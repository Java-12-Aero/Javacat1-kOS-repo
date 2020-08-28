CLEARSCREEN.
PRINT "INTIALIZED LAUNCH".
SET VESSEL to SHIP.
local ttwr is 1.5.
local throt is 0.
local pitch is 0.
STAGE.
WAIT 2.
LOCK THROTTLE to throt.
LOCK STEERING to HEADING(90,pitch).
UNTIL orbit:APOAPSIS > 70000 {
	local x is altitude.
	local g is body:mu / (altitude + body:radius)^2.
	local thrust is VESSEL:AVAILABLETHRUST.
	local twr is VESSEL:AVAILABLETHRUST / (g * VESSEL:MASS).
	set throt to ttwr / twr.
	set pitch to 90 + (-2.45E-03 * x) + (1.79E-08 * x ^ 2) + (-1.81E-14 * x ^ 3).
}
WAIT UNTIL Orbit:APOAPSIS > 70000.
set throt TO 0.
PRINT "Orbit AP reached".
LOCK STEERING TO PROGRADE.
UNTIL Orbit:APOAPSIS > 70000 AND Orbit:periapsis > 70000 {
IF altitude >= (Orbit:apoapsis - 100) AND Orbit:periapsis < 70000 {
	SET throt TO 0.5.
} ELSE {
	SET throt to 0.
}
}
PRINT "Stable orbit reached.".
