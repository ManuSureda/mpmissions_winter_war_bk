/*
	Descripción:
	Genera tráfico de vehículos militares (por ahora de un solo bando).
	
	Las siguientes variables tienen que estar definidas como variables globales antes de ejecutar el script:
	
	SAC_MTS_trafficTypesSquematic		["UNARMED", 20, "ARMED_SOFT", 10, "APC", 1]
	SAC_MTS_trafficUnarmed				array de clases para los vehículos sin armas
	SAC_MTS_trafficArmedSoft				array de clases para los vehículos armados pero sin blindaje
	SAC_MTS_trafficCrew					array de clases para los tripulantes de los vehículos livianos
	SAC_MTS_trafficAPC					array de clases para los APCs
	SAC_MTS_trafficAPCCrew				array de clases para los tripulantes de los APCs
	SAC_MTS_Blacklist						Un array de áreas indicadas por markers ó triggers, dentro de las cuales no se generarán unidades.
	SAC_MTS_Greenzones					Un array de áreas indicadas por markers ó triggers, dentro de las cuales la presencia de jugadores no es seguida.
	SAC_MTS_interval						Cada cuanto tiempo en minutos se intentan enviar vehículos
	SAC_MTS_trackFlyingPlayers			true para que los jugadores volando también generen los vehículos
	
	
	Uso:
	[] spawn compile preprocessFileLineNumbers "sac_military_traffic.sqf";
	

*/

if (!isServer) exitWith {};

SAC_MTS_fnc_cleaner = {

	//Buscar los vehículos que se deban borrar.
	private _v = [];
	{
	
		if (([_x, 700] call SAC_fnc_notNearPlayerSide_2) && {(time > _x getVariable "SAC_MTS_TTL") || {_x getVariable "SAC_MTS_speed_zero_counter" >= 2}}) then {

			_v pushBack _x;
			/*
			Se observo que en el caso de que la tripulacion estuviera viva, la misma queda de a pie,
			y si la tripulacion estuviera muerta, se borra junto con el vehiculo (despejando correctamente
			allDeadMen).
			*/
			deleteVehicle _x;
			
		} else {
		
			if (speed _x == 0) then {_x setVariable ["SAC_MTS_speed_zero_counter", (_x getVariable "SAC_MTS_speed_zero_counter") + 1]};
		
		};
	
	} forEach SAC_MTS_vehicles;
	
	//Buscar las personas que se deban borrar.
	private _u = [];
	{
	
		if (!alive _x) then {

			if ([_x, 50] call SAC_fnc_notNearPlayerSide_2) then {
		
				_u pushBack _x;
			
				[_x] call SAC_fnc_deleteUnit;
				
			};
			
		} else {
	
			if (((time > _x getVariable "SAC_MTS_TTL") || (isNull objectParent _x)) && {[_x, 700] call SAC_fnc_notNearPlayerSide_2}) then {
			
				_u pushBack _x;
				
				[_x] call SAC_fnc_deleteUnit;
				
			};
			
		};
	
	} forEach SAC_MTS_units;
	
	SAC_MTS_vehicles = SAC_MTS_vehicles - _v;
	SAC_MTS_units = SAC_MTS_units - _u;
	
};


private ["_centralPos", "_centers", "_nextCarTime", "_interval", "_returnedArray", "_result", "_start", "_destination", "_vehicle", "_grp"];

//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitwith {"ERROR: SAC_MTS - ""SAC_FNC"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
if (isnil "SAC_MTS_trafficTypesSquematic") exitwith {"ERROR: SAC_MTS - ""SAC_MTS_trafficTypesSquematic"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
if (isnil "SAC_MTS_trafficUnarmed") exitwith {"ERROR: SAC_MTS - ""SAC_MTS_trafficUnarmed"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
if (isnil "SAC_MTS_trafficArmedSoft") exitwith {"ERROR: SAC_MTS - ""SAC_MTS_trafficArmedSoft"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
if (isnil "SAC_MTS_trafficCrew") exitwith {"ERROR: SAC_MTS - ""SAC_MTS_trafficCrew"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
if (isnil "SAC_MTS_trafficAPC") exitwith {"ERROR: SAC_MTS - ""SAC_MTS_trafficAPC"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
if (isnil "SAC_MTS_trafficAPCCrew") exitwith {"ERROR: SAC_MTS - ""SAC_MTS_trafficAPCCrew"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
if (isnil "SAC_MTS_Blacklist") exitwith {"ERROR: SAC_MTS - ""SAC_MTS_Blacklist"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
if (isnil "SAC_MTS_Greenzones") exitwith {"ERROR: SAC_MTS - ""SAC_MTS_Greenzones"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
if (isnil "SAC_MTS_interval") exitwith {"ERROR: SAC_MTS - ""SAC_MTS_interval"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
if (isnil "SAC_MTS_trackFlyingPlayers") exitwith {"ERROR: SAC_MTS - ""SAC_MTS_trackFlyingPlayers"" is not initialized in SAC_MTS." call SAC_fnc_MPhintC};
{

	if !(_x in allMapMarkers) then {(_x + " marker is missing.") call SAC_fnc_MPsystemChat};
	
} forEach SAC_MTS_Blacklist;
{

	if !(_x in allMapMarkers) then {(_x + " marker is missing.") call SAC_fnc_MPsystemChat};
	
} forEach SAC_MTS_Greenzones;


SAC_MTS_vehicles = [];
SAC_MTS_units = [];

SAC_MTS = true;

"MTS initialized." call SAC_fnc_MPsystemChat;

private _trafficTypes = [SAC_MTS_trafficTypesSquematic] call SAC_fnc_squematicToArray;

sleep (5 + random 5);

_interval = 60 * SAC_MTS_interval;
_nextCarTime = time + _interval;

private _itsTimeToClean = 0;

while {true} do {

	sleep 10;

	if (time > _nextCarTime) then {
	
		_centers = [500, SAC_MTS_Greenzones, SAC_MTS_trackFlyingPlayers, true] call SAC_fnc_groupsOfPlayers;
		
		{
		
			_centralPos = _x;
			
			if ((_centralPos isNotEqualTo [0,0,0]) && {!surfaceIsWater _centralPos}) then {

				_returnedArray = [_centralPos, 1000, 1500, 500, 3500, SAC_MTS_Blacklist] call SAC_fnc_trafficGetRoute;
				_result = _returnedArray select 0;
				_start = _returnedArray select 1; //devuelve un road segment
				_destination = _returnedArray select 2; //devuelve un road segment
				
				if (_result) then {
				
					private ["_vehicleClasses", "_unitClasses", "_skill"];

					switch (selectRandom _trafficTypes) do {
					
						case "UNARMED": {
						
							_vehicleClasses = SAC_MTS_trafficUnarmed;
							_unitClasses = SAC_MTS_trafficCrew;
							_skill = [0.4, 0.6];
							
						};
						case "ARMED_SOFT": {
						
							_vehicleClasses = SAC_MTS_trafficArmedSoft;
							_unitClasses = SAC_MTS_trafficCrew;
							_skill = [0.4, 0.6];
							
						};
						case "APC": {
						
							_vehicleClasses = SAC_MTS_trafficAPC;
							_unitClasses = SAC_MTS_trafficAPCCrew;
							_skill = [0.4, 0.6];
							
						};

					};
				
					//["_start", "_destination", "_vehicleClasses", "_unitClasses", "_unitCount", "_skill", "_speed", "_combatMode", "_behaviour", "_setCaptive"
					_returnedArray = [getPos _start, getPos _destination, _vehicleClasses, _unitClasses, [2, 5], _skill, [50, 70], "RED", "SAFE", false] call SAC_fnc_sendCar;
					_vehicle = _returnedArray select 0;
					_grp = _returnedArray select 1;

					_vehicle setVariable ["SAC_CAR_DESTINATION", getPos _destination];
					_vehicle setVariable ["SAC_MTS_TTL", time + (7*60)];
					_vehicle setVariable ["SAC_MTS_speed_zero_counter", 0];
					
					SAC_MTS_vehicles pushBack _vehicle;
					SAC_MTS_units append units _grp;
					
					{_x setVariable ["SAC_MTS_TTL", time + (7*60)]} forEach units _grp;
					
				};

			};
			
			sleep 0.5;
			
		} forEach _centers;
		
		_nextCarTime = time + _interval;
		
	};

	if (_itsTimeToClean >= 12) then {
	
		[] call SAC_MTS_fnc_cleaner;
		
		_itsTimeToClean = 0;
		
	} else {
	
		_itsTimeToClean = _itsTimeToClean + 1;
	
	};
	
	[SAC_MTS_vehicles, SAC_MTS_Blacklist, "RED", "SAFE", 500, 3500] call SAC_fnc_trafficRetasker;
	
};

