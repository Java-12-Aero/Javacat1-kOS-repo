clearscreen.
local done is 0.
local rcsdock is ship:control.
set rcsdock:fore to 0.
set rcsdock:starboard to 0.
set rcsdock:top to 0.
List dockingports in ports.
set ctrlport to ports[0].
Print "Beginning docking procedure".
lock steering to target_port.
Print "Aligning".
until done {
	set target_port to lookdirup(-target:portfacing:vector, target:portfacing:topvector).
	set relative_velocity to (ship:velocity:orbit - target:ship:velocity:orbit).
	set relative_position to target:position - ctrlport:position.
	set relative_pos_star to vdot(ship:facing:starvector, relative_position).
	set relative_velocity_star to vdot(ship:facing:starvector, relative_velocity).
	set relvel to relative_velocity:mag.
	set desired_velocity_star to min(2,max(-2,relative_pos_star)).
	set vdiff_star to (desired_velocity_star - relative_velocity_star).
	set rcsdock:starboard to vdiff_star.
	set relative_pos_top to vdot(ship:facing:topvector, relative_position).
	set relative_velocity_top to vdot(ship:facing:topvector, relative_velocity).
	set desired_velocity_top to min(2,max(-2,relative_pos_top)).
	set vdiff_top to (desired_velocity_top - relative_velocity_top).
	set rcsdock:top to vdiff_top.
	if abs(relative_pos_star) <= 0.1 and abs(relative_pos_top) <= 0.1 {
		set relative_pos_fore to vdot(ship:facing:forevector, relative_position).
		set relative_velocity_fore to vdot(ship:facing:forevector, relative_velocity).
		set desired_velocity_fore to min(2,max(-2,relative_pos_fore)).
		set vdiff_fore to (desired_velocity_fore - relative_velocity_fore).
		set rcsdock:fore to vdiff_fore.
		if abs(relative_pos_fore) < 1 {
			set rcsdock:starboard to 0.
			set rcsdock:top to 0.
			set rcsdock:fore to 0.
			set done to "true".
		}.
	} else {
		set relative_velocity_fore to vdot(ship:facing:forevector, relative_velocity).
		set vdiff_fore to -1 * relative_velocity_fore.
		set rcsdock:fore to vdiff_fore.
	}.
}.