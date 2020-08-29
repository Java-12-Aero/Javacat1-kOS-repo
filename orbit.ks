Clearscreen.
//NOTE: Set Target orbit Apoapsis Here
local targetap is 90000.
//NOTE: Set Target Orbit Apoapsis Above
local tinc is 0. //Set target inclination here
local pitchrate is 0. //rate for ship to pitch DOWN into orbit
local tgtd is SHIP:FACING. //flight target direction
local bthrust is 0. //for when boosters/stages empty 
local thrt is 0. //for throttle
local node is 0. //node storage
local pg is 0. //for node math
local burnt is 0. //node burn time
local mf is 0. //final burn mass
local flow is 0. //engine thrust for burn
local md is 0. //mass expelled in burn
local circ is 0. //circularization speed
local curr is 0. //current orbit speed
local ndv is 0. //Initial node Delta V
local done is 0. //for loop
local incd is 0. //inclination change
local norm is 0. //for plane change
local ovel is 0. //orbit velocity
local engine_flow is 0. //for multiple engine calculation
local engine_thrust is 0. //for multiple engine calculation
local avg_isp is 0. //for multiple engine calculation
LOCK STEERING to tgtd.
Wait 1.
Print "Launch Starting.".
RCS ON.
Stage.
SET bthrust to SHIP:MAXTHRUST.
SET thrt to 1.
LOCK THROTTLE to thrt.
Wait 1.
When bthrust > SHIP:MAXTHRUST Then {
	Stage.
	SET bthrust to SHIP:MAXTHRUST.
	Return True.
}.
Until SHIP:ORBIT:APOAPSIS >= targetap {
	Clearscreen.
	SET pitchrate to SHIP:ORBIT:APOAPSIS/targetap.
	SET tgtd to HEADING(90,90 * (1 - MIN(pitchrate^0.5,1))).
	set thrt to 1.
	Print "Pitch is " + (90 * (1 - MIN(pitchrate^0.5,1))).
	Print "Apoapsis is " + SHIP:ORBIT:APOAPSIS.
	WAIT 0.
}.
SET thrt to 0.
Print "Target Apoapsis Achieved.".
Until altitude > 70000 {
	SET tgtd to SHIP:PROGRADE.
	WAIT 0.
}.
SET circ to sqrt(BODY:MU/(ORBIT:APOAPSIS+BODY:RADIUS)).
SET curr to sqrt(BODY:MU*((2/(BODY:RADIUS+ORBIT:APOAPSIS))-(1/ORBIT:SEMIMAJORAXIS))).
SET pg to circ-curr.
SET node to NODE(ETA:APOAPSIS+TIME:SECONDS,0,0,pg).
ADD node.
List ENGINES in englist. //engines list
For eng in englist {
	If eng:ignition {
		Set engine_flow to engine_flow + (eng:availablethrust/(eng:ISP*Constant:g0)).
		Set engine_thrust to engine_thrust + eng:availablethrust.
	}.
}.
Set avg_isp to engine_thrust/engine_flow.
SET mf to SHIP:MASS/(Constant:e^(pg/(avg_isp*Constant:g0))).
SET flow to SHIP:MAXTHRUST/(avg_isp*Constant:g0).
SET md to SHIP:MASS-mf.
SET burnt to md/flow.
Print "Burn time is " + burnt + "seconds".
Wait Until node:eta <=(burnt/2 + 60).
Print "60 Seconds to burn".
SET tgtd to NODE:DELTAV.
Wait Until vang(tgtd, SHIP:FACING:VECTOR) < 0.25. 
Print "aligned to node".
Wait Until NODE:ETA <= (burnt/2).
Print "Burning".
SET ndv to NODE:DELTAV.
Until done {
	SET thrt to min(NODE:DELTAV:MAG/(SHIP:MAXTHRUST/SHIP:MASS), 1).
	SET tgtd to NODE:DELTAV.
	If NODE:DELTAV:MAG < 0.1 {
		Print "Burn Finalizing".
		Wait Until vdot(ndv, NODE:DELTAV) < 0.5.
		SET thrt to 0.
		SET done to True.
	}.
	Wait 0.
}.
REMOVE node.
CLEARSCREEN.
Print "Orbit complete, running inclination correction".
Unlock ALL.
RCS OFF.
Run once inclination_change.ks.