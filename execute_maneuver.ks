CLEARSCREEN.
Print "Beginning node execution".
local done is 0.
local eng is 0.
local ndv is 0.
local thrt is 0.
local tgtd is SHIP:FACING.
LOCK Steering to tgtd.
LOCK Throttle to thrt.
local engine_flow is 0. //for multiple engine calculation
local engine_thrust is 0. //for multiple engine calculation
local avg_isp is 0. //for multiple engine calculation
local mnv is nextnode.
List ENGINES in englist. //engines list
For eng in englist {
	If eng:ignition {
		Set engine_flow to engine_flow + (eng:availablethrust/(eng:ISP*Constant:g0)).
		Set engine_thrust to engine_thrust + eng:availablethrust.
	}.
}.
Set avg_isp to engine_thrust/engine_flow.
SET mf to SHIP:MASS/(Constant:e^(mnv:DELTAV:MAG/(avg_isp*Constant:g0))).
SET flow to SHIP:MAXTHRUST/(avg_isp*Constant:g0).
SET md to SHIP:MASS-mf.
SET burnt to md/flow.
Print "Burn time is " + burnt + "seconds".
Wait Until mnv:eta <=(burnt/2 + 60).
Print "60 Seconds to burn".
SET tgtd to mnv:DELTAV.
Wait Until vang(tgtd, SHIP:FACING:VECTOR) < 0.25. 
Print "aligned to node".
Wait Until mnv:ETA <= (burnt/2).
Print "Burning".
SET ndv to mnv:DELTAV.
Until done {
	SET thrt to min(mnv:DELTAV:MAG/(SHIP:MAXTHRUST/SHIP:MASS), 1).
	SET tgtd to mnv:DELTAV.
	If mnv:DELTAV:MAG < 0.1 {
		Print "Burn Finalizing".
		Wait Until vdot(ndv, mnv:DELTAV) < 0.5.
		SET thrt to 0.
		SET done to True.
	}.
	Wait 0.
}.
REMOVE mnv.