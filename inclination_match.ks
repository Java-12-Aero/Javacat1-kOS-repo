CLEARSCREEN.
local time is TIME:SECONDS. //split tick prevention
local trueanomaly is obt:trueanomaly. //split tick prevention
parameter ship_orbit1 is ship:orbit.
local eccentricity is ship_orbit1:eccentricity.
local t1 is ship_orbit1:epoch.
local b1 is ship_orbit1:body.
parameter ship_orbit2 is target:orbit.
local ecc2 is ship_orbit2:eccentricity.
local t2 is ship_orbit2:epoch.
local b2 is ship_orbit2:body.
local rs1 is 0. //ship position vector
local vs1 is 0. //ship velocity vector
local ns1 is 0. //ship normal vector
local rs2 is 0. //target position vector
local vs2 is 0. //target velocity vector
local ns2 is 0. //target normal vector
local an_vector is 0. //ascending node vector
local rel_pos is 0. //relative angle between ship and node
local sign_test is 0. //for signing angle
local an_true_anomaly is 0. //ture anomaly of the ascending node
local an_eccentric_anomaly is 0. //ascending node eccentric anomaly
local an_mean_anomaly is 0. //ascending node mean anomaly
local node_timestamp is 0. //node timestamp add UT to this
local node is 0. //storage for node
set rs1 to positionat(ship,time)-b1:position.
set vs1 to velocityat(ship,time):obt.
set ns1 to vcrs(vs1,rs1):normalized.
set rs2 to positionat(target,time)-b2:position.
set vs2 to velocityat(target,time):obt.
set ns2 to vcrs(vs2,rs2):normalized.
set an_vector to vcrs(ns1,ns2).
set rel_pos to vang(rs1,an_vector).
set sign_test to vdot(vcrs(an_vector,rs1),ns1).
if sign_test < 0 {
	set rel_pos to 360 - rel_pos.
}.
set an_true_anomaly to trueanomaly + rel_pos.
set an_eccentric_anomaly to mod(360+arctan2(sqrt(1-eccentricity^2)*sin(an_true_anomaly), eccentricity+cos(an_true_anomaly)),360).
set an_mean_anomaly to an_eccentric_anomaly-eccentricity*constant:RadToDeg*sin(an_eccentric_anomaly).
local base_meananomaly is mod(mod(time-ship_orbit1:epoch, ship_orbit1:period)/ship_orbit1:period*360+ship_orbit1:meananomalyatepoch,360).
local DN_true_anomaly is mod(AN_true_anomaly+180,360).
local DN_eccentric_anomaly is mod(360+arctan2(sqrt(1-eccentricity^2)*sin(DN_true_anomaly), eccentricity+cos(DN_true_anomaly)),360).
local DN_mean_anomaly is DN_eccentric_anomaly-eccentricity*constant:RadToDeg*sin(DN_eccentric_anomaly).
local AN_timestamp is mod(360+AN_mean_anomaly-base_meananomaly,360)/sqrt(b1:mu/ship_orbit1:semimajoraxis^3)/constant:RadToDeg + time.
local DN_timestamp is mod(360+DN_mean_anomaly-base_meananomaly,360)/sqrt(b1:mu/ship_orbit1:semimajoraxis^3)/constant:RadToDeg + time.
local AN_true_anomaly_to_AP is abs(AN_true_anomaly - 180).
local DN_true_anomaly_to_AP is abs(DN_true_anomaly - 180).
set node_timestamp to choose AN_timestamp if AN_true_anomaly_to_AP < DN_true_anomaly_to_AP else DN_timestamp.
local rs is positionat(ship,node_timestamp)-b1:position.
local vs is velocityat(ship,node_timestamp):obt.
local ns is vcrs(vs,rs):normalized.
local v_tangential is vcrs(rs,ns):normalized * vs.
local vt is velocityat(target,node_timestamp):obt.
local rt is positionat(target,node_timestamp)-b2:position.
local nt is vcrs(vt,rt):normalized.
local v_tangential is vcrs(rs,ns):normalized * vs.
local v_radial is rs:normalized * vs.
set dv to v_radial * rs:normalized + v_tangential * vcrs(rs,nt):normalized - vs.
SET node_prograde to dv * vs:normalized. 
SET node_radialout to dv * vxcl(vs,rs):normalized. 
SET node_normal to dv * vcrs(vs,rs):normalized. 
SET node to NODE(node_timestamp, node_radialout, node_normal, node_prograde).
ADD node.
runpath("execute_maneuver.ks").