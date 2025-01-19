if (isNull player) exitWith {};

SAC_TEL_teleport = {

	private _done = false;

	//["_sameSide", "_allPlayers", "_onlyConscious", "_sameGroupNPCs", "_includeMyGroup", "_includeSelected", "_includePointed"];
	private _unit = [false, true, true, false, false, false, false] call SAC_fnc_selectUnit;

	if (SAC_user_input == "") exitWith {};

	if (isNull _unit) exitWith {hint (parseText "<t color='#00FFFF' size='1.2'><br/>No se encontro la unidad, intenta de nuevo.<br/><br/></t>")};

	if (!alive _unit) exitWith {hint (parseText "<t color='#00FFFF' size='1.2'><br/>La unidad ha muerto, intenta de nuevo.<br/><br/></t>")};

	if (isNull objectParent _unit) then {
	
		player setPosATL (getPosATL _unit);
		
		_done = true;
	
	} else {
	
		//la unidad está en un vehículo
		
		if (!isNull objectParent player) then {
		
			moveOut player;
			waitUntil {isNull objectParent player};
			
		};
		
		_done = [player, vehicle _unit, ["Cargo", "personTurret", "commonTurret", "Commander", "Gunner", "Driver"]] call SAC_fnc_moveUnitToVehicle;
		
	
	};

/*
	{
	
		if ((_x != player) && {alive _x}) then {
		
			if (isNull objectParent _x) then {
			
				player setPos (getPos _x);
				
				_done = true;
			
			} else {
			
				//la unidad está en un vehículo
				_done = [player, vehicle _x, ["Cargo", "personTurret", "commonTurret", "Commander", "Gunner", "Driver"]] call SAC_fnc_moveUnitToVehicle;
				
			
			};
		
		};
		
		if (_done) exitWith {};
		
	} forEach units group player;
*/

	if (_done) then {
	
		//SAC_TEL_allow = false;
	
	} else {
	
		hint (parseText "<t color='#00FFFF' size='1.2'><br/>La unidad no tiene lugar en su vehiculo.<br/><br/></t>");
	
	};

};

SAC_TEL_manager = {

	uiSleep (60 *_this); //sleep no funciona cuando se ejecuta en JIP. El engine simplemente no pausa la ejecución del hilo.
	
	hint (parseText "<t color='#00FFFF' size='1.2'><br/>Reconnect Teleport ha terminado.<br/><br/></t>");
	SAC_TEL_allow = false;

};

hint (parseText "<t color='#00FFFF' size='1.2'><br/>Tienes 5 minutos para usar Reconnect Teleport.<br/><br/></t>");
SAC_TEL_allow = true;

SAC_TEL_managerHandle = 6 spawn SAC_TEL_manager;

["Reconnect Teleport","sac_teleport_key", "Teleport", {if (SAC_TEL_allow) then {[] spawn SAC_TEL_teleport}}, "", [20, [false, true, false]]] call CBA_fnc_addKeybind;


