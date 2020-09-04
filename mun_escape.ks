CLEARSCREEN.
print "beginning mun escape calculation".
parameter target_pe is 30000.
local reentry_sma is ((target_pe + BODY:BODY:radius) + ((BODY:POSITION - BODY:BODY:POSITION):mag))/2.
local ship_position is (BODY:POSITION - BODY:BODY:POSITION):MAG.
local reentry_ap_vel is sqrt(BODY:BODY:MU * ((2/ship_position) - (1/reentry_sma))).
local v_inf is velocityat(ship:body, time:seconds):orbit:mag - reentry_ap_vel.
local hyperbolic_sma is -body:mu / v_inf^2.
local hyperbolic_pe is ship:altitude + body:radius.
local hyperbolic_pe_vel is sqrt(body:mu * ((2/hyperbolic_pe) - (1/hyperbolic_sma))).
local escape_dv is hyperbolic_pe_vel - ship:velocity:orbit:mag.
print reentry_sma.
print ship_position.
print reentry_ap_vel.
print velocityat(ship:body, time:seconds):orbit:mag.
print v_inf.
print hyperbolic_sma.
print hyperbolic_pe.
print hyperbolic_pe_vel.
print escape_dv.
set mnv to NODE(time:seconds+60,0,0,escape_dv).
add mnv.
set periapsis_test to nextnode:orbit:nextpatch:periapsis.
print "calculating best escape time".
print nextnode:eta.
until nextnode:orbit:nextpatch:periapsis > periapsis_test and nextnode:orbit:nextpatch:periapsis < 10000000 {
	set periapsis_test to nextnode:orbit:nextpatch:periapsis.
	set nextnode:ETA to nextnode:eta + 1.
	wait 0.
}.
Print "calculating optimal DV for target periapsis".
until nextnode:orbit:nextpatch:periapsis >= target_pe {
	set nextnode:prograde to nextnode:prograde - 0.01.
	wait 0.
}.
Print "maneuver calculated".
runpath("execute_maneuver.ks").