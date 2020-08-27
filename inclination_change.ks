CLEARSCREEN.
parameter ship_orbit is ship:orbit.
local eccentricity is ship_orbit:eccentricity.
local t is ship_orbit:epoch.
local b is ship_orbit:body.
local epoch_pos is (positionat(ship,t)-b:position):normalized.
local base_time is ship_orbit:epoch.
local function newton {
    parameter f, fp, x0.
    local x is x0.
    local err is f(x).
    local steps is 0.
    until abs(err)< 1e-12 or steps > 20 {
        local deriv is fp(x).
        local step is err/deriv.
        // only allow a maximum change of half a radian at a time to prevent small derivatives from throwing off the
        // stability of the algorithm.
        if abs(step) > 0.5 set step to 0.5 * sign(step).
        set x to x - step.
        set steps to steps+1.
        set err to f(x).
    }
    return x.
}
local mean_anomaly_rad is ship_orbit:meananomalyatepoch * constant:DegToRad.
local epoch_eccentric_anomaly is newton(
    {parameter e. return e-eccentricity*sin(e*constant:RadToDeg)-mean_anomaly_rad.},
    {parameter e. return 1-eccentricity*cos(e*constant:RadToDeg).},
    mean_anomaly_rad)*constant:RadToDeg.
local epoch_true_anomaly is mod(360+arctan2(sqrt(1-eccentricity^2)*sin(epoch_eccentric_anomaly), cos(epoch_eccentric_anomaly)-eccentricity),360).
local angle_to_an is vang(mod(360+AN_mean_anomaly-base_meananomaly,360)/sqrt(b:mu/ship_orbit:semimajoraxis^3)/constant:RadToDeg + base_time,epoch_pos)*sign(vcrs(mod(360+AN_mean_anomaly-base_meananomaly,360)/sqrt(b:mu/ship_orbit:semimajoraxis^3)/constant:RadToDeg + base_time,epoch_pos)*nrm_ship).
local AN_true_anomaly is mod(360+epoch_true_anomaly+angle_to_an,360).
local AN_eccentric_anomaly is mod(360+arctan2(sqrt(1-eccentricity^2)*sin(AN_true_anomaly), eccentricity+cos(AN_true_anomaly)),360).
local AN_mean_anomaly is AN_eccentric_anomaly-eccentricity*constant:RadToDeg*sin(AN_eccentric_anomaly).
local AN_true_anomaly_to_AP is abs(AN_true_anomaly - 180).
local DN_true_anomaly_to_AP is abs(DN_true_anomaly - 180).
local node_timestamp is 0.
set node_timestamp to choose AN_timestamp if AN_true_anomaly_to_AP < DN_true_anomaly_to_AP else DN_timestamp.
local rs is positionat(ship,node_timestamp)-b:position.
local ns is vcrs(vs,rs):normalized.
local v_tangential is vcrs(rs,ns):normalized * vs.
local nt is -body:angularvel:normalized.
set dv to v_radial * rs:normalized + v_tangential * vcrs(rs,nt):normalized - vs.
SET node_prograde to dv * vs:normalized. 
SET node_radialout to dv * vxcl(vs,rs):normalized. 
SET node_normal to dv * vcrs(vs,rs):normalized. 