/*
	Descripción:
	Genera patrullas de infantería en las áreas en que se detectan jugadores. Son patrullas de 4 puntos, distribuidos por toda el área que van ocupando los jugadores.
	
	Las siguientes variables tienen que estar definidas como variables globales antes de ejecutar el script:
	
	SAC_IPS_unitClasses					un array con las clases de las unidades que integran las patrullas
	SAC_IPS_skill							un array con la skill de las unidades a crear, por ej. [0.2, 0.4]
	SAC_IPS_minUnits						la cantidad minima de unidades por grupo
	SAC_IPS_maxUnits						la cantidad máxima de unidades por grupo
	SAC_IPS_minDistanceFromPlayers
	SAC_IPS_minDistanceBetweenPoints
	SAC_IPS_maxGroups						la cantidad maxima de patrullas alrededor de cada grupo de jugadores
	SAC_IPS_Blacklist						un array de áreas indicadas por markers ó triggers, dentro de las cuales no se generarán unidades
	SAC_IPS_Greenzones					un array de áreas indicadas por markers ó triggers, dentro de las cuales la presencia de jugadores no es seguida
	SAC_IPS_maxDistanceFromCenter
	SAC_IPS_interval						el intervalo con el que evalua la generación de patrullas
	SAC_IPS_trackFlyingPlayers			true para que los jugadores volando también generen las patrullas
	
	Uso:
	[] spawn compile preprocessFileLineNumbers "sac_infantry_patrols_real.sqf";
	

*/

If (!isServer) exitWith {};

#define TTL 7

SAC_IPS_fnc_cleaner = {

	private ["_u", "_g", "_deleted"];

	//diag_log ("DEBUG: " + str SAC_IPS_units);
	
	//Buscar las personas que se deban borrar.
	_u = [];
	{
	
		if (!alive _x) then { //si está muerto
		
			if ([_x, 50] call SAC_fnc_notNearPlayers) then { //borrarlo si no hay players cerca
			
				_u pushBack _x;
				
				[_x] call SAC_fnc_deleteUnit;
			
			};
		
		} else { //si está vivo
		
			if (time > _x getVariable "SAC_IPS_TTL") then { //si se pasó su TTL
			
				//4/6/2020 Antes era 900 mts.
				if ([_x, 600] call SAC_fnc_notNearPlayers) then { //borrarlo si no hay players cerca
				
					_u pushBack _x;
					
					[_x] call SAC_fnc_deleteUnit;
				
				};
			
			};

		};
		
	} forEach SAC_IPS_units;
	
	//diag_log ("DEBUG: " + str SAC_IPS_units);

	SAC_IPS_units = SAC_IPS_units - _u;
	
	if ({isNull _x} count SAC_IPS_units > 0) then {systemChat "Null elements in SAC_IPS_units: " + str ({isNull _x} count SAC_IPS_units)};
	
	//diag_log ("DEBUG: " + str SAC_IPS_units);
	
	//Borrar cualquier grupo vacío.
	SAC_IPS_groups = SAC_IPS_groups - ([SAC_IPS_groups, [], 0, 0] call SAC_fnc_irrelevantItems);
	
};

private ["_t1", "_centralPos", "_startPos", "_dir", "_destPos", "_centers", "_unit", "_location", "_vehicle", "_nextPatrolTime", "_interval", "_temp",
"_distance", "_grps", "_patrolsNear", "_nearestPlayer", "_p1", "_p2", "_movementDir"];

//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitwith {"ERROR: SAC_IPS - ""SAC_FNC"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_unitClasses") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_unitClasses"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_Blacklist") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_Blacklist"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_Greenzones") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_Greenzones"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_maxGroups") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_maxGroups"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_skill") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_skill"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_minUnits") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_minUnits"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_maxUnits") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_maxUnits"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_minDistanceFromPlayers") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_minDistanceFromPlayers"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_minDistanceBetweenPoints") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_minDistanceBetweenPoints"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_maxDistanceFromCenter") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_maxDistanceFromCenter"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_interval") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_interval"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};
if (isnil "SAC_IPS_trackFlyingPlayers") exitwith {"ERROR: SAC_IPS - ""SAC_IPS_interval"" is not initialized in SAC_IPS." call SAC_fnc_MPhintC};

//if (true) exitWith {systemChat str SAC_IPS_Blacklist};
{

	if !(_x in allMapMarkers) then {(_x + " marker is missing.") call SAC_fnc_MPsystemChat};
	
} forEach SAC_IPS_Blacklist;
{

	if !(_x in allMapMarkers) then {(_x + " marker is missing.") call SAC_fnc_MPsystemChat};
	
} forEach SAC_IPS_Greenzones;

SAC_IPS_groups = [];
SAC_IPS_units = [];

SAC_IPS = true;

"IP initialized." call SAC_fnc_MPsystemChat;

sleep (5 + random 5);


_interval = 60 * SAC_IPS_interval;
_nextPatrolTime = time + _interval;
while {true} do {

	//15/7/2020 Un sleep aparte del _nextPatrolTime permite que se borren las unidades irrelevantes con más
	//frecuencia de la que se controla su generación, sin embargo, cuando el valor del intervalo de generación
	//es casi igual al de borrado de unidades, se termina alterando el resultado de generación esperado. Debido
	//a esto, por el momento los unifico, haciendo que el sleep sea igual al intervalo de generación (+ 10 seg
	//para estar seguros de que cada vez que se despierte también se haya entrado en el tiempo de generación
	//de unidades)
	sleep _interval + 10;

	//_t1 = diag_tickTime;

	if (time > _nextPatrolTime) then {
	
		//systemChat "IPS main execution...";
	
		_centers = [500, SAC_IPS_Greenzones, SAC_IPS_trackFlyingPlayers, true] call SAC_fnc_groupsOfPlayers;
		
		//("unidades: " + str (count _centers)) call SAC_fnc_MPsystemChat;
		//("encontrar unidades: " + str (diag_tickTime - _t1)) call SAC_fnc_MPsystemChat;
		//sleep 2;
		//_t1 = diag_tickTime;
		
		{
		
			_centralPos = _x;
			
/*	15/7/2020 Desactivo la predicción de movimiento porque si la posición central predecida está en el agua, no se genera nada,
	y me parece que puede ser demasiado probable en algunos mapas.
				
			//trato de encontrar el player que se asocia a este "centro"
			_nearestPlayer = [_centralPos] call SAC_fnc_nearestPlayer;
		
			if (!isNull _nearestPlayer) then { //es improbable que sea null pero por las dudas
			
				if (speed vehicle _nearestPlayer > 20) then { //si el player está en un vehículo voy a tomar el area a la que se dirije como centro
				
					_centralPos = _nearestPlayer getPos [SAC_IPS_maxDistanceFromCenter, getDir vehicle _nearestPlayer];
					
				};
				
			
			};
*/

			//[_centralPos, "ColorRed", "", "", [SAC_IPS_maxDistanceFromCenter, SAC_IPS_maxDistanceFromCenter], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;




			
			if ((!surfaceIsWater _centralPos) && {[_centralPos, SAC_IPS_Greenzones] call SAC_fnc_isNotBlacklisted} && {[_centralPos, SAC_PLAYER_SIDE, 350] call SAC_fnc_countNearEnemies < 20}) then {
			
				_patrolsNear = {{(alive _x) && {_x distance _centralPos < 1200}} count units _x >= 2} count SAC_IPS_groups;
				
				if ((_centralPos isNotEqualTo [0,0,0]) && {_patrolsNear < SAC_IPS_maxGroups}) then {
				
					//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"]
					_grps = [_centralPos, SAC_IPS_maxDistanceFromCenter, (SAC_IPS_maxGroups - _patrolsNear), ["militia"], SAC_IPS_unitClasses, [], [], SAC_IPS_Blacklist, SAC_IPS_minDistanceFromPlayers, SAC_IPS_minDistanceBetweenPoints, false, true, false, 15, false, false] call SAC_fnc_addInfantryPatrols;

	
					if (count _grps > 0) then {
					
						SAC_IPS_groups append _grps;
						
						{
							
							SAC_IPS_units append units _x;
						
							{_x setVariable ["SAC_IPS_TTL", time + (TTL*60)]} forEach units _x;
							
						} forEach _grps;
					
					};
					
				};
				
			};
			
			sleep 0.3;
			
			//_t1 = diag_tickTime;
			
		} forEach _centers;
		
		_nextPatrolTime = time + _interval;
		
	};

	//systemChat "IPS cleaning up...";
	[] call SAC_IPS_fnc_cleaner;
	
	//("cleaning: " + str (diag_tickTime - _t1)) call SAC_fnc_MPsystemChat;
	//_t1 = diag_tickTime;

};

