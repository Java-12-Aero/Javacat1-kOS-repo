@lazyglobal OFF.
local engine_flow is 0.
local engine_thrust is 0.
local thrust_control is 0.
parameter target_twr is 1.2.
parameter target_alt is 500.
local done is False.
print "Skycrane online, setting up.".
print "Activating first stage, calculating TWR, ISP, and Flight Time.".
Stage.
print "staged successfully, taking control of steering.".
wait 3.
lock steering to up.
local englist is 0.
List ENGINES in englist.
for eng in englist {
	if eng:ignition {
		Set engine_flow to engine_flow + (eng:availablethrust/(eng:isp*Constant:g0)).
		Set engine_thrust to engine_thrust + eng:availablethrust.
	}.
}.
Local avg_isp is engine_thrust/engine_flow.
Local weight is ship:mass * (body:mu / (altitude + body:radius)^2).
Local twr is engine_thrust/weight.
Local flight_time is (ship:mass - ship:drymass)/engine_flow.
Local twr_max is engine_thrust/(ship:drymass * (body:mu / (altitude + body:radius)^2)).
print "Current TWR is " + round(twr,2) + ". Maximum TWR is " + round(twr_max,2) + ". ISP is " + round(avg_isp,2) + ". Flight time at full throttle is " + flight_time + ".".
if twr <= 1 { print "TWR of " + round(twr,2) + " is insufficient for payload, mass must be ejected.". }.
if twr < target_twr { print "TWR of " + round(twr,2) + " is below target TWR of " + target_twr + ".".}.
if twr_max < target_twr {print "Maximum possible TWR is below target TWR of " + target_twr + ".". }.
if twr_max <= 1 { print "Maximum TWR of " + twr_max + " is insufficient for payload, cannot continue.". }.
print "Calculating control parameters and limits.".
local max_pitch is arcsin(target_twr/twr).
local min_throttle is 1/twr.
local climb_throttle is target_twr/twr.
print "Maximum pitch is " + round(max_pitch,2) + " degrees. Minimum hover throttle is " + round(min_throttle * 100,2) + "%. Minimum climb throttle is " + round(climb_throttle * 100,2) + "%.".
lock Throttle to thrust_control.
until alt:radar >= target_alt {
	set min_throttle to 1/(ship:maxthrust/(ship:mass * (body:mu / (altitude + body:radius)^2))).
	set climb_throttle to target_twr/(ship:maxthrust/(ship:mass * (body:mu / (altitude + body:radius)^2))).
	set thrust_control to min_throttle + min(((climb_throttle - min_throttle) / (alt:radar/target_alt)),climb_throttle - min_throttle).
	wait 0.
	clearscreen.
	print "climbing.".
}.
lock throttle to 1/(ship:maxthrust/(ship:mass * (body:mu / (altitude + body:radius)^2))).
until done { 
	clearscreen.
	print (ship:maxthrust/(ship:mass * (body:mu / (altitude + body:radius)^2))). 
	print throttle * (ship:maxthrust/(ship:mass * (body:mu / (altitude + body:radius)^2))).
	print groundspeed.
	print verticalspeed.
	wait 0.
	}.