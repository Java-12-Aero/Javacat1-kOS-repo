clearscreen.
print "calculating closest intercept within orbital period".
local corbit is 0.
local torbit is 0.
local mnv is 0.
local dv is 0.
local tgt is target:position.
local relvel is (ship:velocity:orbit - target:velocity:orbit):mag.
local intercept_separation is (target:position - ship:position):mag.
local rcsdock is ship:control.
set rcsdock:fore to 0.
set tpos to target:position - ship:position.
set tretro to target:velocity:orbit - ship:velocity:orbit.
set tprograde to ship:velocity:orbit - target:velocity:orbit.
print "Current separation is " + round(tpos:mag) + " meters".
function approach_search { 
	set intercept_separation to (target:position - ship:position):mag.
	parameter lower_time is 10.
	parameter upper_time is 2.
	set lowerbound to time:seconds + lower_time.
	set upperbound to time:seconds + orbit:period/upper_time.
	set time_difference to upperbound - lowerbound.
	set time_midpoint to time_difference/2 + lowerbound.
	until time_difference <= 1 {
		set time_midpoint to time_difference/2 + lowerbound.
		set midpoint_position to positionat(target, time_midpoint) - positionat(ship, time_midpoint).
		set midpoint_velocity to velocityat(ship, time_midpoint):obt - velocityat(target, time_midpoint):obt.
		set midpoint_direction to VDOT(midpoint_position:normalized, midpoint_velocity).
		set time_difference to upperbound - lowerbound.
		set intercept_separation to midpoint_position:mag.
		if midpoint_direction > 0 {
			set lowerbound to time_midpoint.
		} else {
			set upperbound to time_midpoint.
		}.
	}.
	return intercept_separation.
}.
approach_search().
print "search complete".
print round(time_midpoint - time:seconds) + " seconds to approach".
print round(midpoint_position:mag) + " meters separation at approach".
local ctime is time:seconds.
local steer is target:velocity:orbit - ship:velocity:orbit.
local throt is 0.
local separation is target:position - ship:position.
lock steering to steer.
lock throttle to throt.
until ctime >= time_midpoint {
	clearscreen.
	set ctime to time:seconds.
	print round(time_midpoint - ctime,1) + " seconds to approach".
	set steer to target:velocity:orbit - ship:velocity:orbit.
	wait 0.
}.
print "closing distance".
until abs(relvel) <= 1 {
	approach_search().
	set separation to target:position - ship:position.
	set tretro to target:velocity:orbit - ship:velocity:orbit.
	set tprograde to ship:velocity:orbit - target:velocity:orbit.
	set steer to tretro.
	set relvel to (ship:velocity:orbit - target:velocity:orbit):mag.
	if abs(VDOT(separation:normalized, tretro)) > 0 and abs(vang(ship:facing:vector, tretro)) < 5 {
		set tretro to target:velocity:orbit - ship:velocity:orbit.
		set throt to 1.
		set separation to target:position - ship:position.
	} else {
		set throt to 0.
	}.
	wait 0.
}.
print "closed, flying in to intercept".
set throt to 0.
lock steering to tgt.
local rcsdock is ship:control.
until intercept_separation <= 500 {
	approach_search().
	set tgt to target:position.
	set separation to target:position - ship:position.
	set relvel to (ship:velocity:orbit - target:velocity:orbit):mag.
	if abs(relvel) < 5 or abs(vdot(separation:normalized,tretro)) > 0 {
		set rcsdock:fore to 1.
	} else { 
		set rcsdock:fore to 0.
	}.
	wait 0.
}.
print "beginning final approach".
until separation:mag <= 100 {
	set tgt to target:position.
	set separation to target:position - ship:position.
	set relvel to (ship:velocity:orbit - target:velocity:orbit):mag.
	set tretro to target:velocity:orbit - ship:velocity:orbit.
	set tprograde to ship:velocity:orbit - target:velocity:orbit.
	if abs(relvel) < 5 or abs(vdot(separation:normalized,tretro)) > -5 {
		set rcsdock:fore to 1.
	} else {
		set rcsdock:fore to 0.
	}.
}.
set rcsdock:fore to 0.