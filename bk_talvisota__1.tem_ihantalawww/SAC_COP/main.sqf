//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitWith {"ERROR: SAC_COP - SAC_FNC is not initialized in COP." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_O_G_Soldiers") exitWith {"ERROR: SAC_COP - SAC_UDS_O_G_Soldiers is not initialized in COP." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_O_Soldiers") exitWith {"ERROR: SAC_COP - SAC_UDS_O_Soldiers is not initialized in COP." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_O_G_garrisonVeh") exitWith {"ERROR: SAC_COP - SAC_UDS_O_G_garrisonVeh is not initialized in COP." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_B_bigUAVs") exitWith {"ERROR: SAC_COP - SAC_UDS_B_bigUAVs is not initialized in COP." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_B_HeliPilot") exitWith {"ERROR: SAC_COP - SAC_UDS_B_HeliPilot is not initialized in COP." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_O_G_patrolVeh") exitWith {"ERROR: SAC_COP - SAC_UDS_O_G_patrolVeh is not initialized in COP." call SAC_fnc_MPhintC};
if (isnil "SAC_UDS_O_armedTransport") exitWith {"ERROR: SAC_COP - SAC_UDS_O_armedTransport is not initialized in COP." call SAC_fnc_MPhintC};
if !("SAC_COP_unitsSpawn" in allMapMarkers) exitWith {"ERROR: SAC_COP - SAC_COP_unitsSpawn marker is missing." call SAC_fnc_MPhintC};

if ((!isNil "SAC_COP_CSAR_can_generate") && {SAC_COP_CSAR_can_generate} && {!("SAC_mapButtonLeft" in allMapMarkers)}) exitWith {"ERROR: SAC_COP - Falta definir SAC_mapButtonLeft." call SAC_fnc_MPhintC};
if ((!isNil "SAC_COP_CSAR_can_generate") && {SAC_COP_CSAR_can_generate} && {!("SAC_mapTopRight" in allMapMarkers)}) exitWith {"ERROR: SAC_COP - Falta definir SAC_mapTopRight." call SAC_fnc_MPhintC};
if ((!isNil "SAC_COP_CSAR_can_generate") && {SAC_COP_CSAR_can_generate} && {!("SAC_validMapSection" in allMapMarkers)}) exitWith {"ERROR: SAC_COP - Falta definir SAC_validMapSection." call SAC_fnc_MPhintC};
if ((!isNil "SAC_COP_CSAR_can_generate") && {SAC_COP_CSAR_can_generate} && {isNil "SAC_COP_CSAR_garrisons"}) exitWith {"ERROR: SAC_COP - Falta definir SAC_COP_CSAR_garrisons." call SAC_fnc_MPhintC};

if ((!isNil "SAC_COP_DKT_can_generate") && {SAC_COP_DKT_can_generate} && {!("SAC_COP_KILLTARGET" in allMapMarkers)}) exitWith {"ERROR: SAC_COP - Falta definir SAC_COP_KILLTARGET." call SAC_fnc_MPhintC};
if ((!isNil "SAC_COP_DKT_can_generate") && {SAC_COP_DKT_can_generate} && {isNil "SAC_COP_DKT_garrisons"}) exitWith {"ERROR: SAC_COP - Falta definir SAC_COP_DKT_garrisons." call SAC_fnc_MPhintC};

SAC_COP_buildings_blacklisted_for_interactive_npcs = ["Land_Unfinished_Building_02_F","Land_Misc_deerstand","Land_Unfinished_Building_01_F",
"Land_Ind_TankBig","Land_Warehouse_01_F","Land_StorageTank_01_small_F","Land_StorageTank_01_large_F",
"Land_SCF_01_storageBin_medium_F","Land_SCF_01_storageBin_big_F","Land_SCF_01_storageBin_small_F"];

SAC_COP_blacklists = _this select 0;

{

	if !(_x in allMapMarkers) then {(format["%1 marker is missing in COP.", _x]) call SAC_fnc_MPsystemChat};

} forEach SAC_COP_blacklists;

//"COP running" call SAC_fnc_debugNotify;

if ((!isNil "COP_visualCaching") && {COP_visualCaching}) then {
	
	if (isNil "COP_visualCaching_distance") exitWith {"ERROR: SAC_COP - Falta definir COP_visualCaching_distance." call SAC_fnc_MPhintC};
	
	[COP_visualCaching_distance] spawn {
	
		params ["_distance"];

		"visualCaching running." call SAC_fnc_MPsystemChat;
		
		while {true} do {
		
			private _unit = objNull;
			
			sleep 3;
			
			{
			
				_unit = _x;
			
				if (allPlayers findIf {_x distance _unit < _distance} == -1) then {
				
					_x hideObjectGlobal true;
				
				} else {
				
					_x hideObjectGlobal false;
				
				};
			
			
			} forEach allUnits + allDeadMen;

		};
	};

};

#define DEAD_REM_INTERVAL 60*5

[] spawn {

	"Garbage Collector running." call SAC_fnc_MPsystemChat;
	
	while {true} do {
	
		//sleep DEAD_REM_INTERVAL;
		sleep 60;
		
		[] call SAC_fnc_markGroupsForDeleteWhenEmpty;
		[] call SAC_fnc_deleteAllDeadMen;
	
	};

};


SAC_COP_fnc_createGarrisonedArea = {

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};

	private _howMany = [1, 3] call SAC_fnc_numberBetween;
	
	if (count _this > 3) then {_howMany = (_this select 3)};

	private _markerColor = getMarkerColor (_this select 0);

	private _grpTypes = [];
	private _regUnitClasses = [];
	private _milUnitClasses = [];
	private _regVehClasses = [];
	private _milVehClasses = [];
	switch (_markerColor) do {
	
		case "ColorRed": {
		
			_grpTypes = ["regular"];
			_regUnitClasses = SAC_UDS_O_Soldiers;
			_regVehClasses = SAC_UDS_O_garrisonVeh;
		
		};
		case "ColorGreen": {
		
			_grpTypes = ["militia"];
			_milUnitClasses = SAC_UDS_O_G_Soldiers;
			_milVehClasses = SAC_UDS_O_G_garrisonVeh;
		
		};
		
		case "ColorBlack": {
		
			_grpTypes = ["militia", "regular"];
			_regUnitClasses = SAC_UDS_O_Soldiers;
			_milUnitClasses = SAC_UDS_O_G_Soldiers;
			_regVehClasses = SAC_UDS_O_garrisonVeh;
			_milVehClasses = SAC_UDS_O_G_garrisonVeh;
		
		};
		
		case "ColorBlue": {
		
			_grpTypes = ["regular"];
			_regUnitClasses = SAC_UDS_B_Soldiers;
			_regVehClasses = SAC_UDS_B_garrisonVeh;
		
		};
		
		case "ColorCIV": {
		
			_grpTypes = ["civilian"];
		
		};
		
		default {"cop_garrison: El color del marcador no es valido" call SAC_fnc_debugNotify};

	};
	
	private _allGrps =  [];
	
	//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes","_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
	_allGrps = ([_centerPos, _howMany, 0, _radius, [7,1], 100, false, [], _grpTypes, _milUnitClasses, _regUnitClasses, [], SAC_UDS_C_Men, [3, 5], 0.65, _milVehClasses, _regVehClasses, [], SAC_UDS_C_garrisonVeh, 0.3, SAC_fucked_up_buildings, true, 0] call SAC_fnc_addGarrisons) select 0;

/*	
	if (count _allGrps == 0) exitWith {
	
		systemChat "No valid buildings found.";
		
	};

	systemChat "Area occupied succesfully.";
*/

};

SAC_COP_fnc_createFortifiedArea = {

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};

	
	private _howMany = [2, 3] call SAC_fnc_numberBetween;
	
	if (count _this > 3) then {_howMany = (_this select 3)};
	
	private _mod = if (count _this > 4) then {_this select 4} else {"N"};
	
	private _unitCount = switch (_mod) do {
	
		case "N": {[3, 7]};
		case "H": {[999, 999]};
		case "F": {[555, 555]};
		case "3": {[333, 333]};

	};
	
/*
	private _grpTypes = switch (getMarkerColor (_this select 0)) do {
	
		case "ColorRed": {["regular"]};
		case "ColorGreen": {["militia"]};
		case "ColorBlack": {["militia", "regular"]};
	
	};
*/

	private _markerColor = getMarkerColor (_this select 0);

	private _grpTypes = [];
	private _regUnitClasses = [];
	private _milUnitClasses = [];
	private _regVehClasses = [];
	private _milVehClasses = [];
	switch (_markerColor) do {
	
		case "ColorRed": {
		
			_grpTypes = ["regular"];
			_regUnitClasses = SAC_UDS_O_Soldiers;
			_regVehClasses = SAC_UDS_O_garrisonVeh;
		
		};
		case "ColorGreen": {
		
			_grpTypes = ["militia"];
			_milUnitClasses = SAC_UDS_O_G_Soldiers;
			_milVehClasses = SAC_UDS_O_G_garrisonVeh;
		
		};
		
		case "ColorBlack": {
		
			_grpTypes = ["militia", "regular"];
			_regUnitClasses = SAC_UDS_O_Soldiers;
			_milUnitClasses = SAC_UDS_O_G_Soldiers;
			_regVehClasses = SAC_UDS_O_garrisonVeh;
			_milVehClasses = SAC_UDS_O_G_garrisonVeh;
		
		};
		
		case "ColorBlue": {
		
			_grpTypes = ["regular"];
			_regUnitClasses = SAC_UDS_B_Soldiers;
			_regVehClasses = SAC_UDS_B_garrisonVeh;
		
		};
		
		case "ColorCIV": {
		
			_grpTypes = ["civilian"];
		
		};
		
		default {"cop_fortify: El color del marcador no es valido" call SAC_fnc_debugNotify};

	};
	
	private _hardcoreStopProb = switch (markerBrush (_this select 0)) do {
	
		case "DiagGrid": {1};
		case "Solid": {0};
		case "Horizontal": {0.5};
		default {0};
	
	};
	
	private _allGrps = [];

	//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes","_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
	_allGrps = ([_centerPos, _howMany, 0, _radius, [7,1], 999, false, [], _grpTypes, _milUnitClasses, _regUnitClasses, [], SAC_UDS_C_Men, _unitCount, 0.65, _milVehClasses, _regVehClasses, [], SAC_UDS_C_garrisonVeh, 0, SAC_fucked_up_buildings, true, _hardcoreStopProb] call SAC_fnc_addGarrisons) select 0;


	//21/11/2019 EXPERIMENTAL Desde ahora todos los grupos se generan con simulación dinámica.
	//28/02/2022 Dejo un tiempo para que las unidades "se acomoden" después del teleport, si no
	//quedaban congeladas en posiciones raras y a veces sin tocar el suelo, hasta que se activaba
	//de nuevo la simulación.
	_allGrps spawn {sleep 5; {_x enableDynamicSimulation true} forEach _this};

};

SAC_COP_fnc_helperCreateHostageArea = {

/*

	Busca el edificio más chico y pone 2 unidades como rehenes adentro, y luego pone un grupo OPFOR que hace guardia en el exterior.

*/


	params ["_centerPos", "_radius", "_hostageUnitClasses", "_captorsUnitClasses"];

	private ["_grp", "_building", "_returnedArray"];
	
	//Buscar el edificio mas chico para poner a los rehenes.
	//[_centralPos, _minDistance, _maxDistance, _minPositions, _bannedTypes, _playerExclusionDistance, _blacklist, [_method]] call SAC_fnc_findBuilding;
	_building = [_centerPos, 0, _radius, 2, SAC_fucked_up_buildings, 200, [], "smallest", "empty"] call SAC_fnc_findBuilding;

	if (isNull _building) exitWith {
	
		//systemChat "No valid buildings found."
		
	};
	
	_grp = [getMarkerPos "SAC_COP_unitsSpawn", [_hostageUnitClasses select 0] call SAC_fnc_getSideFromCfg, _hostageUnitClasses, [], [], [0.4, 0.6], [], [2, 0]] call SAC_fnc_spawnGroup;
	{[_x] call SAC_GEAR_applyLoadoutByClass} forEach units _grp;

	[_grp, ["G_Blindfold_01_black_F", "G_Blindfold_01_white_F"]] call SAC_fnc_convertToHostage;
	//[_grp, ["flb_beard_drkbrn", "flb_beard_oldbrn"]] call SAC_fnc_convertToHostage;
	
	_grp deleteGroupWhenEmpty true;
	
	[units _grp, _building, ["auto"], "hardcore_stop"] call SAC_fnc_putUnitsInBuilding;
	
	//["_building", "_unitClasses", "_skill", "_unitCount", "_vehClasses", "_idle", "_autoDeleteGroup", "_hardcoreStop"];
	//_returnedArray = [_building, selectRandom [SAC_UDS_O_G_Soldiers, SAC_UDS_O_Soldiers], [0.2, 0.4], [2, 3], [], true, 1] call SAC_fnc_createGarrison;
	_returnedArray = [_building, _captorsUnitClasses, [0.2, 0.4], [2, 3], [], true, true, 1] call SAC_fnc_createGarrison;
	
};

SAC_COP_fnc_createHostageArea_PILOTS = {

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};

	private _unitClasses = switch (getMarkerColor (_this select 0)) do {
	
		case "ColorRed": {SAC_UDS_O_Soldiers};
		case "ColorGreen": {SAC_UDS_O_G_Soldiers};
		case "ColorBlack": {selectRandom [SAC_UDS_O_G_Soldiers, SAC_UDS_O_Soldiers]};
		default {"cop_hostage: El color del marcador no es valido" call SAC_fnc_debugNotify};
	
	};
	
	
	[_centerPos, _radius, [SAC_UDS_B_HeliPilot, SAC_UDS_B_HeliPilot], _unitClasses] call SAC_COP_fnc_helperCreateHostageArea;
	
};

SAC_COP_fnc_createHostageArea_SOLDIERS = {

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};
	
	private _unitClasses = switch (getMarkerColor (_this select 0)) do {
	
		case "ColorRed": {SAC_UDS_O_Soldiers};
		case "ColorGreen": {SAC_UDS_O_G_Soldiers};
		case "ColorBlack": {selectRandom [SAC_UDS_O_G_Soldiers, SAC_UDS_O_Soldiers]};
		default {"cop_hostage: El color del marcador no es valido" call SAC_fnc_debugNotify};
	
	};
	
	[_centerPos, _radius, SAC_UDS_B_Soldiers, _unitClasses] call SAC_COP_fnc_helperCreateHostageArea;
	
};

SAC_COP_fnc_createCrashedAircraft = {

	private _centerPos = _this call SAC_fnc_getPointDesignation;
	if (_centerPos isEqualTo [0,0,0]) exitWith {};
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};
	
	private ["_vehicle", "_smoke"];

	//Crear la aeronave.
	_vehicle = [SAC_UDS_B_transportHelicopter + SAC_UDS_B_attackHelicopter, _centerPos] call SAC_fnc_createVehicle;
	_vehicle allowDammage false;

	_vehicle setPos _centerPos;

	_vehicle setdammage 0.5;

	_smoke = "test_EmptyObjectForSmoke" createVehicle getMarkerPos "SAC_COP_unitsSpawn";
	_smoke disableCollisionWith _vehicle;
	_smoke attachTo [_vehicle, [0,0,0.5]];

	_vehicle spawn {
		sleep 10;
		_this allowDammage true;
	};
	
	//systemChat "Aircraft created succesfully.";
	
};

SAC_COP_fnc_createAircraftCrew = {

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};
	
	private ["_allGrps", "_grp"];

	//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes","_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
	_allGrps = ([_centerPos, 1, 0, _radius, [3,3], 200, false, [], ["regular"], [], [SAC_UDS_B_HeliPilot], [], [], [1, 3], 0, [], [], [], [], 0, SAC_fucked_up_buildings + SAC_militaryBuildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, true, 1] call SAC_fnc_addGarrisons) select 0;

	if (count _allGrps == 0) then {

		_grp = [_centerPos, [SAC_UDS_B_HeliPilot] call SAC_fnc_getSideFromCfg, [SAC_UDS_B_HeliPilot, SAC_UDS_B_HeliPilot, SAC_UDS_B_HeliPilot], [], [], [0.4, 0.6], [], [[1, 3] call SAC_fnc_numberBetween, 0]] call SAC_fnc_spawnGroup;
		{[_x] call SAC_GEAR_applyLoadoutByClass} forEach units _grp;
		_grp deleteGroupWhenEmpty true;
		
	} else {
	
		_grp = _allGrps select 0;
	
	};

	{removeHeadGear _x} forEach units _grp;
	_grp setCombatMode "GREEN"; //hold fire, defend only

	//systemChat "Crew created succesfully.";

};

SAC_COP_fnc_createDamagedDrone = {

	private _centerPos = _this call SAC_fnc_getPointDesignation;
	if (_centerPos isEqualTo [0,0,0]) exitWith {};
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};
	
	private ["_vehicle"];

	//Crear la drona.
	_vehicle = [SAC_UDS_B_bigUAVs, _centerPos] call SAC_fnc_createVehicle;
	_vehicle allowDammage false;

	_vehicle setPos _centerPos;

	_vehicle setdammage 0.2;

	_vehicle spawn {
		sleep 10;
		_this allowDammage true;
	};
	
	//systemChat "Drone created succesfully.";
	
};

SAC_COP_fnc_createDamagedVehicle = {

	private _centerPos = _this call SAC_fnc_getPointDesignation;
	if (_centerPos isEqualTo [0,0,0]) exitWith {};

	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};
	
	private ["_vehicle", "_nearestRoad"];

	[SAC_UDS_B_unarmedTransport + SAC_UDS_B_APC + SAC_UDS_B_Tanks, _centerPos] call SAC_fnc_createVehicle;
	_vehicle allowDammage false;

	_nearestRoad = [_centerPos, 0, 10, 999, [], 999, "closest"] call SAC_fnc_findRoad;
	if (!isNull _nearestRoad) then {_vehicle setDir (getDir _nearestRoad)};
	
	_vehicle setPos _centerPos;
	
	_vehicle setdammage 0.5;
	
	_smoke = "test_EmptyObjectForSmoke" createVehicle getMarkerPos "SAC_COP_unitsSpawn";
	_smoke disableCollisionWith _vehicle;
	_smoke attachTo [_vehicle, [0,0,0.5]];

	_vehicle spawn {
		sleep 10;
		_this allowDammage true;
	};
	
	//systemChat "BLUE vehicle created succesfully.";
	
};

SAC_COP_fnc_createPatrols = {

	//"COP creating patrols" call SAC_fnc_debugNotify;

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};

	
	private _howMany = 3 min round (_radius / 150);
	
	if (count _this > 3) then {_howMany = (_this select 3)};
	
	private _dynamicSimulation = false;
	if (markerBrush (_this select 0) == "FDiagonal") then {_dynamicSimulation = true};
/*
	private _grpTypes = switch (getMarkerColor (_this select 0)) do {
	
		case "ColorRed": {["regular"]};
		case "ColorGreen": {["militia"]};
		case "ColorBlack": {["militia", "militia", "militia", "militia", "militia", "militia", "regular", "regular", "regular"]};
	
	};
*/	

	private _markerColor = getMarkerColor (_this select 0);

	private _grpTypes = [];
	private _regUnitClasses = [];
	private _sfUnitClasses = [];
	private _milUnitClasses = [];
	switch (_markerColor) do {
	
		case "ColorRed": {
		
			_grpTypes = ["regular"];
			_regUnitClasses = SAC_UDS_O_Soldiers;
			_sfUnitClasses = SAC_UDS_O_SF_Soldiers;
		
		};
		case "ColorGreen": {
		
			_grpTypes = ["militia"];
			_milUnitClasses = SAC_UDS_O_G_Soldiers;
		
		};
		
		case "ColorBlack": {
		
			_grpTypes = ["militia", "militia", "militia", "militia", "militia", "militia", "regular", "regular", "regular"];
			_regUnitClasses = SAC_UDS_O_Soldiers;
			_sfUnitClasses = SAC_UDS_O_SF_Soldiers;
			_milUnitClasses = SAC_UDS_O_G_Soldiers;
		
		};
		
		case "ColorBlue": {
		
			_grpTypes = ["regular"];
			_regUnitClasses = SAC_UDS_B_Soldiers;
			_sfUnitClasses = SAC_UDS_B_SF_Soldiers;
		
		};
		
		default {"cop_patrols: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
	//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"]
	[_centerPos, _radius, _howMany, _grpTypes, _milUnitClasses, _regUnitClasses, _sfUnitClasses, [], 350, _radius / 2, false, true, _dynamicSimulation, 50, false, false] call SAC_fnc_addInfantryPatrols;

};

SAC_COP_fnc_createStaticGroups = {

	//"COP creating patrols" call SAC_fnc_debugNotify;

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};

	
	private _howMany = if (count _this > 3) then {_this select 3} else {3 min round (_radius / 150)};
	
	private _dispersion = if (count _this > 4) then {_this select 4} else {50};
	
	private _dynamicSimulation = false;
	if (markerBrush (_this select 0) == "FDiagonal") then {_dynamicSimulation = true};

	private _markerColor = getMarkerColor (_this select 0);

	private _grpTypes = [];
	private _regUnitClasses = [];
	private _sfUnitClasses = [];
	private _milUnitClasses = [];
	switch (_markerColor) do {
	
		case "ColorRed": {
		
			_grpTypes = ["regular"];
			_regUnitClasses = SAC_UDS_O_Soldiers;
			_sfUnitClasses = SAC_UDS_O_SF_Soldiers;
		
		};
		case "ColorGreen": {
		
			_grpTypes = ["militia"];
			_milUnitClasses = SAC_UDS_O_G_Soldiers;
		
		};
		
		case "ColorBlack": {
		
			_grpTypes = ["militia", "militia", "militia", "militia", "militia", "militia", "regular", "regular", "regular"];
			_regUnitClasses = SAC_UDS_O_Soldiers;
			_sfUnitClasses = SAC_UDS_O_SF_Soldiers;
			_milUnitClasses = SAC_UDS_O_G_Soldiers;
		
		};
		
		case "ColorBlue": {
		
			_grpTypes = ["regular"];
			_regUnitClasses = SAC_UDS_B_Soldiers;
			_sfUnitClasses = SAC_UDS_B_SF_Soldiers;
		
		};
		
		default {"cop_static_groups: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
	//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers", "_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"]
	[_centerPos, _radius, _howMany, _grpTypes, _milUnitClasses, _regUnitClasses, _sfUnitClasses, [], 350, _radius / 2, false, true, _dynamicSimulation, _dispersion, true, true] call SAC_fnc_addInfantryPatrols;

};

SAC_COP_fnc_createMortarTrigger = { //MORTAR@PROB@DISPERSION@ROUNDS@DELAY@MAXSEARCHDISTANCE

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 1} && {random 1 > (_this select 1)}) exitWith {};

	private _dispersion = if (count _this > 2) then {_this select 2} else {50};
	
	private _rounds = if (count _this > 3) then {_this select 3} else {5};
	
	private _delay = if (count _this > 4) then {_this select 4} else {5};
	
	private _maxSearchDistance = if (count _this > 5) then {_this select 5} else {_radius * 2};
	
	private _markerColor = getMarkerColor (_this select 0);

	switch (_markerColor) do {
	
		case "ColorRed": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_REGULAR_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[""Sh_82mm_AMOS"", %1, %2, %3, %4] spawn SAC_fnc_indirectFireBarrageOnNearestPlayerSide", _centerPos, _dispersion, _rounds, _maxSearchDistance]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		case "ColorGreen": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_MILITIA_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[""Sh_82mm_AMOS"", %1, %2, %3, %4] spawn SAC_fnc_indirectFireBarrageOnNearestPlayerSide", _centerPos, _dispersion, _rounds, _maxSearchDistance]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		case "ColorBlue": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[""Sh_82mm_AMOS"", %1, %2, %3, %4] spawn SAC_fnc_indirectFireBarrageOnNearestPlayerSide", _centerPos, _dispersion, _rounds, _maxSearchDistance]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		default {"cop_mortar: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
};

SAC_COP_fnc_createArtyTrigger = { //ARTY@PROB@DISPERSION@ROUNDS@DELAY@MAXSEARCHDISTANCE

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 1} && {random 1 > (_this select 1)}) exitWith {};

	private _dispersion = if (count _this > 2) then {_this select 2} else {50};
	
	private _rounds = if (count _this > 3) then {_this select 3} else {5};
	
	private _delay = if (count _this > 4) then {_this select 4} else {5};
	
	private _maxSearchDistance = if (count _this > 5) then {_this select 5} else {_radius * 2};
	
	private _markerColor = getMarkerColor (_this select 0);

	switch (_markerColor) do {
	
		case "ColorRed": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_REGULAR_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[""Sh_155mm_AMOS"", %1, %2, %3, %4] spawn SAC_fnc_indirectFireBarrageOnNearestPlayerSide", _centerPos, _dispersion, _rounds, _maxSearchDistance]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		case "ColorGreen": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_MILITIA_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[""Sh_155mm_AMOS"", %1, %2, %3, %4] spawn SAC_fnc_indirectFireBarrageOnNearestPlayerSide", _centerPos, _dispersion, _rounds, _maxSearchDistance]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		case "ColorBlue": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[""Sh_155mm_AMOS"", %1, %2, %3, %4] spawn SAC_fnc_indirectFireBarrageOnNearestPlayerSide", _centerPos, _dispersion, _rounds, _maxSearchDistance]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		default {"cop_arty: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
};

SAC_COP_fnc_createInfantryQRFTrigger = { //SENDINFANTRY@PROB@SQUADS@WAVES@DELAY@WAVEDELAY

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 1} && {random 1 > (_this select 1)}) exitWith {};

	private _squads = if (count _this > 2) then {_this select 2} else {3};
	
	private _waves = if (count _this > 3) then {_this select 3} else {2};
	
	private _delay = if (count _this > 4) then {_this select 4} else {0};
	
	private _waveDelay = if (count _this > 5) then {_this select 5} else {120};
	
	private _markerColor = getMarkerColor (_this select 0);

	switch (_markerColor) do {
	
		case "ColorRed": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_REGULAR_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, [600, 800], 500, [5, 8], [0.2, 0.4], %6, true, 20] spawn SAC_fnc_sendWavesOfInfantry", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_Soldiers, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		}; 
		case "ColorGreen": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_MILITIA_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, [600, 800], 500, [5, 8], [0.2, 0.4], %6, true, 20] spawn SAC_fnc_sendWavesOfInfantry", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		case "ColorBlue": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, [600, 800], 500, [5, 8], [0.2, 0.4], %6, true, 20] spawn SAC_fnc_sendWavesOfInfantry", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
			
		};
		
		default {"cop_sendInfantry: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
};

SAC_COP_fnc_createMotorInfantryQRFTrigger = { //SENDMOTORINFANTRY@PROB@SQUADS@WAVES@DELAY@WAVEDELAY

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 1} && {random 1 > (_this select 1)}) exitWith {};

	private _squads = if (count _this > 2) then {_this select 2} else {2};
	
	private _waves = if (count _this > 3) then {_this select 3} else {2};
	
	private _delay = if (count _this > 4) then {_this select 4} else {0};
	
	private _waveDelay = if (count _this > 5) then {_this select 5} else {120};
	
	private _markerColor = getMarkerColor (_this select 0);

	switch (_markerColor) do {
	
		case "ColorRed": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_REGULAR_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [5, 8], [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfInfantryInVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_Soldiers, SAC_UDS_O_unarmedTransport, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"]
		}; 
		case "ColorGreen": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_MILITIA_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [5, 8], [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfInfantryInVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_UDS_O_G_unarmedTransport, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		case "ColorBlue": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [5, 8], [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfInfantryInVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_UDS_O_G_unarmedTransport, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		default {"cop_sendMotorInfantry: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
};

SAC_COP_fnc_createHeliInfantryQRFTrigger = { //SENDHELIINFANTRY@PROB@SQUADS@WAVES@DELAY@WAVEDELAY

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 1} && {random 1 > (_this select 1)}) exitWith {};

	private _squads = if (count _this > 2) then {_this select 2} else {2};
	
	private _waves = if (count _this > 3) then {_this select 3} else {2};
	
	private _delay = if (count _this > 4) then {_this select 4} else {0};
	
	private _waveDelay = if (count _this > 5) then {_this select 5} else {120};
	
	private _markerColor = getMarkerColor (_this select 0);

	switch (_markerColor) do {
	
		case "ColorRed": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_REGULAR_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, ""%7"", [5, 8], [0.2, 0.4], %8, true, 20] spawn SAC_fnc_sendWavesOfInfantryInHelicopter", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_Soldiers, SAC_UDS_O_G_transportHelicopter, SAC_UDS_O_HeliPilot, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_crewClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"]
		}; 
		case "ColorGreen": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_MILITIA_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, ""%7"", [5, 8], [0.2, 0.4], %8, true, 20] spawn SAC_fnc_sendWavesOfInfantryInHelicopter", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_UDS_O_G_transportHelicopter, SAC_UDS_O_G_Soldiers # 0, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		case "ColorBlue": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, ""%7"", [5, 8], [0.2, 0.4], %8, true, 20] spawn SAC_fnc_sendWavesOfInfantryInHelicopter",	_centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_UDS_O_G_transportHelicopter, SAC_UDS_O_G_Soldiers # 0, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		default {"cop_sendHeliInfantry: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
};

SAC_COP_fnc_createTechnicalsQRFTrigger = { //SENDTECHNICALS@PROB@SQUADS@WAVES@DELAY@WAVEDELAY

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 1} && {random 1 > (_this select 1)}) exitWith {};

	private _squads = if (count _this > 2) then {_this select 2} else {1};
	
	private _waves = if (count _this > 3) then {_this select 3} else {2};
	
	private _delay = if (count _this > 4) then {_this select 4} else {0};
	
	private _waveDelay = if (count _this > 5) then {_this select 5} else {60};
	
	private _markerColor = getMarkerColor (_this select 0);

	switch (_markerColor) do {
	
		case "ColorRed": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_REGULAR_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_Soldiers, SAC_UDS_O_armedTransport, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"]
		}; 
		case "ColorGreen": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_MILITIA_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_UDS_O_G_armedTransport, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		case "ColorBlue": {
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_UDS_O_G_armedTransport, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		default {"cop_sendTechnicals: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
};

SAC_COP_fnc_createAPCQRFTrigger = { //SENDAPC@PROB@SQUADS@WAVES@DELAY@WAVEDELAY

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 1} && {random 1 > (_this select 1)}) exitWith {};

	private _squads = if (count _this > 2) then {_this select 2} else {1};
	
	private _waves = if (count _this > 3) then {_this select 3} else {2};
	
	private _delay = if (count _this > 4) then {_this select 4} else {0};
	
	private _waveDelay = if (count _this > 5) then {_this select 5} else {60};
	
	private _markerColor = getMarkerColor (_this select 0);

	switch (_markerColor) do {
	
		case "ColorRed": {
		
			if (count SAC_UDS_O_APC == 0) exitWith {"Error: SENDAPC - SAC_UDS_O_APC esta vacio." call SAC_fnc_MPhintC};
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_REGULAR_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_Soldiers, SAC_UDS_O_APC, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"]
		}; 
		case "ColorGreen": {
		
			if (count SAC_UDS_O_G_APC == 0) exitWith {"Error: SENDAPC - SAC_UDS_O_G_APC esta vacio." call SAC_fnc_MPhintC};
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_MILITIA_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_UDS_O_G_APC, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		case "ColorBlue": {
		
			if (count SAC_UDS_O_G_APC == 0) exitWith {"Error: SENDAPC - SAC_UDS_O_G_APC esta vacio." call SAC_fnc_MPhintC};
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_UDS_O_G_APC, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		default {"cop_sendAPC: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
};

SAC_COP_fnc_createIFVQRFTrigger = { //SENDIFV@PROB@SQUADS@WAVES@DELAY@WAVEDELAY

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 1} && {random 1 > (_this select 1)}) exitWith {};

	private _squads = if (count _this > 2) then {_this select 2} else {1};
	
	private _waves = if (count _this > 3) then {_this select 3} else {2};
	
	private _delay = if (count _this > 4) then {_this select 4} else {0};
	
	private _waveDelay = if (count _this > 5) then {_this select 5} else {60};
	
	private _markerColor = getMarkerColor (_this select 0);

	switch (_markerColor) do {
	
		case "ColorRed": {
		
		
			if (count SAC_UDS_O_IFV == 0) exitWith {"Error: SENDIFV - SAC_UDS_O_IFV esta vacio." call SAC_fnc_MPhintC};
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_REGULAR_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_Soldiers, SAC_UDS_O_IFV, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"]
		}; 
		case "ColorGreen": {
		
			if (count SAC_UDS_O_G_IFV == 0) exitWith {"Error: SENDIFV - SAC_UDS_O_G_IFV esta vacio." call SAC_fnc_MPhintC};
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_MILITIA_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_UDS_O_G_IFV, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		case "ColorBlue": {
		
			if (count SAC_UDS_O_G_IFV == 0) exitWith {"Error: SENDIFV - SAC_UDS_O_G_IFV esta vacio." call SAC_fnc_MPhintC};
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_Soldiers, SAC_UDS_O_G_IFV, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		default {"cop_sendIFV: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
};

SAC_COP_fnc_createTankQRFTrigger = { //SENDTANK@PROB@SQUADS@WAVES@DELAY@WAVEDELAY

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 1} && {random 1 > (_this select 1)}) exitWith {};

	private _squads = if (count _this > 2) then {_this select 2} else {1};
	
	private _waves = if (count _this > 3) then {_this select 3} else {2};
	
	private _delay = if (count _this > 4) then {_this select 4} else {0};
	
	private _waveDelay = if (count _this > 5) then {_this select 5} else {60};
	
	private _markerColor = getMarkerColor (_this select 0);

	switch (_markerColor) do {
	
		case "ColorRed": {
		
			if (count SAC_UDS_O_Tanks == 0) exitWith {"Error: SENDTANK - SAC_UDS_O_Tanks esta vacio." call SAC_fnc_MPhintC};
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_REGULAR_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_TankCrews, SAC_UDS_O_Tanks, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		//["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"]
		}; 
		case "ColorGreen": {
		
			if (count SAC_UDS_O_G_Tanks == 0) exitWith {"Error: SENDTANK - SAC_UDS_O_G_Tanks esta vacio." call SAC_fnc_MPhintC};
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_O_MILITIA_SIDE], "NOT PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_TankCrews, SAC_UDS_O_G_Tanks, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		case "ColorBlue": {
		
			if (count SAC_UDS_O_G_Tanks == 0) exitWith {"Error: SENDTANK - SAC_UDS_O_G_Tanks esta vacio." call SAC_fnc_MPhintC};
		
			private _trigger = createTrigger ["EmptyDetector", _centerPos, false];
			_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
			_trigger setTriggerArea [_radius, _radius, 0, false];
			_trigger setTriggerType "NONE";
			_trigger setTriggerInterval 5;
			_trigger setTriggerStatements 
			[
			"this",
			format ["[%1, %2, %3, %4, %5, %6, [0.2, 0.4], %7, true, 20] spawn SAC_fnc_sendWavesOfArmedVehicles", _centerPos, _squads, _waves, _waveDelay, SAC_UDS_O_G_TankCrews, SAC_UDS_O_G_Tanks, SAC_green_zones]
			,""
			];
			_trigger setTriggerTimeout [_delay, _delay, _delay, false];
		
		};
		
		default {"cop_sendTANK: El color del marcador no es válido." call SAC_fnc_debugNotify};

	};
	
};


SAC_COP_fnc_createTechnical = {

	params ["_marker"];
	
	//diag_log "logging";
	//diag_log _this;
	//diag_log "logging finished";
	
	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};

	private _markerColor = getMarkerColor (_this select 0);
	
	if (_markerColor == "ColorBlack") then {if (random 1 < 0.65) then {_markerColor = "ColorGreen"} else {_markerColor = "ColorRed"}};
	
	private _unitClasses = [];
	private _vehClasses = [];
	switch (_markerColor) do {
	
		case "ColorRed": {
		
			_unitClasses = SAC_UDS_O_Soldiers;
			_vehClasses = SAC_UDS_O_armedTransport;
		
		};
		case "ColorGreen": {
		
			_unitClasses = SAC_UDS_O_G_Soldiers;
			_vehClasses = SAC_UDS_O_G_patrolVeh;
		
		};
		case "ColorBlue": {
		
			_unitClasses = SAC_UDS_B_Soldiers;
			_vehClasses = SAC_UDS_B_armedTransport;
		
		};
		default {"cop_technical: El color del marcador no es válido" call SAC_fnc_debugNotify};

	};
	
	//["_centerPos", "_maxDistance", "_maxVehicles", "_vehClasses", "_crewClasses", "_autoDeleteGroup"];
	[_centerPos, _radius, 1, _vehClasses, _unitClasses, true] call SAC_fnc_createVehicles;

	//systemChat "Operation completed.";
	
};

SAC_COP_fnc_createAPC = {

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};
	
	private _markerColor = getMarkerColor (_this select 0);
	
	private _unitClasses = [];
	private _vehClasses = [];
	switch (_markerColor) do {
	
		case "ColorRed": {
		
			_unitClasses = SAC_UDS_O_TankCrews;
			_vehClasses = SAC_UDS_O_APC;
		
		};
		case "ColorGreen": {
		
			_unitClasses = SAC_UDS_O_G_Soldiers;
			_vehClasses = SAC_UDS_O_G_APC;
		
		};
		case "ColorBlue": {
		
			_unitClasses = SAC_UDS_B_TankCrews;
			_vehClasses = SAC_UDS_B_APC;
		
		};
		
		default {"cop_apc: El color del marcador no es valido" call SAC_fnc_debugNotify};

	};
	
	//["_centerPos", "_maxDistance", "_maxVehicles", "_vehClasses", "_crewClasses", "_autoDeleteGroup"];
	[_centerPos, _radius, 1, _vehClasses, _unitClasses, true] call SAC_fnc_createVehicles;

	//systemChat "Operation completed.";
	
};

SAC_COP_fnc_createIFV = {

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};
	
	private _markerColor = getMarkerColor (_this select 0);
	
	private _unitClasses = [];
	private _vehClasses = [];
	switch (_markerColor) do {
	
		case "ColorRed": {
		
			_unitClasses = SAC_UDS_O_TankCrews;
			_vehClasses = SAC_UDS_O_IFV;
		
		};
		case "ColorGreen": {
		
			_unitClasses = SAC_UDS_O_G_Soldiers;
			_vehClasses = SAC_UDS_O_G_IFV;
		
		};
		case "ColorBlue": {
		
			_unitClasses = SAC_UDS_B_TankCrews;
			_vehClasses = SAC_UDS_B_IFV;
		
		};
		
		default {"cop_apc: El color del marcador no es valido" call SAC_fnc_debugNotify};

	};
	
	//["_centerPos", "_maxDistance", "_maxVehicles", "_vehClasses", "_crewClasses", "_autoDeleteGroup"];
	[_centerPos, _radius, 1, _vehClasses, _unitClasses, true] call SAC_fnc_createVehicles;

	//systemChat "Operation completed.";
	
};

SAC_COP_fnc_createTank = {

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};
	
	private _markerColor = getMarkerColor (_this select 0);
	
	private _unitClasses = [];
	private _vehClasses = [];
	switch (_markerColor) do {
	
		case "ColorRed": {
		
			_unitClasses = SAC_UDS_O_TankCrews;
			_vehClasses = SAC_UDS_O_Tanks;
		
		};
		case "ColorGreen": {
		
			_unitClasses = SAC_UDS_O_G_Soldiers;
			_vehClasses = SAC_UDS_O_G_Tanks;
		
		};
		case "ColorBlue": {
		
			_unitClasses = SAC_UDS_B_TankCrews;
			_vehClasses = SAC_UDS_B_Tanks;
		
		};
		default {"cop_tank: El color del marcador no es valido" call SAC_fnc_debugNotify};

	};
	
	
	//["_centerPos", "_maxDistance", "_maxVehicles", "_vehClasses", "_crewClasses", "_autoDeleteGroup"];
	[_centerPos, _radius, 1, _vehClasses, _unitClasses, true] call SAC_fnc_createVehicles;

	//systemChat "Operation completed.";
	
};

SAC_COP_fnc_createEnemyAirDefense = {

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};
	
	private ["_vehicles", "_grp", "_maxVehicles"];
	
	_maxVehicles = if (_radius <= 50) then {1} else {[1, 2] call SAC_fnc_numberBetween};
	
	//["_centerPos", "_maxDistance", "_maxVehicles", "_vehClasses", "_crewClasses", "_autoDeleteGroup"];
	_vehicles = [_centerPos, _radius, _maxVehicles, SAC_UDS_O_AAVehicles, SAC_UDS_O_TankCrews, true] call SAC_fnc_createVehicles;
	
	{
	
		if (random 1 < 0.5) then {
		
			//["_centerPos", "_minDistance", "_maxDistance", "_playerExclusionDistance", "_blacklistsMarkers", "_unitClasses", "_grpSize", "_skill", "_autoDeleteGroup"]
			_grp = [getPos _x, 0, 50, 999, [], SAC_UDS_O_G_AA_Soldiers, [1, 2], [0.2, 0.4], true] call SAC_fnc_createGroup;
			{[_x] call SAC_GEAR_applyLoadoutByClass} forEach units _grp;
			[_grp] call SAC_fnc_setSkills;
		
		};
	
	} forEach _vehicles;

	//systemChat "Operation completed.";
	
};

SAC_COP_fnc_createRevealArea = {

	private _area = []; //en la forma [_centerPos, _radius]
	_area = _this call SAC_fnc_getAreaDesignation;
	if ((_area select 0) isEqualTo [0,0,0]) exitWith {};
	
	private _centerPos = _area select 0;
	private _radius = _area select 1;
	
	if ((count _this > 1) && {(_this select 1) != 0}) then {sleep (_this select 1)};
	
	if ((count _this > 2) && {(_this select 2) != 1} && {random 1 > (_this select 2)}) exitWith {};
	
	private _trigger = createTrigger ["EmptyDetector", _centerPos];
	_trigger setTriggerActivation [format["%1", SAC_PLAYER_SIDE], "PRESENT", false];
	_trigger setTriggerArea [_radius, _radius, 0, false];
	_trigger setTriggerType "NONE";
	_trigger setTriggerStatements ["this","[thisList, thisTrigger] spawn SAC_COP_fnc_alertZone",""];

	
};

SAC_COP_fnc_alertZone = {

	/*
		Es importante tener en cuenta que está diseñado para interactuar con SAC_TAC. Si bien sin TAC las unidades afectadas van a estar más
		atentas, e incluso algunas van a abrir fuego a las unidades detectadas, por las distancias y los obstáculos, lo más probable es que queden
		en COMBAT, y mirando hacia las unidades detectadas. Esto prepara la situación para que cuando TAC recorra la lista de unidades a reforzar,
		encuentre a estas unidades alertadas, y las unidades detectadas reciban respuesta de TAC. Algo muy importante a tener en cuenta es que TAC
		usa findNearestEnemy, la cual sólo cuenta las unidades con un valor de knowsAbout de 4. Este valor sólo se mantiene durante 2 minutos si la
		unidad no tiene contacto visual con las unidades detectadas. Así que, es un juego entre cuán próxima está la recorrida de TAC, y cuánto falta
		para que el valor de knowsAbout baje de 4, pero en general, creo que a las unidades que traten de penetrar esta zona se les va a complicar
		mucho más que si no estuviera.	
	
	*/


	params ["_thisList", "_thisTrigger"];
	
	private _unitsToReveal = +_thisList;
	private _center = getPos _thisTrigger;
	private _radius = (triggerArea _thisTrigger) select 0;
	
	private _g = grpNull;
	
	{
	
		_g = _x;
		
		if ((side _g in [SAC_O_REGULAR_SIDE, SAC_O_MILITIA_SIDE]) && {leader _g distance _center <= _radius}) then {
		
			_g setBehaviour "COMBAT";
			{
			
				_g reveal [_x, 4];
			
			} forEach _unitsToReveal;
	
		};

	} forEach allGroups;


};

SAC_COP_fnc_dyn_CSAR = {

	#define RADIUS 1500
	#define RADIUS_13 500

	SAC_COP_dyn_CSAR_aoCheckRadius =

		switch (toLower(worldName)) do
		{

			case "chernarus_winter";
			case "chernarus_summer";
			case "cup_chernarus_a3";
			case "ruha";
			case "chernarus": {RADIUS};
			case "woodland_acr": {RADIUS};//Bystrica
			case "fallujah": {RADIUS};
			case "zargabad": {RADIUS};
			case "mcm_Aliabad": {RADIUS};
			case "fata": {RADIUS};
			case "praa_av": {RADIUS};//afghan village
			case "kunduz": {RADIUS};
			case "tem_anizay";
			case "lythium";
			case "uzbin";
			case "kidal";
			case "takistan": {RADIUS};
			case "rhspkl";
			case "smd_sahrani_a3";
			case "sahrani";
			case "sara";
			case "sara_dbe1";
			case "sehreno";
			case "smd_sahrani_a2": {RADIUS};
			case "tembelan";
			case "malden";
			case "dakrong";
			case "jnd_balong";
			case "swu_public_rhode_map"; //mutambara
			case "tanoa": {RADIUS/2};
			case "beketov": {RADIUS};
			case "jnd_dakpek_terrain";
			case "vt7";
			case "hellanmaa";
			case "enoch";
			case "wl_rosche";
			case "altis": {RADIUS};
			case "bornholm": {RADIUS};
			case "isladuala3": {RADIUS_13};
			case "panthera3": {RADIUS_13};
			case "pja305": {RADIUS};//Nziwasogo
			case "pja314": {RADIUS};//Leskovets
			case "dya": {RADIUS}; //Diyala
			case default {
				worldName call SAC_fnc_debugNotify;
			};

		};

	(parseText "<t color='#FFFFFF' size='1.2'><br/>Marking CSAR location...<br/></t>") call SAC_fnc_MPhint;

	private ["_isLandArea", "_iteration", "_grp", "_building", "_treeAreas", "_found", "_trigger", "_possibleAreas", "_tempMarkers"];

	//Buscar una celda con suficiente tierra alrededor, en donde crear el helicóptero caído.
	_isLandArea = false;
	_iteration = 0;
	_possibleAreas = [];
	_tempMarkers = [];
	while {_iteration < 800} do {

		_iteration = _iteration + 1;

		//[_areaButtonLeft, _areaTopRight, _maxIterations, _playerSideExclusionDistance, _waterAllowed, _blacklist] call SAC_fnc_randomPosFromSquare;
		SAC_COP_dyn_CSAR_centerPos = [getMarkerPos "SAC_mapButtonLeft", getMarkerPos "SAC_mapTopRight", 200, 1500, false, SAC_COP_blacklists + _tempMarkers] call SAC_fnc_randomPosFromSquare;

		if (SAC_COP_dyn_CSAR_centerPos isEqualTo [0,0,0]) exitWith {};

		//["_centerPos", "_radius", "_blacklistMarkers", "_whitelistMarkers"];
		_isLandArea = [SAC_COP_dyn_CSAR_centerPos, SAC_COP_dyn_CSAR_aoCheckRadius, SAC_COP_blacklists, ["SAC_validMapSection"]] call SAC_fnc_isLandArea;

		if (_isLandArea) then {
			_tempMarkers pushBack ([SAC_COP_dyn_CSAR_centerPos, "ColorBlue", "", "", [SAC_COP_dyn_CSAR_aoCheckRadius, SAC_COP_dyn_CSAR_aoCheckRadius], ["ELLIPSE", "Border"]] call SAC_fnc_createMarkerLocal);
			_possibleAreas pushBack SAC_COP_dyn_CSAR_centerPos;
		};

	};

	{deleteMarker _x} forEach _tempMarkers;

	_possibleAreas call SAC_fnc_shuffleArray;
	
	private ["_filteredPossibleAreas", "_tempArea", "_areasToDelete"];

	_filteredPossibleAreas = [];
	while {count _possibleAreas > 0} do {

		_tempArea = selectRandom _possibleAreas;
		
		_areasToDelete = [];
		{

			if (_x distance _tempArea < (SAC_COP_dyn_CSAR_aoCheckRadius * 2)) then {_areasToDelete pushBack _x};
			
		} forEach _possibleAreas;

		_possibleAreas = _possibleAreas - _areasToDelete;

		_filteredPossibleAreas pushBack _tempArea;


	};
	/*
	{
		[_x, "ColorBlue", "", "", [SAC_COP_dyn_CSAR_aoCheckRadius, SAC_COP_dyn_CSAR_aoCheckRadius], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;

	} forEach _filteredPossibleAreas;
	*/

	if (count _filteredPossibleAreas == 0) exitWith {(parseText "<t color='#FF0000' size='1.2'><br/>Unable to find suitable start position!<br/></t>") call SAC_fnc_MPhint};

	_filteredPossibleAreas call SAC_fnc_shuffleArray;
	
	SAC_COP_dyn_CSAR_centerPos = selectRandom _filteredPossibleAreas;

	private ["_vehicle", "_smoke1"];

	if (SAC_COP_CSAR_helicopter) then {
	
		//Crear el helicóptero.
		_vehicle = [SAC_COP_CSAR_helicopter_classes, SAC_COP_dyn_CSAR_centerPos] call SAC_fnc_createVehicle;

		_vehicle allowDammage false;

		{
		
			//Each object can contain only 1 reference to the object it disabled collision with.
			//Thus trying to disable collisions with multiple objects will overwrite object previously
			//set for disable collision.
			//_vehicle disableCollisionWith _x;
			_x disableCollisionWith _vehicle;
		
		} forEach (nearestTerrainObjects [SAC_COP_dyn_CSAR_centerPos, ["TREE", "SMALL TREE","POWER LINES","BUILDING", "HOUSE","FENCE", "WALL", "STACK", "RUIN", "ROCK", "ROCKS"], 30, false]);

		_vehicle setPos SAC_COP_dyn_CSAR_centerPos;

		_vehicle setdammage 0.5;

		if (SAC_COP_CSAR_smoke) then {
		
			_smoke1 = "test_EmptyObjectForSmoke" createVehicle getMarkerPos "SAC_COP_unitsSpawn";
			_smoke1 disableCollisionWith _vehicle;
			_smoke1 attachTo [_vehicle, [0,0,0.5]];
			
		};

		_vehicle setVariable ["sac_has_blackbox", true, true];
		
		_vehicle allowDammage true;

		//Crear unidades enemigas alrededor del crash site.
		
		//["_centerPos", "_minDistance", "_maxDistance", "_playerExclusionDistance", "_blacklistsMarkers", "_unitClasses", "_grpSize", "_skill", "_autoDeleteGroup"]
		_grp = [getPos _vehicle, 0 , 50, 999, [], SAC_UDS_O_G_Soldiers call SAC_fnc_shuffleArray, [5, 10], [0.1, 0.3], true] call SAC_fnc_createGroup;
		//["_grp", "_centerPos", "_minDistance", "_maxDistance", "_disableMovement", "_addKilledEH"]
		[_grp, getPos _vehicle, 5, 50, true, true] call SAC_fnc_disperseGroup;
		
		
		//Pongo vehículos alrededor del crash site
		private ["_vehPos", "_veh"];
		for "_i" from 1 to ([1, 3] call SAC_fnc_numberBetween) do {

			//[_centerPos, _minDistance, _posSize, _maxTerrainGradient, _roadAllowed, _noplayerDistance, _maxDistance, _debug, _blacklist] call SAC_fnc_safePosition;
			_vehPos = [SAC_COP_dyn_CSAR_centerPos, 10, 6, 10, true, 999, 100, false, []] call SAC_fnc_safePosition;

			if (count _vehPos > 0) then {

				_veh = [SAC_UDS_O_G_trafficUnarmed, _vehPos] call SAC_fnc_createVehicle;

				//_car setDir (getDir _building);
				_veh setDir (getDir (nearestBuilding _veh)); //el problema actual con nearestBuilding es que no reconoce los edificios de los mapas de A2

				_veh setPos _vehPos;

			};

		};
		
		if !(SAC_COP_CSAR_crew_reveals_helicopter_pos) then {
		
			//Crear el marcador en el mapa.
			[SAC_COP_dyn_CSAR_centerPos, "ColorRed", " Vehículo", "hd_destroy_noShadow", [0.5, 0.5]] call SAC_fnc_createMarker;
			
			/*
			[SAC_COP_dyn_CSAR_centerPos, "ColorRed", "", "", [100, 100], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
			[SAC_COP_dyn_CSAR_centerPos, "ColorRed", "", "", [200, 200], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
			[SAC_COP_dyn_CSAR_centerPos, "ColorRed", "", "", [300, 300], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
			[SAC_COP_dyn_CSAR_centerPos, "ColorRed", "", "", [400, 400], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
			[SAC_COP_dyn_CSAR_centerPos, "ColorRed", "", "", [500, 500], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
			*/
		};
		
		//22/11/2021 Genera un grupo de garrisons, que pueden o no salir de sus edificios (_hardcoreStop = 0.5).
		if ((SAC_COP_CSAR_garrisons > 0) && {random 1 < SAC_COP_CSAR_garrisons_prob}) then {
		
			//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes","_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
			[SAC_COP_dyn_CSAR_centerPos, SAC_COP_CSAR_garrisons, 0, SAC_COP_CSAR_garrisons_radius, [8,3], 200, (random 1 < 0.5), [], ["militia"], SAC_UDS_O_G_Soldiers, [], [], [], [3, 5], 0.65, SAC_UDS_O_G_garrisonVeh, [], [], [], 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings, true, 0.5] call SAC_fnc_addGarrisons;
			
		};
		
	};
	
	if (SAC_COP_CSAR_crew) then {
	
		private ["_group1", "_group2", "_group1Pos", "_group2Pos", "_currentGroup", "_currentGroupPos", "_captiveProb", "_unitsToHide"];

		private _unitCount = 0;
		private _survivorGroupNumber = 1;
		while {_survivorGroupNumber <= SAC_COP_CSAR_survivors_groups} do {
		
			_unitCount = if (_survivorGroupNumber == 1) then {SAC_COP_CSAR_units_group_1} else {SAC_COP_CSAR_units_group_2};
			
			//Crear las unidades a extraer.
			//[format ["DEBUG - _unitCount = %1", _unitCount]] call SAC_fnc_MPsystemChat;
			
			private _survClasses = [];
			if (isNil "SAC_COP_CSAR_survClasses") then {
			
				_survClasses = SAC_UDS_B_Soldiers;
			
			} else {
			
				_survClasses = SAC_COP_CSAR_survClasses;
			
			};
			
			_currentGroup = [getMarkerPos "SAC_COP_unitsSpawn", [_survClasses select 0] call SAC_fnc_getSideFromCfg, _survClasses call SAC_fnc_shuffleArray, [], [], [0.1, 0.3], [], [_unitCount, 0]] call SAC_fnc_spawnGroup;
			
			{[_x] call SAC_GEAR_applyLoadoutByClass} forEach units _currentGroup;
			
			[_currentGroup] call SAC_fnc_setSkills;
			
			_currentGroup setBehaviour "CARELESS";
			_currentGroup setCombatMode "BLUE"; //never fire
			{_x setCaptive true} forEach units _currentGroup;
			
			{_x setVariable ["DO_NOT_DELETE", true]} forEach units _currentGroup;
			
			{
			
				if (typeOf _x == SAC_UDS_B_HeliPilot) then {removeHeadGear _x; _x unlinkItem (hmd _x)};
			
			} forEach units _currentGroup;
			
			
			//Encontrar un lugar en donde ponerlas.
			//Hay dos escenarios posibles para la ubicación de los tripulantes vivos, adentro de la celda en la que cayó el helicóptero, o afuera.
			private ["_minDistance", "_maxDistance"];
			switch (selectRandom SAC_COP_CSAR_survivors_groups_pos) do {

				case "within": {

					_minDistance = 600;
					_maxDistance = RADIUS;

				};

				case "outside": {

					_minDistance = RADIUS;
					_maxDistance = RADIUS*1.6;

				};
			};

			//si fueron capturados
			_captiveProb = if (_survivorGroupNumber == 1) then {SAC_COP_CSAR_units_group_1_captive_prob} else {SAC_COP_CSAR_units_group_2_captive_prob};
			if (random 1 < _captiveProb) then {
			
				//["_centerPos", "_minDistance", "_maxDistance", "_playerExclusionDistance", "_blacklistsMarkers", "_unitClasses", "_grpSize", "_skill", "_autoDeleteGroup"]
				_grp = [getMarkerPos "SAC_COP_unitsSpawn", 0 , 50, 999, [], SAC_UDS_O_G_Soldiers call SAC_fnc_shuffleArray, [1, 3], [0.1, 0.3], true] call SAC_fnc_createGroup;
		
			} else {
			
				_grp = grpNull;
				
			};
		
			if (!isNull _grp) then {
			
				_unitsToHide = (units _currentGroup) + (units _grp);
			
			} else {
			
				_unitsToHide = units _currentGroup;
			
			};


			//Se busca un edificio adecuado, si no se encuentra se busca una zona boscosa, y si no se encuentra tampoco, se elige una posición al azar.

			_found = false;

			private _isolated = if (random 1 < 0.5) then {"isolated"} else {""};
			if (!isNil "SAC_COP_CSAR_prefer_survivors_in_cities") then {
			
				_isolated = if (SAC_COP_CSAR_prefer_survivors_in_cities) then {""} else {"isolated"};
				
			};

			//[_centralPos, _minDistance, _maxDistance, _minPositions, _bannedTypes, _playerExclusionDistance, _blacklist, [_method]] call SAC_fnc_findBuilding;
			_building = [SAC_COP_dyn_CSAR_centerPos, _minDistance, _maxDistance, count _unitsToHide, SAC_militaryBuildings + SAC_fucked_up_buildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, 999, SAC_COP_blacklists, "random", _isolated, "empty"] call SAC_fnc_findBuilding;

//_building = objNull;

			if (!isNull _building) then {
			
				[_unitsToHide, _building, ["middle"], "hardcore_stop"] call SAC_fnc_putUnitsInBuilding;

				_building setVariable ["SAC_empty", false];
				
				if (!isNull _grp) then {
				
					[_currentGroup, ["G_Blindfold_01_black_F", "G_Blindfold_01_white_F"]] call SAC_fnc_convertToHostage;
				
				};

				_found = true;

			} else {

				_treeAreas = selectBestPlaces [SAC_COP_dyn_CSAR_centerPos, _maxDistance, "(forest + trees) * (1-houses)", 10, 50];

				private _goodTreeAreas = [];
				{

					if (((_x select 1) > 1) && {(_x select 0) distance SAC_COP_dyn_CSAR_centerPos > _minDistance}) then {

						_goodTreeAreas pushBack (_x select 0);

					};

				} forEach _treeAreas;

				if (count _goodTreeAreas > 0) then {

					private _forestPos = selectRandom _goodTreeAreas;

					[_unitsToHide, _forestPos, 0, 10, true] call SAC_fnc_disperseUnits;

					if (!isNull _grp) then {
					
						[_currentGroup, ["G_Blindfold_01_black_F", "G_Blindfold_01_white_F"]] call SAC_fnc_convertToHostage;
					
					};

					_found = true;

				};

			};

			if (!_found) then {

				//[_centerPos, _minDistance, _posSize, _maxTerrainGradient, _roadAllowed, _noplayerDistance, _maxDistance, _debug, _blacklist] call SAC_fnc_safePosition;
				_currentGroupPos = [SAC_COP_dyn_CSAR_centerPos, _minDistance, 10, 20, false, 999, _maxDistance, false, SAC_COP_blacklists] call SAC_fnc_safePosition;

				if (count _currentGroupPos > 0) then {

					[_unitsToHide, _currentGroupPos, 0, 10, true] call SAC_fnc_disperseUnits;

					if (!isNull _grp) then {
					
						[_currentGroup, ["G_Blindfold_01_black_F", "G_Blindfold_01_white_F"]] call SAC_fnc_convertToHostage;
					
					};

					_found = true;

				};

			};

			if (!_found) exitWith {(parseText "<t color='#FF0000' size='1.2'><br/>No valid location could be found to fit the crew in!<br/></t>") call SAC_fnc_MPhint};

			_currentGroupPos = getPos leader _currentGroup;

			if (_survivorGroupNumber == 1) then {
			
				[_currentGroupPos, "ColorBlue", " Tripulación", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;
				
			};
			
			switch (_survivorGroupNumber) do {
				case 1: {_group1 = _currentGroup; _group1Pos = _currentGroupPos};
				case 2: {_group2 = _currentGroup; _group2Pos = _currentGroupPos};
			};
			
			_survivorGroupNumber = _survivorGroupNumber + 1;
			
		};

		if (SAC_COP_CSAR_crew_reveals_helicopter_pos) then {
		
			//Acción de revelar posición del vehículo.
			//["_object", "_actionTitle", "_titleText", "_actionType", "_position", "_timer"]
			//[leader _group1, "<t color='#FF0000'>*** Vehicle ***</t>", "The unit marked his vehicle's position in your map.", 1, SAC_COP_dyn_CSAR_centerPos getPos [round random 100, round random 360], 0, " Vehicle"] call SAC_fnc_addPredefinedAction;
			
			{
			
				_x setVariable ["SAC_interact_interrogar", true, true];
				_x setVariable ["SAC_interact_crashLocation", SAC_COP_dyn_CSAR_centerPos getPos [round random 100, round random 360], true];
			
			} forEach units _group1;
			
		};
		
		if (SAC_COP_CSAR_survivors_groups == 2) then {
		
			if (SAC_COP_CSAR_crew_reveals_helicopter_pos) then {
			
				//Acción de revelar posición del vehículo.
				//["_object", "_actionTitle", "_titleText", "_actionType", "_position", "_timer"]
				//[leader _group2, "<t color='#FF0000'>*** Vehicle ***</t>", "The unit marked his vehicle's position in your map.", 1, SAC_COP_dyn_CSAR_centerPos getPos [round random 100, round random 360], 0, " Vehicle"] call SAC_fnc_addPredefinedAction;
				
				{
				
					_x setVariable ["SAC_interact_interrogar", true, true];
					_x setVariable ["SAC_interact_crashLocation", SAC_COP_dyn_CSAR_centerPos getPos [round random 100, round random 360], true];
				
				} forEach units _group2;
			
			};

			//Acción de revelar posición del segundo grupo.
			//["_object", "_actionTitle", "_titleText", "_actionType", "_position", "_timer"]
			//[leader _group1, "<t color='#FF0000'>*** Survivors ***</t>", "The unit says they split in two groups, and marked the other group's last known position in your map.", 1, _group2Pos getPos [round random 50, round random 360], 0, " Second Group"] call SAC_fnc_addPredefinedAction;
		
			{
			
				_x setVariable ["SAC_interact_interrogar", true, true];
				_x setVariable ["SAC_interact_2ndGroupLocation", _group2Pos getPos [round random 50, round random 360], true];
			
			} forEach units _group1;

			
		};

	};
	
	//Crear tropas alrededor del vehículos
	
	if ((SAC_COP_CSAR_technicals > 0) && {random 1 < SAC_COP_CSAR_technicals_prob}) then {
	
		//["_centerPos", "_maxDistance", "_maxVehicles", "_vehClasses", "_crewClasses", "_autoDeleteGroup"];
		[SAC_COP_dyn_CSAR_centerPos, SAC_COP_CSAR_technicals_radius, SAC_COP_CSAR_technicals, SAC_UDS_O_G_patrolVeh, SAC_UDS_O_G_Soldiers, true] call SAC_fnc_createVehicles;
		
	};
	
	if ((SAC_COP_CSAR_patrols > 0) && {random 1 < SAC_COP_CSAR_patrols_prob}) then {
	
		//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"]
		[SAC_COP_dyn_CSAR_centerPos, SAC_COP_CSAR_patrols_radius, SAC_COP_CSAR_patrols, ["militia"], SAC_UDS_O_G_Soldiers, [], [], SAC_COP_blacklists, 350, SAC_COP_CSAR_patrols_radius / 2, false, true, false, 50, false, false] call SAC_fnc_addInfantryPatrols;
		
	};
	
	if ((SAC_COP_CSAR_static_groups > 0) && {random 1 < SAC_COP_CSAR_static_groups_prob}) then {
	
		//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_static", "_addKilledEH"]
		[SAC_COP_dyn_CSAR_centerPos, SAC_COP_CSAR_static_groups_radius, SAC_COP_CSAR_static_groups, ["militia"], SAC_UDS_O_G_Soldiers, [], [], SAC_COP_blacklists, 350, SAC_COP_CSAR_static_groups_radius / 2, false, true, true, 50, true, true] call SAC_fnc_addInfantryPatrols;

		
	};
	
	
	//Crear tropas alrededor de los grupos si fueron capturados.
	
	

	//"Mission available." call SAC_fnc_MPsystemChat;
	(parseText "<t color='#FFFFFF' size='1.2'><br/>Location available.<br/></t>") call SAC_fnc_MPhint;

};

SAC_COP_fnc_dyn_killTarget = {

	/*
	
	Genera 3 grupos que ocupan casas diferentes dentro de una misma zona. Uno de esos grupos tiene definido el nombre del objetivo,
	mientras que todos los demás van a resultar en identificación negativa.
	
	Si SAC_COP_DKT_informant no está definido o está definido en false, la función termina colocando marcadores en las tres locaciones.
	Si está definido en true, la función crea un civil en un edificio fuera del radio del area de operaciones en donde están las casas,
	y le agrega a éste la inicialización para que pueda revelar las casas de los objetivos (con sac_interact). En este caso las casas
	no se marcan al principio, y solo se agregar al array SAC_hiddenTargetObjects.
	Si SAC_COP_DKT_extractionguy no está definido o está definido en false, la función termina. Si está definido en true, la función
	crea un civil en un edificio fuera del radio del area de operaciones en donde están los objetivos, y le agrega inicialización para
	que pueda revelar (con sac_interact) la posición en la costa de botes para la extracción (los cuales tambien son, obviamente,
	creados por la función).
	
	Si SAC_COP_DKT_informant y/o SAC_COP_DKT_extractionguy están definidos en true, la función utiliza los marcadores
	SAC_COP_INFORMANTKILLTARGET y SAC_COP_EXTRACTIONGUYKILLTARGET, respectivamente, para decidir la ubicación de los mismos. Si esos
	marcadores no existen, se van a ubicar al informante y al extraction guy en una franja alrededor del area de los objetivos. Es
	decir, se va a generar una misión más compacta en términos de terreno a recorrer. Al contrario, crear de antemano los dos marcadores,
	con la misma extensión que SAC_COP_KILLTARGET, distribuye los objetivos (potencialmente) por todo el mapa.
	
	*/

	if ((!isNil "SAC_COP_DKT_useSpecialInitText") && {SAC_COP_DKT_useSpecialInitText}) then {
	
		(parseText SAC_COP_DKT_specialInitText) call SAC_fnc_MPhint;
	
	} else {
	
		(parseText "<t color='#FFFFFF' size='1.2'><br/>Marking target locations...<br/></t>") call SAC_fnc_MPhint;
		
	};

	private _killTargetBlacklists = +SAC_COP_blacklists;
	
	//Se trata de crear la garrison del objetivo, con la condicion de "isolated" al azar.
	private _isolated = (random 1 < 0.5);
	//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes","_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
	private _returnedArray = [getMarkerPos "SAC_COP_KILLTARGET", 1, 0, (getMarkerSize "SAC_COP_KILLTARGET") select 0, [5,5], 200, _isolated, SAC_COP_blacklists, ["militia"], SAC_UDS_O_G_Soldiers, [], [], [], [3, 5], 0.65, SAC_UDS_O_G_garrisonVeh, [], [], [], 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, true, 1] call SAC_fnc_addGarrisons;
	
	//Si no se encuentra, y se buscó con "isolated", busca sin la condición.
	if ((count (_returnedArray select 0) == 0) && (_isolated)) then {
	
		//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes","_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
		_returnedArray = [getMarkerPos "SAC_COP_KILLTARGET", 1, 0, (getMarkerSize "SAC_COP_KILLTARGET") select 0, [5,5], 200, false, SAC_COP_blacklists, ["militia"], SAC_UDS_O_G_Soldiers, [], [], [], [3, 5], 0.65, SAC_UDS_O_G_garrisonVeh, [], [], [], 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, true, 1] call SAC_fnc_addGarrisons;
	
	};
	
	private _allGrps = _returnedArray select 0;
	private _occupiedBuildings = _returnedArray select 1;

	if (count _allGrps == 0) exitWith {"No se encontro edificio para el objetivo!" call SAC_fnc_MPhintC};

	private _targetPos = getPos (_occupiedBuildings select 0);

	private _decoysMaxDistance = if (isNil "SAC_COP_DKT_decoy_groups_max_distance") then {1000} else {SAC_COP_DKT_decoy_groups_max_distance};

	private _decoysCenterPos = if (isNil "SAC_COP_DKT_decoy_groups_center_pos") then {_targetPos} else {SAC_COP_DKT_decoy_groups_center_pos};

	if (SAC_COP_DKT_decoy_groups > 0) then {
	
		//Se buscan las garrison de los "decoy", con la condición "isolated" al azar.
		_isolated = (random 1 < 0.5);
		//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes","_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
		_returnedArray = [_decoysCenterPos, SAC_COP_DKT_decoy_groups, 0, _decoysMaxDistance, [5,5], 200, _isolated, [], ["militia"], SAC_UDS_O_G_Soldiers, [], [], [], [3, 5], 0.65, SAC_UDS_O_G_garrisonVeh, [], [], [], 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, true, 0] call SAC_fnc_addGarrisons;
		//_returnedArray = [getMarkerPos "SAC_COP_KILLTARGET", SAC_COP_DKT_decoy_groups, 0, (getMarkerSize "SAC_COP_KILLTARGET") select 0, 4, 200, _isolated, [], ["militia"], SAC_UDS_O_G_Soldiers, [], [], [], [3, 5], 0.65, SAC_UDS_O_G_garrisonVeh, [], [], [], 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, true, 0] call SAC_fnc_addGarrisons;

		if (count (_returnedArray select 0) > 0) then {
		
			_allGrps append (_returnedArray select 0);
			_occupiedBuildings append (_returnedArray select 1);
			
		};

		private _missingDecoys = SAC_COP_DKT_decoy_groups - count (_returnedArray select 0);

		//Si no se pudieron crear los "decoys" necesarios, y se buscó "isolated", se tratan de crear los que faltan, sin esa condición.
		if ((_missingDecoys > 0) && (_isolated)) then {

			//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes","_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
			_returnedArray = [_decoysCenterPos, _missingDecoys, 0, _decoysMaxDistance, [5,5], 200, false, [], ["militia"], SAC_UDS_O_G_Soldiers, [], [], [], [3, 5], 0.65, SAC_UDS_O_G_garrisonVeh, [], [], [], 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, true, 0] call SAC_fnc_addGarrisons;

		};

		if (count (_returnedArray select 0) > 0) then {
		
			_allGrps append (_returnedArray select 0);
			_occupiedBuildings append (_returnedArray select 1);
			
		};
		
	};
	
	private ["_p", "_grp", "_b"];
	for "_i" from 0 to (count _allGrps) - 1 do {
	
		_grp = _allGrps select _i;
		_b = _occupiedBuildings select _i;
		
		//intento que el mod VcomAI no afecte a estas unidades
		_grp setVariable ["Vcm_Disable", true];
		
//systemChat str _i;

		[_b] spawn SAC_fnc_musicSource;
		
		_p = getPos _b;
		
		if ((isNil "SAC_COP_DKT_informant") || {!SAC_COP_DKT_informant}) then {
		
			[_p, "ColorBlack", " Target", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;

			[_p, "ColorRed", "", "", [100, 100], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
			[_p, "ColorRed", "", "", [101, 101], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
			
		} else {
		
			SAC_hiddenTargetObjects pushback _b;
			_b setVariable ["SAC_markerText", " Target", true];
		
		};
		
		{
		
			if ((_x == leader _grp) && {_i == 0}) then {
			
//systemChat "aplicando nombre";
			
				_x setName SAC_COP_DKT_target_name;
				
				_x setVariable ["SAC_interact_name", SAC_COP_DKT_target_name, true];
			
			} else {
			
				_x setVariable ["SAC_interact_name", "anybody", true];
			
			};
			
			_x setVariable ["DO_NOT_DELETE", true];
			
		} forEach units _grp;
		
		if (_i == 0) then {
		
			[_grp, 15, []] spawn SAC_fnc_behaviour_get_away_from_player_side;
			
		};
		
		private _marker = createMarkerLocal [format ["SAC_COP_KILLTARGET_%1_%2", random 1, random 1], _p];
		_marker setMarkerShape "ELLIPSE";
		_marker setMarkerBrush "Border";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerSize [1000, 1000];
		_marker setMarkerAlpha 0;
		
		_killTargetBlacklists pushBack _marker;
		
		
	};
	
	if ((SAC_COP_DKT_technicals > 0) && {random 1 < SAC_COP_DKT_technicals_prob}) then {
	
		//["_centerPos", "_maxDistance", "_maxVehicles", "_vehClasses", "_crewClasses", "_autoDeleteGroup"];
		[_targetPos, SAC_COP_DKT_technicals_radius, SAC_COP_DKT_technicals, SAC_UDS_O_G_patrolVeh, SAC_UDS_O_G_Soldiers, true] call SAC_fnc_createVehicles;
	
	};
	
	if ((SAC_COP_DKT_patrols > 0) && {random 1 < SAC_COP_DKT_patrols_prob}) then {
	
		//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"]
		[_targetPos, SAC_COP_DKT_patrols_radius, SAC_COP_DKT_patrols, ["militia"], SAC_UDS_O_G_Soldiers, [], [], SAC_COP_blacklists, 350, SAC_COP_DKT_patrols_radius / 2, false, true, true, 50, false, false] call SAC_fnc_addInfantryPatrols;
		
	};
	
	if ((SAC_COP_DKT_static_groups > 0) && {random 1 < SAC_COP_DKT_static_groups_prob}) then {
	
		//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"]
		[_targetPos, SAC_COP_DKT_static_groups_radius, SAC_COP_DKT_static_groups, ["militia"], SAC_UDS_O_G_Soldiers, [], [], SAC_COP_blacklists, 350, SAC_COP_DKT_static_groups_radius / 2, false, true, true, 50, true, true] call SAC_fnc_addInfantryPatrols;

		
	};
	
	//22/11/2021 Genera un grupo de garrisons, que pueden o no salir de sus edificios (_hardcoreStop = 0.5).
	if ((SAC_COP_DKT_garrisons > 0) && {random 1 < SAC_COP_DKT_garrisons_prob}) then {
	
		//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes","_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
		[_targetPos, SAC_COP_DKT_garrisons, 0, SAC_COP_DKT_garrisons_radius, [7,3], 200, false, [], ["militia"], SAC_UDS_O_G_Soldiers, [], [], [], [3, 5], 0.65, SAC_UDS_O_G_garrisonVeh, [], [], [], 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings, true, 0.5] call SAC_fnc_addGarrisons;
		
	};
	
	
	if ((!isNil "SAC_COP_DKT_informant") && {SAC_COP_DKT_informant}) then {

		//si no existe el marcador SAC_COP_INFORMANTKILLTARGET, crear uno a partir del primer objetivo a eliminar
		if !("SAC_COP_INFORMANTKILLTARGET" in allMapMarkers) then {
			
			private _marker = createMarkerLocal ["SAC_COP_INFORMANTKILLTARGET", getPos (SAC_hiddenTargetObjects select 0)];
			_marker setMarkerShape "ELLIPSE";
			_marker setMarkerBrush "Border";
			_marker setMarkerColor "ColorRed";
			_marker setMarkerSize [4000, 4000];
			_marker setMarkerAlpha 0;
			

		};
		
		if !("SAC_COP_INFORMANTKILLTARGET" in allMapMarkers) exitWith {"ERROR: SAC_COP - Falla al crear SAC_COP_INFORMANTKILLTARGET." call SAC_fnc_MPhintC};
		
		_isolated = (random 1 < 0.5);
		//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
		_returnedArray = [getMarkerPos "SAC_COP_INFORMANTKILLTARGET", 1, 0, (getMarkerSize "SAC_COP_INFORMANTKILLTARGET") select 0, [4,4], 200, _isolated, _killTargetBlacklists, ["civilian"], [], [], [], SAC_UDS_C_Men, [1, 1], 0.65, [], [], [], SAC_UDS_C_garrisonVeh, 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, true, 1] call SAC_fnc_addGarrisons;

		//Si no se encuentra, y se buscó con "isolated", busca sin la condición.
		if ((count (_returnedArray select 0) == 0) && (_isolated)) then {

			//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
			_returnedArray = [getMarkerPos "SAC_COP_INFORMANTKILLTARGET", 1, 0, (getMarkerSize "SAC_COP_INFORMANTKILLTARGET") select 0, [4,4], 200, false, _killTargetBlacklists, ["civilian"], [], [], [], SAC_UDS_C_Men, [1, 1], 0.65, [], [], [], SAC_UDS_C_garrisonVeh, 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, true, 1] call SAC_fnc_addGarrisons;

		};

		_allGrps = _returnedArray select 0;
		_occupiedBuildings = _returnedArray select 1;

		if (count _allGrps == 0) exitWith {"No se encontro edificio para el informante!" call SAC_fnc_MPhintC};

		private _informant = leader (_allGrps select 0);

		private _b = _occupiedBuildings select 0;
		
		private _p = getPos _b;
		
		[_p, "ColorBlack", " Informante", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;

		[_p, "ColorBlue", "", "", [100, 100], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
		[_p, "ColorBlue", "", "", [101, 101], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
		
		_informant setVariable ["SAC_interact_interrogar", true, true];
		_informant setVariable ["SAC_interact_revealHiddenTargets", true, true];
		
		_informant setVariable ["DO_NOT_DELETE", true];
	
		//agregar algunas casas más ocupadas por civiles
		//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
		[_p, 3, 0, 50, [7,1], 200, false, _killTargetBlacklists, ["civilian"], [], [], [], SAC_UDS_C_Men, [2, 5], 0.65, [], [], [], SAC_UDS_C_garrisonVeh, 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings, true, 0.5] call SAC_fnc_addGarrisons;

		private _marker = createMarkerLocal [format ["SAC_COP_KILLTARGET_%1_%2", random 1, random 1], _p];
		_marker setMarkerShape "ELLIPSE";
		_marker setMarkerBrush "Border";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerSize [500, 500];
		_marker setMarkerAlpha 0;
		
		_killTargetBlacklists pushBack _marker;

	
	};
	
	
	if ((!isNil "SAC_COP_DKT_extractionguy") && {SAC_COP_DKT_extractionguy}) then {

		//si no existe el marcador SAC_COP_EXTRACTIONGUYKILLTARGET, crear uno a partir del primer objetivo a eliminar
		if !("SAC_COP_EXTRACTIONGUYKILLTARGET" in allMapMarkers) then {
			
			private _marker = createMarkerLocal ["SAC_COP_EXTRACTIONGUYKILLTARGET", getPos (SAC_hiddenTargetObjects select 0)];
			_marker setMarkerShape "ELLIPSE";
			_marker setMarkerBrush "Border";
			_marker setMarkerColor "ColorRed";
			_marker setMarkerSize [4000, 4000];
			_marker setMarkerAlpha 0;
			

		};
		
		if !("SAC_COP_EXTRACTIONGUYKILLTARGET" in allMapMarkers) exitWith {"ERROR: SAC_COP - Falla al crear SAC_COP_EXTRACTIONGUYKILLTARGET." call SAC_fnc_MPhintC};

		_isolated = (random 1 < 0.5);
		//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
		_returnedArray = [getMarkerPos "SAC_COP_EXTRACTIONGUYKILLTARGET", 1, 0, (getMarkerSize "SAC_COP_EXTRACTIONGUYKILLTARGET") select 0, [4,4], 200, _isolated, _killTargetBlacklists, ["civilian"], [], [], [], SAC_UDS_C_Men, [1, 1], 0.65, [], [], [], SAC_UDS_C_garrisonVeh, 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, true, 1] call SAC_fnc_addGarrisons;

		if ((count (_returnedArray select 0) == 0) && (_isolated)) then {
		
			//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
			_returnedArray = [getMarkerPos "SAC_COP_EXTRACTIONGUYKILLTARGET", 1, 0, (getMarkerSize "SAC_COP_EXTRACTIONGUYKILLTARGET") select 0, [4,4], 200, false, _killTargetBlacklists, ["civilian"], [], [], [], SAC_UDS_C_Men, [1, 1], 0.65, [], [], [], SAC_UDS_C_garrisonVeh, 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings + SAC_COP_buildings_blacklisted_for_interactive_npcs, true, 1] call SAC_fnc_addGarrisons;

		};

		_allGrps = _returnedArray select 0;
		_occupiedBuildings = _returnedArray select 1;

		if (count _allGrps == 0) exitWith {"No se encontro edificio para el extraction guy!" call SAC_fnc_MPhintC};

		private _extractionGuy = leader (_allGrps select 0);

		private _b = _occupiedBuildings select 0;
		
		private _p = getPos _b;
		
		[_p, "ColorBlack", " Extraction Guy", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;

		[_p, "ColorBlue", "", "", [100, 100], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
		[_p, "ColorBlue", "", "", [101, 101], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
		
		_extractionGuy setVariable ["SAC_interact_interrogar", true, true];
		_extractionGuy setVariable ["SAC_interact_revealHiddenTargets_2", true, true];
		
		_extractionGuy setVariable ["DO_NOT_DELETE", true];

		//agregar algunas más casas ocupadas por civiles
		//["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses", "_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"]
		[_p, 3, 0, 50, [7,1], 200, false, _killTargetBlacklists, ["civilian"], [], [], [], SAC_UDS_C_Men, [2, 5], 0.65, [], [], [], SAC_UDS_C_garrisonVeh, 0, SAC_militaryFortifications + SAC_militaryBuildings + SAC_fucked_up_buildings, true, 0.5] call SAC_fnc_addGarrisons;

		
		//Si se crean en el editor las opciones de extracción ya deberían estar guardadas en SAC_hiddenTargetObjects_2
		if (count SAC_hiddenTargetObjects_2 == 0) then {
		
			//Crear botes en la costa más cercana.
		
			//Encontrar costa más cercana (aunque parece haber una aleatoriedad, o sea que en realidad sería cerca, pero no la más cercana).
			private _shorePosition = [];
			private _tp1 = [];
			private _tp2 = [];
			private _found = false;
			private _boat = objNull;
			
			for "_j" from 0 to 1 step 1 do {
				//systemChat "loop";
				for "_i" from 0 to 100 step 1 do {
				
					_shorePosition = [];
					
					for "_d" from 1000 to 10000 step 1000 do {
					
						//devuelve array de 2 elementos si encontró posición, o de 3 elementos si no la encontró
						_shorePosition = [_p, 0, _d, 10, 0, 0.5, 1, SAC_boats_blacklists + _killTargetBlacklists] call BIS_fnc_findSafePos;

						if (count _shorePosition == 2) exitWith {};
						
					};
					
					if (count _shorePosition == 3) exitWith {"No se encontro costa para los botes!" call SAC_fnc_MPhintC};
				
					//encontrar posiciones para los botes
					
					//[_shorePosition, "ColorBlue", ""] call SAC_fnc_createMarker;
					
					_found = false;
					
					for "_h" from 0 to 360 step 15 do {
					
						_tp1 = _shorePosition getPos [50, _h];
						//[_tp1, "ColorGreen", ""] call SAC_fnc_createMarker;
						
						if ([_tp1, 15] call SAC_fnc_isCellInWater) then {
						
							_tp2= _shorePosition getPos [75, _h];
							//[_tp2, "ColorYellow", ""] call SAC_fnc_createMarker;
							
							if ([_tp2, 15] call SAC_fnc_isCellInWater) then {
							
								_found = true;
							
							};
						
						};
						
						if (_found) exitWith {};
					
					};
					
					if (_found) exitWith {};
				
				};
				
				if (!_found) exitWith {};
				
				//[_tp1, "ColorBlue", " 1"] call SAC_fnc_createMarker;
				//[_tp2, "ColorBlue", " 2"] call SAC_fnc_createMarker;
				
				_boat = "C_Boat_Transport_02_F" createVehicle _tp1;
				_boat setVariable ["SAC_markerText", " Botes", true];
				SAC_hiddenTargetObjects_2 pushback _boat;
				
				_boat = "C_Boat_Transport_02_F" createVehicle _tp2;
				_boat setVariable ["SAC_markerText", " Botes", true];
				SAC_hiddenTargetObjects_2 pushback _boat;
				
				
				if ((SAC_COP_DKT_technicals_inext > 0) && {random 1 < SAC_COP_DKT_technicals_inext_prob}) then {
				
					//["_centerPos", "_maxDistance", "_maxVehicles", "_vehClasses", "_crewClasses", "_autoDeleteGroup"];
					[_tp1, SAC_COP_DKT_technicals_inext_radius, SAC_COP_DKT_technicals_inext, SAC_UDS_O_G_patrolVeh, SAC_UDS_O_G_Soldiers, true] call SAC_fnc_createVehicles;
					
				};
				
				if ((SAC_COP_DKT_patrols_inext > 0) && {random 1 < SAC_COP_DKT_patrols_inext_prob}) then {
				
					//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"]
					[_tp1, SAC_COP_DKT_patrols_inext_radius, SAC_COP_DKT_patrols_inext, ["militia"], SAC_UDS_O_G_Soldiers, [], [], SAC_COP_blacklists, 350, SAC_COP_DKT_patrols_inext_radius / 2, false, true, true, 50, false, false] call SAC_fnc_addInfantryPatrols;
					
				};
				
				if ((SAC_COP_DKT_static_groups_inext > 0) && {random 1 < SAC_COP_DKT_static_groups_inext_prob}) then {
				
					//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"]
					[_tp1, SAC_COP_DKT_static_groups_inext_radius, SAC_COP_DKT_static_groups_inext, ["militia"], SAC_UDS_O_G_Soldiers, [], [], SAC_COP_blacklists, 350, SAC_COP_DKT_static_groups_inext_radius / 2, false, true, true, 50, true, true] call SAC_fnc_addInfantryPatrols;

					
				};

			};
			
			if (!_found) exitWith {"No se encontro lugar para los botes!" call SAC_fnc_MPhintC};
			
		} else {
		
			private _tp1 = [];
			
			for "_i" from 0 to (count SAC_hiddenTargetObjects_2) - 1 step 1 do {
			
				if (!isNull (SAC_hiddenTargetObjects_2 select _i)) then {
				
					_tp1 = getPos (SAC_hiddenTargetObjects_2 select _i);
				
					if ((SAC_COP_DKT_technicals_inext > 0) && {random 1 < SAC_COP_DKT_technicals_inext_prob}) then {
					
						//["_centerPos", "_maxDistance", "_maxVehicles", "_vehClasses", "_crewClasses", "_autoDeleteGroup"];
						[_tp1, SAC_COP_DKT_technicals_inext_radius, SAC_COP_DKT_technicals_inext, SAC_UDS_O_G_patrolVeh, SAC_UDS_O_G_Soldiers, true] call SAC_fnc_createVehicles;
						
					};
					
					if ((SAC_COP_DKT_patrols_inext > 0) && {random 1 < SAC_COP_DKT_patrols_inext_prob}) then {
					
						//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"]
						[_tp1, SAC_COP_DKT_patrols_inext_radius, SAC_COP_DKT_patrols_inext, ["militia"], SAC_UDS_O_G_Soldiers, [], [], SAC_COP_blacklists, 350, SAC_COP_DKT_patrols_inext_radius / 2, false, true, true, 50, false, false] call SAC_fnc_addInfantryPatrols;
						
					};
					
					if ((SAC_COP_DKT_static_groups_inext > 0) && {random 1 < SAC_COP_DKT_static_groups_inext_prob}) then {
					
						//["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"]
						[_tp1, SAC_COP_DKT_static_groups_inext_radius, SAC_COP_DKT_static_groups_inext, ["militia"], SAC_UDS_O_G_Soldiers, [], [], SAC_COP_blacklists, 350, SAC_COP_DKT_static_groups_inext_radius / 2, false, true, true, 50, true, true] call SAC_fnc_addInfantryPatrols;
						
					};
					
				};
				
			};
		
		};
		
	
	};

	if ((!isNil "SAC_COP_DKT_createDiaryEntry") && {SAC_COP_DKT_createDiaryEntry}) then {
	
		{player createDiarySubject  [SAC_COP_DKT_diaryEntrySubject, SAC_COP_DKT_diaryEntryDisplayName]} remoteExec ["call", [0, -2] select isDedicated, true]; 
		{player createDiaryRecord  [SAC_COP_DKT_diaryEntrySubject, [SAC_COP_DKT_diaryEntryTitle, SAC_COP_DKT_diaryEntryDescription]]} remoteExec ["call", [0, -2] select isDedicated, true];
	
		(parseText SAC_COP_DKT_diaryEntryDescription) call SAC_fnc_MPhint;
	
	} else {
	
		(parseText "<t color='#FFFFFF' size='1.2'><br/>Locations marked.<br/></t>") call SAC_fnc_MPhint;
		
	};

};




/******************************************************************************************************************************************
Borrar objetos que deban ser eliminados.

Ej.
this setVariable ["SAC_COP_specialEffects", "COP_ONLYONE"]; //puede ponerse en una 'Logic', y afecta a los objetos sincronizados con ella
this setVariable ["SAC_COP_specialEffects", "COP_ATLEASTONE"]; //puede ponerse en una 'Logic', y afecta a los objetos sincronizados con ella
this setVariable ["SAC_COP_specialEffects", ["COP_ATLEASTONE", "COP_GENERATE_CSAR_SIMPLE_ACTION"]];

*******************************************************************************************************************************************/

private ["_marker"];

SAC_onlyOneList_1 = [];
SAC_atLeastOneList_1 = [];
SAC_maybeOneList_1 = [];
SAC_onlyOneList_2 = [];
SAC_atLeastOneList_2 = [];
SAC_maybeOneList_2 = [];
SAC_onlyOneList_3 = [];
SAC_atLeastOneList_3 = [];
SAC_maybeOneList_3 = [];

private _object = objNull;
private _specialEffects = [];
private _specialEffectsArray = [];

{

	_object = _x;
	
	_specialEffectsArray = [];
	
	_specialEffects = _object getVariable ["SAC_COP_specialEffects", []];
	
	if (_specialEffects isEqualType "") then {
	
		_specialEffectsArray pushBack _specialEffects;
	
	} else {
	
		_specialEffectsArray = _specialEffects;
	
	};


	{
	
		switch (_x) do {
		
			case "COP_ONLYONE";
			case "COP_ONLYONE_1": {
			
				SAC_onlyOneList_1 pushback _object;
			
			};
			case "COP_ATLEASTONE";
			case "COP_ATLEASTONE_1": {
			
				SAC_atLeastOneList_1 pushback _object;
			
			};
			case "COP_MAYBEONE";
			case "COP_MAYBEONE_1": {
			
				SAC_maybeOneList_1 pushback _object;
			
			};
			case "COP_ONLYONE_2": {
			
				SAC_onlyOneList_2 pushback _object;
			
			};
			case "COP_ATLEASTONE_2": {
			
				SAC_atLeastOneList_2 pushback _object;
			
			};
			case "COP_MAYBEONE_2": {
			
				SAC_maybeOneList_2 pushback _object;
			
			};
			case "COP_ONLYONE_3": {
			
				SAC_onlyOneList_3 pushback _object;
			
			};
			case "COP_ATLEASTONE_3": {
			
				SAC_atLeastOneList_3 pushback _object;
			
			};
			case "COP_MAYBEONE_3": {
			
				SAC_maybeOneList_3 pushback _object;
			
			};
		};
		
	} forEach _specialEffectsArray;

} forEach allUnits + vehicles + (entities "Logic");

//soporte para el nuevos sistema que no requiere setear la veariable SAC_COP_specialEffects
if (!isNil "SAC_COP_ONLYONE") then {{SAC_onlyOneList_1 pushback _x} forEach synchronizedObjects SAC_COP_ONLYONE};

if (!isNil "SAC_COP_ONLYONE_1") then {{SAC_onlyOneList_1 pushback _x} forEach synchronizedObjects SAC_COP_ONLYONE_1};

if (!isNil "SAC_COP_ONLYONE_2") then {{SAC_onlyOneList_2 pushback _x} forEach synchronizedObjects SAC_COP_ONLYONE_2};

if (!isNil "SAC_COP_ONLYONE_3") then {{SAC_onlyOneList_3 pushback _x} forEach synchronizedObjects SAC_COP_ONLYONE_3};


if (!isNil "SAC_COP_ATLEASTONE") then {{SAC_atLeastOneList_1 pushback _x} forEach synchronizedObjects SAC_COP_ATLEASTONE};

if (!isNil "SAC_COP_ATLEASTONE_1") then {{SAC_atLeastOneList_1 pushback _x} forEach synchronizedObjects SAC_COP_ATLEASTONE_1};

if (!isNil "SAC_COP_ATLEASTONE_2") then {{SAC_atLeastOneList_2 pushback _x} forEach synchronizedObjects SAC_COP_ATLEASTONE_2};

if (!isNil "SAC_COP_ATLEASTONE_3") then {{SAC_atLeastOneList_3 pushback _x} forEach synchronizedObjects SAC_COP_ATLEASTONE_3};


if (!isNil "SAC_COP_MAYBEONE") then {{SAC_maybeOneList_1 pushback _x} forEach synchronizedObjects SAC_COP_MAYBEONE};

if (!isNil "SAC_COP_MAYBEONE_1") then {{SAC_maybeOneList_1 pushback _x} forEach synchronizedObjects SAC_COP_MAYBEONE_1};

if (!isNil "SAC_COP_MAYBEONE_2") then {{SAC_maybeOneList_2 pushback _x} forEach synchronizedObjects SAC_COP_MAYBEONE_2};

if (!isNil "SAC_COP_MAYBEONE_3") then {{SAC_maybeOneList_3 pushback _x} forEach synchronizedObjects SAC_COP_MAYBEONE_3};


if (count SAC_onlyOneList_1 > 1) then {

	SAC_onlyOneList_1 = SAC_onlyOneList_1 call SAC_fnc_shuffleArray;

	for "_i" from 1 to (count SAC_onlyOneList_1) do {
	
		if ((SAC_onlyOneList_1 select _i) isKindOf "Logic") then {
		
			{deleteVehicle _x} forEach synchronizedObjects (SAC_onlyOneList_1 select _i);
			
		};
		
		deleteVehicle (SAC_onlyOneList_1 select _i);
		
	};

};

if (count SAC_atLeastOneList_1 > 1) then {

	SAC_atLeastOneList_1 = SAC_atLeastOneList_1 call SAC_fnc_shuffleArray;

	for "_i" from 1 to (count SAC_atLeastOneList_1) do {
	
		if (random 1 < 0.75) then {
		
		
			if ((SAC_atLeastOneList_1 select _i) isKindOf "Logic") then {
			
				{deleteVehicle _x} forEach synchronizedObjects (SAC_atLeastOneList_1 select _i);
				
			};
		
			deleteVehicle (SAC_atLeastOneList_1 select _i)
			
		};
		
	};

};

if (count SAC_maybeOneList_1 > 1) then {

	SAC_maybeOneList_1 = SAC_maybeOneList_1 call SAC_fnc_shuffleArray;

	for "_i" from 0 to (count SAC_maybeOneList_1) do {
	
		if ((_i != 0) || {random 1 > 0.2}) then {
	
			if ((SAC_maybeOneList_1 select _i) isKindOf "Logic") then {
			
				{deleteVehicle _x} forEach synchronizedObjects (SAC_maybeOneList_1 select _i);
				
			};
			
			deleteVehicle (SAC_maybeOneList_1 select _i);
			
		};
		
	};
	
};

if (count SAC_onlyOneList_2 > 1) then {

	SAC_onlyOneList_2 = SAC_onlyOneList_2 call SAC_fnc_shuffleArray;

	for "_i" from 1 to (count SAC_onlyOneList_2) do {
	
		if ((SAC_onlyOneList_2 select _i) isKindOf "Logic") then {
		
			{deleteVehicle _x} forEach synchronizedObjects (SAC_onlyOneList_2 select _i);
			
		};
		
		deleteVehicle (SAC_onlyOneList_2 select _i);
		
	};

};

if (count SAC_atLeastOneList_2 > 1) then {

	SAC_atLeastOneList_2 = SAC_atLeastOneList_2 call SAC_fnc_shuffleArray;

	for "_i" from 1 to (count SAC_atLeastOneList_2) do {
	
		if (random 1 < 0.75) then {
		
		
			if ((SAC_atLeastOneList_2 select _i) isKindOf "Logic") then {
			
				{deleteVehicle _x} forEach synchronizedObjects (SAC_atLeastOneList_2 select _i);
				
			};
		
			deleteVehicle (SAC_atLeastOneList_2 select _i)
			
		};
		
	};

};

if (count SAC_maybeOneList_2 > 1) then {

	SAC_maybeOneList_2 = SAC_maybeOneList_2 call SAC_fnc_shuffleArray;

	for "_i" from 0 to (count SAC_maybeOneList_2) do {
	
		if ((_i != 0) || {random 1 > 0.15}) then {
	
			if ((SAC_maybeOneList_2 select _i) isKindOf "Logic") then {
			
				{deleteVehicle _x} forEach synchronizedObjects (SAC_maybeOneList_2 select _i);
				
			};
			
			deleteVehicle (SAC_maybeOneList_2 select _i);
			
		};
		
	};
	
};

if (count SAC_onlyOneList_3 > 1) then {

	SAC_onlyOneList_3 = SAC_onlyOneList_3 call SAC_fnc_shuffleArray;

	for "_i" from 1 to (count SAC_onlyOneList_3) do {
	
		if ((SAC_onlyOneList_3 select _i) isKindOf "Logic") then {
		
			{deleteVehicle _x} forEach synchronizedObjects (SAC_onlyOneList_3 select _i);
			
		};
		
		deleteVehicle (SAC_onlyOneList_3 select _i);
		
	};

};

if (count SAC_atLeastOneList_3 > 1) then {

	SAC_atLeastOneList_3 = SAC_atLeastOneList_3 call SAC_fnc_shuffleArray;

	for "_i" from 1 to (count SAC_atLeastOneList_3) do {
	
		if (random 1 < 0.75) then {
		
		
			if ((SAC_atLeastOneList_3 select _i) isKindOf "Logic") then {
			
				{deleteVehicle _x} forEach synchronizedObjects (SAC_atLeastOneList_3 select _i);
				
			};
		
			deleteVehicle (SAC_atLeastOneList_3 select _i)
			
		};
		
	};

};

if (count SAC_maybeOneList_3 > 1) then {

	SAC_maybeOneList_3 = SAC_maybeOneList_3 call SAC_fnc_shuffleArray;

	for "_i" from 0 to (count SAC_maybeOneList_3) do {
	
		if ((_i != 0) || {random 1 > 0.15}) then {
	
			if ((SAC_maybeOneList_3 select _i) isKindOf "Logic") then {
			
				{deleteVehicle _x} forEach synchronizedObjects (SAC_maybeOneList_3 select _i);
				
			};
			
			deleteVehicle (SAC_maybeOneList_3 select _i);
			
		};
		
	};
	
};

/******************************************************************************************************************************************
Aplicar efectos a los objetos puestos de antemano en la misión.

Ej.
this setVariable ["SAC_COP_specialEffects", "SAC_GETAWAY"];
this setVariable ["SAC_COP_specialEffects", "COP_DOWNLOAD"];
this setVariable ["SAC_COP_specialEffects", "COP_HACK"];
this setVariable ["SAC_COP_specialEffects", "COP_ACTIVATE"];
this setVariable ["SAC_COP_specialEffects", ["COP_HIDDENTARGETOBJECT", "COP_MAKEHOSTAGE"]];
this setVariable ["SAC_COP_specialEffects", "TAC_TARGET"];
this setVariable ["SAC_COP_specialEffects", "COP_MAKEHOSTAGE"]; //si hay que afectar a todo un grupo, poner solo sobre una sola unidad

*******************************************************************************************************************************************/

SAC_hiddenTargetObjects = [];
SAC_hiddenTargetObjects_2 = [];
SAC_hiddenTargetObjects_3 = [];

SAC_passwords = [];
SAC_passwords_2 = [];
SAC_passwords_3 = [];

SAC_COP_tracker_blindzones = [];
{

	if (toUpper(markerText _x) == "COP_TRACKER_BLINDZONE") then {SAC_COP_tracker_blindzones pushBackUnique _x};

} forEach allMapMarkers;

/*

Este código es para dar soporte a misiones creadas antes del sistema de objetos sincronizados a Logics.
No agregar ninguna nueva función a esta sección (hacerlo sólo al sistema de las Logics).

*/
{

	_object = _x;
	
	_specialEffectsArray = [];
	
	_specialEffects = _object getVariable ["SAC_COP_specialEffects", []];
	
	if (_specialEffects isEqualType "") then {
	
		_specialEffectsArray pushBack _specialEffects;
	
	} else {
	
		_specialEffectsArray = _specialEffects;
	
	};


	{
	
		switch (_x) do {
		
			case "TAC_TARGET_MILITIA";
			case "TAC_TARGET_REGULAR";
			case "TAC_TARGET": {
			
				_marker = createMarkerLocal [format["SAC_COP_%1", random 1], getPos _object];
				_marker setMarkerShapeLocal "ELLIPSE";
				_marker setMarkerSizeLocal [10,10];
				_marker setMarkerTextLocal (_object getVariable _x);
				_marker setMarkerAlphaLocal 0;

				[_object, _marker] spawn {
				
					params ["_u", "_marker"];

					while {!isNull _u} do {_marker setMarkerPosLocal getPos _u; sleep 1};
				
				};
			
			
			};
			case "SAC_GETAWAY": {
			
				[group _object, 10, []] spawn SAC_fnc_behaviour_get_away_from_player_side;
			
			};
			case "COP_HIDDENTARGETOBJECT": {
			
				SAC_hiddenTargetObjects pushback _object;
			
			};
			case "COP_HIDDENTARGETOBJECT_2": {
			
				SAC_hiddenTargetObjects_2 pushback _object;
			
			};
			case "COP_HIDDENTARGETOBJECT_3": {
			
				SAC_hiddenTargetObjects_3 pushback _object;
			
			};
			case "COP_DOWNLOAD": { //usar genera texto en pantalla "INFORMACIÓN DESCARGADA CON ÉXITO"
			
				//[_object, "<t color='#FF0000'>DOWNLOAD DATA</t>", "DATA DOWNLOADED", 2, [], 0, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa"] call SAC_fnc_addPredefinedActionNew;
				
				_object setVariable ["SAC_interact_use", true, true];
				_object setVariable ["SAC_interact_download", true, true];
			
			};
			case "COP_USE_REVEAL": { //usar revela SAC_hiddenTargetObjects
			
				//[_object, "<t color='#FF0000'>DOWNLOAD DATA</t>", "DATA DOWNLOADED", 8, [], 0, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa"] call SAC_fnc_addPredefinedActionNew;
				
				_object setVariable ["SAC_interact_use", true, true];
				_object setVariable ["SAC_interact_revealHiddenTargets", true, true];
			
			};
			case "COP_USE_REVEAL_2": { //usar revela SAC_hiddenTargetObjects_2
			
				//[_object, "<t color='#FF0000'>DOWNLOAD DATA</t>", "DATA DOWNLOADED", 8, [], 0, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa"] call SAC_fnc_addPredefinedActionNew;
				
				_object setVariable ["SAC_interact_use", true, true];
				_object setVariable ["SAC_interact_revealHiddenTargets_2", true, true];
			
			};
			case "COP_USE_REVEAL_3": { //usar revela SAC_hiddenTargetObjects_3
			
				//[_object, "<t color='#FF0000'>DOWNLOAD DATA</t>", "DATA DOWNLOADED", 8, [], 0, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa"] call SAC_fnc_addPredefinedActionNew;
				
				_object setVariable ["SAC_interact_use", true, true];
				_object setVariable ["SAC_interact_revealHiddenTargets_3", true, true];
			
			};
			case "COP_USE_CSAR": { //usar genera csar
			
				//[_object, "<t color='#FF0000'>DOWNLOAD DATA</t>", "DATA DOWNLOADED", 8, [], 0, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa"] call SAC_fnc_addPredefinedActionNew;
				
				_object setVariable ["SAC_interact_use", true, true];
				_object setVariable ["SAC_interact_csar", true, true];
			
			};
			case "COP_USE_KILLTARGET": { //usar genera killtarget
			
				_object setVariable ["SAC_interact_use", true, true];
				_object setVariable ["SAC_interact_killtarget", true, true];
			
			};
			case "COP_HACK": { //usar genera texto en pantalla "HACKEO TERMINADO CON ÉXITO"
			
				//[_object, "<t color='#FF0000'>HACK SYSTEM</t>", "HACKING COMPLETE", 2, [], 0, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa"] call SAC_fnc_addPredefinedActionNew;
				
				_object setVariable ["SAC_interact_use", true, true];
				_object setVariable ["SAC_interact_hack", true, true];
				
			};
			case "COP_SEARCH": { //usar genera texto en pantalla "DOCUMENTOS ENCONTRADOS"
			
				//[_object, "<t color='#FFFFFF'>SEARCH</t>", "DOCUMENTS RETRIEVED", 2, [], 0, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa"] call SAC_fnc_addPredefinedActionNew;
				
				_object setVariable ["SAC_interact_use", true, true];
				_object setVariable ["SAC_interact_searchDocuments", true, true];
			
			};
			case "COP_TALK_GENERATE_CSAR": { //interrogar a una persona genera CSAR
				
				_object setVariable ["SAC_interact_interrogar", true, true];
				_object setVariable ["SAC_interact_csar", true, true];
			
			};
			case "COP_TALK_GENERATE_KILLTARGET": { //interrogar a una persona genera killtarget
				
				_object setVariable ["SAC_interact_interrogar", true, true];
				_object setVariable ["SAC_interact_killtarget", true, true];
			
			};
			case "COP_TALK_REVEAL": { //interrogar a una persona revela SAC_hiddenTargetObjects
			
				_object setVariable ["SAC_interact_interrogar", true, true];
				_object setVariable ["SAC_interact_revealHiddenTargets", true, true];
			
			};
			case "COP_TALK_REVEAL_2": { //interrogar a una persona revela SAC_hiddenTargetObjects_2
			
				_object setVariable ["SAC_interact_interrogar", true, true];
				_object setVariable ["SAC_interact_revealHiddenTargets_2", true, true];
			
			};
			case "COP_TALK_REVEAL_3": { //interrogar a una persona revela SAC_hiddenTargetObjects_3
			
				_object setVariable ["SAC_interact_interrogar", true, true];
				_object setVariable ["SAC_interact_revealHiddenTargets_3", true, true];
			
			};
			case "COP_ACTIVATE": {
			
				[_object, "<t color='#FF0000'>ACTIVATE SYSTEM</t>", "SYSTEM ACTIVATED", 6, [], 0, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa"] call SAC_fnc_addPredefinedActionNew;
			
			};
			case "COP_MAKEHOSTAGE": {
			
				[group _object, ["G_Blindfold_01_black_F", "G_Blindfold_01_white_F"]] call SAC_fnc_convertToHostage;
			
			};			
			case "COP_MAKEHOSTAGE_BEARD": {
			
				[group _object, ["flb_beard_drkbrn", "flb_beard_oldbrn"]] call SAC_fnc_convertToHostage;
			
			};
			case "COP_MAKEHOSTAGE_HEADBAG": {
			
				[group _object, ["mgsr_headbag"]] call SAC_fnc_convertToHostage;
			
			};
			case "COP_MUSICSOURCE": {
			
				[_object] spawn SAC_fnc_musicSource;
			
			};
			case "COP_RADIOSOURCE": {
			
				[_object] spawn SAC_fnc_radioSource;
			
			};
			default {
			
				if !(_x in ["COP_ONLYONE", "COP_ATLEASTONE", "COP_MAYBEONE", "COP_ONLYONE_1", "COP_ATLEASTONE_1", "COP_MAYBEONE_1", "COP_ONLYONE_2", "COP_ATLEASTONE_2", "COP_MAYBEONE_2", "COP_ONLYONE_3", "COP_ATLEASTONE_3", "COP_MAYBEONE_3"]) then {
			
					[format ["ERROR: Hay specialEffects no reconocidos! [%1]", _x]] call SAC_fnc_debugNotify;
					
				};
			
			};
		
		};
		
	} forEach _specialEffectsArray;

} forEach allUnits + vehicles + (entities "Logic");







//soporte para el nuevos sistema que no requiere setear la veariable SAC_COP_specialEffects
if (!isNil "COP_TAC_TARGET_MILITIA") then {

	{
	
		_marker = createMarkerLocal [format["SAC_COP_%1_%2", random 1, random 1], getPos _x];
		_marker setMarkerShapeLocal "ELLIPSE";
		_marker setMarkerSizeLocal [10,10];
		_marker setMarkerTextLocal "TAC_TARGET_MILITIA";
		_marker setMarkerAlphaLocal 0;

		[_object, _marker] spawn {
		
			params ["_u", "_marker"];

			while {!isNull _u} do {_marker setMarkerPosLocal getPos _u; sleep 1};
		
		};
	
	} forEach synchronizedObjects COP_TAC_TARGET_MILITIA;

};

if (!isNil "COP_TAC_TARGET_REGULAR") then {

	{
	
		_marker = createMarkerLocal [format["SAC_COP_%1_%2", random 1, random 1], getPos _x];
		_marker setMarkerShapeLocal "ELLIPSE";
		_marker setMarkerSizeLocal [10,10];
		_marker setMarkerTextLocal "TAC_TARGET_REGULAR";
		_marker setMarkerAlphaLocal 0;

		[_object, _marker] spawn {
		
			params ["_u", "_marker"];

			while {!isNull _u} do {_marker setMarkerPosLocal getPos _u; sleep 1};
		
		};
	
	} forEach synchronizedObjects COP_TAC_TARGET_REGULAR;

};

if (!isNil "COP_TAC_TARGET") then {

	{
	
		_marker = createMarkerLocal [format["SAC_COP_%1_%2", random 1, random 1], getPos _x];
		_marker setMarkerShapeLocal "ELLIPSE";
		_marker setMarkerSizeLocal [10,10];
		_marker setMarkerTextLocal "TAC_TARGET";
		_marker setMarkerAlphaLocal 0;

		[_object, _marker] spawn {
		
			params ["_u", "_marker"];

			while {!isNull _u} do {_marker setMarkerPosLocal getPos _u; sleep 1};
		
		};
	
	} forEach synchronizedObjects COP_TAC_TARGET;


};

if (!isNil "COP_GETAWAY") then {{[group _x, 10, []] spawn SAC_fnc_behaviour_get_away_from_player_side} forEach synchronizedObjects COP_GETAWAY};

if (!isNil "COP_ADDTRACKER") then {{[_x, SAC_COP_tracker_blindzones] spawn SAC_fnc_addTracker} forEach synchronizedObjects COP_ADDTRACKER};

if (!isNil "COP_HIDDENTARGETOBJECT") then {{SAC_hiddenTargetObjects pushback _x} forEach synchronizedObjects COP_HIDDENTARGETOBJECT};

if (!isNil "COP_HIDDENTARGETOBJECT_2") then {{SAC_hiddenTargetObjects_2 pushback _x} forEach synchronizedObjects COP_HIDDENTARGETOBJECT_2};

if (!isNil "COP_HIDDENTARGETOBJECT_3") then {{SAC_hiddenTargetObjects_3 pushback _x} forEach synchronizedObjects COP_HIDDENTARGETOBJECT_3};

if (!isNil "COP_DOWNLOAD") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_download", true, true];
	
	} forEach synchronizedObjects COP_DOWNLOAD;

};

if (!isNil "COP_SHUTDOWN_SAT_COMMS") then {

	{

		_x setVariable ["SAC_interact_shutdown_sat_comms", true, true];
	
	} forEach synchronizedObjects COP_SHUTDOWN_SAT_COMMS;

};

if (!isNil "COP_DISARM") then {

	{

		_x setVariable ["SAC_interact_disarm", true, true];
	
	} forEach synchronizedObjects COP_DISARM;

};

if (!isNil "COP_SHUTDOWN_RADAR") then {

	{

		_x setVariable ["SAC_interact_shutdown_radar", true, true];
	
	} forEach synchronizedObjects COP_SHUTDOWN_RADAR;

};

if (!isNil "COP_USE_REVEAL") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_revealHiddenTargets", true, true];
	
	} forEach synchronizedObjects COP_USE_REVEAL;

};

if (!isNil "COP_USE_REVEAL_2") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_revealHiddenTargets_2", true, true];
	
	} forEach synchronizedObjects COP_USE_REVEAL_2;

};

if (!isNil "COP_USE_REVEAL_3") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_revealHiddenTargets_3", true, true];
	
	} forEach synchronizedObjects COP_USE_REVEAL_3;

};

if (!isNil "COP_USE_CSAR") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_csar", true, true];
	
	} forEach synchronizedObjects COP_USE_CSAR;

};

if (!isNil "COP_USE_KILLTARGET") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_killtarget", true, true];
	
	} forEach synchronizedObjects COP_USE_KILLTARGET;

};

if (!isNil "COP_HACK") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_hack", true, true];
	
	} forEach synchronizedObjects COP_HACK;

};

if (!isNil "COP_SEARCH") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_searchDocuments", true, true];
	
	} forEach synchronizedObjects COP_SEARCH;

};

if (!isNil "COP_TALK_GENERATE_CSAR") then {

	{
	
		_x setVariable ["SAC_interact_interrogar", true, true];
		_x setVariable ["SAC_interact_csar", true, true];
	
	} forEach synchronizedObjects COP_TALK_GENERATE_CSAR;

};

if (!isNil "COP_TALK_GENERATE_KILLTARGET") then {

	{
	
		_x setVariable ["SAC_interact_interrogar", true, true];
		_x setVariable ["SAC_interact_killtarget", true, true];
	
	} forEach synchronizedObjects COP_TALK_GENERATE_KILLTARGET;

};

if (!isNil "COP_TALK_REVEAL") then {

	{
	
		_x setVariable ["SAC_interact_interrogar", true, true];
		_x setVariable ["SAC_interact_revealHiddenTargets", true, true];
	
	} forEach synchronizedObjects COP_TALK_REVEAL;

};

if (!isNil "COP_TALK_REVEAL_2") then {

	{
	
		_x setVariable ["SAC_interact_interrogar", true, true];
		_x setVariable ["SAC_interact_revealHiddenTargets_2", true, true];
	
	} forEach synchronizedObjects COP_TALK_REVEAL_2;

};

if (!isNil "COP_TALK_REVEAL_3") then {

	{
	
		_x setVariable ["SAC_interact_interrogar", true, true];
		_x setVariable ["SAC_interact_revealHiddenTargets_3", true, true];
	
	} forEach synchronizedObjects COP_TALK_REVEAL_3;

};

if (!isNil "COP_ACTIVATE") then {

	{
	
		[_x, "<t color='#FF0000'>ACTIVATE SYSTEM</t>", "SYSTEM ACTIVATED", 6, [], 0, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa"] call SAC_fnc_addPredefinedActionNew;
	
	} forEach synchronizedObjects COP_ACTIVATE;

};

if (!isNil "COP_MAKEHOSTAGE") then {

	{
	
		[group _x, ["G_Blindfold_01_black_F", "G_Blindfold_01_white_F"]] call SAC_fnc_convertToHostage;
	
	} forEach synchronizedObjects COP_MAKEHOSTAGE;

};

if (!isNil "COP_MAKEHOSTAGE_BEARD") then {

	{
	
		[group _x, ["flb_beard_drkbrn", "flb_beard_oldbrn"]] call SAC_fnc_convertToHostage;
	
	} forEach synchronizedObjects COP_MAKEHOSTAGE_BEARD;

};

if (!isNil "COP_MAKEHOSTAGE_HEADBAG") then {

	{
	
		[group _x, ["mgsr_headbag"]] call SAC_fnc_convertToHostage;
	
	} forEach synchronizedObjects COP_MAKEHOSTAGE_HEADBAG;

};

if (!isNil "COP_MAKEUNCONCIOUS") then {

	{
	
		[_x] spawn SAC_fnc_makeUnconcious;
	
	} forEach synchronizedObjects COP_MAKEUNCONCIOUS;

};

if (!isNil "COP_MAKESOMEUNCONCIOUS") then {

	{
	
		if (selectRandom [true, false]) then {[_x] spawn SAC_fnc_makeUnconcious};
	
	} forEach synchronizedObjects COP_MAKESOMEUNCONCIOUS;

};

if (!isNil "COP_MEDICAL") then {

	{
	
		[_x] spawn SAC_fnc_addHandleDamageWithUnconscious;
	
	} forEach synchronizedObjects COP_MEDICAL;

};

if (!isNil "COP_MUSICSOURCE") then {

	{
	
		[_x] spawn SAC_fnc_musicSource;
	
	} forEach synchronizedObjects COP_MUSICSOURCE;

};

if (!isNil "COP_RADIOSOURCE") then {

	{
	
		[_x] spawn SAC_fnc_radioSource;
	
	} forEach synchronizedObjects COP_RADIOSOURCE;

};

if (!isNil "COP_SET_SAME_PASSWORD") then {

	private _password = [8] call SAC_fnc_generatePassword;
	{
	
		_x setVariable ["SAC_access_code", _password, true];
	
	} forEach synchronizedObjects COP_SET_SAME_PASSWORD;

};

if (!isNil "COP_SET_UNIQUE_PASSWORD") then {

	{
	
		_x setVariable ["SAC_access_code", [8] call SAC_fnc_generatePassword, true];
	
	} forEach synchronizedObjects COP_SET_UNIQUE_PASSWORD;

};

if (!isNil "COP_TALK_REVEAL_PASSWORDS") then {

	{
	
		_x setVariable ["SAC_interact_interrogar", true, true];
		_x setVariable ["SAC_interact_revealPasswords", true, true];
	
	} forEach synchronizedObjects COP_TALK_REVEAL_PASSWORDS;

};
if (!isNil "COP_TALK_REVEAL_PASSWORDS_2") then {

	{
	
		_x setVariable ["SAC_interact_interrogar", true, true];
		_x setVariable ["SAC_interact_revealPasswords_2", true, true];
	
	} forEach synchronizedObjects COP_TALK_REVEAL_PASSWORDS_2;

};
if (!isNil "COP_TALK_REVEAL_PASSWORDS_3") then {

	{
	
		_x setVariable ["SAC_interact_interrogar", true, true];
		_x setVariable ["SAC_interact_revealPasswords_3", true, true];
	
	} forEach synchronizedObjects COP_TALK_REVEAL_PASSWORDS_3;

};

if (!isNil "COP_USE_REVEAL_PASSWORDS") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_revealPasswords", true, true];
	
	} forEach synchronizedObjects COP_USE_REVEAL_PASSWORDS;

};
if (!isNil "COP_USE_REVEAL_PASSWORDS_2") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_revealPasswords_2", true, true];
	
	} forEach synchronizedObjects COP_USE_REVEAL_PASSWORDS_2;

};
if (!isNil "COP_USE_REVEAL_PASSWORDS_3") then {

	{
	
		_x setVariable ["SAC_interact_use", true, true];
		_x setVariable ["SAC_interact_revealPasswords_3", true, true];
	
	} forEach synchronizedObjects COP_USE_REVEAL_PASSWORDS_3;

};
if (!isNil "COP_BLACKBOX") then {

	{
	
		_x setVariable ["sac_has_blackbox", true, true];
	
	} forEach synchronizedObjects COP_BLACKBOX;

};

if (!isNil "COP_PASSWORDS") then {{SAC_passwords pushbackUnique (_x getVariable ["SAC_access_code",""])} forEach synchronizedObjects COP_PASSWORDS};

if (!isNil "COP_PASSWORDS_2") then {{SAC_passwords_2 pushbackUnique (_x getVariable ["SAC_access_code",""])} forEach synchronizedObjects COP_PASSWORDS_2};

if (!isNil "COP_PASSWORDS_3") then {{SAC_passwords_3 pushbackUnique (_x getVariable ["SAC_access_code",""])} forEach synchronizedObjects COP_PASSWORDS_3};



/******************************************************************************************************************************************
Ejecutar todos los 'auto_init'.
*******************************************************************************************************************************************/
if ((!isNil "SAC_COP_CSAR_auto_init") && {SAC_COP_CSAR_auto_init}) then {

	if ((!isNil "SAC_COP_CSAR_can_generate") && {SAC_COP_CSAR_can_generate}) then {
	
		SAC_COP_CSAR_can_generate = false; publicVariable "SAC_COP_CSAR_can_generate";
		
		[]  call SAC_COP_fnc_dyn_CSAR;
		
	};

};

if ((!isNil "SAC_COP_DKT_auto_init") && {SAC_COP_DKT_auto_init}) then {

	if ((!isNil "SAC_COP_DKT_can_generate") && {SAC_COP_DKT_can_generate}) then {
	
		SAC_COP_DKT_can_generate = false; publicVariable "SAC_COP_DKT_can_generate";
		
		[]  call SAC_COP_fnc_dyn_killTarget;

	};

};


/******************************************************************************************************************************************
Ejecutar todas las órdenes indicadas con marcadores.
*******************************************************************************************************************************************/

private ["_parseResult", "_markerText"];

{

	if (markerText _x != "") then {
	
		_parseResult = (markerText _x) splitString "@";
		
		_markerText = _parseResult select 0;
		
		switch (_markerText) do {
			
			case "CRASH_SITE": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createCrashedAircraft;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {
						
							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createCrashedAircraft;
							
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createCrashedAircraft;
						
						};
					
					};
					case (count _parseResult == 3): {
						
						if (parseNumber (_parseResult select 1) != 0) then {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createCrashedAircraft;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createCrashedAircraft;
						
						};
						
					};

				};

			};
			
			case "BLUE_BROKEN_VEHICLE": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createDamagedVehicle;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {
						
							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createDamagedVehicle;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createDamagedVehicle;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createDamagedVehicle;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createDamagedVehicle;
						
						};
						
					};

				};
			
			};
		
			case "DRONE": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createDamagedDrone;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {
						
							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createDamagedDrone;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createDamagedDrone;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createDamagedDrone;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createDamagedDrone;
						
						};
						
					};

				};
			
			};

			case "AAA": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createEnemyAirDefense;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {
						
							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createEnemyAirDefense;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createEnemyAirDefense;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createEnemyAirDefense;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createEnemyAirDefense;
						
						};
						
					};

				};
			
			};
		
			case "TECHNICAL": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createTechnical;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createTechnical;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createTechnical;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createTechnical;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createTechnical;
						
						};
						
					};

				};
			
			};
			
			case "APC": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createAPC;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createAPC;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createAPC;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createAPC;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createAPC;
						
						};
						
					};

				};
			
			};

			case "IFV": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createIFV;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createIFV;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createIFV;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createIFV;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createIFV;
						
						};
						
					};

				};
			
			};

			case "TANK": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createTank;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createTank;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createTank;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createTank;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createTank;
						
						};
						
					};

				};
			
			};
		
			case "CREW": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createAircraftCrew;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createAircraftCrew;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createAircraftCrew;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createAircraftCrew;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createAircraftCrew;
						
						};
						
					};

				};
			
			};
		
			case "HOSTAGE_PILOTS": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createHostageArea_PILOTS;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createHostageArea_PILOTS;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createHostageArea_PILOTS;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createHostageArea_PILOTS;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createHostageArea_PILOTS;
						
						};
						
					};

				};
			
			};
			
			case "HOSTAGE_SOLDIERS": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createHostageArea_SOLDIERS;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createHostageArea_SOLDIERS;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createHostageArea_SOLDIERS;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createHostageArea_SOLDIERS;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createHostageArea_SOLDIERS;
						
						};
						
					};

				};
			
			};
			
			case "FORTIFY": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createFortifiedArea;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createFortifiedArea;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createFortifiedArea;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createFortifiedArea;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createFortifiedArea;
						
						};
						
					};
					case (count _parseResult == 4): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  spawn SAC_COP_fnc_createFortifiedArea;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createFortifiedArea;
						
						};
						
					};
					case (count _parseResult == 5): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), _parseResult select 4]  spawn SAC_COP_fnc_createFortifiedArea;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), _parseResult select 4]  call SAC_COP_fnc_createFortifiedArea;
						
						};
						
					};

				};
			
			};
			
			case "GARRISON": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createGarrisonedArea;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createGarrisonedArea;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createGarrisonedArea;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createGarrisonedArea;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createGarrisonedArea;
						
						};
						
					};
					case (count _parseResult == 4): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  spawn SAC_COP_fnc_createGarrisonedArea;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createGarrisonedArea;
						
						};
						
					};

				};
			
			};
			
			case "PATROLS_FOOT": {
			
				//"COP patrols found" call SAC_fnc_debugNotify;
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createPatrols;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createPatrols;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createPatrols;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createPatrols;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createPatrols;
						
						};
						
					};
					case (count _parseResult == 4): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  spawn SAC_COP_fnc_createPatrols;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createPatrols;
						
						};
						
					};

				};
			
			};
			
			case "STATIC_GROUPS": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createStaticGroups;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createStaticGroups;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createStaticGroups;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createStaticGroups;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createStaticGroups;
						
						};
						
					};
					case (count _parseResult == 4): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  spawn SAC_COP_fnc_createStaticGroups;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createStaticGroups;
						
						};
						
					};
					case (count _parseResult == 5): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  spawn SAC_COP_fnc_createStaticGroups;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  call SAC_COP_fnc_createStaticGroups;
						
						};
						
					};

				};
			
			};
			
			case "REVEAL": {
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createRevealArea;
					
					};
					case (count _parseResult == 2): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1)]  spawn SAC_COP_fnc_createRevealArea;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1)]  call SAC_COP_fnc_createRevealArea;
						
						};
						
					};
					case (count _parseResult == 3): {
					
						if (parseNumber (_parseResult select 1) != 0) then {

							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  spawn SAC_COP_fnc_createRevealArea;
						
						} else {
						
							[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)]  call SAC_COP_fnc_createRevealArea;
						
						};
						
					};

				};
			
			};
			
			case "MORTAR": { //MORTAR@PROB@DISPERSION@ROUNDS@DELAY@MAXSEARCHDISTANCE
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createMortarTrigger;
					
					};
					case (count _parseResult == 2): {
					
						[_x, parseNumber (_parseResult select 1)] call SAC_COP_fnc_createMortarTrigger;
						
					};
					case (count _parseResult == 3): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)] call SAC_COP_fnc_createMortarTrigger;
						
					};
					case (count _parseResult == 4): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createMortarTrigger;
						
					};
					case (count _parseResult == 5): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  call SAC_COP_fnc_createMortarTrigger;
						
					};
					case (count _parseResult == 6): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4), parseNumber (_parseResult select 5)]  call SAC_COP_fnc_createMortarTrigger;
						
					};

				};
			
			};
			
			case "ARTY": { //ARTY@PROB@DISPERSION@ROUNDS@DELAY@MAXSEARCHDISTANCE
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createArtyTrigger;
					
					};
					case (count _parseResult == 2): {
					
						[_x, parseNumber (_parseResult select 1)] call SAC_COP_fnc_createArtyTrigger;
						
					};
					case (count _parseResult == 3): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)] call SAC_COP_fnc_createArtyTrigger;
						
					};
					case (count _parseResult == 4): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createArtyTrigger;
						
					};
					case (count _parseResult == 5): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  call SAC_COP_fnc_createArtyTrigger;
						
					};
					case (count _parseResult == 6): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4), parseNumber (_parseResult select 5)]  call SAC_COP_fnc_createArtyTrigger;
						
					};

				};
			
			};
			
			case "SENDINFANTRY": { //SENDINFANTRY@PROB@SQUADS@WAVES@DELAY@WAVEDELAY
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createInfantryQRFTrigger;
					
					};
					case (count _parseResult == 2): {
					
						[_x, parseNumber (_parseResult select 1)] call SAC_COP_fnc_createInfantryQRFTrigger;
						
					};
					case (count _parseResult == 3): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)] call SAC_COP_fnc_createInfantryQRFTrigger;
						
					};
					case (count _parseResult == 4): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createInfantryQRFTrigger;
						
					};
					case (count _parseResult == 5): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  call SAC_COP_fnc_createInfantryQRFTrigger;
						
					};
					case (count _parseResult == 6): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4), parseNumber (_parseResult select 5)]  call SAC_COP_fnc_createInfantryQRFTrigger;
						
					};

				};
			
			};
			
			case "SENDMOTORINFANTRY": { //SENDMOTORINFANTRY@PROB@SQUADS@WAVES@DELAY@WAVEDELAY
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createMotorInfantryQRFTrigger;
					
					};
					case (count _parseResult == 2): {
					
						[_x, parseNumber (_parseResult select 1)] call SAC_COP_fnc_createMotorInfantryQRFTrigger;
						
					};
					case (count _parseResult == 3): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)] call SAC_COP_fnc_createMotorInfantryQRFTrigger;
						
					};
					case (count _parseResult == 4): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createMotorInfantryQRFTrigger;
						
					};
					case (count _parseResult == 5): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  call SAC_COP_fnc_createMotorInfantryQRFTrigger;
						
					};
					case (count _parseResult == 6): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4), parseNumber (_parseResult select 5)]  call SAC_COP_fnc_createMotorInfantryQRFTrigger;
						
					};
					
				};
			
			};	

			case "SENDHELIINFANTRY": { //SENDHELIINFANTRY@PROB@SQUADS@WAVES@DELAY@WAVEDELAY
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createHeliInfantryQRFTrigger;
					
					};
					case (count _parseResult == 2): {
					
						[_x, parseNumber (_parseResult select 1)] call SAC_COP_fnc_createHeliInfantryQRFTrigger;
						
					};
					case (count _parseResult == 3): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)] call SAC_COP_fnc_createHeliInfantryQRFTrigger;
						
					};
					case (count _parseResult == 4): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createHeliInfantryQRFTrigger;
						
					};
					case (count _parseResult == 5): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  call SAC_COP_fnc_createHeliInfantryQRFTrigger;
						
					};
					case (count _parseResult == 6): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4), parseNumber (_parseResult select 5)]  call SAC_COP_fnc_createHeliInfantryQRFTrigger;
						
					};

				};
			
			};
			
			case "SENDTECHNICALS": { //SENDTECHNICALS@PROB@SQUADS@WAVES@DELAY@WAVEDELAY
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createTechnicalsQRFTrigger;
					
					};
					case (count _parseResult == 2): {
					
						[_x, parseNumber (_parseResult select 1)] call SAC_COP_fnc_createTechnicalsQRFTrigger;
						
					};
					case (count _parseResult == 3): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)] call SAC_COP_fnc_createTechnicalsQRFTrigger;
						
					};
					case (count _parseResult == 4): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createTechnicalsQRFTrigger;
						
					};
					case (count _parseResult == 5): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  call SAC_COP_fnc_createTechnicalsQRFTrigger;
						
					};
					case (count _parseResult == 6): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4), parseNumber (_parseResult select 5)]  call SAC_COP_fnc_createTechnicalsQRFTrigger;
						
					};
					
				};
			
			};
			
			case "SENDAPC": { //SENDAPC@PROB@SQUADS@WAVES@DELAY@WAVEDELAY
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createAPCQRFTrigger;
					
					};
					case (count _parseResult == 2): {
					
						[_x, parseNumber (_parseResult select 1)] call SAC_COP_fnc_createAPCQRFTrigger;
						
					};
					case (count _parseResult == 3): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)] call SAC_COP_fnc_createAPCQRFTrigger;
						
					};
					case (count _parseResult == 4): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createAPCQRFTrigger;
						
					};
					case (count _parseResult == 5): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  call SAC_COP_fnc_createAPCQRFTrigger;
						
					};
					case (count _parseResult == 6): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4), parseNumber (_parseResult select 5)]  call SAC_COP_fnc_createAPCQRFTrigger;
						
					};
					
				};
			
			};
			
			case "SENDIFV": { //SENDIFV@PROB@SQUADS@WAVES@DELAY@WAVEDELAY
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createIFVQRFTrigger;
					
					};
					case (count _parseResult == 2): {
					
						[_x, parseNumber (_parseResult select 1)] call SAC_COP_fnc_createIFVQRFTrigger;
						
					};
					case (count _parseResult == 3): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)] call SAC_COP_fnc_createIFVQRFTrigger;
						
					};
					case (count _parseResult == 4): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createIFVQRFTrigger;
						
					};
					case (count _parseResult == 5): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  call SAC_COP_fnc_createIFVQRFTrigger;
						
					};
					case (count _parseResult == 6): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4), parseNumber (_parseResult select 5)]  call SAC_COP_fnc_createIFVQRFTrigger;
						
					};
					
				};
			
			};
			
			case "SENDTANK": { //SENDTANK@PROB@SQUADS@WAVES@DELAY@WAVEDELAY
			
				switch (true) do {
				
					case (count _parseResult == 1): {
					
						[_x] call SAC_COP_fnc_createTankQRFTrigger;
					
					};
					case (count _parseResult == 2): {
					
						[_x, parseNumber (_parseResult select 1)] call SAC_COP_fnc_createTankQRFTrigger;
						
					};
					case (count _parseResult == 3): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2)] call SAC_COP_fnc_createTankQRFTrigger;
						
					};
					case (count _parseResult == 4): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3)]  call SAC_COP_fnc_createTankQRFTrigger;
						
					};
					case (count _parseResult == 5): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4)]  call SAC_COP_fnc_createTankQRFTrigger;
						
					};
					case (count _parseResult == 6): {
					
						[_x, parseNumber (_parseResult select 1), parseNumber (_parseResult select 2), parseNumber (_parseResult select 3), parseNumber (_parseResult select 4), parseNumber (_parseResult select 5)]  call SAC_COP_fnc_createTankQRFTrigger;
						
					};
					
				};
			
			};	
			
		};
	};

} forEach allMapMarkers;

/*
{

	if (!alive _x) then {SAC_hiddenTargetObjects set [_forEachIndex, objNull]};

} forEach SAC_hiddenTargetObjects;

SAC_hiddenTargetObjects = SAC_hiddenTargetObjects - [objNull];
*/

publicVariable "SAC_hiddenTargetObjects";
publicVariable "SAC_hiddenTargetObjects_2";
publicVariable "SAC_hiddenTargetObjects_3";

publicVariable "SAC_passwords";
publicVariable "SAC_passwords_2";
publicVariable "SAC_passwords_3";

