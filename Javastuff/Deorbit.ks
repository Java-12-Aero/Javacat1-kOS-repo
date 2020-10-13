CLEARSCREEN.
Print "Beginning deorbiting".
local target_periapsis is 30000. //Note: set to target periapsis in altitude at beginning of reentry
local corbit is 0. //current orbital velocity
local torbit is 0. //target velocity
local mnv is 0. //node holder
local node_timestamp is 0. //node timestamp in mission time
local dv is 0. //delta v for deorbit
if ETA:Apoapsis < ETA:Periapsis or orbit:periapsis > 70000 {
	set corbit to sqrt(BODY:MU*((2/(BODY:RADIUS+ORBIT:APOAPSIS))-(1/ORBIT:SEMIMAJORAXIS))).
	Print "Current orbital velocity is " + corbit + " m/s".
	set torbit to sqrt(BODY:MU*((2 / (ORBIT:APOAPSIS + BODY:RADIUS)) - (1 / ((target_periapsis + ORBIT:APOAPSIS) / 2 + BODY:RADIUS)))).
	set dv to torbit - corbit.
	set node_timestamp to ETA:APOAPSIS.
	set mnv to NODE(node_timestamp+TIME:SECONDS,0,0,dv).
	add mnv.
	runpath("execute_maneuver.ks").
}.
Wait until altitude < 70000.
Lock steering to retrograde.
Lock throttle to 1.
Until SHIP:STATUS = "Landed" or STAGE:NUMBER = 0 {
	if ship:maxthrust = 0 {
		Stage.
	}.
	wait 0.
}.
Wait until SHIP:STATUS = "Landed".
Unlock all.