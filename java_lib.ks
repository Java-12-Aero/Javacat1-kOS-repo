//overall library for random stuff I need
@lazyGlobal off.
//Maneuver execution Function
function maneuver {
    Print "Beginning node execution".
    local done is 0.
    local eng is 0.
    local ndv is 0.
    local thrt is 0.
    local tgtd is SHIP:FACING.
    LOCK Steering to tgtd.
    LOCK Throttle to thrt.
    local engine_flow is 0. //for multiple engine calculation
    local engine_thrust is 0. //for multiple engine calculation
    local mnv is nextnode.
    List ENGINES in englist. //engines list
    For eng in englist {
        If eng:ignition {
            local engine_flow is engine_flow + (eng:availablethrust/(eng:ISP*Constant:g0)).
            local engine_thrust is engine_thrust + eng:availablethrust.
        }.
    }.
    Set avg_isp is engine_thrust/engine_flow.
    print avg_isp.
    print mnv:deltav:mag.
    local mf is SHIP:MASS/(Constant:e^(mnv:DELTAV:MAG/(avg_isp*Constant:g0))).
    local flow is SHIP:MAXTHRUST/(avg_isp*Constant:g0).
    local md is SHIP:MASS-mf.
    local burnt is md/flow.
    Print "Burn time is " + burnt + " seconds".
    Print "Delta V is " + mnv:DELTAV:MAG + " m/s".
    local tgtd is mnv:DELTAV.
    Wait Until mnv:eta <=(burnt/2 + 60).
    Print "60 Seconds to burn".
    Wait Until vang(tgtd, SHIP:FACING:VECTOR) < 0.25. 
    Print "aligned to node".
    Wait Until mnv:ETA <= (burnt/2).
    Print "Burning".
    local ndv is mnv:DELTAV.
    Until done {
        local thrt is min(mnv:DELTAV:MAG/(SHIP:MAXTHRUST/SHIP:MASS), 1).
        local tgtd is mnv:DELTAV.
        If mnv:DELTAV:MAG < 0.1 {
            Print "Burn Finalizing".
            Wait Until vdot(ndv, mnv:DELTAV) < 0.5.
            local thrt is 0.
            local done is True.
        }.
        Wait 0.
    }.
    Print "Burn Complete".
    UNLOCK ALL.
    REMOVE mnv.
}