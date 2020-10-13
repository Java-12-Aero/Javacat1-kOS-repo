CLEARSCREEN.
Print "Calculating intercept".
local pto is 0. //period of transfer orbit
local trgt is 0. //apoapsis of mun orbit
local dv is 0. //dv to match apoapsis
local done is 0.
local sma is 0. //semimajoraxis
local pd is 0. //calculated period
local tgtda is 0. //change in angle over half period
local tphase is 0. //Desired phase angle for maneuver node.
local deltaphase is 0. //Change in phase angle
local vcrs1 is 0. //cross product between target and ship
local vcrs2 is 0. //cross product between ship and velocity
local norm is 0. //normal direction of target to ship
local cphase is 0. //vector angle for determining current phase angle
local pt is 0. //phase time in seconds ahead of ship
local node_timestamp is 0. //timestamp of node
local mnv is 0. //node holder
local v0 is 0. //current orbit velocity
local v1 is 0. //target orbit velocity
set thrt to 0. //throttle control
set tgtd to SHIP:FACING. //steering control
local engine_flow is 0. //for multiple engine calculation
local engine_thrust is 0. //for multiple engine calculation
local avg_isp is 0. //for multiple engine calculation
LOCK throttle to thrt.
LOCK steering to tgtd.
set sma to (TARGET:ORBIT:APOAPSIS + SHIP:ORBIT:PERIAPSIS)/2 + BODY:RADIUS.
set pd to 2 * Constant:PI * sqrt(((sma^3)/BODY:MU)). //NOTE: Remember to divide by 2!!!!!!
set tgtda to   (360/TARGET:ORBIT:PERIOD) * (pd/2).
set deltaphase to (360/TARGET:ORBIT:PERIOD) - (360/SHIP:ORBIT:PERIOD). //Change in phase angle per second
set tphase to 180 - tgtda.
if tphase < 0 { set tphase to 360 + tphase.}.
set vcrs1 to vcrs(ship:position-body:position, target:position-body:position).
set vcrs2 to vcrs(SHIP:POSITION-body:POSITION,SHIP:VELOCITY:ORBIT).
set cphase to vang(ship:position-body:position, target:position-body:position).
set norm to vdot(vcrs1,vcrs2).
Print "Semimajor Axis of transfer is " + sma.
Print "Transfer orbital period is " + pd.
Print "Target movement during transfer is " + tgtda + " degrees".
Print "Desired phase angle is " + tphase.
Print "Phase angle change is " + deltaphase + " degrees per second".
If norm > 0 {
	Print "Target is in front of vessel".
	Print "Current Phase angle is " + cphase.
	set pt to (tphase-cphase)/deltaphase.
	} else {
	Print "Target is behind vessel".
	set cphase to 360 - cphase.
	Print "Current phase angle is " + cphase.
	set pt to (tphase-cphase)/deltaphase.
}.
if pt < 0 {
	set pt to mod(tphase-cphase-360,360)/deltaphase.
}.
set node_timestamp to pt + TIME:SECONDS.
Print "Node in " + pt + " seconds".
set v0 to sqrt(body:mu/orbit:semimajoraxis).
set v1 to sqrt(body:mu*(2/orbit:semimajoraxis - (1/sma))).
set dv to v1 - v0.
set mnv to NODE(node_timestamp,0,0,dv).
add mnv.
Print "Calculating dv for safe AP".
until nextnode:orbit:nextpatch:periapsis > 10000 {
    set nextnode:prograde to nextnode:prograde - 0.01.
    wait 0.
}.
Print "Delta V for apoapsis change is " + nextnode:prograde + " m/s".
Print "Maneuver Planned".
runoncepath("execute_maneuver.ks").
Print "Transfer to target complete, Manual control".