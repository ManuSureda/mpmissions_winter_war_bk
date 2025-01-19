// SAC_ARTY\fn_monitorKeyPress.sqf
while {true} do {
    if (inputAction "User7" > 0) then {
        if ((player getVariable ["SAC_RO", false]) || (getPlayerUID player in SAC_FACR_PUIDs)) then {
            [] call openArtilleryRequestDialog;
            uiSleep 1;  // Evitar múltiples aperturas
        };
    };
    uiSleep 0.1;  // Pausa entre chequeos
};