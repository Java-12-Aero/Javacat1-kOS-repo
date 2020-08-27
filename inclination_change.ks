CLEARSCREEN.
parameter ship_orbit is ship:orbit.
local eccentricity is ship_orbit:eccentricity.
local t is ship_orbit:epoch.
local b is ship_orbit:body.
local AN_true_anomaly is 360-obt:argumentofperiapsis.
local DN_true_anomaly is mod(AN_true_anomaly+180,360).
local AN_eccentric_anomaly is mod(360+arctan2(sqrt(1-eccentricity^2)*sin(AN_true_anomaly), eccentricity+cos(AN_true_anomaly)),360).
local AN_mean_anomaly is AN_eccentric_anomaly-eccentricity*constant:RadToDeg*sin(AN_eccentric_anomaly).
local AN_true_anomaly_to_AP is abs(AN_true_anomaly - 180).
local DN_true_anomaly_to_AP is abs(DN_true_anomaly - 180).
local node_timestamp is 0.
local AN_eccentric_anomaly is mod(360+arctan2(sqrt(1-eccentricity^2)*sin(AN_true_anomaly), eccentricity+cos(AN_true_anomaly)),360).
local AN_mean_anomaly is AN_eccentric_anomaly-eccentricity*constant:RadToDeg*sin(AN_eccentric_anomaly).
local base_meananomaly is ship_orbit:meananomalyatepoch.
local base_time is ship_orbit:epoch.
local AN_timestamp is mod(360+AN_mean_anomaly-base_meananomaly,360)/sqrt(b:mu/ship_orbit:semimajoraxis^3)/constant:RadToDeg + base_time.
local DN_eccentric_anomaly is mod(360+arctan2(sqrt(1-eccentricity^2)*sin(DN_true_anomaly), eccentricity+cos(DN_true_anomaly)),360).
local DN_mean_anomaly is DN_eccentric_anomaly-eccentricity*constant:RadToDeg*sin(DN_eccentric_anomaly).
local DN_timestamp is mod(360+DN_mean_anomaly-base_meananomaly,360)/sqrt(b:mu/ship_orbit:semimajoraxis^3)/constant:RadToDeg + base_time.
set node_timestamp to choose AN_timestamp if AN_true_anomaly_to_AP < DN_true_anomaly_to_AP else DN_timestamp.
local rs is positionat(ship,node_timestamp)-b:position.
local vs is velocityat(ship,node_timestamp):obt.
local ns is vcrs(vs,rs):normalized.
local v_tangential is vcrs(rs,ns):normalized * vs.
local nt is -body:angularvel:normalized.
local v_tangential is vcrs(rs,ns):normalized * vs.
local v_radial is rs:normalized * vs.
set dv to v_radial * rs:normalized + v_tangential * vcrs(rs,nt):normalized - vs.
SET node_prograde to dv * vs:normalized. 
SET node_radialout to dv * vxcl(vs,rs):normalized. 
SET node_normal to dv * vcrs(vs,rs):normalized. 