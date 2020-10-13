@lazyglobal off.
Clearscreen.
Parameter targetAP is BODY:ATM:HEIGHT + 12000.
Parameter hdg is 90.
local tgtd is SHIP:FACING.
Lock STEERING to tgtd.
Wait 1.
Print "Launch Starting.".
RCS on.
If SHIP:AVAILABLETHRUST = 0 { STAGE. }
local cThrust is SHIP:MAXTHRUST.
Lock Throttle to 1.
Wait 0.
When cThrust > SHIP:MAXTHRUST Then { 
	STAGE.
	set cThrust to SHIP:MAXTHRUST.
	Return True.
}
Until SHIP:ORBIT:APOAPSIS >= targetAP {
	local pitchRate is SHIP:ORBIT:APOAPSIS/targetAP.
	set tgtd to HEADING(hdg,90 * (1- MIN(pitchRate^0.5, 1))).
	Wait 0.
}
Unlock Throttle.
Print "Target Apoapsis Achieved, Gliding".
Lock STEERING to SHIP:PROGRADE.
Wait Until ALTITUDE > BODY:ATM:HEIGHT.
local circulization is sqrt(BODY:MU / (ORBIT:APOAPSIS + BODY:RADIUS)).
local currentOrbit is sqrt(BODY:MU * ((2 / (BODY:RADIUS + ORBIT:APOAPSIS)) - (1 / ORBIT:SEMIMAJORAXIS))).
local nodePrograde is circulization - currentOrbit.
Add NODE(ETA:APOAPSIS + TIME:SECONDS, 0, 0 ,nodePrograde).
Runpath("1:/Javastuff/execute_maneuver.ks").
Print "Orbit complete".