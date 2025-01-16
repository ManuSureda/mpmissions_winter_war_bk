if (!hasInterface) exitWith {};
waitUntil {!isNull player};

if !(getPlayerUID player in SAC_TRACK_PUIDs) exitWith {};

params ["_radioChannel"];
private ["_trg"];


//Para compilar el tracker que deja un rastro llamar con un segundo parametro en true (se usará un tracker más viejo y de menor rendimiento).
SAC_TRACK_LeaveTrail = if (count _this > 1) then {true} else {false};

SAC_TRACK_OpenDebugInterface = {

	private _exit = false;
	
	SAC_user_input = "not yet initialized";

	while {(not _exit) && (SAC_user_input != "")} do {

		SAC_user_input = "";

		0 = createdialog "SAC_1x14_panel";
		ctrlSetText [1800, " Unit Selector "];

		if (!SAC_tracker_ON) then {ctrlSetText [1601, "Tracker OFF"]} else {ctrlSetText [1601, "Tracker ON"]; ((findDisplay 3000) displayCtrl 1601) ctrlSetBackgroundColor [0.7,0,0,1]};
		if (!SAC_teleport) then {ctrlSetText [1602, "Teleport OFF"]} else {ctrlSetText [1602, "Teleport ON"]; ((findDisplay 3000) displayCtrl 1602) ctrlSetBackgroundColor [0.7,0,0,1]};
		if (!isDamageAllowed player) then {ctrlSetText [1603, "Allow Damage OFF"]; ((findDisplay 3000) displayCtrl 1603) ctrlSetBackgroundColor [0.7,0,0,1]} else {ctrlSetText [1603, "Allow Damage ON"]};
		if !(captive player) then {ctrlSetText [1604, "Set Captive OFF"]} else {ctrlSetText [1604, "Set Captive ON"]; ((findDisplay 3000) displayCtrl 1604) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlShow [1605, false ];
		ctrlSetText [1606, "Open Arsenal"];
		ctrlShow [1607, false ];
		ctrlShow [1608, false ];
		ctrlShow [1609, false ];
		ctrlShow [1610, false ];
		ctrlShow [1611, false ];
		ctrlShow [1612, false ];
		ctrlShow [1613, false ];
		ctrlSetText [1614, ""];
		ctrlSetFocus ((findDisplay 3000) displayCtrl 1614);

		waitUntil { !dialog };

		switch (SAC_user_input) do
		{
			case "Tracker OFF";
			case "Tracker ON": {
			
				//systemChat "tracker control";
				if (!SAC_tracker_ON) then {
				
					[2, "ON"] spawn SAC_TRACK_Tracker;
					waitUntil {SAC_tracker_ON};
					
				} else {
				
					[2, "OFF"] spawn SAC_TRACK_Tracker;
					waitUntil {!SAC_tracker_ON};
					
				};
				
			};
			case "Teleport OFF";
			case "Teleport ON": {

				if (!SAC_teleport) then {

					SAC_DefaultMapClick = "player setpos _pos";
					onMapSingleClick SAC_DefaultMapClick;
					SAC_teleport = true;

				} else {

					SAC_DefaultMapClick = "";
					onMapSingleClick SAC_DefaultMapClick;
					SAC_teleport = false;

				};
				
			};
			case "Allow Damage OFF";
			case "Allow Damage ON": {
			
				if (isDamageAllowed player) then {player allowDamage false} else {player allowDamage true};
				
			};
			case "Set Captive OFF";
			case "Set Captive ON": {
			
				if (captive player) then {player setCaptive false} else {player setCaptive true};
				
			};
			case "Open Arsenal": {
			
				["Open", true] spawn BIS_fnc_arsenal;
				_exit = true;
				
			};

		};
		
	};

};

SAC_TRACK_OpenLoadoutInterface = {

	private _exit = false;
	
	SAC_user_input = "not yet initialized";

	while {(not _exit) && (SAC_user_input != "")} do {

		SAC_user_input = "";

		0 = createdialog "SAC_1x14_panel";
		ctrlSetText [1800, " Loadout Interface "];

		ctrlSetText [1601, "Apply My Gear To..."];
		ctrlSetText [1602, "Apply My Outfit To..."];
		ctrlSetText [1603, "Apply SQUAD Loadout To..."]; if (isNil "SAC_SQUAD") then {ctrlEnable [1603, false]};
		ctrlSetText [1604, "Get My Gear From..."];
		ctrlSetText [1605, "Get My Outfit From..."];
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
		
			case "Apply My Gear To...": {
			
				//["_sameSide", "_allPlayers", "_onlyConscious", "_sameGroupNPCs", "_includeMyGroup", "_includeSelected", "_includePointed"];
				private _unit = [false, true, false, true, true, true, true] call SAC_fnc_selectUnit;
			
				if (_unit isEqualType "") then {
				
					switch (_unit) do {
					
						case "Selected": {
						
							{
							
								_x setUnitLoadout (getUnitLoadout player);
								
								if !(_x in allPlayers) then {[_x] call SAC_GEAR_fnc_initializeRearm};
							
							} forEach (groupSelectedUnits player) - [player];
						
						};
						
						case "My Group": {
						
							{
							
								_x setUnitLoadout (getUnitLoadout player);
								
								if !(_x in allPlayers) then {[_x] call SAC_GEAR_fnc_initializeRearm};
							
							} forEach (units group player) - [player];
						
						};
						
						case "Pointed": {
						
							private _o = SAC_TRACK_cursorObject;
							
							if (_o isKindOf "Man") then {
							
								_o setUnitLoadout (getUnitLoadout player);
								
								if !(_o in allPlayers) then {[_o] call SAC_GEAR_fnc_initializeRearm};
							
							};
						
						};
					};
				
				} else {
				
					if (!isNull _unit) then {
					
						_unit setUnitLoadout (getUnitLoadout player);
						if !(_unit in allPlayers) then {[_unit] call SAC_GEAR_fnc_initializeRearm};
					
					};
				
				};
			
			};
			case "Apply My Outfit To...": {
			
				//["_sameSide", "_allPlayers", "_onlyConscious", "_sameGroupNPCs", "_includeMyGroup", "_includeSelected", "_includePointed"];
				private _unit = [false, true, false, true, true, true, true] call SAC_fnc_selectUnit;
			
				if (_unit isEqualType "") then {
				
					switch (_unit) do {
					
						case "Selected": {
						
							{
							
								[player, _x] call SAC_fnc_transferOnlyOutfit;
							
							} forEach (groupSelectedUnits player) - [player];
						
						};
						
						case "My Group": {
						
							{
							
								[player, _x] call SAC_fnc_transferOnlyOutfit;
							
							} forEach (units group player) - [player];
						
						};
						
						case "Pointed": {
						
							private _o = SAC_TRACK_cursorObject;
							
							if (_o isKindOf "Man") then {
							
								[player, _o] call SAC_fnc_transferOnlyOutfit;
							
							};
						
						};
					};
				
				} else {
				
					if (!isNull _unit) then {
					
						[player, _unit] call SAC_fnc_transferOnlyOutfit;
					
					};
				
				};
			
			};
			case "Apply SQUAD Loadout To...": {
			
				//["_sameSide", "_allPlayers", "_onlyConscious", "_sameGroupNPCs", "_includeMyGroup", "_includeSelected", "_includePointed"];
				private _unit = [false, true, false, true, true, true, true] call SAC_fnc_selectUnit;
			
				if (_unit isEqualType "") then {
				
					switch (_unit) do {
					
						case "Selected": {
						
							{
							
								[_x, SAC_SQUAD_loadoutProfile, _x getVariable ["SAC_GEAR_role", "RIFLEMAN"], SAC_SQUAD_silencer] call SAC_GEAR_applyLoadout;
								
								if !(_x in allPlayers) then {[_x] call SAC_GEAR_fnc_initializeRearm};

							} forEach (groupSelectedUnits player) - [player];
						
						};
						
						case "My Group": {
						
							{
							
								[_x, SAC_SQUAD_loadoutProfile, _x getVariable ["SAC_GEAR_role", "RIFLEMAN"], SAC_SQUAD_silencer] call SAC_GEAR_applyLoadout;
								
								if !(_x in allPlayers) then {[_x] call SAC_GEAR_fnc_initializeRearm};

							} forEach units group player;
						
						};
						
						case "Pointed": {
						
							private _o = SAC_TRACK_cursorObject;
							
							if (_o isKindOf "Man") then {
							
								[_o, SAC_SQUAD_loadoutProfile, _o getVariable ["SAC_GEAR_role", "RIFLEMAN"], SAC_SQUAD_silencer] call SAC_GEAR_applyLoadout;
								
								if !(_o in allPlayers) then {[_o] call SAC_GEAR_fnc_initializeRearm};
							
							};
						
						};
					};
				
				} else {
				
					if (!isNull _unit) then {
					
						[_unit, SAC_SQUAD_loadoutProfile, _unit getVariable ["SAC_GEAR_role", "RIFLEMAN"], SAC_SQUAD_silencer] call SAC_GEAR_applyLoadout;
						
						if !(_unit in allPlayers) then {[_unit] call SAC_GEAR_fnc_initializeRearm};
					
					};
				
				};
			
			};
			case "Get My Gear From...": {
			
				//["_sameSide", "_allPlayers", "_onlyConscious", "_sameGroupNPCs", "_includeMyGroup", "_includeSelected", "_includePointed"];
				private _unit = [false, true, false, false, false, false, true] call SAC_fnc_selectUnit;
			
				if (_unit isEqualType "") then {
				
					switch (_unit) do {
					
						case "Pointed": {
						
							private _o = SAC_TRACK_cursorObject;
							
							if (_o isKindOf "Man") then {
							
								player setUnitLoadout (getUnitLoadout _o);
							
							};
						
						};
					};
				
				} else {
				
					if (!isNull _unit) then {
					
						player setUnitLoadout (getUnitLoadout _unit);
					
					};
				
				};
			
			};
			case "Get My Outfit From...": {
			
				//["_sameSide", "_allPlayers", "_onlyConscious", "_sameGroupNPCs", "_includeMyGroup", "_includeSelected", "_includePointed"];
				private _unit = [false, true, false, true, false, false, true] call SAC_fnc_selectUnit;
			
				if (_unit isEqualType "") then {
				
					switch (_unit) do {
					
						case "Pointed": {
						
							private _o = SAC_TRACK_cursorObject;
							
							if (_o isKindOf "Man") then {
							
								[_o, player] call SAC_fnc_transferOnlyOutfit;
							
							};
						
						};
					};
				
				} else {
				
					if (!isNull _unit) then {
					
						[_unit, player] call SAC_fnc_transferOnlyOutfit;
					
					};
				
				};
			
			};

		};
		
	};

};

SAC_TRACK_OpenGameMasterInterface = {

	private _exit = false;
	
	SAC_user_input = "not yet initialized";

	while {(not _exit) && (SAC_user_input != "")} do {

		SAC_user_input = "";

		0 = createdialog "SAC_1x14_panel";
		ctrlSetText [1800, " Game Master Interface "];

		ctrlSetText [1601, "Teleport To My Position..."];
		ctrlSetText [1602, "Add Arsenal To Pointed"];
		ctrlSetText [1603, "Full Heal..."];
		ctrlSetText [1604, "Delete Dead Units"];
		ctrlSetText [1605, "Mission Flow..."];
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
		
			case "Teleport To My Position...": {
			
				//["_sameSide", "_allPlayers", "_onlyConscious", "_sameGroupNPCs", "_includeMyGroup", "_includeSelected", "_includePointed"];
				private _unit = [false, true, false, true, true, true, false] call SAC_fnc_selectUnit;
			
				if (_unit isEqualType "") then {
				
					switch (_unit) do {
					
						case "Selected": {
						
							[(groupSelectedUnits player) - [player]] call SAC_fnc_moveUnitsToPlayerPosition;
						
						};
						
						case "My Group": {
						
							[(units group player) - [player]] call SAC_fnc_moveUnitsToPlayerPosition;
						
						};

					};
				
				} else {
				
					if (!isNull _unit) then {
					
						[[_unit]] call SAC_fnc_moveUnitsToPlayerPosition;

					} else {systemChat "la unidad es null"};
				
				};
			
			};
			case "Delete Dead Units": {
			
				[] remoteExec ["SAC_fnc_markGroupsForDeleteWhenEmpty", 2, false];
				[0] remoteExec ["SAC_fnc_deleteAllDeadMen", 2, false];
			
			};
			case "Full Heal...": {
			
				//["_sameSide", "_allPlayers", "_onlyConscious", "_sameGroupNPCs", "_includeMyGroup", "_includeSelected", "_includePointed"];
				private _unit = [false, true, false, true, true, true, false] call SAC_fnc_selectUnit;
			
				if (_unit isEqualType "") then {
				
					switch (_unit) do {
					
						case "Selected": {
						
							{
							
								_x call SAC_fnc_healUnit;
							
							} forEach (groupSelectedUnits player) - [player];
						
						};
						
						case "My Group": {
						
							{

								_x call SAC_fnc_healUnit;

							} forEach units group player;
						
						};

					};
				
				} else {
				
					if (!isNull _unit) then {
					
						_unit call SAC_fnc_healUnit;
					
					};
				
				};
			
			};
			case "Add Arsenal To Pointed": {
			
				if (!isNull SAC_TRACK_cursorObject) then {
				
					SAC_TRACK_cursorObject setVariable ["SAC_GEAR_INITIALIZED", true, true];
					
					SAC_TRACK_cursorObject setVariable ["SAC_interact_arsenal", true, true];
					
					if (SAC_ace) then {
					
						[SAC_TRACK_cursorObject, true, true] call ace_arsenal_fnc_initBox;
					
					};
					
				} else {
				
					hint (parseText "<t color='#00FFFF' size='1.2'><br/>Objeto no válido.<br/><br/></t>")
				
				};
				
				_exit = true;
			
			};
			case "Mission Flow...": {
			
				[] spawn SAC_TRACK_OpenFlowInterface;
				
				_exit = true;
				
			};
			
		};
		
	};

};

SAC_TRACK_OpenFlowInterface = {

	private _exit = false;
	
	SAC_user_input = "not yet initialized";

	while {(not _exit) && (SAC_user_input != "")} do {

		SAC_user_input = "";

		0 = createdialog "SAC_1x14_panel";
		ctrlSetText [1800, " Mission Flow Interface "];

		ctrlSetText [1601, "End Mission Completed"]; ((findDisplay 3000) displayCtrl 1601) ctrlSetBackgroundColor [0.7,0,0,1];
		ctrlSetText [1602, "End Mission Failed"]; ((findDisplay 3000) displayCtrl 1602) ctrlSetBackgroundColor [0.7,0,0,1];
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
		ctrlSetText [1614, ""];
		ctrlSetFocus ((findDisplay 3000) displayCtrl 1614);

		waitUntil { !dialog };

		switch (SAC_user_input) do {
		
			case "End Mission Completed": {
			
				["Mission Complete", true] remoteExecCall ['BIS_fnc_endMission', 0];
				_exit = true;
				
			};
			case "End Mission Failed": {
			
				["Mission Failed", false] remoteExecCall ['BIS_fnc_endMission', 0];
				_exit = true;
			
			};
			
		};
		
	};

};

SAC_TRACK_OpenInterface = {

	private ["_pos", "_unit", "_loadout", "_uniformArray", "_vestArray", "_backpackArray", "_allItems"];

	SAC_user_input = "no yet initialized";

	private _exit = false;

	while {(not _exit) && (SAC_user_input != "")} do {

		SAC_user_input = "";
		
		0 = createdialog "SAC_1x14_panel";
		ctrlSetText [1800, " Functions & Debug Interface "];
		
		ctrlSetText [1601, "Debug..."];
		ctrlSetText [1602, "Loadout..."];
		ctrlSetText [1603, "Game Master..."];
		ctrlShow [1604, false ];
		ctrlSetText [1605, "Addons Verification"]; ((findDisplay 3000) displayCtrl 1605) ctrlSetBackgroundColor [0.7,0,0,1];
		ctrlShow [1606, false ];//ctrlSetText [1605, "Delete SAC_TRACK_cursorObject"];
		ctrlShow [1607, false ];//ctrlSetText [1606, "Hard Unstuck Units"];
		ctrlShow [1608, false ];
		ctrlShow [1609, false ];
		ctrlShow [1610, false ];
		ctrlShow [1611, false ];
		ctrlShow [1612, false ];
		ctrlShow [1613, false ];
		ctrlSetText [1614, ""];
		ctrlSetFocus ((findDisplay 3000) displayCtrl 1614);

		waitUntil { !dialog };

		switch (SAC_user_input) do
		{
			case "Debug...": {
			
				[] spawn SAC_TRACK_OpenDebugInterface;
				_exit = true;
				
			};
			case "Loadout...": {
			
				[] spawn SAC_TRACK_OpenLoadoutInterface;
				_exit = true;
				
			};
			case "Game Master...": {
			
				[] spawn SAC_TRACK_OpenGameMasterInterface;
				_exit = true;
				
			};
			case "Delete cursorObject": {
			
				deleteVehicle SAC_TRACK_cursorObject;
				_exit = true;
				
			};
			case "Hard Unstuck Units": {
			
				[] spawn {
				
					private ["_selectUnits", "_grp", "_unitNumber", "_unitColor"];
				
					_selectUnits = groupSelectedUnits player;

					if (count _selectUnits == 0) exitWith {hint parseText "<t color='#FF0000' size='1.2'><br/>You must select some units.<br/></t>"};
			
					{
					
						_unitNumber = _x call SAC_fnc_unitNumber;
						_unitColor = assignedTeam _x;
						
						_grp = createGroup SAC_PLAYER_SIDE;
						
						[_x] joinSilent _grp;
						
						sleep 0.5;
						
						_x joinAsSilent [group player, _unitNumber];
						
						//doStop _x;
						
						_x assignTeam _unitColor;
						
						sleep 1.5;
						
					} forEach _selectUnits;
					
				};
				
				_exit = true;
				
			};
			case "Addons Verification": {
			
				//["_sameSide", "_allPlayers", "_onlyConscious", "_sameGroupNPCs", "_includeMyGroup", "_includeSelected", "_includePointed"];
				private _unit = [false, true, false, false, false, false, false] call SAC_fnc_selectUnit;
				
				sac_request_activated_addons = name _unit;
				publicVariable "sac_request_activated_addons";
				
				_exit = true;
			
			};

		};
	};

};

if (SAC_TRACK_LeaveTrail) then {
	SAC_TRACK_Tracker = compile preProcessFileLineNumbers "SAC_TRACK\tracker_trailing.sqf";
} else {
	SAC_TRACK_Tracker = compile preProcessFileLineNumbers "SAC_TRACK\tracker3.sqf";
};

SAC_tracker_ON = false;
SAC_teleport = false;

_trg = createTrigger ["EmptyDetector",[1,0,0]];
_trg setTriggerActivation [_radioChannel, "PRESENT", true];
_trg setTriggerType "NONE";
_trg setTriggerStatements ["this","[] spawn SAC_TRACK_OpenInterface",""];
_trg setTriggerText "Tracker & Debug";

waitUntil {!isNull(findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["keyDown", {
	
	if (dialog) exitWith {false};
	
	private["_shift","_dik"]; 
	_dik = _this select 1; 
	_shift = _this select 2; 
	
	if (_dik in [72]) then {
	
		SAC_TRACK_cursorObject = cursorObject;
		
		systemChat typeOf SAC_TRACK_cursorObject;
		
		[] spawn SAC_TRACK_OpenInterface;
	
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
	
	if (_dik in [72]) then {
	
		[] spawn SAC_TRACK_OpenInterface;
	
		true
		
	} else {
	
		false
		
	};

}]; 

//player globalChat "Tracker & Debug initialized.";
