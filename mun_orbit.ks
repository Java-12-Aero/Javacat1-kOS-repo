CLEARSCREEN.
//NOTE: set target orbit apoapsis below
parameter target_apoapsis is 10000.
//NOTE: Set target orbit apoapsis above
local done is 0.
Print "Beginning calculation to desired orbit".
print "Periapsis in " + round(ETA:PERIAPSIS) + " seconds".
Print "Desired apoapsis is " + target_apoapsis.
print "Velocity at periapsis is " + velocityat(ship, ETA:PERIAPSIS+TIME:SECONDS):obt:mag + " m/s".
set current_velocity to velocityat(ship, ETA:PERIAPSIS+TIME:SECONDS):obt:mag.
set target_velocity to sqrt(BODY:MU * (2/(ship:orbit:periapsis + body:radius) - (1/((ship:orbit:periapsis + target_apoapsis)/2 + body:radius)))).
set delta_v to current_velocity - target_velocity.
print "Delta V needed to close orbit is " + delta_v + " m/s".
set mnv to NODE(ETA:PERIAPSIS + TIME:SECONDS,0,0,-1 * delta_v).
Print "Creating node".
add mnv.
runpath("execute_maneuver.ks").