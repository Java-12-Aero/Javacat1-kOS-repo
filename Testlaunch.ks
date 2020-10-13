//Start of Script
CLEARSCREEN.
PRINT "INTIALIZED LAUNCH".
SET VESSEL to SHIP.
local ttwr is 1.5.
STAGE.
WAIT 2.
UNTIL orbit:APOAPSIS > 70000 {
	local m is VESSEL:MASS.
	local x is altitude.
	local g is body:mu / (altitude + body:radius)^2. //Gravitational acceleration
	local thrust is VESSEL:MAXTHRUST.
	local twr is VESSEL:MAXTHRUST / (g * VESSEL:MASS).
	local throt is ttwr / twr.
	local hdg is 90 + (-2.45E-03 * x) + (1.79E-08 * x ^ 2) + (-1.81E-14 * x ^ 3).
	LOCK THROTTLE to throt.
	LOCK STEERING to HEADING(90,hdg).
	WAIT 0.001.
	PRINT "Throttle is " + throt.
PRINT "Target is " + ttwr.
PRINT "Thrust is " + thrust.
PRINT "MASS is " + m.
PRINT "G is " + g.
PRINT "TWR is " + twr.
}

WAIT UNTIL Orbit:APOAPSIS > 70000.
PRINT "Orbit AP reached".