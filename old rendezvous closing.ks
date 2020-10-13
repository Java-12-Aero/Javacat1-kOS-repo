//closing distance suggestion
until separation:MAG < 200 {
	set ship_face to ship:velocity:orbit - target:velocity:orbit.
	set separation to (target:position - ship:position).
	if VDOT(separation:normalized, ship_face) < 0 {
		until VDOT(separation:normalized, ship_face) > 0 and ship_face:MAG > 10 {
			set steer to target:velocity:orbit - ship:velocity:orbit.
			wait until vang(steer, ship:facing:vector) < 0.5.
			set throtle to 1.
			set ship_face to ship:velocity:orbit - target:velocity:orbit.
			set separation to (target:position - ship:position).
			wait 0.
		}.
	} else {
		until VDOT(separation:normalized, ship_face) < 0 and ship_face:mag > 10 {
			set steer to ship:velocity:orbit - target:velocity:orbit.
			wait until vang(steer, ship:facing:vector) < 0.5.
			set throtle to 1.
			set ship_face to ship:velocity:orbit - target:velocity:orbit.
			set separation to target:position - ship:position.
			wait 0.
		}.
	}.
	wait 0.
	set throtle to 0.
}.

//old script
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
Print "Calculating closest approach".
set search_duration to orbit:period/5.
set time1 to time:seconds + orbit:period/2 - search_duration/2.
set time2 to time1 + search_duration.
set time_diff to time2 - time1.
set time_mid to time_diff/2 + time1.
until time_diff <= 1 {
	set time_mid to time_diff/2 + time1.
	set pos_mid to positionat(target, time_mid) - positionat(ship, time_mid).
	set velocity_mid to velocityat(ship, time_mid):obt - velocityat(target, time_mid):obt.
	set direction_mid to VDOT(pos_mid:normalized, velocity_mid).
	if direction_mid > 0 {
		set time1 to time_mid.
	} else {
		set time2 to time_mid.
	}.
	set time_diff to time2-time1.
	Wait 0.
}.
Print "search complete".
set time_mid to time_diff/2 + time1.
print round(time_mid - time:seconds) + " seconds to approach".
print round((positionat(target, time_mid) - positionat(ship, time_mid)):MAG) + " meters separation at approach".
print "reducing relative velocity".
local ctime is TIME:SECONDS.
until ctime >= time_mid {
	clearscreen.
	set ctime to time:seconds.
	print ctime.
	print time_mid.
	wait 0.
}.
print "starting correction".
set ship_face to ship:velocity:orbit - target:velocity:orbit.
local separation is (target:position - ship:position).
local steer is ship_face.
lock steering to steer.
lock throttle to throtle.
until separation:MAG < 200 {
	set ship_face to ship:velocity:orbit - target:velocity:orbit.
	set separation to (target:position - ship:position).
	if VDOT(separation:normalized, ship_face) < 0 {
		until VDOT(separation:normalized, ship_face) > 0 and ship_face > 10 {
			set steer to target:velocity:orbit - ship:velocity:orbit.
			set throtle to 0.5.
			set ship_face to ship:velocity:orbit - target:velocity:orbit.
			set separation to (target:position - ship:position).
			wait 0.
		}.
	} else {
		until VDOT(separation:normalized, ship_face) < 0 and ship_face > 10 {
			set steer to ship:velocity:orbit - target:velocity:orbit.
			set throtle to 0.5.
			set ship_face to ship:velocity:orbit - target:velocity:orbit.
			set separation to target:position - ship:position.
			wait 0.
		}.
	}.
	wait 0.
}.
Print "Done".