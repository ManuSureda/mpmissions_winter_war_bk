/*
	
	TACTICAL RESPONSE
	
	[] call compile preprocessFileLineNumbers "sac_tac_multi_instance_202105.sqf";

	Las siguientes variables tienen que estar definidas como variables globales antes de ejecutar el script:
	
	SAC_TAC_initDelay					//delay en minutos, se usa para retrasar la ejecuci�n de cada instancia
	SAC_TAC_dynamic_greenzones			//activa el sistema de greenzones dyn�micas (23/11/2019)
	SAC_TAC_interval					//cada cu�ntos minutos se evaluar� el env�o de ataques
	SAC_TAC_intervalVariation			//un valor en minuto que se va a sumar al intervalo, que puede variar por cada ciclo entre 0 y el valor
	SAC_TAC_groupsPerRun				//la cantidad de respuestas por intervalo
	SAC_TAC_groupsPerRunVariation		//un valor entre 0 y _groupsPerRunVariation, que se sumar� a _groupsPerRun, recalculado por cada ciclo
	SAC_TAC_maxGroupsTotal				//si hay esta cantidad de grupos del lado del TAC en todo el escenario, no se crean m�s
	SAC_TAC_maxGroupsTAC				//si hay esta cantidad de grupos generados por este TAC, no se crean m�s
	SAC_TAC_Blacklists					//array de marcadores dentro de los cuales no se generar�n unidades ni waypoints
	SAC_TAC_infClasses					//ademas de definir las unidades que se generan, define las unidades que apoya esta instancia (typeOf leader _grp in SAC_TAC_infClasses)
	SAC_TAC_transportVehClasses
	SAC_TAC_armedVehNoArmorClasses
	SAC_TAC_armedVehArmorIFVClasses
	SAC_TAC_armedVehArmorAPCClasses
	SAC_TAC_armorTankClasses
	SAC_TAC_helicopterClasses
	SAC_TAC_skill						//[0.3, 0.5]
	SAC_TAC_responseTypesSquematic		//ej. ["INF_FOOT", 6, "INF_VEHICLE", 4, "INF_HELICOPTER", 1, "VEHICLE_NOARMOR", 3, "VEHICLE_ARMOR_IFV", 2, "VEHICLE_ARMOR_TANK", 1]
	SAC_TAC_pilotClass
	SAC_TAC_crewClasses
	SAC_TAC_minUnits					//define el tama�o m�nimo del grupo que se env�a
	SAC_TAC_maxUnits
	SAC_TAC_markerNames					//un array de strings que identifica a los marcadores a utilizar como lugares para reforzar/atacar
	SAC_TAC_playersAsTargets			//el TAC incluir� la posici�n de los players cuando elija a donde atacar, excepto que est�n en las blacklists
	SAC_TAC_playersAsTargets_prob		//la prob de que SAC_TAC_playersAsTargets ejecute el ataque
	SAC_TAC_dynamicGreenzonesTTL		//tiempo de vida en minutos de las greenzones dyn�micas (pasar cero para hacerlas infinitas)
	
	Luego estas variables se copian en variables privadas, para permitir correr otra instancia.
	
	Se pueden poner marcadores en el mapa con el texto "TAC_TARGET_REGULAR" y "TAC_TARGET_MILITIA", y todas las instancias de TAC los trataran como posiciones a donde mandar ataques.
	"TAC_TARGET" se tratar� como objetivo para todos los TAC que haya corriendo. Dos "TAC_TARGET_REGULAR" y "TAC_TARGET_MILITIA", se pueden reemplazar por un "TAC_TARGET".
	
*/

If (!isServer) exitWith {};

//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_FNC." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_initDelay") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_initDelay." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_dynamic_greenzones") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_dynamic_greenzones." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_interval") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_interval." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_intervalVariation") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_intervalVariation." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_groupsPerRun") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_groupsPerRun." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_groupsPerRunVariation") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_groupsPerRunVariation." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_maxGroupsTotal") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_maxGroupsTotal." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_maxGroupsTAC") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_maxGroupsTAC." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_Blacklists") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_Blacklists." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_infClasses") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_infClasses." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_transportVehClasses") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_transportVehClasses." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_armedVehNoArmorClasses") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_armedVehNoArmorClasses." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_armedVehArmorAPCClasses") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_armedVehArmorAPCClasses." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_armedVehArmorIFVClasses") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_armedVehArmorIFVClasses." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_armorTankClasses") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_armorTankClasses." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_helicopterClasses") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_helicopterClasses." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_skill") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_skill." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_responseTypesSquematic") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_responseTypesSquematic." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_pilotClass") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_pilotClass." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_crewClasses") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_crewClasses." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_minUnits") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_minUnits." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_maxUnits") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_maxUnits." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_markerNames") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_markerNames." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_playersAsTargets") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_playersAsTargets." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_playersAsTargets_prob") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_playersAsTargets_prob." call SAC_fnc_MPhintC};
if (isnil "SAC_TAC_dynamicGreenzonesTTL") exitwith {"ERROR: SAC_TAC - Falta inicializar SAC_TAC_dynamicGreenzonesTTL." call SAC_fnc_MPhintC};

{

	if !(_x in allMapMarkers) then {(format ["ERROR: SAC_TAC - Falta el marcador %1", _x]) call SAC_fnc_MPsystemChat};
	
} forEach SAC_TAC_Blacklists;

if ("INF_HELICOPTER" in SAC_TAC_responseTypesSquematic) then {

	if (count SAC_TAC_helicopterClasses ==  0) then {
	
		"Error: SAC_TAC - Se indica el uso de helicopteros, pero el array de clases esta vacio." call SAC_fnc_MPhintC;
	
	};
	if (SAC_TAC_pilotClass == "") then {
	
		"Error: SAC_TAC - Se indica el uso de helicopteros, pero no esta definida la clase del piloto." call SAC_fnc_MPhintC;
	
	};

};

if ("VEHICLE_ARMOR_TANK" in SAC_TAC_responseTypesSquematic) then {

	if (count SAC_TAC_armorTankClasses ==  0) then {
	
		"Error: SAC_TAC - Se indica el uso de tanques, pero el array de clases esta vacio." call SAC_fnc_MPhintC;
	
	};
	if (count SAC_TAC_crewClasses ==  0) then {
	
		"Error: SAC_TAC - Se indica el uso de tanques, pero el array de clases de tripulacion esta vacio." call SAC_fnc_MPhintC;
	
	};

};

if ("VEHICLE_ARMOR_APC" in SAC_TAC_responseTypesSquematic) then {

	if (count SAC_TAC_armedVehArmorAPCClasses ==  0) then {
	
		"Error: SAC_TAC - Se indica el uso de APCs, pero el array de clases esta vacio." call SAC_fnc_MPhintC;
	
	};
	if (count SAC_TAC_crewClasses ==  0) then {
	
		"Error: SAC_TAC - Se indica el uso de APCs, pero el array de clases de tripulacion esta vacio." call SAC_fnc_MPhintC;
	
	};

};

if ("VEHICLE_ARMOR_IFV" in SAC_TAC_responseTypesSquematic) then {

	if (count SAC_TAC_armedVehArmorIFVClasses ==  0) then {
	
		"Error: SAC_TAC - Se indica el uso de IFVs, pero el array de clases esta vacio." call SAC_fnc_MPhintC;
	
	};
	if (count SAC_TAC_crewClasses ==  0) then {
	
		"Error: SAC_TAC - Se indica el uso de IFVs, pero el array de clases de tripulacion esta vacio." call SAC_fnc_MPhintC;
	
	};

};

private _initDelay = SAC_TAC_initDelay;
private _dynamic_greenzones = SAC_TAC_dynamic_greenzones;					//activa el uso de greenzones dyn�micas (23/11/2019)
private _interval = SAC_TAC_interval;										//cada cu�ntos minutos se evaluar� el env�o de refuerzos
private _intervalVariation = SAC_TAC_intervalVariation;
private _groupsPerRun = SAC_TAC_groupsPerRun;								//la cantidad de respuestas por intervalo
private _groupsPerRunVariation = SAC_TAC_groupsPerRunVariation;				//una variaci�n que se aplica a la cantidad de respuestas por intervalo
private _maxGroupsTotal = SAC_TAC_maxGroupsTotal;							//si hay esta cantidad de grupos del bando de este TAC en todo el escenario, no se crean m�s
private _maxGroupsTAC = SAC_TAC_maxGroupsTAC;
private _blacklists = SAC_TAC_Blacklists;									//array de marcadores dentro de los cuales no se generar�n unidades ni waypoints
private _infClasses = SAC_TAC_infClasses;
private _transportVehClasses = SAC_TAC_transportVehClasses;
private _armedVehNoArmorClasses = SAC_TAC_armedVehNoArmorClasses;
private _armedVehArmorAPCClasses = SAC_TAC_armedVehArmorAPCClasses;
private _armedVehArmorIFVClasses = SAC_TAC_armedVehArmorIFVClasses;
private _armorTankClasses = SAC_TAC_armorTankClasses;
private _helicopterClasses = SAC_TAC_helicopterClasses;
private _skill = SAC_TAC_skill;
private _responseTypesSquematic = SAC_TAC_responseTypesSquematic;
private _side = [_infClasses select 0] call SAC_fnc_getSideFromCfg;
private _pilotClass = SAC_TAC_pilotClass;
private _crewClasses = SAC_TAC_crewClasses;
private _minUnits = SAC_TAC_minUnits;
private _maxUnits = SAC_TAC_maxUnits;
private _markerNames = SAC_TAC_markerNames;
private _playersAsTargets = SAC_TAC_playersAsTargets;
private _playersAsTargets_prob = SAC_TAC_playersAsTargets_prob;
private _dynamicGreenzonesTTL = SAC_TAC_dynamicGreenzonesTTL * 60;

private _responseTypes = [_responseTypesSquematic] call SAC_fnc_squematicToArray;

//(str _responseTypes) call SAC_fnc_debugNotify;

SAC_TAC = true;

#define TTL 20
//#define TTL 4
//[] spawn {sleep 10; systemChat "TTL del TAC en 4 funcionado como debug!!!!!"};

(format ["TAC %1 initialized", _side]) call SAC_fnc_MPsystemChat;

[_initDelay, _dynamic_greenzones, _interval, _intervalVariation, _groupsPerRun, _groupsPerRunVariation, _maxGroupsTotal,
_maxGroupsTAC, _blacklists, _infClasses, _transportVehClasses, _armedVehNoArmorClasses, _armedVehArmorAPCClasses,
_armedVehArmorIFVClasses,	_armorTankClasses, _helicopterClasses, _skill, _responseTypes, _side, _pilotClass, 
_crewClasses, _minUnits, _maxUnits, _markerNames, _playersAsTargets, _playersAsTargets_prob, _dynamicGreenzonesTTL] spawn {

	params ["_initDelay", "_dynamic_greenzones", "_interval", "_intervalVariation", "_groupsPerRun", "_groupsPerRunVariation",
	"_maxGroupsTotal","_maxGroupsTAC", "_blacklists", "_infClasses", "_transportVehClasses", "_armedVehNoArmorClasses", 
	"_armedVehArmorAPCClasses", "_armedVehArmorIFVClasses",	"_armorTankClasses","_helicopterClasses", "_skill", "_responseTypes",
	"_side", "_pilotClass", "_crewClasses", "_minUnits", "_maxUnits", "_markerNames", "_playersAsTargets", "_playersAsTargets_prob",
	"_dynamicGreenzonesTTL"];
	
	private ["_u", "_v", "_grp", "_reinforcementsSent", "_returnedArray", "_vehicle", "_crewGrp", "_responseTypesTemp", "_responseType",
	"_tacTargetMarkers","_greenZoneMarker", "_centers", "_center", "_validTargetPositions", "_m"];
	
	private _groups = [];
	private _units = [];
	private _vehicles = [];
	
	private _tacTargetsPos = [];
	
	private _dynamicGreenzones = [];
	
	systemChat format["TAC waiting: %1 minutes", _initDelay];
	sleep (60 * _initDelay);
	
	while {true} do {

		//systemChat "TAC main execution...";
	
		//Actualizar lista de TAC_MARKERs. Recalcularlos cada vez me permite mover los marcadores despu�s de comenzada la misi�n y TAC los sigue.
		_tacTargetMarkers = [];
		{

			if (markerText _x in _markerNames) then {_tacTargetMarkers pushBack _x};

		} forEach allMapMarkers;

		//Buscar los veh�culos que se deban borrar (antes de borrarlos borrar la tripulaci�n tambi�n).
		_v = [];
		{
		
			if (!alive _x) then {
			
				if ([_x, 150] call SAC_fnc_notNearPlayerSide_2) then {
				
					_v pushBack _x;
					/*
					Se observo que en el caso de que la tripulacion estuviera viva, la misma queda de a pie,
					y si la tripulacion estuviera muerta, se borra junto con el vehiculo (despejando correctamente
					allDeadMen).
					*/
					deleteVehicle _x;
				
				};
			
			} else {
			
				if (time > _x getVariable "SAC_TTL") then { //si se pas� su TTL
				
					//4/6/2020 Antes era 900 mts.
					if ([_x, 600] call SAC_fnc_notNearPlayerSide_2) then {
					
						_v pushBack _x;
						
						/*
						Se observo que en el caso de que la tripulacion estuviera viva, la misma queda de a pie,
						y si la tripulacion estuviera muerta, se borra junto con el vehiculo (despejando correctamente
						allDeadMen).
						*/
						deleteVehicle _x;
					
					};
				
				};

			};
		
		} forEach _vehicles;
		
		_vehicles = _vehicles - _v;
		
		//Buscar las personas que se deban borrar.
		_u = [];
		{
		
			if (!alive _x) then {
			
				if ([_x, 50] call SAC_fnc_notNearPlayerSide_2) then {
				
					_u pushBack _x;
					
					[_x] call SAC_fnc_deleteUnit;
					
				};
			
			} else {
			
				if (time > _x getVariable "SAC_TTL") then {
				
					//4/6/2020 Antes era 900 mts.
					if ([_x, 600] call SAC_fnc_notNearPlayerSide_2) then {
					
						_u pushBack _x;
						
						[_x] call SAC_fnc_deleteUnit;
					
					};
				
				};

			};
		
		} forEach _units;

		_units = _units - _u;
		
		//diag_log ("DEBUG: " + str _vehicles);
		//diag_log ("DEBUG: " + str _units);
		
		//Borrar cualquier grupo vac�o.
		_groups = _groups - ([_groups, [], 0, 0] call SAC_fnc_irrelevantItems);
		
		if (_dynamicGreenzonesTTL != 0) then {
		
			//Borrar las greenzones din�micas luego del TTL especificado
			_m = [];
			{
			
//systemChat format ["evaluando greenzone dinamica: %1 > %2", time, (markerText _x)  + _dynamicGreenzonesTTL];

				if (time > (parseNumber (markerText _x)) + _dynamicGreenzonesTTL) then {
				
//systemChat "borrando una greenzone dinamica";
					_m pushBack _x;
					deleteMarkerLocal _x;
				
				};
			
			} forEach _dynamicGreenzones;
			
			_dynamicGreenzones = _dynamicGreenzones - _m;
			
		};
		
		
		if (count groups _side <= _maxGroupsTotal) then {
		
			if (count _groups <= _maxGroupsTAC) then {


				_centers = [500, _blacklists + _dynamicGreenzones, false, true] call SAC_fnc_groupsOfPlayers;
				
				_validTargetPositions = [];
				
				{
				
					_center = _x;
				
					{
					
						if ((behaviour leader _x == "COMBAT") && {leader _x distance _center < 300} && {typeOf leader _x in _infClasses}) then {
						
							_validTargetPositions pushBack _center;
						
						};

					} forEach groups _side;
				
				} forEach _centers;

				_tacTargetsPos = [];
				{
				
					_tacTargetsPos pushback ((getMarkerPos _x) getPos [random ((getMarkerSize _x) select 0), round random 360]);
				
				} forEach _tacTargetMarkers;
				
				_validTargetPositions append _tacTargetsPos;
				
				if (_playersAsTargets && {random 1 < _playersAsTargets_prob}) then {
				
					{
					
						if (([_x, _blacklists + _dynamicGreenzones] call SAC_fnc_isNotBlacklisted) && {[_x] call SAC_fnc_isNotFlying} && {!surfaceIsWater getPos _x}) then {
						
							_validTargetPositions pushBack getPos _x;
						
						};
						
					} forEach allPlayers;
				
				};
			
				_validTargetPositions = _validTargetPositions call SAC_fnc_shuffleArray;

				_reinforcementsSent = 0;
				{
				
					_responseTypesTemp = +_responseTypes;
				
					//Si la posici�n est� en un bosque no mando veh�culos que no puedan entrar en los bosques.
					if ([_x, 50, 15] call SAC_fnc_isForest) then {
					
						_responseTypesTemp = _responseTypesTemp - ["VEHICLE_NOARMOR", "VEHICLE_ARMOR_APC", "VEHICLE_ARMOR_IFV", "VEHICLE_ARMOR_TANK"]
					
					};
					
					while {count _responseTypesTemp > 0} do {
					
						_responseType =  selectRandom _responseTypesTemp;
						
						//["INF_FOOT", "INF_VEHICLE", "INF_HELICOPTER", "VEHICLE_NOARMOR", "VEHICLE_ARMOR_APC", "VEHICLE_ARMOR_IFV", "VEHICLE_ARMOR_TANK"]
						switch (_responseType) do {
				
							case "INF_FOOT": { //infanter�a a pie
								
								//systemChat "TAC trying INF_FOOT...";
							
								//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_spawnDistance","_playerExclusionDistance","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"]
								_returnedArray = [_x, 1, 1, 0, _infClasses, [700, 1000], 600, [_minUnits, _maxUnits], _skill, _blacklists, false, TTL] call SAC_fnc_sendWavesOfInfantry;
								
								if (count (_returnedArray # 0) > 0) then {
								
									_reinforcementsSent = _reinforcementsSent + 1;
									_groups append (_returnedArray # 0);
									_units append (_returnedArray # 1);
									
								} else {
								
									//systemChat "TAC failed";
									//02/06/2022 Esto debi� estar hace mucho tiempo, porque si no se puede enviar infanter�a, se entra en un bucle
									//infinito. Creo que nunca me pas� porque es muy raro que no se pueda. Lo descubr� estando en un bote a 300 mts.
									//de la costa. Espero que no lo haya dejado para prevenir alguna otra cosa.
									//19/06/2023 Quiero probar la hipotesis de que muchas veces no se podia enviar infanteria, y el bucle infinito
									//hacia que finalmente se enviara. Para eso voy a poner un mensaje cada vez que no se pueda enviar.
									systemChat "TAC: No se pudo enviar infanteria!";
									_responseTypesTemp = _responseTypesTemp - ["INF_FOOT"];
								
								};

							};
							case "INF_VEHICLE": { //infanter�a en veh�culo (no artillado)
							
								//systemChat "TAC trying INF_VEHICLE...";
							
								//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"]
								_returnedArray = [_x, 1, 1, 0, _infClasses, _transportVehClasses, [_minUnits, _maxUnits], _skill, _blacklists, false, TTL] call SAC_fnc_sendWavesOfInfantryInVehicles;
								
								if (count (_returnedArray # 0) > 0) then {
								
									_reinforcementsSent = _reinforcementsSent + 1;
									_groups append (_returnedArray # 0);
									_units append (_returnedArray # 1);
									_vehicles append (_returnedArray # 2);
								
								} else {
								
									//systemChat "TAC failed";
									//la raz�n por la que saco tambi�n a los interceptores, que tiene menos requisitos, es porque si no puedo enviar tropas en camiones, y no saco a los
									//interceptores, aumentar�an las probabilidades de enviar un interceptor, sin importar cu�n bajas hayan sido especificadas. Deber�a quitar, siguiendo
									//el mismo criterio, a los helic�pteros, pero por ahora los dejo y ver� como sale.
									_responseTypesTemp = _responseTypesTemp - ["INF_VEHICLE", "VEHICLE_ARMOR_TANK", "VEHICLE_ARMOR_APC", "VEHICLE_ARMOR_IFV", "VEHICLE_NOARMOR"]; //quitar de las opciones las respuestas que tengan los mismos requisitos
								
								};
							
							};
							case "INF_HELICOPTER": { //infanter�a en helic�ptero
							
								//systemChat "TAC trying HELICOPTER...";
								
								//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"]
								//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_crewClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"]
								_returnedArray = [_x, 1, 1, 0, _infClasses, _helicopterClasses, _pilotClass, [_minUnits, _maxUnits], _skill, _blacklists, false, TTL] call SAC_fnc_sendWavesOfInfantryInHelicopter;
								
								if (count (_returnedArray # 0) > 0) then {
								
									_reinforcementsSent = _reinforcementsSent + 1;
									_groups append (_returnedArray # 0);
									_units append (_returnedArray # 1);
									_vehicles append (_returnedArray # 2);
								
								} else {
								
									//systemChat "TAC failed";
									_responseTypesTemp = _responseTypesTemp - ["INF_HELICOPTER"]; //quitar de las opciones las respuestas que tengan los mismos requisitos
								
								};

							};
							case "VEHICLE_NOARMOR": { //veh�culo artillado sin protecci�n, se puede deshabilitar con un rifle de asalto
							
								//systemChat "TAC trying VEHICLE_NOARMOR...";
								
								//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_skill","_blacklists","_runCleaner","_TTL"]
								_returnedArray = [_x, 1, 1, 0, _infClasses, _armedVehNoArmorClasses, _skill, _blacklists, false, TTL] call SAC_fnc_sendWavesOfArmedVehicles;
							
								if (count (_returnedArray # 0) > 0) then {
								
									_reinforcementsSent = _reinforcementsSent + 1;
									_groups append (_returnedArray # 0);
									_units append (_returnedArray # 1);
									_vehicles append (_returnedArray # 2);
									
								} else {
								
									//systemChat "TAC failed";
									_responseTypesTemp = _responseTypesTemp - ["VEHICLE_ARMOR_TANK", "VEHICLE_ARMOR_APC", "VEHICLE_ARMOR_IFV", "VEHICLE_NOARMOR"]; //quitar de las opciones las respuestas que tengan los mismos requisitos
								
								};

							};
							case "VEHICLE_ARMOR_APC": { //veh�culo artillado con protecci�n media, se necesita un explosivo para deshabilitarlo

								//systemChat "TAC trying VEHICLE_ARMOR_APC...";
								
								//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_skill","_blacklists","_runCleaner","_TTL"]
								_returnedArray = [_x, 1, 1, 0, _infClasses, _armedVehArmorAPCClasses, _skill, _blacklists, false, TTL] call SAC_fnc_sendWavesOfArmedVehicles;
							
								if (count (_returnedArray # 0) > 0) then {
								
									_reinforcementsSent = _reinforcementsSent + 1;
									_groups append (_returnedArray # 0);
									_units append (_returnedArray # 1);
									_vehicles append (_returnedArray # 2);
									
								} else {
								
									//systemChat "TAC failed";
									_responseTypesTemp = _responseTypesTemp - ["VEHICLE_ARMOR_TANK", "VEHICLE_ARMOR_APC", "VEHICLE_ARMOR_IFV", "VEHICLE_NOARMOR"]; //quitar de las opciones las respuestas que tengan los mismos requisitos
								
								};

							};
							case "VEHICLE_ARMOR_IFV": { //mejor que un APC, puede ayudar a la infanter�a en la primera l�nea; t�picamente tiene orugas

								//systemChat "TAC trying VEHICLE_ARMOR_IFV...";
								
								//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_skill","_blacklists","_runCleaner","_TTL"]
								_returnedArray = [_x, 1, 1, 0, _infClasses, _armedVehArmorIFVClasses, _skill, _blacklists, false, TTL] call SAC_fnc_sendWavesOfArmedVehicles;
							
								if (count (_returnedArray # 0) > 0) then {
								
									_reinforcementsSent = _reinforcementsSent + 1;
									_groups append (_returnedArray # 0);
									_units append (_returnedArray # 1);
									_vehicles append (_returnedArray # 2);
									
								} else {
								
									//systemChat "TAC failed";
									_responseTypesTemp = _responseTypesTemp - ["VEHICLE_ARMOR_TANK", "VEHICLE_ARMOR_APC", "VEHICLE_ARMOR_IFV", "VEHICLE_NOARMOR"]; //quitar de las opciones las respuestas que tengan los mismos requisitos
								
								};
							
							};
							case "VEHICLE_ARMOR_TANK": { //veh�culo artillado con protecci�n completa, se necesita alto explosivo (javelin, PCML, titan, gunship)
							
								//systemChat "TAC trying VEHICLE_ARMOR_TANK...";
								
								//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_skill","_blacklists","_runCleaner","_TTL"]
								_returnedArray = [_x, 1, 1, 0, _infClasses, _armorTankClasses, _skill, _blacklists, false, TTL] call SAC_fnc_sendWavesOfArmedVehicles;
							
								if (count (_returnedArray # 0) > 0) then {
								
									_reinforcementsSent = _reinforcementsSent + 1;
									_groups append (_returnedArray # 0);
									_units append (_returnedArray # 1);
									_vehicles append (_returnedArray # 2);
									
								} else {
								
									//systemChat "TAC failed";
									_responseTypesTemp = _responseTypesTemp - ["VEHICLE_ARMOR_TANK", "VEHICLE_ARMOR_APC", "VEHICLE_ARMOR_IFV", "VEHICLE_NOARMOR"]; //quitar de las opciones las respuestas que tengan los mismos requisitos
								
								};

							};
						
						};
						
						if (_reinforcementsSent >= _groupsPerRun + round random _groupsPerRunVariation) exitWith {};
						
						//3/10/2019 Vi que seg�n ALIVE se sobrecarga el engine si se crean muchas unidades al mismo tiempo. Aunque no s� si
						//es ac� en donde me est� pasando, ni s� si una pausa ac� mejorar� las cosas, lo voy a probar, porque no veo ning�n
						//efecto negativo.
						//11/11/2019 Casi seguro esto resolvi� el problema.
						sleep 0.3;
						
					};
				
					if (_reinforcementsSent > 0) exitWith {
					
						//systemChat "TAC reinforcement sent";
						//(str _responseTypesTemp) call SAC_fnc_debugNotify;
						
						if (_dynamic_greenzones) then {

							_greenZoneMarker = [_x, "ColorBlue", "", "", [250, 250], ["ELLIPSE", "Border"]] call SAC_fnc_createMarkerLocal;
							_greenZoneMarker setMarkerTextLocal str time;
							_greenZoneMarker setMarkerAlphaLocal 0;
							_dynamicGreenzones pushBack _greenZoneMarker;
							
							//systemChat format ["creado una greenzone dinamica: %1", markerText _greenZoneMarker];
							
						};
					
					};
					
					//3/10/2019 Ver nota sobre ALIVE m�s arriba.
					sleep 0.3;
				
				} forEach _validTargetPositions;
				
				//systemChat "TAC search FINISH";
				
			} else {
			
				"WARNING: SAC_TAC - Max number of TAC groups for the instance reached." call SAC_fnc_debugNotify;
			
			};
			
		} else {
		
			"WARNING: SAC_TAC - Max number of ANY groups for the side reached." call SAC_fnc_debugNotify;
		
		};
		
		sleep (_interval * 60) + ((random _intervalVariation) * 60);
		
	};
};

