clearscreen.
local ut is time:seconds.
parameter target_inclination is 45.
local eccentricity is obt:eccentricity.
local ship_orbit is ship:orbit.
local i is ship_orbit:inclination.
local delta_inclination is target_inclination - i.
local rs is positionat(ship,ut)-ship_orbit:body:position.
local vs is velocityat(ship,ut):obt.
local ns is vcrs(vs,rs):normalized.
local axis is vcrs(v(0,1,0),ns):normalized.
local nt is angleaxis(delta_inclination,axis)*ns.
local an_vector is vcrs(ns,nt).
local rel_ang is vang(rs,an_vector).
local sign_test is vdot(vcrs(an_vector,rs),ns).
if sign_test < 0 {
	set rel_ang to 360 - rel_ang.
}.
local an_true_anom is obt:trueanomaly + rel_ang.
local an_eccentric_anom is mod(360+arctan2(sqrt(1-eccentricity^2)*sin(an_true_anom), eccentricity+cos(an_true_anom)),360).
local an_mean_anom is an_eccentric_anom-eccentricity*constant:RadToDeg*sin(an_eccentric_anom).
local base_mean_anom is mod(mod(ut-ship_orbit:epoch, ship:orbit:period)/ship:orbit:period*360+ship_orbit:meananomalyatepoch,360).
local an_timestamp is mod(360+an_mean_anom-base_mean_anom,360)/sqrt(body:mu/ship_orbit:semimajoraxis^3)/constant:RadToDeg + ut.
local dn_true_anom is mod(an_true_anom+180,360).
local dn_eccentric_anom is mod(360+arctan2(sqrt(1-eccentricity^2)*sin(DN_true_anom), eccentricity+cos(DN_true_anom)),360).
local dn_mean_anom is dn_eccentric_anom-eccentricity*constant:RadToDeg*sin(dn_eccentric_anom).
local dn_timestamp is mod(360+dn_mean_anom-base_mean_anom,360)/sqrt(body:mu/ship_orbit:semimajoraxis^3)/constant:RadToDeg + ut.
local an_anom_ap is abs(an_true_anom-180).
local dn_anom_ap is abs(dn_true_anom-180).
set node_timestamp to choose an_timestamp if an_anom_ap < dn_anom_ap else dn_timestamp.
set rs to positionat(ship,node_timestamp)-ship:body:obt:position.
set vs to velocityat(ship,node_timestamp):obt.
set ns to vcrs(vs,rs):normalized.
set axis to vcrs(v(0,1,0),ns):normalized.
set nt to angleaxis(delta_inclination,axis)*ns.
set v_tangential to vcrs(rs,ns):normalized * vs.
set v_radial to rs:normalized * vs.
set dv to v_radial * rs:normalized + v_tangential * vcrs(rs,nt):normalized - vs.
set node_prograde to dv * vs:normalized.
set node_radialout to dv * vxcl(vs,rs):normalized.
set node_normal to dv * ns.
set mnv to NODE(node_timestamp,node_radialout,node_normal,node_prograde).
add mnv.
runpath("execute_maneuver.ks").