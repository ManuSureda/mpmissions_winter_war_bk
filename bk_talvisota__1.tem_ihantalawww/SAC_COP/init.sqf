//Código que se ejecuta antes de la pantalla de briefing (o que no espera hasta después de ésta)

[] call compile preprocessFileLineNumbers "SAC_COP\hide_cop_markers.sqf";

//En MP, el player ya no es null en la pantalla del mapa del briefing, antes de que los jugadores le den OK.
if (!isDedicated) then {waitUntil {!isNull player}};

//wait for the simulation to start
//nota 2: se supone que time no empieza a correr hasta que no se pasa la pantalla del mapa del briefing
waitUntil {time>0};

//Finish world initialization before mission is launched.
finishMissionInit;

0 fademusic 0;
0 fadeSound 0;
0 fadeRadio 0;

///////////////////////////////////////////////////////////////////////
//Código para sincronizar cambio de hora del día.
///////////////////////////////////////////////////////////////////////
if (!isServer) then {

	"SAC_MP_timeShift" addPublicVariableEventHandler {

		setDate (_this select 1);

	};

};

///////////////////////////////////////////////////////////////////////
//Código que corre en servidores dedicados, no dedicados, y clientes.
///////////////////////////////////////////////////////////////////////

[] call compile preprocessFileLineNumbers "sac_functions.sqf";

[] call compile preprocessFileLineNumbers "SAC_GEAR\main.sqf";

///////////////////////////////////////////////////////////////////////
//Código que corre sólo en clientes y servidores no dedicados.
///////////////////////////////////////////////////////////////////////
if (!isNull player) then {

	waitUntil {!isNull findDisplay 46}; //esto es necesario porque si no el engine no respeta el primer 'sleep'
	
	[] call compile preprocessFileLineNumbers "SAC_VOL\main.sqf";

	["ALPHA", "BRAVO", "NATO", 15, "allowattack"] call compile preprocessFileLineNumbers "SAC_THU\main.sqf";
	
	["GOLF", "INDIA", "IRRELEVANT", 15, "allowattack"] call compile preprocessFileLineNumbers "SAC_TVU\main.sqf";
	
	SAC_SQUAD_no_damage_ai = false;
	[] call compile preprocessFileLineNumbers "SAC_SQUAD2\main.sqf";

	SAC_FACR_radioChannel = "CHARLIE";
	SAC_FACR_airstrikeDelay = 10; //siempre fue 40
	SAC_FACR_mortarDelay = 30;
	SAC_FACR_artilleryDelay = 20;
	[] call compile preprocessFileLineNumbers "SAC_FACR\main.sqf";

	["DELTA"] call compile preprocessFileLineNumbers "SAC_EXPLO\main.sqf";

	["HOTEL"] call compile preprocessFileLineNumbers "SAC_TRACK\init.sqf";

	[] call SAC_fnc_addHandleDamage; //pantalla negra en vez de morir
	
	[] call compile preprocessFileLineNumbers "SAC_interact\main.sqf";
	
//	[] call compile preprocessFileLineNumbers "sac_downed_players_markers.sqf";
	[] call compile preprocessFileLineNumbers "sac_players_markers.sqf";
	
	[] execVM "sac_entag2020.sqf";
	
	if (isNil "SAC_PLAYER_SIDE") then {"Error: SAC_COP - Falta definir SAC_PLAYER_SIDE." call SAC_fnc_MPhintC};
	if !(SAC_PLAYER_SIDE in [west, east, resistance]) then {"Error: SAC_COP - SAC_PLAYER_SIDE no contiene un bando válido." call SAC_fnc_MPhintC};
	if (isNil "GEAR_NVG") then {"Error: SAC_COP - Falta definir GEAR_NVG." call SAC_fnc_MPhintC};
	if (isNil "TAC_B_REGULAR") then {"Error: SAC_COP - Falta definir TAC_B_REGULAR." call SAC_fnc_MPhintC};
	if (isNil "TAC_B_MILITIA") then {"Error: SAC_COP - Falta definir TAC_B_MILITIA." call SAC_fnc_MPhintC};
	if (isNil "TAC_O_REGULAR") then {"Error: SAC_COP - Falta definir TAC_O_REGULAR." call SAC_fnc_MPhintC};
	if (isNil "TAC_O_MILITIA") then {"Error: SAC_COP - Falta definir TAC_O_MILITIA." call SAC_fnc_MPhintC};
	if (isNil "CTS_ON") then {"Error: SAC_COP - Falta definir CTS_ON." call SAC_fnc_MPhintC};
	if (isNil "AMB_ON") then {"Error: SAC_COP - Falta definir AMB_ON." call SAC_fnc_MPhintC};
	if (isNil "AMB_IED") then {"Error: SAC_COP - Falta definir AMB_IED." call SAC_fnc_MPhintC};
	if (isNil "ITS_ON") then {"Error: SAC_COP - Falta definir ITS_ON." call SAC_fnc_MPhintC};
	if (isNil "IPS_ON") then {"Error: SAC_COP - Falta definir IPS_ON." call SAC_fnc_MPhintC};
	if (isNil "DGS_ON") then {"Error: SAC_COP - Falta definir DGS_ON." call SAC_fnc_MPhintC};
	if (isNil "MTS_ON") then {"Error: SAC_COP - Falta definir MTS_ON." call SAC_fnc_MPhintC};
	
	if (isNil "COP_TAC_interval") then {"Error: SAC_COP - Falta definir COP_TAC_interval." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_dynamic_greenzones") then {"Error: SAC_COP - Falta definir COP_TAC_dynamic_greenzones." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_intervalVariation") then {"Error: SAC_COP - Falta definir COP_TAC_intervalVariation." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_delay") then {"Error: SAC_COP - Falta definir COP_TAC_delay." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_groupsPerRun") then {"Error: SAC_COP - Falta definir COP_TAC_groupsPerRun." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_groupsPerRunVariation") then {"Error: SAC_COP - Falta definir COP_TAC_groupsPerRunVariation." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_maxGroupsTAC") then {"Error: SAC_COP - Falta definir COP_TAC_maxGroupsTAC." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_responseTypesSquematicRegular") then {"Error: SAC_COP - Falta definir COP_TAC_responseTypesSquematicRegular." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_responseTypesSquematicMilitia") then {"Error: SAC_COP - Falta definir COP_TAC_responseTypesSquematicMilitia." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_markerNamesRegular") then {"Error: SAC_COP - Falta definir COP_TAC_markerNamesRegular." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_markerNamesMilitia") then {"Error: SAC_COP - Falta definir COP_TAC_markerNamesMilitia." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_playersAsTargets") then {"Error: SAC_COP - Falta definir COP_TAC_playersAsTargets." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_playersAsTargets_prob") then {"Error: SAC_COP - Falta definir COP_TAC_playersAsTargets_prob." call SAC_fnc_MPhintC};
	if (isNil "COP_TAC_dynamicGreenzonesTTL") then {"Error: SAC_COP - Falta definir COP_TAC_dynamicGreenzonesTTL." call SAC_fnc_MPhintC};
	
	if (isNil "COP_IPS_patrols_count") then {"Error: SAC_COP - Falta definir COP_IPS_patrols_count." call SAC_fnc_MPhintC};
	if (isNil "COP_IPS_interval") then {"Error: SAC_COP - Falta definir COP_IPS_interval." call SAC_fnc_MPhintC};
	if (isNil "COP_DGS_groups_count") then {"Error: SAC_COP - Falta definir COP_DGS_groups_count." call SAC_fnc_MPhintC};

	if (isNil "COP_MTS_trafficTypesSquematic") then {"Error: SAC_COP - Falta definir COP_MTS_trafficTypesSquematic." call SAC_fnc_MPhintC};
	if (isNil "COP_MTS_interval") then {"Error: SAC_COP - Falta definir COP_MTS_interval." call SAC_fnc_MPhintC};

	//control por cambio posterior a muchas misiones anteriores
	if (count SAC_green_zones == 0) then {"Warning: SAC_COP - SAC_green_zones no contiene elementos." call SAC_fnc_MPhintC};
	
	
};

///////////////////////////////////////////////////////////////////////
//Código que corre en servidores dedicados y no dedicados.
///////////////////////////////////////////////////////////////////////
if (isServer) then {

	///////////////////////////////////////////////////////////////////////
	//Cambios de hora del día.
	///////////////////////////////////////////////////////////////////////
	if ((!isNil "SAC_randomizeTime") && {SAC_randomizeTime}) then {
	
		SAC_MP_timeShift = [2018, round random 12, round random 28, round random 24, round random 60];
		setDate SAC_MP_timeShift;
		publicVariable "SAC_MP_timeShift";
		
	};
	
	[[0,0,0], 50000] call SAC_fnc_initAllVehicles;
	
	[] call SAC_fnc_initAllUnits;

	["flares"] execVM "sac_night.sqf";

	private _initDelay = 0; //en minutos
	
	if ((!isNil "TAC_O_MILITIA") && {TAC_O_MILITIA}) then {
		//Tactical Response para los milicianos
		SAC_TAC_initDelay = _initDelay + COP_TAC_delay;
		SAC_TAC_dynamic_greenzones = COP_TAC_dynamic_greenzones;
		SAC_TAC_interval = COP_TAC_interval;
		SAC_TAC_intervalVariation = COP_TAC_intervalVariation;
		SAC_TAC_groupsPerRun = COP_TAC_groupsPerRun;
		SAC_TAC_groupsPerRunVariation = COP_TAC_groupsPerRunVariation;
		SAC_TAC_maxGroupsTotal = 144; //siempre fue 144
		SAC_TAC_maxGroupsTAC = COP_TAC_maxGroupsTAC; //siempre fue 144
		SAC_TAC_Blacklists = SAC_green_zones + SAC_no_tac_zones;
		SAC_TAC_infClasses = SAC_UDS_O_G_Soldiers;
		SAC_TAC_transportVehClasses = SAC_UDS_O_G_unarmedTransport;
		SAC_TAC_armedVehNoArmorClasses = SAC_UDS_O_G_armedTransport;
		SAC_TAC_armedVehArmorAPCClasses = SAC_UDS_O_G_APC;
		SAC_TAC_armedVehArmorIFVClasses = SAC_UDS_O_G_IFV;
		SAC_TAC_armorTankClasses = SAC_UDS_O_G_Tanks;
		SAC_TAC_helicopterClasses = SAC_UDS_O_G_transportHelicopter;
		SAC_TAC_skill = [0.2, 0.4];
		SAC_TAC_responseTypesSquematic = COP_TAC_responseTypesSquematicMilitia;
		SAC_TAC_pilotClass = SAC_UDS_O_G_HeliPilot;
		SAC_TAC_crewClasses = SAC_UDS_O_G_TankCrews;
		SAC_TAC_minUnits = 4;
		SAC_TAC_maxUnits = 7;
		SAC_TAC_markerNames = COP_TAC_markerNamesMilitia;
		//["TAC_TARGET_MILITIA", "TAC_TARGET"];
		SAC_TAC_playersAsTargets = COP_TAC_playersAsTargets;
		SAC_TAC_playersAsTargets_prob = COP_TAC_playersAsTargets_prob;
		SAC_TAC_dynamicGreenzonesTTL = COP_TAC_dynamicGreenzonesTTL;
		[] call compile preprocessFileLineNumbers "sac_tac_multi_instance_202105.sqf";
		_initDelay = _initDelay + 1;
	
	};
	
	if ((!isNil "TAC_O_REGULAR") && {TAC_O_REGULAR}) then {
		//Tactical Response para los militares
		SAC_TAC_initDelay = _initDelay + COP_TAC_delay;
		SAC_TAC_dynamic_greenzones = COP_TAC_dynamic_greenzones;
		SAC_TAC_interval = COP_TAC_interval;
		SAC_TAC_intervalVariation = COP_TAC_intervalVariation;
		SAC_TAC_groupsPerRun = COP_TAC_groupsPerRun;
		SAC_TAC_groupsPerRunVariation = COP_TAC_groupsPerRunVariation;
		SAC_TAC_maxGroupsTotal = 144; //siempre fue 144
		SAC_TAC_maxGroupsTAC = COP_TAC_maxGroupsTAC; //siempre fue 144
		SAC_TAC_Blacklists = SAC_green_zones + SAC_no_tac_zones;
		SAC_TAC_infClasses = SAC_UDS_O_Soldiers;
		SAC_TAC_transportVehClasses = SAC_UDS_O_unarmedTransport;
		SAC_TAC_armedVehNoArmorClasses = SAC_UDS_O_armedTransport;
		SAC_TAC_armedVehArmorAPCClasses = SAC_UDS_O_APC;
		SAC_TAC_armedVehArmorIFVClasses = SAC_UDS_O_IFV;
		SAC_TAC_armorTankClasses = SAC_UDS_O_Tanks;
		SAC_TAC_helicopterClasses = SAC_UDS_O_transportHelicopter;
		SAC_TAC_skill = [0.2, 0.4];
		SAC_TAC_responseTypesSquematic = COP_TAC_responseTypesSquematicRegular;
		SAC_TAC_pilotClass = SAC_UDS_O_HeliPilot;
		SAC_TAC_crewClasses = SAC_UDS_O_TankCrews;
		SAC_TAC_minUnits = 4;
		SAC_TAC_maxUnits = 7;
		SAC_TAC_markerNames = COP_TAC_markerNamesRegular;
		//["TAC_TARGET_REGULAR", "TAC_TARGET"];
		SAC_TAC_playersAsTargets = COP_TAC_playersAsTargets;
		SAC_TAC_playersAsTargets_prob = COP_TAC_playersAsTargets_prob;
		SAC_TAC_dynamicGreenzonesTTL = COP_TAC_dynamicGreenzonesTTL;
		[] call compile preprocessFileLineNumbers "sac_tac_multi_instance_202105.sqf";
		_initDelay = _initDelay + 1;

	};
		
	if ((!isNil "TAC_B_MILITIA") && {TAC_B_MILITIA}) then {
		//Tactical Response para los milicianos
		SAC_TAC_initDelay = _initDelay + COP_TAC_delay;
		SAC_TAC_dynamic_greenzones = COP_TAC_dynamic_greenzones;
		SAC_TAC_interval = COP_TAC_interval;
		SAC_TAC_intervalVariation = COP_TAC_intervalVariation;
		SAC_TAC_groupsPerRun = COP_TAC_groupsPerRun;
		SAC_TAC_groupsPerRunVariation = COP_TAC_groupsPerRunVariation;
		SAC_TAC_maxGroupsTotal = 144; //siempre fue 144
		SAC_TAC_maxGroupsTAC = COP_TAC_maxGroupsTAC; //siempre fue 144
		SAC_TAC_Blacklists = SAC_green_zones + SAC_no_tac_zones;
		SAC_TAC_infClasses = SAC_UDS_B_G_Soldiers;
		SAC_TAC_transportVehClasses = SAC_UDS_B_G_unarmedTransport;
		SAC_TAC_armedVehNoArmorClasses = SAC_UDS_B_G_armedTransport;
		SAC_TAC_armedVehArmorAPCClasses = SAC_UDS_B_G_APC;
		SAC_TAC_armedVehArmorIFVClasses = SAC_UDS_B_G_IFV;
		SAC_TAC_armorTankClasses = SAC_UDS_B_G_Tanks;
		SAC_TAC_helicopterClasses = SAC_UDS_B_G_transportHelicopter;
		SAC_TAC_skill = [0.2, 0.4];
		SAC_TAC_responseTypesSquematic = COP_TAC_responseTypesSquematicMilitia;
		SAC_TAC_pilotClass = SAC_UDS_O_G_Soldiers select 0;
		SAC_TAC_crewClasses = SAC_UDS_B_G_Soldiers;
		SAC_TAC_minUnits = 4;
		SAC_TAC_maxUnits = 7;
		SAC_TAC_markerNames = COP_TAC_markerNamesMilitia;
		//["TAC_TARGET_MILITIA", "TAC_TARGET"];
		SAC_TAC_playersAsTargets = COP_TAC_playersAsTargets;
		SAC_TAC_playersAsTargets_prob = COP_TAC_playersAsTargets_prob;
		SAC_TAC_dynamicGreenzonesTTL = COP_TAC_dynamicGreenzonesTTL;
		[] call compile preprocessFileLineNumbers "sac_tac_multi_instance.sqf";
		_initDelay = _initDelay + 1;
	};
	
	if ((!isNil "TAC_B_REGULAR") && {TAC_B_REGULAR}) then {
		//Tactical Response para los militares
		SAC_TAC_initDelay = _initDelay + COP_TAC_delay;
		SAC_TAC_dynamic_greenzones = COP_TAC_dynamic_greenzones;
		SAC_TAC_interval = COP_TAC_interval;
		SAC_TAC_intervalVariation = COP_TAC_intervalVariation;
		SAC_TAC_groupsPerRun = COP_TAC_groupsPerRun;
		SAC_TAC_groupsPerRunVariation = COP_TAC_groupsPerRunVariation;
		SAC_TAC_maxGroupsTotal = 144; //siempre fue 144
		SAC_TAC_maxGroupsTAC = COP_TAC_maxGroupsTAC; //siempre fue 144
		SAC_TAC_Blacklists = SAC_green_zones + SAC_no_tac_zones;
		SAC_TAC_infClasses = SAC_UDS_B_Soldiers;
		SAC_TAC_transportVehClasses = SAC_UDS_B_unarmedTransport;
		SAC_TAC_armedVehNoArmorClasses = SAC_UDS_B_armedTransport;
		SAC_TAC_armedVehArmorAPCClasses = SAC_UDS_B_APC;
		SAC_TAC_armedVehArmorIFVClasses = SAC_UDS_B_IFV;
		SAC_TAC_armorTankClasses = SAC_UDS_B_Tanks;
		SAC_TAC_helicopterClasses = SAC_UDS_B_transportHelicopter;
		SAC_TAC_skill = [0.2, 0.4];
		SAC_TAC_responseTypesSquematic = COP_TAC_responseTypesSquematicRegular;
		SAC_TAC_pilotClass = SAC_UDS_B_HeliPilot;
		SAC_TAC_crewClasses = SAC_UDS_B_TankCrews;
		SAC_TAC_minUnits = 4;
		SAC_TAC_maxUnits = 7;
		SAC_TAC_markerNames = COP_TAC_markerNamesRegular;
		//["TAC_TARGET_REGULAR", "TAC_TARGET"];
		SAC_TAC_playersAsTargets = COP_TAC_playersAsTargets;
		SAC_TAC_playersAsTargets_prob = COP_TAC_playersAsTargets_prob;
		SAC_TAC_dynamicGreenzonesTTL = COP_TAC_dynamicGreenzonesTTL;
		[] call compile preprocessFileLineNumbers "sac_tac_multi_instance.sqf";
		_initDelay = _initDelay + 1;
	};
	
	[SAC_green_zones] spawn compile preprocessFileLineNumbers "SAC_COP\main.sqf";
	
	if ((!isNil "CTS_ON") && {CTS_ON}) then {
		SAC_CTS_Blacklist = ["SAC_CTS_blacklist"] + SAC_no_cts_spawn_zones;
		SAC_CTS_Greenzones = SAC_cts_green_zones;
		SAC_CTS_interval = COP_CTS_interval;
		SAC_CTS_trackFlyingPlayers = COP_CTS_trackFlyingPlayers;
		[] spawn compile preprocessFileLineNumbers "sac_civilian_traffic.sqf";
	};
	
	if ((!isNil "AMB_ON") && {AMB_ON}) then {
		SAC_AMB_prob = 0.046;
		SAC_AMB_blacklist = SAC_green_zones;
		SAC_AMB_greenzones = SAC_green_zones;
		[] spawn compile preprocessFileLineNumbers "sac_ambushV2.sqf";
	};
	
	if ((!isNil "ITS_ON") && {ITS_ON}) then {
		SAC_ITS_prob = 0.08;
		SAC_ITS_VBIED_prob = .8;
		SAC_ITS_Blacklist = SAC_green_zones;
		SAC_ITS_Greenzones = SAC_green_zones;
		[] spawn compile preprocessFileLineNumbers "sac_insurgency_traffic.sqf";	
	};
	
	if ((!isNil "IPS_ON") && {IPS_ON}) then {
		SAC_IPS_unitClasses = SAC_UDS_O_G_Soldiers;
		SAC_IPS_skill = [0.1, 0.2];
		SAC_IPS_minUnits = 4;
		SAC_IPS_maxUnits = 6;
		SAC_IPS_minDistanceFromPlayers = 500;
		SAC_IPS_minDistanceBetweenPoints = 700;
		SAC_IPS_maxGroups = COP_IPS_patrols_count;
		SAC_IPS_Blacklist = SAC_green_zones;
		SAC_IPS_Greenzones = SAC_green_zones;
		SAC_IPS_maxDistanceFromCenter = 1200;
		SAC_IPS_interval = COP_IPS_interval;
		SAC_IPS_trackFlyingPlayers = COP_IPS_trackFlyingPlayers;
		[] spawn compile preprocessFileLineNumbers "sac_infantry_patrols_real_test.sqf";
	};
	
	if ((!isNil "DGS_ON") && {DGS_ON}) then {
		SAC_DGS_unitClasses = SAC_UDS_O_G_Soldiers;
		SAC_DGS_skill = [0.1, 0.2];
		SAC_DGS_minUnits = 3;
		SAC_DGS_maxUnits = 5;
		SAC_DGS_minDistanceFromPlayers = 300;
		SAC_DGS_maxGroups = COP_DGS_groups_count;
		SAC_DGS_Blacklist = SAC_green_zones;
		SAC_DGS_Greenzones = SAC_green_zones;
		SAC_DGS_maxDistanceFromCenter = 700;
		SAC_DGS_interval = 10;
		SAC_DGS_allowWater = true;
		[] spawn compile preprocessFileLineNumbers "sac_dynamic_garrisons.sqf";
	};
	
	if ((!isNil "MTS_ON") && {MTS_ON}) then {
		SAC_MTS_trafficTypesSquematic = COP_MTS_trafficTypesSquematic;
		SAC_MTS_trafficUnarmed = SAC_UDS_O_G_trafficUnarmed;
		SAC_MTS_trafficArmedSoft = SAC_UDS_O_G_trafficArmed;
		SAC_MTS_trafficCrew = SAC_UDS_O_G_Soldiers;
		SAC_MTS_trafficAPC = SAC_UDS_O_G_APC;
		SAC_MTS_trafficAPCCrew = SAC_UDS_O_G_Soldiers;
		SAC_MTS_Blacklist = SAC_green_zones;
		SAC_MTS_Greenzones = SAC_green_zones + SAC_no_mts_spawn_zones;
		SAC_MTS_interval = COP_MTS_interval;
		SAC_MTS_trackFlyingPlayers = COP_MTS_trackFlyingPlayers;
		[] spawn compile preprocessFileLineNumbers "sac_military_traffic.sqf";
	};

	SAC_MP_initializationReady = true;
	publicVariable "SAC_MP_initializationReady";

};

//Código que borra los slots de líderes y sus unidades, previstos para otros jugadores, en el caso
//de una partida SP. Se asume que los slots jugables son los líderes siempre y solamente. También
//se borran los vehículos que tripulaban.
if (!isMultiplayer) then {

	private _groupsToDelete = [];
	private _vehiclesToDelete = [];
	
	{
		
		if (!isPlayer _x) then {
		
			{

				_vehiclesToDelete pushBackUnique _x;
				_vehiclesToDelete pushBackUnique vehicle _x;
				
			
			} forEach units group _x;
			
			_groupsToDelete pushBack group _x;
		
		};

	} forEach switchableUnits;

	{deleteVehicle _x} forEach _vehiclesToDelete;

	{

		if ((units _x) findIf {alive _x} == -1) then {

			//"_items", "_positions", "_proximityMode", "_distances", "_checkInterval", "_side", "_aliveCheck", "_TTLCheck"
			[[_x], [], 0, [0, 0], 120, civilian, false, false] spawn SAC_fnc_garbageCollector;

		};

	} forEach _groupsToDelete;

};

//****************************************
//Última parte que corre solo en clientes
//****************************************
if (!isServer) then {

	waitUntil{!isNil "SAC_MP_initializationReady" && {SAC_MP_initializationReady}};

};

if (hasInterface) then {

	if (!isNil "SAC_musictrack") then {SAC_musictrack call SAC_fnc_playMusic} else {
	
		switch (toLower(worldName)) do {
		
			case "isladuala3": {"white_rabbit" call SAC_fnc_playMusic};
			
			case "lythium": {"slight_return" call SAC_fnc_playMusic};
			
			case "tanoa": {"long_tall_sally" call SAC_fnc_playMusic};
			
			case "eden": {};
			
			default {"fortunate_son" call SAC_fnc_playMusic};
		
		};
		
	};

};
