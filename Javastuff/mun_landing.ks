clearscreen.
local bounds is SHIP:BOUNDS.
local g is body:mu / body:radius^2.
local maxdecel is (ship:availablethrust / ship:mass) - g.
lock stopdistance to ship:velocity:surface:mag^2 / (2 * maxdecel).
lock impacttime to bounds:bottomaltradar / ship:velocity:surface:mag.
Wait until ship:verticalspeed < -1.
print "Preparing for landing".
rcs on.
brakes on.
gear on.
lock steering to srfretrograde.
until bounds:bottomaltradar < stopdistance {
	clearscreen.
	print impacttime.
	print bounds:bottomaltradar.
	print stopdistance.
	wait 0.
}.
Print "Beginning landing".
Lock throttle to 1.
until ship:verticalspeed > -0.01 {
	set idealthrottle to stopdistance / bounds:bottomaltradar.
	wait 0.
}.
print "Landing complete".
Unlock all.