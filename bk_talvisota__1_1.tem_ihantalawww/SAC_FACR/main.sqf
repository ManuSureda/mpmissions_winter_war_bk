if (!hasInterface) exitWith {};
waitUntil {!isNull player};

if !(getPlayerUID player in SAC_FACR_PUIDs) exitWith {};

SAC_FACR_CreateMultipleTargets_FixedWing = {

	private ["_pos", "_firstSelection"];


	_firstSelection = true;
	
	SAC_FACR_TerminateTargetsDesignation = false;
	
	while {true} do {
	
		_pos = [] call SAC_fnc_select_position_in_map;
		
		if (SAC_FACR_TerminateTargetsDesignation || {_pos isEqualTo [0,0,0]}) exitWith {};
		
		if (_firstSelection) then {
		
			{deleteMarkerLocal _x} forEach SAC_FACR_target_list_markers_FixedWing;
			SAC_FACR_target_list_markers_FixedWing = [];
			SAC_FACR_TargetList_FixedWing = [];
			
			_firstSelection = false;
			
		};

		SAC_FACR_TargetList_FixedWing = SAC_FACR_TargetList_FixedWing + [_pos];

		SAC_FACR_target_list_markers_FixedWing = SAC_FACR_target_list_markers_FixedWing + [[_pos, "ColorRed", "fw", "hd_destroy", [1, 1]] call SAC_fnc_createMarkerLocal];
		
	};
	
	!_firstSelection

};

SAC_FACR_CreateMultipleTargets_82mm_HE = {

	private ["_pos", "_firstSelection"];


	_firstSelection = true;
	
	SAC_FACR_TerminateTargetsDesignation = false;
	
	while {true} do {
	
		_pos = [] call SAC_fnc_select_position_in_map;
		
		if (SAC_FACR_TerminateTargetsDesignation || {_pos isEqualTo [0,0,0]}) exitWith {};
		
		if (_firstSelection) then {
		
			{deleteMarkerLocal _x} forEach SAC_FACR_target_list_markers_82mm_HE;
			SAC_FACR_target_list_markers_82mm_HE = [];
			SAC_FACR_TargetList_82mm_HE = [];
			
			_firstSelection = false;
			
		};

		SAC_FACR_TargetList_82mm_HE = SAC_FACR_TargetList_82mm_HE + [_pos];

		SAC_FACR_target_list_markers_82mm_HE = SAC_FACR_target_list_markers_82mm_HE + [[_pos, "ColorRed", "82", "hd_destroy", [0.5, 0.5]] call SAC_fnc_createMarkerLocal];
		
	};
	
	!_firstSelection

};

SAC_FACR_CreateMultipleTargets_155mm_HE = {

	private ["_pos", "_firstSelection"];


	_firstSelection = true;
	
	SAC_FACR_TerminateTargetsDesignation = false;
	
	while {true} do {
	
		_pos = [] call SAC_fnc_select_position_in_map;
		
		if (SAC_FACR_TerminateTargetsDesignation || {_pos isEqualTo [0,0,0]}) exitWith {};
		
		if (_firstSelection) then {
		
			{deleteMarkerLocal _x} forEach SAC_FACR_target_list_markers_155mm_HE;
			SAC_FACR_target_list_markers_155mm_HE = [];
			SAC_FACR_TargetList_155mm_HE = [];
			
			_firstSelection = false;
			
		};

		SAC_FACR_TargetList_155mm_HE = SAC_FACR_TargetList_155mm_HE + [_pos];

		SAC_FACR_target_list_markers_155mm_HE = SAC_FACR_target_list_markers_155mm_HE + [[_pos, "ColorRed", "155", "hd_destroy", [0.5, 0.5]] call SAC_fnc_createMarkerLocal];
		
	};
	
	!_firstSelection

};

SAC_FACR_CreateMultipleTargets_Illum = {

	private ["_pos", "_firstSelection"];


	_firstSelection = true;
	
	SAC_FACR_TerminateTargetsDesignation = false;
	
	while {true} do {
	
		_pos = [] call SAC_fnc_select_position_in_map;
		
		if (SAC_FACR_TerminateTargetsDesignation || {_pos isEqualTo [0,0,0]}) exitWith {};
		
		if (_firstSelection) then {
		
			{deleteMarkerLocal _x} forEach SAC_FACR_target_list_markers_illum;
			SAC_FACR_target_list_markers_illum = [];
			SAC_FACR_TargetList_illum = [];
			
			_firstSelection = false;
			
		};

		SAC_FACR_TargetList_illum = SAC_FACR_TargetList_illum + [_pos];

		SAC_FACR_target_list_markers_illum = SAC_FACR_target_list_markers_illum + [[_pos, "ColorYellow", "illum", "mil_circle", [0.5, 0.5]] call SAC_fnc_createMarkerLocal];
		
	};
	
	!_firstSelection

};

SAC_FACR_HitMultipleTargets = {

	params ["_targetList", "_ordinance", "_delayUntilImpact", "_delayBetweenRounds", "_maxError"];
	
	if ((count _targetList) == 0) exitWith {[SAC_PLAYER_SIDE, "HQ"] sideChat "No targets designated.";};
	
	private _roundPos = [];
	private _soundPos = [];
	private _targetPosASL = [];
	private _dropPosASL = [];
	private _altitudeDiff = 0;
	private _waterDepth = 0;
	
	[SAC_PLAYER_SIDE, "HQ"] sideChat format ["Ordinance is on the way, ETA %1 sec., over...", _delayUntilImpact];
	if (SAC_FACR_speaker) then {[player, "radiochatter_us_18", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_18" call SAC_fnc_playSound};
	
	sleep _delayUntilImpact;
	
	if (_ordinance in ["MK 83/GBU-12", "MK 82", "Gen/GBU-12", "Napalm"]) then {
	
		_soundPos = +_targetList select (count _targetList) - 1;
		_soundPos set [2, 300];
		private _soundPosASL = ATLToASL _soundPos;
		
		//[filename, soundSource, isInside, soundPosition, volume, soundPitch, distance, offset]
		//playSound3D [getMissionPath "\sounds\gx_air_sounds\battlefield_jet2.wav", player, false, _soundPosASL, 5];
		playSound3D ["sac_sounds_a3\sound\battlefield_jet2.wss", player, false, _soundPosASL, 5];
		//playSound3D [getMissionPath sac_airsound, player, false, _soundPosASL, 5];
		
	};
	
	{
		
		switch (_ordinance) do {
		
			case "MK 83/GBU-12": {

				//_roundPos = _x getPos [round 211, 180]; //para la "Bo_GBU12_LGB"
				_roundPos = _x;
				_roundPos set [2, 0];
				
				if (surfaceIsWater _roundPos) then {_waterDepth = abs(_roundPos select 2)} else {_waterDepth = 0};
				
				_targetPosASL = AGLToASL [_x select 0, _x select 1, 0];
				_dropPosASL = AGLToASL _roundPos;
				
				_altitudeDiff = (_targetPosASL select 2) - (_dropPosASL select 2);
				
				//systemChat format ["_roundPos = %1", _roundPos];
				//systemChat format ["_targetPosASL = %1", _targetPosASL];
				//systemChat format ["_dropPosASL = %1", _dropPosASL];
				//systemChat str _altitudeDiff;
				//[_roundPos, "ColorBlue", ""] call SAC_fnc_createMarker;
				
				
				_roundPos set [2, 250 + _altitudeDiff - _waterDepth]; //250 mts trabaja en conjunto con la aceleración de -100 mts/s dada en SAC_fnc_impact

				//[["Bo_GBU12_LGB", _roundPos, 999, 999, 999, 999, 100], "SAC_fnc_impact", false, false] call BIS_fnc_MP;

				["Bo_GBU12_LGB", _roundPos, 999, 999, 999, 999, 100] remoteExecCall ["SAC_fnc_impact", 2, false];
				
			};
			case "MK 82": {

				//_roundPos = _x getPos [round 82, 180]; //para la "Bo_Mk82"
				_roundPos = _x;
				_roundPos set [2, 0];
				
				if (surfaceIsWater _roundPos) then {_waterDepth = abs(_roundPos select 2)} else {_waterDepth = 0};
				
				_targetPosASL = AGLToASL [_x select 0, _x select 1, 0];
				_dropPosASL = AGLToASL _roundPos;
				
				_altitudeDiff = (_targetPosASL select 2) - (_dropPosASL select 2);
				
				_roundPos set [2, 250 + _altitudeDiff - _waterDepth]; //250 mts trabaja en conjunto con la aceleración de -100 mts/s dada en SAC_fnc_impact
				
				[["Bo_Mk82", _roundPos, 999, 999, 999, 999, 100], "SAC_fnc_impact", false, false] call BIS_fnc_MP;
				
			};
			case "Gen/GBU-12": {

				//_roundPos = _x getPos [round 102, 180]; //para la "Bomb_04_F"
				_roundPos = _x;
				_roundPos set [2, 0];
				
				if (surfaceIsWater _roundPos) then {_waterDepth = abs(_roundPos select 2)} else {_waterDepth = 0};
				
				_targetPosASL = AGLToASL [_x select 0, _x select 1, 0];
				_dropPosASL = AGLToASL _roundPos;
				
				_altitudeDiff = (_targetPosASL select 2) - (_dropPosASL select 2);
				
				_roundPos set [2, 250 + _altitudeDiff - _waterDepth]; //250 mts trabaja en conjunto con la aceleración de -100 mts/s dada en SAC_fnc_impact

				//el modelo es parecido a una GBU-12 y con jsrs es la que mejor suena
				//parece ser una clase interna de BIS, probablemente la base class de la GBU-12
				[["Bomb_04_F", _roundPos, 999, 999, 999, 999, 100], "SAC_fnc_impact", false, false] call BIS_fnc_MP;
				
			};
			case "Napalm": {

				_roundPos = _x; //para la "Bomb_04_F"
				
				if (surfaceIsWater _roundPos) then {_waterDepth = abs(_roundPos select 2)} else {_waterDepth = 0};
				
				_targetPosASL = AGLToASL [_x select 0, _x select 1, 0];
				_dropPosASL = AGLToASL _roundPos;
				
				_altitudeDiff = (_targetPosASL select 2) - (_dropPosASL select 2);
				
				_roundPos set [2, 250 + _altitudeDiff - _waterDepth]; //250 mts trabaja en conjunto con la aceleración de -100 mts/s dada en SAC_fnc_impact

				//el modelo es parecido a una GBU-12 y con jsrs es la que mejor suena
				//parece ser una clase interna de BIS, probablemente la base class de la GBU-12
				[["Uns_Napalm_750", _roundPos, 999, 999, 999, 999, 100], "SAC_fnc_impact", false, false] call BIS_fnc_MP;
				
			};
			case "82mm HE": {
			
				_roundPos = _x;
				_roundPos set [2, 250];
		
				[["Sh_82mm_AMOS", _roundPos, 999, 999, 999, 999, 70], "SAC_fnc_impact", false, false] call BIS_fnc_MP;
				
			};
			case "155mm HE": {
			
				_roundPos = _x;
				_roundPos set [2, 250];
				
				[["Sh_155mm_AMOS", _roundPos, 999, 999, 999, 999, 70], "SAC_fnc_impact", false, false] call BIS_fnc_MP;
				//[["Smoke_82mm_AMOS_White", _roundPos, 999, 999, 999, 999, 70], "SAC_fnc_impact", false, false] call BIS_fnc_MP;
				//[["Smoke_120mm_AMOS_White", _roundPos, 999, 999, 999, 999, 70], "SAC_fnc_impact", false, false] call BIS_fnc_MP;
				
			};
			case "Illum": {
		
				_roundPos = [_x select 0, _x select 1] getPos [round random _maxError, round random 360];
				_roundPos set [2, SAC_FACR_illumRoundAlt + random 50];
				
				//["_ammo", "_pos", "_vehiclePrimaryBlast", "_vehicleSecondaryBlast", "_unitPrimaryBlast", "_unitSecondaryBlast", "_behaviour"]
				[[SAC_FACR_illumRound, _roundPos, 999, 999, 999, 999, 70], "SAC_fnc_impact", false, false] call BIS_fnc_MP;
				
			};
			
		};
		
		sleep (_delayBetweenRounds select 0) + random (_delayBetweenRounds select 1);

	} forEach _targetList;
	
};

SAC_FACR_requestUAV = {

	SAC_user_input = "";

	0 = createdialog "SAC_1x14_panel";
	ctrlSetText [1800, " UAV Selector "];

	ctrlSetText [1601, "Deploy Darter"];
	ctrlSetText [1602, "Call MQ4A Greyhawk"];
	ctrlSetText [1603, "Call Sentinel"];
	ctrlShow [1604, false];
	ctrlShow [1605, false];
	ctrlShow [1606, false];
	ctrlShow [1607, false];
	ctrlShow [1608, false];
	ctrlShow [1609, false];
	ctrlShow [1610, false];
	ctrlShow [1611, false];
	ctrlShow [1612, false];
	ctrlShow [1613, false];
	ctrlShow [1614, false];

	waitUntil { !dialog };

	private ["_vehicle", "_returnedArray", "_spawnPos"];
	
	switch (SAC_user_input) do {

		case "Deploy Darter": {
		
			if ((player call SAC_fnc_isUnderRoof) && {!(typeOf (vehicle player) in ["B_Boat_Transport_01_F"])}) exitWith {

				systemChat "Negativo. Debes estar al aire libre.";

			};
			
			_spawnPos = getPos player; _spawnPos set [2, 2.5];
			
			_returnedArray = [_spawnPos, 0, "B_UAV_01_F", SAC_PLAYER_SIDE, true] call BIS_fnc_spawnVehicle;
			_vehicle = _returnedArray select 0;

			sleep 2;
			_vehicle setPos _spawnPos; //el UAV se crea a 50 mts. y por más que se lo baje, vuelve a retomar la misma altura, asi por lo menos parece que saliera de mas cerca del jugador

			[_vehicle] spawn SAC_fnc_autoRefuel;
			_vehicle setCaptive true;
			
		};
		case "Call MQ4A Greyhawk": {
		
			if !("SAC_FACR_base" in allMapMarkers) exitWith {

				systemChat "Negativo. No está definida la base.";

			};
			
			_spawnPos = getMarkerPos "SAC_FACR_base";
			
			_returnedArray = [_spawnPos, 0, "B_UAV_02_dynamicLoadout_F", SAC_PLAYER_SIDE] call BIS_fnc_spawnVehicle;
			_vehicle = _returnedArray select 0;

			[_vehicle] spawn SAC_fnc_autoRefuel;
			_vehicle setCaptive true;
			
			_vehicle setAmmoOnPylon [1, 0];
			_vehicle setAmmoOnPylon [2, 0];
			
		};
		case "Call Sentinel": {
		
			if !("SAC_FACR_base" in allMapMarkers) exitWith {

				systemChat "Negativo. No está definida la base.";

			};

			_spawnPos = getMarkerPos "SAC_SQUAD_G_vehicleSpawn";
			
			_returnedArray = [_spawnPos, 0, "B_UAV_05_F", SAC_PLAYER_SIDE] call BIS_fnc_spawnVehicle;
			_vehicle = _returnedArray select 0;

			[_vehicle] spawn SAC_fnc_autoRefuel;
			_vehicle setCaptive true;
			
			_vehicle setAmmoOnPylon [1, 0];
			_vehicle setAmmoOnPylon [2, 0];
			
		};

	};
	

};

SAC_FACR_OpenRadioInterface = {

	private ["_pos", "_timeAbort", "_missionOK", "_laserTargets", "_posTemp", "_dummyTarget", "_posLaser", "_missileTargets", "_missileTarget"];

	If (!SAC_FACR_TargetsDesignationMode) then {
	
		SAC_user_input = "";
		
		0 = createdialog "SAC_2x12_panel";
		ctrlSetText [1800, " FAC Radio Interface "];
		
		ctrlSetText [1601, "Airstrike (GBU-12 LGB)"];
		ctrlSetText [1602, "Airstrike (Missile)"];
		ctrlShow [1603, false ];
		((findDisplay 3000) displayCtrl 1604) ctrlSetTextColor [1,0,0,1];
		ctrlSetText [1604, "Drop MK 83/GBU-12"];
		((findDisplay 3000) displayCtrl 1605) ctrlSetTextColor [1,0,0,1];
		ctrlSetText [1605, "Drop MK 82"];
		((findDisplay 3000) displayCtrl 1606) ctrlSetTextColor [1,0,0,1];
		if (SAC_unsung) then {ctrlSetText [1606, "Drop Napalm"]} else {ctrlSetText [1606, "Drop Gen/GBU-12"]};
		ctrlShow [1607, false ];
		((findDisplay 3000) displayCtrl 1608) ctrlSetTextColor [1,0,0,1];
		ctrlSetText [1608, "Hit 82mm HE Targets"];
		((findDisplay 3000) displayCtrl 1609) ctrlSetTextColor [1,0,0,1];
		ctrlSetText [1609, "Hit 155mm HE Targets"];
		ctrlShow [1610, false ];
		ctrlSetText [1611, "Hit Illum Targets"];
		ctrlShow [1612, false ];
		
		ctrlSetText [1613, "Set Supplies Target"];
		ctrlSetText [1614, "Set Fixed Wing Targets"];
		ctrlSetText [1615, "Set 82mm HE Targets"];
		ctrlSetText [1616, "Set 155mm HE Targets"];
		ctrlSetText [1617, "Set Illum Targets"];
		ctrlSetText [1618, "Mark Laser Target"];
		ctrlShow [1619, false ];
		ctrlSetText [1620, "UAVs..."];
		ctrlSetText [1621, "Drop Supplies"];
		ctrlShow [1622, false ];
		ctrlShow [1623, false ];
		if (!SAC_FACR_speaker) then {ctrlSetText [1624, "Speaker OFF"]; ((findDisplay 3000) displayCtrl 1624) ctrlSetBackgroundColor [0.7,0,0,1]} else {ctrlSetText [1624, "Speaker ON"]};

		waitUntil { !dialog };

		switch (SAC_user_input) do {
		
			case "Airstrike (GBU-12 LGB)": { //Airstrike (GBU-12 LGB) - MK-82 (500lb, 241 kg)

				if (time > SAC_FACR_time_until_next_airstrike) then {
					
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Start lasing now...";
					if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
					hint "Paint the target with the laser until the operator detects it.";
					sleep 10;
					
					_timeAbort = time + 15;
					_missionOK = false;
					while {!_missionOK and time < _timeAbort} do {

						_laserTargets =  player nearEntities ["LaserTarget", 50000];

						if (count _laserTargets > 0) then {
						
							_pos = position (_laserTargets select 0);
							[SAC_PLAYER_SIDE, "HQ"] sideChat "Target adquired, stand by, over.";
							if (SAC_FACR_speaker) then {[player, "radiochatter_us_34", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_34" call SAC_fnc_playSound};
							SAC_FACR_time_until_next_airstrike = time + SAC_FACR_airstrikeDelay;
							
							//[_pos, "ColorBlue", ""] call SAC_fnc_createMarker;
							//systemChat str _pos;

							/*
							private _spawnDistance = 7000;
							private _flyAltitudeAGL = 700;
							private _spawnPos = _pos getPos [_spawnDistance, 180];
							_spawnPos set [2, _flyAltitudeAGL];
							//[_spawnPos, "ColorBlue", ""] call SAC_fnc_createMarker;
							private _deSpawnPos = _spawnPos getPos [_spawnDistance * 2.5, _spawnPos getDir _pos];
							//[_deSpawnPos, "ColorRed", ""] call SAC_fnc_createMarker;
							private _terrainAltitudeASL = (getPosASL player) select 2;
							private _returnedArray = [_spawnPos, _spawnPos getDir _pos, "B_Plane_Fighter_01_F", SAC_PLAYER_SIDE] call BIS_fnc_spawnVehicle;
							private _vehicle = _returnedArray select 0;
							_vehicle setCaptive true;
							_vehicle setBehaviour "CARELESS";
							_vehicle setCombatMode "BLUE";
							
							//systemChat str (getPos _vehicle select 2);
							
							_vehicle flyInHeightASL [_terrainAltitudeASL + _flyAltitudeAGL, _terrainAltitudeASL + _flyAltitudeAGL, _terrainAltitudeASL + _flyAltitudeAGL];

							private _wp = group _vehicle addWaypoint [_pos, 0];
							_wp setWaypointType "MOVE";
							
							_wp = group _vehicle addWaypoint [_deSpawnPos, 0];
							_wp setWaypointType "MOVE";
							
							[_vehicle, _pos, _spawnDistance + 500] spawn {
							
								params ["_v", "_p", "_d"];
								
								waitUntil {_v distance _p > _d};
								deleteVehicle _v;
							
							};
*/


							
							sleep SAC_FACR_airstrikeDelay;
							
							_laserTargets =  player nearEntities ["LaserTarget", 50000];
							if (count _laserTargets > 0) then {_pos = position (_laserTargets select 0)};
							
							[[_pos], "MK 83/GBU-12", 10, [0.5, 0.8], 0] spawn SAC_FACR_HitMultipleTargets;
							
							_missionOK = true;
							
						};
						
						sleep 1;
						
					};
					
					if (!_missionOK) then {
					
						[SAC_PLAYER_SIDE, "HQ"] sideChat "No laser detected, out.";
						if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
					
					};
					
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat format ["Negative, tasker will be ready in aprox. %1 sec., over...", round (SAC_FACR_time_until_next_airstrike - time)];
				
				};
			};
			
			case "Airstrike (Missile)": { //Airstrike (Missile)

				if (time > SAC_FACR_time_until_next_airstrike) then {
		
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Designate target now...";
					if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
					hint "Designate the target with the laser until the missile locks on.";
					
					sleep 10;

					_timeAbort = time + 15;
					_missionOK = false;
					while {!_missionOK and time < _timeAbort} do {
						_laserTargets =  player nearEntities ["LaserTarget", 50000];
						if (count _laserTargets > 0) then {
							_posLaser = position (_laserTargets select 0);
							_missileTargets =  nearestobjects [_posLaser, ["Car","Tank","Air"], 5];
							if (count _missileTargets > 0) then {
								_missileTarget = _missileTargets select 0;
								[SAC_PLAYER_SIDE, "HQ"] sideChat "Target adquired. Missile launched...";
								if (SAC_FACR_speaker) then {[player, "radiochatter_us_34", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_34" call SAC_fnc_playSound};
								SAC_FACR_time_until_next_airstrike = time + SAC_FACR_airstrikeDelay;
								sleep SAC_FACR_airstrikeDelay;
								
								["Bo_GBU12_LGB", getPos _missileTarget, 999, 999, 999, 999, 100] call SAC_fnc_impact;
								
								//_missileTarget setDammage 1;
								
								[SAC_PLAYER_SIDE, "HQ"] sidechat "Splash.";

								_missionOK = true;
							};
						};
						sleep 1;
					};
					If (!_missionOK) then {
						[SAC_PLAYER_SIDE, "HQ"] sideChat "No target. Mission aborted.";
						if (SAC_FACR_speaker) then {[player, "radiochatter_us_14", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_14" call SAC_fnc_playSound};
					};
					
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat format ["Negative, tasker will be ready in aprox. %1 sec., over...", round (SAC_FACR_time_until_next_airstrike - time)];
				
				};
				
			};
			
			case "Mark Laser Target": {

				[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Start lasing now...";
				//if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
				hint "Paint the target with the laser until the operator detects it.";
				sleep 10;
				
				_timeAbort = time + 15;
				_missionOK = false;
				while {!_missionOK and time < _timeAbort} do {

					_laserTargets =  player nearEntities ["LaserTarget", 50000];

					if (count _laserTargets > 0) then {
					
						_pos = position (_laserTargets select 0);
						[SAC_PLAYER_SIDE, "HQ"] sideChat "Target marked, over.";
						//if (SAC_FACR_speaker) then {[player, "radiochatter_us_34", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_34" call SAC_fnc_playSound};
						
						SAC_FACR_Target setMarkerPosLocal _pos;

						_missionOK = true;
						
					};
					
					sleep 1;
					
				};
				
				if (!_missionOK) then {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "No laser detected, out.";
					//if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
				
				};
				
			};

			case "Set Supplies Target": {
			
				SAC_FACR_TargetsDesignationMode = true;
				[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Standing by...";
				if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
				
				_pos = [] call SAC_fnc_select_position_in_map;

				if (_pos isNotEqualTo [0,0,0]) then {
				
					SAC_FACR_Target setMarkerPosLocal _pos;
					
					openMap false;
					
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Coordinates received.";
					if (SAC_FACR_speaker) then {[player, "radiochatter_us_15", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_15" call SAC_fnc_playSound};
					
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Roger. Out.";
				
				};
				
				SAC_FACR_TargetsDesignationMode = false;
				
			};
			
			case "Set Fixed Wing Targets": {
			
				SAC_FACR_TargetsDesignationMode = true;
				[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Standing by for target package...";
				if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
				
				if ([] call SAC_FACR_CreateMultipleTargets_FixedWing) then {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Coordinates received.";
					if (SAC_FACR_speaker) then {[player, "radiochatter_us_15", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_15" call SAC_fnc_playSound};
				
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Roger. Out.";
					
				};
				
				SAC_FACR_TargetsDesignationMode = false;
				
			};
			
			case "Set 82mm HE Targets": {
			
				SAC_FACR_TargetsDesignationMode = true;
				[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Standing by for target package...";
				if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
				
				if ([] call SAC_FACR_CreateMultipleTargets_82mm_HE) then {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Coordinates received.";
					if (SAC_FACR_speaker) then {[player, "radiochatter_us_15", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_15" call SAC_fnc_playSound};
				
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Roger. Out.";
					
				};
				
				SAC_FACR_TargetsDesignationMode = false;
				
			};
			
			case "Set 155mm HE Targets": {
			
				SAC_FACR_TargetsDesignationMode = true;
				[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Standing by for target package...";
				if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
				
				if ([] call SAC_FACR_CreateMultipleTargets_155mm_HE) then {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Coordinates received.";
					if (SAC_FACR_speaker) then {[player, "radiochatter_us_15", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_15" call SAC_fnc_playSound};
				
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Roger. Out.";
					
				};
				
				SAC_FACR_TargetsDesignationMode = false;
				
			};
			
			case "Set Illum Targets": {
			
				SAC_FACR_TargetsDesignationMode = true;
				[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Standing by for target package...";
				if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
				
				if ([] call SAC_FACR_CreateMultipleTargets_Illum) then {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Coordinates received.";
					if (SAC_FACR_speaker) then {[player, "radiochatter_us_15", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_15" call SAC_fnc_playSound};
				
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Roger. Out.";
					
				};
				
				SAC_FACR_TargetsDesignationMode = false;
				
			};
			
			case "Drop MK 83/GBU-12": {

				if (count SAC_FACR_TargetList_FixedWing > 0) then {
				
					if (time > SAC_FACR_time_until_next_airstrike) then {
					
						//["_targetList", "_ordinance", "_delayUntilImpact", "_delayBetweenRounds", "_maxError"];
						[SAC_FACR_TargetList_FixedWing, "MK 83/GBU-12", 10, [0.5, 0.8], 15] spawn SAC_FACR_HitMultipleTargets;
						SAC_FACR_time_until_next_airstrike = time + SAC_FACR_airstrikeDelay;
						
					} else {
					
						[SAC_PLAYER_SIDE, "HQ"] sideChat format ["Negative, tasker will be ready in aprox. %1 sec., over...", round (SAC_FACR_time_until_next_airstrike - time)];
					
					};
					
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Negative, no targets package, over...";
				
				};
				
			};
			
			case "Drop MK 82": {

				if (count SAC_FACR_TargetList_FixedWing > 0) then {
				
					if (time > SAC_FACR_time_until_next_airstrike) then {
					
						//["_targetList", "_ordinance", "_delayUntilImpact", "_delayBetweenRounds", "_maxError"];
						[SAC_FACR_TargetList_FixedWing, "MK 82", 10, [0.5, 0.8], 15] spawn SAC_FACR_HitMultipleTargets;
						SAC_FACR_time_until_next_airstrike = time + SAC_FACR_airstrikeDelay;
						
					} else {
					
						[SAC_PLAYER_SIDE, "HQ"] sideChat format ["Negative, tasker will be ready in aprox. %1 sec., over...", round (SAC_FACR_time_until_next_airstrike - time)];
					
					};
					
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Negative, no targets package, over...";
				
				};
				
			};
			
			case "Drop Gen/GBU-12": {

				if (count SAC_FACR_TargetList_FixedWing > 0) then {
				
					if (time > SAC_FACR_time_until_next_airstrike) then {
					
						//["_targetList", "_ordinance", "_delayUntilImpact", "_delayBetweenRounds", "_maxError"];
						[SAC_FACR_TargetList_FixedWing, "Gen/GBU-12", 10, [0.5, 0.8], 15] spawn SAC_FACR_HitMultipleTargets;
						SAC_FACR_time_until_next_airstrike = time + SAC_FACR_airstrikeDelay;
						
					} else {
					
						[SAC_PLAYER_SIDE, "HQ"] sideChat format ["Negative, tasker will be ready in aprox. %1 sec., over...", round (SAC_FACR_time_until_next_airstrike - time)];
					
					};
					
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Negative, no targets package, over...";
				
				};
				
			};
			
			case "Drop Napalm": {

				if (count SAC_FACR_TargetList_FixedWing > 0) then {
				
					if (time > SAC_FACR_time_until_next_airstrike) then {
					
						//["_targetList", "_ordinance", "_delayUntilImpact", "_delayBetweenRounds", "_maxError"];
						[SAC_FACR_TargetList_FixedWing, "Napalm", 10, [0.5, 0.8], 15] spawn SAC_FACR_HitMultipleTargets;
						SAC_FACR_time_until_next_airstrike = time + SAC_FACR_airstrikeDelay;
						
					} else {
					
						[SAC_PLAYER_SIDE, "HQ"] sideChat format ["Negative, tasker will be ready in aprox. %1 sec., over...", round (SAC_FACR_time_until_next_airstrike - time)];
					
					};
					
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Negative, no targets package, over...";
				
				};
				
			};
			
			case "Hit 82mm HE Targets": {

				if (count SAC_FACR_TargetList_82mm_HE > 0) then {
				
					if (time > SAC_FACR_time_until_next_mortar) then {
					
						//["_targetList", "_ordinance", "_delayUntilImpact", "_delayBetweenRounds", "_maxError"];
						[SAC_FACR_TargetList_82mm_HE, "82mm HE", 10, [2, 3], 25] spawn SAC_FACR_HitMultipleTargets;
						SAC_FACR_time_until_next_mortar = time + SAC_FACR_mortarDelay;
						
					} else {
					
						[SAC_PLAYER_SIDE, "HQ"] sideChat format ["Negative, tasker will be ready in aprox. %1 sec., over...", round (SAC_FACR_time_until_next_mortar - time)];
					
					};
					
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Negative, no targets package, over...";
				
				};
				
			};
			
			case "Hit 155mm HE Targets": {

				if (count SAC_FACR_TargetList_155mm_HE > 0) then {
				
					if (time > SAC_FACR_time_until_next_artillery) then {
					
						//["_targetList", "_ordinance", "_delayUntilImpact", "_delayBetweenRounds", "_maxError"];
						[SAC_FACR_TargetList_155mm_HE, "155mm HE", 10, [0.5, 1], 15] spawn SAC_FACR_HitMultipleTargets;
						SAC_FACR_time_until_next_artillery = time + SAC_FACR_artilleryDelay;
						
					} else {
					
						[SAC_PLAYER_SIDE, "HQ"] sideChat format ["Negative, tasker will be ready in aprox. %1 sec., over...", round (SAC_FACR_time_until_next_artillery - time)];
					
					};
					
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Negative, no targets package, over...";
				
				};
				
			};
			
			case "Hit Illum Targets": {

				if (count SAC_FACR_TargetList_illum > 0) then {
				
					if (time > SAC_FACR_time_until_next_mortar) then {
					
						//["_targetList", "_ordinance", "_delayUntilImpact", "_delayBetweenRounds", "_maxError"];
						[SAC_FACR_TargetList_illum, "Illum", 10, [0.5, 2.5], 15] spawn SAC_FACR_HitMultipleTargets;
						SAC_FACR_time_until_next_mortar = time + SAC_FACR_mortarDelay;
						
					} else {
					
						[SAC_PLAYER_SIDE, "HQ"] sideChat format ["Negative, tasker will be ready in aprox. %1 sec., over...", round (SAC_FACR_time_until_next_mortar - time)];
					
					};
					
				} else {
				
					[SAC_PLAYER_SIDE, "HQ"] sideChat "Negative, no targets package, over...";
				
				};
				
			};
			
			case "UAVs...": {

				[] spawn SAC_FACR_requestUAV;

			};
			
			case "Drop Supplies": {

				[SAC_PLAYER_SIDE, "HQ"] sideChat "Copy. Standing by for supply drop, ETA 60s...";
				if (SAC_FACR_speaker) then {[player, "radiochatter_us_21", 100] call SAC_fnc_netSay3D;} else {"radiochatter_us_21" call SAC_fnc_playSound};
				
				 sleep 5;
				 
				[getMarkerPos SAC_FACR_Target] spawn SAC_fnc_ammoDrop;

			};
			
			case "Speaker ON";
			case "Speaker OFF": {

				SAC_FACR_speaker = if (SAC_FACR_speaker) then {false} else {true};

			};
			
		};
		
	} else {
	
		SAC_user_input = "";
		
		0 = createdialog "SAC_1x14_panel";
		ctrlSetText [1800, " FAC Radio Interface (Setting Multiple Targets) "];
		
		ctrlSetText [1601, "Cancel/Finish"];
		ctrlShow [1602, false ];
		ctrlShow [1603, false ];
		ctrlShow [1604, false ];
		ctrlShow [1605, false ];
		ctrlShow [1606, false ];
		ctrlShow [1607, false ];
		ctrlShow [1608, false ];
		ctrlShow [1609, false ];
		ctrlShow [1610, false ];
		ctrlShow [1611, false ];
		ctrlShow [1612, false ];
		ctrlShow [1613, false ];
		ctrlShow [1614, false ];

		waitUntil { !dialog };

		switch (SAC_user_input) do {
		
			case "Cancel/Finish": { //Cancel/Finish multi target designation
				hint "";
				SAC_FACR_TerminateTargetsDesignation = true;
				SAC_FACR_TargetsDesignationMode = false;
				SAC_fnc_select_position_in_map_cancel = true;
			};
			
		};


	};

};

private ["_trg", "_marker"];

//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitwith {hintC """SAC_FNC"" is not initialized in SAC_FACR."};
if (isnil "SAC_FACR_radioChannel") exitwith {hintC """SAC_FACR_radioChannel"" is not initialized in SAC_FACR."};
if (isnil "SAC_FACR_airstrikeDelay") exitwith {hintC """SAC_FACR_airstrikeDelay"" is not initialized in SAC_FACR."};
if (isnil "SAC_FACR_mortarDelay") exitwith {hintC """SAC_FACR_mortarDelay"" is not initialized in SAC_FACR."};
if (isnil "SAC_FACR_artilleryDelay") exitwith {hintC """SAC_FACR_artilleryDelay"" is not initialized in SAC_FACR."};

SAC_FACR_time_until_next_airstrike = time;
SAC_FACR_time_until_next_mortar = time;
SAC_FACR_time_until_next_artillery = time;

SAC_FACR_TargetList_FixedWing = [];
SAC_FACR_target_list_markers_FixedWing = [];
SAC_FACR_TargetList_82mm_HE = [];
SAC_FACR_target_list_markers_82mm_HE = [];
SAC_FACR_TargetList_155mm_HE = [];
SAC_FACR_target_list_markers_155mm_HE = [];
SAC_FACR_TargetList_illum = [];
SAC_FACR_target_list_markers_illum = [];
SAC_FACR_TargetList_smoke = [];
SAC_FACR_target_list_markers_smoke = [];
SAC_FACR_TargetList_napalm = [];
SAC_FACR_target_list_markers_napalm = [];
SAC_FACR_TerminateTargetsDesignation = false;
SAC_FACR_TargetsDesignationMode = false;

SAC_FACR_speaker = false;

//"mortar_82mm","mortar_82mm","Single1","Sh_82mm_AMOS"
//"mortar_155mm_AMOS","mortar_155mm_AMOS","Sh_155mm_AMOS"
//"mortar_155mm_AMOS","mortar_155mm_AMOS","Cluster_155mm_AMOS"
//"Bomb_04_Plane_CAS_01_F","Bomb_04_Plane_CAS_01_F","Bomb_04_Plane_CAS_01_F","Bomb_04_F"
//"HelicopterExploSmall"
//"gatling_20mm","gatling_20mm","manual","B_20mm_Tracer_Red"
//"Gatling_30mm_Plane_CAS_01_F","Gatling_30mm_Plane_CAS_01_F","LowROF","Gatling_30mm_HE_Plane_CAS_01_F"

_trg = createTrigger ["EmptyDetector",[1,0,0]];
_trg setTriggerActivation [SAC_FACR_radioChannel, "PRESENT", true];
_trg setTriggerType "NONE";
_trg setTriggerStatements ["this","[] spawn SAC_FACR_OpenRadioInterface",""];
_trg setTriggerText "FAC Radio";

waitUntil {!isNull(findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["keyDown", {
	
	if (dialog) exitWith {false};
	
	private["_shift","_dik"]; 
	_dik = _this select 1; 
	_shift = _this select 2; 
	
	if (_dik in [81]) then {
	
		[] spawn SAC_FACR_OpenRadioInterface;
	
		true
		
	} else {
	
		false
		
	};

}]; 

(findDisplay 12) displayAddEventHandler ["keyDown", {
	
	if (dialog) exitWith {false};
	
	private["_shift","_dik"]; 
	_dik = _this select 1; 
	_shift = _this select 2; 
	
	if (_dik in [81]) then {
	
		[] spawn SAC_FACR_OpenRadioInterface;
	
		true
		
	} else {
	
		false
		
	};

}]; 

SAC_FACR_Target = [[0,0,0], "ColorYellow", "", "hd_destroy"] call SAC_fnc_createMarkerLocal;

SAC_FACR = true;
systemChat "FACR initialized.";

SAC_FACR_illumRound = "F_40mm_Green";
if (SAC_ace) then {SAC_FACR_illumRound = "ACE_40mm_Flare_green"};
if (SAC_unsung) then {SAC_FACR_illumRound = "uns_40mm_green"};

SAC_FACR_illumRoundAlt = 200;
if (SAC_ace) then {SAC_FACR_illumRoundAlt = 190};
if (SAC_unsung) then {SAC_FACR_illumRoundAlt = 250};

