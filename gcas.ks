RUNONCEPATH("Library/lib_navball.ks").
CLEARSCREEN.
PRINT "FCAS Online".
local pitch is 0.
local hdg is 0.
local yaw is 0.
local lnd is 1.
local fcas is 0.
WHEN fcas = 1 THEN {
	if ALT:RADAR <=300 {
		PRINT "ACTIVE.".
		LOCK STEERING TO HEADING(hdg, 45, 0).
	} else {
		UNLOCK STEERING.
		PRINT "Safe".
		SET fcas to 0.
	}.
	Return true.
}.
WAIT UNTIL SHIP:STATUS = "FLYING" AND ALT:RADAR >= 500.
PRINT "System Armed.".
ON GEAR {
	IF GEAR {
		PRINT "FCAS Disarmed.".
	} else {
		IF NOT GEAR {
		PRINT "FCAS Rearmed.".
		}.
	}.
	Return True.
}.
UNTIL SHIP:STATUS = "LANDED" {
	IF fcas = 0 {
		SET hdg TO compass_for(SHIP).
		SET lnd to 0.
	}.
	if ALT:RADAR <= 300 AND fcas = 0 AND NOT GEAR {
		PRINT "PULL UP.".
		set fcas to 1.
	}.
	wait 0.
}.