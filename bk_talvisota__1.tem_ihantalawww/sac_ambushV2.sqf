/*
	Descripción:
	Genera ataques sobre unidades del lado del jugador.
	
	Uso:
	[SAC_AMB_high_zones, SAC_AMB_low_zones, SAC_AMB_hz_prob, SAC_AMB_lz_prob, SAC_AMB_blacklist, SAC_AMB_greenzones, SAC_AMB_mode, SAC_AMB_mintba, SAC_AMB_maxtba] spawn compile preprocessFileLineNumbers "sac_ambush.sqf";
	
	Parámetros:
	SAC_AMB_prob				La probabilidad de ataques.
	SAC_AMB_blacklist		Un array de áreas indicadas por markers ó triggers, dentro de las cuales no se generarán unidades.
	SAC_AMB_greenzones		Un array de áreas indicadas por markers ó triggers, dentro de las cuales las unidades no serán atacadas.
	
	Ejemplo de uso:
	SAC_AMB_prob = 0.055;
	SAC_AMB_blacklist = ["SAC_ambush_green_zone_1"];
	SAC_AMB_greenzones = ["SAC_ambush_green_zone_1"];
	[] spawn compile preprocessFileLineNumbers "sac_ambush.sqf";
	
	26/03/2018 Se simplificó la selección de IEDs, o sea poder detener a un player en un vehículo. AMB_IED tiene
	que estar definido siempre. Si es "true" se puede detener al player con un IED mientras va en vehículo; si es "false" no.
	
*/


If (!isServer) exitWith {};

SAC_AMB_fnc_createIncomingUnits = {

	params ["_formations", "_p"];
	
	private ["_grpCount", "_c", "_grpSize", "_grp"];

	_grpCount = _formations select 0;
	_grpSize = _formations select 1;
	
	for "_c" from 1 to _grpCount do {
	
		//["_destination", "_spawnDistance", "_playerExclusionDistance", "_blacklistsMarkers", "_unitClasses", "_grpSize", "_skill", "_waypointType", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_waypointStatements", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"]
		_grp = [_p, [450, 750], 450, SAC_AMB_blacklist, SAC_UDS_O_G_Soldiers, [_grpSize, _grpSize], [0.2, 0.4], ["GUARD", "PATROL"], "NORMAL", "AWARE", 1, 1, 1, "", 500, SAC_AMB_blacklist, 4, 400, false] call SAC_fnc_sendGroup;
	
		if (isNull _grp) exitWith {};
		
		SAC_AMB_units append units _grp;
	
		sleep 0.1;
	
	};

};

//La razón por la que no uso la funcion genérica de la librería, es porque el vehículo no tiene que ir a ningún lado. La rutina genérica sería completamente
//incompatible porque lo que toma como parámetro es el destino, y se encarga de calcular el orígen automáticamente. En ésta en cambio lo único que importa es el orígen.
SAC_AMB_fnc_spawnTechnical = {

	params ["_start"];
	
	private ["_returnedarray", "_grp", "_vehicle", "_wp"];

	//["_position", "_direction", "_vehicleClasses", "_crewClasses", "_special", "_autoDeleteGroup"]
	_returnedArray = [_start, random 360, SAC_UDS_O_G_ambushVeh, SAC_UDS_O_G_Soldiers, "NONE", true] call SAC_fnc_spawnVehicle;
	_vehicle = _returnedArray select 0;
	_grp = _returnedArray select 1;

	SAC_AMB_vehicles pushBack _vehicle;

	SAC_AMB_units append units _grp;

	_wp = _grp addWaypoint [_start, 0];
	_wp setWaypointType "HOLD"; _wp setWaypointCompletionRadius 10;

	[_vehicle] call SAC_fnc_initVehicle;

};

SAC_AMB_fnc_createTechnicals = {

	private ["_c", "_direction", "_road", "_p"];
	
	_p = _this select 0;
	
	//Buscar un camino en cada punto cardinal y crear vehiculos armados estacionados.
	
	//Hay dos formaciones posibles para la ubicación de los vehículos, y cada vehículo puede o no ser factible en la posición pretendida. En un esquema estarían
	//ubicados NORTE-ESTE-SUR-OESTE, y en el otro se rotaría 45 grados la cuadrícula (quedando NE-SE-SO-NO).
	if (random 1 < 0.5) then {_direction = 0} else {_direction = 45};
	
	for "_c" from 0 to 4 - 1 do {
	
		//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, [_method]] call SAC_fnc_findRoad;
		_road = [_p, 400, 700, _direction, SAC_AMB_blacklist, 400, "closest"] call SAC_fnc_findRoad;
		
		if (!isNull _road) then {
		
			[getPos _road] call SAC_AMB_fnc_spawnTechnical;

		};
		
		_direction = _direction + 90;
		
	};
};

SAC_AMB_fnc_doStaticAmbush = {

	params ["_pos"];
	
	private ["_formations"];
	
	//La cantidad de unidades involucradas varía entre 8 y 16.
	_formations = [[2,4], [3,3], [4,2], [2,8], [3,5], [4,4], [5,3], [6,2]];
	
	[selectRandom _formations, _pos] call SAC_AMB_fnc_createIncomingUnits;
	
	[_pos] call SAC_AMB_fnc_createTechnicals;

	//Aumenta temporalmente la probabilidad de que ITS genere un ataque también.
	if ((!isNil "SAC_ITS_prob") && {!SAC_AMB_raised_its_prob}) then {
	
		SAC_AMB_normal_its_prob = SAC_ITS_prob;
		SAC_ITS_prob = .85;
		SAC_AMB_raised_its_prob = true;
		[] spawn {
		
			sleep (60*20);
			//sleep 120; systemChat "AMB in debug mode!";
			SAC_ITS_prob = SAC_AMB_normal_its_prob;
			SAC_AMB_raised_its_prob = false;
			
		};
	
	};
	
};

SAC_AMB_fnc_detonateIED = {

	params ["_trigger"];
	
	private ["_position", "_vehicles", "_activators", "_activator"];
	
	_activators = list _trigger;
	
	//diag_log format ["SAC_AMB_fnc_detonateIED _activators: %1", _activators];
	
	_position = getPos _trigger;
	
	_activator = _activators select 0;
	
	//[_object, [_actionTitle, _scriptCode, _arguments, _priority, _showWindow, _hideOnUse, "", _condition]] remoteExec ["addAction", 0, true];
	//[<params1>, <params2>] remoteExec ["someScriptCommand", targets, JIP];
	[_activator, false] remoteExec ["allowDamage", 0, false];
	//_activator allowDamage false;
	
	{
	
		if (_x distance _position <= 15) exitWith {
		
			_x setDamage 1;
			
		};
	
	} forEach SAC_AMB_ieds;
	
	sleep 1;
	
	[_activator, true] remoteExec ["allowDamage", 0, false];
	//_activator allowDamage true;
	
	[_activator, 0] remoteExec ["setFuel", 0, false];
	//_activator setFuel 0; //no uso una rutina para dañar al vehículo porque ninguna funciona 100% bien
	
	{deleteVehicle _x} forEach SAC_AMB_triggers;
	
	{deleteVehicle _x} forEach SAC_AMB_ieds;
	
	SAC_AMB_triggers = [];
	SAC_AMB_ieds = [];
	
};

SAC_AMB_fnc_spawnIED = {

	params ["_position"];
	
	private ["_iedType", "_ied", "_trigger"];
	
	_iedType = selectRandom SAC_ieds;
	
	_ied = _iedType createVehicle _position;
	_ied setPos [_position select 0, _position select 1, -0.5];
	
	//if (isMultiplayer) then {hideObjectGlobal _ied} else {hideObject _ied};
	
	SAC_AMB_ieds pushBack _ied;
	
	_trigger = createTrigger ["EmptyDetector", getPos _ied];
	_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
	_trigger setTriggerArea [5 + random 10, 5 + random 10, 0, false];
	_trigger setTriggerType "NONE";
	_trigger setTriggerStatements ["this","[thisTrigger] spawn SAC_AMB_fnc_detonateIED; [getPos thisTrigger] spawn SAC_AMB_fnc_doStaticAmbush",""];
	
	SAC_AMB_triggers pushBack _trigger;
	
};

SAC_AMB_fnc_createIEDs360 = {

	params ["_unit"];
	
	private ["_c", "_direction", "_road"];
	
	_direction = 0;
	
	//Nota: Si un vehículo viaja a una vel. máx. de 100 km/h, tarda 14 seg. en recorrer 400 metros.
	/*
	
	100.000   -----  3.600
	400 -----------   x
	
	x = (3.600*400) / 100.000
	
	*/
	
	for "_c" from 0 to 6 - 1 do {
	
		//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, [_method]] call SAC_fnc_findRoad;
		//Nota: _noplayerDistance es 40, porque los triggers tienen un radio de 15 mts.
		_road = [getPos _unit, 200, 400, _direction, SAC_AMB_blacklist, 40, "closest"] call SAC_fnc_findRoad;
		
		if (!isNull _road) then {
		
			[getPos _road] call SAC_AMB_fnc_spawnIED;

		};
		
		_direction = _direction + 60;
		
	};
	
	//{[getPos _x, "ColorRed", "mil_dot_noshadow"] call SAC_fnc_createMarker} forEach SAC_AMB_ieds;

};

SAC_AMB_fnc_doSpeedAmbush = {

	params ["_unit"];
	
	//Lo que hago acá es colocar explosivos en los caminos alrededor de la posición de la unidad, cubriendo más o menos 360 grados. Con cada explosivo hay un trigger,
	//y el trigger, aparte de detonar el explosivo, dispara un ambush estático en la posición del trigger (además desactiva todos los demás triggers y explosivos).
	//Es decir, en vez de tratar de saber hacia donde está yendo la unidad, y tratar de poner el IED en la posición correcta, uso el truco de rodear a la unidad de
	//explosivos/triggers, y el primero que se detona, borra los demás, que se usaron para resolver el problema.
	
	[_unit] call SAC_AMB_fnc_createIEDs360;
	
	
};

SAC_AMB_fnc_spawnAirThreat = {

	params ["_unit"];
	
	private ["_grp"];

	//["_centerPos", "_minDistance", "_maxDistance", "_playerExclusionDistance", "_blacklistsMarkers", "_unitClasses", "_grpSize", "_skill", "_autoDeleteGroup"]
	_grp = [getPos _unit, 0, 1000, 450, SAC_AMB_blacklist, SAC_UDS_O_G_AA_Soldiers, [1, 1], [0.4, 0.6], true] call SAC_fnc_createGroup;
	
	if (isNull _grp) exitWith {};

	((units _grp) select 0) lookAt _unit;
	((units _grp) select 0) reveal [vehicle _unit, 4];

};


private ["_t1", "_irrelevantUnits", "_irrelevantGroups", "_irrelevantVehicles", "_ambush", "_irrelevantIEDS", "_irrelevantTriggers", "_nextAmbushTime"];

//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitwith {hintC """SAC_FNC"" is not initialized in SAC_AMB."};
if (isnil "SAC_UDS_O_G_Soldiers") exitwith {hintC """SAC_UDS_O_G_Soldiers"" is not initialized in SAC_AMB."};
if (isnil "SAC_UDS_O_G_ambushVeh") exitwith {hintC """SAC_UDS_O_G_ambushVeh"" is not initialized in SAC_AMB."};
if (isnil "SAC_UDS_O_G_AA_Soldiers") exitwith {hintC """SAC_UDS_O_G_AA_Soldiers"" is not initialized in SAC_AMB."};
if (isnil "SAC_AMB_blacklist") exitwith {hintC """SAC_AMB_blacklist"" is not initialized in SAC_AMB."};
if (isnil "SAC_AMB_greenzones") exitwith {hintC """SAC_AMB_greenzones"" is not initialized in SAC_AMB."};
if (isnil "SAC_AMB_prob") exitwith {hintC """SAC_AMB_prob"" is not initialized in SAC_AMB."};
if (isnil "AMB_IED") exitwith {hintC """AMB_IED"" is not initialized in SAC_AMB."};
{

	if !(_x in allMapMarkers) then {hintC (_x + " marker is missing.")};
	
} forEach SAC_AMB_blacklist;
{

	if !(_x in allMapMarkers) then {hintC (_x + " marker is missing.")};
	
} forEach SAC_AMB_greenzones;

SAC_AMB_vehicles = [];
SAC_AMB_groups = [];
SAC_AMB_units = [];

SAC_AMB_triggers = [];
SAC_AMB_ieds = [];

SAC_AMB_MASTER_SWITCH_OFF = false; //se usa para externamente suspender la actividad del módulo

SAC_AMB_requestAmbush = objNull;
publicVariable "SAC_AMB_requestAmbush";

SAC_AMB_raised_its_prob = false;

SAC_AMB_side = [SAC_UDS_O_G_Soldiers select 0] call SAC_fnc_getSideFromCfg;


//**************************************************************************************
//Una API para que otros módulos puedan pedir un ambush
//**************************************************************************************
if (isDedicated) then {

	"SAC_AMB_requestAmbush" addPublicVariableEventHandler {

		private ["_unit"];
		_unit = SAC_AMB_requestAmbush;
		
		if (!SAC_AMB_MASTER_SWITCH_OFF) then {
		
			if ([_unit] call SAC_fnc_isNotFlying) then {
			
				if (speed vehicle _unit > 20) then {
				
					if ((vehicle _unit isKindOf "Wheeled_APC_F") || (vehicle _unit isKindOf "Tank")) then {
					
						[_unit] call SAC_AMB_fnc_doSpeedAmbush;
					
					} else {

						if (random 1 < 0.6) then {
					
							//systemChat "Doing speed ambush.";
							[_unit] call SAC_AMB_fnc_doSpeedAmbush;
							
						} else {
						
							[getPos _unit] call SAC_AMB_fnc_doStaticAmbush;
						
						};				
					
					};
				
				} else {
				
					if ((vehicle _unit isKindOf "Wheeled_APC_F") || (vehicle _unit isKindOf "Tank")) then {
					
						[_unit] call SAC_AMB_fnc_doSpeedAmbush;
					
					} else {

						[getPos _unit] call SAC_AMB_fnc_doStaticAmbush;
					
					};
				
				};
			
			} else {
			
				//systemChat "Doing air ambush.";
				[_unit] call SAC_AMB_fnc_spawnAirThreat;

			};
			
		};
		
		SAC_AMB_requestAmbush = objNull;
		publicVariable "SAC_AMB_requestAmbush";
		
	};

} else {

	[] spawn {

		while {true} do {
		
			waitUntil {
			
				sleep 5;
				
				!isNull SAC_AMB_requestAmbush
			
			
			};

			if (!SAC_AMB_MASTER_SWITCH_OFF) then {
			
				private ["_unit"];
				_unit = SAC_AMB_requestAmbush;
				
				if ([_unit] call SAC_fnc_isNotFlying) then {
				
					if (speed vehicle _unit > 20) then {
					
						if (random 1 < 0.6) then {
					
							systemChat "Doing speed ambush.";
							[_unit] call SAC_AMB_fnc_doSpeedAmbush;
							
						} else {
						
							[getPos _unit] call SAC_AMB_fnc_doStaticAmbush;
						
						};
					
					} else {
					
						systemChat "Doing static ambush.";
						[getPos _unit] call SAC_AMB_fnc_doStaticAmbush;
					
					};				
				
				} else {
				
					systemChat "Doing air ambush.";
					[_unit] call SAC_AMB_fnc_spawnAirThreat;

				};
				
			};
			
			SAC_AMB_requestAmbush = objNull;
			publicVariable "SAC_AMB_requestAmbush";
			
		};
	};

};

//**************************************************************************************
	
SAC_AMB = true;
systemChat "AMB initialized.";

sleep 5;

private ["_unit", "_fastMovingUnits", "_ambushableUnits", "_targetTypes", "_executedAmbush"];

while {true} do {

	sleep (3*60);
	//sleep 60; systemChat "AMB in debug mode!";
	//_t1 = diag_tickTime;

	//systemChat ("SAC_AMB_MASTER_SWITCH_OFF=" + str SAC_AMB_MASTER_SWITCH_OFF);
	if (!SAC_AMB_MASTER_SWITCH_OFF && (random 1 < SAC_AMB_prob)) then {
	
		_executedAmbush = false;
		_targetTypes = ["FASTMOVING", "SLOWMOVING"];
		while {(count _targetTypes > 0) && !(_executedAmbush)} do {
		
			switch (selectRandom _targetTypes) do {
			
				case "FASTMOVING": {
				
					_targetTypes =  _targetTypes - ["FASTMOVING"];
					
					_fastMovingUnits = [];
					{
					
						if ((!surfaceIsWater (getPos _x)) && {speed _x > 20} && {_x isKindOf "Man"} && {[getPos _x, SAC_AMB_greenzones] call SAC_fnc_isNotBlacklisted}) then {
						
							_fastMovingUnits pushBack _x;
						
						};

					} forEach units SAC_PLAYER_SIDE;
					
					if (count _fastMovingUnits > 0) then {
					
						_unit = selectRandom _fastMovingUnits;
						
						if ([_unit] call SAC_fnc_isNotFlying) then {
						
							//systemChat "Doing speed ambush.";
							if (AMB_IED) then {
								[_unit] call SAC_AMB_fnc_doSpeedAmbush;
							};

						} else {
						
							//systemChat "Doing air ambush.";
							[_unit] call SAC_AMB_fnc_spawnAirThreat;

						};
					
						_executedAmbush = true;
						
					};
					
				};
				
				case "SLOWMOVING": {
				
					_targetTypes =  _targetTypes - ["SLOWMOVING"];
				
					_ambushableUnits = [];
					
					if (isNil "SAC_AMB_TARGET_EVERYONE") then { //si la variable no está definida sólo se atacan las unidades descubiertas por el bando del 'ambush'
					
						{
						
							if ((!surfaceIsWater (getPos _x)) && {speed _x < 20} && {_x isKindOf "Man"} && {SAC_AMB_side knowsAbout _x >= 1.5} && {[getPos _x, SAC_AMB_greenzones] call SAC_fnc_isNotBlacklisted}) then {
							
								_ambushableUnits pushBack _x;
							
							};

						} forEach units SAC_PLAYER_SIDE;
					
					} else { //si está definida se ataca cualquier unidad, simulando que el enemigo trabaja como guerrilla y obtiene su propia información
					
						{
						
							if ((!surfaceIsWater (getPos _x)) && {speed _x < 20} && {_x isKindOf "Man"} && {[getPos _x, SAC_AMB_greenzones] call SAC_fnc_isNotBlacklisted}) then {
							
								_ambushableUnits pushBack _x;
							
							};

						} forEach units SAC_PLAYER_SIDE;
					
					};
					
					if (count _ambushableUnits > 0) then {
					
						_unit = selectRandom _ambushableUnits;
				
						//en un futuro, tal vez se podrían ajustar la fuerza que haría el ambush segun el tipo de unidades a emboscar
						
						//systemChat "Doing static ambush.";
						[getPos _unit] call SAC_AMB_fnc_doStaticAmbush;
					
						_executedAmbush = true;
						
					};
					
				};
			};
			
		};
		
	};
	
	//Borrar los vehículos usando el mismo criterio que para los ocupantes.
	SAC_AMB_vehicles = SAC_AMB_vehicles - ([SAC_AMB_vehicles, [], 1000, 0, "side"] call SAC_fnc_irrelevantItems);

	//Limpiar todo lo que esté a más de 1000 mts. de cualquier unidad de SAC_PLAYER_SIDE.
	SAC_AMB_units = SAC_AMB_units - ([SAC_AMB_units, [], 1000, 0, "side"] call SAC_fnc_irrelevantItems);
	
	//Borrar los ieds usando el mismo criterio.
	SAC_AMB_ieds = SAC_AMB_ieds - ([SAC_AMB_ieds, [], 1500, 0, "side"] call SAC_fnc_irrelevantItems);
	
	//Borrar los triggers de los ieds usando el mismo criterio.
	SAC_AMB_triggers = SAC_AMB_triggers - ([SAC_AMB_triggers, [], 1500, 0, "side"] call SAC_fnc_irrelevantItems);

};

