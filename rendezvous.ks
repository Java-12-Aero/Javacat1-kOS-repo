CLEARSCREEN.
Print "Matching orbit".
local current_orbit is 0. //current orbital velocity
local target_orbit is 0. //target orbital velocity
local mnv is 0. //maneuver node
local dv is 0. //delta v for the maneuver
local ship_face is 0. //for steering
Print "target Periapsis is " + TARGET:ORBIT:PERIAPSIS.
Print "target Apoapsis is " + TARGET:ORBIT:Apoapsis.
set tpos to target:position - ship:position.
set tvel to ship:velocity:orbit - target:velocity:orbit.
set curr_sep to tpos:MAG.
Print "Current separation is " + round(curr_sep) + " Meters".
print "starting correction".
set ship_face to ship:velocity:orbit - target:velocity:orbit.
local separation is (target:position - ship:position).
local steer is ship_face.
lock steering to steer.
lock throttle to throtle.
LOCAL tarSpeed TO 10.
LOCK tarVel TO TARGET:POSITION:NORMALIZED * tarSpeed.
LOCK relvel TO SHIP:VELOCITY:ORBIT - TARGET:VELOCITY:ORBIT.
LOCK STEERING TO tarVel - relvel.

WAIT UNTIL VANG(STEERING,SHIP:FACING:VECTOR) < 1.

LOCK THROTTLE TO (STEERING:MAG / (SHIP:AVAILABLETHRUST / SHIP:MASS))/2.
WAIT UNTIL (STEERING:MAG < 0.01) OR (VANG(STEERING,SHIP:FACING:VECTOR) > 5).
LOCK THROTTLE TO 0.
Print "Done".