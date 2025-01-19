/*
	Descripción:
	Genera tráfico civil.
	
	Las siguientes variables tienen que estar definidas como variables globales antes de ejecutar el script:
	
	SAC_UDS_C_trafficVeh
	SAC_UDS_C_Men
	SAC_CTS_Blacklist				Un array de áreas indicadas por markers ó triggers, dentro de las cuales no se generarán unidades.
	SAC_CTS_Greenzones			Un array de áreas indicadas por markers ó triggers, dentro de las cuales la presencia del player no es seguida por el script.
	SAC_CTS_interval				Cada cuanto tiempo en minutos se intentan enviar vehículos
	SAC_CTS_trackFlyingPlayers	true para que los jugadores volando también generen los vehículos

	Uso:
	[] spawn compile preprocessFileLineNumbers "sac_civilian_traffic.sqf";
	
*/

If (!isServer) exitWith {};

SAC_CTS_fnc_cleaner = {
	
	//Buscar los vehículos que se deban borrar.
	private _v = [];
	{
	
		if (([_x, 700] call SAC_fnc_notNearPlayerSide_2) && {(time > _x getVariable "SAC_CTS_TTL") || {_x getVariable "SAC_CTS_speed_zero_counter" >= 2}}) then {

			_v pushBack _x;
			/*
			Se observo que en el caso de que la tripulacion estuviera viva, la misma queda de a pie,
			y si la tripulacion estuviera muerta, se borra junto con el vehiculo (despejando correctamente
			allDeadMen).
			*/
			deleteVehicle _x;
			
		} else {
		
			if (speed _x == 0) then {_x setVariable ["SAC_CTS_speed_zero_counter", (_x getVariable "SAC_CTS_speed_zero_counter") + 1]};
		
		};
	
	} forEach SAC_CTS_vehicles;
	
	//Buscar las personas que se deban borrar.
	private _u = [];
	{
	
		if (!alive _x) then {

			if ([_x, 50] call SAC_fnc_notNearPlayerSide_2) then {
		
				_u pushBack _x;
			
				[_x] call SAC_fnc_deleteUnit;
				
			};
			
		} else {
	
			if (((time > _x getVariable "SAC_CTS_TTL") || (isNull objectParent _x)) && {[_x, 700] call SAC_fnc_notNearPlayerSide_2}) then {
			
				_u pushBack _x;
				
				[_x] call SAC_fnc_deleteUnit;
				
			};
			
		};
	
	} forEach SAC_CTS_units;
	
	SAC_CTS_vehicles = SAC_CTS_vehicles - _v;
	SAC_CTS_units = SAC_CTS_units - _u;
	
};

private ["_t1", "_centralPos", "_centers", "_nextCarTime", "_interval", "_temp", "_returnedArray", "_start", "_destination", "_result",
"_vehicle", "_grp"];

//Marcadores y variables requeridos por el script.

if (isnil "SAC_FNC") exitwith {"ERROR: SAC_CTS - ""SAC_FNC"" is not initialized in SAC_CTS." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_C_trafficVeh") exitwith {"ERROR: SAC_CTS - ""SAC_UDS_C_trafficVeh"" is not initialized in SAC_CTS." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_C_Men") exitwith {"ERROR: SAC_CTS - ""SAC_UDS_C_Men"" is not initialized in SAC_CTS." call SAC_fnc_MPhintC};
if (isnil "SAC_CTS_Blacklist") exitwith {"ERROR: SAC_CTS - ""SAC_CTS_Blacklist"" is not initialized in SAC_CTS." call SAC_fnc_MPhintC};
if (isnil "SAC_CTS_Greenzones") exitwith {"ERROR: SAC_CTS - ""SAC_CTS_Greenzones"" is not initialized in SAC_CTS." call SAC_fnc_MPhintC};
if (isnil "SAC_CTS_interval") exitwith {"ERROR: SAC_CTS - ""SAC_CTS_interval"" is not initialized in SAC_CTS." call SAC_fnc_MPhintC};
if (isnil "SAC_CTS_trackFlyingPlayers") exitwith {"ERROR: SAC_CTS - ""SAC_CTS_trackFlyingPlayers"" is not initialized in SAC_CTS." call SAC_fnc_MPhintC};
{

	if !(_x in allMapMarkers) then {(_x + " marker is missing.") call SAC_fnc_MPsystemChat};
	
} forEach SAC_CTS_Blacklist;
{

	if !(_x in allMapMarkers) then {(_x + " marker is missing.") call SAC_fnc_MPsystemChat};
	
} forEach SAC_CTS_Greenzones;

SAC_CTS_vehicles = [];
SAC_CTS_units = [];

SAC_CTS = true;

"CTS initialized." call SAC_fnc_MPsystemChat;

sleep (5 + random 5);


_interval = 60*SAC_CTS_interval;
_nextCarTime = time + _interval;

private _itsTimeToClean = 0;

while {true} do {

	sleep 10;

	//_t1 = diag_tickTime;

	if (time > _nextCarTime) then {
	
		_centers = [500, SAC_CTS_Greenzones, SAC_CTS_trackFlyingPlayers, true] call SAC_fnc_groupsOfPlayers;
		
		
		//("unidades: " + str (count _centers)) call SAC_fnc_MPsystemChat;
		//("encontrar unidades: " + str (diag_tickTime - _t1)) call SAC_fnc_MPsystemChat;
		//sleep 2;
		//_t1 = diag_tickTime;
		
		{
		
			_centralPos = _x;
			
			if ((_centralPos isNotEqualTo [0,0,0]) && {!surfaceIsWater _centralPos}) then {

				//["_centralPos", "_startMinDistance", "_startMaxDistance", "_destMinDistance", "_destMaxDistance", "_blacklistMarkers"]
				_returnedArray = [_centralPos, 1000, 1500, 500, 3500, SAC_CTS_Blacklist] call SAC_fnc_trafficGetRoute;
				_result = _returnedArray select 0;
				_start = _returnedArray select 1; //devuelve un road segment
				_destination = _returnedArray select 2; //devuelve un road segment
				
				if (_result) then {
				
					_returnedArray = [getPos _start, getPos _destination, SAC_UDS_C_trafficVeh, SAC_UDS_C_Men, [1, 3], [0.1, 0.1], [50, 70], "YELLOW", "CARELESS", false] call SAC_fnc_sendCar;
					_vehicle = _returnedArray select 0;
					_grp = _returnedArray select 1;

					
					_vehicle setVariable ["SAC_CAR_DESTINATION", getPos _destination];
					_vehicle setVariable ["SAC_CTS_TTL", time + (7*60)];
					_vehicle setVariable ["SAC_CTS_speed_zero_counter", 0];
					
					SAC_CTS_vehicles pushBack _vehicle;
					SAC_CTS_units append units _grp;
					
					{_x setVariable ["SAC_CTS_TTL", time + (7*60)]} forEach units _grp;
					
					// if (faction driver _vehicle == "CIV_F") then {
					
						// {_x forceAddUniform selectRandom SAC_bis_altis_civilian_clothes} forEach units _grp;
					
					// };
				
				};
			
			};
			
			sleep 0.5;
			
			//_t1 = diag_tickTime;
			
		} forEach _centers;
		
		_nextCarTime = time + _interval;
		
	};

	if (_itsTimeToClean >= 12) then {
	
		[] call SAC_CTS_fnc_cleaner;
		
		_itsTimeToClean = 0;
		
	} else {
	
		_itsTimeToClean = _itsTimeToClean + 1;
	
	};
	
	//("cleaning: " + str (diag_tickTime - _t1)) call SAC_fnc_MPsystemChat;
	//_t1 = diag_tickTime;

	//["_vehicles", "_blacklistMarkers", "_combatMode", "_behaviour", "_minDistance", "_maxDistance"];
	[SAC_CTS_vehicles, SAC_CTS_Blacklist, "BLUE", "CARELESS", 500, 3500] call SAC_fnc_trafficRetasker;
	
	//("retasker: " + str (diag_tickTime - _t1)) call SAC_fnc_MPsystemChat;
	//_t1 = diag_tickTime;

};

