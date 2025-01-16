/*
	Descripción:
	Ocupa edificios con infantería en las áreas en que se detectan jugadores.
	Las 'garrisons' usan simulación dinámica y no se borran nunca una vez que se generan.
	Las unidades están fijas dentro de los edificios o pueden salir si deciden atacar, al azar, en una proporción de 70/30.
	
	Las siguientes variables tienen que estar definidas como variables globales antes de ejecutar el script:
	
	SAC_DGS_unitClasses					//un array con las clases de las unidades que integran las patrullas
	SAC_DGS_skill							//un array con la skill de las unidades a crear, por ej. [0.2, 0.4]
	SAC_DGS_minUnits						//la cantidad minima de unidades por grupo
	SAC_DGS_maxUnits						//la cantidad máxima de unidades por grupo
	SAC_DGS_minDistanceFromPlayers
	SAC_DGS_maxGroups						//la cantidad maxima de edificios alrededor de cada grupo de jugadores
	SAC_DGS_Blacklist						//un array de áreas indicadas por markers ó triggers, dentro de las cuales no se generarán unidades
	SAC_DGS_Greenzones					//un array de áreas indicadas por markers ó triggers, dentro de las cuales la presencia de jugadores no es seguida
	SAC_DGS_maxDistanceFromCenter
	SAC_DGS_interval
	
	Uso:
	[] spawn compile preprocessFileLineNumbers "sac_dynamic_garrisons.sqf";
	

*/

If (!isServer) exitWith {};

private ["_centralPos", "_centers", "_nextPatrolTime", "_interval", "_temp", "_grpsNear",
"_nearestPlayer", "_p1", "_p2", "_movementDir", "_grpsToCreate"];

//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitwith {"""SAC_FNC"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};
if (isnil "SAC_DGS_unitClasses") exitwith {"""SAC_DGS_unitClasses"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};
if (isnil "SAC_DGS_Blacklist") exitwith {"""SAC_DGS_Blacklist"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};
if (isnil "SAC_DGS_Greenzones") exitwith {"""SAC_DGS_Greenzones"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};
if (isnil "SAC_DGS_maxGroups") exitwith {"""SAC_DGS_maxGroups"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};
if (isnil "SAC_DGS_skill") exitwith {"""SAC_DGS_skill"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};
if (isnil "SAC_DGS_minUnits") exitwith {"""SAC_DGS_minUnits"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};
if (isnil "SAC_DGS_maxUnits") exitwith {"""SAC_DGS_maxUnits"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};
if (isnil "SAC_DGS_minDistanceFromPlayers") exitwith {"""SAC_DGS_minDistanceFromPlayers"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};
if (isnil "SAC_DGS_maxDistanceFromCenter") exitwith {"""SAC_DGS_maxDistanceFromCenter"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};
if (isnil "SAC_DGS_interval") exitwith {"""SAC_DGS_interval"" is not initialized in SAC_DGS." call SAC_fnc_MPhintC};

//if (true) exitWith {systemChat str SAC_DGS_Blacklist};
{

	if !(_x in allMapMarkers) then {(_x + " marker is missing.") call SAC_fnc_MPsystemChat};
	
} forEach SAC_DGS_Blacklist;
{

	if !(_x in allMapMarkers) then {(_x + " marker is missing.") call SAC_fnc_MPsystemChat};
	
} forEach SAC_DGS_Greenzones;


SAC_DGS_units = [];

SAC_DGS = true;

"DGS initialized." call SAC_fnc_MPsystemChat;

sleep (5 + random 5);

private _allowWater = if (isNil "SAC_DGS_allowWater") then {false} else {SAC_DGS_allowWater};
private _allGrps = [];
private _u = [];
	
_interval = 60 * SAC_DGS_interval;

while {true} do {

	sleep _interval;

	//systemChat "DG main execution...";

	_centers = [500, SAC_DGS_Greenzones, false, true] call SAC_fnc_groupsOfPlayers;

	{
	
		_centralPos = _x;
		
		
		//trato de encontrar el player que se asocia a este "centro"
		_nearestPlayer = [_centralPos] call SAC_fnc_nearestPlayer;
	
		if (!isNull _nearestPlayer) then { //es improbable que sea null pero por las dudas
		
			if (speed vehicle _nearestPlayer > 20) then { //si el player está en un vehículo voy a tomar el area a la que se dirije como centro

				_centralPos = _nearestPlayer getPos [SAC_DGS_maxDistanceFromCenter, getDir vehicle _nearestPlayer];
				
			};
			
		
		};


		//[_centralPos, "ColorRed", "", "", [SAC_DGS_maxDistanceFromCenter, SAC_DGS_maxDistanceFromCenter], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;



		if (_centralPos isNotEqualTo [0,0,0]) then {
		
			if (((_allowWater) || {!surfaceIsWater _centralPos}) && {[_centralPos, SAC_DGS_Greenzones] call SAC_fnc_isNotBlacklisted}) then {

				_grpsNear = {_x distance _centralPos < SAC_DGS_maxDistanceFromCenter} count SAC_garrisons;
				
				_grpsToCreate = SAC_DGS_maxGroups - _grpsNear;

				if (_grpsToCreate > 0) then {
					
					//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes","_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
					_allGrps = ([_centralPos, _grpsToCreate, 0, SAC_DGS_maxDistanceFromCenter, [7,2], SAC_DGS_minDistanceFromPlayers, false, SAC_DGS_Blacklist, ["militia"], SAC_DGS_unitClasses, [], [], [], [SAC_DGS_minUnits, SAC_DGS_maxUnits], 0.65, SAC_UDS_O_G_garrisonVeh, [], [], [], 0, SAC_fucked_up_buildings, true, 0.5] call SAC_fnc_addGarrisons) select 0;

					{
					
						//como no se borran nunca, es casi obligatorio activarles la simulación dinámica
						_x enableDynamicSimulation true;
						
						SAC_DGS_units append units _x;
						
						
					} forEach _allGrps;
					
				
				};
				
			};
			
		};
		
		sleep 0.3;
		
	} forEach _centers;
	


	//diag_log ("DEBUG: " + str SAC_IPS_units);
	
	//Buscar las personas que se deban borrar.
	_u = [];
	{
	
		if (!alive _x) then {
		
			if ([_x, 50] call SAC_fnc_notNearPlayers) then { //borrarlo si no hay players cerca
			
				_u pushBack _x;
				
				[_x] call SAC_fnc_deleteUnit;
			
			};
		
		};
		
	} forEach SAC_DGS_units;
	
	SAC_DGS_units = SAC_DGS_units - _u;

};

