/*
	Descripción:
	Genera tráfico de vehículos que le disparan al bando del jugador.
	
	Las siguientes variables tienen que estar definidas como variables globales antes de ejecutar el script:
	
	SAC_ITS_prob				//la probabilidad de que se cree un vehículo (se evalúa cada 15 minutos)
	SAC_ITS_VBIED_prob		//la probabilidad de que el vehículo lleve explosivos y los detone si llega cerca del bando del jugador
	SAC_ITS_Blacklist		//un array de áreas indicadas por markers ó triggers, dentro de las cuales no se generarán unidades.
	SAC_ITS_Greenzones		//un array de áreas indicadas por markers ó triggers, dentro de las cuales la presencia de jugadores no es seguida.
	
	Uso:
	[] spawn compile preprocessFileLineNumbers "sac_insurgency_traffic.sqf";
	

*/

If (!isServer) exitWith {};

SAC_ITS_fnc_cleaner = {

	//Buscar los vehículos que se deban borrar.
	private _v = [];
	{
	
		if (([_x, 700] call SAC_fnc_notNearPlayerSide_2) && {(time > _x getVariable "SAC_ITS_TTL") || {_x getVariable "SAC_ITS_speed_zero_counter" >= 2}}) then {

			_v pushBack _x;
			deleteVehicle (_x getVariable ["SAC_ITS_TRIGGER", objnull]);
			/*
			Se observo que en el caso de que la tripulacion estuviera viva, la misma queda de a pie,
			y si la tripulacion estuviera muerta, se borra junto con el vehiculo (despejando correctamente
			allDeadMen).
			*/
			deleteVehicle _x;
			
		} else {
		
			if (speed _x == 0) then {_x setVariable ["SAC_ITS_speed_zero_counter", (_x getVariable "SAC_ITS_speed_zero_counter") + 1]};
		
		};
	
	} forEach SAC_ITS_vehicles;
	
	//Buscar las personas que se deban borrar.
	private _u = [];
	{
	
		if (!alive _x) then {

			if ([_x, 50] call SAC_fnc_notNearPlayerSide_2) then {
		
				_u pushBack _x;
			
				[_x] call SAC_fnc_deleteUnit;
				
			};
			
		} else {
	
			if (((time > _x getVariable "SAC_ITS_TTL") || (isNull objectParent _x)) && {[_x, 700] call SAC_fnc_notNearPlayerSide_2}) then {
			
				_u pushBack _x;
				
				[_x] call SAC_fnc_deleteUnit;
				
			};
			
		};

	} forEach SAC_ITS_units;
	
	SAC_ITS_vehicles = SAC_ITS_vehicles - _v;
	SAC_ITS_units = SAC_ITS_units - _u;
	
};

SAC_ITS_fnc_detonateVBIED = {

	params ["_trigger"];
	
	private _vehicle = _trigger getVariable ["SAC_ITS_VEHICLE", objNull];
	
	//((selectRandom SAC_ieds) createVehicle (getPos _trigger)) setDammage 1;
	//("SatchelCharge_Remote_Ammo_Scripted" createVehicle (getPos _trigger)) setDammage 1;
	if (alive driver _vehicle) then {
	
		//La mayoría de las veces se detona el vehículo, pero también puede detonarse una Mk84 (240Kg)
		if (random 1 < .5) then {
		
			(_trigger getVariable ["SAC_ITS_VEHICLE", objNull]) setDammage 1;
			
		} else {
		
			[["Bomb_04_F", getPos _vehicle, 20, 30, 30, 50, 150], "SAC_fnc_impact", false, false] call BIS_fnc_MP;
			
		};
	};

};

private ["_t1", "_centralPos", "_centers", "_nextCarTime", "_interval", "_temp", "_returnedArray", "_result", "_start", "_destination", "_trigger", "_civilian"];

//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitwith {"""SAC_FNC"" is not initialized in SAC_ITS." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_O_G_insurgencyTraffic") exitwith {"""SAC_UDS_O_G_insurgencyTraffic"" is not initialized in SAC_ITS." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_O_G_Soldiers") exitwith {"""SAC_UDS_O_G_Soldiers"" is not initialized in SAC_ITS." call SAC_fnc_MPhintC};
if (isnil "SAC_ITS_Blacklist") exitwith {"""SAC_ITS_Blacklist"" is not initialized in SAC_ITS." call SAC_fnc_MPhintC};
if (isnil "SAC_ITS_Greenzones") exitwith {"""SAC_ITS_Greenzones"" is not initialized in SAC_ITS." call SAC_fnc_MPhintC};
if (isnil "SAC_ITS_prob") exitwith {"""SAC_ITS_prob"" is not initialized in SAC_ITS." call SAC_fnc_MPhintC};
if (isnil "SAC_ITS_VBIED_prob") exitwith {"""SAC_ITS_VBIED_prob"" is not initialized in SAC_ITS." call SAC_fnc_MPhintC};

{

	if !(_x in allMapMarkers) then {(_x + " marker is missing.") call SAC_fnc_MPsystemChat};
	
} forEach SAC_ITS_Blacklist;
{

	if !(_x in allMapMarkers) then {(_x + " marker is missing.") call SAC_fnc_MPsystemChat};
	
} forEach SAC_ITS_Greenzones;

SAC_ITS_vehicles = [];
SAC_ITS_units = [];

SAC_ITS = true;

"ITS initialized." call SAC_fnc_MPsystemChat;

sleep (5 + random 5);
/*
//Esto es copiado de TPW y supuestamente ayuda a reducir la caída de FPS cuando se crean autos y unidades nuevas. Para mí esto no reduce nada. EXPERIMENTAL.
{
_temp = _x createvehicle [0,0,1000]; 
sleep 0.1;
deletevehicle _temp;
} foreach SAC_UDS_O_G_Soldiers;

{
_temp = _x createvehicle [0,0,1000]; 
sleep 0.1;
deletevehicle _temp;
} foreach SAC_UDS_O_G_insurgencyTraffic;
*/

_interval = 60*15;
//_interval = 30; systemChat "ITS in debug mode!";
_nextCarTime = time + _interval;

private _itsTimeToClean = 0;

while {true} do {

	sleep 10;

	//_t1 = diag_tickTime;

	if (time > _nextCarTime) then {
	
		if (random 1 < SAC_ITS_prob) then {
		
			_centers = [500, SAC_ITS_Greenzones, false, true] call SAC_fnc_groupsOfPlayers;
			
			//("unidades: " + str (count _centers)) call SAC_fnc_MPsystemChat;
			//("encontrar unidades: " + str (diag_tickTime - _t1)) call SAC_fnc_MPsystemChat;
			//sleep 2;
			//_t1 = diag_tickTime;
			
			_interval = 60*15;
			//_interval = 30; systemChat "ITS in debug mode!";
			{
			
				_centralPos = _x;
				
				if (_centralPos isNotEqualTo [0,0,0]) then {

					_returnedArray = [_centralPos, 1000, 1500, 500, 3500, SAC_ITS_Blacklist] call SAC_fnc_trafficGetRoute;
					_result = _returnedArray select 0;
					_start = _returnedArray select 1; //devuelve un road segment
					_destination = _returnedArray select 2; //devuelve un road segment
					
					if (_result) then {
					
						//El vehículo civil es un cambión lleno de explosivos conducido por un civil, mientras que el otro es un camión o camioneta conducido por
						//insurgentes con armas, que pueden o no llevar el vehículo con explosivos.
						_civilian = if (random 1 < 0.5) then {true} else {false};
					
						if (_civilian) then {
							//["_start", "_destination", "_vehicleClasses", "_unitClasses", "_unitCount", "_skill", "_speed", "_combatMode", "_behaviour", "_setCaptive"]
							_returnedArray = [getPos _start, getPos _destination, SAC_UDS_C_trafficVeh, SAC_UDS_C_Men, [0, 0], [0.3, 0.5], [], "YELLOW", "CARELESS", false] call SAC_fnc_sendCar;
						} else {
							//["_start", "_destination", "_vehicleClasses", "_unitClasses", "_unitCount", "_skill", "_speed", "_combatMode", "_behaviour", "_setCaptive"]
							_returnedArray = [getPos _start, getPos _destination, SAC_UDS_O_G_insurgencyTraffic, SAC_UDS_O_G_Soldiers, [2, 4], [0.3, 0.5], [], "YELLOW", "CARELESS", true] call SAC_fnc_sendCar;
						};
						_vehicle = _returnedArray select 0;
						_grp = _returnedArray select 1;

						driver _vehicle disableAI "TARGET";
						
						if (_civilian || (random 1 < SAC_ITS_VBIED_prob)) then {
						
							/*
							Agregar trigger pegado al vehiculo, que lo detone si detecta unidades del lado del jugador
							*/
							_trigger = createTrigger ["EmptyDetector", getPos _vehicle];
							_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
							_trigger setTriggerArea [5 + random 10, 5 + random 10, 0, false];
							_trigger setTriggerType "NONE";
							_trigger setTriggerStatements ["this","[thisTrigger] spawn SAC_ITS_fnc_detonateVBIED",""];
							_trigger attachTo [_vehicle, [0,0,.5]];
							_trigger setVariable ["SAC_ITS_VEHICLE", _vehicle];
							
							_vehicle setVariable ["SAC_ITS_TRIGGER", _trigger];
							
							_vehicle addMagazineCargo ["SatchelCharge_Remote_Mag", 4];
							
							/**/
							
						};
						
						_vehicle setVariable ["SAC_CAR_DESTINATION",getPos  _destination];
						_vehicle setVariable ["SAC_ITS_TTL", time + (7*60)];
						_vehicle setVariable ["SAC_ITS_speed_zero_counter", 0];

						SAC_ITS_vehicles pushBack _vehicle;
						SAC_ITS_units append units _grp;
						
						{_x setVariable ["SAC_ITS_TTL", time + (7*60)]} forEach units _grp;
						
					} else {
					
						_interval = 60;
					
					};

				};
				
				sleep 0.5;
				
				//_t1 = diag_tickTime;
				
			} forEach _centers;
			
		};
		
		_nextCarTime = time + _interval;
		
	};

	if (_itsTimeToClean >= 12) then {
	
		[] call SAC_ITS_fnc_cleaner;
		
		_itsTimeToClean = 0;
		
	} else {
	
		_itsTimeToClean = _itsTimeToClean + 1;
	
	};

	//("cleaning: " + str (diag_tickTime - _t1)) call SAC_fnc_MPsystemChat;
	//_t1 = diag_tickTime;

	[SAC_ITS_vehicles, SAC_ITS_Blacklist, "YELLOW", "CARELESS", 500, 3500] call SAC_fnc_trafficRetasker;
	
	//("retasker: " + str (diag_tickTime - _t1)) call SAC_fnc_MPsystemChat;
	//_t1 = diag_tickTime;

};

