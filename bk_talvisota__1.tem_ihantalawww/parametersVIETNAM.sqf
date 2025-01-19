SAC_UDS_unitsProfile = "OP_BITING";
SAC_SQUAD_loadoutProfile = "NONE";
SAC_GEAR_B_loadoutProfile = "NONE";
SAC_GEAR_O_loadoutProfile = "NONE";
SAC_GEAR_O_G_loadoutProfile = "NONE";
GEAR_NVG = false;
AMB_IED = false;
CTS_ON = false;
AMB_ON = true;
ITS_ON = false;
IPS_ON = true;
DGS_ON = true;
MTS_ON = true;

COP_visualCaching = true;
COP_visualCaching_distance = 700;

TAC_B_REGULAR = false; TAC_B_MILITIA = false;
TAC_O_REGULAR = false; TAC_O_MILITIA = true;
SAC_UDS_O_vehicleProfile = "BIS_CSAT";
SAC_UDS_O_G_vehicleProfile = "OP_BITING_V_G";
SAC_UDS_C_vehicleProfile = "CIV_WW2_GRAL";
SAC_UDS_weaponColor = "BLACK";

COP_TAC_interval = 5;
COP_TAC_dynamic_greenzones = true;
COP_TAC_intervalVariation = 0;
COP_TAC_delay = 1;
COP_TAC_groupsPerRun = 1;
COP_TAC_groupsPerRunVariation = 1;
COP_TAC_maxGroupsTAC = 20;
COP_TAC_responseTypesSquematicRegular = ["INF_FOOT", 15, "INF_VEHICLE", 15, "INF_HELICOPTER", 5, "VEHICLE_NOARMOR", 2, "VEHICLE_ARMOR_IFV", 2, "VEHICLE_ARMOR_TANK", 1];
COP_TAC_responseTypesSquematicMilitia = ["INF_FOOT", 30];//, "INF_VEHICLE", 25, "VEHICLE_NOARMOR", 15, "VEHICLE_ARMOR_IFV", 2];
COP_TAC_markerNamesRegular = ["TAC_TARGET_REGULAR", "TAC_TARGET"];
COP_TAC_markerNamesMilitia = ["TAC_TARGET_MILITIA", "TAC_TARGET"];
COP_TAC_playersAsTargets = true;
COP_TAC_playersAsTargets_prob = 0.25;
COP_TAC_dynamicGreenzonesTTL = 0;

COP_IPS_patrols_count = 2;
COP_IPS_interval = 4;
COP_IPS_trackFlyingPlayers = false;

COP_DGS_groups_count = 1;

COP_MTS_trafficTypesSquematic = ["UNARMED", 20, "ARMED_SOFT", 10, "APC", 1];
COP_MTS_interval = 10; //recomended 10+
COP_MTS_trackFlyingPlayers = false;

COP_CTS_interval = 7;
COP_CTS_trackFlyingPlayers = false;

SAC_PLAYER_SIDE = east; //tiene que estar definido aca porque depende de cada misi�n

SAC_randomizeTime = false;
