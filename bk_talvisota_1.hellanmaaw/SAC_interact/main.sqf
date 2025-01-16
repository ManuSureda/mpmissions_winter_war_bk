if (!hasInterface) exitWith {};
waitUntil {!isNull player};

#include "DIK_codes.h"

if (isnil "SAC_FNC") exitwith {hintC """SAC_FNC"" is not initialized in SAC_interact."};


SAC_interact_openInterface = {

	if (!isNull objectParent player) then {SAC_interact_cursorObject = vehicle player};
	
	SAC_interact_posibleActions = [];
	
	//encontrar todas las acciones válidas
	if (isNull (player getVariable ["sac_carried", objNull])) then {
	
		if (isNull SAC_interact_cursorObject) exitWith {};
	
		if ((SAC_interact_cursorObject getVariable ["SAC_interact_isHostage", false]) && {SAC_interact_cursorObject distance player < 3} && {alive SAC_interact_cursorObject}) then {SAC_interact_posibleActions pushBack "Liberar"}; 

		if (SAC_interact_cursorObject getVariable ["SAC_interact_name", ""] != "") then {SAC_interact_posibleActions pushBack "Identificar"}; 
		
		if ((SAC_interact_cursorObject getVariable ["SAC_interact_use", false]) && {SAC_interact_cursorObject distance player < 3}) then {SAC_interact_posibleActions pushBack "Usar"}; 
		
		if ((SAC_interact_cursorObject getVariable ["SAC_interact_shutdown_sat_comms", false]) && {SAC_interact_cursorObject distance player < 3}) then {SAC_interact_posibleActions pushBack "Terminar Enlace Satelital"}; 
		if ((SAC_interact_cursorObject getVariable ["SAC_interact_shutdown_radar", false]) && {SAC_interact_cursorObject distance player < 3}) then {SAC_interact_posibleActions pushBack "Apagar Radar"}; 
		if ((SAC_interact_cursorObject getVariable ["SAC_interact_disarm", false]) && {SAC_interact_cursorObject distance player < 3}) then {SAC_interact_posibleActions pushBack "Desactivar"}; 

		if ((SAC_interact_cursorObject getVariable ["SAC_interact_interrogar", false]) && {!(SAC_interact_cursorObject getVariable ["sac_incapacitated", false])} && {SAC_interact_cursorObject isKindOf "Man"} && {SAC_interact_cursorObject distance player < 3} && {alive SAC_interact_cursorObject}) then {SAC_interact_posibleActions pushBack "Interrogar"}; 
		
		if ((SAC_interact_cursorObject getVariable ["SAC_interact_arsenal", false]) && {SAC_interact_cursorObject distance player < 5} && {alive SAC_interact_cursorObject}) then {SAC_interact_posibleActions pushBack "Arsenal"}; 
		
		if ((alive SAC_interact_cursorObject) && {SAC_interact_cursorObject distance player < 5} && {((SAC_interact_cursorObject isKindOf "LandVehicle") || (SAC_interact_cursorObject isKindOf "Reammobox_F")) && {[getPos SAC_interact_cursorObject, SAC_GEAR_resupplyPoints] call SAC_fnc_isBlacklisted}}) then {SAC_interact_posibleActions pushBack "Cargar suministros"}; 
		
		if ((!SAC_ACE) && {SAC_interact_cursorObject isKindOf "Man"} && {!(SAC_interact_cursorObject getVariable ["SAC_interact_isDetainee", false])} && {SAC_interact_cursorObject distance player < 1.5} && {alive SAC_interact_cursorObject} && {currentWeapon SAC_interact_cursorObject == ""} && {!(SAC_interact_cursorObject getVariable ["SAC_interact_isHostage", false])}) then {SAC_interact_posibleActions pushBack "Precintar"}; 
		if ((!SAC_ACE) && {SAC_interact_cursorObject getVariable ["SAC_interact_isDetainee", false]} && {SAC_interact_cursorObject distance player < 1.5} && {alive SAC_interact_cursorObject}) then {SAC_interact_posibleActions pushBack "Quitar Precinto"}; 

		if ((SAC_interact_cursorObject isKindOf "Man") && {vest SAC_interact_cursorObject == ""} && {SAC_interact_cursorObject distance player < 2} && {alive SAC_interact_cursorObject}) then {SAC_interact_posibleActions pushBack "Dar chaleco"}; 

		if ((SAC_interact_cursorObject isKindOf "Man") && {group SAC_interact_cursorObject == group player} && {count weapons SAC_interact_cursorObject == 0} && {SAC_interact_cursorObject distance player < 2} && {alive SAC_interact_cursorObject}) then {SAC_interact_posibleActions pushBack "Dar arma"}; 

		if ((SAC_interact_cursorObject isKindOf "Man") && {group SAC_interact_cursorObject == group player} && {vest SAC_interact_cursorObject == ""} && {count weapons SAC_interact_cursorObject == 0} && {SAC_interact_cursorObject distance player < 2} && {alive SAC_interact_cursorObject}) then {SAC_interact_posibleActions pushBack "Dar chaleco y arma"}; 

		if (SAC_interact_cursorObject getVariable ["sac_incapacitated", false] && {SAC_interact_cursorObject distance player < 3}) then {SAC_interact_posibleActions pushBack "Revivir"}; 
		
		if (SAC_interact_cursorObject getVariable ["sac_incapacitated", false] && {SAC_interact_cursorObject distance player < 3}) then {SAC_interact_posibleActions pushBack "Carry"}; 
		
		//if ((alive SAC_interact_cursorObject) && {SAC_interact_cursorObject distance player < 5} && {{SAC_interact_cursorObject isKindOf _x} count ["LandVehicle", "Air"] > 0} && {{alive _x} count crew SAC_interact_cursorObject == 0} && {locked SAC_interact_cursorObject != 2}) then {SAC_interact_posibleActions pushBack "Bloquear"}; 
		//if ((alive SAC_interact_cursorObject) && {SAC_interact_cursorObject distance player < 5} && {{SAC_interact_cursorObject isKindOf _x} count ["LandVehicle", "Air"] > 0} && {!alive driver SAC_interact_cursorObject || {alive driver SAC_interact_cursorObject && isPlayer driver SAC_interact_cursorObject}} && {locked SAC_interact_cursorObject != 2}) then {SAC_interact_posibleActions pushBack "Bloquear"}; 
		if ((alive SAC_interact_cursorObject) && {SAC_interact_cursorObject distance player < 5} && {{SAC_interact_cursorObject isKindOf _x} count ["LandVehicle", "Air", "Ship"] > 0} && {!(alive driver SAC_interact_cursorObject && !isPlayer driver SAC_interact_cursorObject)} && {locked SAC_interact_cursorObject != 2}) then {SAC_interact_posibleActions pushBack "Bloquear"}; 
		
		if ((alive SAC_interact_cursorObject) && {SAC_interact_cursorObject distance player < 5} && {{SAC_interact_cursorObject isKindOf _x} count ["LandVehicle", "Air", "Ship"] > 0} && {!(alive driver SAC_interact_cursorObject && !isPlayer driver SAC_interact_cursorObject)} && {locked SAC_interact_cursorObject in [2,3]}) then {SAC_interact_posibleActions pushBack "Desbloquear"}; 
		
		if ((!SAC_ACE) && {SAC_interact_cursorObject distance player < 5} && {(SAC_interact_cursorObject isKindOf "Man") || {SAC_interact_cursorObject isKindOf "Car"} || {SAC_interact_cursorObject isKindOf "Helicopter"} || {SAC_interact_cursorObject isKindOf "Ship"} || {SAC_interact_cursorObject isKindOf "Ammobox"} || {SAC_interact_cursorObject isKindOf "WeaponHolderSimulated"} || {SAC_interact_cursorObject isKindOf "WeaponHolder"}}) then {SAC_interact_posibleActions pushBack "Abrir inventario"}; 

		if (!isNull objectParent player) then {SAC_interact_posibleActions pushBack "Salir del Vehiculo"}; 
		
		if (SAC_interact_cursorObject getVariable ["sac_has_blackbox", false] && {SAC_interact_cursorObject distance player < 5}) then {SAC_interact_posibleActions pushBack "Remover Caja Negra"}; 

	} else {
	
		SAC_interact_posibleActions pushBack "Drop Carrying";
		
		if (SAC_interact_cursorObject isKindOf "LandVehicle" || SAC_interact_cursorObject isKindOf "Helicopter" || SAC_interact_cursorObject isKindOf "Ship") then {
		
			SAC_interact_posibleActions pushBack "Load Carrying Into Vehicle";
		
		};
	
	};
		
	if (count SAC_interact_posibleActions == 0) exitWith {
	
		//el problema de este código es que se ejecuta cuando las unidades tienen interacciones pero están muy lejos, por ejemplo, y entonces se vuelve confuso
		//systemChat typeOf SAC_interact_cursorObject;
		private _objectType = switch (true) do {
		
			case (SAC_interact_cursorObject isKindOf "Man"): {
			
				"hombre"
			
			};
			case (SAC_interact_cursorObject isKindOf "Car"): {
			
				"vehículo"
			
			};
			case (SAC_interact_cursorObject isKindOf "Helicopter"): {
			
				"helicóptero"
			
			};
			case (SAC_interact_cursorObject isKindOf "Building"): {
			
				"edificio"
			
			};
			default {
			
				"default"
			
			};
		
		};
		
		if (_objectType != "default") then {
		
			hint (parseText format["<t color='#00FFFF' size='1.2'><br/>No se puede interactuar con este %1.<br/><br/></t>", _objectType])
			
		} else {
		
			hint (parseText "<t color='#00FFFF' size='1.2'><br/>No se detecta objeto valido.<br/><br/></t>")
		
		};
		
	};
	
	//generar los botones
	SAC_user_input = "";
	
	0 = createdialog "SAC_1x14_panel";
	ctrlSetText [1800, " SAC Interact "];
	
	private _k = 1;
	{
	
		ctrlSetText [1600 + _k, _x];
	
		_k = _k + 1;
	
	} forEach SAC_interact_posibleActions;
	
	if (_k < 15) then {
	
		for [{_c=_k},{_c<=14},{_c=_c+1}] do {
		
			ctrlShow [1600 + _c, false ];
		
		};
	
	};
	
	
	waitUntil { !dialog };
	
	if (SAC_user_input == "") exitWith {};
	
	//procesar el botón seleccionado
	switch (SAC_user_input) do
	{
		case "Liberar": {

			if ((alive SAC_interact_cursorObject) && {SAC_interact_cursorObject distance player < 3} && {SAC_interact_cursorObject getVariable ["SAC_interact_isHostage", false]}) then {
			
				[[SAC_interact_cursorObject]] remoteExec ["SAC_fnc_releaseHostage", SAC_interact_cursorObject, false];
			
			}; 
			
		};
		case "Dar chaleco": {

			if ((vest SAC_interact_cursorObject == "") && {SAC_interact_cursorObject distance player < 2}) then {
			
				SAC_interact_cursorObject addVest "V_TacVest_blk";
			
			}; 
			
		};
		case "Dar arma": {

			if ((count weapons SAC_interact_cursorObject == 0) && {SAC_interact_cursorObject distance player < 2} && {alive SAC_interact_cursorObject}) then {
			
				//[SAC_interact_cursorObject] spawn SAC_GEAR_fnc_orderTakeWeaponFromDeadUnit;
				
				[SAC_interact_cursorObject] remoteExec ["SAC_GEAR_fnc_orderTakeWeaponFromDeadUnit", SAC_interact_cursorObject];
			
			}; 
			
		};
		case "Dar chaleco y arma": {

			if ((vest SAC_interact_cursorObject == "") && {count weapons SAC_interact_cursorObject == 0} && {SAC_interact_cursorObject distance player < 2} && {alive SAC_interact_cursorObject}) then {
			
				SAC_interact_cursorObject addVest "V_TacVest_blk";
				[SAC_interact_cursorObject] remoteExec ["SAC_GEAR_fnc_orderTakeWeaponFromDeadUnit", SAC_interact_cursorObject];
			
			}; 
			
		};
		case "Quitar Precinto": {

			if ((SAC_interact_cursorObject getVariable ["SAC_interact_isDetainee", false]) && {SAC_interact_cursorObject distance player < 1.5} && {alive SAC_interact_cursorObject}) then {
			
				[[SAC_interact_cursorObject]] remoteExec ["SAC_fnc_releaseDetainee", SAC_interact_cursorObject, false];
			
			}; 
			
		};
		case "Precintar": {

			if ((!(SAC_interact_cursorObject getVariable ["SAC_interact_isDetainee", false])) && {SAC_interact_cursorObject distance player < 1.5} && {alive SAC_interact_cursorObject} && {currentWeapon SAC_interact_cursorObject == ""}) then {
			
				[[SAC_interact_cursorObject]] remoteExec ["SAC_fnc_detainPerson", SAC_interact_cursorObject, false];
			
			}; 
			
		};
		case "Abrir inventario": {

			if (SAC_interact_cursorObject distance player < 5) then {
			
				player action ["Gear", SAC_interact_cursorObject];
			
			}; 
			
		};
		case "Identificar": {

			if (SAC_interact_cursorObject getVariable ["SAC_interact_name", ""] in ["", "anybody", "nobody"]) then {
			
				["NO ES EL OBJETIVO"] call SAC_fnc_titleText;
			
			} else {
			
				//titleText [format ["%1 LOCALIZADO", SAC_interact_cursorObject getVariable ["SAC_interact_name", ""]], "PLAIN"];
				[format ["%1", SAC_interact_cursorObject getVariable ["SAC_interact_name", ""]]] call SAC_fnc_titleText;
				
			};
			
			//falta poner algo que diga 'enviando imagenes...' y que despues de 2 o 3 segundos de el resultado
			
		};
		case "Usar": {

			if ((SAC_interact_cursorObject distance player < 3) && {SAC_interact_cursorObject getVariable ["SAC_interact_use", false]}) then {
			
				if !([SAC_interact_cursorObject getVariable ["SAC_access_code", ""]] call SAC_fnc_passwordCheck) exitWith {};
			
				if !(SAC_interact_cursorObject getVariable ["SAC_interact_use", false]) exitWith {};
			
				SAC_interact_cursorObject setVariable ["SAC_interact_use", false, true];

				[] spawn {
				
					private _percentagePerSecond = 10;
					
					for [{_c=0},{_c<=100},{_c=_c+_percentagePerSecond}] do {
					
						systemChat format ["%1 completado", _c];
						
						sleep 1;
						
					};
					
				};
					
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealHiddenTargets", false]) then {
					
					[] spawn {
					
						sleep 12;
						
						[SAC_hiddenTargetObjects] call SAC_fnc_markObjectsPositions;
						
						[] call SAC_interact_handleRevealNotifications;
						
					};
				
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealHiddenTargets_2", false]) then {
					
					[] spawn {
					
						sleep 12;
						
						[SAC_hiddenTargetObjects_2] call SAC_fnc_markObjectsPositions;
						
						[] call SAC_interact_handleRevealNotifications_2;
						
					};
				
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealHiddenTargets_3", false]) then {
					
					[] spawn {
					
						sleep 12;
						
						[SAC_hiddenTargetObjects_3] call SAC_fnc_markObjectsPositions;
						
						[] call SAC_interact_handleRevealNotifications_3;
						
					};
				
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealPasswords", false]) then {
					
					[] spawn {
					
						sleep 12;
						
						[] call SAC_interact_handleRevealPasswords;
						
					};

				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealPasswords_2", false]) then {

					[] spawn {
					
						sleep 12;
						
						[] call SAC_interact_handleRevealPasswords_2;
						
					};

				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealPasswords_3", false]) then {

					[] spawn {
					
						sleep 12;
						
						[] call SAC_interact_handleRevealPasswords_3;
						
					};

				};

				if ((SAC_interact_cursorObject getVariable ["SAC_interact_csar", false]) && {SAC_COP_CSAR_can_generate}) then {

					SAC_interact_cursorObject setVariable ["SAC_interact_csar", false, true];
					
					[] spawn {
					
						sleep 12;
						
						[] remoteExec ["SAC_COP_fnc_dyn_CSAR", 2, false];
						
						SAC_COP_CSAR_can_generate = false; publicVariable "SAC_COP_CSAR_can_generate";
						
						//systemChat "SE MARCARON NUEVAS POSICIONES EN TU MAPA.";
						
					};
				
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_killTarget", false] && {SAC_COP_DKT_can_generate}) then {
				
					SAC_interact_cursorObject setVariable ["SAC_interact_killTarget", false, true];
				
					[] spawn {
					
						sleep 12;
						
						[] remoteExec ["SAC_COP_fnc_dyn_killTarget", 2, false];
						
						SAC_COP_DKT_can_generate = false; publicVariable "SAC_COP_DKT_can_generate";
						
					};
				
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_download", false]) then {
				
					SAC_interact_cursorObject setVariable ["SAC_interact_download", false, true];

					[] spawn {
					
						sleep 12;
						
						"INFORMACION DESCARGADA" call SAC_fnc_MPtitleText;

					};
					
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_hack", false]) then {
				
					SAC_interact_cursorObject setVariable ["SAC_interact_hack", false, true];

					[] spawn {
					
						sleep 12;
						
						"HACKEO TERMINADO" call SAC_fnc_MPtitleText;

					};
					
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_searchDocuments", false]) then {
				
					SAC_interact_cursorObject setVariable ["SAC_interact_searchDocuments", false, true];

					[] spawn {
					
						sleep 12;
						
						"DOCUMENTOS ENCONTRADOS" call SAC_fnc_MPtitleText;

					};
					
				};
				
			};
		
		};
		case "Terminar Enlace Satelital": {

			if ((SAC_interact_cursorObject distance player < 3) && {SAC_interact_cursorObject getVariable ["SAC_interact_shutdown_sat_comms", false]}) then {
			
				if !([SAC_interact_cursorObject getVariable ["SAC_access_code", ""]] call SAC_fnc_passwordCheck) exitWith {};
			
				if !(SAC_interact_cursorObject getVariable ["SAC_interact_shutdown_sat_comms", false]) exitWith {};
			
				SAC_interact_cursorObject setVariable ["SAC_interact_shutdown_sat_comms", false, true];

				[] spawn {
				
					private _percentagePerSecond = 10;
					
					for [{_c=0},{_c<=100},{_c=_c+_percentagePerSecond}] do {
					
						systemChat format ["%1 completado", _c];
						
						sleep 1;
						
					};
					
					systemChat "Enlace satelital terminado.";
					//titleText ["<t color='#F7FF9E' size='2'>ENLACE SATELITAL TERMINADO</t>", "PLAIN", -1, true, true]
					"ENLACE SATELITAL TERMINADO" call SAC_fnc_MPtitleText;
					
				};					
				
			};
		
		};
		case "Apagar Radar": {

			if ((SAC_interact_cursorObject distance player < 3) && {SAC_interact_cursorObject getVariable ["SAC_interact_shutdown_radar", false]}) then {
			
				if !([SAC_interact_cursorObject getVariable ["SAC_access_code", ""]] call SAC_fnc_passwordCheck) exitWith {};
			
				if !(SAC_interact_cursorObject getVariable ["SAC_interact_shutdown_radar", false]) exitWith {};
			
				SAC_interact_cursorObject setVariable ["SAC_interact_shutdown_radar", false, true];

				[] spawn {
				
					private _percentagePerSecond = 10;
					
					for [{_c=0},{_c<=100},{_c=_c+_percentagePerSecond}] do {
					
						systemChat format ["%1 completado", _c];
						
						sleep 1;
						
					};
					
					systemChat "Radar apagado.";
					"RADAR APAGADO" call SAC_fnc_MPtitleText;
					
				};					
				
			};
		
		};
		case "Desactivar": {

			if ((SAC_interact_cursorObject distance player < 3) && {SAC_interact_cursorObject getVariable ["SAC_interact_disarm", false]}) then {
			
				if !([SAC_interact_cursorObject getVariable ["SAC_access_code", ""]] call SAC_fnc_passwordCheck) exitWith {};
			
				if !(SAC_interact_cursorObject getVariable ["SAC_interact_disarm", false]) exitWith {};
			
				SAC_interact_cursorObject setVariable ["SAC_interact_disarm", false, true];

				[] spawn {
				
					private _percentagePerSecond = 10;
					
					for [{_c=0},{_c<=100},{_c=_c+_percentagePerSecond}] do {
					
						systemChat format ["%1 completado", _c];
						
						sleep 1;
						
					};
					
					systemChat "Desactivado.";
					//titleText ["<t color='#F7FF9E' size='2'>ENLACE SATELITAL TERMINADO</t>", "PLAIN", -1, true, true]
					"DESACTIVADO" call SAC_fnc_MPtitleText;
					
				};					
				
			};
		
		};
		case "Interrogar": {
		
			if ((SAC_interact_cursorObject getVariable ["SAC_interact_interrogar", false]) && {SAC_interact_cursorObject distance player < 5} && {alive SAC_interact_cursorObject}) then {
			
				SAC_interact_cursorObject setVariable ["SAC_interact_interrogar", false, true];
				
				if ((SAC_interact_cursorObject getVariable ["SAC_interact_csar", false]) && {SAC_COP_CSAR_can_generate}) then {
				
					SAC_interact_cursorObject setVariable ["SAC_interact_csar", false, true];
					
					[] remoteExec ["SAC_COP_fnc_dyn_CSAR", 2, false];
					
					SAC_COP_CSAR_can_generate = false; publicVariable "SAC_COP_CSAR_can_generate";
				
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_killTarget", false] && {SAC_COP_DKT_can_generate}) then {
				
					SAC_interact_cursorObject setVariable ["SAC_interact_killTarget", false, true];
					
					[] remoteExec ["SAC_COP_fnc_dyn_killTarget", 2, false];
					
					SAC_COP_DKT_can_generate = false; publicVariable "SAC_COP_DKT_can_generate";
				
				};
				if (count (SAC_interact_cursorObject getVariable ["SAC_interact_2ndGroupLocation", []]) > 0) then {
				
					[SAC_interact_cursorObject getVariable ["SAC_interact_2ndGroupLocation", [0,0,0]], "ColorRed", " 2do grupo", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;
					
					SAC_interact_cursorObject setVariable ["SAC_interact_2ndGroupLocation", [], true];
					
					systemChat "SE MARCARON NUEVAS POSICIONES EN TU MAPA.";
					
				};
				if (count (SAC_interact_cursorObject getVariable ["SAC_interact_crashLocation", []]) > 0) then {
				
					[SAC_interact_cursorObject getVariable ["SAC_interact_crashLocation", [0,0,0]], "ColorRed", " Vehículo", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;
					
					SAC_interact_cursorObject setVariable ["SAC_interact_crashLocation", [], true];
					
					systemChat "SE MARCARON NUEVAS POSICIONES EN TU MAPA.";
				
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealHiddenTargets", false]) then {
					
					[SAC_hiddenTargetObjects] call SAC_fnc_markObjectsPositions;
					
					[] call SAC_interact_handleRevealNotifications;
				
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealHiddenTargets_2", false]) then {
					
					[SAC_hiddenTargetObjects_2] call SAC_fnc_markObjectsPositions;
					
					[] call SAC_interact_handleRevealNotifications_2;
				
				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealHiddenTargets_3", false]) then {
					
					[SAC_hiddenTargetObjects_3] call SAC_fnc_markObjectsPositions;
					
					[] call SAC_interact_handleRevealNotifications_3;
				
				};

				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealPasswords", false]) then {

					[] call SAC_interact_handleRevealPasswords;

				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealPasswords_2", false]) then {

					[] call SAC_interact_handleRevealPasswords_2;

				};
				if (SAC_interact_cursorObject getVariable ["SAC_interact_revealPasswords_3", false]) then {

					[] call SAC_interact_handleRevealPasswords_3;

				};
				
			};

		};
		case "Arsenal": {

			["Open", true] spawn BIS_fnc_arsenal;
			
		};
		case "Cargar suministros": {

			[SAC_interact_cursorObject] spawn SAC_GEAR_fnc_activateSupplies;
			
			systemChat format ["Se cargaron suministros a %1", (typeOf SAC_interact_cursorObject) call SAC_fnc_displayName];
			
		};
		case "Revivir": {
		
			player playActionNow "MedicOther";
			sleep 5;
			
			SAC_interact_cursorObject call SAC_fnc_healUnit;

		};
		case "Carry": {
		
			SAC_interact_cursorObject call SAC_fnc_carryUnit;

		};
		case "Drop Carrying": {
		
			[] call SAC_fnc_dropCarrying;

		};
		case "Load Carrying Into Vehicle": {
		
			[SAC_interact_cursorObject] call SAC_fnc_LoadCarrying;

		};
		case "Bloquear": {
			
			//if (!alive driver SAC_interact_cursorObject || {alive driver SAC_interact_cursorObject && isPlayer driver SAC_interact_cursorObject}) then {
			if !(alive driver SAC_interact_cursorObject && !isPlayer driver SAC_interact_cursorObject && locked SAC_interact_cursorObject != 2) then {
			
				[SAC_interact_cursorObject, true] remoteExec ["lock", SAC_interact_cursorObject, false];
				[SAC_interact_cursorObject, "sac_sounds_car_alarm_on"] remoteExec ["say3D"];
				
			};
		
		};
		case "Desbloquear": {
		
			//if (!alive driver SAC_interact_cursorObject || {alive driver SAC_interact_cursorObject && isPlayer driver SAC_interact_cursorObject}) then {
			if !(alive driver SAC_interact_cursorObject && !isPlayer driver SAC_interact_cursorObject && {locked SAC_interact_cursorObject in [2,3]}) then {
			
				[SAC_interact_cursorObject, false] remoteExec ["lock", SAC_interact_cursorObject, false];
				[SAC_interact_cursorObject, "sac_sounds_car_alarm_off"] remoteExec ["say3D"];
				
			};
		
		};
		case "Salir del Vehiculo": {
		
			moveOut player;
		
		};
		case "Remover Caja Negra": {

			if (SAC_interact_cursorObject getVariable ["sac_has_blackbox", false] && {SAC_interact_cursorObject distance player < 5}) then {
			
				SAC_interact_cursorObject setVariable ["sac_has_blackbox", false, true];

				[] spawn {
				
					private _percentagePerSecond = 1;
					
					for [{_c=0},{_c<=100},{_c=_c+_percentagePerSecond}] do {
					
						systemChat format ["%1 completado", _c];
						
						sleep 1;
						
					};
					
					systemChat "CAJA NEGRA RECUPERADA.";
					
				};
				
			};
		
		};
		default {SAC_user_input = ""};
	};
	
	
};

SAC_interact_openSelfInterface = {

	private _exit = false;
/*	
	private _colorViewDistanceBelow = [0.75,0,0,1];
	private _colorViewDistanceAbove = [0.3,0,0,1];
	private _colorObjectViewDistanceBelow = [0,0,0.75,1];
	private _colorObjectViewDistanceAbove = [0,0,0.3,1];*/
	private _colorViewDistanceBelow = [0.75,0.75,0,1];
	private _colorViewDistanceAbove = [0.3,0.3,0,1];
	private _colorObjectViewDistanceBelow = [0,0.75,0,1];
	private _colorObjectViewDistanceAbove = [0,0.3,0,1];
	
	SAC_user_input = "not yet initialized";
	
	while {(not _exit) && (SAC_user_input != "")} do {

		SAC_user_input = "";
		
		0 = createdialog "SAC_4x16_panel";
		//ctrlSetText [1800, format[" Ajustar ViewDistance (Actual Terreno: %1 Objetos: %2 )", viewDistance, getObjectViewDistance select 0]];
		[] spawn {sleep 0.01; ctrlSetText [1800, format[" Ajustar ViewDistance (Actual Terreno %1 Objetos [%2] )", viewDistance, getObjectViewDistance select 0]];};

		((findDisplay 3000) displayCtrl 1601) ctrlSetTextColor (if (1000 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {[1,0,0,1]});
		ctrlSetText [1601, "1000"];
		((findDisplay 3000) displayCtrl 1602) ctrlSetTextColor (if (1200 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText [1602, "1200"];
		((findDisplay 3000) displayCtrl 1603) ctrlSetTextColor (if (1400 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText [1603, "1400"];
		((findDisplay 3000) displayCtrl 1604) ctrlSetTextColor (if (1600 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText [1604, "1600"];
		((findDisplay 3000) displayCtrl 1605) ctrlSetTextColor (if (1800 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1605, "1800"];
		((findDisplay 3000) displayCtrl 1606) ctrlSetTextColor (if (2000 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1606, "2000"];
		((findDisplay 3000) displayCtrl 1607) ctrlSetTextColor (if (2200 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1607, "2200"];
		((findDisplay 3000) displayCtrl 1608) ctrlSetTextColor (if (2400 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1608, "2400"];
		((findDisplay 3000) displayCtrl 1609) ctrlSetTextColor (if (2600 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1609, "2600"];
		((findDisplay 3000) displayCtrl 1610) ctrlSetTextColor (if (2800 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1610, "2800"];
		((findDisplay 3000) displayCtrl 1611) ctrlSetTextColor (if (3000 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1611, "3000"];
		((findDisplay 3000) displayCtrl 1612) ctrlSetTextColor (if (3200 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1612, "3200"];
		((findDisplay 3000) displayCtrl 1613) ctrlSetTextColor (if (3400 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1613, "3400"];
		((findDisplay 3000) displayCtrl 1614) ctrlSetTextColor (if (3600 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1614, "3600"];
		((findDisplay 3000) displayCtrl 1615) ctrlSetTextColor (if (3800 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1615, "3800"];
		((findDisplay 3000) displayCtrl 1616) ctrlSetTextColor (if (4000 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1616, "4000"];
		
		((findDisplay 3000) displayCtrl 1617) ctrlSetTextColor (if (4200 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1617, "4200"];
		((findDisplay 3000) displayCtrl 1618) ctrlSetTextColor (if (4400 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1618, "4400"];
		((findDisplay 3000) displayCtrl 1619) ctrlSetTextColor (if (4600 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1619, "4600"];
		((findDisplay 3000) displayCtrl 1620) ctrlSetTextColor (if (4800 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1620, "4800"];
		((findDisplay 3000) displayCtrl 1621) ctrlSetTextColor (if (5000 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1621, "5000"];
		((findDisplay 3000) displayCtrl 1622) ctrlSetTextColor (if (5200 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1622, "5200"];
		((findDisplay 3000) displayCtrl 1623) ctrlSetTextColor (if (5400 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1623, "5400"];
		((findDisplay 3000) displayCtrl 1624) ctrlSetTextColor (if (5600 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1624, "5600"];
		((findDisplay 3000) displayCtrl 1625) ctrlSetTextColor (if (5800 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1625, "5800"];
		((findDisplay 3000) displayCtrl 1626) ctrlSetTextColor (if (6000 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1626, "6000"];
		((findDisplay 3000) displayCtrl 1627) ctrlSetTextColor (if (6200 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1627, "6200"];
		((findDisplay 3000) displayCtrl 1628) ctrlSetTextColor (if (6400 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1628, "6400"];
		((findDisplay 3000) displayCtrl 1629) ctrlSetTextColor (if (6600 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1629, "6600"];
		((findDisplay 3000) displayCtrl 1630) ctrlSetTextColor (if (6800 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1630, "6800"];
		((findDisplay 3000) displayCtrl 1631) ctrlSetTextColor (if (7000 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1631, "7000"];
		((findDisplay 3000) displayCtrl 1632) ctrlSetTextColor (if (7200 <= SAC_initialViewDistance) then {_colorViewDistanceBelow} else {_colorViewDistanceAbove});
		ctrlSetText[1632, "7200"];

		((findDisplay 3000) displayCtrl 1633) ctrlSetTextColor (if (1000 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1633, "[1000]"];
		((findDisplay 3000) displayCtrl 1634) ctrlSetTextColor (if (1200 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1634, "[1200]"];
		((findDisplay 3000) displayCtrl 1635) ctrlSetTextColor (if (1400 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1635, "[1400]"];
		((findDisplay 3000) displayCtrl 1636) ctrlSetTextColor (if (1600 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1636, "[1600]"];
		((findDisplay 3000) displayCtrl 1637) ctrlSetTextColor (if (1800 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1637, "[1800]"];
		((findDisplay 3000) displayCtrl 1638) ctrlSetTextColor (if (2000 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1638, "[2000]"];
		((findDisplay 3000) displayCtrl 1639) ctrlSetTextColor (if (2200 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1639, "[2200]"];
		((findDisplay 3000) displayCtrl 1640) ctrlSetTextColor (if (2400 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1640, "[2400]"];
		((findDisplay 3000) displayCtrl 1641) ctrlSetTextColor (if (2600 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1641, "[2600]"];
		((findDisplay 3000) displayCtrl 1642) ctrlSetTextColor (if (2800 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1642, "[2800]"];
		((findDisplay 3000) displayCtrl 1643) ctrlSetTextColor (if (3000 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1643, "[3000]"];
		((findDisplay 3000) displayCtrl 1644) ctrlSetTextColor (if (3200 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1644, "[3200]"];
		((findDisplay 3000) displayCtrl 1645) ctrlSetTextColor (if (3400 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1645, "[3400]"];
		((findDisplay 3000) displayCtrl 1646) ctrlSetTextColor (if (3600 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1646, "[3600]"];
		((findDisplay 3000) displayCtrl 1647) ctrlSetTextColor (if (3800 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1647, "[3800]"];
		((findDisplay 3000) displayCtrl 1648) ctrlSetTextColor (if (4000 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1648, "[4000]"];
		
		((findDisplay 3000) displayCtrl 1649) ctrlSetTextColor (if (4200 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1649, "[4200]"];
		((findDisplay 3000) displayCtrl 1650) ctrlSetTextColor (if (4400 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1650, "[4400]"];
		((findDisplay 3000) displayCtrl 1651) ctrlSetTextColor (if (4600 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1651, "[4600]"];
		((findDisplay 3000) displayCtrl 1652) ctrlSetTextColor (if (4800 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1652, "[4800]"];
		((findDisplay 3000) displayCtrl 1653) ctrlSetTextColor (if (5000 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1653, "[5000]"];
		((findDisplay 3000) displayCtrl 1654) ctrlSetTextColor (if (5200 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1654, "[5200]"];
		((findDisplay 3000) displayCtrl 1655) ctrlSetTextColor (if (5400 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1655, "[5400]"];
		((findDisplay 3000) displayCtrl 1656) ctrlSetTextColor (if (5600 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1656, "[5600]"];
		((findDisplay 3000) displayCtrl 1657) ctrlSetTextColor (if (5800 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1657, "[5800]"];
		((findDisplay 3000) displayCtrl 1658) ctrlSetTextColor (if (6000 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1658, "[6000]"];
		((findDisplay 3000) displayCtrl 1659) ctrlSetTextColor (if (6200 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1659, "[6200]"];
		((findDisplay 3000) displayCtrl 1660) ctrlSetTextColor (if (6400 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1660, "[6400]"];
		((findDisplay 3000) displayCtrl 1661) ctrlSetTextColor (if (6600 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1661, "[6600]"];
		((findDisplay 3000) displayCtrl 1662) ctrlSetTextColor (if (6800 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1662, "[6800]"];
		((findDisplay 3000) displayCtrl 1663) ctrlSetTextColor (if (7000 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1663, "[7000]"];
		((findDisplay 3000) displayCtrl 1664) ctrlSetTextColor (if (7200 <= SAC_initialObjectViewDistance) then {_colorObjectViewDistanceBelow} else {_colorObjectViewDistanceAbove});
		ctrlSetText [1664, "[7200]"];
		
		waitUntil { !dialog };

		switch (SAC_user_input) do {
		
			case "1000": {setViewDistance 1000};
			case "1200": {setViewDistance 1200};
			case "1400": {setViewDistance 1400};
			case "1600": {setViewDistance 1600};
			case "1800": {setViewDistance 1800};
			case "2000": {setViewDistance 2000};
			case "2200": {setViewDistance 2200};
			case "2400": {setViewDistance 2400};
			case "2600": {setViewDistance 2600};
			case "2800": {setViewDistance 2800};
			case "3000": {setViewDistance 3000};
			case "3200": {setViewDistance 3200};
			case "3400": {setViewDistance 3400};
			case "3600": {setViewDistance 3600};
			case "3800": {setViewDistance 3800};
			case "4000": {setViewDistance 4000};
			case "4200": {setViewDistance 4200};
			case "4400": {setViewDistance 4400};
			case "4600": {setViewDistance 4600};
			case "4800": {setViewDistance 4800};
			case "5000": {setViewDistance 5000};
			case "5200": {setViewDistance 5200};
			case "5400": {setViewDistance 5400};
			case "5600": {setViewDistance 5600};
			case "5800": {setViewDistance 5800};
			case "6000": {setViewDistance 6000};
			case "6200": {setViewDistance 6200};
			case "6400": {setViewDistance 6400};
			case "6600": {setViewDistance 6600};
			case "6800": {setViewDistance 6800};
			case "7000": {setViewDistance 7000};
			case "7200": {setViewDistance 7200};
		
			case "[1000]": {setObjectViewDistance 1000};
			case "[1200]": {setObjectViewDistance 1200};
			case "[1400]": {setObjectViewDistance 1400};
			case "[1600]": {setObjectViewDistance 1600};
			case "[1800]": {setObjectViewDistance 1800};
			case "[2000]": {setObjectViewDistance 2000};
			case "[2200]": {setObjectViewDistance 2200};
			case "[2400]": {setObjectViewDistance 2400};
			case "[2600]": {setObjectViewDistance 2600};
			case "[2800]": {setObjectViewDistance 2800};
			case "[3000]": {setObjectViewDistance 3000};
			case "[3200]": {setObjectViewDistance 3200};
			case "[3400]": {setObjectViewDistance 3400};
			case "[3600]": {setObjectViewDistance 3600};
			case "[3800]": {setObjectViewDistance 3800};
			case "[4000]": {setObjectViewDistance 4000};
			case "[4200]": {setObjectViewDistance 4200};
			case "[4400]": {setObjectViewDistance 4400};
			case "[4600]": {setObjectViewDistance 4600};
			case "[4800]": {setObjectViewDistance 4800};
			case "[5000]": {setObjectViewDistance 5000};
			case "[5200]": {setObjectViewDistance 5200};
			case "[5400]": {setObjectViewDistance 5400};
			case "[5600]": {setObjectViewDistance 5600};
			case "[5800]": {setObjectViewDistance 5800};
			case "[6000]": {setObjectViewDistance 6000};
			case "[6200]": {setObjectViewDistance 6200};
			case "[6400]": {setObjectViewDistance 6400};
			case "[6600]": {setObjectViewDistance 6600};
			case "[6800]": {setObjectViewDistance 6800};
			case "[7000]": {setObjectViewDistance 7000};
			case "[7200]": {setObjectViewDistance 7200};
		};
		
	};

};

SAC_interact_handleRevealNotifications = {

	if ((!isNil "SAC_COP_reveal_1_flag") && {SAC_COP_reveal_1_flag == false}) then { 
	
		if ((!isNil "SAC_COP_reveal_createDiaryEntry") && {SAC_COP_reveal_createDiaryEntry}) then {
		
			{player createDiarySubject  [SAC_COP_reveal_diaryEntrySubject, SAC_COP_reveal_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
			{player createDiaryRecord  [SAC_COP_reveal_diaryEntrySubject, [SAC_COP_reveal_diaryEntryTitle, SAC_COP_reveal_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
		
			(parseText SAC_COP_reveal_diaryEntryDescription) call SAC_fnc_MPhint; 
		
		};
		
		if ((!isNil "SAC_COP_reveal_useSpecialSystemChatText") && {SAC_COP_reveal_useSpecialSystemChatText}) then {
		
			// SAC_COP_reveal_specialSystemChatText call SAC_fnc_MPsystemChat; 
		
		} else {
		
			// "SE MARCARON NUEVAS POSICIONES EN TU MAPA." call SAC_fnc_MPsystemChat; 
			
		};
	};
	SAC_COP_reveal_1_flag = true;
};

SAC_interact_handleRevealNotifications_2 = {
	if ((!isNil "SAC_COP_reveal_2_flag") && {SAC_COP_reveal_2_flag == false}) then { 
	
		if ((!isNil "SAC_COP_reveal_2_createDiaryEntry") && {SAC_COP_reveal_2_createDiaryEntry}) then {
		
			{player createDiarySubject  [SAC_COP_reveal_2_diaryEntrySubject, SAC_COP_reveal_2_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
			{player createDiaryRecord  [SAC_COP_reveal_2_diaryEntrySubject, [SAC_COP_reveal_2_diaryEntryTitle, SAC_COP_reveal_2_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
		
			(parseText SAC_COP_reveal_2_diaryEntryDescription) call SAC_fnc_MPhint; 
		
		};
		
		if ((!isNil "SAC_COP_reveal_2_useSpecialSystemChatText") && {SAC_COP_reveal_2_useSpecialSystemChatText}) then {
		
			SAC_COP_reveal_2_specialSystemChatText call SAC_fnc_MPsystemChat; 
		
		} else {
		
			"SE MARCARON NUEVAS POSICIONES EN TU MAPA." call SAC_fnc_MPsystemChat; 
			
		};

	};
	SAC_COP_reveal_2_flag = true;

};
SAC_interact_handleRevealNotifications_3 = {
	if ((!isNil "SAC_COP_reveal_3_flag") && {SAC_COP_reveal_3_flag == false}) then { 
	
		if ((!isNil "SAC_COP_reveal_3_createDiaryEntry") && {SAC_COP_reveal_3_createDiaryEntry}) then {
		
			{player createDiarySubject  [SAC_COP_reveal_3_diaryEntrySubject, SAC_COP_reveal_3_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
			{player createDiaryRecord  [SAC_COP_reveal_3_diaryEntrySubject, [SAC_COP_reveal_3_diaryEntryTitle, SAC_COP_reveal_3_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
		
			(parseText SAC_COP_reveal_3_diaryEntryDescription) call SAC_fnc_MPhint; 
		
		};
		
		if ((!isNil "SAC_COP_reveal_3_useSpecialSystemChatText") && {SAC_COP_reveal_3_useSpecialSystemChatText}) then {
		
			SAC_COP_reveal_3_specialSystemChatText call SAC_fnc_MPsystemChat; 
		
		} else {
		
			"SE MARCARON NUEVAS POSICIONES EN TU MAPA." call SAC_fnc_MPsystemChat; 
			
		};

	};
	SAC_COP_reveal_3_flag = true;

};

SAC_interact_handleRevealNotifications_4 = {

	if ((!isNil "SAC_COP_reveal_4_flag") && {SAC_COP_reveal_4_flag == false}) then { 
	
		if ((!isNil "SAC_COP_reveal_4_createDiaryEntry") && {SAC_COP_reveal_4_createDiaryEntry}) then {

			if (SAC_COP_reveal_4_flag == false) then {
				
				{player createDiarySubject  [SAC_COP_reveal_4_diaryEntrySubject, SAC_COP_reveal_4_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
				{player createDiaryRecord  [SAC_COP_reveal_4_diaryEntrySubject, [SAC_COP_reveal_4_diaryEntryTitle, SAC_COP_reveal_4_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
			
				(parseText SAC_COP_reveal_4_diaryEntryDescription) call SAC_fnc_MPhint; 
			
			};
		
			SAC_COP_reveal_4_flag = true;
		
		};
		
		if ((!isNil "SAC_COP_reveal_4_useSpecialSystemChatText") && {SAC_COP_reveal_4_useSpecialSystemChatText}) then {
		
			SAC_COP_reveal_3_specialSystemChatText call SAC_fnc_MPsystemChat; 
		
		} else {
		
			//"SE MARCARON NUEVAS POSICIONES EN TU MAPA." call SAC_fnc_MPsystemChat; 
			
		};
	};
	SAC_COP_reveal_4_flag = true;

};

SAC_interact_handleRevealNotifications_5 = {
	if ((!isNil "SAC_COP_reveal_5_flag") && {SAC_COP_reveal_5_flag == false}) then { 
	
		if ((!isNil "SAC_COP_reveal_5_createDiaryEntry") && {SAC_COP_reveal_5_createDiaryEntry}) then {
		
			{player createDiarySubject  [SAC_COP_reveal_5_diaryEntrySubject, SAC_COP_reveal_5_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
			{player createDiaryRecord  [SAC_COP_reveal_5_diaryEntrySubject, [SAC_COP_reveal_5_diaryEntryTitle, SAC_COP_reveal_5_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
		
			(parseText SAC_COP_reveal_5_diaryEntryDescription) call SAC_fnc_MPhint; 
		
		};
		
		if ((!isNil "SAC_COP_reveal_5_useSpecialSystemChatText") && {SAC_COP_reveal_5_useSpecialSystemChatText}) then {
		
			SAC_COP_reveal_3_specialSystemChatText call SAC_fnc_MPsystemChat; 
		
		} else {
		
			//"SE MARCARON NUEVAS POSICIONES EN TU MAPA." call SAC_fnc_MPsystemChat; 
			
		};

	};
	SAC_COP_reveal_5_flag = true;
};

SAC_interact_handleRevealNotifications_6 = {
	if ((!isNil "SAC_COP_reveal_6_flag") && {SAC_COP_reveal_6_flag == false}) then { 
	
		if ((!isNil "SAC_COP_reveal_6_createDiaryEntry") && {SAC_COP_reveal_6_createDiaryEntry}) then {
		
			{player createDiarySubject  [SAC_COP_reveal_6_diaryEntrySubject, SAC_COP_reveal_6_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
			{player createDiaryRecord  [SAC_COP_reveal_6_diaryEntrySubject, [SAC_COP_reveal_6_diaryEntryTitle, SAC_COP_reveal_6_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
		
			(parseText SAC_COP_reveal_6_diaryEntryDescription) call SAC_fnc_MPhint; 
		
		};
		
		if ((!isNil "SAC_COP_reveal_6_useSpecialSystemChatText") && {SAC_COP_reveal_6_useSpecialSystemChatText}) then {
		
			SAC_COP_reveal_3_specialSystemChatText call SAC_fnc_MPsystemChat; 
		
		} else {
		
			//"SE MARCARON NUEVAS POSICIONES EN TU MAPA." call SAC_fnc_MPsystemChat; 
			
		};

	};
	SAC_COP_reveal_6_flag = true;
};

SAC_interact_handleRevealNotifications_7 = {
	if ((!isNil "SAC_COP_reveal_7_flag") && {SAC_COP_reveal_7_flag == false}) then { 
	
		if ((!isNil "SAC_COP_reveal_7_createDiaryEntry") && {SAC_COP_reveal_7_createDiaryEntry}) then {
		
			{player createDiarySubject  [SAC_COP_reveal_7_diaryEntrySubject, SAC_COP_reveal_7_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
			{player createDiaryRecord  [SAC_COP_reveal_7_diaryEntrySubject, [SAC_COP_reveal_7_diaryEntryTitle, SAC_COP_reveal_7_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
		
			(parseText SAC_COP_reveal_7_diaryEntryDescription) call SAC_fnc_MPhint; 
		
		};
		
		if ((!isNil "SAC_COP_reveal_7_useSpecialSystemChatText") && {SAC_COP_reveal_7_useSpecialSystemChatText}) then {
		
			SAC_COP_reveal_3_specialSystemChatText call SAC_fnc_MPsystemChat; 
		
		} else {
		
			//"SE MARCARON NUEVAS POSICIONES EN TU MAPA." call SAC_fnc_MPsystemChat; 
			
		};

	};
	SAC_COP_reveal_7_flag = true;
};

SAC_interact_handleRevealNotifications_8 = {
	if ((!isNil "SAC_COP_reveal_8_flag") && {SAC_COP_reveal_8_flag == false}) then { 
	
		if ((!isNil "SAC_COP_reveal_8_createDiaryEntry") && {SAC_COP_reveal_8_createDiaryEntry}) then {
		
			{player createDiarySubject  [SAC_COP_reveal_8_diaryEntrySubject, SAC_COP_reveal_8_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
			{player createDiaryRecord  [SAC_COP_reveal_8_diaryEntrySubject, [SAC_COP_reveal_8_diaryEntryTitle, SAC_COP_reveal_8_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
		
			(parseText SAC_COP_reveal_8_diaryEntryDescription) call SAC_fnc_MPhint; 
		
		};
		
		if ((!isNil "SAC_COP_reveal_8_useSpecialSystemChatText") && {SAC_COP_reveal_8_useSpecialSystemChatText}) then {
		
			SAC_COP_reveal_3_specialSystemChatText call SAC_fnc_MPsystemChat; 
		
		} else {
		
			//"SE MARCARON NUEVAS POSICIONES EN TU MAPA." call SAC_fnc_MPsystemChat; 
			
		};

	};
	SAC_COP_reveal_8_flag = true;
};

SAC_interact_handleRevealNotifications_9 = {
	if ((!isNil "SAC_COP_reveal_9_flag") && {SAC_COP_reveal_9_flag == false}) then { 
	
		if ((!isNil "SAC_COP_reveal_9_createDiaryEntry") && {SAC_COP_reveal_9_createDiaryEntry}) then {
		
			{player createDiarySubject  [SAC_COP_reveal_9_diaryEntrySubject, SAC_COP_reveal_9_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
			{player createDiaryRecord  [SAC_COP_reveal_9_diaryEntrySubject, [SAC_COP_reveal_9_diaryEntryTitle, SAC_COP_reveal_9_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
		
			(parseText SAC_COP_reveal_9_diaryEntryDescription) call SAC_fnc_MPhint; 
		
		};
		
		if ((!isNil "SAC_COP_reveal_9_useSpecialSystemChatText") && {SAC_COP_reveal_9_useSpecialSystemChatText}) then {
		
			SAC_COP_reveal_3_specialSystemChatText call SAC_fnc_MPsystemChat; 
		
		} else {
		
			//"SE MARCARON NUEVAS POSICIONES EN TU MAPA." call SAC_fnc_MPsystemChat; 
			
		};

	};
	SAC_COP_reveal_9_flag = true;
};

SAC_interact_handleRevealNotifications_10 = {
	if ((!isNil "SAC_COP_reveal_10_flag") && {SAC_COP_reveal_10_flag == false}) then { 
	
		if ((!isNil "SAC_COP_reveal_10_createDiaryEntry") && {SAC_COP_reveal_10_createDiaryEntry}) then {
		
			{player createDiarySubject  [SAC_COP_reveal_10_diaryEntrySubject, SAC_COP_reveal_10_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
			{player createDiaryRecord  [SAC_COP_reveal_10_diaryEntrySubject, [SAC_COP_reveal_10_diaryEntryTitle, SAC_COP_reveal_10_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
		
			(parseText SAC_COP_reveal_10_diaryEntryDescription) call SAC_fnc_MPhint; 
		
		};
		
		if ((!isNil "SAC_COP_reveal_10_useSpecialSystemChatText") && {SAC_COP_reveal_10_useSpecialSystemChatText}) then {
		
			SAC_COP_reveal_3_specialSystemChatText call SAC_fnc_MPsystemChat; 
		
		} else {
		
			//"SE MARCARON NUEVAS POSICIONES EN TU MAPA." call SAC_fnc_MPsystemChat; 
			
		};

	};
	SAC_COP_reveal_10_flag = true;
};

SAC_interact_handleRevealPasswords = {

	if ((!isNil "SAC_COP_reveal_passwords_createDiaryEntry") && {SAC_COP_reveal_passwords_createDiaryEntry}) then {
	
		{player createDiarySubject  [SAC_COP_reveal_passwords_diaryEntrySubject, SAC_COP_reveal_passwords_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
		{player createDiaryRecord  [SAC_COP_reveal_passwords_diaryEntrySubject, [SAC_COP_reveal_passwords_diaryEntryTitle, SAC_COP_reveal_passwords_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
	
		(parseText SAC_COP_reveal_passwords_diaryEntryDescription) call SAC_fnc_MPhint; 
	
	};

	{player createDiarySubject  ["accessCodes", "Codigos De Acceso"]} remoteExec ["call", [0, -2] select isDedicated, true];
	{player createDiaryRecord  ["accessCodes", [SAC_passwords_name, str SAC_passwords]]} remoteExec ["call", [0, -2] select isDedicated, true];
	
	if ((!isNil "SAC_COP_reveal_passwords_useSpecialSystemChatText") && {SAC_COP_reveal_passwords_useSpecialSystemChatText}) then {
	
		SAC_COP_reveal_passwords_specialSystemChatText call SAC_fnc_MPsystemChat; 
	
	} else {
	
		"SE AGREGO LA INFORMACION A TU DIARIO." call SAC_fnc_MPsystemChat; 
		
	};
	
};
SAC_interact_handleRevealPasswords_2 = {

	if ((!isNil "SAC_COP_reveal_passwords_createDiaryEntry_2") && {SAC_COP_reveal_passwords_createDiaryEntry_2}) then {
	
		{player createDiarySubject  [SAC_COP_reveal_passwords_diaryEntrySubject_2, SAC_COP_reveal_passwords_diaryEntryDisplayName_2]} remoteExec ["call", [0, -2] select isDedicated, true]; 
		{player createDiaryRecord  [SAC_COP_reveal_passwords_diaryEntrySubject_2, [SAC_COP_reveal_passwords_diaryEntryTitle_2, SAC_COP_reveal_passwords_diaryEntryDescription_2]]} remoteExec ["call", [0, -2] select isDedicated, true];
	
		(parseText SAC_COP_reveal_passwords_diaryEntryDescription_2) call SAC_fnc_MPhint; 
	
	};

	{player createDiarySubject  ["accessCodes", "Codigos De Acceso"]} remoteExec ["call", [0, -2] select isDedicated, true]; 
	{player createDiaryRecord  ["accessCodes", [SAC_passwords_name_2, str SAC_passwords_2]]} remoteExec ["call", [0, -2] select isDedicated, true];

	if ((!isNil "SAC_COP_reveal_passwords_useSpecialSystemChatText_2") && {SAC_COP_reveal_passwords_useSpecialSystemChatText_2}) then {
	
		SAC_COP_reveal_passwords_specialSystemChatText_2 call SAC_fnc_MPsystemChat; 
	
	} else {
	
		"SE AGREGO LA INFORMACION A TU DIARIO." call SAC_fnc_MPsystemChat; 
		
	};

};
SAC_interact_handleRevealPasswords_3 = {

	if ((!isNil "SAC_COP_reveal_passwords_createDiaryEntry_3") && {SAC_COP_reveal_passwords_createDiaryEntry_3}) then {
	
		{player createDiarySubject  [SAC_COP_reveal_passwords_diaryEntrySubject_3, SAC_COP_reveal_passwords_diaryEntryDisplayName_3]} remoteExec ["call", [0, -2] select isDedicated, true]; 
		{player createDiaryRecord  [SAC_COP_reveal_passwords_diaryEntrySubject_3, [SAC_COP_reveal_passwords_diaryEntryTitle_3, SAC_COP_reveal_passwords_diaryEntryDescription_3]]} remoteExec ["call", [0, -2] select isDedicated, true];
	
		(parseText SAC_COP_reveal_passwords_diaryEntryDescription_3) call SAC_fnc_MPhint; 
	
	};
	
	{player createDiarySubject  ["accessCodes", "Codigos De Acceso"]} remoteExec ["call", [0, -2] select isDedicated, true]; 
	{player createDiaryRecord  ["accessCodes", [SAC_passwords_name_3, str SAC_passwords_3]]} remoteExec ["call", [0, -2] select isDedicated, true];

	if ((!isNil "SAC_COP_reveal_passwords_useSpecialSystemChatText_3") && {SAC_COP_reveal_passwords_useSpecialSystemChatText_3}) then {
	
		SAC_COP_reveal_passwords_specialSystemChatText_3 call SAC_fnc_MPsystemChat; 
	
	} else {
	
		"SE AGREGO LA INFORMACION A TU DIARIO." call SAC_fnc_MPsystemChat; 
		
	};

};













































waitUntil {!isNull(findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["keyDown", {
	
	if (dialog) exitWith {false};
	
	private["_shift", "_ctrl", "_alt","_dik"];
	_dik = _this select 1;
	_shift = _this select 2;
	_ctrl = _this select 3;
	_alt = _this select 4;

	switch (true) do {

		case (_alt && (_dik == DIK_U)): {

			[] spawn SAC_interact_openSelfInterface;

			true

		};
		
		case (_dik == DIK_U): {

			SAC_interact_cursorObject = cursorObject;
			[] spawn SAC_interact_openInterface;

			true

		};

		default {false}

	};

}];


SAC_interact = true;

systemChat "INTERACT inicializado.";
