clearscreen.
local tperiapsis is 10.
Print "Beginning calculation to impact".
local current_velocity is ship:velocity:orbit:mag.
local target_velocity is sqrt(body:mu * ((2/(altitude + body:radius)) - (1/((tperiapsis+altitude)/2 + body:radius)))).
local dv is target_velocity - current_velocity.
Print "dv calculated, creating node".
set mnv to NODE(time:seconds+65,0,0,dv).
add mnv.
runpath("execute_maneuver.ks").
runpath("mun_landing.ks").