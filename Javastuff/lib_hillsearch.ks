//This is the hillclimber function for the lambert solver
//defaults to finding within 1 revolution
//Praise the omnissiah etc etc
//note:set variables to functions to use lexicons
@lazyglobal off.
//Hohmann approximation to start with lambert solver - gives needed info
Function hohmann {
	local sma is (TARGET:ORBIT:APOAPSIS + SHIP:ORBIT:PERIAPSIS)/2 + BODY:RADIUS.
	local pd is 2 * Constant:PI * sqrt(((sma^3)/BODY:MU)).
	local target_deltangle is (360/TARGET:ORBIT:PERIOD) * (pd/2).
	local deltaphase is (360/TARGET:ORBIT:PERIOD) - (360/SHIP:ORBIT:PERIOD).
	local target_phase is 180- target_deltangle.
	local vcrs1 is vcrs(SHIP:POSITION - BODY:POSITION, TARGET:POSITION-BODY:POSITION).
	local vcrs2 is vcrs(SHIP:POSITION - BODY:POSITION, SHIP:VELOCITY:ORBIT).
	local current_phase is vang(SHIP:POSITION - BODY:POSITION, TARGET:POSITION - BODY:POSITION).
	local norm is vdot(vcrs1,vcrs2).
	If norm < 0 {
		local current_phase is 360 - current_phase.
	}.
	local phase_time is (target_phase-current_phase)/deltaphase.
	if phase_time < 0 {
		local phase_time is mod(360+target_phase-current_phase,360)/deltaphase.
	}.
	local node_timestamp is pt + TIME:SECONDS.
	local Vi is sqrt(body:MU / ORBIT:SEMIMAJORAXIS).
	local Vf is sqrt(BODY:MU * (2 / ORBIT:SEMIMAJORAXIS - (1 / sma))).
	local dv is Vi-Vf.
	local mnv is NODE(node_timestamp, 0, 0, dv).
	local tof is pd/2.
	local timestamp is (pd/2)+node_timestamp.
	Return lexicon("pd", pd, "timestamp", timestamp, "tof", tof, "dv", dv).
}.
//eccentricity vector calculation
Function vector_e {
	Parameter subject is ship.
	Parameter timestamp.
	local vV is velocityat(subject,timestamp).
	local rV is positionat(subject,timestamp).
	local eV is (vcrs(vV,vcrs(rV,vV))/Body:MU) - (rV/rV:Normalized).
	Return lexicon("vV",vV,"rV",rV,"eV",eV).
}.
//True Anomaly Calculation
Function trueanom {
	Parameter subject is ship.
	Parameter timestamp.
	Parameter eV.
	local rV is positionat(subject,timestamp).
	local vV is velocityat(subject,timestamp).
	local true_anomaly is arccos(vdot(eV,rV)/(eV:normalized * rV:normalized)).
	Return lexicon("vV", vV, "rV", rV, "true_anomaly", true_anomaly).
}.
//Phase angle calculation at given time
Function phase_angle {
	Parameter fix is true.
	Parameter timestamp.
	local phaseang is vang(positionat(ship,timestamp) - positionat(body,timestamp), positionat(target,timestamp) - positionat(body,timestamp).
	local vcrs1 is vcrs(positionat(ship,timestamp) - positionat(body,timestamp), positionat(target,timestamp) - positionat(body,timestamp)).
	local vcrs2 is vcrs(positionat(ship,timestamp) - positionat(body,timestamp), velocityat(ship,timestamp):orbit).
	local norm is vdot(vcrs1, vcrs2)
	if norm < 0 and fix {
		local phaseang is 360 - phaseang.
	}.
	Return lexicon("phaseang", phaseang, "norm", norm).
}.
//Lambert Hillclimber
Function lambert {
	Parameter tof.
	Parameter vV.
	Parameter rV.
	Parameter phaseang.
	Parameter timestamp.
	Parameter norm.
	local time_up is true.
	local nodetime is nextnode:eta + time:seconds.
	if not ship:orbit:hasnextpatch {
		until ship:orbit:hasnextpatch or nextnode:orbit:hasnextpatch {
			local closest_approach is (positionat(target,timestamp) - positionat(ship,timestamp)):mag.
			if norm < 0 {
				if time_up {
					local future_sep is (positionat(target,timestamp + 120) - positionat(ship,timestamp + 120)):mag.
					if future_sep < closest_approach { 
						local timestamp is timestamp + 120.
						set nodetime to nodetime + 120.
						set closest_approach to (positionat(target,timestamp) - positionat(ship,timestamp)):mag.
					} else { local time_up is false }.
				} else { 
					set nextnode:prograde to nextnode:prograde + 10.
					local tof is nextnode:orbit:period/2.
					local timestamp is nodetime + tof.
					local future_sep is (positionat(target, timestamp) - positionat(ship, timestamp)):mag.
					if future_sep > closest_approach { 
					set nextnode:prograde to nextnode:prograde - 10.
					}.
				}.
			} else {
				if time_up {
					local future_sep is (positionat(target,timestamp - 120) - positionat(ship,timestamp - 120)):mag.
					if future_sep < closest_approach { 
						local timestamp is timestamp - 120.
						set nodetime to nodetime - 120.
						set closest_approach to (positionat(target,timestamp) - positionat(ship,timestamp)):mag.
					} else { local time_up is false }.
				} else { 
					set nextnode:prograde to nextnode:prograde - 10.
					local tof is nextnode:orbit:period/2.
					local timestamp is nodetime + tof.
					local future_sep is (positionat(target, timestamp) - positionat(ship, timestamp)):mag.
					if future_sep > closest_approach { 
					set nextnode:prograde to nextnode:prograde + 10.
					} else { set closest_approach to (positionat(target, timestamp) - positionat(ship, timestamp)):mag. }.
				}.
			}.
		}.
		set nextnode:eta to nodetime - time:seconds.
	}.
}.	