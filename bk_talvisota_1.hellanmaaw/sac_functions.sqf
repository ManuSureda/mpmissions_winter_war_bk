//
//Funciones generales usadas por todos los scripts.
//

SAC_RHS = ("rhs_main" in activatedAddons);

//SAC_ace = ("ace_common" in activatedAddons);
SAC_ace = isClass(configFile >> "CfgPatches" >> "ace_main");

//SAC_sounds = ("sac_sounds_a3" in activatedAddons);
SAC_sounds = (isClass(configFile >> "CfgPatches" >> "sac_sounds_a3"));

SAC_unsung = (isClass(configFile >> "CfgAmmo" >> "Uns_Napalm_750"));

SAC_VSM = ("vsm_shemagh_config" in activatedAddons);

SAC_MEU_nvg = ("meu_nvg_cs" in activatedAddons);

if (isClass(configFile >> "CfgWeapons" >> "lbt_tl_od")) then {SAC_spec4_lbt = true} else {SAC_spec4_lbt = false};

SAC_FGN = ("fgn_caurebels_troops" in activatedAddons);

SAC_STUI = ("stui_autobrightness" in activatedAddons);

SAC_SMA = ("sma_weapons" in activatedAddons);

SAC_FFCP = ("ffcamopack_aaf" in activatedAddons);

SAC_VW_CUP = (isClass(configFile >> "CfgPatches" >> "vw_us_vehicles_sas")); //vehiculos del Vietnam (CUP-S&S)

SAC_CUP = (isClass(configFile >> "CfgWeapons" >> "CUP_I_B_PARA_Unit_5"));

SAC_NSW = (isClass(configFile >> "CfgWeapons" >> "cargoflannel_5_uni"));

SAC_TFL = (isClass(configFile >> "CfgWeapons" >> "tfl_g3_field_uniform"));

SAC_TFN = (isClass(configFile >> "CfgWeapons" >> "TFN_Gen3_Gen3_rs_or_cb_Flag_uniform"));

SAC_ERHS = (isClass(configFile >> "CfgWeapons" >> "mbavr_r"));

if (isClass(configFile >> "CfgVehicles" >> "RDS_Gaz24_Civ_03")) then {SAC_RDS = true} else {SAC_RDS = false};

if (isClass(configFile >> "CfgVehicles" >> "B_MH60L_noprobe_F")) then {SAC_CAA = true} else {SAC_CAA = false};

if (isClass(configFile >> "CfgVehicles" >> "UK3CB_TKC_C_Datsun_Civ_Closed")) then {SAC_3CBF = true} else {SAC_3CBF = false};

if (isClass(configFile >> "CfgVehicles" >> "flb_mappack_Standard_mc")) then {SAC_FLB = true} else {SAC_FLB = false};

if (isClass(configFile >> "CfgWeapons" >> "USAF_Overalls_Ranger_2_w")) then {SAC_75TH = true} else {SAC_75TH = false};

if (isClass(configFile >> "CfgVehicles" >> "LOP_SLA_Mi8MT_Cargo")) then {SAC_LOP = true} else {SAC_LOP = false};

if (isClass(configFile >> "CfgWeapons" >> "opscore_sf_rgr_full")) then {SAC_helmets2035 = true} else {SAC_helmets2035 = false};
if (isClass(configFile >> "CfgWeapons" >> "opscore_sf_rgr_full")) then {SAC_helmets2035 = true} else {SAC_helmets2035 = false};

if (isClass(configFile >> "CfgWeapons" >> "COD_Bump_21")) then {SAC_bumps = true} else {SAC_bumps = false};



#define PUID_SEBASTIAN 	"76561198088417899"
#define PUID_DIEGO		"76561198136923707"
#define PUID_EAREN 		"76561197971465779"
#define PUID_MANU       "76561198058849858"

SAC_nosounds_PUIDs = [];

//"_SP_PLAYER_" esto es lo que devuelve getPlayerUID en SP
SAC_THU_PUIDs   = ["_SP_PLAYER_", PUID_SEBASTIAN, PUID_DIEGO, PUID_EAREN, PUID_MANU];
SAC_TVU_PUIDs   = ["_SP_PLAYER_", PUID_SEBASTIAN, PUID_DIEGO, PUID_EAREN, PUID_MANU];
SAC_FACR_PUIDs  = ["_SP_PLAYER_", PUID_SEBASTIAN, PUID_DIEGO, PUID_EAREN, PUID_MANU];
SAC_TRACK_PUIDs = ["_SP_PLAYER_", PUID_SEBASTIAN, PUID_EAREN, PUID_MANU];

if (!isDedicated) then {

	if (getPlayerUID player in SAC_nosounds_PUIDs) then {
	
		SAC_sounds = false;
	
	};

};



sac_request_activated_addons = "";
sac_activated_addons = activatedAddons;

if (!isDedicated) then {

	"sac_request_activated_addons" addPublicVariableEventHandler {

		if ((_this select 1) == name player) then {

			sac_activated_addons = activatedAddons;
			publicVariable "sac_activated_addons";
			
		};
		
	};

};

if (!isDedicated) then {

	if (getPlayerUID player == PUID_SEBASTIAN) then {
	
		"sac_activated_addons" addPublicVariableEventHandler {

			_this spawn SAC_fnc_verifyAddons;
			
		};

	};

};

SAC_fnc_verifyAddons = {

	private _activatedAddons =  _this select 1;
	
	systemChat format ["Addons verification started for player %1", sac_request_activated_addons];
	diag_log format ["Addons verification started for player %1", sac_request_activated_addons];

	//método 1 (probado)
/*	{
	
		if !(_x in activatedAddons) then {
		
			systemChat format ["Warning: Player %2 is using %1", _x, sac_request_activated_addons];
			diag_log format ["Warning: Player %2 is using %1", _x, sac_request_activated_addons];
			
		};
	
	} foreach _activatedAddons;
*/

	//método 2 (a prueba)
	private _sameAddons = _activatedAddons arrayIntersect activatedAddons;
	systemChat format ["%1 has this extra addons: %2", sac_request_activated_addons, _activatedAddons - _sameAddons];
	diag_log format ["%1 has this extra addons: %2", sac_request_activated_addons, _activatedAddons - _sameAddons];

	systemChat format ["You have this extra addons: %1", activatedAddons - _sameAddons];
	diag_log format ["You have this extra addons: %1", activatedAddons - _sameAddons];




	
	systemChat format ["Addons verification finished for player %1", sac_request_activated_addons];
	diag_log format ["Addons verification finished for player %1", sac_request_activated_addons];
	
};

SAC_fnc_playMusic = {

	if (getPlayerUID player in SAC_nosounds_PUIDs) exitWith {};
	
	playMusic _this

};

SAC_garrisons = []; //registra todos los EDIFICIOS ocupados por unidades enemigas al bando del jugador


//BIS_spetsnaz ******************* 2020
SAC_bis_spetsnaz_recon = ["O_R_recon_AR_F", "O_R_recon_exp_F", "O_R_recon_GL_F", "O_R_recon_JTAC_F", "O_R_recon_M_F",
"O_R_recon_medic_F", "O_R_recon_LAT_F", "O_R_recon_TL_F"];

SAC_bis_spetsnaz_soldiers = ["O_R_Soldier_AR_F","O_R_medic_F","O_R_soldier_exp_F","O_R_Soldier_GL_F","O_R_JTAC_F",
"O_R_soldier_M_F","O_R_Soldier_LAT_F","O_R_Soldier_TL_F"];

//BIS_CSAT ASSETS ****************

// SAC_bis_csat_regular_soldiers = ["O_Soldier_AR_F", "O_medic_F", "O_engineer_F", "O_soldier_exp_F", "O_Soldier_GL_F", "O_HeavyGunner_F", "O_soldier_M_F", "O_Soldier_AT_F", "O_soldier_repair_F",
// "O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_lite_F", "O_Sharpshooter_F", "O_Soldier_SL_F", "O_Soldier_TL_F", "O_Soldier_A_F"];

SAC_bis_csat_regular_soldiers = ["O_Soldier_AR_F", "O_medic_F", "O_engineer_F", "O_Soldier_GL_F", "O_HeavyGunner_F", "O_soldier_M_F", "O_Soldier_AT_F",
"O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_SL_F", "O_Soldier_TL_F"];

SAC_bis_csat_regular_soldiers_urban = ["O_soldierU_A_F", "O_soldierU_AR_F", "O_soldierU_medic_F", "O_engineer_U_F", "O_soldierU_exp_F", "O_SoldierU_GL_F", "O_Urban_HeavyGunner_F", "O_soldierU_M_F",
"O_soldierU_AT_F", "O_soldierU_repair_F", "O_soldierU_F", "O_soldierU_LAT_F", "O_Urban_Sharpshooter_F", "O_SoldierU_SL_F", "O_soldierU_TL_F"];

SAC_bis_csat_sf_soldiers = ["O_recon_F","O_recon_M_F","O_recon_LAT_F","O_recon_medic_F","O_recon_exp_F","O_recon_JTAC_F","O_recon_TL_F","O_Pathfinder_F","O_recon_F",
"O_recon_F","O_recon_F","O_recon_F"];

SAC_bis_csat_viper_soldiers = ["O_V_Soldier_Exp_hex_F","O_V_Soldier_JTAC_hex_F","O_V_Soldier_M_hex_F","O_V_Soldier_Medic_hex_F","O_V_Soldier_LAT_hex_F","O_V_Soldier_TL_hex_F", "O_V_Soldier_hex_F"];

SAC_bis_csat_aa_soldiers = ["O_Soldier_AA_F", "O_Soldier_AA_F", "O_Soldier_AA_F"];

SAC_bis_csat_helicopter_pilot = "O_helipilot_F";

SAC_bis_csat_tank_crew = "O_crew_F";

SAC_bis_csat_atv_unarmed = ["O_MRAP_02_F", "O_LSV_02_unarmed_F"];

SAC_bis_csat_atv_armed = ["O_MRAP_02_hmg_F", "O_LSV_02_armed_F"];

SAC_bis_csat_tanks = ["O_MBT_02_cannon_F", "O_MBT_04_cannon_F"];

SAC_bis_csat_apcs = ["O_APC_Wheeled_02_rcws_v2_F"];

SAC_bis_csat_ifvs = ["O_APC_Tracked_02_cannon_F"];

SAC_bis_csat_aa = ["O_APC_Tracked_02_AA_F"];

SAC_bis_csat_transport = ["O_Truck_02_covered_F", "O_Truck_02_transport_F", "O_Truck_03_transport_F", "O_Truck_03_covered_F"];

SAC_bis_csat_logistics = ["O_Truck_03_repair_F", "O_Truck_03_ammo_F", "O_Truck_03_fuel_F", "O_Truck_03_medical_F", "O_Truck_02_box_F", "O_Truck_02_medical_F", "O_Truck_02_Ammo_F", "O_Truck_02_fuel_F"];

SAC_bis_csat_multirole_helicopters = ["O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F"]; //ataque y transporte

SAC_bis_csat_transport_helicopters_unarmed = ["O_Heli_Light_02_unarmed_F", "O_Heli_Transport_04_bench_F", "O_Heli_Transport_04_covered_F"];

SAC_bis_csat_transport_helicopters_armed = ["O_Heli_Light_02_F"];

SAC_bis_csat_water = [];


//*******************************

//BIS_CSAT_PACIFIC ASSETS ****************

SAC_bis_csat_pacific_regular_soldiers = ["O_T_Soldier_AR_F", "O_T_medic_F", "O_T_engineer_F", "O_T_Soldier_GL_F", "O_T_soldier_M_F", "O_T_Soldier_AT_F",
"O_T_Soldier_F", "O_T_Soldier_LAT_F", "O_T_Soldier_SL_F", "O_T_Soldier_TL_F"];

SAC_bis_csat_pacific_sf_soldiers = ["O_T_recon_F","O_T_recon_M_F","O_T_recon_LAT_F","O_T_recon_medic_F","O_T_recon_exp_F","O_T_recon_JTAC_F","O_T_recon_TL_F","O_T_recon_F",
"O_T_recon_F","O_T_recon_F","O_T_recon_F"];

SAC_bis_csat_pacific_viper_soldiers = ["O_V_Soldier_Exp_ghex_F","O_V_Soldier_JTAC_ghex_F","O_V_Soldier_M_ghex_F","O_V_Soldier_Medic_ghex_F","O_V_Soldier_LAT_ghex_F","O_V_Soldier_TL_ghex_F", "O_V_Soldier_ghex_F"];

SAC_bis_csat_pacific_aa_soldiers = ["O_T_Soldier_AA_F", "O_T_Soldier_AA_F", "O_T_Soldier_AA_F"];

SAC_bis_csat_pacific_helicopter_pilot = "O_T_helipilot_F";

SAC_bis_csat_pacific_tank_crew = "O_T_Crew_F";

SAC_bis_csat_pacific_atv_unarmed = ["O_T_MRAP_02_ghex_F", "O_T_LSV_02_unarmed_F"];

SAC_bis_csat_pacific_atv_armed = ["O_T_MRAP_02_hmg_ghex_F", "O_T_LSV_02_armed_F"];

SAC_bis_csat_pacific_tanks = ["O_T_MBT_02_cannon_ghex_F", "O_T_MBT_04_cannon_F"];

SAC_bis_csat_pacific_apcs = ["O_T_APC_Wheeled_02_rcws_ghex_F"];

SAC_bis_csat_pacific_ifvs = ["O_T_APC_Tracked_02_cannon_ghex_F"];

SAC_bis_csat_pacific_aa = ["O_T_APC_Tracked_02_AA_ghex_F"];

SAC_bis_csat_pacific_transport = ["O_T_Truck_03_covered_ghex_F", "O_T_Truck_03_transport_ghex_F"];

SAC_bis_csat_pacific_logistics = ["O_T_Truck_03_repair_ghex_F", "O_T_Truck_03_ammo_ghex_F", "O_T_Truck_03_fuel_ghex_F", "O_T_Truck_03_medical_ghex_F"];

SAC_bis_csat_pacific_multirole_helicopters = ["O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F"]; //ataque y transporte

SAC_bis_csat_pacific_transport_helicopters_unarmed = ["O_Heli_Light_02_unarmed_F", "O_Heli_Transport_04_bench_F", "O_Heli_Transport_04_covered_F"];

SAC_bis_csat_pacific_transport_helicopters_armed = ["O_Heli_Light_02_F"];

SAC_bis_csat_pacific_water = ["O_T_Boat_Transport_01_F", "O_T_Lifeboat", "O_T_Boat_Armed_01_hmg_F"];

//*******************************

//BIS_GUERILLA_east ASSETS ******
SAC_bis_o_guerilla_soldiers = ["O_G_Soldier_F","O_G_Soldier_SL_F","O_G_Soldier_TL_F","O_G_Soldier_AR_F","O_G_medic_F","O_G_Soldier_GL_F","O_G_Soldier_M_F",
"O_G_Soldier_LAT_F", "O_G_engineer_F"]; //, "O_G_Sharpshooter_F"];

SAC_bis_o_guerilla_aa_soldiers = ["O_Soldier_AA_F", "O_Soldier_AA_F", "O_Soldier_AA_F"];

SAC_bis_o_guerilla_atv_unarmed = ["O_G_Offroad_01_F"];

SAC_bis_o_guerilla_atv_armed = ["O_G_Offroad_01_armed_F"];

SAC_bis_o_guerilla_transport = ["O_G_Van_01_transport_F"];

SAC_bis_o_guerilla_logistics = ["O_G_Van_01_fuel_F"];
//*******************************

//BIS_NATO ASSETS ***************
SAC_bis_nato_regular_soldiers = ["B_Soldier_F","B_Soldier_GL_F","B_soldier_AR_F","B_Soldier_SL_F","B_Soldier_TL_F","B_soldier_M_F","B_soldier_LAT_F","B_medic_F",
"B_soldier_repair_F","B_soldier_AT_F", "B_HeavyGunner_F"]; //, "B_Sharpshooter_F"];

SAC_bis_nato_sf_soldiers = ["B_recon_exp_F", "B_recon_JTAC_F", "B_recon_M_F", "B_recon_medic_F", "B_recon_F", "B_recon_LAT_F", "B_Recon_Sharpshooter_F", "B_recon_TL_F"];

SAC_bis_nato_aa_soldiers = ["B_soldier_AA_F", "B_soldier_AA_F", "B_soldier_AA_F"];

SAC_bis_nato_officers = ["B_officer_F"];

SAC_bis_nato_atv_unarmed = ["B_MRAP_01_F"];

SAC_bis_nato_atv_armed = ["B_MRAP_01_gmg_F", "B_MRAP_01_hmg_F"];

SAC_bis_nato_tanks = ["B_MBT_01_cannon_F", "B_MBT_01_TUSK_F"];

SAC_bis_nato_apcs = ["B_APC_Wheeled_01_cannon_F"];

SAC_bis_nato_ifvs = ["B_APC_Tracked_01_rcws_F"];

SAC_bis_nato_aa = ["B_APC_Tracked_01_AA_F"];

SAC_bis_nato_helicopter_pilot = "B_Helipilot_F";

SAC_bis_nato_tank_crew = "B_crew_F";

SAC_bis_nato_transport = ["B_Truck_01_transport_F", "B_Truck_01_covered_F"];

SAC_bis_nato_logistics = ["B_Truck_01_mover_F", "B_Truck_01_box_F", "B_Truck_01_Repair_F", "B_Truck_01_ammo_F", "B_Truck_01_fuel_F", "B_Truck_01_medical_F"];

SAC_bis_nato_attack_helicopters = ["B_Heli_Attack_01_F"];

SAC_bis_nato_multirole_helicopters = []; //ataque y transporte

SAC_bis_nato_transport_helicopters_unarmed = ["B_Heli_Light_01_F", "B_Heli_Transport_03_unarmed_F"];

SAC_bis_nato_transport_helicopters_armed = ["B_Heli_Transport_01_F", "B_Heli_Transport_01_camo_F", "B_Heli_Transport_03_F"];

SAC_bis_nato_water = ["B_Boat_Armed_01_minigun_F", "B_Boat_Transport_01_F", "B_Lifeboat", "B_SDV_01_F"];

//*******************************

//BIS_NATO_PACIFIC ASSETS ***************
SAC_bis_nato_pacific_regular_soldiers = ["B_T_Soldier_F","B_T_Soldier_GL_F","B_T_soldier_AR_F","B_T_Soldier_SL_F","B_T_Soldier_TL_F","B_T_soldier_M_F","B_T_soldier_LAT_F","B_T_medic_F",
"B_T_soldier_repair_F","B_T_soldier_AT_F"]; //, "B_T_Sharpshooter_F"];

SAC_bis_nato_pacific_sf_soldiers = ["B_T_recon_exp_F", "B_T_recon_JTAC_F", "B_T_recon_M_F", "B_T_recon_medic_F", "B_T_recon_F", "B_T_recon_LAT_F", "B_T_recon_TL_F"];

SAC_bis_nato_pacific_aa_soldiers = ["B_T_soldier_AA_F", "B_T_soldier_AA_F", "B_T_soldier_AA_F"];

SAC_bis_nato_pacific_atv_unarmed = ["B_T_MRAP_01_F", "B_T_LSV_01_unarmed_F"];

SAC_bis_nato_pacific_atv_armed = ["B_T_MRAP_01_gmg_F", "B_T_MRAP_01_hmg_F", "B_T_LSV_01_armed_F"];

SAC_bis_nato_pacific_tanks = ["B_T_MBT_01_cannon_F", "B_T_MBT_01_TUSK_F"];

SAC_bis_nato_pacific_apcs = ["B_T_APC_Wheeled_01_cannon_F"];

SAC_bis_nato_pacific_ifvs = ["B_T_APC_Tracked_01_rcws_F"];

SAC_bis_nato_pacific_aa = ["B_T_APC_Tracked_01_AA_F"];

SAC_bis_nato_pacific_helicopter_pilot = "B_T_Helipilot_F";

SAC_bis_nato_pacific_tank_crew = "B_T_crew_F";

SAC_bis_nato_pacific_transport = ["B_T_Truck_01_transport_F", "B_T_Truck_01_covered_F"];

SAC_bis_nato_pacific_logistics = ["B_T_Truck_01_mover_F", "B_T_Truck_01_box_F", "B_T_Truck_01_Repair_F", "B_T_Truck_01_ammo_F", "B_T_Truck_01_fuel_F", "B_T_Truck_01_medical_F"];

SAC_bis_nato_pacific_attack_helicopters = ["B_Heli_Attack_01_F"];

SAC_bis_nato_pacific_multirole_helicopters = []; //ataque y transporte

SAC_bis_nato_pacific_transport_helicopters_unarmed = ["B_Heli_Light_01_F", "B_Heli_Transport_03_unarmed_F"];

SAC_bis_nato_pacific_transport_helicopters_armed = ["B_Heli_Transport_01_F", "B_Heli_Transport_01_camo_F", "B_Heli_Transport_03_F"];

SAC_bis_nato_pacific_water = ["B_T_Boat_Armed_01_minigun_F", "B_T_Boat_Transport_01_F", "B_T_Lifeboat"];

//*******************************

//BIS_AAF ASSETS ***************
SAC_bis_aaf_regular_soldiers = ["I_soldier_F","I_Soldier_GL_F","I_Soldier_AR_F","I_Soldier_SL_F","I_Soldier_TL_F","I_Soldier_M_F",
"I_Soldier_LAT_F","I_Soldier_AT_F","I_medic_F","I_Soldier_repair_F"];

SAC_bis_aaf_aa_soldiers = ["I_Soldier_AA_F", "I_Soldier_AA_F", "I_Soldier_AA_F"];

SAC_bis_aaf_officers = ["I_officer_F", "I_Story_Colonel_F"];

SAC_bis_aaf_atv_unarmed = ["I_MRAP_03_F"];

SAC_bis_aaf_atv_armed = ["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F"];

SAC_bis_aaf_tanks = ["I_MBT_03_cannon_F"];

SAC_bis_aaf_apcs = ["I_APC_Wheeled_03_cannon_F"];

SAC_bis_aaf_ifvs = ["I_APC_tracked_03_cannon_F"];

SAC_bis_aaf_aa = [];

SAC_bis_aaf_helicopter_pilot = "I_helipilot_F";

SAC_bis_aaf_tank_crew = "I_crew_F";

SAC_bis_aaf_transport = ["I_Truck_02_covered_F", "I_Truck_02_transport_F"];

SAC_bis_aaf_logistics = ["I_Truck_02_ammo_F", "I_Truck_02_box_F", "I_Truck_02_medical_F", "I_Truck_02_fuel_F"];

SAC_bis_aaf_attack_helicopters = [];

SAC_bis_aaf_multirole_helicopters = []; //ataque y transporte

SAC_bis_aaf_transport_helicopters_unarmed = ["I_Heli_Transport_02_F", "I_Heli_light_03_unarmed_F"];

SAC_bis_aaf_transport_helicopters_armed = ["I_Heli_light_03_F"];

SAC_bis_aaf_water = ["I_Boat_Armed_01_minigun_F", "I_Boat_Transport_01_F", "I_SDV_01_F"];

//*******************************

//BIS_GUERILLA_ind ASSETS ******
SAC_bis_i_guerilla_soldiers = ["I_G_Soldier_F","I_G_Soldier_SL_F","I_G_Soldier_TL_F","I_G_Soldier_AR_F","I_G_medic_F","I_G_Soldier_GL_F","I_G_Soldier_M_F",
"I_G_Soldier_LAT_F", "I_G_engineer_F", "I_G_Sharpshooter_F"];

SAC_bis_i_guerilla_atv_unarmed = ["I_G_Offroad_01_F"];

SAC_bis_i_guerilla_atv_armed = ["I_G_Offroad_01_armed_F"];

SAC_bis_i_guerilla_transport = ["I_G_Van_01_transport_F"];

SAC_bis_i_guerilla_logistics = ["I_G_Van_01_fuel_F"];
//*******************************

//BIS_GUERILLA_fia ASSETS ******
SAC_bis_b_guerilla_soldiers = ["B_G_Soldier_F","B_G_Soldier_SL_F","B_G_Soldier_TL_F","B_G_Soldier_AR_F","B_G_medic_F","B_G_Soldier_GL_F","B_G_Soldier_M_F",
"B_G_Soldier_LAT_F", "B_G_engineer_F"]; //, "B_G_Sharpshooter_F"];

SAC_bis_b_guerilla_atv_unarmed = ["B_G_Offroad_01_F"];

SAC_bis_b_guerilla_atv_armed = ["B_G_Offroad_01_armed_F"];

SAC_bis_b_guerilla_transport = ["B_G_Van_01_transport_F"];

SAC_bis_b_guerilla_logistics = ["B_G_Van_01_fuel_F"];
//*******************************

//BIS_syndikat_ind ASSETS ******
SAC_bis_syndikat_bandits_soldiers = ["I_C_Soldier_Bandit_1_F","I_C_Soldier_Bandit_2_F","I_C_Soldier_Bandit_3_F","I_C_Soldier_Bandit_4_F","I_C_Soldier_Bandit_5_F","I_C_Soldier_Bandit_6_F","I_C_Soldier_Bandit_7_F",
"I_C_Soldier_Bandit_8_F"];

SAC_bis_syndikat_paramilitary_soldiers = ["I_C_Soldier_Para_1_F","I_C_Soldier_Para_2_F","I_C_Soldier_Para_3_F","I_C_Soldier_Para_4_F",
"I_C_Soldier_Para_5_F","I_C_Soldier_Para_6_F","I_C_Soldier_Para_7_F", "I_C_Soldier_Para_8_F"];

SAC_bis_syndikat_paramilitary_atv_unarmed = ["I_C_Offroad_02_unarmed_F"];

SAC_bis_syndikat_paramilitary_transport = ["I_C_Van_01_transport_F"];

//*******************************

//BIS CIVILIAN ASSETS *****
SAC_bis_civilian_logistic_vehicles = ["C_Van_01_fuel_F", "C_Offroad_01_repair_F", "C_Truck_02_fuel_F", "C_Truck_02_box_F", "C_Van_01_transport_F",
"C_Van_01_box_F", "C_Truck_02_transport_F", "C_Truck_02_covered_F", "C_Van_02_medevac_F", "C_Van_02_service_F", "C_IDAP_Van_02_medevac_F",
"C_IDAP_Truck_02_water_F", "C_IDAP_Offroad_02_unarmed_F", "C_IDAP_Offroad_01_F", "C_IDAP_Van_02_transport_F", "C_IDAP_Truck_02_transport_F",
"C_IDAP_Truck_02_F"]; //solo aparecen en generadores de tráfico

SAC_bis_civilian_transport_vehicles = ["C_Hatchback_01_F", "C_Offroad_01_F", "C_SUV_01_F", "C_Hatchback_01_sport_F", "C_Offroad_02_unarmed_F",
"C_Van_02_vehicle_F", "C_Van_02_transport_F"]; //además de en tráfico, también aparecen estacionados en casas de civiles

SAC_bis_altis_civilian_men = ["C_man_p_beggar_F", "C_man_1", "C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_4_F", "C_man_polo_5_F", "C_man_polo_6_F",
"C_man_hunter_1_F", "C_Man_casual_1_F", "C_Man_casual_2_F", "C_Man_casual_3_F", "C_man_sport_1_F", "C_man_sport_2_F", "C_man_sport_3_F", "C_Man_casual_4_F", "C_Man_casual_5_F",
"C_Man_casual_6_F", "C_Man_Fisherman_01_F", "C_Story_Mechanic_01_F"];

SAC_bis_afro_civilian_men = ["C_man_p_beggar_F_afro", "C_man_polo_1_F_afro", "C_man_polo_2_F_afro", "C_man_polo_3_F_afro", "C_man_polo_4_F_afro", "C_man_polo_5_F_afro",
 "C_man_polo_6_F_afro", "C_Man_casual_1_F_afro", "C_Man_casual_2_F_afro", "C_Man_casual_3_F_afro", "C_man_sport_1_F_afro", "C_man_sport_2_F_afro",
 "C_man_sport_3_F_afro", "C_Man_casual_4_F_afro", "C_Man_casual_5_F_afro","C_Man_casual_6_F", "C_Man_Fisherman_01_F"];

 SAC_bis_euro_civilian_men = ["C_man_p_beggar_F_euro", "C_man_polo_1_F_euro", "C_man_polo_2_F_euro", "C_man_polo_3_F_euro", "C_man_polo_4_F_euro", "C_man_polo_5_F_euro",
 "C_man_polo_6_F_euro", "C_Man_casual_1_F_euro", "C_Man_casual_2_F_euro", "C_Man_casual_3_F_euro", "C_man_sport_1_F_euro", "C_man_sport_2_F_euro",
 "C_man_sport_3_F_euro", "C_Man_casual_4_F_euro", "C_Man_casual_5_F_euro","C_Man_casual_6_F", "C_Man_Fisherman_01_F", "C_Story_Mechanic_01_F"];

 SAC_bis_tanoan_civilian_men = ["C_Man_casual_1_F_tanoan", "C_Man_casual_2_F_tanoan", "C_Man_casual_3_F_tanoan", "C_man_sport_1_F_tanoan", "C_man_sport_2_F_tanoan",
 "C_man_sport_3_F_tanoan", "C_Man_casual_4_F_tanoan", "C_Man_casual_5_F_tanoan","C_Man_casual_6_F", "C_Man_Fisherman_01_F", "C_Story_Mechanic_01_F"];


//**************************************




SAC_problematic_vehicles = ["rhsgref_BRDM2", "rhsgref_cdf_btr60", "rhsgref_cdf_btr70", "rhsgref_cdf_bmp1d", "rhsgref_cdf_bmp1d", "rhsgref_cdf_bmp1k", "rhsgref_cdf_bmp1p", "rhsgref_cdf_bmp2e",
"rhsgref_cdf_bmp2", "rhsgref_cdf_bmp2d", "rhsgref_cdf_bmp2k", "rhsgref_BRDM2_msv", "rhs_btr70_msv", "rhs_btr60_msv", "rhs_bmp1_msv", "rhs_bmp1d_msv", "rhs_bmp1k_msv", "rhs_bmp1p_msv",
"rhs_bmp2e_msv", "rhs_bmp2_msv", "rhs_bmp2d_msv", "rhs_bmp2k_msv", "rhs_brm1k_msv", "rhs_Ob_681_2", "rhs_btr80_msv", "rhs_bmp3_late_msv", "rhs_bmp3m_msv", "rhs_bmp3mera_msv"];

SAC_gasmasks = ["mcu2p2_grey", "G_AirPurifyingRespirator_01_F"];


//********** infrastructure altis ***********************

SAC_infrastructure_a3 = ["Land_TTowerSmall_2_F", "Land_dp_smallTank_F", "Land_TBox_F", "Land_TTowerBig_2_F", "Land_Radar_F", "Land_Radar_Small_F", "Land_fs_feed_F",
"Land_spp_Tower_F", "Land_dp_bigTank_F", "Land_Communication_F", "Land_i_Shed_Ind_F", "Land_dp_smallFactory_F", "Land_HighVoltageEnd_F", "HighVoltageTower_Large_F"];


//*******************************************************

//********* edificios con 6 posiciones como mínimo ******
//SAC_buildingClasses_6p = ["Land_i_House_Big_01_V2_F","Land_i_Shed_Ind_F","Land_i_Barracks_V2_F","Land_Offices_01_V1_F","Land_Unfinished_Building_01_F","Land_i_Shop_01_V2_F","Land_i_House_Big_02_V1_F","Land_u_Shop_02_V1_F","Land_u_House_Big_01_V1_F","Land_i_Shop_02_V2_F","Land_i_Shop_02_V3_F","Land_i_Shop_01_V3_F","Land_i_House_Big_01_V3_F","Land_i_House_Big_02_V3_F","Land_u_Shop_01_V1_F","Land_Unfinished_Building_02_F","Land_u_House_Big_02_V1_F","Land_Bridge_01_PathLod_F","Land_i_House_Big_02_V2_F","Land_i_Shop_01_V1_F","Land_i_Shop_02_V1_F","Land_i_House_Big_01_V1_F","Land_d_House_Big_02_V1_F","Land_d_Shop_01_V1_F","Land_Hospital_side2_F","Land_Hospital_main_F","Land_CarService_F","Land_WIP_F","Land_dp_bigTank_F","Land_u_Barracks_V2_F","Land_Factory_Main_F","Land_Stadium_p9_F","Land_MilOffices_V1_F","Land_spp_Tower_F","Land_Hangar_F","Land_LightHouse_F","Land_Airport_Tower_F","Land_Airport_right_F","Land_Airport_left_F","Land_Research_HQ_F","Land_GH_House_1_F","Land_GH_Gazebo_F","Land_GH_MainBuilding_left_F","Land_GH_MainBuilding_middle_F","Land_GH_MainBuilding_right_F","Land_Radar_F","Land_i_Barracks_V1_F"];

/*
// HABITABLE HOUSES
SAC_habitable_houses = [ // Habitable Greek houses with white walls, red roofs, intact doors and windows
"Land_i_House_Small_01_V1_F",
"Land_i_House_Small_01_V2_F",
"Land_i_House_Small_01_V3_F",
"Land_i_House_Small_02_V1_F",
"Land_i_House_Small_02_V2_F",
"Land_i_House_Small_02_V3_F",
"Land_i_House_Small_03_V1_F",
"Land_i_House_Big_01_V1_F",
"Land_i_House_Big_01_V2_F",
"Land_i_House_Big_01_V3_F",
"Land_i_House_Big_02_V1_F",
"Land_i_House_Big_02_V2_F",
"Land_i_House_Big_02_V3_F",

"Land_i_Stone_HouseBig_V1_F", //agregador por mí, son las casas en la zona montañosa
"Land_i_Stone_HouseSmall_V1_F",
"Land_i_Stone_Shed_V1_F",

"Land_House_L_1_EP1", // OA classes - thanks Spliffz
"Land_House_L_3_EP1",
"Land_House_L_4_EP1",
"Land_House_L_6_EP1",
"Land_House_L_7_EP1",
"Land_House_L_8_EP1",
"Land_House_L_9_EP1",
"Land_House_K_1_EP1",
"Land_House_K_3_EP1",
"Land_House_K_5_EP1",
"Land_House_K_6_EP1",
"Land_House_K_7_EP1",
"Land_House_K_8_EP1",
"Land_Terrace_K_1_EP1",
"Land_House_C_1_EP1",
"Land_House_C_1_v2_EP1",
"Land_House_C_2_EP1",
"Land_House_C_3_EP1",
"Land_House_C_4_EP1",
"Land_House_C_5_EP1",
"Land_House_C_5_V1_EP1",
"Land_House_C_5_V2_EP1",
"Land_House_C_5_V3_EP1",
"Land_House_C_9_EP1",
"Land_House_C_10_EP1",
"Land_House_C_11_EP1",
"Land_House_C_12_EP1",
"Land_A_Villa_EP1",
"Land_A_Mosque_small_1_EP1",
"Land_A_Mosque_small_2_EP1",
//"Land_Ind_FuelStation_Feed_EP1",
"Land_Ind_FuelStation_Build_EP1",
"Land_Ind_FuelStation_Shed_EP1",
"Land_Ind_Garage01_EP1",

"Land_HouseV_1I1",  // A2 classes - thanks Reserve
"Land_HouseV_1I2",
"Land_HouseV_1I3",
"Land_HouseV_1I4",
"Land_HouseV_1L1",
"Land_HouseV_1L2",
"Land_HouseV_1T",
"Land_HouseV_2I",
"Land_HouseV_2L",
"Land_HouseV_2T1",
"Land_HouseV_2T2",
"Land_HouseV_3I1",
"Land_HouseV_3I2",
"Land_HouseV_3I3",
"Land_HouseV_3I4",
"Land_HouseV2_01A",
"Land_HouseV2_01B",
"Land_HouseV2_02",
"Land_HouseV2_03",
"Land_HouseV2_03B",
"Land_HouseV2_04",
"Land_HouseV2_05",
"Land_HouseBlock_A1",
"Land_HouseBlock_A2",
"Land_HouseBlock_A3",
"Land_HouseBlock_B1",
"Land_HouseBlock_B2",
"Land_HouseBlock_B3",
"Land_HouseBlock_C2",
"Land_HouseBlock_C3",
"Land_HouseBlock_C4",
"Land_HouseBlock_C5",
"Land_Church_02",
"Land_Church_02A",
"Land_Church_03",
//"Land_A_FuelStation_Feed",
"Land_A_FuelStation_Build",
"Land_A_FuelStation_Shed",

"Land_dum_istan2",// Fallujah
"Land_dum_istan2b",
"Land_dum_istan2_01",
"Land_dum_istan2_02",
"Land_dum_istan2_03",
"Land_dum_istan2_03a",
"Land_dum_istan2_04a",
"Land_dum_istan3",
"Land_dum_istan3_hromada",
"Land_dum_istan4",
"Land_dum_istan4_big",
"Land_dum_istan4_big_inverse",
"Land_dum_istan4_detaily1",
"Land_dum_istan4_inverse",
"Land_dum_mesto3_istan",
"Land_hotel",
"Land_stanek_1",
"Land_stanek_1b",
"Land_stanek_1c",
"Land_stanek_2",
"Land_stanek_2b",
"Land_stanek_2c",
"Land_stanek_3",
"Land_stanek_3b",
"Land_stanek_3c"
];
*/

SAC_sovietSongs = ["sovietsong01", "sovietsong02", "sovietsong03", "sovietsong04", "sovietsong05", "sovietsong06", "sovietsong07", "sovietsong08"];

SAC_arabicSongs = ["arabicsong01", "arabicsong02", "arabicsong03", "arabicsong04", "arabicsong05", "arabicsong06", "arabicsong07", "arabicsong08"];

SAC_reggaeSongs = ["reggaesong01", "reggaesong02", "reggaesong03", "reggaesong04", "reggaesong05", "reggaesong06", "reggaesong07",	"reggaesong08",
"reggaesong09", "reggaesong10", "reggaesong11"];

SAC_africanSongs = ["africansong01", "africansong02", "africansong03", "africansong04", "africansong05", "africansong06", "africansong07",
"africansong08", "africansong09"];

SAC_cumbias = ["cumbia1", "cumbia2", "cumbia3", "cumbia4", "cumbia5", "cumbia6", "cumbia7"];

SAC_russian_radio_samples = ["russianchatter1", "russianchatter2", "russianchatter3", "russianchatter4", "russianchatter5", "russianchatter6",
"russianchatter7", "russianchatter8", "russianchatter9", "russianchatter10", "russianchatter11", "russianchatter12", "russianchatter13",
"russianchatter14", "russianchatter15", "russianchatter16", "russianchatter17", "russianchatter18", "russianchatter19", "russianchatter20",
"russianchatter21", "russianchatter22", "russianchatter23", "russianchatter24", "russianchatter25", "russianchatter26", "russianchatter27",
"russianchatter28", "russianchatter28", "russianchatter30", "russianchatter31", "russianchatter32", "russianchatter33", "russianchatter34",
"russianchatter35", "russianchatter36", "russianchatter37", "russianchatter38"];

SAC_vehicles_with_radio = ["O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_AA_F", "O_MBT_02_cannon_F", "O_MBT_04_cannon_F", "O_MBT_02_arty_F", "O_APC_Wheeled_02_rcws_v2_F",
"O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F", "O_MRAP_02_F"];

SAC_flares = ["F_40mm_White", "F_40mm_Green", "F_40mm_Red", "F_40mm_Yellow", "uns_40mm_white", "uns_40mm_green",
"ACE_40mm_Flare_white", "ACE_40mm_Flare_green", "ACE_40mm_Flare_red"];

SAC_binoculars = ["Binocular", "Rangefinder", "Laserdesignator"];

SAC_ieds = ["DemoCharge_Remote_Ammo_Scripted", "SatchelCharge_Remote_Ammo_Scripted"];

SAC_militaryFortifications = [
	"Land_Cargo_Tower_V1_No1_F",
	"Land_Cargo_Tower_V1_No2_F",
	"Land_Cargo_Tower_V1_No3_F",
	"Land_Cargo_Tower_V1_No4_F",
	"Land_Cargo_Tower_V1_No5_F",
	"Land_Cargo_Tower_V1_No6_F",
	"Land_Cargo_Tower_V1_No7_F",
	"Land_Cargo_Tower_V1_F",
	"Land_Cargo_Tower_V2_F",
	"Land_Cargo_Tower_V3_F",
	"Land_Cargo_Patrol_V1_F",
	"Land_Cargo_Patrol_V2_F",
	"Land_Cargo_Patrol_V3_F",
	"Land_Cargo_Patrol_V1_F",
	"Land_Cargo_Patrol_V2_F",
	"Land_Cargo_Patrol_V3_F",
	"Land_Cargo_Patrol_V1_F",
	"Land_Cargo_Patrol_V2_F",
	"Land_Cargo_Patrol_V3_F",
	"Land_fortified_nest_big",
	"Land_fortified_nest_big_EP1"
];

SAC_A2_militaryBuildings = ["Land_Barrack2", "Land_Mil_Barracks_i_EP1", "Land_Mil_Barracks_L_EP1", "Land_Mil_Barracks_EP1", "Land_Mil_Repair_center_EP1",
"Land_Mil_House_EP1", "Land_Mil_Guardhouse_EP1"];

SAC_A3_militaryBuildings = ["Land_Research_HQ_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_House_V1_F", "Land_Cargo_House_V3_F", "Land_Cargo_HQ_V3_F", "Land_Medevac_house_V1_F"];

SAC_militaryBuildings = SAC_A2_militaryBuildings + SAC_A3_militaryBuildings + SAC_militaryFortifications;

SAC_fucked_up_buildings = ["Land_Pier_small_F", "Land_Unfinished_Building_01_ruins_F", "Land_Hospital_side2_F", "Land_Stadium_p5_F", "Land_Stadium_p4_F",
"Land_CarService_F", "Land_Hospital_main_F", "Land_CarService_F", "Land_Hospital_side1_F", "Land_Bridge_01_PathLod_F", "Land_dp_bigTank_F",
"Land_Stadium_p9_F", "Land_spp_Tower_F", "Land_Hangar_F", "Land_LightHouse_F", "Land_Airport_Tower_F", "Land_Radar_F", "Land_water_tank", "Land_Vez", "Land_Pier_F",
"Land_i_Addon_04_V1_F", "Land_i_Addon_03_V1_F", "Land_u_Shed_Ind_F", "Land_i_Garage_V2_F", "Land_Chapel_V1_F", "Land_Bridge_Concrete_PathLod_F",
"Land_Bridge_HighWay_PathLod_F", "Land_Metal_Shed_F", "Land_Addon_04_V1_ruins_F", "Land_Bridge_Asphalt_PathLod_F", "Land_d_Stone_HouseSmall_V1_F", "Land_Shed_03_F",
"Land_House_L_3_ruins_EP1", "Land_House_L_7_ruins_EP1", "Land_House_L_8_ruins_EP1", "Land_Shed_02_F",
"Land_PierWooden_01_10m_noRails_F", "Land_PierWooden_02_16m_F", "Land_PierWooden_01_16m_F", "Land_PierWooden_01_dock_F",
"Land_FireEscape_01_tall_F", "Land_HaulTruck_01_abandoned_F", "Land_MiningShovel_01_abandoned_F", "Land_FireEscape_01_short_F",
"Land_Vysilac_FM", "Land_Molo_drevo_bs", "Land_DeerStand_01_F", "Land_SCF_01_heap_bagasse_F", "Land_A_Crane_02a"];

SAC_buildingsInDB = [

"Land_i_Barracks_V1_F",
"Land_GH_MainBuilding_middle_F",
"Land_GH_MainBuilding_left_F",
"Land_GH_MainBuilding_right_F",
"Land_GH_Gazebo_F",
"Land_GH_House_1_F",
"Land_Airport_left_F",
"Land_Airport_right_F",
"Land_Cargo_HQ_V1_F",
"Land_Cargo_HQ_V3_F",
"Land_Cargo_Tower_V3_F",
"Land_Factory_Main_F",
"Land_i_House_Big_01_V2_F",
"Land_MilOffices_V1_F",
"Land_i_House_Big_01_V1_F",
"Land_Cargo_Tower_V1_F",
"Land_Research_HQ_F",
"Land_u_Barracks_V2_F",
"Land_i_House_Big_01_V3_F",
"Land_u_House_Big_02_V1_F",
"Land_i_House_Big_02_V3_F",
"Land_d_House_Big_02_V1_F",
"Land_d_Shop_01_V1_F",
"Land_WIP_F",
"Land_i_Shop_02_V1_F",
"Land_i_Shop_01_V1_F",
"Land_i_House_Big_02_V2_F",
"Land_Unfinished_Building_02_F",
"Land_u_Shop_01_V1_F",
"Land_i_Shop_01_V3_F",
"Land_i_Shop_02_V3_F",
"Land_u_House_Big_01_V1_F",
"Land_i_House_Big_02_V1_F",
"Land_i_Shop_01_V2_F",
"Land_u_Shop_02_V1_F",
"Land_Unfinished_Building_01_F",
"Land_i_Shop_02_V2_F",
"Land_i_Barracks_V2_F",
"Land_i_Shed_Ind_F",
"Land_d_Stone_HouseBig_V1_F",
"Land_i_Stone_HouseBig_V3_F",
"Land_i_Stone_HouseBig_V1_F",
"Land_i_Stone_HouseBig_V2_F",
"Land_i_Stone_HouseSmall_V2_F",
"Land_i_Stone_HouseSmall_V1_F",
"Land_i_Stone_HouseSmall_V3_F",
"Land_u_House_Small_02_V1_F",
"Land_i_House_Small_02_V3_F",
"Land_i_House_Small_03_V1_F",
"Land_d_House_Small_02_V1_F",
"Land_i_House_Small_02_V2_F",
"Land_i_House_Small_02_V1_F",

"Land_House_Big_02_F",
"Land_Temple_Native_01_F",
"Land_GarageShelter_01_F",
"Land_House_Small_05_F",
"Land_Shed_02_F",
"Land_House_Small_04_F",
"Land_House_Small_06_F",
"Land_House_Small_01_F",
"Land_House_Small_02_F",
"Land_Shop_Town_01_F",
"Land_Shop_Town_03_F",
"Land_Supermarket_01_F",
"Land_Slum_03_F",
"Land_House_Big_01_F",
"Land_Addon_04_F",
"Land_House_Big_03_F",
"Land_Hotel_02_F",
"Land_PillboxBunker_01_hex_F",
"Land_Barracks_01_camo_F",
"Land_GuardHouse_01_F",
"Land_PillboxBunker_01_big_F",
"Land_Hotel_01_F",
"Land_House_Big_04_F",
"Land_FuelStation_01_shop_F",
"Land_Warehouse_03_F",
"Land_School_01_F",
"Land_Shed_05_F",
"Land_House_Small_03_F",
"Land_House_Native_01_F",
"Land_Slum_02_F",
"Land_House_Native_02_F",
"Land_Slum_01_F",
"Land_SCF_01_diffuser_F",
"Land_SM_01_shed_unfinished_F",
"Land_SM_01_shed_F"

];

SAC_buildingPosDB = [

["Land_i_Barracks_V1_F", [[-11.082,2.87695,0.60552],[-9.07813,-2.72168,0.60552],[-4.13281,2.81934,0.60552],[6.23047,-2.84375,0.60552],[4.01563,2.99609,0.60552],
[12.7578,2.85449,0.60552],[10.6992,-2.6875,0.60552],[-11.6484,2.94824,3.9395],[-9.125,-2.78809,3.9395],[-3.40625,2.96875,3.9395],[5.94531,-2.87012,3.9395],
[4.11328,2.94434,3.9395],[12.6719,2.92285,3.9395],[11.1563,-2.78516,3.9395]]],

["Land_GH_MainBuilding_middle_F", [[1.24805,4.76172,-8.35117]]],

["Land_GH_MainBuilding_left_F", [[-7.4248,6.91406,-5.48278],[-1.57227,7.93945,-5.48278],[11.0166,11.9512,-5.48278],[-7.40137,-10.0176,-1.04552],
[5.13574,-6.24414,-1.04262],[-6.21484,2.5957,-1.04264],[-1.02246,3.58398,-1.04264],[12.1602,7.30273,-1.04264],[13.3145,2.73633,3.40288],[8.03125,1.43555,3.40288],
[0.182617,-0.873047,3.40288],[-5.31445,-2.125,3.40288]]],

["Land_GH_MainBuilding_right_F", [[7.87402,6.64453,-5.48278],[2.2334,8.42969,-5.48278],[-10.8379,11.7656,-5.48278],[-11.7646,7.25781,-1.04264],
[-6.86133,5.7168,-1.04264],[1.20508,3.72656,-1.04264],[6.81934,2.76172,-1.04264],[-0.918945,-7.45703,-1.04261],[5.6709,-1.77734,3.40288],[-0.332031,-0.6875,3.40288],
[-8.11816,1.16797,3.40288],[-12.8906,3.02148,3.40288]]],

["Land_GH_Gazebo_F", [[-4.41211,0.759766,-1.73972]]],

["Land_GH_House_1_F", [[-2.37402,-4.58594,1.40028],[2.47461,-4.73633,1.40025],[-2.44922,-4.94727,-2.09973],[2.46582,-5.08203,-2.09973]]],

 ["Land_Airport_left_F", [[-1.04492,-8.63281,-1.73733],[-1.23633,1.07324,-1.73733],[0.160156,1.39551,-1.73733],[1.14258,-8.50977,-1.73733]]],

["Land_Cargo_HQ_V1_F", [[4.875,2.31055,-3.27229],[-1.66504,1.3457,-3.27229]]],

["Land_Cargo_HQ_V3_F", [[-1.51367,1.76172,-3.27229],[4.66309,2.35938,-3.27229]]],

["Land_Cargo_Tower_V3_F", [[-2.91895,-1.84668,2.47989]]],

["Land_Factory_Main_F", [[-8.69727,12.7754,-6.30167],[-3.70703,6.12598,-6.33168],[-1.75781,-12.4551,2.36833]]],

["Land_i_House_Big_01_V2_F", [[1.69922,-5.23633,0.855064],[2.4585,5.41211,0.855064]]],

["Land_MilOffices_V1_F", [[8.77148,-1.62939,-2.86676],[8.59668,-4.52588,-2.86676],[14.4355,7.57861,-2.86676],[2.9707,8.73047,-2.86676],[-4.6084,8.79004,-2.86676],
[-8.78516,8.72168,-2.86676],[-15.2354,3.17188,-2.86676],[-15.0205,-3.36328,-2.86676],[-11.4863,-4.42188,-2.86676],[-7.76855,-3.04443,-2.86676],
[-3.51172,-3.10547,-2.86676]]],

["Land_i_House_Big_01_V1_F", [[2.11133,-5.19238,0.855064],[2.0918,5.30762,0.855063]]],

["Land_Cargo_Tower_V1_F", [[-2.8916,-2.29565,2.47988]]],

["Land_Research_HQ_F", [[4.38672,1.83984,-3.26622]]],

["Land_u_Barracks_V2_F", [[2.22949,-1.79297,-1.81228],[1.04102,4.00488,-1.81228],[7.55078,-1.76074,-1.81228],[-12.835,-1.91113,-1.81228],[-12.9834,-1.80371,1.52171],
[-6.62891,3.94824,1.52171],[2.3418,-1.79102,1.52171],[1.13672,3.90039,1.52171],[9.08594,3.95508,1.52171],[7.09375,-1.73926,1.52171]]],

["Land_i_House_Big_01_V3_F", [[1.95996,-5.11206,0.855064],[2.17188,5.32275,0.855068]]],

["Land_u_House_Big_02_V1_F", [[2.00977,2.39551,0.96582]]],

["Land_i_House_Big_02_V3_F", [[2.42822,2.14551,0.78406]]],

["Land_d_House_Big_02_V1_F", [[0.607422,2.30005,0.490025]]],

["Land_d_Shop_01_V1_F", [[1.69263,-1.70313,0.990793]]],

["Land_WIP_F", [[-15.6504,-2.84033,4.32572],[-15.4424,8.87842,4.32572],[-9.91406,9.15186,4.32572],[-3.58789,9.30176,4.32572],[8.16309,-8.79492,4.32446],
[-3.87988,-8.80859,4.3239],[-4.09375,0.832031,8.35863],[-9.09961,-14.3809,12.3244]]],

["Land_i_Shop_02_V1_F", [[-1.28906,-2.18652,1.23859]]],

["Land_i_Shop_01_V1_F", [[-0.744141,0.719238,1.10933]]],

["Land_i_House_Big_02_V2_F", [[2.19629,2.44336,0.784062]]],

["Land_Unfinished_Building_02_F", [[-5.86523,0.355469,0.976165]]],

["Land_u_Shop_01_V1_F", [[-0.626953,0.279297,0.990211]]],

["Land_i_Shop_01_V3_F", [[-0.535156,0.408203,1.10943]]],

["Land_i_Shop_02_V3_F", [[-0.495117,-0.119141,1.23859]]],

["Land_u_House_Big_01_V1_F", [[2.02344,5.17822,0.855064],[2.45215,-5.09912,0.855066]]],

["Land_i_House_Big_02_V1_F", [[2.35156,2.52051,0.784063]]],

["Land_i_Shop_01_V2_F", [[-0.671875,0.0429688,1.10944]]],

["Land_u_Shop_02_V1_F", [[-0.0576172,-0.62793,1.23859]]],

["Land_Unfinished_Building_01_F", [[-1.43311,3.57129,1.19791]]],

["Land_i_Shop_02_V2_F", [[-0.169922,-0.534912,1.23859]]],

["Land_i_Barracks_V2_F", [[-11.1719,3.08301,0.60552],[-9.09131,-2.88477,0.60552],[5.9043,-2.80859,0.60552],[4.1792,2.90234,0.60552],[10.9238,-2.72852,0.605519],
[-11.4375,2.98047,3.9395],[-9.15576,-2.86719,3.9395],[-3.47559,3.04688,3.9395],[6.20508,-2.91699,3.9395],[4.53516,2.96289,3.9395],[12.6943,2.90332,3.9395],
[10.7764,-2.79785,3.9395]]],

["Land_i_Shed_Ind_F", [[1.45605,3.06348,-1.40977],[8.95508,2.83008,-1.40977]]],

["Land_d_Stone_HouseBig_V1_F", [[-1.07764,-1.13086,1.21893]]],

["Land_i_Stone_HouseBig_V3_F", [[0.766113,0.96875,1.21892]]],

["Land_i_Stone_HouseBig_V1_F", [[0.4375,1.10657,1.21893]]],

["Land_i_Stone_HouseBig_V2_F", [[0.564453,0.970703,1.21892]]],

["Land_i_Stone_HouseSmall_V2_F", [[-3.59326,2.10938,-0.628708], [4.50684,2.27734,-0.606003]]],

["Land_i_Stone_HouseSmall_V1_F", [[-3.5791,2.12305,-0.6285],[3.68555,2.65625,-0.609655]]],

["Land_i_Stone_HouseSmall_V3_F", [[4.06543,2.39453,-0.607948],[-4.03711,2.06641,-0.629333]]],

["Land_u_House_Small_02_V1_F", [[4.46387,-0.441406,-0.712719]]],

["Land_i_House_Small_02_V3_F", [[4.42041,-0.0625,-0.702557]]],

["Land_i_House_Small_03_V1_F", [[3.89233,-3.29395,-0.371632],[-4.10449,1.94336,-0.371632],[0.409424,2.88086,-0.371632]]],

["Land_d_House_Small_02_V1_F", [[5.14258,0.268555,-0.965181]]],

["Land_i_House_Small_02_V2_F", [[4.75562,-0.394531,-0.702129]]],

["Land_i_House_Small_02_V1_F", [[4.41406,-0.438477,-0.702568]]],



["Land_House_Big_02_F", [[-7.31494,1.1438,-1.44146]]],

["Land_Temple_Native_01_F", [[-1.96533,2.38525,-5.95314]]],

["Land_GarageShelter_01_F", [[-2.54102,0.789551,-1.25335]]],

["Land_House_Small_05_F", [[-0.920898,2.09546,-1.08537]]],

["Land_Shed_02_F", [[0.173828,0.740234,-0.8443]]],

["Land_House_Small_04_F", [[0.550781,-1.91309,-0.864767]]],

["Land_House_Small_06_F", [[-0.857422,-1.51514,-1.00068]]],

["Land_House_Small_01_F", [[-2.86865,-0.171387,-0.699362]]],

["Land_i_Shed_Ind_F", [[4.53223,3.9375,-1.40977]]],

["Land_House_Small_02_F", [[-1.78906,-3.47217,-0.714202]]],

["Land_Shop_Town_01_F", [[-2.5625,-0.921387,-3.24367]]],

["Land_Shop_Town_03_F", [[4.91846,4.87598,-3.35822]]],

["Land_Supermarket_01_F", [[2.90918,11.3799,-1.4792]]],

["Land_Slum_03_F", [[-2.16309,5.44897,-0.648015]]],

["Land_House_Big_01_F", [[3.60889,2.87549,-1.01143]]],

["Land_Addon_04_F", [[-1.87891,-5.02295,0.334781]]],

["Land_House_Big_03_F", [[4.07275,-2.10156,-0.0890989]]],

["Land_Hotel_02_F", [[3.26318,0.89209,0.227445]]],

["Land_PillboxBunker_01_hex_F", [[-2.47833,-1.1123,-0.94185]]],

["Land_Barracks_01_camo_F", [[-3.35156,2.61523,3.9395]]],

["Land_GuardHouse_01_F", [[-0.21582,-2.021,-1.00598]]],

["Land_u_Shed_Ind_F", [[-6.69141,0.512695,-1.40862]]],

["Land_PillboxBunker_01_big_F", [[-3.31323,4.35059,-0.796555]]],

["Land_Hotel_01_F", [[-4.4375,4.51318,-5.28577]]],

["Land_House_Big_04_F", [[-3.51367,2.66602,0.302855]]],

["Land_FuelStation_01_shop_F", [[-0.774414,3.33777,-2.01158]]],

["Land_Warehouse_03_F", [[6.1709,3.08496,-2.36326]]],

["Land_School_01_F", [[-1.37109,-0.108398,-1.24651]]],

["Land_Shed_05_F", [[0.871094,-0.705444,-0.889054]]],

["Land_House_Small_03_F", [[-4.61523,-0.095459,-1.32258]]],

["Land_House_Native_01_F", [[0.000976563,0.162842,-3.10103]]],

["Land_Slum_02_F", [[0.0722656,2.47827,0.184655]]],

["Land_House_Native_02_F", [[-1.4209,-0.15918,-2.41487]]],

["Land_Slum_01_F", [[3.52637,0.0429077,0.669953]]],

["Land_SCF_01_diffuser_F", [[2.76758,-15.9141,4.55216]]],

["Land_SM_01_shed_unfinished_F", [[-6.82813,0.804688,-1.61566]]],

["Land_SM_01_shed_F", [[5.34766,3.81885,-1.56777]]],

["Land_Offices_01_V1_F", [[5.82617,2.37207,4.66545]]]

];

SAC_buildingPosDB_for_units = [

["Land_Offices_01_V1_F", [[11.0347,-1.16016,-7.05899], [-0.915039,-5.5791,-7.05899], [3.84326,2.8584,-7.05899], [10.3809,3.55176,-7.05899],
[-4.87354,6.32715,-7.05899], [-15.3906,6.40332,-7.05899], [5.98193,-5.50098,-3.15961], [5.12646,2.3457,-3.16037], [-0.675293,2.5166,-3.16324],
[6.4707,-4.62109,0.829345], [2.9668,2.30078,0.837401], [4.16211,-1.88086,4.66438], [10.6685,-5.62305,4.66541], [11.8379,-1.66211,4.66569],
[5.62109,2.49268,4.66547]]],
["Land_Jbad_Mil_House", [[-1.47119,-6.23828,-5.01463], [8.70557,3.63672,-5.01463], [2.68115,2.24219,-5.01463], [3.02246,-6.38867,-5.01462],
[14.1592,-1.60645,-5.01463], [-10.2065,3.80078,-5.01462], [-12.96,-4.70215,-5.01462], [-9.06738,-5.5752,-5.01463], [-6.6084,3.02832,-5.01463],
[-1.04883,3.38184,-0.683563], [-9.49512,3.50684,-0.696548], [-13.8472,1.42578,-0.696548], [-9.86426,-0.766602,-0.696548], [-9.07861,-6.00293,-0.696556],
[-13.2603,-5.35742,-0.696548]]],
["Land_Cargo_Patrol_V1_F", [[-1.38721,-1.00366,-0.559521], [1.62695,-1.10571,-0.559521], [-1.95361,1.3645,-0.763517], [2.26904,1.28809,-0.763517]]],
["Land_Cargo_Patrol_V2_F", [[-1.38721,-1.00366,-0.559521], [1.62695,-1.10571,-0.559521], [-1.95361,1.3645,-0.763517], [2.26904,1.28809,-0.763517]]],
["Land_Cargo_Patrol_V3_F", [[-1.38721,-1.00366,-0.559521], [1.62695,-1.10571,-0.559521], [-1.95361,1.3645,-0.763517], [2.26904,1.28809,-0.763517]]],
["Land_Cargo_Patrol_V4_F", [[-1.38721,-1.00366,-0.559521], [1.62695,-1.10571,-0.559521], [-1.95361,1.3645,-0.763517], [2.26904,1.28809,-0.763517]]],
["Land_d_House_Big_01_V1_F",[[-4.67383,6.4043,-2.17078],[-4.2168,9.63379,-2.17079],[-2.5332,10.4121,-2.17079],[-0.501953,8.71631,-2.17078],
[4.4043,9.93164,-2.59315],[1.96484,2.73193,-2.17079],[-4.74805,-1.6001,-2.26079],[-4.68555,2.65918,-2.2608],[2.10938,6.33838,-0.510796],
[-1.91992,6.26855,1.24922],[0.537109,4.63428,1.24921],[2.21094,2.18311,1.39871],[2.38477,0.0517578,1.24921],[-1.38672,0.163086,1.24921],
[-4.93164,4.98779,1.24921],[-4.74609,10.1484,1.24921],[2.0332,8.81396,1.24921]]]
];

if (isNil "SAC_DefaultMapClick") then {SAC_DefaultMapClick = ""};
if (isNil "SAC_onMapSingleClick_Available") then {SAC_onMapSingleClick_Available = true};

SAC_mapCoordinates = [0,0,0];

if !("SAC_MAP_CENTER" in allMapMarkers) then {

	if (hasInterface) then {hintC "SAC_FNC: Falta el marcador 'SAC_MAP_CENTER'"};
	
};

switch (toLower(worldName)) do
{
	case "village_normandy";
	case "beketov";
	case "utes";
	case "chernarus_winter";
	case "chernarus_summer";
	case "woodland_acr";
	case "pja314";
	case "eden";
	case "cup_chernarus_a3";
	case "ruha";
	case "chernarus": {

		SAC_songs = SAC_sovietSongs;

		SAC_militaryBases = [];
		_count = 1;
		while {getMarkerColor format ["sac_mil_%1", _count] != ""} do {

			SAC_militaryBases pushBack (getMarkerPos format ["sac_mil_%1", _count]);
			_count = _count + 1;
		};

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage"], 50000];

	};
	case "tem_anizay";
	case "dya"; //Diyala
	case "praa_av";
	case "fata";
	case "fallujah";
	case "mcm_aliabad";
	case "zargabad";
	case "kunduz";
	case "lythium";
	case "uzbin";
	case "kidal";
	case "takistan": {

		SAC_songs = SAC_arabicSongs;

		// SAC_militaryBases = [[5130.27,6068.59,-0.00505066],[5050.22,6846.15,0.10498],[4578.36,9467.14,-0.0421906],[10400.2,6423.47,-0.19722],
		// [2613.61,5087.29,-0.169556],[6014.67,10415.8,-0.00012207],[8205.85,2139.33,-0.0426025],[9317.01,10061.1,-0.0246582],[5854.38,11248.3,-0.0512543],
		// [6092.37,11479.4,-0.0533829],[7147.84,1042.88,-0.0183411],[5944.75,11750.7,0]];

		SAC_militaryBases = [];
		_count = 1;
		while {getMarkerColor format ["sac_mil_%1", _count] != ""} do {

			SAC_militaryBases pushBack (getMarkerPos format ["sac_mil_%1", _count]);
			_count = _count + 1;
		};

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage"], 50000];

	};
	case "smd_sahrani_a3";
	case "sahrani";
	case "sara";
	case "sara_dbe1";
	case "sehreno";
	case "smd_sahrani_a2": {

		SAC_songs = SAC_reggaeSongs;

		SAC_militaryBases = [];
		_count = 1;
		while {getMarkerColor format ["sac_mil_%1", _count] != ""} do {

			SAC_militaryBases pushBack (getMarkerPos format ["sac_mil_%1", _count]);
			_count = _count + 1;
		};

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage"], 50000];

	};
	case "tembelan";
	case "stratis";
	case "malden";
	case "altis": {

		SAC_songs = SAC_cumbias;

		SAC_militaryBases = [[15435.3,15826,-0.269979],[14149.8,16271.9,0.00455284],[15999.2,16931.1,0.00225449],[15158.4,17350.4,-0.000289917],[16000.7,17096.8,-0.00918961],
		[14313.4,13041.3,-0.0434153],[12817.5,16652.1,-0.165672],[17412.2,13183.2,0.00621223],[16650.6,12277,0.0518823],[16789.7,12115.6,-0.016953],[13821.5,18958.2,-0.0167427],
		[16585.7,19007.8,-0.081398],[14215.3,21222.1,-0.0545502],[20436.8,18771.1,-0.0353394],[20579.9,18811.6,-0.0111198],[9967.54,19367.7,-0.00375366],[10013.4,11228.5,-0.0830269],
		[21014.1,19074.1,-0.00108719],[20994.4,19197,0],[12301.9,8880.05,-0.0779343],[8370.97,18248.3,-0.0607452],[8315.73,10056.1,-0.129707],[20077.6,6725.71,0.00775146],
		[5239.49,14199.1,0.0175819],[23527.5,21160.2,-0.106293],[23670.9,21048.2,0.0470963]];

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage"], 50000];

	};
	case "vt7";
	case "hellanmaa";
	case "wl_rosche";
	case "enoch": {

		SAC_songs = SAC_sovietSongs;

		SAC_militaryBases = [[15435.3,15826,-0.269979],[14149.8,16271.9,0.00455284],[15999.2,16931.1,0.00225449],[15158.4,17350.4,-0.000289917],[16000.7,17096.8,-0.00918961],
		[14313.4,13041.3,-0.0434153],[12817.5,16652.1,-0.165672],[17412.2,13183.2,0.00621223],[16650.6,12277,0.0518823],[16789.7,12115.6,-0.016953],[13821.5,18958.2,-0.0167427],
		[16585.7,19007.8,-0.081398],[14215.3,21222.1,-0.0545502],[20436.8,18771.1,-0.0353394],[20579.9,18811.6,-0.0111198],[9967.54,19367.7,-0.00375366],[10013.4,11228.5,-0.0830269],
		[21014.1,19074.1,-0.00108719],[20994.4,19197,0],[12301.9,8880.05,-0.0779343],[8370.97,18248.3,-0.0607452],[8315.73,10056.1,-0.129707],[20077.6,6725.71,0.00775146],
		[5239.49,14199.1,0.0175819],[23527.5,21160.2,-0.106293],[23670.9,21048.2,0.0470963]];

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage"], 50000];

	};
	case "jnd_dakpek_terrain";
	case "rhspkl";
	case "dakrong";
	case "jnd_balong";
	case "tanoa": {

		SAC_songs = SAC_cumbias;

		SAC_militaryBases = [];
		_count = 1;
		while {getMarkerColor format ["sac_mil_%1", _count] != ""} do {

			SAC_militaryBases pushBack (getMarkerPos format ["sac_mil_%1", _count]);
			_count = _count + 1;
		};

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage"], 50000];

	};
	case "panthera3": {

		SAC_songs = SAC_reggaeSongs;

		SAC_militaryBases = [];
		_count = 1;
		while {getMarkerColor format ["sac_mil_%1", _count] != ""} do {

			SAC_militaryBases pushBack (getMarkerPos format ["sac_mil_%1", _count]);
			_count = _count + 1;
		};

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage"], 50000];

	};
	case "abramia": {

		SAC_songs = SAC_reggaeSongs;

		SAC_militaryBases = [];
		_count = 1;
		while {getMarkerColor format ["sac_mil_%1", _count] != ""} do {

			SAC_militaryBases pushBack (getMarkerPos format ["sac_mil_%1", _count]);
			_count = _count + 1;
		};

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage"], 50000];

	};
	case "bornholm": {

		SAC_songs = [];

		SAC_militaryBases = [];
		_count = 1;
		while {getMarkerColor format ["sac_mil_%1", _count] != ""} do {

			SAC_militaryBases pushBack (getMarkerPos format ["sac_mil_%1", _count]);
			_count = _count + 1;
		};

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage", "NameLocal"], 50000];

	};
	case "pja305": {

		SAC_songs = SAC_sovietSongs;

		SAC_militaryBases = [];
		_count = 1;
		while {getMarkerColor format ["sac_mil_%1", _count] != ""} do {

			SAC_militaryBases pushBack (getMarkerPos format ["sac_mil_%1", _count]);
			_count = _count + 1;
		};

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage", "NameLocal"], 50000];

	};
	case "swu_public_rhode_map"; //mutambara
	case "isladuala3": {

		SAC_songs = SAC_reggaeSongs;

		SAC_militaryBases = [];
		_count = 1;
		while {getMarkerColor format ["sac_mil_%1", _count] != ""} do {

			SAC_militaryBases pushBack (getMarkerPos format ["sac_mil_%1", _count]);
			_count = _count + 1;
		};

		SAC_locations = nearestLocations [getMarkerPos "SAC_MAP_CENTER", ["NameCityCapital", "NameCity", "NameVillage"], 50000];

		private ["_badLocationNames", "_badLocations"];

		_badLocationNames = ["Hazena Vulcano"];
		_badLocations = [];
		{
			if (text _x in _badLocationNames) then {_badLocations pushBack _x};
		} forEach SAC_locations;

		SAC_locations = SAC_locations - _badLocations;

	};
	case default {
	
		SAC_songs = [];
		
		systemChat ("SAC_functions: " + worldName);
		diag_log ("SAC_functions: " + worldName);
	};
};

SAC_green_zones = [];
{

	if (toUpper(markerText _x) == "SAC_GREEN_ZONE") then {SAC_green_zones pushBackUnique _x};

} forEach allMapMarkers;

SAC_no_cts_spawn_zones = [];
{

	if (toUpper(markerText _x) == "SAC_NO_CTS_SPAWN") then {SAC_no_cts_spawn_zones pushBackUnique _x};

} forEach allMapMarkers;

SAC_no_mts_spawn_zones = [];
{

	if (toUpper(markerText _x) == "SAC_NO_MTS_SPAWN") then {SAC_no_mts_spawn_zones pushBackUnique _x};

} forEach allMapMarkers;

SAC_no_tac_zones = [];
{

	if (toUpper(markerText _x) == "SAC_NO_TAC_ZONE") then {SAC_no_tac_zones pushBackUnique _x};

} forEach allMapMarkers;

SAC_cts_green_zones = [];
{

	if (toUpper(markerText _x) == "SAC_CTS_GREEN_ZONE") then {SAC_cts_green_zones pushBackUnique _x};

} forEach allMapMarkers;

SAC_boats_blacklists = [];
{

	if ((markerText _x == "SAC_NO_BOATS") || {_x == "SAC_no_boats"}) then {_x setMarkerAlpha 0; SAC_boats_blacklists pushBackUnique _x};

} forEach allMapMarkers;

if (isNil "PVEH_netSay3D") then {
    PVEH_NetSay3D = [objNull,0];
};

"PVEH_netSay3D" addPublicVariableEventHandler {
      private["_array"];
      _array = _this select 1;
     (_array select 0) say3D [(_array select 1),(_array select 2)];
};

SAC_fnc_MPsystemChat = {

	params ["_message"];

	[_message] remoteExec ["systemChat", [0, -2] select isDedicated, false]; 

	diag_log _message;

};

SAC_fnc_MPhintC = {

	params ["_message"];

	[_message] remoteExec ["hintC", [0, -2] select isDedicated, false]; 

	diag_log _message;

};

SAC_fnc_MPhint = {

	params ["_message"];

	[_message] remoteExec ["hint", [0, -2] select isDedicated, false];

	diag_log _message;

};

SAC_fnc_titleText = {

	params ["_text"];
	
	titleText [format ["<t color='#9EFAFF' size='2'>%1</t>", _text], "PLAIN", -1, true, true];

};

SAC_fnc_MPtitleText = {

	params ["_text"];
	
	[[format ["<t color='#9EFAFF' size='2'>%1</t>", _text], "PLAIN", -1, true, true]] remoteExec ["titleText", [0, -2] select isDedicated, false];
	
	diag_log _text;
	
};

//init master building array
SAC_fnc_initializeMasterBuildingArray = {

	private _allBuildings = (getMarkerPos "SAC_MAP_CENTER") nearObjects ["House", 50000];

	private _masterBuildingArray = [];
	private _bannedTypes = SAC_fucked_up_buildings + ["Land_Unfinished_Building_02_F", "Land_Misc_deerstand", "Land_Ind_TankBig"];
	_building = objNull;

	{
		
		_building = _x;
		
		if !(typeOf _building in _bannedTypes) then {

			if (count (_building call SAC_fnc_buildingPos) >= 2) then {

				_masterBuildingArray pushBack _building;

			};
		};

	} foreach _allBuildings;
	
	SAC_masterArrayBuilding = _masterBuildingArray;

};

SAC_fnc_getMagazines = {

	// return array with all compatible mags for a weapon's main muzzle
	// por ej. 
	//[["rhs_30Rnd_762x39mm","rhs_30Rnd_762x39mm_tracer"],["rhs_VOG25","rhs_VOG25p","rhs_vg40tb","rhs_vg40sz]]


	private ["_w"];
	
	_w = if ((_this select 0) isEqualType "") then {_this select 0} else {typeOf (_this select 0)};
	
	private _compat = [];
	private "_mags";

	private "_magsForThisMuzzle";
	
	{ // for each weapon muzzle
		
		_magsForThisMuzzle = [];
		
		//diag_log _x;
	
		if (toLower _x == "this") then {
			_mags = getArray(configFile >> "CfgWeapons" >> _w >> "magazines");
		} else {
			_mags = getArray(configFile >> "CfgWeapons" >> _w >> _x >> "magazines");
		};
		
		//diag_log _mags;
		
		//la comprobación del slot > 128 hace que no reconozca las granadas del GL rhs_VOG25, que devuelven 16, mientras que el magazine de balas devuelve 256
		//la verdad no tengo idea de como funciona lo del tamaño del slot, pero si robalo puso este control estoy seguro de que por algo sera
		//sin embargo, lo deshabilito por el momento porque necesito que devuelva las GL de las armas.
		/*
		{ // for each magazine type, check slot size
			if (getNumber(configFile >> "CfgMagazines" >> _x >> "type") > 128) then {_magsForThisMuzzle pushBackUnique _x};
		} forEach _mags;
		*/
		_magsForThisMuzzle = _mags;
		
		if (count _magsForThisMuzzle > 0) then {_compat pushBack _magsForThisMuzzle};
		
	} forEach getArray(configFile >> "CfgWeapons" >> _w >> "muzzles");

	//diag_log _compat;
	
	_compat
	
};

SAC_fnc_findBuilding = {
/*
	IMPORTANTE: En mapas con muchos edificios como Altis, esta rutina puede ser bastante pesada, sobre todo con _maxDistance > 500. El código fué
	optimizado varias veces y sólo se lo puede hacer más rápido dejando de usar BIS_fnc_nearestPosition, y haciendo parte de la búsqueda de la posición
	más cercana, las otras comprobaciones, es decir, no considerar un edificio como más cercano al anterior si no cumple todas las demás reglas.
	Por ahora prefiero dejarlo así.
*/
	private ["_centralPos", "_minDistance", "_maxDistance", "_allBuildings", "_inRangeBuildings", "_goodBuildings",
	"_buildingPositions", "_cnt", "_pos", "_building", "_minPositions", "_bannedTypes", "_method", "_noplayerDistance", "_blacklist",
	"_buildingPos", "_empty", "_valid", "_smallestBuildingPositions", "_isolated", "_useProvidedArray"];

	_centralPos = _this select 0;
	_minDistance = _this select 1;
	_maxDistance = _this select 2;
	_minPositions = _this select 3;
	_bannedTypes = _this select 4;
	_noplayerDistance = _this select 5; //pasar 999 para deshabilitar la zona de exclusión alrededor de los jugadores
	_blacklist = _this select 6; //un array de áreas indicadas por markers ó triggers
	_buildings = _this select 7; //un array de edificios, opcional.
	_method = if ("closest" in _this) then {"closest"} else {"random"};
	_method = if ("smallest" in _this) then {"smallest"} else {_method};
	_empty = if ("empty" in _this) then {true} else {false};
	_isolated = if ("isolated" in _this) then {true} else {false}; //por ahora solo implementado en el método "random"
	_useProvidedArray = if ("useProvidedArray" in _this) then {true} else {false};

	//["I love this feature."] call BIS_fnc_error;

	if (_useProvidedArray) then {

		_allBuildings = +_buildings;

	} else {

		//si uso "house" no encuentra los arboles sniper del unsung
		//_allBuildings = _centralPos nearObjects ["Building", _maxDistance];
		_allBuildings = _centralPos nearObjects ["Building", _maxDistance];


	};

//systemChat str count _allBuildings;

	_building = objNull;

	if (count _allBuildings > 0) then {

		switch (_method) do {

			case "random": {

				_valid = false;
				
				while {(!_valid) && count _allBuildings > 0} do {

					_building = selectRandom _allBuildings;
					
//[getPos _building, "ColorBlue", ""] call SAC_fnc_createMarker;

					if (_building distance _centralPos >= _minDistance) then {

						if !(typeOf _building in _bannedTypes) then {

							if (count (_building call SAC_fnc_buildingPos) >= _minPositions) then {

								if ([getPos _building, _blacklist] call SAC_fnc_isNotBlacklisted) then {

									if ((_noplayerDistance == 999) || {[_building, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

										if ((!_isolated) || {count (_building nearObjects ["House", 100]) < 5}) then {

											if ((!_empty) || {_building getVariable ["SAC_empty", true]}) then {

												_valid = true;

											};

										};
									};
								};
							};
						};
					};
					
					if (!_valid) then {
						_allBuildings = _allBuildings - [_building];
						_building = objNull;
					};

					//sleep 0.3;
					//(str count _allBuildings) call SAC_fnc_MPsystemChat;
					
//systemChat format["%1 - %2",_valid, count _allBuildings];

				};

			};

			case "closest": {

				_inRangeBuildings = [];
				_inRangeBuildings = _allBuildings select {_x distance _centralPos > _minDistance};

				while {(isNull _building) && count _inRangeBuildings > 0} do {

					_building = [_inRangeBuildings, _centralPos] call BIS_fnc_nearestPosition;
					
//[getPos _building, "ColorBlue", ""] call SAC_fnc_createMarker;

					_valid = false;

					if (_building distance _centralPos >= _minDistance) then {

						if !(typeOf _building in _bannedTypes) then {

							if (count (_building call SAC_fnc_buildingPos) >= _minPositions) then {

								if ([getPos _building, _blacklist] call SAC_fnc_isNotBlacklisted) then {

									if ((_noplayerDistance == 999) || {[_building, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

										if ((!_empty) || {_building getVariable ["SAC_empty", true]}) then {

											_valid = true;

										};
									};
								};
							};
						};
					};

					if (!_valid) then {
						_inRangeBuildings = _inRangeBuildings - [_building];
						_building = objNull;
					};

					//sleep 0.3;

				};

			};

			case "smallest": {

				_inRangeBuildings = [];
				//_inRangeBuildings = _allBuildings select {_x distance _centralPos > _minDistance};

				_smallestBuildingPositions = 1000;

				{

					_candidateBuilding = _x;

					if (count (_candidateBuilding call SAC_fnc_buildingPos) < _smallestBuildingPositions) then {

						if (_candidateBuilding distance _centralPos >= _minDistance) then {

							if !(typeOf _candidateBuilding in _bannedTypes) then {

								if (count (_candidateBuilding call SAC_fnc_buildingPos) >= _minPositions) then {

									if ([getPos _candidateBuilding, _blacklist] call SAC_fnc_isNotBlacklisted) then {

										if ((_noplayerDistance == 999) || {[_candidateBuilding, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

											if ((!_empty) || {_candidateBuilding getVariable ["SAC_empty", true]}) then {

												_building = _candidateBuilding;
												_smallestBuildingPositions = count (_building call SAC_fnc_buildingPos);

											};
										};
									};
								};
							};
						};
					};

					//sleep 0.3;

				} foreach _inRangeBuildings;

			};
		};
	};

	_building

};


//uso experimental del SAC_masterArrayBuilding
//es muy efectivo para acelerar el inicio de CSAR, pero hay tantos otros usos, que requeriría
//hacer un montón de cambios, que ahora no tengo tiempo de hacer y después probarlos.
//además es mucho más lento para muchos de esos usos.
/*
SAC_fnc_findBuilding = {



	private ["_centralPos", "_minDistance", "_maxDistance", "_allBuildings", "_inRangeBuildings", "_goodBuildings",
	"_buildingPositions", "_cnt", "_pos", "_building", "_minPositions", "_bannedTypes", "_method", "_noplayerDistance", "_blacklist",
	"_buildingPos", "_empty", "_valid", "_smallestBuildingPositions", "_isolated", "_useProvidedArray"];

	_centralPos = _this select 0;
	_minDistance = _this select 1;
	_maxDistance = _this select 2;
	_minPositions = _this select 3;
	_bannedTypes = _this select 4;
	_noplayerDistance = _this select 5; //pasar 999 para deshabilitar la zona de exclusión alrededor de los jugadores
	_blacklist = _this select 6; //un array de áreas indicadas por markers ó triggers
	_buildings = _this select 7; //un array de edificios, opcional.
	_method = if ("closest" in _this) then {"closest"} else {"random"};
	_method = if ("smallest" in _this) then {"smallest"} else {_method};
	_empty = if ("empty" in _this) then {true} else {false};
	_isolated = if ("isolated" in _this) then {true} else {false}; //por ahora solo implementado en el método "random"
	_useProvidedArray = if ("useProvidedArray" in _this) then {true} else {false};

	//["I love this feature."] call BIS_fnc_error;

	if (_useProvidedArray) then {

		_allBuildings = +_buildings;

	} else {

		_allBuildings = +SAC_masterArrayBuilding;

	};

	_building = objNull;

	//if (true) exitWith {_building};

	if (count _allBuildings > 0) then {

		switch (_method) do {

			case "random": {

				_valid = false;
				
				while {(!_valid) && count _allBuildings > 0} do {

					_building = selectRandom _allBuildings;
					
//[getPos _building, "ColorBlue", ""] call SAC_fnc_createMarker;

					if ((_building distance _centralPos < _maxDistance) && {_building distance _centralPos > _minDistance}) then {

//						if !(typeOf _building in _bannedTypes) then {

							if (count (_building call SAC_fnc_buildingPos) >= _minPositions) then {

								if ([getPos _building, _blacklist] call SAC_fnc_isNotBlacklisted) then {

									if ((_noplayerDistance == 999) || {[_building, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

										if ((!_isolated) || {count (_building nearObjects ["House", 100]) < 5}) then {

											if ((!_empty) || {_building getVariable ["SAC_empty", true]}) then {

												_valid = true;

											} else {
											
												_allBuildings = _allBuildings - [_building];
											
											};

										};
									};
								};
							};
//						};
					};

					//sleep 0.3;
					//(str count _allBuildings) call SAC_fnc_MPsystemChat;

				};

			};

			case "closest": {

				_inRangeBuildings = [];
				//_inRangeBuildings = _allBuildings select {_x distance _centralPos > _minDistance};

				while {(isNull _building) && count _allBuildings > 0} do {

					_building = [_allBuildings, _centralPos] call BIS_fnc_nearestPosition;

					_valid = false;

					if ((_building distance _centralPos < _maxDistance) && {_building distance _centralPos > _minDistance}) then {

//						if !(typeOf _building in _bannedTypes) then {

							if (count (_building call SAC_fnc_buildingPos) >= _minPositions) then {

								if ([getPos _building, _blacklist] call SAC_fnc_isNotBlacklisted) then {

									if ((_noplayerDistance == 999) || {[_building, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

										if ((!_empty) || {_building getVariable ["SAC_empty", true]}) then {

											_valid = true;

										};
									};
								};
							};
//						};
					};

					if (!_valid) then {
						_allBuildings = _allBuildings - [_building];
						_building = objNull;
					};

					//sleep 0.3;

				};

			};

			case "smallest": {

				_inRangeBuildings = [];
				//_inRangeBuildings = _allBuildings select {_x distance _centralPos > _minDistance};

				_smallestBuildingPositions = 1000;

				{

					_candidateBuilding = _x;

					if (count (_candidateBuilding call SAC_fnc_buildingPos) < _smallestBuildingPositions) then {

					if ((_candidateBuilding distance _centralPos < _maxDistance) && {_candidateBuilding distance _centralPos > _minDistance}) then {

//							if !(typeOf _candidateBuilding in _bannedTypes) then {

								if (count (_candidateBuilding call SAC_fnc_buildingPos) >= _minPositions) then {

									if ([getPos _candidateBuilding, _blacklist] call SAC_fnc_isNotBlacklisted) then {

										if ((_noplayerDistance == 999) || {[_candidateBuilding, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

											if ((!_empty) || {_candidateBuilding getVariable ["SAC_empty", true]}) then {

												_building = _candidateBuilding;
												_smallestBuildingPositions = count (_building call SAC_fnc_buildingPos);

											};
										};
									};
								};
//							};
						};
					};

					//sleep 0.3;

				} foreach _allBuildings;

			};
		};
	};

	_building

};

*/

//From Larrow on the BIS forums
/*
Just some quick code to see if there is any difference between draw3D and EachFrame and whether or not calculating the bounds on each event makes any difference.

TAG_fnc_addDrawEvent = {
	addMissionEventHandler [ "Draw3D", {
		[ car1, TAG_vehicleBounds, [ 0, 1, 0, 1 ] ] call TAG_fnc_drawLines;
		[ car1, car1 call TAG_fnc_getBounds, [ 1, 0, 0, 1 ] ] call TAG_fnc_drawLines;
	}];
	addMissionEventHandler [ "EachFrame", {
		[ car1, TAG_vehicleBounds, [ 0, 0, 1, 1 ] ] call TAG_fnc_drawLines;
		[ car1, car1 call TAG_fnc_getBounds, [ 1, 1, 1, 1 ] ] call TAG_fnc_drawLines;
	}];
};
*/
/*
TAG_fnc_drawLines = {
	params[ "_vehicle", "_points", "_color" ];
	
	_points params[ "_mins", "_maxs" ];
	_mins params[ "_minX", "_minY", "_minZ" ];
	_maxs params[ "_maxX", "_maxY", "_maxZ" ];
	
	
	drawLine3D[ _vehicle modelToWorldVisual[ _minX, _minY, _minZ ], _vehicle modelToWorldVisual[ _minX, _minY, _maxZ ], _color ];
	drawLine3D[ _vehicle modelToWorldVisual[ _minX, _maxY, _minZ ], _vehicle modelToWorldVisual[ _minX, _maxY, _maxZ ], _color ];
	drawLine3D[ _vehicle modelToWorldVisual[ _maxX, _maxY, _minZ ], _vehicle modelToWorldVisual[ _maxX, _maxY, _maxZ ], _color ];
	drawLine3D[ _vehicle modelToWorldVisual[ _maxX, _minY, _minZ ], _vehicle modelToWorldVisual[ _maxX, _minY, _maxZ ], _color ];
	
	
	drawLine3D[ _vehicle modelToWorldVisual[ _minX, _minY, _minZ ], _vehicle modelToWorldVisual[ _minX, _maxY, _minZ ], _color ];
	drawLine3D[ _vehicle modelToWorldVisual[ _minX, _maxY, _minZ ], _vehicle modelToWorldVisual[ _maxX, _maxY, _minZ ], _color ];
	drawLine3D[ _vehicle modelToWorldVisual[ _maxX, _maxY, _minZ ], _vehicle modelToWorldVisual[ _maxX, _minY, _minZ ], _color ];
	drawLine3D[ _vehicle modelToWorldVisual[ _maxX, _minY, _minZ ], _vehicle modelToWorldVisual[ _minX, _minY, _minZ ], _color ];
	
	
	drawLine3D[ _vehicle modelToWorldVisual[ _minX, _minY, _maxZ ], _vehicle modelToWorldVisual[ _minX, _maxY, _maxZ ], _color ];
	drawLine3D[ _vehicle modelToWorldVisual[ _minX, _maxY, _maxZ ], _vehicle modelToWorldVisual[ _maxX, _maxY, _maxZ ], _color ];
	drawLine3D[ _vehicle modelToWorldVisual[ _maxX, _maxY, _maxZ ], _vehicle modelToWorldVisual[ _maxX, _minY, _maxZ ], _color ];
	drawLine3D[ _vehicle modelToWorldVisual[ _maxX, _minY, _maxZ ], _vehicle modelToWorldVisual[ _minX, _minY, _maxZ ], _color ];
};

TAG_fnc_getBounds = {
	params[ "_vehicle" ];
	
	boundingBoxReal _vehicle;
};
*/
/*

TAG_vehicleBounds = this call TAG_fnc_getBounds;
[] call TAG_fnc_addDrawEvent;

*/

// From pedeathtrian on the BIS Forums.
// returns distance between position _p and closest point suface of _obj's real
// bound box (i.e. closest vertex, edge or point in bb's face).
// returns 0 if inside or exactly on surface
SAC_fnc_distance2Box = {
	params ["_p","_obj"];
	_uPos = _obj worldToModel _p;
	_oBox = boundingBoxReal _obj;
	_pt = [0, 0, 0];
	{
		if (_x < (_oBox select 0 select _forEachIndex)) then {
			_pt set [_forEachIndex, (_oBox select 0 select _forEachIndex) - _x];
		} else {
			if ((_oBox select 1 select _forEachIndex) < _x) then {
				_pt set [_forEachIndex, _x - (_oBox select 1 select _forEachIndex)];
			}
		}
	} forEach _uPos;
	_pt distance [0, 0, 0]
};

SAC_fnc_safePosition = {

	/*
	
	03/04/2022 Por lo que veo, esta función está basada en el anterior uso del segundo parámetro de isFlatEmpty. La verdad
	es que hoy en día está establecido que ese parámetro se debe poner en -1, y no se admite otro valor (ver lo escrito en 
	sac_fnc_findLZ). Sin embargo, hasta donde pude probar, funciona. Lo único que se agregó fue el chequeo de las "bounding
	spheres boxes" de los árboles y los edificios (que ya había agregado a findLZ), y finalmente un nuevo chequeo para evitar
	los cables de tensión (porque en las pruebas se dió con MUCHA frecuencia).
	
	*/


	//Uso:
	//[_centerPos, _minDistance, _posSize, _maxTerrainGradient, _roadAllowed, _noplayerDistance, _maxDistance, _debug, _blacklist, _whitelist] call SAC_fnc_safePosition;

	private ["_centerPos", "_minDistance", "_posSize", "_maxTerrainGradient", "_roadAllowed", "_noplayerDistance", "_maxDistance",
	"_waterMode", "_shoreMode", "_safePos", "_testPos", "_blacklist", "_iteration", "_iter2", "_maxIter2", "_angleToCell", "_checkCellSize",
	"_maxIterations", "_whitelist", "_posTree"];

	scopeName "main";

	_centerPos = _this select 0;
	_minDistance = _this select 1; //************** ATENCION: La función entera tiende a fallar en tanto más grande se haga este parámetro. Tratar de que tienda a cero. *****
	_posSize = _this select 2;
	_maxTerrainGradient = (_this select 3) * (pi / 180); //_maxTerrainGradient = 10 * (pi / 180);
	_roadAllowed = _this select 4;
	_noplayerDistance = _this select 5; //pasar 999 para deshabilitar la zona de exclusión alrededor de los jugadores
	_maxDistance = _this select 6; //sugerido < 1500
	_debug = _this select 7;
	_blacklist = _this select 8; //un array de áreas indicadas por markers ó triggers
	_whitelist = if (count _this > 9) then {_this select 9} else {[]}; //un array de áreas indicadas por markers ó triggers

	_waterMode = 0;
	_shoreMode = false;

	_safePos = [];

	//[_centerPos, "ColorYellow", "", "", [_minDistance, _minDistance], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
	//[_centerPos, "ColorYellow", "", "", [_maxDistance, _maxDistance], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;

	_checkCellSize = 30;

	_iteration = 1;
	_maxIterations = floor ((_maxDistance - _minDistance) / _checkCellSize);
	if (_maxDistance - (_minDistance + (_maxIterations * _checkCellSize)) > _checkCellSize / 2) then {_maxIterations = _maxIterations + 1};
	if (_minDistance == 0) then {_maxIterations = _maxIterations + 1};

	_minDistanceNow = _minDistance;
	while {(count _safePos == 0) && {_iteration <= _maxIterations}} do {

		sleep 1;

		if (_minDistanceNow == 0) then {

			_testPos = _centerPos;

			_minDistanceNow = _minDistanceNow - (_checkCellSize / 2);

			//[_testPos, "ColorRed", ""] call SAC_fnc_createMarker;
			//[_testPos, "ColorBlue", "", "", [(_checkCellSize / 2), (_checkCellSize / 2)], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;

			_testPos = _testPos isFlatEmpty [_posSize / 2, _checkCellSize / 2, _maxTerrainGradient, _posSize, _waterMode, _shoreMode, objNull];

			if (count _testPos > 0) then {

				if ((_noplayerDistance == 999) || {[_testPos, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

					if ((_roadAllowed) || {!isOnRoad _testPos}) then {

						if ((count _blacklist == 0) || ([_testPos, _blacklist] call SAC_fnc_isNotBlacklisted)) then {

							if ((count _whitelist == 0) || ([_testPos, _whitelist] call SAC_fnc_isBlacklisted)) then {

								{
								
									/*
									
									Para chequear si el círculo A intersecta al círculo B, obtener un punto desde el centro de A
									en la dirección de B a la distancia del radio de A, y chequear que la distancia entre ese punto
									y el centro de B, no sea menor que el radio de B. Esto es una simplificación, posible sólo
									porque en este contexto, ya se eliminaron los círculos cuyos centros se encuentren dentro del
									área del círculo a chequear.
									
									*/
								
									_posTree = getPosATL _x;
									_posTree set [2, 0];
									
									if (((_testPos getPos [_posSize / 2, _testPos getDir _posTree]) distance _posTree) < (boundingBox _x) select 2) exitWith {

										_testPos = [];
									
									};

								} forEach (nearestTerrainObjects [_testPos, ["TREE", "SMALL TREE","BUILDING", "HOUSE"], (_posSize / 2) + 50, false]);

								if (count _testPos > 0) then {
								
									{
									
										if ([_testPos, _x] call SAC_fnc_distance2Box <= (_posSize / 2) + 5) exitWith {
										
											_testPos = [];
										
										};

									} forEach (nearestTerrainObjects [_testPos, ["POWER LINES"], (_posSize / 2) + 150, false]);

									if (_testPos isNotEqualTo []) then {

										_safePos = _testPos;
										breakTo "main";
									
									};
									
								};

							};

						};

					};

				};

			};

		} else {

			_iter2 = 1;
			_maxIter2 = (pi * (_minDistanceNow + (_checkCellSize / 2)) * 2) / _checkCellSize;
			_angleToCell = round random 360;

			//[_centerPos, "ColorBlack", "", "", [_minDistanceNow + (_checkCellSize / 2), _minDistanceNow + (_checkCellSize / 2)], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;

			while {(count _safePos == 0) && {_iter2 <= _maxIter2 + 1}} do { //es +1 para compensar por el resto de la division

				_testPos = _centerPos getPos [_minDistanceNow + (_checkCellSize / 2), _angleToCell];

				//[_testPos, "ColorRed", ""] call SAC_fnc_createMarker;
				//[_testPos, "ColorGreen", "", "", [(_checkCellSize / 2), (_checkCellSize / 2)], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;

				_testPos = _testPos isflatempty [_posSize / 2, _checkCellSize / 2, _maxTerrainGradient, _posSize, _waterMode, _shoreMode, objNull];

				if (count _testPos > 0) then {

					if ((_noplayerDistance == 999) || {[_testPos, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

						if ((_roadAllowed) || {!isOnRoad _testPos}) then {

							if ((count _blacklist == 0) || ([_testPos, _blacklist] call SAC_fnc_isNotBlacklisted)) then {

								if ((count _whitelist == 0) || ([_testPos, _whitelist] call SAC_fnc_isBlacklisted)) then {

									{
									
										/*
										
										Para chequear si el círculo A intersecta al círculo B, obtener un punto desde el centro de A
										en la dirección de B a la distancia del radio de A, y chequear que la distancia entre ese punto
										y el centro de B, no sea menor que el radio de B. Esto es una simplificación, posible sólo
										porque en este contexto, ya se eliminaron los círculos cuyos centros se encuentren dentro del
										área del círculo a chequear.
										
										*/
									
										_posTree = getPosATL _x;
										_posTree set [2, 0];
										
										if (((_testPos getPos [_posSize / 2, _testPos getDir _posTree]) distance _posTree) < (boundingBox _x) select 2) exitWith {

											_testPos = [];
										
										};

									} forEach (nearestTerrainObjects [_testPos, ["TREE", "SMALL TREE","BUILDING", "HOUSE"], (_posSize / 2) + 50, false]);

									if (count _testPos > 0) then {
									
										{
										
											if ([_testPos, _x] call SAC_fnc_distance2Box <= (_posSize / 2) + 5) exitWith {
											
												_testPos = [];
											
											};

										} forEach (nearestTerrainObjects [_testPos, ["POWER LINES"], (_posSize / 2) + 150, false]);

										if (_testPos isNotEqualTo []) then {

											_safePos = _testPos;
											breakTo "main";
										
										};
										
									};

								};

							};

						};

					};

				};


				_iter2 = _iter2 + 1;
				_angleToCell = _angleToCell + (360 / _maxIter2);

			};

		};

		_iteration = _iteration + 1;

		_minDistanceNow = _minDistanceNow + _checkCellSize;

	};

	//if (count _testPos > 0) then {[_testPos, "ColorBlue", "", "", [_posSize / 2, _posSize / 2], ["ELLIPSE", "Border"]] call SAC_fnc_createMarkerLocal;};

	_safePos

};

SAC_fnc_findLZ = {

	/*

	Según la nueva documentación de isFlatEmpty, el segundo parámetro tiene que estar en
	cero, o la función se vuelve "inusable". No sé cuándo cambió, pero antes
	el segundo parámetro definía el área de búsqueda, porque la función buscaba en los
	alrededores un área válida y devolvía ese punto, y toda mi función estaba basada en
	ese comportamiento. Lo peor del caso es que mi función parece seguir funcionando bien,
	usando el segundo parámetro, y permitiendo que isFlatEmpty busque un punto válido por
	sí sola.

	Por las dudas, voy a intentar una función basada en el comportamiento documentado actual.

	2016-05-01 Al final, como experimento, tuve que usar el segundo parámetro, y al menos pasar 1 en vez de -1.
	Así la función es bastante eficiente para validar una LZ a partir del punto pasado como parámetro, y en un radio
	no mayor de 50 mts.
	
	2022-03-01 Tuve problemas con algunos árboles que sólo se detectaba el tronco, y no el follaje, por lo que los
	helicópteros se estrellaban. La documentación de isFlatEmpty, dice que comprueba si la zona está vacía, según las
	"bounding SPHERES" de los objetos, cosa que evidentemente fallaba con el segundo parámetro en 1, que era como lo estaba usando.
	Al final el problema se resolvió cambiando el segundo parámetro a -1 (como decía la documentación). Noté dos efectos
	adversos. Uno es que ahora parece más estricta la detección de la pendiente, y con 0.1, muchas LZ que antes eran válidas,
	ahora no lo son. Desconozco el motivo. Y dos, ahora incluye objetos que antes no incluía, como las luces superficiales en las
	pistas de aterrizaje, y las líneas de alta tensión (éstas últimas tienen "bounding spheres" gigantescas).
	
	En definitiva, el segundo parámetro en -1 parece decirle que use las "bounding spheres" en vez de las "bounding boxes", y que
	incluya algunos tipos de objetos más (se los encuentra con nearestTerrainObjects, con el tipo "HIDE", pero no todos esos objetos
	son los que tiene en cuenta). O tal vez en -1 hace un trabajo diferente en 3D, y por eso antes detectaba la intersección con el
	árbol sólo al nivel del suelo, pero no a la altura del follaje.
	
	En este punto, y después de mucho investigar y probar, hay dos opciones:
	1 - Usar la función con el segundo parámetro en -1, lo cual reduce la cantidad de LZ válidas encontradas,
	pero también hace casi imposible que las LZ encontradas tengan algún problema.
	2 - Usar la función como hasta ahora (con el segundo parámetro en 1), lo cual aumenta las LZ válidas, y agregar
	un testeo extra, por las "bounding spheres" de los árboles cercanos.
	
	Finalmente, se implementó la opción 2. Además se incluyó lo mismo para edificios, porque se permitía poner LZs justo al borde
	de la boundingBox, y eso también podría ser problemático.
	
	2022-04-04 Encontré una función que devuelve la distancia hasta el punto más cercano a una "bounding box", así que se pudo
	agregar una comprobación adicional para evitar los cables de tensión y sus torres.
	
	*/

	params ["_centerPos", "_posSize", "_safetyMargin"];

	private ["_waterMode", "_shoreMode", "_testPos", "_iteration", "_maxIterations", "_maxDistance",
	"_iterations", "_maxTerrainGradient", "_marker", "_theSecondParameter", "_sd", "_finalPosSize", "_finalPosSizeRadius",
	"_center"];

	scopeName "main";

	_finalPosSize = _posSize + _safetyMargin;
	_finalPosSizeRadius = _finalPosSize / 2;
	
	//BIKI: The gradient seems to correlate with general hill steepness: 0.1 (10%) ~6°, 0.5 (50%) ~27°, 1.0 (100%) ~45°, etc.
	//_maxTerrainGradient = 10 * (pi / 180); //_maxTerrainGradient = 10 * (pi / 180);
	_maxTerrainGradient = 0.12; //(10%) ~6°
	_waterMode = 0;
	_shoreMode = false;

	_theSecondParameter = 1;
	//_theSecondParameter = -1;

	private _m = "";
	if (_centerPos isflatempty [-1, -1, _maxTerrainGradient, _finalPosSizeRadius, 0, false, objNull] isEqualTo []) then {_m = "TOO STEEP<br/>"};
	if (_centerPos isflatempty [_finalPosSizeRadius, -1, -1, -1, 0, false, objNull] isEqualTo []) then {_m = _m + "NOT EMPTY"};
	hint parseText ("<t color='#FFFF00' size='1.2'><br/>" + _m + "<br/></t>");

	//valores precalculados para una densidad de 1 punto por metro cuadrado
	//hasta un circulo de 50 metros de radio
	_iterations = [78, 235, 392, 549, 706, 863, 1021, 1178, 1335, 1492];

	private _safePos = [];

	_testPos = _centerPos;

	_maxDistance = 5; //representa la distancia máxima de desplazamiento del punto designado originalmente

	while {_maxDistance <= 50} do {

		_iteration = 1;
		_maxIterations = _iterations deleteAt 0;

		while {_iteration <= _maxIterations} do {

			_safePos = _testPos isflatempty [_finalPosSizeRadius, _theSecondParameter, _maxTerrainGradient, _finalPosSizeRadius, _waterMode, _shoreMode, objNull];

			if (_safePos isNotEqualTo []) then {
			
				//systemChat "candidate pos found";
			
				{
				
					/*
					
					Para chequear si el círculo A intersecta al círculo B, obtener un punto desde el centro de A
					en la dirección de B a la distancia del radio de A, y chequear que la distancia entre ese punto
					y el centro de B, no sea menor que el radio de B. Esto es una simplificación, posible sólo
					porque en este contexto, ya se eliminaron los círculos cuyos centros se encuentren dentro del
					área del círculo a chequear.
					
					*/
				
					//systemChat "checking trees";
				
					_posTree = getPosATL _x;
					_posTree set [2, 0];
					
					//diag_log _posTree;
					
					//[_posTree, "ColorGreen", ""] call SAC_fnc_createMarkerLocal;
					
					
					//_center = _x modelToWorld (boundingCenter _x);
					
					//[_center, "ColorRed", ""] call SAC_fnc_createMarkerLocal;
					
					//diag_log ((_safePos getPos [_finalPosSizeRadius, _safePos getDir _posTree]) distance _posTree);
					
					//[_safePos getPos [_finalPosSizeRadius, _safePos getDir _posTree], "ColorOrange", ""] call SAC_fnc_createMarkerLocal;
					
					//diag_log ((boundingBox _x) select 2);
					
					/*
					
						03/04/2022 Tener en cuenta que las "FENCE" y los "WALL" no se tienen en cuenta en la 
						comprobación	de las "sphere bounding boxes". Esto es porque al ser alargadas, las 
						"sphere bounding boxes" distorsionarían la comprobación de colisión. La "bounding box"
						normal ya es tomada en cuenta	por "isFlatEmpty", y al no tener "follage", no debería
						existir el problema que hay con los árboles.
					
					
					*/
					if (((_safePos getPos [_finalPosSizeRadius, _safePos getDir _posTree]) distance _posTree) < (boundingBox _x) select 2) exitWith {
					
						_safePos = [];
					
					};

				} forEach (nearestTerrainObjects [_safePos, ["TREE", "SMALL TREE","BUILDING", "HOUSE"], _finalPosSizeRadius + 50, false]);

				if (_safePos isNotEqualTo []) then {

					{
					
						//systemChat str ([_safePos, _x] call SAC_fnc_distance2Box);
						
						if ([_safePos, _x] call SAC_fnc_distance2Box <= _finalPosSizeRadius + 5) exitWith {
						
							_safePos = [];
						
						};
						
						/*
						sac_powerLine = _x;
						addMissionEventHandler [ "EachFrame", {
							[ sac_powerLine, sac_powerLine call TAG_fnc_getBounds, [ 1, 1, 1, 1 ] ] call TAG_fnc_drawLines;
						}];
						*/

					} forEach (nearestTerrainObjects [_safePos, ["POWER LINES"], _finalPosSizeRadius + 150, false]);

					if (_safePos isNotEqualTo []) then {

						//systemChat "candidate pos accepted";
						breakTo "main";
					
					};
					
				};

			};
			
			_testPos = _centerPos getPos [(_maxDistance -  5) + random 5, random 360];

			_iteration = _iteration + 1;

		};

		_maxDistance = _maxDistance + 5;

	};

	_safePos

};

SAC_fnc_findRoad = {

	//Uso:
	//[_centralPos, _minDistance, _maxDistance, _dir, _blacklist, _noplayerDistance, [_method]] call SAC_fnc_findRoad;

	private ["_centralPos", "_minDistance", "_maxDistance", "_dir", "_method", "_road", "_goodRoads", "_bestDistance", "_blacklist", "_noplayerDistance",
	"_allRoads", "_testroad", "_t1", "_initialCentralPos", "_searchRadius"];

	_centralPos = _this select 0;
	_minDistance = _this select 1;
	_maxDistance = _this select 2;
	_dir = _this select 3; //pasar 999 como argumento desactiva el parámetro
	_blacklist = _this select 4; //un array de áreas indicadas por markers ó triggers
	_noplayerDistance = _this select 5; //pasar 999 para deshabilitar la zona de exclusión alrededor de los jugadores
	_method = if ("closest" in _this) then {"closest"} else {"random"};

	_initialCentralPos = _centralPos;

	if (_dir != 999) then {

		/*

		Calcular la _centralPos como un punto en la dirección de la búsqueda _dir, a una distancia igual a: _minDistance + ((_maxDistance - _minDistance) / 2) y
		un radio de: (_maxDistance - _minDistance) / 2

		*/

		_centralPos = _centralPos getPos [_minDistance + ((_maxDistance - _minDistance) / 2), _dir];

		_searchRadius = (_maxDistance - _minDistance) / 2;

	} else {

		_searchRadius = _maxDistance;

	};

	_allRoads = (_centralPos nearRoads _searchRadius) select {(getRoadInfo _x) select 2 == false}; //descarto 'pedestrian roads'

	_road = objNull;

	if (_method == "closest") then {

		_goodRoads = [];
		{

			if ((_minDistance == 0) || {_dir != 999} || {_centralPos distance _x > _minDistance}) then {

				if ((count _blacklist == 0) || {[getPos _x, _blacklist] call SAC_fnc_isNotBlacklisted}) then {

					if ((_noplayerDistance == 999) || {[_x, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

						_goodRoads pushBack _x;

					};

				};

			};

		} forEach _allRoads;

		if (count _goodRoads > 0) then {

			_road = [_goodRoads, _centralPos] call BIS_fnc_nearestPosition;

		};

	} else {

		//_allRoads = _allRoads call SAC_fnc_shuffleArray;

		while {(count _allRoads > 0) && {isNull _road}} do {

			_testroad = selectRandom _allRoads;

			if ((_minDistance == 0) || {_dir != 999} || {_centralPos distance _testroad > _minDistance}) then {

				if ((count _blacklist == 0) || {[getPos _testroad, _blacklist] call SAC_fnc_isNotBlacklisted}) then {

					if ((_noplayerDistance == 999) || {[_testroad, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

						_road = _testroad;

					};

				};

			};

			_allRoads deleteAt (_allRoads find _testroad);

		};

	};

	_road

};


SAC_fnc_markRoadsForEver = {

	//para debug
	
	private _p = [0,0,0];
	private _r = objNull;
	
	while {true} do {
	
		_r = [getPos player, 0, 500, 999, [], 999, ["random"]] call SAC_fnc_findRoad;
		
		if !(isNull _r) then {
		
			[getPos _r, "ColorBlue", ""] call SAC_fnc_createMarker;
		
		};
		
	
	
	};



};

SAC_fnc_markJungleTrails = {

	private ["_mapMiddle","_allRoadPositions","_jungleTrailPositions","_roadPosition"];

	_mapMiddle = [10000,10000,0];

	_allRoadPositions = _mapMiddle nearRoads 15000;

	_jungleTrailPositions = [];
	{
		_roadPosition = getPos _x;
		if ((!isOnRoad _roadPosition) && (surfaceType _roadPosition == "#GdtForest")) then {
			if ((({
				(surfaceType _x == "#GdtForest") ||
				(surfaceType _x == "#GdtBeach") ||
				(surfaceType _x == "#GdtSeabed")
			}) count [
				[(_roadPosition select 0) + 200,(_roadPosition select 1) + 200,0],
				[(_roadPosition select 0) + 200,(_roadPosition select 1) - 200,0],
				[(_roadPosition select 0) - 200,(_roadPosition select 1) + 200,0],
				[(_roadPosition select 0) - 200,(_roadPosition select 1) - 200,0],
				[(_roadPosition select 0) + 100,(_roadPosition select 1) + 100,0],
				[(_roadPosition select 0) + 100,(_roadPosition select 1) - 100,0],
				[(_roadPosition select 0) - 100,(_roadPosition select 1) + 100,0],
				[(_roadPosition select 0) - 100,(_roadPosition select 1) - 100,0]
			]) == 8) then {
				_jungleTrailPositions pushBack _roadPosition;
			};
		};
	} forEach _allRoadPositions;

	{ 
		_mkr = createMarker[str _x,_x];
		_mkr setMarkerShape "ELLIPSE";
		_mkr setMarkerSize [10,10];
		_mkr setMarkerColor "ColorOrange";
		_mkr setMarkerAlpha 1;
	} forEach _jungleTrailPositions;

	systemChat format["All - %1 --- Jungle - %2",count _allRoadPositions,count _jungleTrailPositions];

};

SAC_fnc_markJungleTrails2 = {

	private ["_mapMiddle","_allRoadPositions","_jungleTrailPositions","_roadPosition"];

	_mapMiddle = [10000,10000,0];

	_allRoadPositions = _mapMiddle nearRoads 15000;

	_jungleTrailPositions = [];
	{
		_roadPosition = getPos _x;
		if (!isOnRoad _roadPosition) then {
		//if ((!isOnRoad _roadPosition) && (surfaceType _roadPosition == "#GdtForest")) then {
/*			if ((({
				(surfaceType _x == "#GdtForest") ||
				(surfaceType _x == "#GdtBeach") ||
				(surfaceType _x == "#GdtSeabed")
			}) count [
				[(_roadPosition select 0) + 200,(_roadPosition select 1) + 200,0],
				[(_roadPosition select 0) + 200,(_roadPosition select 1) - 200,0],
				[(_roadPosition select 0) - 200,(_roadPosition select 1) + 200,0],
				[(_roadPosition select 0) - 200,(_roadPosition select 1) - 200,0],
				[(_roadPosition select 0) + 100,(_roadPosition select 1) + 100,0],
				[(_roadPosition select 0) + 100,(_roadPosition select 1) - 100,0],
				[(_roadPosition select 0) - 100,(_roadPosition select 1) + 100,0],
				[(_roadPosition select 0) - 100,(_roadPosition select 1) - 100,0]
			]) == 8) then {*/
				_jungleTrailPositions pushBack _roadPosition;
/*			};*/
		};
	} forEach _allRoadPositions;

	{ 
		_mkr = createMarker[str _x,_x];
		_mkr setMarkerShape "ELLIPSE";
		_mkr setMarkerSize [10,10];
		_mkr setMarkerColor "ColorOrange";
		_mkr setMarkerAlpha 1;
	} forEach _jungleTrailPositions;

	systemChat format["All - %1 --- Jungle - %2",count _allRoadPositions,count _jungleTrailPositions];

};

SAC_fnc_markJungleTrails3 = {

	private ["_mapMiddle","_allRoadPositions","_jungleTrailPositions","_roadPosition"];

	_mapMiddle = [10000,10000,0];
	_mapMiddle = getPos player;

	//_allRoadPositions = _mapMiddle nearRoads 15000;
	
	_allRoadPositions = (_mapMiddle nearRoads 15000) select {(getRoadInfo _x) select 2 == true}; //descarto 'pedestrian roads'

	_jungleTrailPositions = [];
	{
		_roadPosition = getPos _x;
		//if ((getRoadInfo _x) select 2) then {
			
			_jungleTrailPositions pushBack _roadPosition;

		//};
	} forEach _allRoadPositions;

	{ 
		_mkr = createMarker[str _x,_x];
		_mkr setMarkerShape "ELLIPSE";
		_mkr setMarkerSize [10,10];
		_mkr setMarkerColor "ColorOrange";
		_mkr setMarkerAlpha 1;
	} forEach _jungleTrailPositions;

	systemChat format["All - %1 --- Jungle - %2",count _allRoadPositions,count _jungleTrailPositions];

};

SAC_fnc_markAllRoads = {

	//_mapMiddle = [10000,10000,0];
	private _mapMiddle = getPos player;

	private _allRoads = _mapMiddle nearRoads 50000;

	{ 
		_mkr = createMarker[str getPos _x, getPos _x];
		_mkr setMarkerShape "ELLIPSE";
		_mkr setMarkerSize [10,10];
		_mkr setMarkerColor "ColorOrange";
		//_mkr setMarkerAlpha 1;
	} forEach _allRoads;

	systemChat format["All - %1", count _allRoads];

};


SAC_fnc_trimGroup = {

	/*

		2016/04/24 - Ya no se refiere a un grupo como tipo de objeto, sino a una coleccion de unidades, independientemente de que sean del mismo grupo o no.

	*/


	private ["_units", "_newSize", "_irrelevantUnits", "_count"];

	_units = _this select 0;
	_newSize = _this select 1;

	_count = 1;
	_irrelevantUnits = [];
	{

		if (alive _x) then {

			if (_count > _newSize) then {

				_irrelevantUnits pushBack _x;

			};

			_count = _count + 1;

		};

	} forEach _units;

	{

		deleteVehicle _x;

	} forEach _irrelevantUnits;

};

SAC_fnc_buildingPos = {

	params ["_building"];
	
	private _positions = [];
	
	private _index = SAC_buildingPosDB_for_units findIf {_x select 0 == typeOf _building};
	
	if (_index != -1) then {

		{
		
			_positions pushBack (_building modelToWorld _x); //modelToWorld devuelve PositionAGL (sobre la tierra es igual a PositionATL)
		
		} forEach ((SAC_buildingPosDB_for_units select _index) select 1);


	} else {
	
		_positions = _building buildingPos -1;
		
	};

	_positions
	
};


SAC_fnc_putUnitsInBuilding = {

	/*

		2016/04/24 - Ya no trabaja sobre un grupo como tipo de objeto, sino con un array de unidades, independientemente de que sean del mismo grupo o no.

	*/

	private ["_units", "_building", "_enableAttack", "_buildingPositions", "_cnt", "_pos", "_indx", "_rndpos", "_autoTrim", "_noStop", "_stance", "_watchDir",
	"_outsidePos", "_array", "_hardcoreStop"];

	_units = _this select 0;
	_building = _this select 1;
	_stance = _this select 2; //el pool de posibles "stances" que tomará cada unidad. Ej. ["middle","up"] ó ["auto"]
	_enableAttack = if ("enable_attack" in _this) then {true} else {false}; //el líder puede ordenar a las unidades salir a perseguir enemigos.
	_autoTrim = if ("auto_trim" in _this) then {true} else {false}; //si el grupo tiene más unidades que posiciones, se eliminan las unidades que sobran.
	_noStop = if ("no_stop" in _this) then {true} else {false}; //no dar order doStop a cada unidad del grupo.
	_hardcoreStop = if ("hardcore_stop" in _this) then {true} else {false}; //desactivar partes de la AI para que no se puedan mover de sus posiciones.

	_buildingPositions = _building call SAC_fnc_buildingPos;

	//"defensive code"
	if ((count _buildingPositions == 0) && (_autoTrim)) exitWith {"ERROR: Se intentó poner unidades en un edificio no ocupable, con el parámetro _autoTrim." call SAC_fnc_MPsystemChat};

	//"defensive code"
	if ((count _buildingPositions > 0) && (count _buildingPositions < {alive _x} count _units) && (!_autoTrim)) exitWith {"ERROR: El edificio es ocupable, pero tiene menos posiciones que el grupo, y no se utilizó _autoTrim." call SAC_fnc_MPsystemChat};

	//"defensive code"
	if ((count _buildingPositions == 0) && (!_autoTrim)) then {"WARNING: Se intentó poner unidades en un edificio no ocupable. Las unidades se ubicarán en el exterior." call SAC_fnc_MPsystemChat; (typeOf _building) call SAC_fnc_MPsystemChat};


	if (count _buildingPositions == 0) then { //Si todo lo demás está bien, y el edificio no es "enterable", la intención es que se ubique al grupo afuera.

		//[_centerPos, _minDistance, _posSize, _maxTerrainGradient, _roadAllowed, _noplayerDistance, _maxDistance, _debug, _blacklist] call SAC_fnc_safePosition;
		_outsidePos = [getPos _building, 0, 5.5, 15, false, 999, 500, false, []] call SAC_fnc_safePosition;

		if (_outsidePos isEqualTo []) then {

			_outsidePos = getPos _building;

		};

		{if (alive _x) then {_x setPos _outsidePos}} forEach _units;

	} else {

		if (count _buildingPositions < {alive _x} count _units) then { //_autoTrim está implícito en esta condición porque si no hubiera salido de la función por el "defensive code".

			[_units, count _buildingPositions] call SAC_fnc_trimGroup;

		};

		{

			if (alive _x) then {

				//28/02/22 Esto es para prevenir que se muevan después de usar setPos, y antes de que el script las detenga.
				_x disableAI "PATH"; 

				if (count _buildingPositions == 0) exitWith {
					//Llegados a este punto, si hay más unidades que posiciones, es porque el engine todavía
					//no reconoció la reducción del nro. de unidades por _autoTrim. Por eso lo correcto es salir
					//de la función.
				};

				//select a random position
				_rndpos = _buildingPositions deleteAt floor (random (count _buildingPositions));

				_x setPosATL _rndpos;

				//El siguiente código trata de que las unidades no queden mirando a una pared a 30 cm. Para eso en el primer intento se trata
				//de buscar una dirección hacia la cual haya una línea de visión, en el exterior del edificio, a 5 mts., y que a su vez esté al aire libre.
				//Si no existe, en el segundo intento, se busca una línea visual libre hacia una posición a 4 mts., dentro del edificio. Y si tampoco existiera,
				//en el tercer intento, se busca una línea visual hacia una posición a 2 mts., dentro del edificio. Si no existe no se cambia la dirección.
				//NOTA: La función SAC_fnc_dirToClearView está basada en un script extraordinario que no hice yo, y que sólo adapté para el caso.
				_array = [_rndpos, 5, 25] call SAC_fnc_dirToClearView;
				if ((_array select 0) != 999) then {
					_x setDir (_array select 0);
					_x lookAt (_array select 1);
				} else {
					_array = [_rndpos, 4, 0] call SAC_fnc_dirToClearView;
					if ((_array select 0) != 999) then {
						_x setDir (_array select 0);
						_x lookAt (_array select 1);
					} else {
						_array = [_rndpos, 2.5, 0] call SAC_fnc_dirToClearView;
						if ((_array select 0) != 999) then {
							_x setDir (_array select 0);
							_x lookAt (_array select 1);
						};
					};
				};

				if (!_noStop) then {doStop _x};
				
				//25/10/2019 este cambio hace que si se pasa "hardcore_stop" todas las unidades estén estáticas dentro, y si no se pasa,
				//sólo algunas estén estáticas, y otras se puedan mover.
				//if ((_hardcoreStop) || {_x == leader group _x} || {random 1 < 0.35}) then { 
				//28/04/2020 se corrige un error inexplicable por el que todas las unidades tenían una chance de estar estáticas, no
				//solo el líder, cuando no se pasaba hardcore_stop
				if (!_hardcoreStop) then { 

					//12/3/2021 Con este cambio, cuando no se pase _hardcoreStop, el líder ya no es seguro que quede dentro (pero es lo más probable),
					//y tampoco es seguro que cada una de las demás unidades vayan a poder salir (aunque es lo más probable).
					if (_x == leader group _x) then {
					
						if (random 1 < 0.85) then {_x disableAI "PATH"} else {_x enableAI "PATH"};
						
					} else {
					
						if (random 1 < 0.20) then {_x disableAI "PATH"} else {_x enableAI "PATH"};
					
					};
				
				} else {
				
					//23/06/11
					group _x enableAttack false;
					_x disableAI "TARGET";
					/*
						"TARGET" - Prevents units from engaging targets. Units still move around for cover,
						but will not hunt down enemies. Works in groups as well. Excellent for keeping units
						inside bases or other areas without having them flank or engage anyone. They will still
						seek good cover if something is close by.
					*/
				};


				//Debido a un bug de A3 (a la fecha), si a un civil se lo obliga a arrodillarse, no se lo puede parar más.
				//if !(typeOf _x in SAC_CIVILIAN_SIDE_men) then {_x setUnitPos (selectRandom _stance)};
				if !(side group _x == civilian) then {_x setUnitPos (selectRandom _stance)};

				//25/10/2019 Hasta este momento, siempre se usó la línea siguiente.
				//if (!_enableAttack) then {group _x enableAttack false};

			};

		} forEach _units;

	};

	//NOTA: La referencia constante a contar sólo las unidades que estén vivas, se da porque el engine tarda en notar las unidades muertas.

};

SAC_fnc_randomPosFromSquare = {
	private ["_areaButtonLeft", "_areaTopRight", "_maxIterations", "_playerSideExclusionDistance", "_timeOut", "_validPos", "_mapAreaMinX", "_mapAreaMinY", "_mapAreaMaxX",
	"_mapAreaMaxY", "_mapAreaWidth", "_mapAreaHeight", "_randomX", "_randomY", "_pos", "_waterAllowed", "_blacklist"];

	_areaButtonLeft = _this select 0;
	_areaTopRight = _this select 1;
	_maxIterations = _this select 2;
	_playerSideExclusionDistance = _this select 3; //pasar <= 0 para deshabilitar checkeo
	_waterAllowed = _this select 4;
	_blacklist = _this select 5; //un array de áreas indicadas por markers ó triggers

	_timeOut = 0;
	_validPos = false;
	_mapAreaMinX = _areaButtonLeft select 0;
	_mapAreaMinY = _areaButtonLeft select 1;
	_mapAreaMaxX = _areaTopRight select 0;
	_mapAreaMaxY = _areaTopRight select 1;
	_mapAreaWidth = _mapAreaMaxX - _mapAreaMinX;
	_mapAreaHeight = _mapAreaMaxY - _mapAreaMinY;
	while {(_timeOut < _maxIterations) && (!_validPos)} do {

		_randomX = _mapAreaMinX + random _mapAreaWidth;
		_randomY = _mapAreaMinY + random _mapAreaHeight;

		_pos = [_randomX, _randomY];

		_validPos = false;
		if ((count _blacklist == 0) || {[_pos, _blacklist] call SAC_fnc_isNotBlacklisted}) then {
			if ((_waterAllowed) || {!surfaceIsWater _pos}) then {
				_validPos = true;
				
// 11/5/2021 fue cambiado por posible optimización
				if (_playerSideExclusionDistance > 0) then {

					if (SAC_PLAYER_SIDE countSide (_pos nearEntities _playerSideExclusionDistance) > 0) then {_validPos = false};

				};
//por este código equivalente (no es seguro cual es más rápido)
//al final decidí que las unidades del SAC_PLAYER_SIDE son siempre tan pocas, que el código de arriba sea probablemente mucho más rápido
//				if (_playerSideExclusionDistance > 0) then {

//					if ((_pos nearEntities _playerSideExclusionDistance) findIf {side _x == SAC_PLAYER_SIDE} != -1) then {_validPos = false};

//				};
//***************************************************************
			};
		};

		_timeOut = _timeOut + 1;
	};

	if (!_validPos) then {_pos = [0,0,0]};

	_pos

};

SAC_fnc_sunElev = {
	/*
		Author: CarlGustaffa

		Description:
		Returns the suns altitude for current day and hour of the year on any island (whos latitude may differ).

		Parameters:
		None needed.

		Returns:
		Suns altitude in degrees, positive values after sunrise, negative values before sunrise.
	*/
	private ["_lat", "_day", "_hour", "_angle", "_isday"];
	_lat = -1 * getNumber(configFile >> "CfgWorlds" >> worldName >> "latitude");
	_day = 360 * (dateToNumber date);
	_hour = (daytime / 24) * 360;
	_angle = ((12 * cos(_day) - 78) * cos(_lat) * cos(_hour)) - (24 * sin(_lat) * cos(_day));
	_angle
};

SAC_fnc_isNight = {
	private ["_ret"];
	_ret = if (call SAC_fnc_sunElev > 0) then {false} else {true};
	_ret
};

//Cortesía de KillZone Kid ;)
SAC_fnc_shuffleArray = {
    private ["_el","_rnd"];
    for "_i" from count _this - 1 to 0 step -1 do {
        _el = _this select _i;
        _rnd = floor random (_i + 1);
        _this set [_i, _this select _rnd];
        _this set [_rnd, _el];
    };
    _this
};


SAC_fnc_sumAndEqualize = {

	params ["_smallerArray","_biggerArray"];

	private _countSmallerArray = count _smallerArray;
	private _resultingArray = [];
	private _i2 = 0;
	
	for "_i" from 0 to count _biggerArray - 1 do {
	
		_resultingArray pushBack (_biggerArray select _i);
	
		if (_i2 == _countSmallerArray) then {_i2 = 0};
	
		_resultingArray pushBack (_smallerArray select _i2);
	
		_i2 = _i2 + 1;
	

	};
	
	_resultingArray

};


SAC_fnc_drawLine = {

	params ["_punto1", "_punto2", "_global"];

	private ["_lenght", "_dir", "_halfwayPoint", "_marker"];

	_lenght = _punto1 distance _punto2;
	_dir = ((_punto2 select 0) - (_punto1 select 0)) atan2 ((_punto2 select 1) - (_punto1 select 1));
	_halfwayPoint = _punto1 getPos [_lenght / 2, _dir];

	if (_global) then {

		_marker = createMarker [format["SAC_fnc_drawLine_%1_%2", random 1, random 1], _halfwayPoint];
		_marker setMarkerShape "RECTANGLE";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerSize [2, _lenght / 2];
		_marker setMarkerDir _dir;

	} else {

		_marker = createMarkerLocal [format["SAC_fnc_drawLine_%1_%2", random 1, random 1], _halfwayPoint];
		_marker setMarkerShapeLocal "RECTANGLE";
		_marker setMarkerColorLocal "ColorRed";
		_marker setMarkerSizeLocal [2, _lenght / 2];
		_marker setMarkerDirLocal _dir;

	};

	_marker

};

SAC_fnc_updateSavedGear = {

	private["_unit","_weapons","_assigned_items","_primary","_array","_gearText","_headGear","_vest","_uniform","_backpack","_goggles", "_handgun",
	"_primaryWeapon", "_currentMagazine", "_handgunMagazineArray"];

	_unit = [_this,0,objnull,[objnull]] call bis_fnc_param;
	_gearText = "";

	_headGear = "";
	_vest = "";
	_uniform = "";
	_backpack = "";
	_goggles = "";

	_gearText = _gearText + "removeAllWeapons player; ";
	_gearText = _gearText + "removeAllAssignedItems player; ";
	_gearText = _gearText + "removeAllContainers player; ";
	_gearText = _gearText + "removeHeadgear player; ";
	_gearText = _gearText + "removeGoggles player; ";

	if((headgear _unit)!="") then {
		_headGear = headgear _unit;
		_gearText = _gearText + format ["player addHeadgear '%1'; ", _headGear];
	};
	if((goggles _unit)!="") then {
		_goggles = goggles _unit;
		_gearText = _gearText + format ["player addGoggles '%1'; ", _goggles];
	};
	if((uniform _unit)!="") then {
		_uniform = uniform _unit;
		_gearText = _gearText + format ["player forceAddUniform '%1'; ", _uniform];
	};
	if((vest _unit)!="") then {
		_vest = vest _unit;
		_gearText = _gearText + format ["player addVest '%1'; ", _vest];
	};
	if((backpack _unit)!="") then {
		_backpack = backpack _unit;
		_gearText = _gearText + format ["player addBackPack '%1'; ", _backpack];
	};


	_primaryWeapon = primaryWeapon _unit;
	_currentMagazine = currentMagazine _unit;
	if (_primaryWeapon != "") then {
		if (_currentMagazine != "") then {_gearText = _gearText + format ["player addMagazine '%1'; ", _currentMagazine];};
		_gearText = _gearText + format ["player addWeapon '%1'; ", _primaryWeapon];
	};

	_handgun = handgunWeapon _unit;
	_handgunMagazineArray = handgunMagazine _unit;
	if (_handgun != "") then {
		if (count _handgunMagazineArray > 0) then {_gearText = _gearText + format ["player addMagazine '%1'; ", (_handgunMagazineArray select 0)];};
		_gearText = _gearText + format ["player addWeapon '%1'; ", _handgun];
	};


	//Now the attachments get added!
	{
		if(_x != "") then{_gearText = _gearText + format ["player addPrimaryWeaponItem '%1'; ", _x];};
	} foreach (primaryWeaponItems _unit);

	{
		if(_x != "") then{_gearText = _gearText + format ["player addHandgunItem '%1'; ", _x];};
	} foreach (handgunItems _unit);

	_array = getItemCargo uniformContainer _unit;
	if(count(_array)>0) then {
		{
			for[{_i=0},{_i<((_array) select 1) select _forEachIndex},{_i=_i+1}] do {
				_gearText = _gearText + format ["player addItemToUniform '%1'; ", _x];
			};
		} foreach ((_array) select 0);
	};

	_array = getMagazineCargo uniformContainer _unit;
	if(count(_array)>0) then {
		{
			for[{_i=0},{_i<((_array) select 1) select _forEachIndex},{_i=_i+1}] do {
				_gearText = _gearText + format ["player addItemToUniform '%1'; ", _x];
			};
		} foreach ((_array) select 0);
	};

	_array = getWeaponCargo uniformContainer _unit;
	if(count(_array)>0) then {
		{
			for[{_i=0},{_i<((_array) select 1) select _forEachIndex},{_i=_i+1}] do {
				_gearText = _gearText + format ["player addItemToUniform '%1'; ", _x];
			};
		} foreach ((_array) select 0);
	};

	_array = getItemCargo vestContainer _unit;
	if(count(_array)>0) then {
		{
			for[{_i=0},{_i<((_array) select 1) select _forEachIndex},{_i=_i+1}] do {
				_gearText = _gearText + format ["player addItemToVest '%1'; ", _x];
			};
		} foreach ((_array) select 0);
	};

	_array = getMagazineCargo vestContainer _unit;
	if(count(_array)>0) then {
		{
			for[{_i=0},{_i<((_array) select 1) select _forEachIndex},{_i=_i+1}] do {
				_gearText = _gearText + format ["player addItemToVest '%1'; ", _x];
			};
		} foreach ((_array) select 0);
	};

	_array = getWeaponCargo vestContainer _unit;
	if(count(_array)>0) then {
		{
			for[{_i=0},{_i<((_array) select 1) select _forEachIndex},{_i=_i+1}] do {
				_gearText = _gearText + format ["player addItemToBackpack '%1'; ", _x]; ///////WEIRD?????\\\\\\\\\\
			};
		} foreach ((_array) select 0);
	};

	_array = getItemCargo backpackContainer _unit;
	if(count(_array)>0) then {
		{
			for[{_i=0},{_i<((_array) select 1) select _forEachIndex},{_i=_i+1}] do {
				_gearText = _gearText + format ["player addItemToBackpack '%1'; ", _x];
			};
		} foreach ((_array) select 0);
	};

	_array = getMagazineCargo backpackContainer _unit;
	if(count(_array)>0) then {
		{
			for[{_i=0},{_i<((_array) select 1) select _forEachIndex},{_i=_i+1}] do {
				_gearText = _gearText + format ["player addItemToBackpack '%1'; ", _x];
			};
		} foreach ((_array) select 0);
	};

	_array = getWeaponCargo backpackContainer _unit;
	if(count(_array)>0) then {
		{
			for[{_i=0},{_i<((_array) select 1) select _forEachIndex},{_i=_i+1}] do {
				_gearText = _gearText + format ["player addItemToBackpack '%1'; ", _x];
			};
		} foreach ((_array) select 0);
	};

	{
		if (_x in SAC_binoculars) then {
			_gearText = _gearText + format ["player addWeapon '%1'; ", _x];
		} else {
			_gearText = _gearText + format ["player linkItem '%1'; ", _x];
		};
	} foreach assignedItems _unit;

	SAC_fnc_applySavedGear = _gearText;
	copyToClipBoard _gearText;

};

SAC_fnc_findBases = {

	private ["_maxBases", "_distanceFromDifferentGroups", "_centralPos", "_allMilitaryBuildings", "_c", "_marker", "_groupsOfBuildings", "_candidateBuilding", "_valid",
	"_i", "_basesPositions", "_building", "_milObjects", "_step", "_count", "_continue", "_posRight", "_posLeft", "_posUp", "_posDown", "_distanceToAllObjectsC",
	"_distanceToAllObjectsR", "_distanceToAllObjectsL", "_distanceToAllObjectsU", "_distanceToAllObjectsD", "_distance", "_averageDistanceC", "_averageDistanceR",
	"_averageDistanceL", "_averageDistanceU", "_averageDistanceD", "_rndidx", "_maxPlaces", "_militaryBases"];

	_centralPos = _this select 0;
	_radius = _this select 1;
	_maxBases = _this select 2;
	_distanceFromDifferentGroups = _this select 3; //afecta la detección de grupos separados de objetos, y por lo tanto el tamaño de cada grupo de edificios.

	//Busco todos los edificios que identifican bases militares.
	_allMilitaryBuildings = nearestObjects [_centralPos, SAC_militaryBuildings, _radius];

	// for [{_c=0}, {_c<count _allMilitaryBuildings}, {_c=_c+1}] do {[getPos (_allMilitaryBuildings select _c), "ColorYellow", ""] call SAC_fnc_createMarker}};

	//Filtro la lista de manera que quede un solo punto por cada grupo de edificios si están cerca entre sí (detecto los edificios que están agrupados y los convierto
	//en una sola posición).
	_groupsOfBuildings = [];
	for [{_c=0}, {_c<count _allMilitaryBuildings}, {_c=_c+1}] do {

		_candidateBuilding = _allMilitaryBuildings select _c;
		_valid = true;
		for [{_i=0}, {_i<count _groupsOfBuildings}, {_i=_i+1}] do {
			if ((getPos _candidateBuilding) distance (getPos (_groupsOfBuildings select _i)) < _distanceFromDifferentGroups) exitWith {_valid = false};
		};
		if (_valid) then {
			_groupsOfBuildings pushBack _candidateBuilding;
		};
	};

	// for [{_c=0}, {_c<count _groupsOfBuildings}, {_c=_c+1}] do {[getPos (_groupsOfBuildings select _c), "ColorRed", ""] call SAC_fnc_createMarker}};

	//Esta parte es complicada. La idea es encontrar el punto más central a todo el grupo de edificios detectados por cada grupo. Es decir, que si el punto de inicio
	//está marcando, por ej., un edificio periférico, al terminar esta rutina, el nuevo punto esté ubicado en el centro del grupo (es decir, de la base militar).
	//Para eso desplaza el punto en cuatro direcciones, y calcula el promedio de las distancias hacia cada edificio del grupo. Si ese promedio es menor en alguna de las
	//direcciones, el punto que se movió en esa dirección se convierte en el nuevo punto central, y la rutina se repite hasta que ninguna de las posiciones desplazadas
	//tenga un promedio de distancias menor a la central.
	_basesPositions = [];
	for [{_c=0}, {_c<count _groupsOfBuildings}, {_c=_c+1}] do {

		_building = _groupsOfBuildings select _c;

		_centralPos = getPos _building;

		_milObjects = nearestObjects [_centralPos, SAC_militaryBuildings, _distanceFromDifferentGroups];

		if (count _milObjects >= 2) then {

			_step = 1;
			_count = 0;
			_continue = true;
			while {(_count < 100) && (_continue)} do {
				_posRight = [(_centralPos select 0) + _step, _centralPos select 1, _centralPos select 2];

				_posLeft = [(_centralPos select 0) - _step, _centralPos select 1, _centralPos select 2];

				_posUp = [_centralPos select 0, (_centralPos select 1) + _step, _centralPos select 2];

				_posDown = [_centralPos select 0, (_centralPos select 1) - _step, _centralPos select 2];

				_distanceToAllObjectsC = 0;
				_distanceToAllObjectsR = 0;
				_distanceToAllObjectsL = 0;
				_distanceToAllObjectsU = 0;
				_distanceToAllObjectsD = 0;

				{
					_distance = getPos _x distance _centralPos;
					_distanceToAllObjectsC = _distanceToAllObjectsC + _distance;

					_distance = getPos _x distance _posRight;
					_distanceToAllObjectsR = _distanceToAllObjectsR + _distance;

					_distance = getPos _x distance _posLeft;
					_distanceToAllObjectsL = _distanceToAllObjectsL + _distance;

					_distance = getPos _x distance _posUp;
					_distanceToAllObjectsU = _distanceToAllObjectsU + _distance;

					_distance = getPos _x distance _posDown;
					_distanceToAllObjectsD = _distanceToAllObjectsD + _distance;

				} forEach _milObjects;

				_averageDistanceC = _distanceToAllObjectsC / count _milObjects;
				_averageDistanceR = _distanceToAllObjectsR / count _milObjects;
				_averageDistanceL = _distanceToAllObjectsL / count _milObjects;
				_averageDistanceU = _distanceToAllObjectsU / count _milObjects;
				_averageDistanceD = _distanceToAllObjectsD / count _milObjects;

				minNumber = _averageDistanceC min _averageDistanceR min _averageDistanceL min _averageDistanceU min _averageDistanceD;

				switch (true) do {
					case (minNumber == _averageDistanceC) : {
						_continue = false;
					};
					case (minNumber == _averageDistanceR) : {
						_centralPos = _posRight;
					};
					case (minNumber == _averageDistanceL) : {
						_centralPos = _posLeft;
					};
					case (minNumber == _averageDistanceU) : {
						_centralPos = _posUp;
					};
					case (minNumber == _averageDistanceD) : {
						_centralPos = _posDown;
					};
				};


				_count = _count + 1;
			};

			_basesPositions pushBack _centralPos;
		};

	};

	// for [{_c=0}, {_c<count _basesPositions}, {_c=_c+1}] do {[_basesPositions select _c, "ColorBlue", ""] call SAC_fnc_createMarker}};

	_militaryBases = [];
	if (count _basesPositions > _maxBases) then {
		//Si las bases encontradas son más que el límite _maxBases, se completa ese cupo eligiendo cuales al azar.
		_tempBasesPositions = _basesPositions;
		for [{_c=1}, {_c<=_maxBases}, {_c=_c+1}] do {
			_rndidx = floor random count _tempBasesPositions;

			_militaryBases pushBack (_tempBasesPositions select _rndidx);

			_tempBasesPositions set [_rndidx, "delete"]; 	//set the element to something else
			_tempBasesPositions = _tempBasesPositions - ["delete"]; 	//easy to remove now!!
		};
	} else {
		//Si la cantidad de bases es menor que _maxPlaces, se usan todas los que haya.
		_militaryBases = _basesPositions;
	};

	copyToClipboard str _militaryBases;

	_militaryBases

};

SAC_fnc_removeGear = {

	private ["_group", "_removeWeapons", "_noWeapons"];

	_group = _this select 0;
	_removeWeapons = selectRandom (_this select 1);

	_noWeapons = if (random 1 < 0.5) then {true} else {false};

	{

		switch (_removeWeapons) do {

			case "everyone": {
			
				//systemChat "removing gear";

				removeAllWeapons _x;
				//_x setCaptive true;
				removeAllAssignedItems _x;
				removeBackpack _x;
				removeVest _x;
				
				//10/10/2019 Saqué el spawn porque casi me vuelvo loco buscando la causa de por qué no les podía
				//poner una venda en los ojos a los rehenes y era por esto. A la randomización de BIS la voy a tratar
				//de desactivar desde 'SAC_GEAR_applyLoadout'.
				removeHeadgear _x;
				removeGoggles _x;
				//_x spawn {sleep 10; removeHeadgear _this; removeGoggles _this}; //es para que bis no le asigne de nuevo los items por el sistema de randomizacion

			};
			case "none": {
			};
			case "leader_only": {

				if (leader group _x == _x) then {

					removeAllWeapons _x;
					//_x setCaptive true;
					removeAllAssignedItems _x;
					removeBackpack _x;
					_x spawn {sleep 10; removeHeadgear _this; removeGoggles _this}; //es para que bis no le asigne de nuevo los items por el sistema de randomizacion

				};

			};
			case "random_all": {

				if (_noWeapons) then {

					removeAllWeapons _x;
					//_x setCaptive true;
					removeAllAssignedItems _x;
					removeBackpack _x;
					if (random 1 < 0.5) then {removeVest _x};
					_x spawn {sleep 10; removeHeadgear _this; removeGoggles _this}; //es para que bis no le asigne de nuevo los items por el sistema de randomizacion

				};

			};
			case "random_some": {

				if (random 1 < 0.5) then {

					removeAllWeapons _x;
					//_x setCaptive true;
					removeAllAssignedItems _x;
					removeBackpack _x;
					if (random 1 < 0.5) then {removeVest _x};
					_x spawn {sleep 10; removeHeadgear _this; removeGoggles _this}; //es para que bis no le asigne de nuevo los items por el sistema de randomizacion
				};

			};

		};

	} forEach units _group;

};

SAC_fnc_isFlying = {

	private ["_o"];

	_o = _this select 0;

	//Se intenta determinar si el objeto perdió relación con la tierra (está volando). Eso sucede si está a más de 100 mts. de altura, independientemente de la
	//velocidad; o si está a más de 10 mts. de altura, y a más de 30 km/h.
	if ((getPos vehicle _o select 2 > 100) || {(getPos vehicle _o select 2 > 10) && {speed vehicle _o > 30}}) then {true} else {false};
	
	//17/09/2017 La línea anterior es el método que usé durante años, y no considera volando a una unidad que se encuentra estacionaria entre los 10 y los 100 mts.
	//A partir de hoy simplemente considero volando todo lo que esté a más de 10 mts. de altura. El problema surgió con el método anterior, porque si el jugador está
	//en un paracaídas, el chequeo anterior lo consideraba en no volando.
	/*
	if (vehicle _o isKindOf "Air") then {
	
		//Suspendido porque no estoy seguro de que el método anterior no sea mejor.
	
	
	};
	*/
	
};

SAC_fnc_isNotFlying = {

	if ([(_this select 0)] call SAC_fnc_isFlying) then {false} else {true};
};

SAC_fnc_behaviour_idle = {
	/*

	_group
	_object
	_isBuilding		//Además de lo obvio, se puede usar este parámetro para que a pesar de que el objeto sea un edificio, las unidades no ingresen.
	_minDistance		//La distancia mínima desde la posición del edificio, a partir de la cual se cuenta la distancia máxima, a la que se puede mover el grupo.
	_maxDistance		//La distancia máxima que se puede alejar desde la distancia mínima. Si = 999 sólo se moverán dentro del edificio.
	_wait				//[min, max] El tiempo mínimo y máximo de espera, antes de dar otra órden de moverse.
	_removeWeapons		//["everyone", "none", "leader_only", "random_all", "random_some"] un array con uno o más de estos posibles valores, sólo uno, al azar, estará activo.

	Ej. de uso:
	[_group, _object, true, true, 5, 15, [20, 40], ["everyone", "none", "leader_only", "random_all", "random_some"]] spawn SAC_MIP_fnc_behaviour;

	*/

	params ["_group", "_object", "_isBuilding", "_minDistance", "_maxDistance", "_wait", "_removeWeapons"];

	//dispersar al grupo
	[_group, getPos _object, _minDistance, _maxDistance, false, false] call SAC_fnc_disperseGroup;

	private ["_buildingPositions"];

	[_group, _removeWeapons] call SAC_fnc_removeGear;

	if (_isBuilding) then {

		_buildingPositions = _object call SAC_fnc_buildingPos;
		if (count _buildingPositions == 0) then {_isBuilding = false};

	};

	while {(units _group) findIf {alive _x} != -1} do {

		while {((units _group) findIf {alive _x} != -1) && {behaviour leader _group != "COMBAT"}} do {

			if (_isBuilding) then {

				//Si es un edificio, hay dos posibilidades, 1) que se mueva a una posición dentro del edificio, 2) que se mueva a una posición cercana.
				//(El movimiento puede estar restringido a posiciones adentro del edificio, indicando _maxDistance = 999.)
				if ((random 1 < 0.5) && (_maxDistance != 999)) then {

					_group move (getPos _object getPos [_minDistance + random _maxDistance, random 360]); //experimentalmente, se cambió move por doMove en todo el script

				} else {

					_group move (selectRandom _buildingPositions);

				};


			} else {

				//Si no es un edificio, moverse a una posición cercana.
				_group move (getPos _object getPos [_minDistance + random _maxDistance, random 360]);

			};

			_group setBehaviour "SAFE";
			_group setSpeedMode "LIMITED";

			//waitUntil {sleep 1; (behaviour leader _group != "SAFE") || (moveToFailed (leader _group)) || (moveToCompleted (leader _group))};

			sleep (_wait call SAC_fnc_numberBetween);

		};

		if ((units _group) findIf {alive _x} != -1) then {sleep 90};

	};

};

SAC_fnc_behaviour_group_patrols_building = {

	//[_grp, _building, _exitOnCombat, _minWait, _maxWait, _probGoingOut] spawn SAC_fnc_behaviour_group_patrols_building;

	private ["_grp", "_building", "_positions", "_p", "_exitOnCombat", "_minWait", "_maxWait", "_probGoingOut"];

	_grp = _this select 0;
	_building = _this select 1;
	_exitOnCombat = _this select 2;
	_minWait = _this select 3;
	_maxWait = _this select 4;
	_probGoingOut = _this select 5;

	_positions = _building call SAC_fnc_buildingPos;

	scopeName "main";

	while {(units _grp) findIf {alive _x} != -1} do {

		if (behaviour leader _grp != "COMBAT") then {

			if (random 1 < _probGoingOut) then {

				_p = selectRandom _positions;

			} else {

				_p = getPos _building getPos [10 + random 10, random 360];

			};

			leader _grp doMove _p;
			_grp setSpeedMode "LIMITED";

			waitUntil {(unitReady leader _grp) || {moveToFailed leader _grp}};

			sleep (_minWait + round random _maxWait);

		} else {

			if (_exitOnCombat) then {breakTo "main"};

			sleep 90;

		};

	};

};

SAC_fnc_nearestPlayerSide = {

	params ["_center", "_maxDistance"];
	
	private ["_nearestDistance", "_nearestUnit"];

	_nearestDistance = 500000;
	_nearestUnit = objNull;

	{

		if ((side _x == SAC_PLAYER_SIDE) && {_x distance _center < _nearestDistance}) then {

			_nearestUnit = _x;
			_nearestDistance = _x distance _center;

		};

	} forEach (_center nearEntities _maxDistance);

	_nearestUnit

};

SAC_fnc_insideArea = {
	/*
		File: Originally based on insideTrigger.sqf by Karel Moricky.
		Author: Karel Moricky, updated by CarlGustaffa to support marker (expandable to anything) input.

		Description:
		Detects whether is position within provided area.

		Parameter(s):
			_this select 0: Trigger or Marker, Location (not yet)
			_this select 1: Position to test
			_this select 2: OPTIONAL - scalar result (distance from border)

		Returns:
		Boolean (true when position is in area, false if not).
	*/
	private ["_input","_position","_scalarresult","_res","_posx","_posy","_area","_areax","_areay","_areadir","_shape","_in"];
	_input = _this select 0;
	_position = _this select 1;
	_scalarresult = if (count _this > 2) then {_this select 2} else {false};
	_in = false;
	switch (typeName _input) do {
		case "STRING" : { //Markers
			_posx = getMarkerPos _input select 0;
			_posy = getMarkerPos _input select 1;
			_area = getMarkerSize _input;
			_areax = _area select 0;
			_areay = _area select 1;
			_areadir = markerDir _input;
			_shape = if(markerShape _input == "ELLIPSE") then {false} else {true};
			if (_shape) then {
				//--- RECTANGLE
				_difx = (_position select 0) - _posx;
				_dify = (_position select 1) - _posy;
				_dir = atan (_difx / _dify);
				if (_dify < 0) then {_dir = _dir + 180};
				_relativedir = _areadir - _dir;
				_adis = abs (_areax / cos (90 - _relativedir));
				_bdis = abs (_areay / cos _relativedir);
				_borderdis = _adis min _bdis;
				_positiondis = _position distance getMarkerPos _input;
				_in = if (_scalarresult) then {
					_positiondis - _borderdis;
				} else {
					if (_positiondis < _borderdis) then {true} else {false};
				};
			} else {
				//--- ELLIPSE
				_e = sqrt(_areax^2 - _areay^2);
				_posF1 = [_posx + (sin (_areadir+90) * _e),_posy + (cos (_areadir+90) * _e)];
				_posF2 = [_posx - (sin (_areadir+90) * _e),_posy - (cos (_areadir+90) * _e)];
				_total = 2 * _areax;
				_dis1 = _position distance _posF1;
				_dis2 = _position distance _posF2;
				_in = if (_scalarresult) then {
					(_dis1+_dis2) - _total;
				} else {
					if (_dis1+_dis2 < _total) then {true} else {false};
				};
			};
		};
		case "LOCATION" : { //Placeholder for future changes
		};
		case "OBJECT" : {
			switch (true) do {
				case (_input isKindOf "EmptyDetector") : { //Trigger
					_posx = position _input select 0;
					_posy = position _input select 1;
					_area = triggerarea _input;
					_areax = _area select 0;
					_areay = _area select 1;
					_areadir = _area select 2;
					_shape = _area select 3;
					if (_shape) then {
						//--- RECTANGLE
						_difx = (_position select 0) - _posx;
						_dify = (_position select 1) - _posy;
						_dir = atan (_difx / _dify);
						if (_dify < 0) then {_dir = _dir + 180};
						_relativedir = _areadir - _dir;
						_adis = abs (_areax / cos (90 - _relativedir));
						_bdis = abs (_areay / cos _relativedir);
						_borderdis = _adis min _bdis;
						_positiondis = _position distance _input;
						_in = if (_scalarresult) then {
							_positiondis - _borderdis;
						} else {
							if (_positiondis < _borderdis) then {true} else {false};
						};
					} else {
						//--- ELLIPSE
						_e = sqrt(_areax^2 - _areay^2);
						_posF1 = [_posx + (sin (_areadir+90) * _e),_posy + (cos (_areadir+90) * _e)];
						_posF2 = [_posx - (sin (_areadir+90) * _e),_posy - (cos (_areadir+90) * _e)];
						_total = 2 * _areax;
						_dis1 = _position distance _posF1;
						_dis2 = _position distance _posF2;
						_in = if (_scalarresult) then {
							(_dis1+_dis2) - _total;
						} else {
							if (_dis1+_dis2 < _total) then {true} else {false};
						};
					};
				};
				case (_input isKindOf "House") : { //Placeholder for future changes
				};
			};
		};
	};
	_in
};

SAC_fnc_isNotBlacklisted = {

	params ["_pos", "_areas"];

	//systemChat str _this;
	
	//_areas		Un array de áreas indicadas por markers ó triggers

	{

		if (_pos inArea _x) exitWith {_pos = []};

	} forEach _areas;

	if (_pos isEqualTo []) then {false} else {true};

};

SAC_fnc_isBlacklisted = {

	if (_this call SAC_fnc_isNotBlacklisted) then {false} else {true};

};

SAC_fnc_notNearPlayers = {

	private ["_r", "_c", "_d"];

	_c = _this select 0; //puede ser un objeto o una posición porque "distance" admite los dos.
	_d = _this select 1;

	_r = true;

	{

		if (_x distance _c < _d) exitWith {_r = false};

	} forEach allPlayers;

	_r

};

SAC_fnc_nearPlayers = {

	!(_this call SAC_fnc_notNearPlayers);

};

//Esta función usa otro método que SAC_fnc_notNearPlayerSide. Usar ésta sólo cuando se sepa que las unidades del lado del jugador son pocas.
SAC_fnc_notNearPlayerSide_2 = {

	private ["_r", "_c", "_d"];

	_c = _this select 0; //puede ser un objeto o una posición porque "distance" admite los dos.
	_d = _this select 1;

	_r = true;

	{

		if (_x distance _c < _d) exitWith {_r = false};

	} forEach units SAC_PLAYER_SIDE;

	_r

};

SAC_fnc_nearPlayerSide = {

	!(_this call SAC_fnc_notNearPlayerSide_2);

};

SAC_fnc_netSay3D = {

	if (!SAC_sounds) exitWith {};

	params ["_obj","_snd", "_dis"];

	// broadcast PV
	PVEH_netSay3D = [_obj,_snd,_dis];
	publicVariable "PVEH_netSay3D";

	// run on current machine also if not dedi server
	//if (not isDedicated) then {_obj say3D _snd};
	if (not isDedicated) then {_obj say3D [_snd, _dis]};

	true

};

SAC_fnc_valueToBars = {

	if (!hasInterface) exitWith {};

	private ["_value", "_maxValue", "_barMaxChars", "_type", "_barsCount", "_bars", "_i"];

	_value = _this select 0; //el valor a convertir en barras
	_maxValue = _this select 1; //el valor que representaría el 100%
	_barMaxChars = _this select 2; //la cantidad de barras que indicarán el 100%
	_type = _this select 3; //"active": las barras que deben estar "encendidas"; "inactive": las barras que tienen que estar "apagadas".

	if (_value > _maxValue) exitWith {"_value cannot be bigger than _maxValue" call SAC_fnc_MPsystemChat};
	_value = _value max 0; //si el valor es negativo se hace 0 porque el indicador no marca valores negativos

	_barsCount = ceil ((_barMaxChars * _value) / _maxValue);

	_bars = "";

	if (_type == "inactive") then {_barsCount = _barMaxChars - _barsCount};

	for [{_i=0}, {_i<_barsCount}, {_i=_i+1}] do {
		_bars = _bars + "|";
	};

	_bars
};

SAC_fnc_valueToColor = {

	if (!hasInterface) exitWith {};

	private ["_value", "_maxValue", "_colorDanger", "_colorCaution", "_colorNormal", "_color", "_percentage", "_inverse"];

	_value = _this select 0;
	_maxValue = _this select 1;
	_inverse = _this select 2;

	_colorDanger = "#ff0000";
	_colorCaution = "#c8c800";
	_colorNormal = "#00c800";

	_color = "#0000ff";
	if (_value > _maxValue) exitWith {"value cannot be bigger than maxValue" call SAC_fnc_MPsystemChat};
	_percentage = (_value * 100) / _maxValue;
	switch (true) do {
		case (_percentage <= 25): {
			if (_inverse) then {_color = _colorNormal} else {_color = _colorDanger};
		};
		case ((_percentage > 25) && (_percentage <= 50)): {
			_color = _colorCaution;
		};
		case (_percentage > 50): {
			if (_inverse) then {_color = _colorDanger} else {_color = _colorNormal};
		};
	};

	_color

};

SAC_fnc_fatigueIndicator = {

	if (!hasInterface) exitWith {};

	private ["_show", "_title1", "_line1", "_line2", "_fatigue", "_dammage", "_fix_partialHealing"];

	_fix_partialHealing = if ("fix_partial_healing" in _this) then {true} else {false};

	_title1  = "<t color='#ffffff' size='1.2' shadow='1' shadowColor='#000000' align='center'>Status</t><br/><br/>";
	_line1 = "<t align='left'>Fatigue</t><br/>";

	_dammage = 0;

	_show = false;
	while {true} do {
/*
		_fatigue = getFatigue player;

		if (_fatigue > 0.4) then {_show = true} else {

			if (_fatigue == 0) then {


				if (_show) then {

					_line2 = format ["<t color='%3' align='left'>%1</t><t color='#111111' align='left'>%2</t><br/><br/>",
					[_fatigue, 1, 40, "active"] call SAC_fnc_valueToBars,
					[_fatigue, 1, 40, "inactive"] call SAC_fnc_valueToBars,
					[_fatigue, 1, true] call SAC_fnc_valueToColor];
					hint parseText (_title1 + _line1 + _line2);

				};

				_show = false;

			};

		};

		if (_show) then {

			_line2 = format ["<t color='%3' align='left'>%1</t><t color='#111111' align='left'>%2</t><br/><br/>",
			[_fatigue, 1, 40, "active"] call SAC_fnc_valueToBars,
			[_fatigue, 1, 40, "inactive"] call SAC_fnc_valueToBars,
			[_fatigue, 1, true] call SAC_fnc_valueToColor];
			hint parseText (_title1 + _line1 + _line2);

		};
*/
		if (_fix_partialHealing) then {

			if (_dammage > getDammage player) then {player setDammage 0};

			_dammage = getDammage player

		};

		sleep 1;
	};

};

SAC_fnc_shootFlare = {

	if (!hasInterface) exitWith {};

	private ["_flarePos", "_flareObject", "_shootType", "_distance"];

	//diag_log _this;
	_shootType = _this;

	if (_shootType == "long") then {_distance = 350} else {_distance = 50};

	_flarePos = getPos player getPos [_distance, getDir player];
	_flareObject = (selectRandom SAC_flares) createVehicle [_flarePos select 0, _flarePos select 1, (_flarePos select 2) + 250];
	_flareObject setVelocity [35,0,-10];
	//[_flareObject] spawn SAC_fnc_createFlareLight;

};

SAC_fnc_setRespawn = {

	if (!isMultiplayer) then {

		if (SAC_sp_respawn_gear != "ROLE") then {[player] spawn SAC_fnc_updateSavedGear};

		"respawn" setMarkerPos getPos player;

	} else {

		"respawn_west" setMarkerPos getPos player;
		"respawn_guerrila" setMarkerPos getPos player;
		"respawn_east" setMarkerPos getPos player;

	};

};

SAC_fnc_createMarker = {
/*
	[_pos, _color, _text, [_type], [_size], [_shape, _brush]] call SAC_fnc_createMarker;

	Ejemplos:
	[_centerPos, "ColorBlue", ""] call SAC_fnc_createMarker;
	[_centerPos, "ColorBlue", "", "mil_destroy"] call SAC_fnc_createMarker;
	[_centerPos, "ColorBlue", "", "", [0.5, 0.5]] call SAC_fnc_createMarker;
	[_centerPos, "ColorBlue", "", "", [100, 100], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;
	[_centerPos, "ColorBlue", "", "", [100, 100], ["ELLIPSE", "Solid"]] call SAC_fnc_createMarker;
*/

	private ["_marker"];

	_marker = createMarker [format["SAC_markers_%1_%2", random 1, random 1], (_this select 0)];
	if (count _this > 5) then {
		_marker setMarkerShape ((_this select 5) select 0);
		_marker setMarkerBrush ((_this select 5) select 1);
	} else {
		_marker setMarkerType (if (count _this > 3) then {if ((_this select 3) != "") then {(_this select 3)} else {"mil_dot_noshadow"}} else {"mil_dot_noshadow"});
		_marker setMarkerText (_this select 2);
	};
	_marker setMarkerColor (_this select 1);
	_marker setMarkerSize (if (count _this > 4) then {(_this select 4)} else {[1, 1]});

	_marker

};

SAC_fnc_createMarkerLocal = {
/*
	[_pos, _color, _text, [_type], [_size], [_shape, _brush]] call SAC_fnc_createMarkerLocal;

	Ejemplos:
	[_centerPos, "ColorBlue", ""] call SAC_fnc_createMarkerLocal;
	[_centerPos, "ColorBlue", "", "mil_destroy"] call SAC_fnc_createMarkerLocal;
	[_centerPos, "ColorBlue", "", "", [0.5, 0.5]] call SAC_fnc_createMarkerLocal;
	[_centerPos, "ColorBlue", "", "", [100, 100], ["ELLIPSE", "Border"]] call SAC_fnc_createMarkerLocal;
*/

	private ["_marker"];

	_marker = createMarkerLocal [format["SAC_markers_%1_%2", random 1, random 1], (_this select 0)];
	if (count _this > 5) then {
		_marker setMarkerShapeLocal ((_this select 5) select 0);
		_marker setMarkerBrushLocal ((_this select 5) select 1);
	} else {
		_marker setMarkerTypeLocal (if (count _this > 3) then {if ((_this select 3) != "") then {(_this select 3)} else {"mil_dot"}} else {"mil_dot"});
		_marker setMarkerTextLocal (_this select 2);
	};
	_marker setMarkerColorLocal (_this select 1);
	_marker setMarkerSizeLocal (if (count _this > 4) then {(_this select 4)} else {[1, 1]});

	_marker

};

SAC_fnc_createMarkerAroundBuilding = {

	params ["_building", "_color"];
	
	private _boundingBox = boundingBoxReal _building;
	//private _boundingBox = boundingBox _building;
	private _p1 = _boundingBox select 0;
	private _p2 = _boundingBox select 1;
	//private _boundingSphereDiameter = _boundingBox select 2;
	
	private _xSize = abs ((_p2 select 0) - (_p1 select 0));
	private _ySize = abs ((_p2 select 1) - (_p1 select 1));
	
	//[getPos _building, "ColorBlue", "", "", [_boundingSphereDiameter, _boundingSphereDiameter], ["ELLIPSE", "Border"]] call SAC_fnc_createMarkerLocal;
	
	private _marker = [getPos _building, _color, "", "", [_xSize / 2, _ySize / 2], ["RECTANGLE", "Border"]] call SAC_fnc_createMarkerLocal;
	_marker setMarkerDirLocal (getdir _building);
	
	_marker


};

SAC_fnc_markBoundingSphere = {

	params ["_o", "_c"];
	
	private _sd = (boundingBox _o) select 2;
	private _p = getPosATL _o;
	_p set [2, 0];
	
	_m = [_p, _c, "", "", [_sd, _sd], ["ELLIPSE", "Solid"]] call SAC_fnc_createMarkerLocal;
	
	_m

};

SAC_fnc_ammoCount = {

	private ["_magazineType", "_ammoCount", "_unit", "_has_magazines"];

	_unit = _this select 0;

	_has_magazines = true;

	//Si la unidad está recargando el arma necesita un tratamiento especial.
	if (count (primaryWeaponMagazine _unit) == 0) then {

		sleep 3; //aumentar si sigue dando problemas, hay que darle tiempo a que recargue si tiene cargadores
		if (count (primaryWeaponMagazine _unit) == 0) then {

			_has_magazines = false;

		};
	};

	if (_has_magazines) then {

		_magazineType = (primaryWeaponMagazine _unit) select 0;

		_ammoCount = ({_x == _magazineType} count magazines _unit) + 1; //le sumo 1 porque a la magazine puesta en el arma no la devuelve "magazines"

	} else {

		_ammoCount = 0;

	};

	_ammoCount

};

SAC_fnc_addItems = {

	params ["_unit", "_item", "_number"];

	private _added = 0;
	
	while {({_x == _item} count items _unit < _number) && {_unit canAdd _item}} do {

		_unit addItem _item;
		_added = _added + 1;

	};

	_added

};

SAC_fnc_addMagazines = {

	params ["_unit", "_magType", "_count"];

	private ["_added"];

	_added = 0;
	
	//diag_log _this;

	while {(_count > 0) && {_unit canAddItemToUniform _magType}} do {

		_unit addItemToUniform _magType;

		_count = _count - 1;
		_added = _added + 1;

	};

	while {(_count > 0) && {_unit canAddItemToVest _magType}} do {

		_unit addItemToVest _magType;

		_count = _count - 1;
		_added = _added + 1;

	};

	while {(_count > 0) && {_unit canAddItemToBackpack _magType}} do {

		_unit addItemToBackpack _magType;

		_count = _count - 1;
		_added = _added + 1;

	};
	
	_added

};

SAC_fnc_addPrimaryMagazines = {

	params ["_unit", "_number"];

	private _primWpnMags = primaryWeaponMagazine _unit;
	
	if (count _primWpnMags > 0) then {

		[_unit, _primWpnMags select 0, _number] call SAC_fnc_addItems;
		
	};

};

SAC_fnc_getMagazineTypes = {

	private ["_weapon", "_magazines"];

	_weapon = _this select 0;

	_magazines = [];

	if (isClass (configFile / "CfgWeapons" / _weapon)) then {

		_magazines = getArray (configFile / "CfgWeapons" / _weapon / "magazines");

	};

	_magazines

};
/*
SAC_fnc_isMedic = {

	// Authored by chessmaster42
	// Based on 'A3 Wounding System' by Psychobastard


	private ["_healer","_isMedic"];
	_healer = _this select 0;


	//Check if the class of the healer contains the attendant attribute
	//TODO - Improvements to allow more unit types to be healers
	_isMedic = if (getNumber (configFile >> "CfgVehicles" >> (typeOf _healer) >> "attendant") == 1) then {true} else {false};


	_isMedic


};
*/
SAC_fnc_isMedic = {

	params ["_unit"];

	_unit getUnitTrait "Medic"

};

SAC_fnc_findLocation = {

	private ["_centralPos", "_minDistance", "_maxDistance", "_tooCloseLocations", "_allLocations", "_inRangeLocations", "_validLocations",
	"_location", "_method", "_noplayerDistance", "_blacklist", "_locationPos", "_inAngleSector"];

	//diag_log _this;

	_centralPos = _this select 0;
	_minDistance = _this select 1;
	_maxDistance = _this select 2; //pasar 999 para deshabilitar la distancia máxima
	_noplayerDistance = _this select 3; //pasar 999 para deshabilitar la zona de exclusión alrededor de los jugadores
	_blacklist = _this select 4; //un array de áreas indicadas por markers ó triggers
	_method = if ("closest" in _this) then {"closest"} else {"random"};
	_inAngleSector = if (count _this > 6) then {_this select 6} else {999};

	_tooCloseLocations = nearestLocations [_centralPos, ["NameCityCapital", "NameCity", "NameVillage"], _minDistance];
	_allLocations = if (_maxDistance != 999) then {nearestLocations [_centralPos, ["NameCityCapital", "NameCity", "NameVillage"], _maxDistance]} else {
		nearestLocations [_centralPos, ["NameCityCapital", "NameCity", "NameVillage"], 50000]};
	_inRangeLocations = _allLocations - _tooCloseLocations;

	//diag_log _inRangeLocations;

	_validLocations = [];
	{

		if ((count _blacklist == 0) || {[_x call SAC_fnc_locationPosition, _blacklist] call SAC_fnc_isNotBlacklisted}) then {

			if ((_noplayerDistance == 999) || {[_x call SAC_fnc_locationPosition, _noplayerDistance] call SAC_fnc_notNearPlayers}) then {

				if ((_inAngleSector == 999) || {[_centralPos, _inAngleSector, 80, _x call SAC_fnc_locationPosition] call BIS_fnc_inAngleSector}) then {

					_validLocations pushBack _x;
				};
			};
		};

	} forEach _inRangeLocations;

	_location = locationNull;

	if (count _validLocations > 0) then {

		if (_method == "random") then {

			_location = selectRandom _validLocations;

		} else {

			//diag_log _validLocations;
			_location = _validLocations select 0;

		};
	};

	_location

};

SAC_sp_respawn = {

	private ["_player", "_killer", "_distanceToPlayer", "_candidateUnit", "_grp"];

	_player = _this select 0;
	_killer = _this select 1;
	
	setAccTime 0;

	if ((units group player) findIf {alive _x} != -1) then {

		_distanceToPlayer = 100000;
		{
			if ((alive _x) && (_x distance _player < _distanceToPlayer)) then {_candidateUnit = _x; _distanceToPlayer = _x distance _player}; // ****************** Acá se decide cual unidad va a ser player.
		} foreach units group _player;

		//sleep 2; no puede haber "sleeps" si el codigo es "called" desde un evetHandler

		addSwitchableUnit _candidateUnit;
		_candidateUnit setRank "MAJOR";
		_candidateUnit assignTeam "MAIN";
		selectPlayer _candidateUnit;

		waitUntil {_candidateUnit == player};

		SAC_player_SL1 = player;

		group player selectLeader player;

	} else {
	
		titleText ["", "BLACK FADED", 200];
		0 fademusic 0;
		0 fadeSound 0;
		0 fadeRadio 0;

		_candidateUnit = SAC_sp_respawn_playerGroup createUnit [SAC_sp_respawn_playerClass, getMarkerPos "respawn", [], 0, "NONE"];
		_candidateUnit setVariable ["BIS_enableRandomization", false];

		addSwitchableUnit _candidateUnit;
		_candidateUnit setRank "MAJOR";
		//_candidateUnit assignTeam "MAIN";
		selectPlayer _candidateUnit;

		waitUntil {_candidateUnit == player};

		SAC_player_SL1 = player;

		// player setVariable ["SAC_SQUAD_ROLE", SAC_sp_respawn_playerRole, false];

		if (SAC_sp_respawn_gear != "ROLE") then {

			[] spawn {

				sleep 1;
				call compile SAC_fnc_applySavedGear;
			};

		} else {

			if (!isNil "SAC_SQUAD") then {[player, SAC_SQUAD_loadoutProfile, "SL", SAC_SQUAD_silencer] call SAC_GEAR_applyLoadout};

		};

		deleteVehicle _player;

		setAccTime 1;

		titleText ["", "BLACK IN", 1];

		1 fademusic 1;
		1 fadeSound 1;
		1 fadeRadio 1;


	};

	player addEventHandler ["killed", {_this spawn SAC_sp_respawn}];

	if (SAC_sp_respawn_place == "MOBILE") then {

		private ["_title", "_scriptCode", "_priority", "_showWindow", "_hideOnUse", "_condition"];

		_title = "<t color='#FF0000'>Set respawn position</t>";
		_scriptCode = {[] call SAC_fnc_setRespawn}; //solo válido desde A3
		_priority = 1000;
		_showWindow = false;
		_hideOnUse = true;
		_condition = "isNull objectParent _this";
		player addAction [_title, _scriptCode, nil, _priority, _showWindow, _hideOnUse, "", _condition];

	};

	if ((!isNil "SAC_sp_respawn_arsenal") && {SAC_sp_respawn_arsenal}) then {

		player call SAC_fnc_addOpenArsenalAction;

		player setVariable ["SAC_GEAR_INITIALIZED", true, false];
		//["AmmoboxInit", [player, true, {false}]] call BIS_fnc_arsenal;

	};

};

SAC_fnc_select_position_in_map = {

	if (!hasInterface) exitWith {};

/*
	La función abre el mapa automáticamente. Después espera a que se haga click o se cierre el mapa. Se puede abortar haciendo SAC_fnc_select_position_in_map_cancel = true
	La función espera que las variables globales SAC_onMapSingleClick_Available y SAC_DefaultMapClick ya estén inicializadas.

*/

	if (SAC_onMapSingleClick_Available) then {

		SAC_mapCoordinates = [0,0,0];

		SAC_onMapSingleClick_Available = false;

		SAC_fnc_select_position_in_map_cancel = false;

		//hint "Click on the map to indicate the position.";
		//"defaultNotification" call SAC_fnc_playSound;
		private ["_selectedUnits"];

		_selectedUnits = groupSelectedUnits player;
		{player groupSelectUnit [_x, false]} forEach _selectedUnits;
		showCommandingMenu "";

		if (!visibleMap) then {openMap true};

		onMapSingleClick "hint """"; SAC_mapCoordinates = _pos; true";


		waitUntil {(SAC_mapCoordinates isNotEqualTo [0,0,0]) || SAC_fnc_select_position_in_map_cancel || !visibleMap};

		//hint "";

		{player groupSelectUnit [_x, true]} forEach _selectedUnits;

		SAC_onMapSingleClick_Available = true;

		onMapSingleClick SAC_DefaultMapClick;

		SAC_mapCoordinates

	} else {

		hint "La interfaz no esta disponible en este momento.";

		[0,0,0]

	};
};
/*
SAC_fnc_sizeOf = {

	private ["_bbr", "_p1", "_p2", "_maxWidth", "_maxLength", "_maxHeight"];

	//no uso boundingBoxReal porque la diferencia es poca, y parece mejor
	//tener ese margen como seguridad
	_bbr = boundingBoxReal _this;
	//_bbr = boundingBox _this;
	_p1 = _bbr select 0;
	_p2 = _bbr select 1;
	_maxWidth = abs ((_p2 select 0) - (_p1 select 0));
	_maxLength = abs ((_p2 select 1) - (_p1 select 1));
	_maxHeight = abs ((_p2 select 2) - (_p1 select 2));

	[_maxWidth, _maxLength, _maxHeight]


};
*/
SAC_fnc_isBuildingEmpty = {

	params ["_building"];
/*
	private ["_returnedArray", "_maxWidth", "_maxLength", "_maxHeight", "_bbr", "_p1", "_p2", "_maxWidth", "_maxLength", "_maxHeight", "_radius"];

	_returnedArray = _building call SAC_fnc_sizeOf;
	_maxWidth = _returnedArray select 0;
	_maxLength = _returnedArray select 1;

	//_radius = ((_maxWidth max _maxLength) / 2) * 1.1;

	//[getPos _building, "ColorRed", "", "", [_radius, _radius], ["ELLIPSE", "Border"]] call SAC_fnc_createMarker;

	//La corrección * 1.1 es porque el área de detección es circular y el edificio es cuadrado. Ya dió un resultado erróneo sin la corrección.
	if (count (getPos _building nearEntities ["Man", ((_maxWidth max _maxLength) / 2) * 1.1]) == 0) then {true} else {false};
*/

	//9/7/2017 [La desactivo porque] Me impide poner un civil en una casa y dejar que addGarrisons la ocupe. No creo que tenga efectos no deseados porque todas las demás funciones que ocupan edificios
	//los marcan con setVariable.
	true
	
};

#define I(X) X = X + 1;
#define EYE_HEIGHT 1.53
#define CHECK_DISTANCE 5
#define FOV_ANGLE 15
#define ROOF_CHECK 4
#define ROOF_EDGE 2

SAC_fnc_extendPosition = {
    private ["_center", "_dist", "_phi"];

    _center = _this select 0;
    _dist = _this select 1;
    _phi = _this select 2;

    ([(_center select 0) + (_dist * (cos _phi)),(_center select 1) + (_dist * (sin _phi)), (_this select 3)])
};

SAC_fnc_dirToClearView = {

	private ["_housePos", "_putOnRoof", "_startAngle", "_checkPos", "_i", "_hitCount", "_k", "_isRoof", "_edge", "_valid", "_validDir", "_lookAt", "_checkHeight"];

	_housePos = _this select 0;
	_checkDistance = _this select 1; //tiene que ser 5 según el código original
	_checkHeight = _this select 2; //tiene que ser 25 según el código original, evitando que la posición que tiene que observar esté bajo techo

	_housePos = [(_housePos select 0), (_housePos select 1), (_housePos select 2) + (getTerrainHeightASL _housePos) + EYE_HEIGHT];

	_putOnRoof = true;
	_valid = false;

	scopeName "main";

	_startAngle = (round random 10) * (round random 36);
	for "_i" from _startAngle to (_startAngle + 350) step 10 do {
		//_checkPos será un punto a la altura de los ojos del soldado, a _checkDistance, en la dirección de testeo
		_checkPos = [_housePos, _checkDistance, (90 - _i), (_housePos select 2)] call SAC_fnc_extendPosition;
		//comprueba que _checkPos no esté bajo techo
		if !(lineIntersects [_checkPos, [_checkPos select 0, _checkPos select 1, (_checkPos select 2) + _checkHeight], objNull, objNull]) then {
			//ahora sí comprueba línea de visión entre los ojos del soldado y la _checkPos
			if !(lineIntersects [_housePos, _checkPos, objNull, objNull]) then {
				_checkPos = [_housePos, _checkDistance, (90 - _i), (_housePos select 2) + (_checkDistance * sin FOV_ANGLE / cos FOV_ANGLE)] call SAC_fnc_extendPosition;
				if !(lineIntersects [_housePos, _checkPos, objNull, objNull]) then {
					_hitCount = 0;
					for "_k" from 30 to 360 step 30 do {
					    _checkPos = [_housePos, 20, (90 - _k), (_housePos select 2)] call SAC_fnc_extendPosition;
					    if (lineIntersects [_housePos, _checkPos, objNull, objNull]) then {
						  I(_hitCount)
					    };

					    if (_hitCount >= ROOF_CHECK) exitWith {};
					};

					_isRoof = (_hitCount < ROOF_CHECK) && {!(lineIntersects [_housePos, [_housePos select 0, _housePos select 1, (_housePos select 2) + 25], objNull, objNull])};
					if (!(_isRoof) || {((_isRoof) && {(_putOnRoof)})}) then {
						if (_isRoof) then {
							_edge = false;
							for "_k" from 30 to 360 step 30 do {
								_checkPos = [_housePos, ROOF_EDGE, (90 - _k), (_housePos select 2)] call SAC_fnc_extendPosition;
								_edge = !(lineIntersects [_checkPos, [(_checkPos select 0), (_checkPos select 1), (_checkPos select 2) - EYE_HEIGHT - 1], objNull, objNull]);

								if (_edge) exitWith {
								    _i = _k;
								};
							};
						};

						//if (!(_isRoof) || {_edge}) then {

							_valid = true;
							_validDir = _i;
							_lookAt = [];
							_lookAt = ([_housePos, _checkDistance, (90 - _i), (_housePos select 2) - (getTerrainHeightASL _housePos)] call SAC_fnc_extendPosition);

							breakTo "main";

							//(_units select _unitIndex) setPosASL [(_housePos select 0), (_housePos select 1), (_housePos select 2) - EYE_HEIGHT];
							//(_units select _unitIndex) setDir (_i );

							// if (_isRoof) then {
								// (_units select _unitIndex) setUnitPos "MIDDLE";
							// } else {
								// (_units select _unitIndex) setUnitPos "UP";
							// };

							//(_units select _unitIndex) lookAt ([_housePos, _checkDistance, (90 - _i), (_housePos select 2) - (getTerrainHeightASL _housePos)] call SAC_fnc_extendPosition);
							//doStop (_units select _unitIndex);

							// I(_unitIndex)
							// if (_fillEvenly) then {
								// breakTo "for";
							// } else {
								// breakTo "while";
							// };
						//};
					};
				};
			};
		};
	};

	if (_valid) then {[_validDir, _lookAt]} else {[999,[0,0,0]]};

};

SAC_fnc_notNearSide = {

	//[_pos, _side, _distance] call SAC_fnc_notNearSide;

	if ((_this select 0) isEqualTo [0,0,0]) then {"Error in SAC_fnc_notNearSide. Central position is not valid." call SAC_fnc_MPsystemChat};

	//11/5/2021 cambiado por optimización
	//if ((_this select 1) countSide ((_this select 0) nearEntities (_this select 2)) == 0) then {true} else {false};
	
	if (((_this select 0) nearEntities (_this select 2)) findIf {side _x == (_this select 1)} == -1) then {true} else {false}

};

SAC_fnc_notNearPlayerSide = {

	if ((_this select 0) isEqualTo [0,0,0]) then {"Error in SAC_fnc_notNearPlayerSide. Central position is not valid." call SAC_fnc_MPsystemChat};

	if (SAC_PLAYER_SIDE countSide ((_this select 0) nearEntities (_this select 2)) == 0) then {true} else {false}
	//if ([(_this select 0), SAC_PLAYER_SIDE, (_this select 1)] call SAC_fnc_notNearSide) then {true} else {false}

};

//11/5/2021 Reescribí esta función pensando que findIf sería una optimización, pero después de evaluar en qué casos
//estoy usando la función, quedó claro que la original usando countSide era mucho más eficiente.
/*
SAC_fnc_nearEnemies = {

	//devuelve un 'boolean'
	
	
	params ["_position" , "_side" , "_distance" ];
	
	
	private _nearEnemies = false;
	
	if (_side == civilian) exitWith {false};
	
	switch (_side) do {
		
		case west: {
		
			if ((_position nearEntities _distance) findIf {side _x == east} != -1) exitWith {_nearEnemies = true};
		
			if (([west, resistance] call BIS_fnc_sideIsEnemy) && {(_position nearEntities _distance) findIf {side _x == resistance} != -1}) exitWith {_nearEnemies = true};
		
		};

		case east: {
		
			if ((_position nearEntities _distance) findIf {side _x == west} != -1) exitWith {_nearEnemies = true};
		
			if (([east, resistance] call BIS_fnc_sideIsEnemy) && {(_position nearEntities _distance) findIf {side _x == resistance} != -1}) exitWith {_nearEnemies = true};
		
		};
		
		case resistance: {
		
			if (([resistance, west] call BIS_fnc_sideIsEnemy) && {(_position nearEntities _distance) findIf {side _x == west} != -1}) exitWith {_nearEnemies = true};
		
			if (([resistance, east] call BIS_fnc_sideIsEnemy) && {(_position nearEntities _distance) findIf {side _x == east} != -1}) exitWith {_nearEnemies = true};
		
		};
		
		default {
		
			(format["ERROR: SAC_fnc_nearEnemies - No se puede evaluar el bando especificado (%1).", _side]) call SAC_fnc_debugNotify;
			
		};
		
	};
	
	_nearEnemies

};
*/

SAC_fnc_nearEnemies = {

	//devuelve un 'boolean'
	
	
	params ["_position" , "_side" , "_distance" ];
	
	
	private _nearEnemies = false;
	
	if (_side == civilian) exitWith {false};
	
	switch (_side) do {
		
		case west: {
		
			if (east countSide (_position nearEntities _distance) != 0) exitWith {_nearEnemies = true};
		
			if (([west, resistance] call BIS_fnc_sideIsEnemy) && {resistance countSide (_position nearEntities _distance) != 0}) exitWith {_nearEnemies = true};
		
		};

		case east: {
		
			if (west countSide (_position nearEntities _distance) != 0) exitWith {_nearEnemies = true};
		
			if (([east, resistance] call BIS_fnc_sideIsEnemy) && {resistance countSide (_position nearEntities _distance) != 0}) exitWith {_nearEnemies = true};
		
		};
		
		case resistance: {
		
			if (([resistance, west] call BIS_fnc_sideIsEnemy) && {west countSide (_position nearEntities _distance) != 0}) exitWith {_nearEnemies = true};
		
			if (([resistance, east] call BIS_fnc_sideIsEnemy) && {east countSide (_position nearEntities _distance) != 0}) exitWith {_nearEnemies = true};
		
		};
		
		default {
		
			(format["ERROR: SAC_fnc_nearEnemies - No se puede evaluar el bando especificado (%1).", _side]) call SAC_fnc_debugNotify;
			
		};
		
	};
	
	_nearEnemies

};


SAC_fnc_notNearEnemies = {

	!(_this call SAC_fnc_nearEnemies)

};

SAC_fnc_countNearEnemies = {

	//devuelve la cantidad de unidades enemigas
	
	
	params ["_position" , "_side" , "_distance" ];
	
	
	private _nearEnemies = 0;
	
	if (_side == civilian) exitWith {0};
	
	switch (_side) do {
		
		case west: {
		
			_nearEnemies = _nearEnemies + (east countSide (_position nearEntities _distance));
		
			if ([west, resistance] call BIS_fnc_sideIsEnemy) then {

				_nearEnemies = _nearEnemies +  (resistance countSide (_position nearEntities _distance));
				
			};
		
		};

		case east: {
		
			_nearEnemies = _nearEnemies + (west countSide (_position nearEntities _distance));
		
			if ([east, resistance] call BIS_fnc_sideIsEnemy) then {

				_nearEnemies = _nearEnemies +  (resistance countSide (_position nearEntities _distance));
				
			};
			
		};
		
		case resistance: {
		
			if ([resistance, west] call BIS_fnc_sideIsEnemy) then {

				_nearEnemies = _nearEnemies +  (west countSide (_position nearEntities _distance));
				
			};
			
			if ([resistance, east] call BIS_fnc_sideIsEnemy) then {

				_nearEnemies = _nearEnemies +  (east countSide (_position nearEntities _distance));
				
			};		
		};
		
		default {
		
			(format["WARNING: SAC_fnc_nearEnemies - El bando especificado no es WEST, CIVILIAN, EAST, ni RESISTANCE (es %1).", _side]) call SAC_fnc_debugNotify;
			
		};
		
	};
	
	_nearEnemies

};


/*
SAC_fnc_isolatedBuildings = {

	private ["_centralPos", "_maxDistance", "_allBuildings", "_goodBuildings", "_minPositions", "_bannedTypes", "_blacklist", "_isolatedBuildings", "_spacing",
	"_tolerance"];

	_centralPos = _this select 0;
	_maxDistance = _this select 1; //recomendado: > 900
	_minPositions = _this select 2;
	_spacing = _this select 3; //recomendado: 100 <<<<<<<<< muy importante
	_tolerance = _this select 4; //recomendado: 5 <<<<<<<<< muy importante
	_bannedTypes = _this select 5;
	_blacklist = _this select 6; //un array de áreas indicadas por markers ó triggers

	_allBuildings = _centralPos nearObjects ["House", _maxDistance];

	_goodBuildings = [];
	{

		if ([getPos _x, _blacklist] call SAC_fnc_isNotBlacklisted) then {
			if !(typeOf _x in _bannedTypes) then {
				if (count (_x buildingPos -1) >= _minPositions) then {

					_goodBuildings pushBack _x;
				};
			};
		};

	} forEach _allBuildings;

	_isolatedBuildings = [];

	{

		_building = _x;

		//Los dos algoritmos dieron resultados aceptables, me quedo con el más simple por ahora.
		//if ({((_building distance _x > 50) && (_building distance _x <= 100))} count _allBuildings <= 1) then {
		if ({_building distance _x <= _spacing} count _allBuildings <= _tolerance) then {

			_isolatedBuildings pushBack _building;

			//[getPos _building, "ColorBlue", ""] call SAC_fnc_createMarker}

		// } else {

			//[getPos _building, "ColorRed", ""] call SAC_fnc_createMarker}

		};

	} forEach _goodBuildings;

	_isolatedBuildings

};
*/

SAC_fnc_cargoSeats = {

	//devuelve un número

	params ["_vehicle"];

	count fullCrew [_vehicle, "cargo", true];

};

SAC_fnc_emptyCargoSeats = {

	//devuelve un número

	params ["_vehicle"];

	{!alive (_x select 0)} count fullCrew [_vehicle, "cargo", true];

};

SAC_fnc_commonTurrets = {

	//devuelve un array con los path de las turrets que no son firing position capable

	params ["_vehicle"];

	private ["_commonTurretPositions"];

	_commonTurretPositions = [];
	{

		if (!(_x select 4) && {!(_vehicle lockedTurret (_x select 3))}) then {_commonTurretPositions pushBack (_x select 3)};

	} forEach fullCrew [_vehicle, "turret", true];

	_commonTurretPositions

};

SAC_fnc_emptyCommonTurrets = {

	//devuelve un array con los path de las turrets que no son firing position capable, y que están vacías

	params ["_vehicle"];

	private ["_commonTurretPositions"];

	_commonTurretPositions = [];
	{

		if (!(_x select 4) && {!alive (_x select 0)} && {!(_vehicle lockedTurret (_x select 3))}) then {_commonTurretPositions pushBack (_x select 3)};

	} forEach fullCrew [_vehicle, "turret", true];

	_commonTurretPositions

};

SAC_fnc_isCommonTurretEmpty = {

	params ["_vehicle", "_turretPath"];

	if (_turretPath in ([_vehicle] call SAC_fnc_emptyCommonTurrets)) then {true} else {false}

};

SAC_fnc_firstEmptyCommonTurret = {

	//devuelve un path a una turret vacía NO definida como person position, o sea NO firing from vehicles capable

	params ["_vehicle"];

	private ["_commonTurretPositions"];

	_commonTurretPositions = [_vehicle] call SAC_fnc_emptyCommonTurrets;

	if (count _commonTurretPositions > 0) then {_commonTurretPositions select 0} else {_commonTurretPositions}

};

SAC_fnc_personTurrets = {

	//devuelve un array

	params ["_vehicle"];

	private ["_personTurretPositions"];

	_personTurretPositions = [];
	{

		if ((_x select 4) && {!(_vehicle lockedTurret (_x select 3))}) then {_personTurretPositions pushBack (_x select 3)};

	} forEach fullCrew [_vehicle, "turret", true];

	_personTurretPositions

};

SAC_fnc_unitsInCargo = {

	params ["_vehicle"];

	private _unitsInCargo = [];

	{

		_unitsInCargo pushBack (_x select 0);

	} foreach (fullCrew [_vehicle, "cargo"]);

	{

		if (_x select 4) then {

			_unitsInCargo pushBack (_x select 0);

		};

	} foreach (fullCrew [_vehicle, "turret"]);

	_unitsInCargo

};

SAC_fnc_emptyPersonTurrets = {

	//devuelve un array

	params ["_vehicle"];

	private ["_personTurretPositions"];

	_personTurretPositions = [];
	{

		if ((_x select 4) && {!alive (_x select 0)} && {!(_vehicle lockedTurret (_x select 3))}) then {_personTurretPositions pushBack (_x select 3)};

	} forEach fullCrew [_vehicle, "turret", true];

	_personTurretPositions

};

SAC_fnc_firstEmptyPersonTurret = {

	//devuelve un path a una turret vacía definida como person position, o sea firing from vehicles capable

	params ["_vehicle"];

	private ["_personTurretPositions"];

	_personTurretPositions = [_vehicle] call SAC_fnc_emptyPersonTurrets;

	if (count _personTurretPositions > 0) then {_personTurretPositions select 0} else {_personTurretPositions}

};

SAC_fnc_isPersonTurretEmpty = {

	params ["_vehicle", "_turretPath"];

	if (_turretPath in ([_vehicle] call SAC_fnc_emptyPersonTurrets)) then {true} else {false}

};

SAC_fnc_emptyPositions = {

	//Devuelve la cantidad de unidades que podrían abordar un vehículo.
	
	//22/05/03 No tiene en cuenta que algunas posiciones podrían estar bloqueadas.

	params ["_vehicle"];

	count (fullCrew [_vehicle, "driver", true]) +  count (fullCrew [_vehicle, "commander", true]) + count (fullCrew [_vehicle, "gunner", true]) + count (fullCrew [_vehicle, "turret", true]) + count (fullCrew [_vehicle, "cargo", true]) - ({alive _x} count crew _vehicle)

};

SAC_fnc_hasCommander = {

	//devuelve un array

	params ["_vehicle"];

	(count (fullCrew [_vehicle, "commander", true]) > 0);

};

SAC_fnc_isCommanderLocked = {

	params ["_vehicle"];
	
	private _result = true;
	
	if ([_vehicle] call SAC_fnc_hasCommander) then {
	
		//select 3 es el turretPath del commander
		_result = _vehicle lockedTurret (((fullCrew [_vehicle, "commander", true]) select 0) select 3);
	
	};
	
	_result

};

SAC_fnc_isGunnerLocked = {

	params ["_vehicle"];
	
	//select 3 es el turretPath del gunner
	(_vehicle lockedTurret (((fullCrew [_vehicle, "gunner", true]) select 0) select 3))

};

SAC_fnc_hasGunner = {

	//devuelve un array

	params ["_vehicle"];

	(count (fullCrew [_vehicle, "gunner", true]) > 0)

};

SAC_fnc_garbageCollector = {

/*

	Toma un array de objetos, triggers, grupos, y marcadores, y los borra apenas pueda. Sale cuando no quedan más elementos en el array.

	_items					un array de objetos, triggers, grupos, y marcadores
	_positions				una lista de posiciones de las cuales los items del array tienen que estar también lejos para que se puedan borrar, pasar un array vacío si no hay posiciones que considerar
	_proximityMode			units proximity mode: 0 = instantáneo, 1 = jugadores, 2 = lado
	_distances				[dist. desde "players" o "side", dist. desde las posiciones]
	_checkInterval			el intervalo con el que se checkea, antes de ser variable estaba en 20 segundos (sería el valor legacy)
	_side					el lado que no puede estar cerca si se elige el modo de proximidad 2
	_aliveCheck				si es true sólo borra unidades muertas, si es false las borra aunque estén vivas
	_TTLCheck				si es true, sólo borra las unidades que time > _unit getVariable ["SAC_TTL", 0]

	Ejemplos:
	[_markers + _units + _groups + _vehicles, [], 1, [1500, 1500], 20, west, false, false] spawn SAC_fnc_garbageCollector						Borrar lo que esté a +1500 de cualquier jugador.
	[_markers + _units + _groups + _vehicles, [pos1, pos2], 1, [1500, 1500], 20, west, false, false] spawn SAC_fnc_garbageCollector			Borrar lo que esté a +1500 de players y posiciones.
	[_markers + _units + _groups + _vehicles, [], 0, [], 20, west, false, false] spawn SAC_fnc_garbageCollector										Borrar todo sin consideración.
	[_markers + _units + _groups + _vehicles, [pos1, pos2], 0, [1500, 1500], 20, west, false, false] spawn SAC_fnc_garbageCollector			Borrar lo que esté a +1500 de cualquier posición.
	[_markers + _units + _groups + _vehicles, [], 2, [1500, 1500], 20, SAC_SIDE_PLAYER, false, false] spawn SAC_fnc_garbageCollector			Borrar lo que esté a +1500 de cualquier SAC_SIDE_PLAYER.
	[_units + _groups + _vehicles, [pos1, pos2], 1, [500, 1000], 20, west, false, false] spawn SAC_fnc_garbageCollector							Borrar lo que esté a +500 de players y +1000 de posiciones.

*/

	params ["_items", "_positions", "_proximityMode", "_distances", "_checkInterval", "_side", "_aliveCheck", "_TTLCheck"];

	private ["_irrelevant", "_distFromUnits", "_distFromPositions"];

	_distFromUnits = _distances select 0;
	_distFromPositions = _distances select 1;

	_irrelevant = [];

	while {(count _items > 0)} do {

		{

			switch (typeName _x) do {

				case "STRING": {

					_irrelevant pushBack _x;
					deleteMarker _x;

				};

				case "OBJECT": {

					if (typeOf _x == "EmptyDetector") then {

						_irrelevant pushBack _x;
						deleteVehicle _x;

					} else {

						if ((!_aliveCheck) || {!alive _x}) then {

							if ((!_TTLCheck ) || {_x getVariable ["SAC_TTL", 0] > time}) then {

								switch (_proximityMode) do {

									case 0: {

										if ((count _positions == 0) || {[getPos _x, _distFromPositions, _positions] call SAC_fnc_notNearPositions}) then {

											_irrelevant pushBack _x;
											
											if (_x isKindOf "Man") then {
											
												[_x] call SAC_fnc_deleteUnit;
											
											} else {
											
												deleteVehicle _x;
												
											};

										};

									};

									case 1: {

										if (([getPos _x, _distFromUnits] call SAC_fnc_notNearPlayers) && {(count _positions == 0) || [getPos _x, _distFromPositions, _positions] call SAC_fnc_notNearPositions}) then {

											_irrelevant pushBack _x;
											
											if (_x isKindOf "Man") then {
											
												[_x] call SAC_fnc_deleteUnit;
											
											} else {
											
												deleteVehicle _x;
												
											};

										};

									};

									case 2: {

										if (([getPos _x, _side, _distFromUnits] call SAC_fnc_notNearSide) && {(count _positions == 0) || [getPos _x, _distFromPositions, _positions] call SAC_fnc_notNearPositions}) then {

											_irrelevant pushBack _x;
											
											if (_x isKindOf "Man") then {
											
												[_x] call SAC_fnc_deleteUnit;
											
											} else {
											
												deleteVehicle _x;
												
											};

										};

									};

									default {

										"Invalid _proximityMode in SAC_fnc_garbageCollector!" call SAC_fnc_MPsystemChat;
										(typeOf _x) call SAC_fnc_MPsystemChat;

									};

								};

							};

						};

					};


				};

				case "GROUP": {

					//No usar ((units _x) findIf {alive _x} == -1) como condición para borrar el grupo, porque hasta que el engine no quita por su cuenta las
					//a las unidades muertas del grupo, el mismo no se puede borrar.

					if (count units _x == 0) then {

						_irrelevant pushBack _x;
						deleteGroup _x;

					};

				};

				case default {

					"SAC_fnc_garbageCollector invalid type." call SAC_fnc_MPsystemChat;
					(typeName _x) call SAC_fnc_MPsystemChat;

				};
			};

		} forEach _items;

		if (count _irrelevant != 0) then {_items = _items - _irrelevant};

		systemChat format["GC:%1 - %2", str count _irrelevant, count _items];

		_irrelevant = [];

		sleep _checkInterval; //la versión con intervalo fijo usaba 20 segundos

	};

};

SAC_fnc_nearPositions = {

	private ["_distance", "_object", "_positions"];

	_object = _this select 0;
	_distance = _this select 1;
	_positions = _this select 2;

	_near = false;

	{

		if (_x distance _object < _distance) exitWith {_near = true};

	} forEach _positions;

	_near

};

SAC_fnc_notNearPositions = {

	!(_this call SAC_fnc_nearPositions)

};

SAC_fnc_irrelevantItems = {
/*
	Acepta un array de grupos, ó de objetos (no de ambos), borra todos los que sean "irrelevantes" por estar vacíos, ó lejos de players y posiciones, respectivamente,
	y devuelve la lista para que la rutina que la llamó opere sobre las listas de grupos y unidades globales, por ejemplo.
	NOTA: También soporta triggers, pero los trata con el criterio para objetos. Funciona para AMBUSH, habría que ver para otros módulos.
	NOTA 2: Si el parámetro _distance_from_units == 0, no se tienen en cuenta los jugadores ni las demás unidades para la definición de "irrelevante".

	Ejemplos:

	SAC_CTS_vehicles = SAC_CTS_vehicles - ([SAC_CTS_vehicles, [_centralPos], 2000, 3000, "players"] call SAC_fnc_irrelevantItems);
	Considera irrelevantes las unidades que estén a más de 2000 mts. de cualquier jugador, y a más de 3000 de _centralPos.

	SAC_CTS_groups = SAC_CTS_groups - ([SAC_CTS_groups, [], 0, 0] call SAC_fnc_irrelevantItems);
	Si todos los elementos son grupos, ningún otro parámetro hace falta, y pueden tener cualquier valor.

	SAC_QRF_units = SAC_QRF_units - ([SAC_QRF_units, [], 1500, 0, "side", "ignore_flying"] call SAC_fnc_irrelevantItems);
	Considera irrelevantes las unidades que estén a más de 1500 mts. de cualquier jugador, y en tierra, ignorando las unidades volando.

	SAC_MTS_vehicles = SAC_MTS_vehicles - ([SAC_MTS_vehicles, [_centralPos], 2000, 3000, "side"] call SAC_fnc_irrelevantItems);
	Considera irrelevantes las unidades que estén a más de 2000 mts. de cualquier unidad del lado del jugador, y a más de 3000 de _centralPos.

*/
	private ["_irrelevant", "_positions", "_items", "_distance_from_positions", "_distance_from_units"];

	_items = _this select 0;
	_positions = _this select 1;
	_distance_from_units = _this select 2;
	_distance_from_positions = _this select 3;

	_irrelevant = [];

	{

		switch (typeName _x) do {

			case "OBJECT": {

				if (isNull _x) then {

					_irrelevant pushBack _x;

				} else {

					if (!("ignore_flying" in _this) || {[_x] call SAC_fnc_isNotFlying}) then {

						if ((_distance_from_positions == 0) || {[_x, _distance_from_positions, _positions] call SAC_fnc_notNearPositions}) then {

							if (!("players" in _this) || {(_distance_from_units == 0) || {[_x, _distance_from_units] call SAC_fnc_notNearPlayers}}) then {

								if (!("side" in _this) || {(_distance_from_units == 0) || {[_x, _distance_from_units] call SAC_fnc_notNearPlayerSide}}) then {

									_irrelevant pushBack _x;

									//SAC_CARS tiene que liberar la casa a la que se asignó el auto antes de borrarlo.
									if (!isNull(_x getVariable ["SAC_CARS_house", objNull])) then {(_x getVariable "SAC_CARS_house") setVariable ["SAC_CARS_assigned", 0]};
									
									if (_x isKindOf "Man") then {
									
										[_x] call SAC_fnc_deleteUnit;
										
									} else {
									
										deleteVehicle _x;
									
									};

								};

							};

						};

					};

				};

			};

			case "GROUP": {

				//No usar (units _x) findIf {alive _x} == -1) como condición para borrar el grupo, porque hasta que el engine no quita por su cuenta
				//a las unidades muertas del grupo, el mismo no se puede borrar.

				if (count units _x == 0) then {

					_irrelevant pushBack _x;
					deleteGroup _x;

				};

			};

			case default {

				"SAC_fnc_irrelevantItems invalid type." call SAC_fnc_MPsystemChat;
				(typeName _x) call SAC_fnc_MPsystemChat;

			};
		};

	} forEach _items;

	_irrelevant

};

SAC_fnc_behaviour_crashed_crew = {

	params ["_crewGrp", "_removeHelmets"];

	if (units _crewGrp findIf {alive _x} != -1) then {

		{

			[_x, _removeHelmets] spawn {

				params ["_unit", "_removeHelmets"];
				waitUntil{((getPos vehicle _unit) select 2 <= 2) || (!alive _unit)};
				if (alive _unit) then {
					doGetOut _unit;
					if (_removeHelmets) then {removeHeadgear _unit};
					_unit unlinkItem "NVGoggles";
					_unit unlinkItem "NVGoggles_OPFOR";
					_unit unlinkItem "NVGoggles_INDEP";
					_unit enableAI "TARGET";
				};

			};

		} forEach units _crewGrp;

	};

	//"_items", "_positions", "_proximityMode", "_distances", "_checkInterval", "_side", "_aliveCheck", "_TTLCheck"
	[[_crewGrp] + units _crewGrp, [], 1, [600, 0], 120, civilian, false, false] spawn SAC_fnc_garbageCollector;


};

SAC_fnc_openableDoors = {

	switch (typeOf _this) do {
		case "I_Heli_light_03_F": {
			[]
		};
		case "MEF_USMC_Hummingbird";
		case "I_Heli_light_03_unarmed_F": {
			[]
		};
		case "CH49_Mohawk_FG";
		case "W_Merlin";
		case "I_Heli_Transport_02_F": {
			["CargoRamp_Open", "Door_Back_L", "Door_Back_R"]
		};
		case "B_Heli_Light_01_F": {
			[]
		};
		case "MEF_USMC_Ghosthawk";
		case "B_Heli_Transport_01_F";
		case "B_Heli_Transport_01_camo_F": {
			["door_R", "door_L"]
		};
		case "MEF_USMC_Huron";
		case "B_Heli_Transport_03_unarmed_F";
		case "B_Heli_Transport_03_F": {
			["Door_rear_source"]
		};
		case "O_Heli_Light_02_F";
		case "O_Heli_Light_02_v2_F";
		case "O_Heli_Light_02_unarmed_F": {
			[]
		};
		case "O_Heli_Transport_04_covered_F": {
			//["Door_1_source", "Door_2_source", "Door_3_source", "Door_4_source", "Door_5_source", "Door_6_source"]
			["Door_4_source", "Door_5_source", "Door_6_source"]
		};
		case "O_Heli_Transport_04_F";
		case "O_Heli_Transport_04_bench_F": {
			[]
		};
		case "O_Heli_Attack_02_F";
		case "O_Heli_Attack_02_black_F": {
			["door_L", "door_R"]
		};
		case "Cha_UH60M_US";
		case "Cha_UH60L_US": {
			["Doors"]
		};
		case "RHS_CH_47F_light";
		case "RHS_CH_47F_10";
		case "RHS_CH_47F": {
			["ramp_anim"]
		};
		case "RHS_UH60M";
		case "RHS_UH60M_d": {
			["DoorRB", "DoorLB"]
		};
		default {

			[]

		};
	};
};

SAC_fnc_createLight = {

	//Ej: _light = [_pos, [1,0,0], 0.5] call SAC_fnc_createLight;

	_light = "#lightpoint" createVehicle (_this select 0);
	_light setLightBrightness (_this select 2);
	_light setLightColor (_this select 1);
	_light setLightAmbient (_this select 1);

	_light

};

SAC_fnc_autoRefuel = {

	private ["_vehicle"];

	_vehicle = _this select 0;

	while {(alive _vehicle) && (canMove _vehicle)} do {

		sleep (5*60);

		if ((!alive _vehicle) || (!canMove _vehicle)) exitWith {};

		_vehicle setFuel 1;

	};

};

SAC_fnc_putEarplugs = {

	1 fademusic 0.2;
	1 fadeSound 0.2;
	1 fadeRadio 0.2;
};

SAC_fnc_removeEarplugs = {

	1 fademusic 1;
	1 fadeSound 1;
	1 fadeRadio 1;

};

/*
SAC_fnc_addEarProtectionActions = {

	if (!hasInterface) exitWith {};

	private ["_unit", "_title", "_scriptCode", "_priority", "_showWindow", "_hideOnUse", "_condition"];

	_unit = _this;

	waitUntil {!isNull _unit};

	_title = "<t color='#00FF00'>Put earplugs</t>";
	_scriptCode = {[] spawn SAC_fnc_putEarplugs}; //solo válido desde A3
	_priority = 1000;
	_showWindow = false;
	_hideOnUse = true;
	_condition = "true";
	player addAction [_title, _scriptCode, nil, _priority, _showWindow, _hideOnUse, "", _condition];

	_title = "<t color='#00FF00'>Remove earplugs</t>";
	_scriptCode = {[] spawn SAC_fnc_removeEarplugs}; //solo válido desde A3
	_priority = 1000;
	_showWindow = false;
	_hideOnUse = true;
	_condition = "true";
	player addAction [_title, _scriptCode, nil, _priority, _showWindow, _hideOnUse, "", _condition];

};
*/

SAC_fnc_locationPosition = {

	_p = locationPosition _this;

	[_p select 0, _p select 1, 0]

};

SAC_fnc_tacticalDisembark = {

	params ["_cargoUnits", "_vehicle"];
	
	private ["_vehDir", "_step", "_dir", "_position", "_vPos", "_opDir", "_positions", "_lookPos"];

	_cargoUnits = _cargoUnits - allPlayers;
	
	if (count _cargoUnits == 0) exitWith {};
	
	_vPos = getPos _vehicle;

	_vehDir = getDir _vehicle; //funciona como un offset

	_cargoUnits = _cargoUnits - allPlayers;

	_step = 360 / count _cargoUnits;

	//_oposite = false;

	_dir = _vehDir;

	_positions = [];
	
	//06/11/2021 cambio de algoritmo
/*
	{

		if (!_oposite) then {
			_dir = _dir + _step;
			if (_dir < 0) then {_dir = _dir + 360};
			if (_dir > 360) then {_dir = _dir - 360};
			_position = _vPos getPos [10, _dir];
			_oposite = true;
		} else {
			_opDir = _dir + 180;
			if (_opDir < 0) then {_opDir = _opDir + 360};
			if (_opDir > 360) then {_opDir = _opDir - 360};
			_position = _vPos getPos [10, _opDir];
			_oposite = false;
		};

		_positions pushBack _position;


	} forEach _cargoUnits;
*/	
	_dir = _dir + (_step / 2);
	{


		_dir = _dir + _step;
		if (_dir < 0) then {_dir = _dir + 360};
		if (_dir > 360) then {_dir = _dir - 360};
		_position = _vPos getPos [10, _dir];

		_positions pushBack _position;


	} forEach _cargoUnits;

	{

		_position = [_positions, getPos _x] call BIS_fnc_nearestPosition;

		_positions = _positions - [_position];

		_lookPos = _vehicle getPos [20, _vehicle getDir _position];

		[_x, _position, _lookPos] spawn {

			private ["_u", "_v", "_p", "_l"];
			_u = _this select 0;
			_p = _this select 1;
			_l = _this select 2;
			_v = vehicle _u;
			waitUntil {isNull objectParent _u};
			_u disableCollisionWith _v;
			waitUntil {unitReady _u};
			_u doMove _p;
			sleep 5;
			_u enableCollisionWith _v;
			waitUntil {unitReady _u};
			_u lookAt _l;
			if (!isNil "SAC_SQUAD_endStance") then {_u setUnitPos SAC_SQUAD_endStance} else {_u setUnitPos "MIDDLE"};

		};


	} forEach _cargoUnits;

	doGetOut _cargoUnits;

};
/*
SAC_fnc_requestThermal = {

	private ["_focusPos", "_radius", "_markers", "_unit", "_size"];

	_focusPos = _this select 0;
	_radius = _this select 1;

	_markers = [];

	if !([] call SAC_fnc_isNight) then {

		_markers pushBack ([_focusPos, "ColorBlack", "", "", [_radius, _radius], ["ELLIPSE", "Solid"]] call SAC_fnc_createMarker);
	};

	{

		_unit = _x;

		_size = switch (true) do {

			case (_x isKindof "CAManBase"): {0.5};
			case (_x isKindof "Air"): {0.6};
			case (_x isKindof "LandVehicle"): {0.6};
			case default {0.1};

		};

		_markers pushBack ([getPos _unit, "ColorWhite", "", "", [_size, _size]] call SAC_fnc_createMarker);


	} forEach (_focusPos nearEntities [["LandVehicle","Air","CAManBase"], _radius]);

	if (!visibleMap) then {openMap true};

	sleep 10;

	{

		deleteMarker _x;

	} forEach _markers;

};
*/

SAC_fnc_loadToVehicle = {

	private ["_cargo", "_nVehicle"];

	_cargo = _this;

	_nVehicle = nearestObject [_cargo, "Car"];

	if (isNull _nVehicle) exitWith {}; //no hace nada si no encuentra ningún vehículo

	_nVehicle setVariable ["SAC_CARGO_class", typeOf _cargo, true];

	deleteVehicle _cargo;

	private ["_title", "_scriptCode", "_arguments", "_priority", "_showWindow", "_hideOnUse", "_condition"];
	_title = "<t color='#FF8080'>Unload cargo</t>";
	_scriptCode = {[(_this select 0), (_this select 2)] call SAC_fnc_unloadFromVehicle}; //solo válido desde A3
	_arguments = "";
	_priority = 1000;
	_showWindow = false;
	_hideOnUse = true;
	_condition = "isNull objectParent _this";

	_nVehicle addAction [_title, _scriptCode, _arguments, _priority, _showWindow, _hideOnUse, "", _condition];


};

SAC_fnc_unloadFromVehicle = {

	if (!hasInterface) exitWith {};

	private ["_actionID", "_cargo", "_vehicle", "_cargoClass", "_cargoPos"];

	_vehicle = _this select 0;

	_actionID = _this select 1;

	_cargoClass = _vehicle getVariable ["SAC_CARGO_class", "NONE"];

	if (_cargoClass == "UNDEFINED") exitWith {hint "No cargo found."};

	_cargoPos = (getPos _vehicle) findEmptyPosition [0, 20, _cargoClass];

	if (count _cargoPos == 0) exitWith {hint "There's no enough room to unload cargo."};

	_cargo = createVehicle [_cargoClass, _cargoPos, [], 0, "NONE"];
	//workaround porque por algún motivo cuando creo las cajas empiezan a tomar daño y no paran hasta que explotan.
	_cargo allowDammage false;
	_cargo setDammage 0;
	_cargo setPosATL _cargoPos;

	private ["_title", "_scriptCode", "_arguments", "_priority", "_showWindow", "_hideOnUse", "_condition"];
	_title = "<t color='#FF8080'>Load to nearest vehicle</t>";
	_scriptCode = {(_this select 0) call SAC_fnc_loadToVehicle}; //solo válido desde A3
	_arguments = "";
	_priority = 1000;
	_showWindow = true;
	_hideOnUse = true;
	_condition = "isNull objectParent _this";
	_cargo addAction [_title, _scriptCode, _arguments, _priority, _showWindow, _hideOnUse, "", _condition];

	_vehicle removeAction _actionID;
	_vehicle setVariable ["SAC_CARGO_class", "NONE", true];

};

SAC_fnc_fixGetOut = {

	//Arregla el problema de que cuando el jugador se baja, el driver mueve el vehículo tratando de seguir en formación con el jugador.

	//_vehicle addEventHandler ["GetOut", {_this call SAC_fnc_fixGetOut}];

	private ["_v", "_p", "_u"];

	_v = _this select 0;
	_p = _this select 1;
	_u = _this select 2;

	if (isPlayer driver _v) exitWith {}; //5/10/2019
	if (_p == "driver") exitWith {};
	if (group driver _v != group _u) exitWith {};

	systemChat "stopping the driver";
	doStop _v;


};

SAC_fnc_fixGetIn = {

	//Arregla el problema de que cuando se sube una unidad como driver quiere volver a formarse con el jugador, con el vehículo.

	//_vehicle addEventHandler ["GetIn", {_this call SAC_fnc_fixGetIn}];

	private ["_v", "_p", "_u"];

	_v = _this select 0; //vehicle
	_p = _this select 1; //position
	_u = _this select 2; //unit

	if (isPlayer driver _v) exitWith {}; //5/10/2019
	if (!isPlayer leader group _u) exitWith {};
	if (isPlayer _u) exitWith {};
	//if (_p != "driver") exitWith {};
	if (group driver _v != group _u) exitWith {}; //14/03/2019

	systemChat "stopping the driver";
	doStop driver _v;


};

SAC_fnc_teleporter = {

	private ["_elements", "_destination"];

	_elements = _this select 0;
	_destination = _this select 1;

	//(str _elements) call SAC_fnc_MPsystemChat;

	{

		//(typeOf _x) call SAC_fnc_MPsystemChat;

		if !(isPlayer driver _x) then { //y no los conduce un jugador

			if ((getPos vehicle _x) select 2 < 2) then { //y no lo está llevando un helicóptero colgando (sí, ya me pasó :)

				_x setPos _destination;

			} else {};

		} else {};

	} forEach _elements;


};

SAC_fnc_playSound = {

	if (!SAC_sounds) exitWith {};

	if (isNull objectParent player) then {

		playSound _this;

	} else {

		if (cameraView == "EXTERNAL" || cameraView == "GROUP" || {(cameraView == "INTERNAL") && (gunner vehicle player == player)}) then {

			playSound _this;

		} else {

			playSound [_this, true];

		};

	};

};

SAC_fnc_messageFromUnit = {

	private ["_u", "_message"];

	_u = _this select 0;
	_message = _this select 1;

	"mic_click_on" call SAC_fnc_playSound;

	_u sideChat _message;

	//sleep (2 max ((count (toArray _message))/12));
	sleep 1.5;

	"mic_click_off" call SAC_fnc_playSound;

};

SAC_fnc_messageFromHQ = {

	private ["_message", "_sounds", "_soundsDuration"];

	_message = _this select 0; //una cadena con el texto de sidechat
	_sounds = _this select 1; //un array de nombres de sonidos reconocidos por el engine
	_soundsDuration = _this select 2; //un array con la espera requerida después de cada sonido

	[SAC_PLAYER_SIDE, "HQ"] sideChat _message;
	{

		_x call SAC_fnc_playSound;
		sleep (_soundsDuration select _forEachIndex);

	} forEach _sounds;

};

SAC_fnc_displayName = {

	private["_cfg", "_class", "_displayName"];

	_class = _this;

	_cfg  = (configFile >>  "CfgVehicles" >>  _class);

	_displayName = if (isText(_cfg >> "displayName")) then {getText(_cfg >> "displayName")} else {"/"};

	_displayName

};

SAC_fnc_unitNumber = {

	private ["_unit"];

	_unit = _this;

	{

		if (_x == _unit) exitWith {_foreachindex};

	} forEach units group _unit;



};

SAC_fnc_heliProtection = {

	private ["_vehicle", "_continue", "_driver"];

	_vehicle = _this select 0;

	_driver = driver _vehicle;

	_continue = true;
	while {_continue} do {

		sleep 10; //30


		if (((!alive _vehicle) || (!canMove _vehicle) || (!alive _driver))) then {

			_vehicle allowDammage false;

			[_vehicle] spawn {

				private ["_v"];

				_v = _this select 0;

				waitUntil {getPos _v select 2 < 2};

				sleep 30;

				_v allowDammage true;

			};

			_continue = false;
		};

	};

	systemChat "Se termino una instancia de SAC_fnc_heliProtection.";

};

SAC_fnc_retextureVehicle = {
/*
	private ["_v"];

	_v = _this select 0;

	switch (typeOf _v) do {

		case "I_Heli_Transport_02_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];


			// dark green
			// _v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.353,0.588,0.435,0.05)"];
			// _v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.353,0.588,0.435,0.05)"];
			// _v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.353,0.588,0.435,0.05)"];



			// light brown
			// _v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.522,0.42,0.251,0.35)"];
			// _v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.522,0.42,0.251,0.2)"];
			// _v setObjectTextureGlobal  [2,"#(argb,8,8,3)color(0.522,0.42,0.251,0.35)"];



			// dark blue
			// _v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.078,0.078,0.569,0.1)"];
			// _v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.078,0.078,0.569,0.05)"];
			// _v setObjectTextureGlobal  [2,"#(argb,8,8,3)color(0.078,0.078,0.569,0.1)"];



			// lighter blue
			// _v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.078,0.078,0.569,0.5)"];
			// _v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.078,0.078,0.569,0.2)"];
			// _v setObjectTextureGlobal  [2,"#(argb,8,8,3)color(0.078,0.078,0.569,0.5)"];



			// turquoise
			// _v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0,0.835,1,0.3)"];
			// _v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0,0.835,1,0.05)"];
			// _v setObjectTextureGlobal  [2,"#(argb,8,8,3)color(0,0.835,1,0.3)"];


		};

		case "I_Truck_02_box_F";
		case "I_Truck_02_fuel_F";
		case "I_Truck_02_ammo_F";
		case "I_Truck_02_medical_F";
		case "I_Truck_02_covered_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.3)"];

		};

		case "I_Truck_02_transport_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			//_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.3)"];

		};

		case "I_MRAP_03_gmg_F";
		case "I_MRAP_03_F";
		case "I_MRAP_03_hmg_F": {

			_v setObjectTextureGlobal [0,'\A3\soft_f_beta\mrap_03\data\mrap_03_ext_co.paa'];
			_v setObjectTextureGlobal [1,'\A3\data_f\vehicles\turret_co.paa'];

		};

		case "O_Heli_Transport_04_F";
		case "O_Heli_Transport_04_black_F": {

			//skycrane yellow and black
			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.98,0.635,0.039,0.0)"];
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.98,0.635,0.039,0.5)"];
			//_v setObjectTextureGlobal  [2,"#(argb,8,8,3)color(0.98,0.635,0.039,0.5)"];
		};

		case "O_Heli_Transport_04_ammo_F";
		case "O_Heli_Transport_04_bench_F";
		case "O_Heli_Transport_04_box_F";
		case "O_Heli_Transport_04_covered_F";
		case "O_Heli_Transport_04_fuel_F";
		case "O_Heli_Transport_04_medevac_F";
		case "O_Heli_Transport_04_repair_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.0)"]; //alas, cola, y ruedas
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"]; //cabina
			_v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.3)"]; //"pod"
			_v setObjectTextureGlobal [3,"#(argb,8,8,3)color(0.518,0.519,0.455,0.3)"]; //"pod" (lateral)

		};

		case "O_Heli_Transport_04_ammo_black_F";
		case "O_Heli_Transport_04_bench_black_F";
		case "O_Heli_Transport_04_box_black_F";
		case "O_Heli_Transport_04_covered_black_F";
		case "O_Heli_Transport_04_fuel_black_F";
		case "O_Heli_Transport_04_medevac_black_F";
		case "O_Heli_Transport_04_repair_black_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.0)"]; //alas, cola, y ruedas
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.0)"]; //cabina
			_v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.0)"]; //"pod"
			_v setObjectTextureGlobal [3,"#(argb,8,8,3)color(0.518,0.519,0.455,0.0)"]; //"pod" (lateral)

		};

		case "O_Heli_Attack_02_black_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.0)"];
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.0)"];

		};

		case "O_Heli_Attack_02_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];

		};

		case "O_Heli_Transport_04_repair_black_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.0)"];
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.0)"];

		};

		case "I_Heli_light_03_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.15)"];

		};

		case "O_Heli_Light_02_F": {

			_v setObjectTextureGlobal[0,"A3\Air_F\Heli_Light_02\Data\Heli_Light_02_ext_CO.paa"];

		};

		case "O_MRAP_02_F";
		case "O_MRAP_02_hmg_F";
		case "O_MRAP_02_gmg_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			//_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"]; //puerta trasera y ruedas
			//_v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"]; //torreta

		};

		case "I_MBT_03_cannon_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];

		};

		case "I_APC_tracked_03_cannon_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			//_v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];

		};

		case "I_APC_Wheeled_03_cannon_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			//_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];

		};

		case "O_APC_Tracked_02_cannon_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.1)"];
			_v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.1)"];

		};

		case "O_APC_Tracked_02_AA_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.1)"];
			_v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.1)"];

		};

		case "O_APC_Wheeled_02_rcws_F": {

			_v setObjectTextureGlobal[0,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			//_v setObjectTextureGlobal [1,"#(argb,8,8,3)color(0.518,0.519,0.455,0.2)"];
			_v setObjectTextureGlobal [2,"#(argb,8,8,3)color(0.518,0.519,0.455,0.1)"];

		};

	};
*/

};

SAC_fnc_heliCrewProtector = {

	private ["_vehicle", "_continue"];

	_vehicle = _this select 0;

	_continue = true;
	while {_continue} do {

		sleep 5; //30

		if (((!alive _vehicle) || {!canMove _vehicle})) then {

			//systemChat "crew protection engaged";

			_vehicle allowDammage false;  //prevent more dammage until it hits the ground

			[_vehicle] spawn {

				private ["_v"];

				_v = _this select 0;

				waitUntil {getPos _v select 2 < 2};

				sleep 60;

				_v allowDammage true;

			};

			_continue = false;
		};

	};

	//systemChat "Se termino una instancia de SAC_fnc_heliCrewProtector.";

};

SAC_fnc_isNearWater = {

	params ["_position", "_distance"];

	if (surfaceIsWater (_position getPos [_distance, 0])) exitWith {true};
	if (surfaceIsWater (_position getPos [_distance, 45])) exitWith {true};
	if (surfaceIsWater (_position getPos [_distance, 90])) exitWith {true};
	if (surfaceIsWater (_position getPos [_distance, 135])) exitWith {true};
	if (surfaceIsWater (_position getPos [_distance, 180])) exitWith {true};
	if (surfaceIsWater (_position getPos [_distance, 225])) exitWith {true};
	if (surfaceIsWater (_position getPos [_distance, 270])) exitWith {true};
	if (surfaceIsWater (_position getPos [_distance, 315])) exitWith {true};

	false

};

SAC_fnc_isCellInWater = {

	params ["_position", "_distance"];

	if !(surfaceIsWater (_position getPos [_distance, 0])) exitWith {false};
	if !(surfaceIsWater (_position getPos [_distance, 45])) exitWith {false};
	if !(surfaceIsWater (_position getPos [_distance, 90])) exitWith {false};
	if !(surfaceIsWater (_position getPos [_distance, 135])) exitWith {false};
	if !(surfaceIsWater (_position getPos [_distance, 180])) exitWith {false};
	if !(surfaceIsWater (_position getPos [_distance, 225])) exitWith {false};
	if !(surfaceIsWater (_position getPos [_distance, 270])) exitWith {false};
	if !(surfaceIsWater (_position getPos [_distance, 315])) exitWith {false};

	true

};

SAC_fnc_addSetRespawnPositionActions = {

	params ["_unit"];

	private ["_title", "_scriptCode", "_priority", "_showWindow", "_hideOnUse", "_condition"];

	_title = "<t color='#FF0000'>Set respawn position</t>";
	_scriptCode = {[] call SAC_fnc_setRespawn}; //solo válido desde A3
	_priority = 1000;
	_showWindow = false;
	_hideOnUse = true;
	_condition = "isNull objectParent _this";
	_unit addAction [_title, _scriptCode, nil, _priority, _showWindow, _hideOnUse, "", _condition];

};

SAC_fnc_addOpenArsenalAction = {

	params ["_unit"];

	private ["_title", "_scriptCode", "_priority", "_showWindow", "_hideOnUse", "_condition"];

	_title = "<t color='#00FFFF'>Arsenal</t>";
	_scriptCode = {["Open",true] spawn BIS_fnc_arsenal}; //solo válido desde A3
	_priority = 1000;
	_showWindow = false;
	_hideOnUse = true;
	_condition = "isNull objectParent _this";
	_unit addAction [_title, _scriptCode, nil, _priority, _showWindow, _hideOnUse, "", _condition, 2];

};

SAC_fnc_explosionEffects = {

	params ["_pos", "_vehiclePrimaryBlast", "_vehicleSecondaryBlast", "_unitPrimaryBlast", "_unitSecondaryBlast", "_behaviour"];

	private _vehicles = _pos nearEntities [["Car","Tank","Air"], _vehicleSecondaryBlast];


	if (_vehiclePrimaryBlast != 999) then {

		{if (_x distance _pos <= _vehiclePrimaryBlast) then {_x setDammage 1}} forEach _vehicles;

	};

	if (_vehicleSecondaryBlast != 999) then {

		{if ((_x distance _pos > _vehiclePrimaryBlast) && (_x distance _pos <= _vehicleSecondaryBlast)) then {_x setDammage (getDammage _x + 0.4)}} forEach _vehicles;

	};

	///************************************************

	private _men = _pos nearEntities [["Man"], _unitSecondaryBlast];

	if (_unitPrimaryBlast != 999) then {

		{if (_x distance _pos <= _unitPrimaryBlast) then {_x setDammage 1}} forEach _men;

	};

	if (_unitSecondaryBlast != 999) then {

		{if ((_x distance _pos > _unitPrimaryBlast) && (_x distance _pos <= _unitSecondaryBlast)) then {_x setDammage (getDammage _x + 0.4)}} forEach _men;

	};

	if (_behaviour != 999) then {

		{

			if (!isPlayer (leader group _x)) then {_x setBehaviour "COMBAT"};

		} forEach (_pos nearEntities [["Man"], _behaviour]);

	};
};

SAC_fnc_goodGrav = 
{
   private ["_b","_velb","_vx","_vy","_vz", "_prevTime"];

   _b = _this select 0;
   _velb = velocity _b;

   _vx = _velb select 0;
   _vy = _velb select 1;
   _vz = _velb select 2;

   _vz = 0;

   _prevTime = diag_tickTime;
   waitUntil //runs on each frame
   {
       _vz = _vz - 9.81 * (diag_tickTime - _prevTime);
       _b setVelocity [_vx,_vy,_vz];

       _prevTime = diag_tickTime;
       isNull _b // for non-exploding object add:|| ((getPosATL _b) select 2) < 1  //no ; at the end!
   };
};


SAC_fnc_impact = {

	params ["_ammo", "_pos", "_vehiclePrimaryBlast", "_vehicleSecondaryBlast", "_unitPrimaryBlast", "_unitSecondaryBlast", "_behaviour"];
	
	//_device = _ammo createVehicle _pos;
	private _device = createVehicle [_ammo, _pos, [], 0, "CAN_COLLIDE"];
	
	if (_ammo in SAC_flares) then {
	
		_device setVelocity [wind select 0, wind select 1, -5];
		
	} else {
	
		[_device] spawn SAC_fnc_goodGrav;
		//_device setVelocity [0,0,-100]; //si se altera esto, fallan todos los cálculos de corrección de impacto de FACR

	};

};

SAC_fnc_indirectFireBarrage = {

	params ["_ammo","_centralPos", "_dispersion","_rounds"];

	private _device = objNull;
	private _p = [];
	
	for "_i" from 1 to _rounds do {
	
		_p = _centralPos getPos [random _dispersion, random 360];
	
		_p set [2, 250];
	
		_device = createVehicle [_ammo, _p, [], 0, "CAN_COLLIDE"];
		
		[_device] spawn SAC_fnc_goodGrav;
		
		sleep (2 + random 8);
	
	};

};

SAC_fnc_indirectFireBarrageOnNearestPlayerSide = {

	params ["_ammo","_centralPos","_dispersion","_rounds","_maxSearchDistance"];

	private _unit = [_centralPos, _maxSearchDistance] call SAC_fnc_nearestPlayerSide;
	
	if (isNull _unit) exitWith {};
	
	[_ammo, getPosATL _unit, _dispersion,_rounds] call SAC_fnc_indirectFireBarrage;
		

};

SAC_fnc_sendWavesOfInfantry = {

	params ["_centralPos","_squads","_waves","_waveDelay","_infClasses","_spawnDistance","_playerExclusionDistance","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"];

	private ["_grp"];
	
	private _allGrps = [];
	private _allUnits = [];

	for "_i" from 1 to _waves do {
	
		for "_k" from 1 to _squads do {

			_grp = [_centralPos, _spawnDistance, _playerExclusionDistance, _infClasses, _unitsCount, _skill, "ENEMIES", _blacklists] call SAC_fnc_sendHunterInfantry;
		
			if (!isNull _grp) then {
			
				_allGrps pushBack _grp;
				_allUnits append units _grp;
				
				{_x setVariable ["SAC_TTL", time + (_TTL*60)]} forEach units _grp;
				
				sleep 0.3;
				
			};
		
		};

		//si fue la ultima wave, salir sin esperar
		if (_i < _waves) then {sleep _waveDelay};
	
	};
	
	if ((count _allGrps != 0) && (_runCleaner)) then {

		//systemChat "running cleaner";
		[_allGrps, _allUnits, [], _TTL] spawn SAC_fnc_cleaner;
	
	};
	
	[_allGrps, _allUnits]

};

SAC_fnc_sendWavesOfInfantryInVehicles = {

	params ["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"];

	private ["_grp","_returnedArray","_vehicle","_crewGrp"];

	private _allGrps = [];
	private _allUnits = [];
	private _allVeh = [];
	
	for "_i" from 1 to _waves do {
	
		for "_k" from 1 to _squads do {

			//["_destination", "_delay", "_minDistance", "_roadSpawnDistance", "_landVehClasses", "_crewClasses", "_speed", "_combatMode", "_behaviour", "_troopClassesLand", "_landSkill", "_setCaptiveLand", "_airSpawnDistance", "_heliClasses", "_pilotClass", "_troopClassesAir", "_airSkill", "_setCaptiveAir", "_troopCount", "_landProb", "_autoDeleteGroup", "_blacklistsMarkers", "_taskTypes"]
			_returnedArray = [_centralPos, [0, 0], 100, [1000, 1500], _vehClasses, _infClasses, 999, "YELLOW", "CARELESS", _infClasses, _skill, false, 0, [], "", [], [], false, _unitsCount, 1, true, _blacklists, ["ENEMIES"]] call SAC_fnc_sendQRF;
			_vehicle = _returnedArray select 0;
			_crewGrp = _returnedArray select 1;
			_grp = _returnedArray select 2;
			
			if (!isNull _grp) then {
			
				_allGrps pushBack _grp;
				_allGrps pushBack _crewGrp;
				_allUnits append units _grp;
				_allUnits append units _crewGrp;
				
				{_x setVariable ["SAC_TTL", time + (_TTL*60)]} forEach units _grp;
				{_x setVariable ["SAC_TTL", time + (_TTL*60)]} forEach units _crewGrp;
				_vehicle setVariable ["SAC_TTL", time + (_TTL*60)];
				_allVeh pushBack _vehicle;
				
				sleep 0.3;
				
			};
		
		};

		//si fue la ultima wave, salir sin esperar
		if (_i < _waves) then {sleep _waveDelay};
	
	};
	
	if ((count _allGrps != 0) && (_runCleaner)) then {

		[_allGrps, _allUnits, _allVeh, _TTL] spawn SAC_fnc_cleaner;
	
	};
	
	[_allGrps, _allUnits, _allVeh]

};

SAC_fnc_sendWavesOfInfantryInHelicopter = {

	params ["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_crewClasses","_unitsCount","_skill","_blacklists","_runCleaner","_TTL"];

	//systemChat str _this;
	//diag_log _this;


	private ["_grp","_returnedArray","_vehicle","_crewGrp"];

	private _allGrps = [];
	private _allUnits = [];
	
	for "_i" from 1 to _waves do {
	
		for "_k" from 1 to _squads do {

			//["_destination", "_delay", "_minDistance", "_roadSpawnDistance", "_landVehClasses", "_crewClasses", "_speed", "_combatMode", "_behaviour", "_troopClassesLand", "_landSkill", "_setCaptiveLand", "_airSpawnDistance", "_heliClasses", "_pilotClass", "_troopClassesAir", "_airSkill", "_setCaptiveAir", "_troopCount", "_landProb", "_autoDeleteGroup", "_blacklistsMarkers", "_taskTypes"]
			_returnedArray = [_centralPos, [0, 0], 300, [], [], [], 999, "YELLOW", "CARELESS", [], [], false, 5000, _vehClasses, _crewClasses, _infClasses, _skill, false, _unitsCount, 0, true, _blacklists, ["ENEMIES"]] call SAC_fnc_sendQRF;
			_vehicle = _returnedArray select 0;
			_crewGrp = _returnedArray select 1;
			_grp = _returnedArray select 2;
			
			if (!isNull _grp) then {
			
				_allGrps pushBack _grp;
				_allUnits append units _grp;
				
				{_x setVariable ["SAC_TTL", time + (_TTL*60)]} forEach units _grp;
				
				sleep 0.3;
				
			};
		
		};

		//si fue la ultima wave, salir sin esperar
		if (_i < _waves) then {sleep _waveDelay};
	
	};
	
	if ((count _allGrps != 0) && (_runCleaner)) then {

		[_allGrps, _allUnits, [], _TTL] spawn SAC_fnc_cleaner;
	
	};
	
	[_allGrps, _allUnits, []]

};

SAC_fnc_sendWavesOfArmedVehicles = {

	params ["_centralPos","_squads","_waves","_waveDelay","_infClasses","_vehClasses","_skill","_blacklists","_runCleaner","_TTL"];

	private ["_grp","_returnedArray","_vehicle"];

	private _allGrps = [];
	private _allUnits = [];
	private _allVeh = [];
	
	for "_i" from 1 to _waves do {
	
		for "_k" from 1 to _squads do {

			//"_targetPos", "_minSpawnDistance", "_maxSpawnDistance", "_vehicleClasses", "_crewClasses",	"_skill", "_setCaptive", "_blacklistsMarkers", "_autoDeleteGroup"]
			_returnedArray = [_centralPos, "ENEMIES", 1000, 1500, _vehClasses, _infClasses, _skill, false, _blacklists, true] call SAC_fnc_sendInterceptor;
			_vehicle = _returnedArray select 0;
			_grp = _returnedArray select 1;
			
			if (!isNull _grp) then {
			
				_allGrps pushBack _grp;
				_allUnits append units _grp;
				
				{_x setVariable ["SAC_TTL", time + (_TTL*60)]} forEach units _grp;
				_vehicle setVariable ["SAC_TTL", time + (_TTL*60)];
				_allVeh pushBack _vehicle;
				
				sleep 0.3;

			};
		
		
		};

		//si fue la ultima wave, salir sin esperar
		if (_i < _waves) then {sleep _waveDelay};
	
	};
	
	if ((count _allGrps != 0) && (_runCleaner)) then {

		[_allGrps, _allUnits, _allVeh, _TTL] spawn SAC_fnc_cleaner;
	
	};
	
	[_allGrps, _allUnits, _allVeh]

};

SAC_fnc_cleaner = {

	params ["_allGrps", "_allUnits", "_allVeh", "_initialDelay"];
	
	private ["_u","_g","_v"];

	//systemChat ("initial delay " + str _initialDelay);
	sleep (_initialDelay * 60);
	
	systemChat "despertando";

	while {(count _allGrps > 0) || (count _allUnits > 0) || (count _allVeh > 0)} do {

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
			
				if (time > _x getVariable "SAC_TTL") then { //si se pasó su TTL

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
		
		} forEach _allVeh;
		
		_allVeh = _allVeh - _v;

		systemChat "evaluando lista de unidades";
		systemChat str _allUnits;
		
		_u = [];
		{
		
			if (!alive _x) then {
			
				if ([_x, 50] call SAC_fnc_notNearPlayerSide_2) then {
				
					_u pushBack _x;
					
					[_x] call SAC_fnc_deleteUnit;
					
				};
			
			} else {
			
				if (time > _x getVariable "SAC_TTL") then {
				
					if ([_x, 600] call SAC_fnc_notNearPlayerSide_2) then {
					
						_u pushBack _x;
						
						[_x] call SAC_fnc_deleteUnit;
					
					};
				
				};

			};
		
		} forEach _allUnits;


		systemChat "lista evaluada";
		systemChat str _u;
		
		_allUnits = _allUnits - _u;

		
		_g = [];
		{
		
			if (count units _x == 0) then {

				_g pushBack _x;
				deleteGroup _x;

			};
			
		} forEach _allGrps;
		
		_allGrps = _allGrps - _g;
		
		
		sleep (5*60);

	};

};

SAC_fnc_setViewDistance = {
/*
	switch (worldName) do
	{

		case "Chernarus_winter";
		case "Chernarus_Summer";
		case "chernarus": {setViewDistance 3500};
		case "Woodland_ACR": {setViewDistance 3500};//Bystrica
		case "fallujah": {setViewDistance 3500};
		case "Zargabad": {setViewDistance 6000};
		case "MCM_Aliabad": {setViewDistance 6000};
		case "fata": {setViewDistance 6000};
		case "praa_av": {setViewDistance 6000};//afghan village
		case "Kunduz": {setViewDistance 6000};
		case "Beketov": {setViewDistance 6000};
		case "lythium";
		case "kidal";
		case "tem_anizay";
		case "takistan": {setViewDistance 6000};
		case "smd_sahrani_a3";
		case "Sahrani";
		case "Sara";
		case "Sara_dbe1";
		case "smd_sahrani_a2": {setViewDistance 4000};
		case "Tanoa": {setViewDistance 3800};
		case "tembelan";
		case "Malden";
		case "Altis": {setViewDistance 2800};
		case "Bornholm": {setViewDistance 2800};
		case "isladuala3": {setViewDistance 4000};
		case "Panthera3": {setViewDistance 4000};
		case "abramia": {setViewDistance 4000};
		case "pja305": {setViewDistance 3500};//Nziwasogo
		case "pja314": {setViewDistance 3500};//Leskovets
		case "DYA": {setViewDistance 3500}; //Diyala
		case default {
			systemChat worldName;
			diag_log worldName;
		};

	};
*/
};

SAC_fnc_randPosArea = {

	/* ----------------------------------------------------------------------------
	Function: CBA_fnc_randPosArea

	Description:
	    Find a random (uniformly distributed) position within the given area.

	    * You can <CBA_fnc_randPos> to find a position within a simple radius.

	Parameters:
	    _zone - The zone to find a position within [Marker or Trigger]
	    _perimeter - True to return only positions on the area perimeter [Boolean, defaults to false]

	Returns:
	    Position [Array] (Empty array if non-area object/marker was given)

	Examples:
	   (begin example)
	   _position = [marker, true] call CBA_fnc_randPosArea;

	   _position = [trigger] call CBA_fnc_randPosArea;
	   (end)

	Author:
	    SilentSpike 2015-07-06
	---------------------------------------------------------------------------- */

	private ["_zRef","_zSize","_zDir","_zRect","_zPos","_perimeter","_posVector"];
	_zRef = _this select 0;
	_perimeter = if (count _this > 1) then {_this select 1} else {false};

	switch (typeName _zRef) do {
	    case "STRING" : {
		  if ((markerShape _zRef) in ["RECTANGLE","ELLIPSE"]) then {
			_zSize = markerSize _zRef;
			_zDir = markerDir _zRef;
			_zRect = (markerShape _zRef) == "RECTANGLE";
			_zPos = markerPos _zRef;
		  };
	    };
	    case "OBJECT" : {
		  if ((triggerArea _zRef) isNotEqualTo []) then {
			_zSize = triggerArea _zRef;
			_zDir = _zSize select 2;
			_zRect = _zSize select 3;
			_zPos = getPos _zRef;
		  };
	    };
	};

	if (isNil "_zSize") exitWith {[]};

	private ["_x","_y","_a","_b","_rho","_phi","_x1","_x2","_y1","_y2"];
	if (_zRect) then {
	    _x = _zSize select 0;
	    _y = _zSize select 1;
	    _a = _x*2;
	    _b = _y*2;

	    if (_perimeter) then {
		  _rho = random (2*(_a + _b));

		  _x1 = (_rho min _a);
		  _y1 = ((_rho - _x1) min _b) max 0;
		  _x2 = ((_rho - _x1 - _y1) min _a) max 0;
		  _y2 = ((_rho - _x1 - _y1 - _x2) min _b) max 0;
		  _posVector = [(_x1 - _x2) - _x, (_y1 - _y2) - _y, 0];
	    } else {
		  _posVector = [random(_a) - _x, random(_b) - _y, 0];
	    };
	} else {
	    _rho = if (_perimeter) then {1} else {random 1};
	    _phi = random 360;
	    _x = sqrt(_rho) * cos(_phi);
	    _y = sqrt(_rho) * sin(_phi);

	    _posVector = [_x * (_zSize select 0), _y * (_zSize select 1), 0];
	};

	_posVector = [_posVector, -_zDir] call BIS_fnc_rotateVector2D;

	_zPos vectorAdd _posVector


};

SAC_fnc_initVehicle = {

	//Corrige problemas comunes que hacen el uso de vehículos menos problemático.

	params ["_vehicle"];

	if !((_vehicle isKindOf "Car") || (_vehicle isKindOf "Tank") || (_vehicle isKindOf "Air")) exitWith {systemChat "El tipo de vehiculo no es valido."};

	if (_vehicle getVariable ["SAC_VehicleInitialized", false]) exitWith {systemChat "El vehiculo ya estaba inicializado."};

	if (_vehicle isKindOf "Land") then {

		_vehicle addEventHandler ["GetOut", {_this call SAC_fnc_fixGetOut}];
		_vehicle addEventHandler ["GetIn", {_this call SAC_fnc_fixGetIn}];

	};

	if (_vehicle isKindOf "Air") then {

		[_vehicle] spawn SAC_fnc_heliCrewProtector; //impide que tomen más daños hasta que caen a tierra, o sea ayuda a sobrevivir un derrivo

	};

	_vehicle setVariable ["SAC_VehicleInitialized", true, true];

};

SAC_fnc_initAllVehicles = {

	//Corrige problemas comunes que hacen el uso de vehículos menos problemático.

	params ["_centerPos", "_distance"];

	private ["_allVehicles", "_vehicle"];

	_allVehicles = _centerPos nearEntities _distance;

	{

		_vehicle = _x;

		if ((_vehicle isKindOf "Car") || (_vehicle isKindOf "Tank") || (_vehicle isKindOf "Air")) then {

			if !(_vehicle getVariable ["SAC_VehicleInitialized", false]) then {

				[_vehicle] call SAC_fnc_initVehicle;

			};

		};

	} foreach _allVehicles;
};

SAC_fnc_markAllBuildings = {

	params ["_center", "_radius"];

	{

		[getPos _x, "ColorRed", ""] call SAC_fnc_createMarker;


	} foreach (_center nearObjects ["Building", _radius]);

};

SAC_fnc_markAllHouses = {

	params ["_center", "_radius"];

	{

		[getPos _x, "ColorGreen", ""] call SAC_fnc_createMarker;


	} foreach (_center nearObjects ["House", _radius]);

};

SAC_fnc_debugNotify = {

	params ["_message"];

	_message call SAC_fnc_MPsystemChat;
	diag_log _message;
	debugLog _message; //no se a donde sale esto pero lo usa BIS


};

SAC_fnc_dlgYesOrNo = {

	params ["_title"];

	SAC_user_input = "";

	0 = createdialog "SAC_2x12_panel";
	ctrlSetText [1800, _title];

	ctrlSetText [1601, "Yes"];
	ctrlShow [1602, false ];
	ctrlShow [1603, false ];
	ctrlShow [1604, false ];
	ctrlShow [1605, false ];
	ctrlShow [1606, false ];
	ctrlShow [1607, false ];
	ctrlShow [1608, false ];
	ctrlShow [1609, false ];
	ctrlShow [1610, false ];
	ctrlShow [1611, false ];
	ctrlShow [1612, false ];

	ctrlSetText [1613, "No"];
	ctrlShow [1614, false ];
	ctrlShow [1615, false ];
	ctrlShow [1616, false ];
	ctrlShow [1617, false ];
	ctrlShow [1618, false ];
	ctrlShow [1619, false ];
	ctrlShow [1620, false ];
	ctrlShow [1621, false ];
	ctrlShow [1622, false ];
	ctrlShow [1623, false ];
	ctrlShow [1624, false ];

	waitUntil { !dialog };

	_result = false;

	if (SAC_user_input == "Yes") then {_result = true};

	_result

};

SAC_fnc_createVehicle = {

	params ["_vehicleClasses", "_vehPos"]; //soporta que los elementos sean arrays de clases (no solo clases)

	private _vehicleClass = selectRandom _vehicleClasses;
	
	if (_vehicleClass isEqualType []) then {
	
		_vehicleClass = selectRandom _vehicleClass;
		
	};
	
	private _veh = _vehicleClass createVehicle _vehPos;
	
	_veh
	
};


SAC_fnc_spawnVehicle = {

	//"_special" puede ser "NONE", "CAN_COLLIDE", ó "FLY"

	params ["_position", "_direction", "_vehicleClasses", "_crewClasses", "_special", "_autoDeleteGroup"];
/*
	if (count _vehicleClasses == 0) then {
	
		systemChat "*****************************"; ("_vehicleClasses is empty calling SAC_fnc_spawnVehicle. The calling will fail.") call SAC_fnc_debugNotify;
	
	} else {
		{
		
			if (!isClass(configFile >> "CfgVehicles" >> _x)) then {
				
				systemChat "*****************************"; (format["Invalid class in: %1", _vehicleClasses]) call SAC_fnc_debugNotify;
				(format["Class is: %1", _x]) call SAC_fnc_debugNotify;
			
			};
		
		} foreach _vehicleClasses;
	};	
*/	
	private ["_vehicle", "_crewClassesTemp"];
	
	private _side = [_crewClasses select 0] call SAC_fnc_getSideFromCfg;

	_crewClassesTemp = +_crewClasses;

	private _vehicleClass = selectRandom _vehicleClasses;
	
	if (_vehicleClass isEqualType []) then {
	
		_vehicleClass = selectRandom _vehicleClass;
		
	};

	_vehicle = createVehicle [_vehicleClass, _position, [], 0, _special];
	sleep 0.3;

	_vehicle setDir _direction;
	_vehicle setPosATL (getPosATL _vehicle);

	private ["_crewGroup", "_crewMember"];

	_crewGroup = createGroup _side;

	//el driver
	_crewClass = selectRandom _crewClassesTemp;
	_crewMember = _crewGroup createUnit [_crewClass, _position, [], 0, "NONE"];
	sleep 0.3;
	[_crewMember] call SAC_GEAR_applyLoadoutByClass;
	_crewClassesTemp = _crewClassesTemp - [_crewClass];
	if (count _crewClassesTemp == 0) then {_crewClassesTemp = +_crewClasses};
	_crewMember moveInDriver _vehicle;

	//el commander
	if ([_vehicle] call SAC_fnc_hasCommander) then {

		_crewClass = selectRandom _crewClassesTemp;
		_crewMember = _crewGroup createUnit [_crewClass, _position, [], 0, "NONE"];
		sleep 0.3;
		[_crewMember] call SAC_GEAR_applyLoadoutByClass;
		_crewClassesTemp = _crewClassesTemp - [_crewClass];
		if (count _crewClassesTemp == 0) then {_crewClassesTemp = +_crewClasses};
		_crewMember moveInCommander _vehicle;

	};

	//el gunner
	if ([_vehicle] call SAC_fnc_hasGunner) then {

		_crewClass = selectRandom _crewClassesTemp;
		_crewMember = _crewGroup createUnit [_crewClass, _position, [], 0, "NONE"];
		sleep 0.3;
		[_crewMember] call SAC_GEAR_applyLoadoutByClass;
		_crewClassesTemp = _crewClassesTemp - [_crewClass];
		if (count _crewClassesTemp == 0) then {_crewClassesTemp = +_crewClasses};
		_crewMember moveInGunner _vehicle;

	};

	//las turrets
	//14/03/2019 Los BTR de RHS tienen una configuración extraña que requiere un tratamiento específico. SAC_fnc_hasCommander devuelve
	//FALSE, pero el asiento al lado del conductor se ocupa porque aparece en la lista que devuelve SAC_fnc_emptyCommonTurrets.
	//Además de eso "commander _vehicle" devuelve "objNull", pero el ícono de esa posición y la opción para subirse a ella corresponden a
	//"commander". La solución que encontré es que esa posición tiene que estar ocupada, y ese tiene que ser el líder del grupo. Si no, el
	//vehículo no toma las órdenes. O si se la deja vacía, cualquiera que ocupe esa posición traba el vehículo y no obedece ninguna órden.
	//23/04/2021 La questión con los vehículos de RHS es la siguiente: en los BMP 1 y 2 han convertido la posición del commander en una personTurret,
	//pero si uno coloca una IA en esa posición, se la considera "cargo" y ante la detección de enemigos, se baja del vehículo para agregar poder
	//de fuego (o lo que sea). Si uno crea una desde Zeus, lo único que hay adentro es un driver y un gunner, y así funcionan bien. El problema
	//es que un player se puede subir a ese "commander" vacío, y ahí el vehículo deja de responder a las órdenes de los scripts. Los BTR tienen un
	//problema similar, sólo que el commander se convierte en una commonTurret. Por último, los BMP 3 están bien configurados con driver, gunner,
	//y commander, pero aparecen 2 commonTurret que, otra vez, desmontan al contacto con el enemigo.
	//Por todo esto, lo mejor es crear driver y gunner en donde estén configurados como el resto de los vehículos, y no ocupar las commonTurret ni
	//las personTurret. En el caso de la BMP 3 el commander se ocupa porque está configurado como el resto de los vehículos, y solo dejo de ocupar
	//las commonTurret.
	//23/04/2021 Se logró bloquear las turrets problemáticas para impedir que jugadores o unidades se pudieran subir.
	//23/04/2021 Se identificó el mismo problema que las BMP 1 y 2 en el Striker (M1126), y se resolvió de la misma manera.
	private _rhs_btr = false;
	if ("BTR" in toUpper(typeOf _vehicle)) then {
	
		if (("RHS" in toUpper(typeOf _vehicle)) || {"3CB" in toUpper(typeOf _vehicle)} || {"LOP" in toUpper(typeOf _vehicle)}) then {
		
			_rhs_btr = true;
	
		};
	};
	
	if (!_rhs_btr) then {
	
		{

			_crewClass = selectRandom _crewClassesTemp;
			_crewMember = _crewGroup createUnit [_crewClass, _position, [], 0, "NONE"];
			sleep 0.3;
			[_crewMember] call SAC_GEAR_applyLoadoutByClass;
			_crewClassesTemp = _crewClassesTemp - [_crewClass];
			if (count _crewClassesTemp == 0) then {_crewClassesTemp = +_crewClasses};
			_crewMember moveInTurret [_vehicle, _x];

		} forEach ([_vehicle] call SAC_fnc_emptyCommonTurrets);
	
	};

	//impedir que un player se pueda subir a la posición de commander mal
	//configurada de los BTR de RHS.
	if (_rhs_btr) then {
	
		{
		
			_vehicle lockTurret [_x, true];
		
		} forEach ([_vehicle] call SAC_fnc_emptyCommonTurrets);
	
	};

	//impedir que un player se pueda subir a la posición de commander mal
	//configurada de los BMP 1 y 2, y los Strikers, de RHS.
	private _rhs_striker = ("M1126" in toUpper(typeOf _vehicle)) && {"RHS" in toUpper(typeOf _vehicle)};
	private _rhs_bmp12 = false;
	if (("BMP1" in toUpper(typeOf _vehicle)) || {"BMP2" in toUpper(typeOf _vehicle)}) then {
	
		if (("RHS" in toUpper(typeOf _vehicle)) || {"3CB" in toUpper(typeOf _vehicle)} || {"LOP" in toUpper(typeOf _vehicle)}) then {
		
			_rhs_bmp12 = true;
	
		};
	};
	
	
	if (_rhs_bmp12 || _rhs_striker) then {
	
		_vehicle lockTurret [([_vehicle] call SAC_fnc_emptyPersonTurrets) select 0, true];
	
	};


	//imperdir que un player se pueda subir a la posición de personTurrets mal
	//configuradas de los BMP 3.
	private _rhs_bmp3 = false;
	if ("BMP3" in toUpper(typeOf _vehicle)) then {
	
		if (("RHS" in toUpper(typeOf _vehicle)) || {"3CB" in toUpper(typeOf _vehicle)} || {"LOP" in toUpper(typeOf _vehicle)}) then {
		
			_rhs_bmp3 = true;
	
		};
	};
	
	if (_rhs_bmp3) then {

		{
		
			_vehicle lockTurret [_x, true];
		
		} forEach ([_vehicle] call SAC_fnc_emptyPersonTurrets);

	};

	{

		if (isNull objectParent _x) then {

			deleteVehicle _x;
			("Warning: Miscreated crew for " + typeOf _vehicle) call SAC_fnc_debugNotify;

		}

	} forEach units _crewGroup;

	_crewGroup addVehicle _vehicle; //27/03/2018
	
	_crewGroup allowFleeing 0; //27/03/2018
	
	if !(_rhs_btr || _rhs_bmp12) then {
	
		if !(_vehicle isKindOf "Air") then {
		
			if (!isNull commander _vehicle) then {
			
				_crewGroup selectLeader (commander _vehicle);
				(commander _vehicle) setUnitRank "COLONEL";
				//systemChat "commander assigned as group leader";
				
			} else {
			
				if (!isNull gunner _vehicle) then {
				
					_crewGroup selectLeader (gunner _vehicle);
					//systemChat "gunner assigned as group leader";
				
				} else {
				
					if (!isNull driver _vehicle) then {
					
						_crewGroup selectLeader (driver _vehicle);
						//systemChat "driver assigned as group leader";
					
					}
				
				};
			
			
			};
			
		} else {
		
			//14/03/2019 Aunque en los helicópteros de RHS commander _vehicle reporta objNull, dejo esta línea porque era el comportamiento
			//que siempre usé y funcionaba bien. Si se hace líder de grupo al gunner, los helicópteros hacen cualquier cosa.
			_crewGroup selectLeader (commander _vehicle);
			//systemChat "air vehicle, executing: _crewGroup selectLeader (commander _vehicle)";
			
		};
	};
	
	if (_side != SAC_PLAYER_SIDE) then {[_crewGroup] call SAC_fnc_setSkills};
	
	_crewGroup deleteGroupWhenEmpty _autoDeleteGroup;
	
	
	//BIS' vehicle customization system
	switch (typeOf _vehicle) do {
	
		case "B_APC_Wheeled_01_cannon_F": { //marshal
	
			private _optionals = selectRandom [
			["showBags",1,"showCamonetHull",1,"showCamonetTurret",1,"showSLATHull",0,"showSLATTurret",0],
			["showBags",1,"showCamonetHull",0,"showCamonetTurret",0,"showSLATHull",1,"showSLATTurret",1],
			["showBags",1,"showCamonetHull",0,"showCamonetTurret",1,"showSLATHull",1,"showSLATTurret",0]];
			
			[_vehicle, ["Sand",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "B_T_APC_Wheeled_01_cannon_F": { //marshal apex
	
			private _optionals = selectRandom [
			["showBags",1,"showCamonetHull",1,"showCamonetTurret",1,"showSLATHull",0,"showSLATTurret",0],
			["showBags",1,"showCamonetHull",0,"showCamonetTurret",0,"showSLATHull",1,"showSLATTurret",1],
			["showBags",1,"showCamonetHull",0,"showCamonetTurret",1,"showSLATHull",1,"showSLATTurret",0]];
			
			[_vehicle, ["Olive",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "B_APC_Tracked_01_rcws_F": { //panther
	
			private _optionals = selectRandom [
			["showCamonetHull",1,"showBags",0],
			["showCamonetHull",0,"showBags",0]];
			
			[_vehicle, ["Sand",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "B_T_APC_Tracked_01_rcws_F": { //panther apex
	
			private _optionals = selectRandom [
			["showCamonetHull",1,"showBags",0],
			["showCamonetHull",0,"showBags",0]];
			
			[_vehicle, ["Olive",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "B_MBT_01_cannon_F": { //slammer
	
			private _optionals = selectRandom [
			["showBags",1,"showCamonetTurret",1,"showCamonetHull",1],
			["showBags",1,"showCamonetTurret",0,"showCamonetHull",0],
			["showBags",1,"showCamonetTurret",1,"showCamonetHull",0],
			["showBags",1,"showCamonetTurret",0,"showCamonetHull",1]];
			
			[_vehicle, ["Sand",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "B_T_MBT_01_cannon_F": { //slammer apex
	
			private _optionals = selectRandom [
			["showBags",1,"showCamonetTurret",1,"showCamonetHull",1],
			["showBags",1,"showCamonetTurret",0,"showCamonetHull",0],
			["showBags",1,"showCamonetTurret",1,"showCamonetHull",0],
			["showBags",1,"showCamonetTurret",0,"showCamonetHull",1]];
			
			[_vehicle, ["Olive",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "B_MBT_01_TUSK_F": { //slammer up
	
			private _optionals = selectRandom [
			["showBags",1,"showCamonetTurret",1,"showCamonetHull",1],
			["showBags",1,"showCamonetTurret",0,"showCamonetHull",0],
			["showBags",1,"showCamonetTurret",1,"showCamonetHull",0],
			["showBags",1,"showCamonetTurret",0,"showCamonetHull",1]];
			
			[_vehicle, ["Sand",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "B_T_MBT_01_TUSK_F": { //slammer up apex
	
			private _optionals = selectRandom [
			["showBags",1,"showCamonetTurret",1,"showCamonetHull",1],
			["showBags",1,"showCamonetTurret",0,"showCamonetHull",0],
			["showBags",1,"showCamonetTurret",1,"showCamonetHull",0],
			["showBags",1,"showCamonetTurret",0,"showCamonetHull",1]];
			
			[_vehicle, ["Olive",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "O_T_MBT_04_cannon_F": { //T140 angara grey
	
			private _optionals = selectRandom [
			["showCamonetHull",1,"showCamonetTurret",1],
			["showCamonetHull",1,"showCamonetTurret",0],
			["showCamonetHull",0,"showCamonetTurret",0]];
			
			[_vehicle, ["Grey",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "O_T_MBT_04_cannon_F": { //T140 angara apex
	
			private _optionals = selectRandom [
			["showCamonetHull",1,"showCamonetTurret",1],
			["showCamonetHull",1,"showCamonetTurret",0],
			["showCamonetHull",0,"showCamonetTurret",0]];
			
			[_vehicle, ["GreenHex",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "I_APC_Wheeled_03_cannon_F": { //gorgon
	
			private _camo = switch (toLower worldName) do {
				case "tanoa";
				case "chernarus": {"Guerilla_03"};
				default {"Guerilla_02"};
			};
			private _optionals = selectRandom [
			["showCamonetHull",1,"showBags",0,"showBags2",1,"showTools",1,"showSLATHull",0],
			["showCamonetHull",0,"showBags",0,"showBags2",1,"showTools",1,"showSLATHull",0],
			["showCamonetHull",0,"showBags",0,"showBags2",1,"showTools",1,"showSLATHull",1]];
			
			[_vehicle, [_camo,1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "I_MBT_03_cannon_F": { //kuma (leopard)
	
			private _optionals = selectRandom [
			["HideTurret",1,"HideHull",1,"showCamonetHull",1,"showCamonetTurret",1],
			["HideTurret",1,"HideHull",1,"showCamonetHull",0,"showCamonetTurret",0]];
			
			[_vehicle, ["Indep_01",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "O_APC_Wheeled_02_rcws_v2_F": { //marid
	
			private _optionals = selectRandom [
			["showBags",0,"showCanisters",1,"showTools",0,"showCamonetHull",1,"showSLATHull",0],
			["showBags",0,"showCanisters",1,"showTools",0,"showCamonetHull",0,"showSLATHull",0],
			["showBags",0,"showCanisters",1,"showTools",1,"showCamonetHull",0,"showSLATHull",1]];
			
			[_vehicle, ["Hex",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "O_T_APC_Wheeled_02_rcws_v2_ghex_F": { //marid apex
	
			private _optionals = selectRandom [
			["showBags",0,"showCanisters",1,"showTools",0,"showCamonetHull",1,"showSLATHull",0],
			["showBags",0,"showCanisters",1,"showTools",0,"showCamonetHull",0,"showSLATHull",0],
			["showBags",0,"showCanisters",1,"showTools",1,"showCamonetHull",0,"showSLATHull",1]];
			
			[_vehicle, ["GreenHex",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "O_APC_Tracked_02_cannon_F": { //kamish
	
			private _optionals = selectRandom [
			["showTracks",1,"showCamonetHull",1,"showBags",0,"showSLATHull",0],
			["showTracks",1,"showCamonetHull",0,"showBags",0,"showSLATHull",0],
			["showTracks",1,"showCamonetHull",0,"showBags",0,"showSLATHull",1]];
			
			[_vehicle, ["Hex",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "O_T_APC_Tracked_02_cannon_ghex_F": { //kamish apex
	
			private _optionals = selectRandom [
			["showTracks",1,"showCamonetHull",1,"showBags",0,"showSLATHull",0],
			["showTracks",1,"showCamonetHull",0,"showBags",0,"showSLATHull",0],
			["showTracks",1,"showCamonetHull",0,"showBags",0,"showSLATHull",1]];
			
			[_vehicle, ["GreenHex",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "O_MBT_02_cannon_F": { //t-100 varsuk
	
			private _optionals = selectRandom [
			["showCamonetHull",1,"showCamonetTurret",1,"showLog",1],
			["showCamonetHull",1,"showCamonetTurret",1,"showLog",1],
			["showCamonetHull",1,"showCamonetTurret",1,"showLog",1],
			["showCamonetHull",0,"showCamonetTurret",0,"showLog",1]];
			
			[_vehicle, ["Hex",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "O_T_MBT_02_cannon_ghex_F": { //t-100 varsuk apex
	
			private _optionals = selectRandom [
			["showCamonetHull",1,"showCamonetTurret",1,"showLog",1],
			["showCamonetHull",1,"showCamonetTurret",1,"showLog",1],
			["showCamonetHull",1,"showCamonetTurret",1,"showLog",1],
			["showCamonetHull",0,"showCamonetTurret",0,"showLog",1]];
			
			[_vehicle, ["GreenHex",1], _optionals] call BIS_fnc_initVehicle;
	
		};
		
		case "rhsusf_stryker_m1126_m2_d": {
	
			[_vehicle, ["Tan",1], ["Hatch_Commander", 0, "Hatch_Front", 0, "Hatch_Left", 0, "Hatch_Right", 0, "Ramp", 0, "Hide_Antenna_1", 0, "Hide_Antenna_2", 0, "Hide_Antenna_3", 0, "Hatch_Driver", 0]] call BIS_fnc_initVehicle;
	
		};
	
		case "rhsusf_mrzr4_w": {
	
			[_vehicle, ["mud_olive", 1]] call BIS_fnc_initVehicle;
	
		};
	
	};
	
	
	
	[_vehicle, _crewGroup]

};

SAC_fnc_createPatrol = {

	//El area de patrullaje puede estar definida por un centro y un radio, ó por un marcador/trigger, en cuyo caso se debe pasar el marcador/trigger en "_centerPos",
	//y establecer "_maxDistance" en cero.
	params ["_centerPos", "_maxDistance", "_blacklistsMarkers", "_unitClasses", "_skill", "_minUnits", "_maxUnits", "_maxPoints", "_minDistanceFromPlayers",
	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"];

	//["_centerPos", "_minDistance", "_maxDistance", "_playerExclusionDistance", "_blacklistsMarkers", "_unitClasses", "_grpSize", "_skill", "_autoDeleteGroup"]
	private _grp = [_centerPos, 0, _maxDistance, _minDistanceFromPlayers, _blacklistsMarkers, _unitClasses call SAC_fnc_shuffleArray, [_minUnits, _maxUnits], _skill, _autoDeleteGroup] call SAC_fnc_createGroup;

	if (!isnull _grp) then {
	
		//10/10/2019
		//["_grp", "_centerPos", "_minDistance", "_maxDistance", "_disableMovement"]
		[_grp, getPos leader _grp, 5, _initialDispersion, _static, _addKilledEH] call SAC_fnc_disperseGroup;
		
		if (!_static) then {
		
			[_grp, ["PATROL"], _centerPos, "LIMITED", "SAFE", 0, 0, 0, "", _maxDistance, _blacklistsMarkers, _maxPoints, _minDistanceBetweenPoints, _plot] call SAC_fnc_orderGroup;
			
		};

		_grp enableDynamicSimulation _dynamicSimulation;
		
	};
	
	_grp

};

SAC_fnc_addInfantryPatrols = {

	//El area de patrullaje puede estar definida por un centro y un radio, ó por un marcador/trigger, en cuyo caso se debe pasar el marcador/trigger en "_centerPos",
	//y establecer "_maxDistance" en cero.
	params ["_centerPos", "_maxDistance", "_maxPatrols", "_grpTypes", "_militiaClasses", "_regularClasses", "_sfClasses", "_blacklistsMarkers", "_minDistanceFromPlayers",
	"_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_initialDispersion", "_static", "_addKilledEH"];

	private ["_i", "_grp", "_unitClasses", "_skill", "_minUnits", "_maxUnits", "_allGrps"];

	/*	
		Determinar el tipo de unidades que se van a crear. Nótese que se crearán unidades de un sólo tipo. Por ej.
		
		_grpTypes = ["militia", "regular"];
		_maxPatrols = 5;
		
		Se crearán 5 grupos de tipo "militia", o 5 grupos de tipo "regular". **NO** se crearán grupos de un tipo y del otro.
		
		Asimismo,
		
		_grpTypes = ["militia", "militia", "militia", "regular"];
		_maxPatrols = 5;
		
		Sólo significa que habrá 3 veces más probabilidades de que los grupos creados sean de tipo "militia", que de tipo "regular".
		
		17/11/2019 El parámetro '_static' crea el grupo pero no le da ninguna orden. Es contra-intuitivo pero el código sería el mismo si lo pongo en otra función.
		14/05/2021 El parámetro '_addKilledEH' se propaga hasta la función que dispersa al grupo, y solo tiene sentido si se usa _static == true,
		y lo que hace es agregar un EH para que si una unidad del grupo muere, las demás reactivan la posibilidad de moverse.
		
	*/
	switch (selectRandom (_grpTypes call SAC_fnc_shuffleArray)) do {

		case "militia": {

			_unitClasses = _militiaClasses;
			_skill = [0.1, 0.2];
			_minUnits = 4;
			_maxUnits = 8;

		};

		case "regular": {

			_unitClasses = _regularClasses;
			_skill = [0.2, 0.3];
			_minUnits = 4;
			_maxUnits = 8;

		};

		case "SF": {

			_unitClasses = _sfClasses;
			_skill = [0.3, 0.4];
			_minUnits = 3;
			_maxUnits = 5;

		};

	};
	
	_allGrps = [];
	
	for "_i" from 1 to _maxPatrols do {

		//["_centerPos", "_maxDistance", "_blacklistsMarkers", "_unitClasses", "_skill", "_minUnits", "_maxUnits", "_maxPoints", "_minDistanceFromPlayers", "_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup", "_dynamicSimulation", "_static"];
		_grp = [_centerPos, _maxDistance, _blacklistsMarkers, _unitClasses, _skill, _minUnits, _maxUnits, 4, _minDistanceFromPlayers, _minDistanceBetweenPoints, _plot, _autoDeleteGroup, _dynamicSimulation, _initialDispersion, _static, _addKilledEH] call SAC_fnc_createPatrol;

		if (isNull _grp) exitWith {"ERROR: No se encontro lugar para crear las patrullas requeridas." call SAC_fnc_MPsystemChat};
		
		_allGrps pushBack _grp;

		//diag_log "Patrulla creada con exito.";

		sleep 0.3;

	};

	_allGrps

};

SAC_fnc_numberBetween = {

	params ["_min", "_max"];

	//diag_log _this;

	//if (count _this != 2) then {diag_log "error en SAC_fnc_numberBetween"};

	(_min + floor (random (_max - _min + 1)))

};

SAC_fnc_initAllUnits = {

	{
	
		if (_x isKindOf "Man" && {!isPlayer _x}) then {
		
			if (_x getVariable ["SAC_GEAR_applyLoadout", true]) then {[_x] call SAC_GEAR_applyLoadoutByClass};
			
			[group _x] call SAC_fnc_setSkills;
			
			(group _x) allowFleeing 0; //27/03/2018

			(group _x) deleteGroupWhenEmpty true;
			
		};
		
	} foreach allUnits;
	
	SAC_INIT_ALL_UNITS_FINISHED = true;
	
};

SAC_fnc_sendTroopsByHeli = {

	/*
	
		28/03/2018 Para que las unidades cuando llegan a destino persigan a los jugadores o enemigos más cercanos, pasar _waypointType = ["PLAYERS"], o
		_waypointType = ["ENEMIES"], respectivamente. Eso activa un modo especial, ya que no se cursa por orderGroup. Atención que el "PLAYERS" y "ENEMIES" son
		mutuamente excluyentes, y no se pueden combinar con otros posibles comportamientos.
	
	*/
	
	params ["_destCargo", "_destVehicle", "_minDistance", "_spawnDistance", "_spawnDir", "_vehicleClasses", "_pilotClass", "_troopClasses", "_skill", "_minTroops", "_maxTroops",
	"_waypointType", "_waypointSpeed", "_waypointBehaviour", "_setCaptive", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_waypointStatements", "_maxDistance",
	"_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup"];

	private ["_crewGrp", "_cargoGrp", "_vehicle", "_troopCount", "_start", "_unitsToGetIn"];

	_crewGrp = grpNull;
	_cargoGrp = grpNull;
	_vehicle = objNull;

	_start = _destCargo getPos [ _spawnDistance, _spawnDir];

	if (count _destVehicle == 0) then {

		//[_centerPos, _minDistance, _posSize, _maxTerrainGradient, _roadAllowed, _noplayerDistance, _maxDistance, _debug, _blacklist] call SAC_fnc_safePosition;
		_destVehicle = [_destCargo, _minDistance, 30, 10, true, 999, 600, false, []] call SAC_fnc_safePosition;

	};

	if (count _destVehicle == 0) exitWith {[_vehicle, _crewGrp, _cargoGrp]};

	private _returnedArray =  [];
	//["_position", "_direction", "_vehicleClasses", "_crewClasses", "_special", "_autoDeleteGroup"]
	_returnedArray = [_start, _start getDir _destVehicle, _vehicleClasses, [_pilotClass], "FLY", _autoDeleteGroup] call SAC_fnc_spawnVehicle;
	_vehicle = _returnedArray select 0;
	_crewGrp = _returnedArray select 1;


	_crewGrp setVariable ["Vcm_Disable", true];
	(group _vehicle) setVariable ["Vcm_Disable", true];
	
	_crewGrp setVariable ["lambs_danger_disableGroupAI", true];
	(group _vehicle) setVariable ["lambs_danger_disableGroupAI", true];
	
	{_x setVariable ["lambs_danger_disableAI", true]} forEach units _crewGrp;


	driver _vehicle disableAI "TARGET";

	_troopCount = ([_minTroops, _maxTroops] call SAC_fnc_numberBetween) min (([_vehicle] call SAC_fnc_cargoSeats) + (count ([_vehicle] call SAC_fnc_personTurrets)));

	if (_troopCount == 0) exitWith {[[_crewGrp] + units _crewGrp + [_vehicle], [], 1, [600, 0], 120, civilian, false, false] spawn SAC_fnc_garbageCollector; [_vehicle, _crewGrp, _cargoGrp]};

	_cargoGrp = [_vehicle getPos [100, 45], [_troopClasses select 0] call SAC_fnc_getSideFromCfg, _troopClasses call SAC_fnc_shuffleArray, [], [], _skill, [], [_troopCount, 0]] call SAC_fnc_spawnGroup;
	{[_x] call SAC_GEAR_applyLoadoutByClass} forEach units _cargoGrp;
	[_cargoGrp] call SAC_fnc_setSkills;
	_cargoGrp allowFleeing 0; //27/03/2018
	
/*	
	_cargoGrp spawn {
	
		sleep 15;
		//{systemChat str (getDammage _x); systemChat str (getPosATL _x)} forEach units _this;
		{systemChat (str _x + "-> " + str (getDammage _x))} forEach units _this;
	
	};
*/	
	

	_cargoGrp deleteGroupWhenEmpty _autoDeleteGroup;
	
	_unitsToGetIn = units _cargoGrp;

	{

		if (count _unitsToGetIn == 0) exitWith {};

		(_unitsToGetIn select 0) moveInTurret [_vehicle, _x];

		_unitsToGetIn deleteAt 0;

	} forEach ([_vehicle] call SAC_fnc_personTurrets);

	{

		_x moveInCargo _vehicle

	} forEach _unitsToGetIn;

	_vehicle doMove _destVehicle;
	_vehicle flyInheight 60;
	_vehicle setCombatMode "YELLOW";
	//2/8/2019 EXPERIMENTAL: Estoy probando el comando setBehaviourStrong y me está dando buenos resultados.
	//_vehicle setBehaviour "CARELESS";
	_vehicle setBehaviourStrong "AWARE";

	if (_setCaptive) then {

		_vehicle setCaptive true;

		{

			_vehicle addEventHandler ["FiredNear", {vehicle (_this select 0) setCaptive false}];

		} forEach crew _vehicle;

	};

	[_vehicle, _destVehicle, _cargoGrp, _destCargo, _crewGrp, getPos _vehicle, _waypointType, _waypointSpeed, _waypointBehaviour, _waypointTimeoutMin, _waypointTimeoutMed, _waypointTimeoutMax, _waypointStatements, _maxDistance, _blacklistsMarkers, _maxPoints, _minDistanceBetweenPoints, _plot] spawn {

		params ["_vehicle", "_destVehicle", "_cargoGrp", "_destCargo", "_crewGrp", "_sourcePosition", "_waypointType", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin",
		"_waypointTimeoutMed", "_waypointTimeoutMax", "_waypointStatements", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"];

		private ["_heliH", "_timeOut"];

		_heliH = createVehicle ["Land_HelipadEmpty_F", _destVehicle, [], 0, "CAN_COLLIDE"];
		waitUntil {(_vehicle distance _destVehicle < 200) || (!canMove _vehicle)};

		if (canMove _vehicle) then {

			_vehicle land "GET IN";

			waitUntil {(unitReady _vehicle) || (!canMove _vehicle)};

			if (canMove _vehicle) then {

				_vehicle setCombatMode "BLUE";
				_vehicle flyInHeight 0;

				_timeOut = time + 30;
				waitUntil {((getPos _vehicle) select 2 <= 2) || {time > _timeOut}};

				if ((getPos _vehicle) select 2 <= 2) then {

					if (typeOf _vehicle in ["RHS_CH_47F_light", "RHS_CH_47F_10", "RHS_CH_47F"]) then {

						_vehicle animateSource ["ramp_anim", 1];

						sleep 3

					} else {

						{_vehicle animateDoor [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

						sleep 2;

					};

					{
						doGetOut _x;
						unassignVehicle _x;
						sleep 0.5;
					} forEach units _cargoGrp;

					if ((_waypointType select 0) in ["ENEMIES", "PLAYERS"]) then {
					
						//28/03/2018 Ya se que es rebuscado, pero me evita escribir otra función que básicamente hace todo lo mismo excepto por esta parte,
						//que permite hacer que las unidades cuando se bajan pasen a ser controlados por la nueva followNearestX.
						[_cargoGrp, _waypointType select 0, "NORMAL", "AWARE", false, _blacklistsMarkers] call SAC_fnc_followNearestX;
						
					} else {
							
						// _wp = _cargoGrp addWaypoint [_destCargo, 0];
						// _wp setWaypointType _waypointType; _wp setWaypointSpeed _waypointSpeed; _wp setWaypointBehaviour _waypointBehaviour;

						//["_grp", "_order", "_centerPos", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"]
						[_cargoGrp, ["MOVE"], _destCargo, _waypointSpeed, _waypointBehaviour, _waypointTimeoutMin, _waypointTimeoutMed, _waypointTimeoutMax, "", _maxDistance, _blacklistsMarkers, _maxPoints, _minDistanceBetweenPoints, _plot] call SAC_fnc_orderGroup;
						//["_grp", "_order", "_centerPos", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"]
						[_cargoGrp, _waypointType, _destCargo, _waypointSpeed, _waypointBehaviour, _waypointTimeoutMin, _waypointTimeoutMed, _waypointTimeoutMax, _waypointStatements, _maxDistance, _blacklistsMarkers, _maxPoints, _minDistanceBetweenPoints, _plot] call SAC_fnc_orderGroup;
					
					};
					
				};

				_vehicle land "NONE";

				_vehicle doMove _sourcePosition;
				_vehicle flyInHeight 60;
				_vehicle setCombatMode "YELLOW";
				//2/8/2019 EXPERIMENTAL: Estoy probando el comando setBehaviourStrong y me está dando buenos resultados.
				//_vehicle setBehaviour "CARELESS";
				_vehicle setBehaviourStrong "AWARE";

				if (typeOf _vehicle in ["RHS_CH_47F_light", "RHS_CH_47F_10", "RHS_CH_47F"]) then {

					_vehicle animateSource ["ramp_anim", 0];

				} else {

					{_vehicle animateDoor [_x, 0]} forEach (_vehicle call SAC_fnc_openableDoors);

				};

				//{_vehicle animateDoor [_x, 0]} forEach (_vehicle call SAC_fnc_openableDoors);

				deleteVehicle _heliH;

				waitUntil {(_vehicle distance _sourcePosition < 200) || (!canMove _vehicle)};

				if (canMove _vehicle) then {

					[[_crewGrp] + units _crewGrp + [_vehicle], [], 1, [600, 0], 120, civilian, false, false] spawn SAC_fnc_garbageCollector

				} else {

					[_crewGrp, true] spawn SAC_fnc_behaviour_crashed_crew;

				};

			} else {

				deleteVehicle _heliH;

				[_crewGrp, true] spawn SAC_fnc_behaviour_crashed_crew;
				[_cargoGrp, false] spawn SAC_fnc_behaviour_crashed_crew;

			};

		} else {

			deleteVehicle _heliH;

			[_crewGrp, true] spawn SAC_fnc_behaviour_crashed_crew;
			[_cargoGrp, false] spawn SAC_fnc_behaviour_crashed_crew;

		};


	};

	[_vehicle, _crewGrp, _cargoGrp]

};

SAC_fnc_sendTroopsByLand = {

	/*
	
		28/03/2018 Para que las unidades cuando llegan a destino persigan a los jugadores o enemigos más cercanos, pasar _waypointType = ["PLAYERS"], o
		_waypointType = ["ENEMIES"], respectivamente. Eso activa un modo especial, ya que no se cursa por orderGroup. Atención que el "PLAYERS" y "ENEMIES" son
		mutuamente excluyentes, y no se pueden combinar con otros posibles comportamientos.
	
	*/
	
	params ["_start", "_destCargo", "_destVehicle", "_minDistance", "_minSpawnDistance", "_maxSpawnDistance", "_vehicleClasses", "_crewClasses", "_speed", "_combatMode",
	"_behaviour", "_troopClasses", "_skill", "_minTroops", "_maxTroops", "_waypointType", "_waypointSpeed", "_waypointBehaviour", "_setCaptive", "_waypointTimeoutMin",
	"_waypointTimeoutMed", "_waypointTimeoutMax", "_waypointStatements", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot",
	"_markInitialPos", "_addPredefinedAction", "_actionDest", "_autoDeleteGroup"];

	private ["_nearestRoad", "_startRoad", "_crewGrp", "_cargoGrp", "_vehicle", "_unitsToGetIn", "_troopCount", "_scanDistance", "_bestStartDir"];

	_crewGrp = grpNull;
	_cargoGrp = grpNull;
	_vehicle = objNull;
	
	_nearestRoad = objNull;
	_scanDistance = 200;
	
	if (count _destVehicle == 0) then {

		//Si se envían muchos camiones a un mismo _destCargo, con el tiempo se satura un mismo tramo de camino, por eso el 7/3/2018
		//cambié "closest", que parecería la opción ideal, por "random", y veré qué resultados produce. El problema es que la solución
		//ideal depende de muchos factores.
		//[_centralPos, _minDistance, _maxDistance, _dir, _blacklist, _noplayerDistance, [_method]]
		//_nearestRoad = [_destCargo, _minDistance, 400, 999, [], 999, "closest"] call SAC_fnc_findRoad;
		
		while {(isNull _nearestRoad) && {_scanDistance <= 1000}} do {
		
			_nearestRoad = [_destCargo, _minDistance, _scanDistance, 999, _blacklistsMarkers, 999, "random"] call SAC_fnc_findRoad;

			_scanDistance = _scanDistance + 100;
			
		};
		
		if (!isNull _nearestRoad) then {
		
			_destVehicle = getpos _nearestRoad;
	
		};

	};

	if (count _destVehicle == 0) exitWith {[_vehicle, _crewGrp, _cargoGrp]};

	_startRoad = objNull;
	
	if (count _start == 0) then {

		_startRoad = [_destCargo, _minSpawnDistance, _maxSpawnDistance, 999, _blacklistsMarkers, 1000, "random"] call SAC_fnc_findRoad;

		if (!isNull _startRoad) then {_start = getpos _startRoad};

	};

	if (count _start == 0) exitWith {[_vehicle, _crewGrp, _cargoGrp]};

	
	//determinar la mejor dirección inicial
	//si se creó sobre un camino
	if (!isNull _startRoad) then {
	
		//elegir la dirección del camino más parecida a la dirección del destino del viaje
		private _roadRelDir = _startRoad getRelDir _destVehicle;
		_bestStartDir = getDir _startRoad;
		if ((_roadRelDir > 90) && {_roadRelDir < 270}) then {_bestStartDir = _bestStartDir - 180};
	
	} else {//si no se creó sobre un camino
	
		//lo mas probable es que trate de tomar el camino más cercano
		private _nearestRoad = [_start, 0, 200, 999, [], 999, "closest"] call SAC_fnc_findRoad;
		if (!isNull _nearestRoad) then {_bestStartDir = _start getDir _nearestRoad} else {_bestStartDir = random 360};
	
	};
	
	
	
	
	private _returnedArray =  [];
	//["_position", "_direction", "_vehicleClasses", "_crewClasses", "_special", "_autoDeleteGroup"]
	_returnedArray = [_start, _bestStartDir, _vehicleClasses, _crewClasses, "NONE", _autoDeleteGroup] call SAC_fnc_spawnVehicle;
	_vehicle = _returnedArray select 0;
	_crewGrp = _returnedArray select 1;

	if (typeOf _vehicle in SAC_problematic_vehicles) then {
	
		_troopCount = ([_minTroops, _maxTroops] call SAC_fnc_numberBetween) min ([_vehicle] call SAC_fnc_cargoSeats);
		
	} else {
	
		_troopCount = ([_minTroops, _maxTroops] call SAC_fnc_numberBetween) min (([_vehicle] call SAC_fnc_cargoSeats) + (count ([_vehicle] call SAC_fnc_personTurrets)));
		
	};

	if (_troopCount == 0) exitWith {[[_crewGrp] + units _crewGrp + [_vehicle], [], 1, [600, 0], 120, civilian, false, false] spawn SAC_fnc_garbageCollector; [_vehicle, _crewGrp, _cargoGrp]};

	_cargoGrp = [getPos _vehicle, [_troopClasses select 0] call SAC_fnc_getSideFromCfg, _troopClasses call SAC_fnc_shuffleArray, [], [], _skill, [], [_troopCount, 0]] call SAC_fnc_spawnGroup;
	{[_x] call SAC_GEAR_applyLoadoutByClass} forEach units _cargoGrp;
	[_cargoGrp] call SAC_fnc_setSkills;
	_cargoGrp allowFleeing 0; //27/03/2018
/*
	_cargoGrp spawn {
	
		sleep 15;
		//{systemChat str (getDammage _x); systemChat str (getPosATL _x)} forEach units _this;
		{systemChat (str _x + "-> " + str (getDammage _x))} forEach units _this;
	
	};
*/	
	_cargoGrp deleteGroupWhenEmpty _autoDeleteGroup;
	
	_unitsToGetIn = units _cargoGrp;

	if !(typeOf _vehicle in SAC_problematic_vehicles) then {
	
		{

			if (count _unitsToGetIn == 0) exitWith {};

			(_unitsToGetIn select 0) moveInTurret [_vehicle, _x];

			_unitsToGetIn deleteAt 0;

		} forEach ([_vehicle] call SAC_fnc_personTurrets);
		
	};

	{

		_x moveInCargo _vehicle

	} forEach _unitsToGetIn;

	sleep 0.5; //quiero ver si es por esto que muchas veces se quedan como si no tuvieran ordenes
	
	//if (true) exitWith {[_vehicle, _crewGrp, _cargoGrp]};
		
	_vehicle move _destVehicle;
	_vehicle setSpeedMode "NORMAL";
	_vehicle setCombatMode _combatMode;
	_vehicle setBehaviour _behaviour;

	if (_setCaptive) then {

		_vehicle setCaptive true;

		{

			_vehicle addEventHandler ["FiredNear", {vehicle (_this select 0) setCaptive false}];

		} forEach crew _vehicle;

	};

	if (_speed != 999) then {_vehicle forceSpeed (((_speed * 1000) / 60) / 60)};

	[_crewGrp, _vehicle, _destVehicle, _cargoGrp, _destCargo, _waypointType, _waypointSpeed, _waypointBehaviour, _waypointTimeoutMin, _waypointTimeoutMed, _waypointTimeoutMax,
	_waypointStatements, _maxDistance, _blacklistsMarkers, _maxPoints, _minDistanceBetweenPoints, _plot] spawn {

		params ["_crewGrp", "_vehicle", "_destVehicle", "_cargoGrp", "_destCargo", "_waypointType", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed",
		"_waypointTimeoutMax", "_waypointStatements", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"];

		private ["_wp", "_driver", "_knownEnemy"];

		//controla una sola cosa: que la unidad no quede trabada y no se mueva de la posición inicial.
		[_vehicle, getPos _vehicle, _destVehicle] spawn {
		
			params ["_v","_pv","_dv"];
			
			private _stuck = false;
			
			sleep 30;
			
			if (_v distance _pv < 10) then {
				
				_stuck = true;
				systemChat "sendTroopsByLand intentando destrabar vehiculo...";
				//le ordeno que avance 150 mts.
				//origin getPos [distance, heading]
				_v move (_v getPos [150, getDir _v]);
				private _timeout = time + 10;
				waitUntil {sleep 1; ((_v distance _pv > 10) || (time > _timeout))};
			
				_pv =  getPos _v;
				//se haya destrabado o no, le repito la orden con el destino real.
				_v move _dv;
				
			};
			
			sleep 20;
			
			if (_v distance _pv < 10) then {
				(format["fnc_sendTroopsByLand had to delete one vehicle of type %1.", typeOf _v]) call SAC_fnc_debugNotify;
				[getPos _v, "ColorBlue", "Debug"] call SAC_fnc_createMarker;
				deleteVehicle _v;
			} else {
			
				if (_stuck) then {systemChat "sendTroopsByLand vehiculo en movimiento."};
			
			};
			
		};
		
		_driver = driver _vehicle;

		//waitUntil {((_vehicle distance _destVehicle) < 10) || (!canMove _vehicle) || (!alive _driver) || (isNull objectParent _driver) || (behaviour _vehicle == "COMBAT")};
		//waitUntil {sleep 1; ((_vehicle distance _destVehicle) < 10) || (!canMove _vehicle) || (!alive _driver) || (isNull objectParent _driver)};
		waitUntil {sleep 1; _knownEnemy = _driver findNearestEnemy _driver;((_vehicle distance _destVehicle) < 10) || (!canMove _vehicle) || (!alive _driver) || (isNull objectParent _driver) || (!(isNull _knownEnemy) && {_knownEnemy distance _driver < 100})};

		doStop _vehicle;
		doGetOut units _cargoGrp;
		{unassignVehicle _x} foreach units _cargoGrp;

		sleep 3;

		if ((_waypointType select 0) in ["ENEMIES", "PLAYERS"]) then {
		
			//28/03/2018 Ya se que es rebuscado, pero me evita escribir otra función que básicamente hace todo lo mismo excepto por esta parte,
			//que permite hacer que las unidades cuando se bajan pasen a ser controlados por la nueva followNearestX.
			[_cargoGrp, _waypointType select 0, "NORMAL", "AWARE", false, _blacklistsMarkers] call SAC_fnc_followNearestX;
			
		} else {
		
			//Solo le da las intrucciones originales si se llegó a destino. Es decir, si el camión se detiene antes las tropas se bajan y
			//no reciben más órdenes.
			if ((_vehicle distance _destVehicle) < 10) then {
				
				// _wp = _cargoGrp addWaypoint [_destCargo, 0];
				// _wp setWaypointType _waypointType; _wp setWaypointSpeed _waypointSpeed; _wp setWaypointBehaviour _waypointBehaviour;

				//["_grp", "_order", "_centerPos", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"]
				[_cargoGrp, ["MOVE"], _destCargo, _waypointSpeed, _waypointBehaviour, _waypointTimeoutMin, _waypointTimeoutMed, _waypointTimeoutMax, "", _maxDistance, _blacklistsMarkers, _maxPoints, _minDistanceBetweenPoints, _plot] call SAC_fnc_orderGroup;
				//["_grp", "_order", "_centerPos", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"]
				[_cargoGrp, _waypointType, _destCargo, _waypointSpeed, _waypointBehaviour, _waypointTimeoutMin, _waypointTimeoutMed, _waypointTimeoutMax, _waypointStatements, _maxDistance, _blacklistsMarkers, _maxPoints, _minDistanceBetweenPoints, _plot] call SAC_fnc_orderGroup;
			
			};
		
		};
		
		if ([_vehicle] call SAC_fnc_hasGunner) then {

			_wp = (group _vehicle) addWaypoint [getPos _vehicle, 0];
			_wp setWaypointType "HOLD"; _wp setWaypointSpeed "NORMAL"; _wp setWaypointBehaviour "AWARE";

		} else {
		
			//hacer que se bajen del vehículo y se sumen al que transportó, porque sólo es de transporte.
			private _crewUnits = units _crewGrp;
			doGetOut _crewUnits;
			{unassignVehicle _x} foreach _crewUnits;
			//las unidades estaban en modo "CARELESS" y en ese modo siguen cuando se las agrega al otro grupo, así que hay que cambiarles manualmente el behaviour.
			_crewGrp setBehaviour _waypointBehaviour;
			_crewGrp setCombatMode "YELLOW"; //fire at will
			_crewUnits joinSilent _cargoGrp;
			{_x doFollow leader _cargoGrp} forEach _crewUnits;
			
		
		};


	};

	if (_markInitialPos) then {

		[getPos _vehicle, "ColorBlue", " Vehicle", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;

	};

	if (_addPredefinedAction) then {

		//["_object", "_actionTitle", "_titleText", "_actionType", "_position", "_timer"]
		[driver _vehicle, "<t color='#FF0000'>*** SEARCH BODY ***</t>", "YOU'VE GOT AN ADDRESS", 1, _actionDest, 0] call SAC_fnc_addPredefinedAction;

	};

	//SAC_Zeus addCuratorEditableObjects [[_vehicle], true];
	
	[_vehicle, _crewGrp, _cargoGrp]

};

SAC_fnc_sendInterceptor = {

	/*
	
		_targetType			//puede ser "ENEMIES" o "PLAYERS"
	
	
	*/
	
	params ["_targetPos", "_targetType", "_minSpawnDistance", "_maxSpawnDistance", "_vehicleClasses", "_crewClasses",	"_skill", "_setCaptive",
	"_blacklistsMarkers", "_autoDeleteGroup"];

	private ["_startRoad", "_crewGrp", "_vehicle", "_scanDistance", "_bestStartDir", "_startPos"];

	_crewGrp = grpNull;
	_vehicle = objNull;
	
	_startRoad = [_targetPos, _minSpawnDistance, _maxSpawnDistance, 999, _blacklistsMarkers, 1000, "random"] call SAC_fnc_findRoad;

	if (isNull _startRoad) exitWith {[_vehicle, _crewGrp]};
	
	_startPos = getPos _startRoad;
	
	
	
	//determinar la mejor dirección inicial
	//elegir la dirección del camino más parecida a la dirección del destino del viaje
	private _roadRelDir = _startRoad getRelDir _targetPos;
	_bestStartDir = getDir _startRoad;
	if ((_roadRelDir > 90) && {_roadRelDir < 270}) then {_bestStartDir = _bestStartDir - 180};
	
	
	
	private _returnedArray =  [];
	//["_position", "_direction", "_vehicleClasses", "_crewClasses", "_special", "_autoDeleteGroup"]
	_returnedArray = [_startPos, _bestStartDir, _vehicleClasses, _crewClasses, "NONE", _autoDeleteGroup] call SAC_fnc_spawnVehicle;
	_vehicle = _returnedArray select 0;
	_crewGrp = _returnedArray select 1;

	sleep 0.5; //quiero ver si es por esto que muchas veces se quedan como si no tuvieran ordenes
	
	[_crewGrp, _targetType, "NORMAL", "AWARE", false, _blacklistsMarkers] call SAC_fnc_followNearestX;
	
/*

	26/05/2022 Decubrí que no se puede hacer este control, porque el comportamiento normal de SAC_fnc_followNearestX,
	cuando no detecta enemigos cerca, es dejarlo en el lugar, sin ordenes de movimiento. Esto significa que haber tenido
	este control que borraba el vehículo, fue un posible error desde el comienzo.

	//controla una sola cosa: que la unidad no quede trabada y no se mueva de la posición inicial.
	[_vehicle, getPos _vehicle] spawn {
		sleep 60;
		if ((_this select 0) distance (_this select 1) < 10) then {
			(format["fnc_sendInterceptor had to delete one vehicle of type %1.", typeOf (_this select 0)]) call SAC_fnc_debugNotify;
			deleteVehicle (_this select 0);
		};
		
	};
*/		
	if (_setCaptive) then {

		_vehicle setCaptive true;

		{

			_vehicle addEventHandler ["FiredNear", {vehicle (_this select 0) setCaptive false}];

		} forEach crew _vehicle;

	};

	[_vehicle, _crewGrp]

};

SAC_fnc_createVehicleInSupportRole = {

	/*

		Permite crear un tanque con un waypoint GUARD, por ejemplo.

	*/

	params ["_centerPos", "_minSpawnDistance", "_maxSpawnDistance", "_vehicleClasses", "_crewClasses", "_skill", "_waypointSpeed", "_blacklistsMarkers"];

	private ["_startRoad", "_startPos", "_crewGrp", "_vehicle"];

	_crewGrp = grpNull;
	_vehicle = objNull;
	
	if (count _vehicleClasses == 0) exitWith {[_vehicle, _crewGrp]};

	//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, [_method]] call SAC_fnc_findRoad;
	_startRoad = [_centerPos, _minSpawnDistance, _maxSpawnDistance, 999, _blacklistsMarkers, 800, "random"] call SAC_fnc_findRoad;

	if (!isNull _startRoad) then {

		_startPos = getpos _startRoad;

	} else {

		//[_centerPos, _minDistance, _posSize, _maxTerrainGradient, _roadAllowed, _noplayerDistance, _maxDistance, _debug, _blacklist] call SAC_fnc_safePosition;
		_startPos = [_centerPos, _minSpawnDistance, 10, 20, true, 800, _maxSpawnDistance, false, _blacklistsMarkers] call SAC_fnc_safePosition;

	};


	if (count _startPos == 0) exitWith {[_vehicle, _crewGrp]};

	private _returnedArray =  [];
	//["_position", "_direction", "_vehicleClasses", "_crewClasses", "_special", "_autoDeleteGroup"]
	_returnedArray = [_startPos, random 360, _vehicleClasses, _crewClasses, "NONE", false] call SAC_fnc_spawnVehicle;
	_vehicle = _returnedArray select 0;
	_crewGrp = _returnedArray select 1;
	
/*
	private ["_wp"];
	_wp = _crewGrp addWaypoint [_startPos, 0];
	_wp setWaypointType "GUARD"; _wp setWaypointSpeed _waypointSpeed;
*/
	
	//["_grp", "_order", "_centerPos", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"]
	[_crewGrp, ["GUARD"], _centerPos, _waypointSpeed, "AWARE", 0, 0, 0, "", 0, [], 0, 0, false] call SAC_fnc_orderGroup;


	[_vehicle, _crewGrp]

};

SAC_fnc_putVehicleOutsideBuilding = {

	params ["_building", "_vehClasses"];

	private ["_vehPos", "_veh"];

	_veh = objNull;

	//[_centerPos, _minDistance, _posSize, _maxTerrainGradient, _roadAllowed, _noplayerDistance, _maxDistance, _debug, _blacklist] call SAC_fnc_safePosition;
	_vehPos = [getPos _building, 0, 5.5, 20, false, 999, 30, false, []] call SAC_fnc_safePosition;

	if (count _vehPos > 0) then {

		_veh = [_vehClasses, _vehPos] call SAC_fnc_createVehicle;

		//_car setDir (getDir _building);
		_veh setDir (getDir (nearestBuilding _veh)); //el problema actual con nearestBuilding es que no reconoce los edificios de los mapas de A2

		_veh setPos _vehPos;

		clearItemCargoGlobal _veh;
		clearWeaponCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;

	};

	_veh

};

SAC_fnc_createGarrison = {

/*

	Si _idle, el grupo está afuera de la casa, y se mueve alrededor cada tanto.

	_unitCount es un array
	
	Si se pasa _unitCount == [999,999] se ocupan la mitad de las posiciones.
	Si se pasa _unitCount == [555,555] se ocupan todas las posiciones.
	Si se pasa _unitCount == [333,333] se ocupan 3/4 de las posiciones.

*/

	params ["_building", "_unitClasses", "_skill", "_unitCount", "_vehClasses", "_idle", "_autoDeleteGroup", "_hardcoreStop"];

	private ["_grpSize", "_grp", "_veh", "_maxRoamingDistance"];

	private _side = [_unitClasses select 0] call SAC_fnc_getSideFromCfg;

	_grp = grpNull;

	_veh = objNull;

	//defensive code
	if ((!_idle) && {count (_building call SAC_fnc_buildingPos) == 0}) exitWith {"(!_idle) && {count (_building call SAC_fnc_buildingPos) == 0} en SAC_fnc_createGarrison" call SAC_fnc_debugNotify};

	_grpSize = [];

	switch (_unitCount select 0) do {
	
		case 999: {
		
			_grpSize set [0, count (_building call SAC_fnc_buildingPos) / 2];

			_grpSize set [1, count (_building call SAC_fnc_buildingPos) / 2];
		
		};
		
		case 555: {
		
			_grpSize set [0, count (_building call SAC_fnc_buildingPos)];

			_grpSize set [1, count (_building call SAC_fnc_buildingPos)];
		
		};
		
		case 333: {
		
			_grpSize set [0, floor (count (_building call SAC_fnc_buildingPos) * 0.75)];

			_grpSize set [1, floor (count (_building call SAC_fnc_buildingPos) * 0.75)];
		
		};
		
		default {
	
			if (_idle) then { //recordar que si _idle == true las unidades van afuera, y generalmente las _minPos del edificio == 0

				_grpSize = _unitCount;

			} else {

				_grpSize set [0, (_unitCount select 0 ) min (count (_building call SAC_fnc_buildingPos))];

				_grpSize set [1, (_unitCount select 1 ) min (count (_building call SAC_fnc_buildingPos))];

			};
			
		};
		
	};

	//("_grpSize --> " + (str _grpSize)) call SAC_fnc_debugNotify;
	
	_grp = [getPos _building, 10 , 50, 999, [], _unitClasses call SAC_fnc_shuffleArray, _grpSize, _skill, _autoDeleteGroup] call SAC_fnc_createGroup;

	{_x call SAC_fnc_addHandleDamageAI} forEach units _grp;

	if (_idle) then {
	//if (_idle || {(_building buildingPos -1) < (count units _grp)}) then {

		//si son civiles se alejan más de la casa, para simular presencia en las villas
		_maxRoamingDistance = if (_side == civilian) then {50} else {15};

		//["_group", "_object", "_isBuilding", "_minDistance", "_maxDistance", "_wait", "_removeWeapons"]
		[_grp, _building, false, (sizeOf typeOf _building) * 1.5, ((sizeOf typeOf _building) * 1.5) + _maxRoamingDistance, [10, 25], ["none"]] spawn SAC_fnc_behaviour_idle;

	} else {

		//"hardcore_stop" es un parámetro nuevo que hace que las unidades no se muevan nunca de sus posiciones, pero giren y cambien de postura para
		//dispararle a los enemigos (y a veces hasta funciona :)).
		
		[units _grp, _building, ["middle", "up"], false, (if (random 1 < _hardcoreStop) then {"hardcore_stop"} else {""}), "enable_attack"] call SAC_fnc_putUnitsInBuilding;

	};

	_building setVariable ["SAC_empty", false];

	if (count _vehClasses > 0) then {

		//Muchas veces los vehículos colisionan con los edificios hasta que explotan. Hasta que arregle el problema lo desactivo.
		//_veh = [_building, _vehClasses] call SAC_fnc_putVehicleOutsideBuilding;

	};
	
	if ([side _grp, SAC_PLAYER_SIDE] call BIS_fnc_sideIsEnemy ) then {SAC_garrisons pushBack _building};

	[_grp, _veh]

};
/*
SAC_fnc_createGarrison_v2 = {

	params ["_building", "_unitClasses", "_skill", "_side", "_unitCount", "_vehClasses", "_idle"];

	private ["_grpSize", "_grp", "_veh", "_maxRoamingDistance"];

	_grp = grpNull;

	_veh = objNull;

	_grpSize = (_unitCount call SAC_fnc_numberBetween) min (count (_building buildingPos -1));

	_grp = [getPos _building, 10 , 50, 999, [], _unitClasses call SAC_fnc_shuffleArray, _grpSize, _skill, false] call SAC_fnc_createGroup;

	if (isNull _grp) exitWith {systemChat "createGarrison_v2 no pudo encontrar posicion libre afuera"};

	// _grp = [getPos _building, _side, _unitClasses call SAC_fnc_shuffleArray, [], [], _skill, [], [_grpSize, 0]] call SAC_fnc_spawnGroup;
	// {[_x] call SAC_GEAR_applyLoadoutByClass} forEach units _grp;

	if (_idle) then {

		private ["_returnedArray", "_maxWidth", "_maxLength"];

		_returnedArray = _building call SAC_fnc_sizeOf;
		_maxWidth = _returnedArray select 0;
		_maxLength = _returnedArray select 1;

		//si son civiles se alejan más de la casa, para simular presencia en las villas
		_maxRoamingDistance = if (_side == civilian) then {50} else {15};

		//["_group", "_object", "_isBuilding", "_minDistance", "_maxDistance", "_wait", "_removeWeapons"]
		[_grp, _building, true, (_maxWidth max _maxLength) * 1.5, ((_maxWidth max _maxLength) * 1.5) + _maxRoamingDistance, [10, 25], ["none", "random_some"]] spawn SAC_fnc_behaviour_idle;

	} else {

		[units _grp] spawn SAC_fnc_orderGroupGarrisonBuilding;


		//"hardcore_stop" es un parámetro nuevo que hace que las unidades no se muevan nunca de sus posiciones, pero giren y cambien de postura para
		//dispararle a los enemigos (y a veces hasta funciona :)).
		//[units _grp, _building, ["middle", "up"], false, "hardcore_stop"] call SAC_fnc_putUnitsInBuilding;

	};

	_building setVariable ["SAC_empty", false];

	if (count _vehClasses > 0) then {

		_veh = [_building, _vehClasses] call SAC_fnc_putVehicleOutsideBuilding;

	};

	[_grp, _veh]

};
*/

SAC_fnc_disperseGroup = {

/*

	Dispersa las unidades de un grupo y, opcionalmente, les impide moverse de sus posiciones.

*/

	params ["_grp", "_centerPos", "_minDistance", "_maxDistance", "_disableMovement", "_addKilledEH"];

	private ["_watchDir", "_watchPos"];

	//dispersar al grupo
	{
	
		_x setPos (_centerPos getPos [[_minDistance, _maxDistance] call SAC_fnc_numberBetween, random 360]);
		_watchDir = random 360;
		_watchPos = _x getPos [100, _watchDir];
		_x lookAt _watchPos;
		_x doWatch _watchPos;
		_x setDir _watchDir;
		if (_disableMovement) then {
		
			_x disableAI "PATH";
			
			if (_addKilledEH) then {

				_x addEventHandler ["Killed", {
				
					//params ["_unit", "_killer", "_instigator", "_useEffects"];
					
					{
					
						_x enableAI "PATH";
						_x removeEventHandler ["Killed", _thisEventHandler];
						
					} foreach units group (_this select 0);
					
				}];

			};
			
		};
	
	} foreach units _grp;
	
	
};

SAC_fnc_disperseUnits = {

/*

	Dispersa las unidades y, opcionalmente, les impide moverse de sus posiciones.

*/

	params ["_units", "_centerPos", "_minDistance", "_maxDistance", "_disableMovement"];

	private ["_watchDir", "_watchPos"];

	//dispersar al grupo
	{
	
		_x setPos (_centerPos getPos [[_minDistance, _maxDistance] call SAC_fnc_numberBetween, random 360]);
		_watchDir = random 360;
		_watchPos = _x getPos [100, _watchDir];
		_x lookAt _watchPos;
		_x doWatch _watchPos;
		_x setDir _watchDir;
		if (_disableMovement) then {_x disableAI "PATH"};
	
	} foreach _units;
	
};

SAC_fnc_markAllUniqueBuildings = {

	/*

		Marca un edificio de cada tipo en un mapa completo, que cumplan con los criterios especificados. Es decir, sirve para
		encontrar un edificio de cada tipo de los que existen en el mapa. Tambien copia la lista de clases al portapapeles.

	*/


	params ["_minPos", "_exclusionClasses"];

	private ["_allBuildings", "_uniqueBuildings"];

	_allBuildings = [0,0,0] nearObjects ["Building", 50000];

	_uniqueBuildingClasses = [];
	{

		if ((count (_x buildingPos -1) >= _minPos) && {!(typeOf _x in _exclusionClasses)} && {!(typeOf _x in _uniqueBuildingClasses)}) then {

			[getPos _x, "ColorBlue", "", "", [0.5, 0.5]] call SAC_fnc_createMarker;

			_uniqueBuildingClasses pushBackUnique typeOf _x;


		};

	} forEach _allBuildings;

	copyToClipBoard str _uniqueBuildingClasses;

	systemChat str (count _uniqueBuildingClasses);
	systemChat "terminado";

};

SAC_fnc_relPosToNearestBuilding = {

	private _building = nearestBuilding player;

	//[typeOf _building] call SAC_fnc_debugNotify;
	systemChat typeOf _building;
	[str (_building worldToModel (getPosATL player))] call SAC_fnc_debugNotify;

	[getPos _building, "ColorBlack", ""] call SAC_fnc_createMarker;


};

SAC_fnc_relPosToCursorTarget = {

	private _object = cursorTarget;

	//[typeOf _building] call SAC_fnc_debugNotify;
	systemChat typeOf _object;
	[str (_object worldToModel (getPosATL player))] call SAC_fnc_debugNotify;

	[getPos _object, "ColorBlack", ""] call SAC_fnc_createMarker;
	[getPos player, "ColorBlue", ""] call SAC_fnc_createMarker;


};

SAC_fnc_addGarrisons = {

/*

	_minPositions es un array. El primer elemento indica la cantidad de posiciones mínimas con las que
	empezar a buscar el edifcio, y el segundo elemento indica hasta qué número bajar ese requerimiento.
	
	Por ejemplo, [7,1], significa que se intenten crear los grupos en los edificios con 7 posiciones
	ocupables, y que se si no se pueden crear los grupos necesarios en esa clase de edificio, se pueda
	ir bajando hasta 1 posición ocupable. La función termina cuando se crearon la cantidad de grupos
	requeridos, o cuando ya no se permite bajar más el requerimiento de posiciones ocupables.

*/

	params ["_centerPos", "_maxGroups", "_minDistance", "_maxDistance", "_minPositions", "_playerExclusionDistance", "_isolated", "_blacklistsMarkers", "_grpTypes",
	"_militiaClasses", "_regularClasses", "_sfClasses", "_civClasses", "_unitCount", "_vehProb", "_militiaVehClasses", "_regularVehClasses", "_sfVehClasses",
	"_civVehClasses", "_idleProb", "_exclusionClasses", "_autoDeleteGroup", "_hardcoreStop"];

	private ["_allBuildings", "_building", "_grp", "_unitClasses", "_vehClasses", "_allGrps", "_skill", "_returnedArray", "_idle", "_occupiedBuildings", "_isolatedString"];

	_allGrps = [];
	_occupiedBuildings = [];

	//si uso "House" no encuentra los arboles sniper del unsung
	//_allBuildings = _centerPos nearObjects ["House", _maxDistance];
	_allBuildings = _centerPos nearObjects ["Building", _maxDistance];
	_allBuildings call SAC_fnc_shuffleArray;
	
//	_allBuildings = _centerPos nearObjects ["House", _maxDistance];
/*	
	{
	
		switch (count (_x buildingPos -1)) do {
		
			case 6: {[getPos _x, "ColorRed", ""] call SAC_fnc_createMarker};
			case 5: {[getPos _x, "ColorOrange", ""] call SAC_fnc_createMarker};
			case 4: {[getPos _x, "ColorYellow", ""] call SAC_fnc_createMarker};
			case 3: {[getPos _x, "ColorGreen", ""] call SAC_fnc_createMarker};
			case 2: {[getPos _x, "ColorBlue", ""] call SAC_fnc_createMarker};
			case 1: {[getPos _x, "ColorBrown", ""] call SAC_fnc_createMarker};
			case 0: {[getPos _x, "ColorBlack", "", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker};
			default {[getPos _x, "ColorRed", "", "hd_objective"] call SAC_fnc_createMarker};
		
		};
	
	} forEach _allBuildings;
*/

/*	
	Determinar el tipo de unidades que se van a crear. Nótese que se crearán unidades de un sólo tipo. Por ej.
	
	_grpTypes = ["militia", "regular"];
	_maxGroups = 5;
	
	Se crearán 5 grupos de tipo "militia", o 5 grupos de tipo "regular". **NO** se crearán grupos de un tipo y del otro.
	
	Asimismo,
	
	_grpTypes = ["militia", "militia", "militia", "regular"];
	_maxGroups = 5;
	
	Sólo significa que habrá 3 veces más probabilidades de que los grupos creados sean de tipo "militia", que de tipo "regular".
	
*/
	switch (selectRandom (_grpTypes call SAC_fnc_shuffleArray)) do {

		case "militia": {

			_unitClasses = _militiaClasses;
			_vehClasses = _militiaVehClasses;
			_skill = [0.2, 0.4];

		};

		case "regular": {

			_unitClasses = _regularClasses;
			_vehClasses = _regularVehClasses;
			_skill = [0.4, 0.6];

		};

		case "SF": {

			_unitClasses = _sfClasses;
			_vehClasses = _sfVehClasses;
			_skill = [0.6, 0.8];

		};

		case "civilian": {

			_unitClasses = _civClasses;
			_vehClasses = _civVehClasses;
			_skill = [0.1, 0.2];

		};

	};

	_isolatedString = if (_isolated) then {"isolated"} else {""};
	
	private _buildingPositions = _minPositions select 0;
	
	while {(count _occupiedBuildings < _maxGroups) && {_buildingPositions >= _minPositions select 1}} do {
	
		for "_c" from 1 to (_maxGroups - count _occupiedBuildings) do {

			//[_centralPos, _minDistance, _maxDistance, _minPositions, _bannedTypes, _playerExclusionDistance, _blacklist, [_methods]] call SAC_fnc_findBuilding;
			_building = [_centerPos, _minDistance, _maxDistance, _buildingPositions, _exclusionClasses, _playerExclusionDistance, _blacklistsMarkers, _allBuildings, "random", "empty", _isolatedString, "useProvidedArray"] call SAC_fnc_findBuilding;

			if (isNull _building) exitWith {};
			
			if (random 1 > _vehProb) then {_vehClasses = []};

			_idle = if (random 1 < _idleProb) then {true} else {false};

			//["_building", "_unitClasses", "_skill", "_unitCount", "_vehClasses", "_idle", "_autoDeleteGroup", "_hardcoreStop"];
			_returnedArray = [_building, _unitClasses, _skill, _unitCount, _vehClasses, _idle, _autoDeleteGroup, _hardcoreStop] call SAC_fnc_createGarrison;
			_grp = _returnedArray select 0;

			if (!isNull _grp) then {

				_allGrps pushBack _grp;
				_occupiedBuildings pushBack _building;
	/*			
				if (_musicSource) then {

				
					if !([_building, 100] call SAC_fnc_nearMusicSources) then {
					
						_building setVariable ["SAC_isMusicSource", true, true];
						if (count SAC_songs > 0) then {[_building] spawn SAC_fnc_musicSource};
						
					};

				};
	 */	
			};
			
			sleep 0.5;

		};
		
		_buildingPositions = _buildingPositions - 1;
		
	};

	[_allGrps, _occupiedBuildings]

};

SAC_fnc_nearMusicSources = {

	params ["_object", "_maxDistance"];
	
	//por ahora sólo tiene en cuenta buildings, porque es el uso que necesito
	private _allBuildings = _object nearObjects ["House", _maxDistance];
	
	private _musicSources = 0;
	
	{
	
		if (_x getVariable ["SAC_isMusicSource", false]) then {_musicSources = _musicSources + 1};
	
	} forEach _allBuildings;
	
	//systemChat str _musicSources;
	
	if (_musicSources > 0) then {true} else {false}


};

SAC_fnc_musicSource = {

	params ["_object"];
	
	while {alive _object} do {
	
		[_object, selectRandom SAC_songs, 100] call SAC_fnc_netSay3D;
	
		uiSleep (5*60);
	};
};

SAC_fnc_radioSource = {

	params ["_object"];
	
	while {alive _object} do {
	
		[_object, selectRandom SAC_radioChatter, 100] call SAC_fnc_netSay3D;
	
		sleep (5*60);
	};
};

SAC_fnc_sendQRF = {

/*
	_destination puede ser una posición o un objeto (un trigger es un objeto en este caso)
	_delay es en la forma [_minDelay, _maxDelay], expresado en segundos
	_minDistance es la distancia mínima hasta donde podrían ingresar los vehículos
	_troopCount es en la forma [_minTroops, _maxTroops]
	_roadSpawnDistance es en la forma [_minRoadSpawnDistance, _maxRoadSpawnDistance]
	se puede desactivar un tipo de insercion, pasando un array vacío en las clases de vehículos correspondiente
	26/03/2018 _taskTypes permite especificar lo que las unidades tienen que hacer cuando lleguen al objetivo, por ej. ["HOLD", "GUARD", "PATROL"], ["ENEMIES"], o ["PLAYERS"]
	28/03/2018 Tener en cuenta que los tipos de tareas "ENEMIES" y "PLAYERS", son mutuamente excluyentes, y no se pueden combinar con los otros tipos de tareas, porque cada uno
	instruye a sendTroopsByLand, y a SAC_fnc_sendTroopsByHeli, a no cursar las ordenes por orderGroup, sino por followNearestX, al momento del desembarco.
*/

	params ["_destination", "_delay", "_minDistance", "_roadSpawnDistance", "_landVehClasses", "_crewClasses", "_speed", "_combatMode", "_behaviour", "_troopClassesLand",
	"_landSkill", "_setCaptiveLand", "_airSpawnDistance", "_heliClasses", "_pilotClass", "_troopClassesAir", "_airSkill", "_setCaptiveAir", "_troopCount", "_landProb",
	"_autoDeleteGroup", "_blacklistsMarkers", "_taskTypes"];


	//systemChat str _this;
	//diag_log _this;
	
	private ["_destCargo", "_returnedArray", "_crewGrp", "_order"];

	if (_destination isEqualType []) then {_destCargo = _destination} else {_destCargo = getPos _destination};

	_crewGrp = grpNull;

	sleep (_delay call SAC_fnc_numberBetween);

	if (random 1 < _landProb) then {

		_order = ["LAND", "AIR"];

	} else {

		_order = ["AIR", "LAND"];

	};

	scopeName "main_sendQRF";
	{

		switch (_x) do {

			case "LAND": {

				if (count _landVehClasses > 0) then {

					//["_start", "_destCargo", "_destVehicle", "_minDistance", "_minSpawnDistance", "_maxSpawnDistance", "_vehicleClasses", "_crewClasses", "_speed", "_combatMode", "_behaviour", "_troopClasses", "_skill", "_minTroops", "_maxTroops", "_waypointType", "_waypointSpeed", "_waypointBehaviour", "_setCaptive", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot", "_markInitialPos", "_addPredefinedAction", "_actionDest", "_autoDeleteGroup"]
					_returnedArray = [[], _destCargo, [], _minDistance, _roadSpawnDistance select 0, _roadSpawnDistance select 1, _landVehClasses, _crewClasses, _speed, _combatMode, _behaviour, _troopClassesLand, _landSkill, _troopCount select 0, _troopCount select 1, _taskTypes, "NORMAL", "AWARE", _setCaptiveLand, 0, 0, 0, "", 500, _blacklistsMarkers, 4, 100, false, false, false, [], _autoDeleteGroup] call SAC_fnc_sendTroopsByLand;

					if (!isNull(_returnedArray select 1)) then {breakTo "main_sendQRF"};

				};
			};

			case "AIR": {

				if (count _heliClasses > 0) then {

					//["_destCargo", "_destVehicle", "_minDistance", "_spawnDistance", "_spawnDir", "_vehicleClasses", "_pilotClass", "_troopClasses", "_skill", "_minTroops", "_maxTroops", "_waypointType", "_waypointSpeed", "_waypointBehaviour", "_setCaptive", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot", "_autoDeleteGroup"]
					_returnedArray = [_destCargo, [], _minDistance, _airSpawnDistance, random 360, _heliClasses, _pilotClass, _troopClassesAir, _airSkill, _troopCount select 0, _troopCount select 1, _taskTypes, "NORMAL", "AWARE", _setCaptiveAir, 0, 0, 0, "", 500, _blacklistsMarkers, 4, 100, false, _autoDeleteGroup] call SAC_fnc_sendTroopsByHeli;

					if (!isNull(_returnedArray select 1)) then {breakTo "main_sendQRF"};

				};

			};
		};

	} forEach _order;

	_returnedArray

};

SAC_fnc_followNearestX = {

/*

	Podría ser mejor no darles órdenes si están en modo COMBAT, pero tendría que esperar y eso congestionaría el engine. Me
	parece que no traería muchos problemas darles un waypoint nuevo mientras estén en COMBAT, porque creo que no se daría por completado si no se
	llegó a la posición nueva, pero cuidado.

*/

	params ["_grp", "_objetive", "_waypointSpeed", "_waypointBehaviour", "_flying", "_blacklistMarkers"];

	//diag_log _this;

	//19/12/2019 Estaba pasando que 'side _grp' daba 'UNKNOWN', no busqué la razón exacta, pero asumo que el grupo ya no existe.
	if (isNull _grp) exitWith {};

	private ["_waypointStatements", "_objectivePos"];
	
	_waypointStatements = format ["[(group this), '%1', '%2', '%3', %4, %5] call SAC_fnc_followNearestX", _objetive, _waypointSpeed, _waypointBehaviour, _flying, _blacklistMarkers];

	//diag_log _waypointStatements;
	
	private _enemySides = [side _grp] call SAC_fnc_findEnemySides;
	
	//19/12/2019 Estaba pasando que 'side _grp' daba 'UNKNOWN', no busqué la razón exacta, pero asumo que el grupo ya no existe.
	if (count _enemySides == 0) exitWith {};
	
	//esta detección más compleja fue necesaria porque el grupo puede ser el cargo de un camión, y si la llamada los agarra a medio desembarcar
	//se creía que era un vehículo
	private _isVehicle = if ((!isNull objectParent leader _grp) && {group driver vehicle leader _grp == _grp}) then {true} else {false};

	//diag_log _isVehicle;
	
	private _posibleObjectives = if (_objetive == "ENEMIES") then {allUnits} else {allPlayers};
	
	private _validObjectives = [_posibleObjectives, _enemySides, _flying, _blacklistMarkers] call SAC_fnc_unitListFiltered;

	//diag_log count _validObjectives;
	
	if (count _validObjectives == 0) then {
	
		//Si no hay objetivos válidos
		if (!_isVehicle) then {
		
			[_grp, ["PATROL"], getPos leader _grp, "LIMITED", "SAFE", 0, 0, 0, "", 1000, _blacklistMarkers, 4, 500, false] call SAC_fnc_orderGroup;
		
		} else {
		
			//los vehículos no reciben ninguna órden, solo quedan ahí
			//"followNearestX: No valid units to follow." call SAC_fnc_debugNotify;
		
		};
	
	} else {
		
		_objectivePos = getPos ([_validObjectives, leader _grp] call BIS_fnc_nearestPosition);
		
		//diag_log _objectivePos;
		
		if (!_isVehicle) then {
		
			//****************************************************
			//Si son tropas de a pié
			//****************************************************
			
			//si el objetivo más cercano está a más de 1500 mts., empezar a patrulla y salir
			if (leader _grp distance _objectivePos > 1500) then {
			
				[_grp, ["PATROL"], getPos leader _grp, "LIMITED", "SAFE", 0, 0, 0, "", 1000, _blacklistMarkers, 4, 500, false] call SAC_fnc_orderGroup;
				//"It's too far bro, and we ain't have no wheels." call SAC_fnc_debugNotify;
				
			} else {
			
				[_grp, ["MOVE"], _objectivePos, _waypointSpeed, _waypointBehaviour, 0, 0, 0, _waypointStatements, 0, [], 0, 0, false] call SAC_fnc_orderGroup;
			
			};	
		
		} else {
		
			//****************************************************
			//Si es un vehículo
			//****************************************************
		
			//Si el objetivo está a más de 500 mts., y el objetivo está lejos de un camino, mandarlo al camino más cercano al objetivo
			private _nearRoad = [_objectivePos, 0, 250, 999, [], 999, "random"] call SAC_fnc_findRoad;
			if ((leader _grp distance _objectivePos > 500) && {isNull _nearRoad}) then {

				_nearRoad = [_objectivePos, 0, 500, 999, [], 999, "random"] call SAC_fnc_findRoad;
				
				if (!isNull _nearRoad) then {
				
					[_grp, ["MOVE"], getPos _nearRoad, _waypointSpeed, _waypointBehaviour, 0, 0, 0, _waypointStatements, 0, [], 0, 0, false] call SAC_fnc_orderGroup;
				
				} else {
				
					if !([_objectivePos, 50, 15] call SAC_fnc_isForest) then {
					
						//si no hay caminos, y no es un bosque, lo mando y espero lo mejor
						[_grp, ["MOVE"], _objectivePos, _waypointSpeed, _waypointBehaviour, 0, 0, 0, _waypointStatements, 0, [], 0, 0, false] call SAC_fnc_orderGroup;
						//"May the force be with you." call SAC_fnc_debugNotify;
						
					} else {
					
						//si es un bosque, buscar una posición libre
						//"I won't send this car to the forest." call SAC_fnc_debugNotify;
						
					};
				
				};	
				
			} else {
			
				if (leader _grp distance _objectivePos > 10) then {

					[_grp, ["MOVE"], _objectivePos, _waypointSpeed, _waypointBehaviour, 0, 0, 0, _waypointStatements, 0, [], 0, 0, false] call SAC_fnc_orderGroup;

				} else {

					[_grp, ["SAD"], getPos leader _grp getPos [15, random 360], "NORMAL", "AWARE", 0, 0, 0, _waypointStatements, 0, [], 0, 0, false] call SAC_fnc_orderGroup;

				};
				
			};
		
		};
		
	};
	
};

SAC_fnc_isForest = {
	
	params ["_p", "_radius", "_maxTrees"];
	
	private _nearTrees = count nearestTerrainObjects [_p, ["TREE","SMALL TREE"], _radius];
	
	//("isForest: " + str _nearTrees) call SAC_fnc_debugNotify;
	
	if (_nearTrees > _maxTrees) then {true} else {false}

};

SAC_fnc_unitListFiltered = {

	params ["_unitList", "_sides", "_flying", "_blacklistMarkers"];
	
	private _unitListFiltered = [];
	
	{
	
		if (_flying) then {
		
			if ((side _x in _sides) && {[_x, _blacklistMarkers] call SAC_fnc_isNotBlacklisted} && {[_x] call SAC_fnc_isFlying}) then {_unitListFiltered pushBack _x};
			
		} else {
		
			if ((side _x in _sides) && {[_x, _blacklistMarkers] call SAC_fnc_isNotBlacklisted} && {[_x] call SAC_fnc_isNotFlying}) then {_unitListFiltered pushBack _x};
		
		};
	
	}	forEach _unitList;
	
	_unitListFiltered
	
};

SAC_fnc_orderGroup = {

/*
	"_centerPos" tiene distintos significados, según la órden elegida:
		MOVE: es el punto al cual se debe mover el grupo.
		HOLD: es el punto al cual se deben mover y hacer el HOLD.
		GUARD: es el punto al cual se deben mover y en el cual deben esperar todos los pedidos de apoyo que les haga el engine, luego de un tiempo vuelven a este punto.
		SAD: es el punto central del waypoint SAD (search and destroy).
		PATROL: es el punto central del area de la patrulla, se complementa con _maxDistance.

	Si la órden es PATROL, el area de patrullaje puede estar definida por un centro y un radio, ó por un marcador (ó trigger), en cuyo caso se debe pasar el marcador (ó trigger)
	en "_centerPos", y establecer "_maxDistance" en cero.

	"_order" es un array de órdenes, de las cuales se elige una al azar. Para dar una órden específica, pasar un array de un sólo elemento :/

	"_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", y "_plot", sólo son usadas en la órden PATROL.
*/
	params ["_grp", "_order", "_centerPos", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_waypointStatements", "_maxDistance",
	"_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"];

	//defensive code
	if (isNull _grp) exitWith {};
	if (units _grp findIf {alive _x} == -1) exitWith {};
	
	
	private ["_wp"];

	switch (selectRandom (_order call SAC_fnc_shuffleArray)) do {

		case "MOVE": { //puede incluir una demora, hasta que queden libres para recibir nuevas ordenes

			_wp = _grp addWaypoint [_centerPos, 0];
			_wp setWaypointType "MOVE"; _wp setWaypointSpeed _waypointSpeed; _wp setWaypointBehaviour _waypointBehaviour;
			if (_waypointTimeoutMax > 0) then {_wp setWaypointTimeout [_waypointTimeoutMin, _waypointTimeoutMed, _waypointTimeoutMax]};
			if (_waypointStatements != "") then {_wp setWaypointStatements ["true", _waypointStatements]};

		};

		case "SAD": {

			_wp = _grp addWaypoint [_centerPos, 0];
			_wp setWaypointType "SAD"; _wp setWaypointSpeed _waypointSpeed; _wp setWaypointBehaviour _waypointBehaviour;
			if (_waypointStatements != "") then {_wp setWaypointStatements ["true", _waypointStatements]};

		};

		case "HOLD": {

			_wp = _grp addWaypoint [_centerPos, 0];
			_wp setWaypointType "HOLD"; _wp setWaypointSpeed _waypointSpeed; _wp setWaypointBehaviour _waypointBehaviour;

		};

		case "GUARD": {

			_wp = _grp addWaypoint [_centerPos, 0];
			_wp setWaypointType "GUARD"; _wp setWaypointSpeed _waypointSpeed; _wp setWaypointBehaviour _waypointBehaviour;

		};

		case "PATROL": {

			/*
				Lo que hago es calcular la cantidad de puntos especificados dentro del area indicada, de manera de que ningún punto esté,
				a menos de la distancia especificada de ningún otro punto. El primer punto es independiente de la posición actual del grupo,
				de manera que la primera órden es moverse al mismo, y desde ese se comienzan a recorrer los demás. Luego del último punto,
				se crea un 'waypoint' de tipo 'cycle' en la posición del primer punto, lo cual hace que se repita todo el recorrido. Recordar
				que 'cycle' no hace que las unidades se muevan hacia su posición, sino que les asigna el 'waypoint' más cercano a la posición
				de 'cycle', exceptuando el último anterior a él, es decir el último 'waypoint' al que acaban de llegar las unidades. El
				'waypoint' que se crea automáticamente cuando se crea un grupo, en la posición de éste, también cuenta en el cálculo de 'cycle',
				y por eso se debe colocar encima del primer punto de la patrulla (para evitar que 'cycle', en algunos casos, haga mover al
				grupo a la posición en la que fue creado).
			
			*/

			private ["_validPos", "_iteration", "_position"];

			private _route = [];

			for "_i" from 1 to _maxPoints do {

				_validPos = false;
				_iteration = 0;
				while {(!_validPos) && {_iteration < 30}} do {

					_iteration = _iteration + 1;

					if (_maxDistance > 0) then {

						_position = _centerPos getPos [round random _maxDistance, round random 360];

					} else {

						_position = [_centerPos] call SAC_fnc_randPosArea;

					};

					//20/12/2019 EXPERIMENTAL Estoy tratando de que la función use menos CPU porque produce 'stuttering'.
					//[_centerPos, _minDistance, _posSize, _maxTerrainGradient, _roadAllowed, _noplayerDistance, _maxDistance, _debug, _blacklist] call SAC_fnc_safePosition;
					//_position = [_position, 0, 5, 25, true, 999, 50, false, _blacklistsMarkers] call SAC_fnc_safePosition;

					if (count _position > 0) then {
					
						if  (([_position, _blacklistsMarkers] call SAC_fnc_isNotBlacklisted) && {!surfaceIsWater _position}) then {

							if (_route findIf {_x distance _position < _minDistanceBetweenPoints} == -1) then {

								_validPos = true;
								_route pushBack _position;

							};
							
						};
						
					};
					
				};

				if (!_validPos) exitWith {};

			};

			if (count _route > 1) then {

				for "_i" from 0 to count _route - 1 do {

					_wp = _grp addWaypoint [_route select _i, 0];
					_wp setWaypointType "MOVE"; _wp setWaypointSpeed "LIMITED"; _wp setWaypointBehaviour "SAFE";

				};

				_wp = _grp addWaypoint [_route select 0, 0];
				_wp setWaypointType "CYCLE"; _wp setWaypointSpeed "LIMITED"; _wp setWaypointBehaviour "SAFE";

				_grp setVariable ["SAC_ISPATROL", true];
				
				if (_plot) then {

					//plotea la ruta para debug
					private ["_lp"];
					_lp = _route select 0;
					{

						if (_x isNotEqualTo _lp) then {

							[_lp, _x, true] call SAC_fnc_drawLine;

							_lp = _x;

						};

					} forEach _route;

				};

			};

		};

	};

};

SAC_fnc_createGroup = {

	/*


		Crea un grupo en una posición vacía al azar, según los parámetros especificados.

		El area en donde crear el grupo puede estar definido por un centro y un radio, o por un marcador (o trigger), en cuyo caso se debe pasar el marcador (o trigger) en
		"_centerPos", y establecer "_maxDistance" en cero.
		En ambos casos se puede especificar una distancia mínima desde el centro usando "_minDistance".

	*/

	params ["_centerPos", "_minDistance", "_maxDistance", "_playerExclusionDistance", "_blacklistsMarkers", "_unitClasses", "_grpSize", "_skill", "_autoDeleteGroup"];

	private ["_validPos", "_iteration", "_position", "_grp", "_validDistanceGap", "_center"];

	private _side = [_unitClasses select 0] call SAC_fnc_getSideFromCfg;

	_grp = grpNull;

	_validDistanceGap = _maxDistance - _minDistance;

	_validPos = false;
	_iteration = 0;
	while {(!_validPos) && {_iteration < 50}} do {

		_iteration = _iteration + 1;

		if (_maxDistance > 0) then {

			_position = _centerPos getPos [_minDistance + random _validDistanceGap, round random 360];

			_center = _centerPos;

		} else {

			_position = [_centerPos] call SAC_fnc_randPosArea;

			_center = getMarkerPos _centerPos;

		};

		if (_position distance _center >= _minDistance) then {

			//17/11/2019 EXPERIMENTAL Si voy a crear soldados, con BIS_fnc_spawnGroup, creo que no es necesario buscar una posición libre de objetos y plana.
			//[_centerPos, _minDistance, _posSize, _maxTerrainGradient, _roadAllowed, _noplayerDistance, _maxDistance, _debug, _blacklist] call SAC_fnc_safePosition;
			//_position = [_position, 0, 5, 25, true, _playerExclusionDistance, 50, false, _blacklistsMarkers] call SAC_fnc_safePosition;

			if (count _position > 0) then {
			
				if  (([_position, _blacklistsMarkers] call SAC_fnc_isNotBlacklisted) && {!surfaceIsWater _position}) then {
			
					if ((_playerExclusionDistance == 999) || {[_position, _side, _playerExclusionDistance] call SAC_fnc_notNearEnemies}) then {

						_validPos = true;

					};

				};
				
			};

		};

	};

	//if (count _position > 0) then { //dejo esta línea que corregí porque no se si era un error o era intencional...
	if (_validPos) then {

		_grp = [_position, _side, _unitClasses call SAC_fnc_shuffleArray, [], [], _skill, [], [_grpSize call SAC_fnc_numberBetween, 0]] call SAC_fnc_spawnGroup;

		{[_x] call SAC_GEAR_applyLoadoutByClass} forEach units _grp;
		[_grp] call SAC_fnc_setSkills;
		_grp allowFleeing 0; //27/03/2018
		
		_grp deleteGroupWhenEmpty _autoDeleteGroup;

	} else {

		"SAC_fnc_createGroup: Unable to find suitable position for creating units." call SAC_fnc_debugNotify;

	};

	_grp

};

SAC_fnc_spawnGroup = {

	/*
	
		Esta función es exactamente igual a la de BIS, pero hace una pausa de 0.3 segundos entre cada unidad que se crea.
		La diferencia entre crear unidades sin hacer pausas y hacer pausas es importantísima según todas las pruebas. En
		la mayoría de los casos crear un grupo de 8 unidades, sin hacer pausas, genera una baja de 10 FPS, mientras que
		haciendo una pausa la baja es de 2.
	
	*/

	/*
		File: spawnGroup.sqf
		Author: Joris-Jan van 't Land, modified by Thomas Ryan

		Description:
		Function which handles the spawning of a dynamic group of characters.
		The composition of the group can be passed to the function.
		Alternatively a number can be passed and the function will spawn that
		amount of characters with a random type.

		Parameter(s):
		_this select 0: the group's starting position (Array)
		_this select 1: the group's side (Side)
		_this select 2: can be three different types:
			- list of character types (Array)
			- amount of characters (Number)
			- CfgGroups entry (Config)
		_this select 3: (optional) list of relative positions (Array)
		_this select 4: (optional) list of ranks (Array)
		_this select 5: (optional) skill range (Array)
		_this select 6: (optional) ammunition count range (Array)
		_this select 7: (optional) randomization controls (Array)
			0: amount of mandatory units (Number)
			1: spawn chance for the remaining units (Number)
		_this select 8: (optional) azimuth (Number)
		_this select 9: (optional) force precise position (Bool, default: true).
		_this select 10: (optional) max. number of vehicles (Number, default: 10e10).

		Returns:
		The group (Group)
	*/

	//Validate parameter count
	if ((count _this) < 3) exitWith {debugLog "Log: [spawnGroup] Function requires at leat 3 parameters!"; grpNull};

	private ["_pos", "_side"];
	_pos = _this param [0, [], [[]]];
	_side = _this param [1, sideUnknown, [sideUnknown]];

	private ["_chars", "_charsType", "_types"];
	_chars = _this param [2, [], [[], 0, configFile]];
	_charsType = typeName _chars;
	if (_charsType == (typeName [])) then
	{
		_types = _chars;
	}
	else
	{
		if (_charsType == (typeName 0)) then
		{
			//Only a count was given, so ask this function for a good composition.
			_types = [_side, _chars] call BIS_fnc_returnGroupComposition;
		}
		else
		{
			if (_charsType == (typeName configFile)) then
			{
				_types = [];
			};
		};
	};

	private ["_positions", "_ranks", "_skillRange", "_ammoRange", "_randomControls","_precisePosition","_maxVehicles"];
	_positions = _this param [3, [], [[]]];
	_ranks = _this param [4, [], [[]]];
	_skillRange = _this param [5, [], [[]]];
	_ammoRange = _this param [6, [], [[]]];
	_randomControls = _this param [7, [-1, 1], [[]]];
	_precisePosition = _this param [9,true,[true]];
	_maxVehicles = _this param [10,10e10,[123]];

	//Fetch the random controls.
	private ["_minUnits", "_chance"];
	_minUnits = _randomControls param [0, -1, [0]];
	_chance = _randomControls param [1, 1, [0]];

	private ["_azimuth"];
	_azimuth = _this param [8, 0, [0]];

	//Check parameter validity.
	//TODO: Check for valid skill and ammo ranges?
	if ((typeName _pos) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] Position (0) should be an Array!"; grpNull};
	if ((count _pos) < 2) exitWith {debugLog "Log: [spawnGroup] Position (0) should contain at least 2 elements!"; grpNull};
	if ((typeName _side) != (typeName sideEnemy)) exitWith {debugLog "Log: [spawnGroup] Side (1) should be of type Side!"; grpNull};
	if ((typeName _positions) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] List of relative positions (3) should be an Array!"; grpNull};
	if ((typeName _ranks) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] List of ranks (4) should be an Array!"; grpNull};
	if ((typeName _skillRange) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] Skill range (5) should be an Array!"; grpNull};
	if ((typeName _ammoRange) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] Ammo range (6) should be an Array!"; grpNull};
	if ((typeName _randomControls) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] Random controls (7) should be an Array!"; grpNull};
	if ((typeName _minUnits) != (typeName 0)) exitWith {debugLog "Log: [spawnGroup] Mandatory units (7 select 0) should be a Number!"; grpNull};
	if ((typeName _chance) != (typeName 0)) exitWith {debugLog "Log: [spawnGroup] Spawn chance (7 select 1) should be a Number!"; grpNull};
	if ((typeName _azimuth) != (typeName 0)) exitWith {debugLog "Log: [spawnGroup] Azimuth (8) should be a Number!"; grpNull};
	if ((_minUnits != -1) && (_minUnits < 1)) exitWith {debugLog "Log: [spawnGroup] Mandatory units (7 select 0) should be at least 1!"; grpNull};
	if ((_chance < 0) || (_chance > 1)) exitWith {debugLog "Log: [spawnGroup] Spawn chance (7 select 1) should be between 0 and 1!"; grpNull};
	if (((count _positions) > 0) && ((count _types) != (count _positions))) exitWith {debugLog "Log: [spawnGroup] List of positions (3) should contain an equal amount of elements to the list of types (2)!"; grpNull};
	if (((count _ranks) > 0) && ((count _types) != (count _ranks))) exitWith {debugLog "Log: [spawnGroup] List of ranks (4) should contain an equal amount of elements to the list of types (2)!"; grpNull};

	//Convert a CfgGroups entry to types, positions and ranks.
	if (_charsType == (typeName configFile)) then
	{
		_ranks = [];
		_positions = [];

		for "_i" from 0 to ((count _chars) - 1) do
		{
			private ["_item"];
			_item = _chars select _i;

			if (isClass _item) then
			{
				_types = _types + [getText(_item >> "vehicle")];
				_ranks = _ranks + [getText(_item >> "rank")];
				_positions = _positions + [getArray(_item >> "position")];
			};
		};
	};

	private ["_grp","_vehicles","_isMan","_type"];
	_grp = createGroup _side;
	_vehicles = 0;		//spawned vehicles count

	//Extender el array de clases si es menor a la cantidad de unidades requeridas.
	if (count _types < _minUnits) then {
	
		for "_i" from 1 to (_minUnits - count _types) do {
		
			_types pushBack selectRandom _types;
		
		};
	
	};


	//Create the units according to the selected types.
	for "_i" from 0 to ((count _types) - 1) do
	{
		//Check if max. of vehicles was already spawned
		_type = _types select _i;
		_isMan = getNumber(configFile >> "CfgVehicles" >> _type >> "isMan") == 1;

		if !(_isMan) then
		{
			_vehicles = _vehicles + 1;
		};

		if (_vehicles > _maxVehicles) exitWith {};

		//See if this unit should be skipped.
		private ["_skip"];
		_skip = false;
		if (_minUnits != -1) then
		{
			//Has the mandatory minimum been reached?
			if (_i > (_minUnits - 1)) then
			{
				//Has the spawn chance been satisfied?
				if ((random 1) > _chance) then {_skip = true};
			};
		};

		if (!_skip) then
		{
			private ["_unit"];

			//If given, use relative position.
			private ["_itemPos"];
			if ((count _positions) > 0) then
			{
				private ["_relPos"];
				_relPos = _positions select _i;
				_itemPos = [(_pos select 0) + (_relPos select 0), (_pos select 1) + (_relPos select 1)];
			}
			else
			{
				_itemPos = _pos;
			};

			//Is this a character or vehicle?
			if (_isMan) then
			{
				_unit = _grp createUnit [_type, _itemPos, [], 0, "FORM"];
				_unit setDir _azimuth;
			}
			else
			{
				_unit = ([_itemPos, _azimuth, _type, _grp, _precisePosition] call BIS_fnc_spawnVehicle) select 0;
			};

			//If given, set the unit's rank.
			if ((count _ranks) > 0) then
			{
				[_unit,_ranks select _i] call bis_fnc_setRank;
			};

			//If a range was given, set a random skill.
			if ((count _skillRange) > 0) then
			{
				private ["_minSkill", "_maxSkill", "_diff"];
				_minSkill = _skillRange select 0;
				_maxSkill = _skillRange select 1;
				_diff = _maxSkill - _minSkill;

				_unit setUnitAbility (_minSkill + (random _diff));
			};

			//If a range was given, set a random ammo count.
			if ((count _ammoRange) > 0) then
			{
				private ["_minAmmo", "_maxAmmo", "_diff"];
				_minAmmo = _ammoRange select 0;
				_maxAmmo = _ammoRange select 1;
				_diff = _maxAmmo - _minAmmo;

				_unit setVehicleAmmo (_minAmmo + (random _diff));
			};
		};
		
		sleep 0.3;
		
	};

/*
	//--- Sort group members by ranks (the same as 2D editor does it)
	private ["_newGrp"];
	_newGrp = createGroup _side;
	while {count units _grp > 0} do {
		private ["_maxRank","_unit"];
		_maxRank = -1;
		_unit = objnull;
		{
			_rank = rankid _x;
			if (_rank > _maxRank || (_rank == _maxRank && (group effectivecommander vehicle _unit == _newGrp) && effectivecommander vehicle _x == _x)) then {_maxRank = _rank; _unit = _x;};
		} foreach units _grp;
		[_unit] joinsilent _newGrp;
	};
	_newGrp selectleader (units _newGrp select 0);
	deletegroup _grp;

	_newGrp
*/	
	_grp
	
};

SAC_fnc_sendGroup = {

/*

	Crea un grupo de infantería y lo envía al punto de destino. Luego de llegar, el grupo espera el tiempo especificado, y luego realiza la tarea requerida.

*/

	params ["_destination", "_spawnDistance", "_playerExclusionDistance", "_blacklistsMarkers", "_unitClasses", "_grpSize", "_skill", "_waypointType", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_waypointStatements", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"];

	private ["_grp"];

	//["_centerPos", "_minDistance", "_maxDistance", "_playerExclusionDistance", "_blacklistsMarkers", "_unitClasses", "_grpSize", "_skill", "_autoDeleteGroup"];
	_grp = [_destination, _spawnDistance select 0, _spawnDistance select 1, _playerExclusionDistance, _blacklistsMarkers, _unitClasses, _grpSize, _skill, true] call SAC_fnc_createGroup;

	if (isNull _grp) exitWith {"No se pudo crear grupo en sendGroup." call SAC_fnc_debugNotify, _grp};

	//["_grp", "_order", "_centerPos", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"]
	[_grp, ["MOVE"], _destination, _waypointSpeed, _waypointBehaviour, _waypointTimeoutMin, _waypointTimeoutMed, _waypointTimeoutMax, "", _maxDistance, _blacklistsMarkers, _maxPoints, _minDistanceBetweenPoints, _plot] call SAC_fnc_orderGroup;
	//["_grp", "_order", "_centerPos", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"]
	[_grp, _waypointType, _destination, _waypointSpeed, _waypointBehaviour, _waypointTimeoutMin, _waypointTimeoutMed, _waypointTimeoutMax, _waypointStatements, _maxDistance, _blacklistsMarkers, _maxPoints, _minDistanceBetweenPoints, _plot] call SAC_fnc_orderGroup;

	_grp

};

SAC_fnc_sendHunterInfantry = {

/*

	Crea un grupo de infantería que perseguirá a las unidades enemigas más cercanas, o al jugador más cercano, según parámetro.
	
	_centerPos				//es la posición supuesta del objetivo, sólo se usa para crear el grupo alrededor de esa posición
	_spawnDistance			//en la forma [_min, _max]
	_grpSize					//en la forma [_min, _max]
	_skill					//en la forma [_min, _max]
	_targetType				//"ENEMIES" o "PLAYERS"

*/

	params ["_centerPos", "_spawnDistance", "_playerExclusionDistance", "_unitClasses", "_grpSize", "_skill", "_targetType", "_blacklistsMarkers"];

	private _grp = [_centerPos, _spawnDistance select 0, _spawnDistance select 1, _playerExclusionDistance, _blacklistsMarkers, _unitClasses, _grpSize, _skill, true] call SAC_fnc_createGroup;

	if (isNull _grp) exitWith {"sendHunterInfantry: Can't create group." call SAC_fnc_debugNotify, _grp};

	sleep 0.2;//es para no darles el waypoint tan rápido después de crearlos
	
	[_grp, _targetType, "NORMAL", "AWARE", false, _blacklistsMarkers] call SAC_fnc_followNearestX;
	
	_grp

};

SAC_fnc_proximityAutoArrest = {

	params ["_thisUnits"];

	private ["_g", "_i"];

	while {_thisUnits findIf {alive _x} != -1} do {

		_i = [];

		{

			if ((isNull objectParent _x) && {SAC_PLAYER_SIDE countSide (_x nearEntities 1.5) > 0}) then {

				_g = createGroup civilian;
				[_x] joinSilent _g;
				_x setUnitPos "DOWN";
				_x stop true;
				_i pushBack _x;

			};

		} forEach _thisUnits;

		_thisUnits = _thisUnits - _i;

		sleep 1;

	};

};

SAC_fnc_groupsOfPlayers = {
/*

	Encontrar todos los jugadores que estén a más de "_spacing" mts. de cualquier otro jugador.
	Es decir, encontrar grupos de jugadores separadas entre sí por más
	de "_spacing" mts. Fuera de una green zone, y en tierra, no volando.

*/

	params ["_spacing", "_greenZoneMarkers", "_allowFlying", "_allowWater"];

	private ["_centers", "_unit"];

	_centers = [];

	{

		_unit = _x;

		if (_centers findIf {_unit distance _x < _spacing} == -1) then {
		
			if ([getPos _unit, _greenZoneMarkers] call SAC_fnc_isNotBlacklisted) then {

				if ((_allowFlying) || {[_unit] call SAC_fnc_isNotFlying}) then {
				
					if ((_allowWater) || {!surfaceIsWater getPos _unit}) then {

						_centers pushBack (getPos vehicle _unit);
						
					};

				};

			};

		};

	} forEach allPlayers;

	_centers

};

SAC_fnc_trafficRetasker = {

/*
	//Retasker. Si un vehículo llegó a destino, asignarle otro para mantenerlo en movimiento y que no obstaculice los caminos. Primero intenta encontrar una locación
	//en la misma dirección en la que circulaba el vehículo, pero si no la encuentra, expande la búsqueda a cualquier dirección.

*/

	params ["_vehicles", "_blacklistMarkers", "_combatMode", "_behaviour", "_minDistance", "_maxDistance"];

	private ["_vehicle", "_location", "_destRoad"];

	{

		_vehicle = _x;


		if ((!isNull driver _vehicle) && {canMove _vehicle}) then {

			if (_vehicle getVariable "SAC_CAR_DESTINATION" distance getPos _vehicle < 100) then {

				//[getPos _vehicle, "ColorBlue", ""] call SAC_fnc_createMarker;

				//[_centralPos, _minDistance, _maxDistance, _playerExclusionDistance, _blacklist, _method, _inAngleSector] call SAC_fnc_findLocation;
				_location = [getPos _vehicle, _minDistance, _maxDistance, 999, _blacklistMarkers, "random", getDir _vehicle] call SAC_fnc_findLocation;
				if (isNull _location) then {_location = [getPos _vehicle, _minDistance, _maxDistance, 999, _blacklistMarkers, "random"] call SAC_fnc_findLocation;};

				if (!isNull _location) then {

					//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, [_method]] call SAC_fnc_findRoad;
					_destRoad = [_location call SAC_fnc_locationPosition, 0, 200, 999, [], 999, "random"] call SAC_fnc_findRoad;

					if (!isNull _destRoad) then {

						_vehicle move getPos _destRoad;
						_vehicle setSpeedMode "NORMAL";
						_vehicle setCombatMode _combatMode;
						_vehicle setBehaviour _behaviour;

						_vehicle setVariable ["SAC_CAR_DESTINATION", getPos _destRoad];

					};
				};

			};
		};

	} forEach _vehicles;

};
/*
SAC_fnc_trafficGetRoute = {



	//Calcula un punto de inicio y de final para un tráfico, que tentativamente, tenga la posición central como medio.



	//diag_log _this;

	params ["_centralPos", "_startMinDistance", "_startMaxDistance", "_destMinDistance", "_destMaxDistance", "_blacklistMarkers"];

	private ["_location", "_startRoad", "_dir", "_destRoad", "_result"];

	_result = false;
	_startRoad = objNull;
	_destRoad = objNull;

	//[_centralPos, _minDistance, _maxDistance, _playerExclusionDistance, _blacklist, _method] call SAC_fnc_findLocation;
	_location = [_centralPos, _startMinDistance, _startMaxDistance, 400, _blacklistMarkers, "random"] call SAC_fnc_findLocation;

	if (!isNull _location) then {

		//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, _method] call SAC_fnc_findRoad;
		_startRoad = [_location call SAC_fnc_locationPosition, 0, 200, 999, [], 999, "random"] call SAC_fnc_findRoad;

		if (!isNull _startRoad) then {

			_dir =  (getPos _startRoad) getDir _centralPos;

			//[_centralPos, _minDistance, _maxDistance, _playerExclusionDistance, _blacklist, _method, _inAngleSector] call SAC_fnc_findLocation;
			_location = [_centralPos, _destMinDistance, _destMaxDistance, 400, _blacklistMarkers, "random", _dir] call SAC_fnc_findLocation;

			if (!isNull _location) then {

				//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, _method] call SAC_fnc_findRoad;
				_destRoad = [_location call SAC_fnc_locationPosition, 0, 200, 999, [], 999, "random"] call SAC_fnc_findRoad;

				if (!isNull _destRoad) then {

					_result = true;

				};

			};

		};

	};

	[_result, _startRoad, _destRoad]

};
*/

//11/7/2017 Esta versión trabaja igual que la original en todo, excepto que esta busca caminos ("segment roads"), en vez de pueblos ("locations").
//Se cambió la original porque en mapas como Beketov no hay pueblos en el radio de búsqueda que se usa (también se podría aumentar el mismo en una
//vuelta si la primera falla, pero el rango es adecuado). Otra cosa potencialmente negativa que tiene la original es que al crearse dentro de pueblos,
//los vehículos pueden tener más problemas para atravesarlos.
SAC_fnc_trafficGetRoute = {

/*

	Calcula un punto de inicio y de final para un tráfico que, tentativamente, tenga la posición central como medio.

*/

	//diag_log _this;

	params ["_centralPos", "_startMinDistance", "_startMaxDistance", "_destMinDistance", "_destMaxDistance", "_blacklistMarkers"];

	private ["_location", "_startRoad", "_dir", "_destRoad", "_result"];

	_result = false;
	_startRoad = objNull;
	_destRoad = objNull;

	//[_centralPos, _minDistance, _maxDistance, _playerExclusionDistance, _blacklist, _method] call SAC_fnc_findLocation;
	//_location = [_centralPos, _startMinDistance, _startMaxDistance, 400, _blacklistMarkers, "random"] call SAC_fnc_findLocation;
	//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, _method] call SAC_fnc_findRoad;
	_startRoad = [_centralPos, _startMinDistance, _startMaxDistance, 999, _blacklistMarkers, _startMinDistance, "random"] call SAC_fnc_findRoad;
	
/*	
	if (!isNull _location) then {

		//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, _method] call SAC_fnc_findRoad;
		_startRoad = [_location call SAC_fnc_locationPosition, 0, 200, 999, [], 999, "random"] call SAC_fnc_findRoad;
*/
		if (!isNull _startRoad) then {

			_dir =  (getPos _startRoad) getDir _centralPos;

			//[_centralPos, _minDistance, _maxDistance, _playerExclusionDistance, _blacklist, _method, _inAngleSector] call SAC_fnc_findLocation;
			//_location = [_centralPos, _destMinDistance, _destMaxDistance, 400, _blacklistMarkers, "random", _dir] call SAC_fnc_findLocation;
			//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, _method] call SAC_fnc_findRoad;
			_destRoad = [_centralPos, _destMinDistance, _destMaxDistance, _dir, _blacklistMarkers, _startMinDistance, "random"] call SAC_fnc_findRoad;
/*				
			if (!isNull _location) then {

				//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, _method] call SAC_fnc_findRoad;
				_destRoad = [_location call SAC_fnc_locationPosition, 0, 200, 999, [], 999, "random"] call SAC_fnc_findRoad;
*/
				if (!isNull _destRoad) then {

					_result = true;

				};
/*
			};
*/
		};
/*
	};
*/
	[_result, _startRoad, _destRoad]

};

SAC_fnc_addCargoUnits = {

	params ["_vehicle", "_unitClasses", "_crewGroup", "_skill", "_unitCount"];

	private ["_grpSize", "_emptyPersonTurrets", "_tempUnitClasses", "_crewMember", "_crewClass"];

	_grpSize = _unitCount call SAC_fnc_numberBetween;

	_emptyPersonTurrets = [_vehicle] call SAC_fnc_emptyPersonTurrets;

	_grpSize = _grpSize min (([_vehicle] call SAC_fnc_emptyCargoSeats) + count _emptyPersonTurrets);

	_tempUnitClasses = +_unitClasses;

	_createdUnits = 0;

	{

		if (_createdUnits == _grpSize) exitWith {};

		_crewClass = selectRandom _tempUnitClasses;
		_tempUnitClasses = _tempUnitClasses - [_crewClass];

		_crewMember = _crewGroup createUnit [_crewClass, getPos _vehicle, [], 0, "NONE"];
		[_crewMember] call SAC_GEAR_applyLoadoutByClass;

		_createdUnits = _createdUnits + 1;

		_crewMember moveInTurret [_vehicle, _x];

		if (count _tempUnitClasses == 0) then {_tempUnitClasses = +_unitClasses};

	} forEach _emptyPersonTurrets;

	for "_i" from 1 to (_grpSize - _createdUnits) do {

		_crewClass = selectRandom _tempUnitClasses;
		_tempUnitClasses = _tempUnitClasses - [_crewClass];

		_crewMember = _crewGroup createUnit [_crewClass, getPos _vehicle, [], 0, "NONE"];
		[_crewMember] call SAC_GEAR_applyLoadoutByClass;

		_createdUnits = _createdUnits + 1;

		_crewMember moveInCargo _vehicle;

		if (count _tempUnitClasses == 0) then {_tempUnitClasses = +_unitClasses};

	};
	
	[_crewGroup] call SAC_fnc_setSkills;

};

SAC_fnc_sendCar = {

	params ["_start", "_destination", "_vehicleClasses", "_unitClasses", "_unitCount", "_skill", "_speed", "_combatMode", "_behaviour", "_setCaptive"];

	private ["_cargoGrp", "_vehicle", "_grpSize", "_returnedArray"];

	_grp = grpNull;
	_vehicle = objNull;

	//["_position", "_direction", "_vehicleClasses", "_crewClasses", "_special", "_autoDeleteGroup"]
	_returnedArray = [_start, _start getDir _destination, _vehicleClasses, _unitClasses, "NONE", true] call SAC_fnc_spawnVehicle;
	_vehicle = _returnedArray select 0;
	_grp = _returnedArray select 1;

	[_vehicle, _unitClasses, _grp, _skill, _unitCount] call SAC_fnc_addCargoUnits;

	if (count _speed != 0) then {

		_vehicle forceSpeed ((((_speed call SAC_fnc_numberBetween) * 1000) / 60) / 60);

	};

	if (_setCaptive) then {

		_vehicle setCaptive true;

		{

			_vehicle addEventHandler ["FiredNear", {vehicle (_this select 0) setCaptive false}];

		} forEach units _grp;

	};

	_vehicle move _destination;
	_vehicle setSpeedMode "NORMAL";
	_vehicle setCombatMode _combatMode;
	_vehicle setBehaviour _behaviour;

	[_vehicle, _grp]

};

SAC_fnc_isLandArea = {

	//devuelve true si el área definida por un centro y un radio, está mayormente sobre tierra

	params ["_centerPos", "_radius", "_blacklistMarkers", "_whitelistMarkers"];

	private ["_dirToCheck", "_landPoints", "_testPoint"];

	if (_whitelistMarkers isEqualTo []) then {"ERROR en SAC_fnc_isLandArea: _whitelistMarkers no puede estar vacío" call SAC_fnc_MPhintC};

	scopeName "mainIsLandArea";

	_dirToCheck = 0;
	for "_i" from 1 to 2 do {

		_landPoints = 0;
		for "_k" from 1 to 4 do {

			_testPoint = _centerPos getPos [_radius, _dirToCheck];

			//[_testPoint, "ColorBlue", ""] call SAC_fnc_createMarker;

			if ((!surfaceIsWater _testPoint) && {[_testPoint, _blacklistMarkers] call SAC_fnc_isNotBlacklisted} && {[_testPoint, _whitelistMarkers] call SAC_fnc_isBlacklisted}) then {_landPoints = _landPoints + 1};

			_dirToCheck = _dirToCheck + 90;
		};

		if (_landPoints == 4) then {breakTo "mainIsLandArea"};

		_dirToCheck = 45;

	};

	if (_landPoints != 4) exitWith {false};

	true

};

SAC_fnc_addPredefinedAction = {

	//agrega una acción al objeto, que cuando se la utiliza puede realizar una serie de acciones predefinidas
	//1 - marca una posición en el mapa
	//2 - solamente muestra el _titleText
	//3 - desactiva un dispositivo explosivo (el monitoreo sigue estando a cargo de la rutina que llama)
	//4 - borra el objeto registrado en la variable "SAC_targetObject" (usado para apagar el B_IRStrobe del bote de THU, por ejemplo)
	//5 - genera una misión CSAR dentro del esquema de COP
	//6 - mueve al player a asiento del driver

	params ["_object", ["_actionTitle", "Action Title", [""]], ["_titleText", "Title Text", [""]], ["_actionType", 0, [0]],
	["_position", [0,0,0], [[]]], ["_timer", 0, [0]], ["_markerText", " Target", [""]], ["_condition", "true", [""]]];

	private ["_scriptCode", "_arguments", "_priority", "_showWindow", "_hideOnUse"];
	//_actionTitle = "<t color='#FF0000'>*** SEARCH ***</t>";
	_arguments = "";
	_priority = 2000;
	_showWindow = false;
	_hideOnUse = true;
	//_condition = "(isNull objectParent _this) && " + _condition;
	_condition = "true && " + _condition;

	_object setVariable ["SAC_titleText", _titleText, true];

	switch (_actionType) do {
		case 1: {
			//_object setVariable ["SAC_position", _position, true];
			_arguments = [_titleText, _position, _markerText];
			_scriptCode = {

				//[(_this select 0) getVariable "SAC_titleText", {titleText [_this, "PLAIN"]}] remoteExecCall ["call", 0];
				[(_this select 3) select 0, {titleText [_this, "PLAIN"]}] remoteExecCall ["call", 0, false];
				
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

				//[(_this select 3) select 1, "ColorRed", " Target", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;
				[(_this select 3) select 1, "ColorRed", (_this select 3) select 2, "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;

			};
		};
		case 2: {
			_scriptCode = {

				[(_this select 0) getVariable "SAC_titleText", {titleText [_this, "PLAIN"]}] remoteExecCall ["call", 0, false];

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

			};
		};
		case 3: {

			_object setVariable ["SAC_armed", true, true];
			_object setVariable ["SAC_timer", _timer, true];

			_scriptCode = {

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

				player playActionNow "Medic";

				sleep 5; //probablemente de error porque creo que se ejecuta unscheduled

				(_this select 0) setVariable ["SAC_armed", false, true];

			};
		};
		case 4: {
			_scriptCode = {
			
				//[(_this select 0) getVariable "SAC_targetObject", {deleteVehicle  (nearestObject [getPos _this,"NVG_TargetC"])}] remoteExecCall ["call", 0, true]; // delete strobe effect
				[(_this select 0) getVariable "SAC_targetObject", {deleteVehicle _this}] remoteExecCall ["call", 0, false];

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

			};
		};
		case 5: {
			_scriptCode = {

				COP_CAN_GENERATE_CSAR = false; publicVariable "COP_CAN_GENERATE_CSAR";
				
				//[""]  call SAC_COP_fnc_dyn_CSAR;
				[""] remoteExec ["SAC_COP_fnc_dyn_CSAR", 2, false];

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

			};
		};
		case 6: {
			_scriptCode = {
			
				params ["_target", "_caller", "_actionId", "_arguments"];
				//target (_this select 0): Object - the object which the action is assigned to
				//caller (_this select 1): Object - the unit that activated the action
				//ID (_this select 2): Number - ID of the activated action (same as ID returned by addAction)
				//arguments (_this select 3): Anything - arguments given to the script if you are using the extended syntax

				[_target] spawn SAC_fnc_actionHelperMoveInDriver;

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

			};
		};
		default {};
	};

	//_x addAction [_actionTitle, _scriptCode, _arguments, _priority, _showWindow, _hideOnUse, "", _condition];
	//[[_object, [_actionTitle, _scriptCode, _arguments, _priority, _showWindow, _hideOnUse, "", _condition]], "addAction", true, true] call BIS_fnc_MP;
	[_object, [_actionTitle, _scriptCode, _arguments, _priority, _showWindow, _hideOnUse, "", _condition]] remoteExec ["addAction", [0,-2] select isDedicated, true];

};

SAC_fnc_actionHelperMoveInDriver = {

	params ["_vehicle"];
	
	systemChat str typeOf _vehicle;
	
	private _timeOut = time + 5;
	waitUntil {(!alive driver _vehicle) || (time > _timeOut)}; //esto es porque en MP puede haber un delay hasta que cada cliente reconoce como muerto al driver
	
	if (!alive driver _vehicle) then {
	
		//unassignVehicle player; player action ["Eject", vehicle player];
		if (!isNull objectParent player) then {
		
			moveOut player;
			waitUntil {isNull objectParent player};
			
			//aparentemente en MP hay que esperar un poco antes de ejecutar el moveInDriver
			
			if (isMultiplayer) then {sleep 0.5};
		
		};
		
		//como estoy sacando al player de un helicoptero en vuelo, uso esta funcion porque si no lo puede
		//volver a meter como 'driver', al menos voy a intentar meterlo de nuevo al vehiculo.
		private _done = [player, _vehicle, ["Driver", "Cargo", "personTurret", "commonTurret", "Commander", "Gunner"]] call SAC_fnc_moveUnitToVehicle;
		
	} else {
	
		hint (parseText "<t color='#00FFFF' size='1.2'><br/>El conductor esta vivo.<br/><br/></t>");
	
	};

};

SAC_fnc_addPredefinedActionNew = {

	//agrega una acción al objeto, que cuando se la utiliza puede realizar una serie de acciones predefinidas
	//1 - marca una posición en el mapa
	//2 - solamente muestra el _titleText
	//3 - desactiva un dispositivo explosivo (el monitoreo sigue estando a cargo de la rutina que llama)
	//4 - borra el objeto registrado en la variable "SAC_targetObject" (usado para apagar el B_IRStrobe del bote de THU, por ejemplo)
	//5 - genera una misión CSAR dentro del esquema de COP
	//6 - cambia 'SAC_systemActivated' a 'true' y propaga la variable a los clientes y el server
	//7 - libera a un rehen apresado con 'SAC_fnc_convertToHostage'
	//8 - revela la posición de todos los elementos de la lista SAC_hiddenTargetObjects

	params ["_object", "_actionTitle", "_titleText", "_actionType", "_position", "_timer", "_icon"];

	private ["_scriptCode", "_arguments", "_priority", "_showWindow", "_hideOnUse", "_condition"];
	//_actionTitle = "<t color='#FF0000'>*** SEARCH ***</t>";
	_arguments = "";
	_priority = 2000;
	_showWindow = false;
	_hideOnUse = true;
	_condition = "isNull objectParent _this";

	_object setVariable ["SAC_titleText", _titleText, true];

	switch (_actionType) do {
		case 1: {
			_object setVariable ["SAC_position", _position, true];
			_scriptCode = {

				[(_this select 0) getVariable "SAC_titleText", {titleText [_this, "PLAIN"]}] remoteExecCall ["call", 0, false];

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

				[(_this select 0) getVariable "SAC_position", "ColorRed", " Target", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;

			};
		};
		case 2: {
			_scriptCode = {

				[(_this select 0) getVariable "SAC_titleText", {titleText [_this, "PLAIN"]}] remoteExecCall ["call", 0, false];

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

			};
		};
		case 3: {

			_object setVariable ["SAC_armed", true, true];
			_object setVariable ["SAC_timer", _timer, true];

			_scriptCode = {

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

				player playActionNow "Medic";

				sleep 5; //probablemente de error porque creo que se ejecuta 'unscheduled'

				(_this select 0) setVariable ["SAC_armed", false, true];

			};
		};
		case 4: {
			_scriptCode = {
			
				[(_this select 0) getVariable "SAC_targetObject", {deleteVehicle  (nearestObject [getPos _this,"nvg_targetC"])}] remoteExecCall ["call", 0, false]; // delete strobe effect
				[(_this select 0) getVariable "SAC_targetObject", {deleteVehicle _this}] remoteExecCall ["call", 0, false];

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

			};
		};
		case 5: {
			_scriptCode = {

				//[""]  call SAC_COP_fnc_dyn_CSAR;
				[""] remoteExec ["SAC_COP_fnc_dyn_CSAR", 2, false];

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

			};
		};
		case 6: {
			_scriptCode = {

				[(_this select 0) getVariable "SAC_titleText", {titleText [_this, "PLAIN"]}] remoteExecCall ["call", 0, false];
				
				SAC_systemActivated = true; publicVariable "SAC_systemActivated";

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

			};
		};
		case 7: {
			_scriptCode = {
			
				params ["_target", "_caller", "_actionId", "_arguments"];

				//[""]  call SAC_COP_fnc_dyn_CSAR;
				[_target] remoteExec ["SAC_fnc_releaseHostage", _target, false]; //ejecuta la acción en donde el objeto es local

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;

			};
		};
		case 8: {
			_scriptCode = {
			
				params ["_target", "_caller", "_actionId", "_arguments"];
				//target (_this select 0): Object - the object which the action is assigned to
				//caller (_this select 1): Object - the unit that activated the action
				//ID (_this select 2): Number - ID of the activated action (same as ID returned by addAction)
				//arguments (_this select 3): Anything - arguments given to the script if you are using the extended syntax

				//(_this select 0) removeAction (_this select 2);
				[[(_this select 0), (_this select 2)], "removeAction", true, true] call BIS_fnc_MP;
				
				{
				
					//[_pos, _color, _text, [_type], [_size], [_shape, _brush]] call SAC_fnc_createMarker;
					[getPos _x, "ColorRed", "Target", "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;
					
				} forEach SAC_hiddenTargetObjects;

			};
		};
		
		default {};
	};
	

	//_x addAction [_actionTitle, _scriptCode, _arguments, _priority, _showWindow, _hideOnUse, "", _condition];
	//[[_object, [_actionTitle, _scriptCode, _arguments, _priority, _showWindow, _hideOnUse, "", _condition]], "addAction", true, true] call BIS_fnc_MP;
	//[_object, [_actionTitle, _scriptCode, _arguments, _priority, _showWindow, _hideOnUse, "", _condition]] remoteExec ["addAction", 0, true];

	[
	    _object,                                                                           											// Object the action is attached to
	    _actionTitle,                                                                       										// Title of the action
	    _icon,                      																				// Idle icon shown on screen
	    _icon,                      																				// Progress icon shown on screen
	    "_this distance _target < 3",                                                        							// Condition for the action to be shown
	    "_caller distance _target < 3",                                                      						// Condition for the action to progress
	    {},                                                                                  											// Code executed when action starts
	    {},                                                                                 											// Code executed on every progress tick
	    _scriptCode,               								                                 						// Code executed on completion
	    {},                                                                                  											// Code executed on interrupted
	    [],                                                                                  											// Arguments passed to the scripts as _this select 3
	    5,                                                                                  											// Action duration [s]
	    2000,                                                                                 											// Priority
	    true,                                                                                											// Remove on completion
	    false                                                                                											// Show in unconscious state 
	] remoteExec ["BIS_fnc_holdActionAdd", [0,-2] select isDedicated, true];        		// example for MP compatible implementation


};

SAC_fnc_disableAutoCombat = {

	params ["_units", "_canEngage"];

	{

		_x disableAI "AUTOCOMBAT";

		if (!_canEngage) then {

			_x disableAI "AUTOTARGET";

			_x disableAI "TARGET";

		};

		_x doWatch objNull;

	} forEach _units;

};

SAC_fnc_enableAutoCombat = {

	params ["_units"];

	{

		_x enableAI "TARGET";

		_x enableAI "AUTOTARGET";
		_x enableAI "AUTOCOMBAT";


	} forEach _units;

};

SAC_fnc_createVehicles = {

	params ["_centerPos", "_maxDistance", "_maxVehicles", "_vehClasses", "_crewClasses", "_autoDeleteGroup"];

	private ["_validPos", "_iteration", "_start", "_vehicle", "_grp", "_wp", "_vehicles"];

	_vehicles = [];

	for "_k" from 1 to _maxVehicles do {

		//Crear un vehículo alrededor de la posición central, cuidando que no sea a menos de 500 de una unidad 'player'.
		_validPos = false;
		_iteration = 0;
		while {(!_validPos) && {_iteration < 20}} do {

			_iteration = _iteration + 1;

			_start = _centerPos getPos [round random _maxDistance, round random 360];

			//[_centerPos, _minDistance, _posSize, _maxTerrainGradient, _roadAllowed, _noplayerDistance, _maxDistance, _debug, _blacklist] call SAC_fnc_safePosition;
			_start = [_start, 0, 10, 7, true, 500, 100, false, []] call SAC_fnc_safePosition;

			if (count _start > 0) then {

				_validPos = true;

			};

		};

		if !(_validPos) exitWith {"No valid position for vehicle could be found." call SAC_fnc_MPsystemChat};

		private ["_returnedArray", "_crewGrp"];

		//["_position", "_direction", "_vehicleClasses", "_crewClasses", "_special", "_autoDeleteGroup"]
		_returnedArray = [_start, random 360, _vehClasses, _crewClasses, "NONE", _autoDeleteGroup] call SAC_fnc_spawnVehicle;
		_vehicle = _returnedArray select 0;
		_crewGrp = _returnedArray select 1;

		_wp = _crewGrp addWaypoint [_start, 0];
		_wp setWaypointType "HOLD"; _wp setWaypointSpeed "NORMAL"; _wp setWaypointBehaviour "SAFE";

		_vehicles pushBack _vehicle;

	};

	_vehicles

};

SAC_fnc_setSkills = {

	params ["_grp"];
	
	{
	
		_x setSkill ["general", 0.5]; //a este no lo entiendo
		
		//a estos los controla ai precision en el preset de dificultad
		_x setSkill ["aimingAccuracy", 0.2];
		_x setSkill ["aimingShake", 0.2];
		//a estos los controla ai skill en el preset de dificultad
		_x setSkill ["aimingSpeed", 0.005];
		_x setSkill ["commanding", 0.16];
		_x setSkill ["courage", 1];
		_x setSkill ["reloadSpeed", 0.18];
		_x setSkill ["spotDistance", 0.5]; //fue 0.3 hasta el 18/01/2018
		_x setSkill ["spotTime", 0.19];

	} forEach units _grp;

};

SAC_fnc_logSkillFinals = {

	diag_log "*********************************************************************";
	diag_log ("general: " + str (_this skillFinal "general"));
	
	diag_log ("aimingAccuracy: " + str (_this skillFinal "aimingAccuracy"));
	diag_log ("aimingShake: " + str (_this skillFinal "aimingShake"));
	
	diag_log ("aimingSpeed: " + str (_this skillFinal "aimingSpeed"));
	diag_log ("commanding: " + str (_this skillFinal "commanding"));
	diag_log ("courage: " + str (_this skillFinal "courage"));
	diag_log ("reloadSpeed: " + str (_this skillFinal "reloadSpeed"));
	diag_log ("spotDistance: " + str (_this skillFinal "spotDistance"));
	diag_log ("spotTime: " + str (_this skillFinal "spotTime"));
	diag_log "*********************************************************************";


};

SAC_fnc_addHandleDamage = {

	player addEventHandler
	[
	"HandleDamage",
	{
		//params ["_unit", "_selection", "_damage"];
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
		
		//diag_log format ["%1 - %2", _selection, _damage];
		
		if (group _unit == group _source) then {
		
			_damage = 0;
		
		} else {
		
			//if (_damage >= 0.9) then {
			if (_damage >= 0.9) then {
				
				[_unit] spawn {
				
					(_this select 0) setCaptive true;
					(_this select 0) allowDammage false;
					
					titleText ["", "BLACK FADED", 200];
					0 fademusic 0;
					0 fadeSound 0;
					0 fadeRadio 0;
					
					sleep 5;
					
					titleText ["", "BLACK IN", 1];

					1 fademusic 1;
					1 fadeSound 1;
					1 fadeRadio 1;
		
					(_this select 0) setCaptive false;
					_this spawn {sleep 5; (_this select 0) allowDammage true};
					
				};
				
				//systemChat "You would have died.";
				_damage = 0;
			
			};
			
		};
		
		_damage
		
	}
	];

};

SAC_fnc_addHandleDamageWithUnconscious = {

	params ["_unit"];
	
	_unit setVariable ["sac_health", 100, true];
	
	_unit setVariable ["sac_healing", 0, true];
	
	_unit setVariable ["sac_bleading", false];
	
	_unit setVariable ["sac_beingtreated", false];
	
	if (_unit call SAC_fnc_isMedic) then {
	
		[_unit] spawn SAC_fnc_autoMedic;
		
		_unit allowDammage false;
	
	};
	
	_unit addEventHandler
	[
	"HandleDamage",
	{
		//params ["_unit", "_selection", "_damage"];
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
		
		if (group _unit == group _source) then {
		
			_damage = 0;
		
		} else {
		
			if (_damage >= 0.9) exitWith {
				
				_unit allowDammage false;
				_unit setCaptive true;
				_unit setUnconscious true;
				_unit setVariable ["sac_incapacitated", true, true];

				[_unit] spawn SAC_fnc_bleadingSimulation;
				[_unit] spawn SAC_fnc_healingSimulation;
				
				_damage = 0;
			
				
			
			};
		
		};

		_damage
		
	}
	];
	
	_unit setVariable ["SAC_can_get_unconscious", true];

};

SAC_fnc_bleadingSimulation = {

	params ["_u"];
	
	if (_u getVariable ["sac_bleading_running", false]) exitWith {}; //previene que se ejecute mas de una instancia
	
	_u setVariable ["sac_bleading_running", true];
	
	//systemChat "entro a bleading";
	//systemChat str (_u getVariable ["sac_incapacitated", false]);
	
	private _friendlies = 0;
	
	private _health = 0;
	
	while {(alive _u) && (_u getVariable ["sac_incapacitated", false])} do {
	
		/*
		count units SAC_PLAYER_SIDE
		No deberia incluir las unidades inconcientes porque pasan al bando civil, pero por algun
		motivo las incluye igual, sean o no del grupo del jugador. Estar atento por si no funciona
		igual cuado las unidades sean remotas.
		*/
		_friendlies = {(alive _x) && (_x distance _u < 30) && !(_x getVariable ["sac_incapacitated", false])} count units SAC_PLAYER_SIDE;
		
		if (_friendlies > 0) then {
		
			_u setVariable ["sac_bleading", false];
	
		} else {
		
			_u setVariable ["sac_bleading", true];
			
			_health = _u getVariable "sac_health";
			
			_u setVariable ["sac_health", _health - 0.5];
		
			if (_health <= 0) then {_u setDamage 1};
			
		};
		
		sleep 1;
	
	};
	
	_u setVariable ["sac_bleading_running", false];
	
	//systemChat "salgo de bleading";
	
};

SAC_fnc_healingSimulation = {

	params ["_u"];
	
	if (_u getVariable ["sac_healing_running", false]) exitWith {}; //previene que se ejecute mas de una instancia
	
	_u setVariable ["sac_healing_running", true];
	
	//systemChat "entro a healing";
	
	private _medics = 0;
	
	private _healing = 0;
	
	while {(alive _u) && (_u getVariable ["sac_incapacitated", false])} do {
	
		_medics = {(_x call SAC_fnc_isMedic) && (alive _x) && (_x distance _u < 30) && !(_x getVariable ["sac_incapacitated", false])} count units SAC_PLAYER_SIDE;
		
		if (_medics > 0) then {
		
			_healing = _u getVariable "sac_healing";
			
			_u setVariable ["sac_healing", _healing + 3.3];
			
			_u setVariable ["sac_beingtreated", true];
		
		} else{
		
			_u setVariable ["sac_beingtreated", false];
		
		};
	
		if (_healing >= 100) then {
		
			_u setVariable ["sac_incapacitated", false, true];
			
			_u setUnconscious false;
			_u allowDammage true;
			_u setCaptive false;
		
			_u setDamage 0;
			
			_u setVariable ["sac_healing", 0];
			
			_u setVariable ["sac_health", 100];
			
			if (isNull attachedTo _u) then {
			
				if (_u getVariable ["sac_needs_switchmove", false]) then {
				
					_u switchMove "";
				
				};
				
			};
			
		};
	
		sleep 1;
	
	};
	
	_u setVariable ["sac_healing_running", false];
	
	//systemChat "salgo de healing";

};

SAC_fnc_autoMedic = {

	params ["_u"];
	
	while {alive _u} do {

		if !(_u getVariable ["sac_incapacitated", false]) then {
	
			{
			
				_x setDamage 0;
			
			} forEach (units SAC_PLAYER_SIDE) select {(_x distance _u < 30) && !(_x getVariable ["sac_incapacitated", false])};
			
		};

		sleep 60;
	
	};
	
};

SAC_fnc_carryUnit = {

	params ["_u"];
	
	_u switchMove "AinjPfalMstpSnonWrflDf_carried_dead";
	player switchMove "AcinPercMstpSrasWrflDnon";
	_u attachTo [player,[0.15,0.15,0]];
	
	player setVariable ["sac_carried", _u];

};

SAC_fnc_dropCarrying = {

	private _carried = player getvariable "sac_carried";
	
	player switchMove "";
	detach _carried;
	_carried switchMove "AinjPpneMstpSnonWrflDnon";
	_carried setVariable ["sac_needs_switchmove", true, true];
	
	if !(_carried getVariable "sac_incapacitated") then {
	
		_carried switchMove "";
	
	};
	
	player setVariable ["sac_carried", objNull];

};

SAC_fnc_LoadCarrying = {

	params ["_v"];

	if (_v distance player > 10) exitWith {hint (parseText "<t color='#00FFFF' size='1.2'><br/>No se encuentra vehiculo.<br/><br/></t>");};

	private _c = player getvariable "sac_carried";
	
	_done = [_c, _v, ["Cargo", "commonTurret", "personTurret", "Commander", "Gunner"]] call SAC_fnc_moveUnitToVehicle;

	if (_done) then {
	
		player switchMove "";
		detach _c;
		//_c setVariable ["sac_needs_switchmove", true, true];
		
	} else {
	
		hint (parseText "<t color='#00FFFF' size='1.2'><br/>No hay lugares vacios.<br/><br/></t>");
	
	};

};

SAC_fnc_addHandleDamageAI = {

	params ["_unit"];
	
	_unit addEventHandler
	[
	"HandleDamage",
	{
		params ["_unit", "_selection", "_damage"];
		
		if (_damage >= 0.25) then {
			
			_damage = 1;
		
		};
		
		_damage
		
	}
	];

};

SAC_fnc_getNearestSafeInfGroup = {

	params ["_position", "_maxDistance", "_side"];
	
	private ["_minDistance", "_grp"];
	
	_grp = grpNull;
	_minDistance = _maxDistance;
	{

		if (	(_x getVariable ["SAC_ISPATROL", false]) && {(leader _x) distance _position < _minDistance} && {(leader _x) isKindOf "Man"} && {isNull objectParent (leader _x)} && {behaviour leader _x != "COMBAT"}) then {
		
			_minDistance = (leader _x) distance _position;
			_grp = _x;
		
		};
	
	} forEach groups _side;

	_grp

};

SAC_fnc_sendNearestSafeInfGroup =  {

	params ["_position", "_maxDistance", "_side"];
	
	private ["_grp"];
	
	_grp = [_position, _maxDistance, _side] call SAC_fnc_getNearestSafeInfGroup;
	
	if (!isnull _grp) then {
	
		//[(_position getPos [70,  _position getDir (getPos leader _grp)]), "ColorRed", ""] call SAC_fnc_createMarker;
		_grp move (_position getPos [70,  _position getDir (getPos leader _grp)]);
		_grp setBehaviour "AWARE"; [_grp, currentWaypoint _grp] setWaypointSpeed "NORMAL";
		
/*		sleep 5;

		//["_grp", "_order", "_centerPos", "_waypointSpeed", "_waypointBehaviour", "_waypointTimeoutMin", "_waypointTimeoutMed", "_waypointTimeoutMax", "_maxDistance", "_blacklistsMarkers", "_maxPoints", "_minDistanceBetweenPoints", "_plot"]
		[_grp, ["MOVE"], (_position getPos [round random 70, round random 360]), "NORMAL", "AWARE", 0, 0, 0, "", 0, [], 0, 0, false] call SAC_fnc_orderGroup;
		
		[_grp, ["PATROL"], _position, "NORMAL", "AWARE", 0, 0, 0, "", 600, [], 3, 200, false] call SAC_fnc_orderGroup;		
*/	
	};



};

SAC_fnc_getWeaponsListFromDeadUnits = {

	/*
		Excluye los "launchers". Sólo rifles.
	*/
	
	params ["_position", "_radius"];

	private ["_holders", "_weaponsList"];
	
	_holders = nearestObjects [_position, ["WeaponHolderSimulated", "GroundWeaponHolder"], _radius];
	
	_weaponsList = [];
	{
	
		//diag_log weaponCargo _x;
		{
		
			if (getNumber (configFile >> "CfgWeapons" >> _x >> "type") == 1) then {
			
				_weaponsList pushBackUnique _x;
				
			};
		
		} forEach weaponCargo _x;
	
	} forEach _holders;

	//diag_log _weaponsList;
	
	_weaponsList

};

SAC_fnc_getRandomWeaponFromDeadUnits = {

	/*
		Excluye los "launchers". Sólo rifles.
	*/
	
	params ["_position", "_radius"];

	private ["_holders", "_validWeapon"];
	
	_holders = nearestObjects [_position, ["WeaponHolderSimulated", "GroundWeaponHolder"], _radius];
	
	_validWeapon = "";
	{
	
		//diag_log weaponCargo _x;
		{
		
			if (getNumber (configFile >> "CfgWeapons" >> _x >> "type") == 1) then {
			
				_validWeapon = _x;
				
			};
			
			if (_validWeapon != "") exitWith {};
		
		} forEach weaponCargo _x;
		
		if (_validWeapon != "") exitWith {
		
			clearWeaponCargoGlobal _x;
		
		};
	
	} forEach _holders;

	//diag_log _validWeapon;
	
	_validWeapon

};

SAC_fnc_getAreaDesignation = {

	//Si se pasa un marcador (tipo elipse/no hay "defensive code"), el punto central y el radio se obtienen del marcador, si no
	//se pasan parametros, se pide al jugador que marque los dos puntos.
	
	params ["_marker"];

	private _centerPos = [];
	
	if (count _this == 0) then {
	
		//Pedir al player que marque el punto central del área.
		hint "Designate the center of the area. Escape to cancel.";
		_centerPos = [] call SAC_fnc_select_position_in_map;
		hint "";
		
	} else {
	
		_centerPos = getMarkerPos _marker;
	
	};
		
	if (_centerPos isEqualTo [0,0,0]) exitWith {hint "Cancel order confirmed."; [[0,0,0], 0]};
	
	private _radius = 0;
	
	if (count _this == 0) then {
	
		hint "Designate the perimeter of the area. Escape to cancel.";
		private _radiusPos = [] call SAC_fnc_select_position_in_map;
		hint "";
		
		if (_radiusPos isNotEqualTo [0,0,0]) then {_radius = _centerPos distance _radiusPos};
		
	} else {
	
		_radius = (getMarkerSize _marker) select 0;
	
	};
	
	if (_radius == 0) exitWith {hint "Cancel order confirmed."; [[0,0,0], 0]};
	
	[_centerPos, _radius]

};

SAC_fnc_getPointDesignation = {

	//Si se pasa un marcador (tipo simbolo/no hay "defensive code"), el punto central se obtiene del marcador, si no
	//se pasan parametros, se pide al jugador que marque el punto.
	
	params ["_marker"];

	private _centerPos = [];
	
	if (count _this == 0) then {
	
		//Pedir al player que marque el punto central del área.
		hint "Click on the desired position. Escape to cancel.";
		_centerPos = [] call SAC_fnc_select_position_in_map;
		hint "";
		
	} else {
	
		_centerPos = getMarkerPos _marker;
	
	};
		
	if (_centerPos isEqualTo [0,0,0]) exitWith {hint "Cancel order confirmed."; [0,0,0]};
	
	_centerPos

};

SAC_fnc_showcaseClassesArray = {

	private _array = ["Land_HelipadEmpty_F","Land_Shed_M03","Land_HouseV_1L2","Land_Shed_W02","Land_rails_bridge_40","Land_Ind_TankSmall","Land_seno_balik","Land_Barn_W_01","Land_Kulna","Land_Shed_W01","Land_HouseV_1I1","Land_Wall_Gate_Ind1_L","Land_Wall_Gate_Ind1_R","Land_PowLines_WoodL","Land_HouseV_3I3","Land_Misc_GContainer_Big","Land_Shed_W03","Land_Vez","Land_HouseV_1I2","Land_Shed_W4","Land_Ind_Shed_02_main","Land_Ind_Shed_02_end","Land_Stodola_open","Land_fuel_tank_small","Land_houseV_2T1","Land_HouseV_1I4","Land_Ind_Workshop01_03","Land_HouseV_3I2","Land_Shed_M01","Land_HouseV_1I3","Land_Plot_rust_branka","Land_HouseV_3I4","Land_HouseV_2I","Land_Wall_CBrk_5_D","Land_HouseV2_01A","Land_HouseV_2L","Land_SignB_Pub_CZ3","Land_HouseV_3I1","Land_Psi_bouda","Land_Misc_deerstand","Land_HouseV_1T","Land_KBud","Land_Brana02nodoor","Land_Church_tomb_1","Land_Church_tomb_3","Land_Church_tomb_2","Land_Farm_Cowshed_a","Land_Farm_Cowshed_b","Land_Kontejner","Land_houseV_2T2","Land_Nav_Boathouse_PierT","Land_BoatSmall_2a","Land_BoatSmall_1","Land_HouseV2_05","Land_HouseV_1L1","Land_Wall_CGry_5_D","Land_Church_02a","Land_Farm_Cowshed_c","Land_Hut06","Land_Plot_green_branka","Land_Wall_Gate_Wood1","Land_Ind_Workshop01_02","Land_Shed_M02","Land_Plot_rust_vrata","Land_Lampa_sidl","land_nav_pier_c_90","land_nav_pier_c_270","land_nav_pier_F_23","Land_Ind_Workshop01_04","Land_Misc_Cargo2B","Land_Misc_Cargo2D","Land_Misc_Cargo1C","Land_SignB_Pub_CZ1","land_nav_pier_c","Land_Hlidac_budka","Land_Misc_Cargo1B","Land_Ind_Workshop01_01","Land_Plot_green_vrata","Land_Ind_Timbers","Land_Pumpa","Land_HouseV2_04_interier","Land_SignB_Gov","Land_SignB_PostOffice","Land_Ind_SawMillPen","Land_Ind_BoardsPack1","Land_PowLines_ConcL","Land_Ind_SawMill","Land_SignB_GovSign","Land_HouseV2_01B","Land_Ind_BoardsPack2","Land_Rail_House_01","Land_sign_kamenka","Land_A_FuelStation_Build","Land_A_FuelStation_Feed","Land_Fuel_tank_big","Land_Ind_Shed_01_end","Land_Ind_Shed_01_main","Land_Ind_TankSmall2","Land_Shed_Ind02","Land_Trafostanica_velka","Land_Wall_Gate_Ind2B_R","Land_Ind_Workshop01_L","Land_sloup_vn","Land_Trafostanica_velka_draty","Land_Wall_Gate_Ind2B_L","Land_Misc_WaterStation","Land_sloup_vn_drat","Land_Stodola_old_open","Land_Misc_PowerStation","Land_Lampa_ind","Land_A_GeneralStore_01a","Land_A_FuelStation_Shed","Land_SignB_Pub_RU1","Land_Fuel_tank_stairs","Land_HouseV2_03B","Land_Wall_Gate_Village","Land_Church_02","Land_HouseBlock_A3","Land_HouseBlock_A1_1","Land_HouseBlock_C5","Land_HouseBlock_C4","Land_sloup_vn_dratZ","Land_Barn_Metal","Land_Repair_center","Land_BoatSmall_2b","Land_Ind_Garage01","Land_NAV_Lighthouse","Land_Vysilac_FM","Land_Church_03","Land_SignB_Pub_CZ2","Land_Nasypka","Land_Wall_Gate_Ind2A_L","Land_Wall_Gate_Ind2A_R","Land_Hangar_2","Land_Misc_Cargo2E","Land_Ind_TankBig","Land_Tovarna2","land_nav_pier_m_end","Land_nav_pier_m_2","land_nav_pier_c_t15","Land_Ind_Expedice_3","Land_sign_komarovo","Land_Mil_House","Land_Mil_Barracks_L","Land_A_TVTower_Base","Land_A_TVTower_Mid","Land_A_TVTower_Top","Land_Mil_Guardhouse","Land_HouseV2_02_Interier","Land_A_statue01","Land_Stoplight02","Land_A_Office01","Land_SignB_Hotel_CZ2","Land_CncBlock","Land_Mil_Barracks","Land_Ind_IlluminantTower","Land_HouseV2_03","Land_Komin","Land_NavigLight","Land_runway_edgelight","Land_Runway_PAPI","Land_Runway_PAPI_4","Land_Runway_PAPI_3","Land_Runway_PAPI_2","land_nav_pier_F_17","Land_Misc_Cargo1D","Land_sign_balota","Land_Sara_hasic_zbroj","Land_Sara_domek_zluty","Land_Ss_hangar","Land_Misc_Cargo1Ao","Land_Mil_Barracks_i","Land_ruin_01","Land_Mil_ControlTower","Land_a_stationhouse","Land_A_Castle_WallS_10","Land_Church_01","Land_Wall_Gate_Kolchoz","Land_Barn_W_02","Land_Dam_Barrier_40","Land_Misc_Cargo1Bo","Land_Farm_WTower","Land_SignB_Pub_RU3","Land_Sign_Bar_RU","Land_Ind_Pec_03a","Land_Ind_MalyKomin","Land_CncBlock_D","Land_Tec","Land_Rail_Zavora","Land_Rail_Semafor","Land_Lampa_ind_zebr","Land_Panelak","Land_Panelak2","Land_Molo_drevo_bs","Land_rail_station_big","Land_sign_chernogorsk","Land_A_Hospital","Land_IndPipe2_big_18ladder","Land_IndPipe2_big_9","Land_IndPipe2_bigL_R","Land_IndPipe2_bigL_L","Land_IndPipe2_big_ground1","Land_Ind_Mlyn_01","Land_Ind_Mlyn_04","Land_Ind_Vysypka","Land_D_Mlyn_Vys","Land_IndPipe2_Small_9","Land_IndPipe2_Small_ground1","Land_IndPipe2_SmallL_R","Land_Ind_Mlyn_D2","Land_IndPipe2_big_18","Land_IndPipe2_T_R","Land_Ind_Mlyn_02","Land_Ind_Mlyn_D1","Land_IndPipe2_big_ground2","Land_Ind_Mlyn_03","Land_IndPipe2_bigBuild1_R","Land_ind_silomale","Land_D_Vez_Mlyn","Land_IndPipe2_bigBuild2_L","Land_A_Castle_Bastion","Land_A_GeneralStore_01","Land_Vez_Silo","Land_D_Pec_Vez2","Land_Ind_Pec_03b","Land_IndPipe2_SmallL_L","Land_A_Castle_Gate","Land_A_Castle_Wall1_End","Land_Lampa_sidl_2","Land_Ind_Expedice_1","Land_Ind_Expedice_2","Land_D_Pec_Vez1","Land_IndPipe2_SmallBuild1_R","Land_IndPipe2_SmallBuild2_R","Land_IndPipe2_T_L","Land_A_Office02","Land_HouseBlock_B5","Land_HouseBlock_B4","Land_HouseBlock_B3","Land_Telek1","Land_A_Castle_Bergfrit","Land_A_Castle_Wall2_30","Land_A_Castle_Wall2_End","Land_A_Castle_Wall2_Corner_2","Land_Nav_Boathouse_PierL","Land_SignB_GovPolice","Land_IndPipe2_big_support","Land_Ind_Pec_01","Land_Vez_Pec","Land_IndPipe2_Small_ground2","Land_HouseBlock_B6","Land_Ind_Pec_02","Land_Ind_SiloVelke_02","Land_D_VSilo_Pec","Land_A_Pub_01","Land_A_statue02","Land_Ind_SiloVelke_most","Land_Ind_SiloVelke_01","Land_Company3_2","land_nav_pier_C_R10","Land_HouseBlock_D2","Land_HouseBlock_A1","Land_Wall_Gate_Ind2Rail_L","Land_Wall_Gate_Ind2Rail_R","Land_HouseBlock_A2_1","Land_HouseBlock_C3","Land_HouseBlock_A2","Land_HouseBlock_B1","Land_HouseBlock_D1","Land_A_Castle_WallS_End","Land_A_MunicipalOffice","Land_A_Castle_WallS_5_D","Land_SignB_GovSchool","Land_Sign_BES","Land_HouseB_Tenement","Land_A_Castle_Wall1_20","Land_A_Castle_Wall1_End_2","Land_A_Castle_Wall2_Corner","Land_A_Castle_Wall1_20_Turn","Land_A_Castle_Stairs_A","Land_A_Castle_Wall1_Corner_2","Land_A_Castle_Donjon","Land_A_Castle_Wall2_End_2","Land_A_Crane_02b","Land_A_Crane_02a","Land_IndPipe1_stair","Land_Misc_Cargo2C","land_nav_pier_m_1","land_nav_pier_c_big","land_nav_pier_c_t20","land_nav_pier_M_fuel","Land_loco_742_blue","Land_wagon_box","Land_A_BuildingWIP","Land_A_CraneCon","land_nav_pier_C_R30","Land_sign_prigorodki","Land_Church_05R","Land_ruin_rubble","Land_ruin_corner_1","Land_ruin_walldoor","Land_NAV_Lighthouse2","Land_ruin_wall","Land_ruin_corner_2","Land_ruin_chimney","Land_Misc_Scaffolding","Land_SignB_Pub_RU2","Land_Dam_Conc_20","Land_Dam_ConcP_20","Land_sloup_vn_drat_d","land_nav_pier_C_L10","land_nav_pier_c2_end","Land_HouseBlock_B2","Land_IndPipe2_SmallBuild1_L","Land_Lampa_sidl_3","Land_sign_elektrozavodsk","Land_HouseBlock_C2","Land_Ind_Stack_Big","Land_Gate_wood2_5","Land_Gate_Wood1_5","Land_Molo_drevo_end","Land_A_Castle_Wall1_Corner","Land_Ind_Workshop01_box","Land_Nav_Boathouse","Land_Shed_wooden","Land_sign_kamyshovo","Land_HouseBlock_A1_2","Land_HelipadCircle_F","Land_sign_altar","land_nav_pier_c2","Land_Ind_Quarry","Land_sign_berezino","Land_sign_solnichnyi","Land_Nav_Boathouse_PierR"];

	private _xCoord = 0;
	private _yCoord = 0;
	private _gridSize = 50;
	private _column = 0;
	private _row = 0;
	private _object = objNull;
	
	systemChat "empezando";
	
	{
	
		systemChat format["%1, %2", _column, _row];
		
		_object = _x createVehicle [_column * _gridSize, _row * _gridSize];
		
		SAC_Zeus addCuratorEditableObjects [[_object], true] ;
		
		_column = _column + 1;
		if (_column == 20) then {_column = 0; _row = _row + 1};
	
	} forEach _array;
	
	systemChat "terminado";


};

SAC_fnc_isUnderRoof = {

	params ["_unit"];
	
	if (count(lineIntersectsObjs [(getposASL _unit), [(getposASL _unit select 0),(getposASL _unit select 1),((getposASL _unit select 2) + 20)]]) == 0) then {
		false
	} else {
		true
	};
	
};

SAC_fnc_nearestPlayer = {

	params ["_p"];

	private _distance = 0;
	private _nearestPlayer = objNull;
	private _nearestDistance = 9999999;
	{
	
		_distance = _x distance _p;
		if (_distance < _nearestDistance) then {
		
			_nearestPlayer = _x;
			_nearestDistance = _distance;
		
		};
	
	} forEach allPlayers;

	_nearestPlayer

};

SAC_fnc_squematicToArray = {

	/*
		Convierte un plano de un array en un array. Por ej. si el plano es ["string1", 5, "string2", 3], el resultado devuelto será
		["string1", "string1", "string1", "string1", "string1", "string2", "string2", "string2"], es decir, 5 veces "string1", y 3 veces
		"string2".
	
	*/
	params ["_squematic"];
	
	private _element = "";
	private _array = [];
	{

		if (_x isEqualType "") then {
		
			_element = _x
			
		} else {
		
			for "_k" from 1 to _x do {_array pushBack _element}; 
		
		};

	} forEach _squematic;

	_array call SAC_fnc_shuffleArray

};

SAC_fnc_behaviour_get_away_from_player_side = {

	private ["_grp", "_alertDistance", "_vehicle", "_nearestArrester", "_dir", "_destRoad", "_g"];
	
	_grp = _this select 0;
	_alertDistance = _this select 1;
	_blacklistMarkers = _this select 2;
	
	private _leader = leader _grp;
	_vehicle = vehicle leader _grp;
	
	//NOTA: Cuando el jugador captura a las unidades, las hace parte de su grupo, y el grupo de las unidades queda vacío. Entonces todas las comprobaciones por
	//unidades vivas dan false. Tener en cuenta.
	
	//Esperar hasta que las unidades vean unidades del lado del jugador antes de comenzar a escapar.
	while {(units _grp findIf {alive _x} != -1) && {SAC_PLAYER_SIDE countSide (_vehicle nearEntities _alertDistance) == 0} && {leader _grp knowsAbout player < 0.3}} do {

		sleep 1;
	
	};
	
	if (units _grp findIf {alive _x} == -1) exitWith {};
	
	{
	
		_x forceSpeed -1;
		_x enableAI "PATH";
		vehicle _x forceSpeed -1;
		vehicle _x enableAI "PATH";
	
	} forEach units _grp;
	
	//No correr la parte que los guía en vehículo si arrancan de a pié.
	if (_vehicle != leader _grp) then {
	
		//Mientras están vivos y en el vehículo.
		//NOTA: Con crew _vehicle findIf {alive _x} != -1 quiero detectar si están en el vehículo.
		while {(units _grp findIf {alive _x} != -1) && {crew _vehicle findIf {alive _x} != -1}} do {
		
			_nearestArrester = [_vehicle, _alertDistance] call SAC_fnc_nearestPlayerSide;
			
			//Si hay un "arrester" cerca, tratar de escapar en la dirección opuesta, si no, en cualquier dirección.
			if (!isNull _nearestArrester) then {
			
				_dir =  _nearestArrester getDir _vehicle;
				
			} else {_dir = 999};
			
			//Primero intentar a una distancia mínima de 2000 mts.
			//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, [_method]] call SAC_fnc_findRoad;
			
			//systemChat "busqueda 1 inicia";
			_destRoad = [getPos _vehicle, 2000, 4500, _dir, _blacklistMarkers, 999, "random"] call SAC_fnc_findRoad;
			//systemChat "busqueda 1 termina";
			
			if (!isNull _destRoad) then {
			
				_grp move getPos _destRoad;
				_grp setSpeedMode "FULL";
				_grp setCombatMode "YELLOW";
				_grp setBehaviour "SAFE";
				
				//systemChat "reciben orden de moverse";
				//[getPos _destRoad, "ColorRed", "Moverse!"] call SAC_fnc_createMarker;
				
			} else {
			
				//Si no se encuentra un tramo de camino de destino válido, tratar de encontrar uno más cerca.
				
				//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, [_method]] call SAC_fnc_findRoad;
				
				//systemChat "busqueda 2 inicia";
				_destRoad = [getPos _vehicle, 500, 2000, _dir, _blacklistMarkers, 999, "random"] call SAC_fnc_findRoad;
				//systemChat "busqueda 2 termina";
				
				if (!isNull _destRoad) then {
				
					_grp move getPos _destRoad;
					_grp setSpeedMode "FULL";
					_grp setCombatMode "YELLOW";
					_grp setBehaviour "SAFE";
					
					//systemChat "reciben orden de moverse";
					//[getPos _destRoad, "ColorRed", "Moverse!"] call SAC_fnc_createMarker;
					
				} else {
				
					//Por último, si no los intentos eran en una dirección específica, tratar en cualquier dirección.
					if (_dir != 999) then {
					
						_dir = 999;
						
						//Primero intentar a una distancia mínima de 2000 mts.
						//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, [_method]] call SAC_fnc_findRoad;
						
						//systemChat "busqueda 3 inicia";
						_destRoad = [getPos _vehicle, 2000, 4500, _dir, _blacklistMarkers, 999, "random"] call SAC_fnc_findRoad;
						//systemChat "busqueda 3 termina";
						
						if (!isNull _destRoad) then {
						
							_grp move getPos _destRoad;
							_grp setSpeedMode "FULL";
							_grp setCombatMode "YELLOW";
							_grp setBehaviour "SAFE";
							
							//systemChat "reciben orden de moverse";
							//[getPos _destRoad, "ColorRed", "Moverse!"] call SAC_fnc_createMarker;
							
						} else {
						
							//Si no se encuentra un tramo de camino de destino válido, tratar de encontrar uno más cerca.
							
							//[_centralPos, _minDistance, _maxDistance, _inAngleSector, _blacklist, _noplayerDistance, [_method]] call SAC_fnc_findRoad;
							
							//systemChat "busqueda 4 inicia";
							_destRoad = [getPos _vehicle, 500, 2000, _dir, _blacklistMarkers, 999, "random"] call SAC_fnc_findRoad;
							//systemChat "busqueda 4 termina";
							
							if (!isNull _destRoad) then {
							
								_grp move getPos _destRoad;
								_grp setSpeedMode "FULL";
								_grp setCombatMode "YELLOW";
								_grp setBehaviour "SAFE";
								
								//systemChat "reciben orden de moverse";
								//[getPos _destRoad, "ColorRed", "Moverse!"] call SAC_fnc_createMarker;
								
							} else {

								//Si no se encuentra a dónde escapar, bajarlos del vehículo (para que escapen a pié).
								{unassignVehicle _x} forEach units _grp;
								
							};
						
						};
					
					} else {
					
						//Si no se encuentra a dónde escapar, bajarlos del vehículo (para que escapen a pié).
						{unassignVehicle _x} forEach units _grp;
					
					};
				
				};
			
			};
			
			//Siguiente línea del While.
			
			//Si se le dió una órden de moverse...
			if (!isNull _destRoad) then {
			
				//...esperar hasta que lleguen al destino o algo pase en el camino.
				while {(units _grp findIf {alive _x} != -1) && {crew _vehicle findIf {alive _x} != -1} && {_vehicle distance _destRoad > 100}} do {
				
					sleep 1;
				
				};
			
			};
		
		};
	};
	
	//En este punto las unidades están muertas o de a pié.
	
	//Las unidades se separan, y las toma SAC_fnc_behaviour_ONE_foot_unit_get_away_from_player.
	_g = grpNull;
	{

		if (alive _x) then {
		
			_g = createGroup (if (_x == _leader) then {civilian} else {side _grp});
			[_x] joinSilent _g;
			
			sleep 0.1; //por si la entrada en un grupo nuevo necesita algún tiempo antes de poder darle órdenes
			_x spawn SAC_fnc_behaviour_ONE_foot_unit_get_away_from_player;
		};
	
	} forEach units _grp;
	
};

SAC_fnc_behaviour_ONE_foot_unit_get_away_from_player = {

	private ["_unit", "_nearestArrester", "_dir", "_centralPos", "_building", "_escapePos"];
	
	_unit = _this;
	
	[[_unit]] spawn SAC_fnc_proximityAutoArrest;
	
	_nearestArrester = [_unit, 100] call SAC_fnc_nearestPlayerSide;
	
	//Si hay un "arrester" cerca, tratar de escapar en la dirección opuesta, si no, en cualquier dirección.
	if (!isNull _nearestArrester) then {
	
		_dir =  _nearestArrester getDir _unit;
		
		_centralPos = getPos _unit getPos [700, _dir];
		
	} else {
	
		_centralPos = getPos _unit;
	
	};
	
	//Tratar de encontrar un edificio en donde esconderse.
	
	//[_centralPos, _minDistance, _maxDistance, _minPositions, _bannedTypes, _playerExclusionDistance, _blacklist, [_method]] call SAC_fnc_findBuilding;
	_building = [_centralPos, 0, 700, 3, SAC_fucked_up_buildings, 999, [], "random"] call SAC_fnc_findBuilding;
	
	if (!isNull _building) then {
	
		_escapePos = selectRandom (_building buildingPos -1);

	} else {
	
		//Si no hay edificios correr en cualquier dirección.
	
		_escapePos = _centralPos getPos [700, round random 360];
	
		_escapePos = _escapePos isflatempty [5/2, 250, 15 * (pi / 180), 5, 0, false, objNull];
	
	
	};
	
	if (count _escapePos > 0) then {
	
		group _unit move _escapePos;
		group _unit setSpeedMode "FULL";
		group _unit setCombatMode "YELLOW";
		group _unit setBehaviour "AWARE";		
	
	} else {
	
		//Si no hay edificios y falló la búsqueda de alguna posición válida, la unidad se rinde.
		_unit setUnitPos "DOWN";
		_unit stop true;
	
	};

};

SAC_fnc_simulateGAS = {

	params ["_trigger", "_duration"];

	private ["_radius", "_entities", "_timeout"];
	
	_radius = (triggerArea _trigger) select 0;
	
	_timeOut = time + _duration;
	
	while {time < _timeOut} do {
	
		sleep 3;
		
		_entities = (getPos _trigger) nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"], _radius];
		
		{
		
			if (_x isKindOf "Man") then {
			
				if ((lifeState _x == "HEALTHY") && !(goggles _x in SAC_gasmasks)) then {
				
					_x setUnconscious true;
				
				};
			
			} else {
			
				{
				
					if ((lifeState _x == "HEALTHY") && !(goggles _x in SAC_gasmasks)) then {
					
						_x setUnconscious true;
					
					};			
				
				} forEach crew _x;
			
			};
		
		
		} forEach _entities;
	
		sleep 2;
	
	};
	
};

SAC_fnc_convertToHostage = {

	params ["_grp", "_goggles"];
	
	private ["_anim","_headItem"];
	
	_grp setBehaviour "CARELESS";
	
	sleep 0.2; //sin esta pausa a veces falla el 'removeAllWeapons'
	
	[_grp, ["everyone"]] call SAC_fnc_removeGear;
	
	//sleep 10; //sin esta pausa a veces falla el 'addGoggles'
	
	{
	
		_x setCaptive true;
	
		_headItem = selectRandom _goggles;
		
		if (_headItem in ["mgsr_headbag"]) then {
		
			_x addHeadgear _headItem;
			
		} else {
		
			_x addGoggles _headItem;
		
		};
		
		//systemChat "converting to hostage";
		_anim = selectRandom ["Acts_ExecutionVictim_Loop", "Acts_ExecutionVictim_Loop", "Acts_ExecutionVictim_Loop", "Acts_ExecutionVictim_Loop", 
		"Acts_AidlPsitMstpSsurWnonDnon01", "Acts_AidlPsitMstpSsurWnonDnon02", "Acts_AidlPsitMstpSsurWnonDnon03", "Acts_AidlPsitMstpSsurWnonDnon04",
		"Acts_AidlPsitMstpSsurWnonDnon05"];
		_x switchMove _anim;

		_x disableAI "MOVE"; // Disable AI Movement
		_x disableAI "AUTOTARGET"; // Disable AI Autotarget
		_x disableAI "ANIM"; // Disable AI Behavioural Scripts
		_x allowFleeing 0; // Disable AI Fleeing
		
		//Se reemplazaron todas casi todas las 'addActions' por 'SAC_interact'.
		//[_x, "<t color='#FFFFFF'>Release</t>", "", 7, [], 0, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa"] call SAC_fnc_addPredefinedActionNew;
		
		switch (_anim) do {
		
			case "Acts_ExecutionVictim_Loop": {
			
				_x setVariable ["SAC_releaseHostageAnim", "Acts_ExecutionVictim_Unbow", true];
			
			};
			
			default {
			
				_x setVariable ["SAC_releaseHostageAnim", "Acts_AidlPsitMstpSsurWnon﻿Dnon_out", true];
			
			};
		
		};
		
		_x setVariable ["SAC_interact_isHostage", true, true];
		
		_x setVariable ["DO_NOT_DELETE", true];
		
	
	} forEach units _grp;


};

SAC_fnc_releaseHostage = {

	params ["_units"];
	
	private ["_anim"];
	
	{
	
		if (goggles _x in ["G_Blindfold_01_black_F","G_Blindfold_01_white_F"]) then {removeGoggles _x};
		if (headgear _x in ["mgsr_headbag"]) then {removeHeadgear _x};
		
		_anim = _x getVariable "SAC_releaseHostageAnim";
		
		//systemChat _anim;
		
		switch (_anim) do {
		
			case "Acts_ExecutionVictim_Unbow": {
			
				_x playMove _anim;
			
			};
			
			default {
			
				//systemChat "usando switchMove";
			
				_x switchMove _anim;
			
			};
		
		};

		

		_x enableAI "ANIM"; // Enable AI Behavioural Scripts
		
		_x setVariable ["SAC_interact_isHostage", false, true];
	
	} forEach _units;

};

SAC_fnc_makeUnconcious = {

	params ["_unit"];
	
	_unit setUnconscious true;
	
	_unit setVariable ["sac_incapacitated", true, true];
	
	sleep 5;
	
	_unit playMoveNow "AinjPpneMstpSnonWrflDnon_rolltoback";
	
	_unit spawn {
	
		waitUntil {!(_this getVariable "sac_incapacitated")};
		_this playMoveNow "AmovPpneMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon";
	
	};


};

SAC_fnc_releaseDetainee = {

	params ["_units"];
	
	{
	
		_x enableAI "ANIM"; // Enable AI Behavioural Scripts
		_x enableAI "MOVE";
		_x enableAI "AUTOTARGET";
		
		_x setVariable ["SAC_interact_isDetainee", false, true];
	
	} forEach _units;

};

SAC_fnc_detainPerson = {

	params ["_units"];

	
	{
	
		

		_x disableAI "MOVE"; // Disable AI Movement
		_x disableAI "AUTOTARGET"; // Disable AI Autotarget
		_x disableAI "ANIM"; // Disable AI Behavioural Scripts
		
		_x playMoveNow "AmovPercMstpSnonWnonDnon_Ease";
		
		_x setVariable ["SAC_interact_isDetainee", true, true];
	
	} forEach _units;

};

SAC_fnc_getCoPilots = {

	allTurrets _this select { getNumber ([_this, _x] call BIS_fnc_turretConfig >> "isCopilot") > 0 } apply { _this turretUnit _x };
	
};

SAC_fnc_moveUnitToVehicle = {

	params ["_unit", "_vehicle", "_positions"];

	private _done = false;
	
	{

		switch (_x) do {

			case "Driver": {

				if (!alive driver _vehicle) then {
				
					if (!lockedDriver _vehicle) then {

						if (local _unit) then {
						
							_unit moveInDriver _vehicle;
							
						} else {
						
							[_unit, _vehicle] remoteExec ["moveInDriver", _unit, false];
						
						};

						_done = true;
						
					};

				};

			};

			case "Gunner": {

				if ([_vehicle] call SAC_fnc_hasGunner) then {

					if (!alive gunner _vehicle) then {

						if !([_vehicle] call SAC_fnc_isGunnerLocked) then {

							if (local _unit) then {
							
								_unit moveInGunner _vehicle;
								
							} else {
							
								[_unit, _vehicle] remoteExec ["moveInGunner", _unit, false];
							
							};
							
							_done = true;
							
						};
						
					};

				};

			};

			case "Commander": {

				if ([_vehicle] call SAC_fnc_hasCommander) then {

					if (!alive commander _vehicle) then {

						if !([_vehicle] call SAC_fnc_isCommanderLocked) then {

							if (local _unit) then {
							
								_unit moveInCommander _vehicle;
								
							} else {
							
								[_unit, _vehicle] remoteExec ["moveInCommander", _unit, false];
							
							};
							
							_done = true;
							
						};
						
					};
				};

			};

			case "personTurret": {

				if (count ([_vehicle] call SAC_fnc_personTurrets) > 0) then {
				
					private _turretPath = [_vehicle] call SAC_fnc_firstEmptyPersonTurret;
					
					if (count _turretPath > 0) then {
						
						if (local _unit) then {
						
							_unit moveInTurret [_vehicle, _turretPath];
							
						} else {
						
							[_unit, [_vehicle, _turretPath]] remoteExec ["moveInTurret", _unit, false];
						
						};
						
						_done = true;

					};
					
					
				};

			};

			case "commonTurret": {

				if (count ([_vehicle] call SAC_fnc_commonTurrets) > 0) then {
				
					private _turretPath = [_vehicle] call SAC_fnc_firstEmptyCommonTurret;
					
					if (count _turretPath > 0) then {
					
						if (local _unit) then {
						
							_unit moveInTurret [_vehicle, _turretPath];
							
						} else {
						
							[_unit, [_vehicle, _turretPath]] remoteExec ["moveInTurret", _unit, false];
						
						};
						
						_done = true;

					};

				};

			};

			case "Cargo": {

				if ([_vehicle] call SAC_fnc_emptyCargoSeats > 0) then {
					
						if (local _unit) then {
						
							_unit moveInCargo _vehicle;
							
						} else {
						
							[_unit, _vehicle] remoteExec ["moveInCargo", _unit, false];
						
						};
						
						_done = true;

				};
				
			};

		};
		
		if (_done) exitWith {};

	} forEach _positions;
	
	_done

};

SAC_fnc_moveUnitsToPlayerPosition = {
	
	params ["_units"];
	
	private _playerAllowDamageState = isDamageAllowed player;
	player allowDammage false;

	private _done = false;
	{
	
		_done = false;
		
	
		//si la unidad a mover está en un vehículo, ejecutar un moveOut en donde la
		//unidad sea local,	y sólo después de eso tratar de moverla.
		if !(isNull objectParent _x)  then {
		
			[_x] remoteExec ["moveOut", _x, false];
			waitUntil {isNull objectParent _x};
			
		};
		
		if (isNull objectParent player) then { //si el player está de a pié
		
			_x setPosATL (getPosATL player);
			
			_done = true;
			
		} else { //si el player está en un vehículo
			
			_done = [_x, vehicle player, ["Driver", "Gunner", "Commander", "personTurret", "commonTurret", "Cargo"]] call SAC_fnc_moveUnitToVehicle;
			
		};
		
		if (!_done) then {systemChat "No se pudieron mover una o mas unidades."; hint (parseText "<t color='#00FFFF' size='1.2'><br/>No se pudieron mover una o mas unidades.<br/><br/></t>")};

	} forEach _units;
	
	player allowDammage _playerAllowDamageState;
	
};

SAC_fnc_playMusicWhenAceUnconscious = {

	params ["_song"];

	SAC_playingUnMusic = false;

	while {true} do {
	
		sleep 1;
		
		if (!SAC_playingUnMusic) then {

			if ((player getVariable ["ACE_isUnconscious", false]) && (alive player)) then {
			
				playMusic _song;
				SAC_playingUnMusic = true;
			
			};
			
		} else {
		
			if (!(player getVariable ["ACE_isUnconscious", false]) || !(alive player)) then {
		
				playMusic "";
				SAC_playingUnMusic = false;
		
			};
		
		};
	};
};

SAC_fnc_selectUnit = {

	params ["_sameSide", "_allPlayers", "_onlyConscious", "_sameGroupNPCs", "_includeMyGroup", "_includeSelected", "_includePointed"];
	
	private _unitList = [];
	
	if (_allPlayers) then {
	
		{
		
			if ((!_sameSide) || {side _x == side player}) then {
			
				if ((!_onlyConscious) || {!(_x getVariable ["ACE_isUnconscious", false])}) then {
				
					_unitList pushBack _x;
				
				};
			
			};
		
		}  forEach allPlayers;
	
	};
	
	if (_sameGroupNPCs) then {
	
		{

			if (alive _x) then {_unitList pushBack _x};
		
		}  forEach units group player - allPlayers;
	
	};
	
	if (count _unitList == 0) exitWith {hint (parseText "<t color='#00FFFF' size='1.2'><br/>No se encuentran unidades que cumplan con el criterio.<br/><br/></t>")};
	
	if (_includeMyGroup) then {_unitList pushBack "My Group"};
	if (_includeSelected) then {_unitList pushBack "Selected"};
	if (_includePointed) then {_unitList pushBack "Pointed"};
	
	SAC_user_input = "";

	0 = createdialog "SAC_4x16_panel";
	ctrlSetText [1800, " Select Unit Interface "];

	private _maxIndex = (count _unitList) - 1;
	private ["_item"];
	private _buttonText = "";
	for [{_c=1},{_c<=64},{_c=_c+1}] do {
	
		if ((_c - 1) <= _maxIndex) then {
		
			_item = _unitList select (_c - 1);
		
			_buttonText = if (_item isEqualType "") then {_item} else {name _item};
			ctrlSetText [1600 + _c, _buttonText];
			
			if (_buttonText in ["My Group", "Selected", "Pointed"]) then {
			
				((findDisplay 3000) displayCtrl (1600 + _c)) ctrlSetBackgroundColor [0,0,0.7,1];
			
			};
			
			if !(_item isEqualType "") then {

				if (_item getVariable ["ACE_isUnconscious", false] || _item getVariable ["sac_incapacitated", false]) then {
				
					((findDisplay 3000) displayCtrl (1600 + _c)) ctrlSetBackgroundColor [0.7,0,0,1];
				
				};
			
			};
		
		} else {
		
			ctrlShow [1600 + _c, false ];
		
		};
	
	};

	waitUntil { !dialog };
	
	if (SAC_user_input == "") exitWith {objNull};
	
	if (SAC_user_input in ["My Group", "Selected", "Pointed"]) exitWith {SAC_user_input};
	
	_unitList = _unitList - ["My Group", "Selected", "Pointed"];
	
	_unit = _unitList select (_unitList findIf {name _x == SAC_user_input});
	
	_unit
	
};

SAC_fnc_groupUnitsTracker = {

	params ["_group"];
	
	private ["_markerName", "_marker", "_unitsInTheSystem", "_deletedUnits"];

	_unitsInTheSystem = [];

	while {true} do {
	
		sleep 1;

		_deletedUnits = false;
		{
				if (!alive (_x select 0)) then {
				
					deleteMarkerLocal (_x select 1);
					_x = "delete";
					_deletedUnits = true;
					
				};
				
		} forEach _unitsInTheSystem;
		if (_deletedUnits) then {_unitsInTheSystem = _unitsInTheSystem - ["delete"]};

		{
			_markerName = name _x;
			if !(_markerName in allMapMarkers) then {
			
				_marker = createMarkerLocal [_markerName, getPos _x];
				_markerName setMarkerTypeLocal "Select";
				_unitsInTheSystem pushBack [_x, _markerName];
				
			};
			
			_markerName setMarkerPosLocal getPos _x;

			_markerName setMarkerColorLocal (switch (assignedTeam _x) do {
				case "MAIN": {"ColorBlack"};
				case "RED": {"ColorRed"};
				case "GREEN": {"ColorGreen"};
				case "BLUE": {"ColorBlue"};
				case "YELLOW": {"ColorYellow"};
				default {"ColorCiv"}; //cuando tomo un uav, todas las unidades de mi grupo reportan "" como 'assignedTeam'
			});
		} forEach units _group;
		
		if ((isNull _group) || {units _group findIf {alive _x} == -1}) exitWith {systemChat "Group units tracker finished. No alive units left."};

	};
};

SAC_fnc_markAOE = {

	params ["_u", "_aoe", "_color"];

	private _marker = [getPos _u, _color, "", "", [_aoe, _aoe], ["ELLIPSE", "Border"]] call SAC_fnc_createMarkerLocal;
	
	while {alive _u} do {
	
		sleep 1;
		
		_marker setMarkerPosLocal (getPos _u);
	
	};

};


SAC_fnc_lockOccupiedTurrets = {

	params ["_vehicle"];
	
	private _lockedTurrets = [];
	
	{
	
		if (count (_x select 3) > 0) then {
		
			_vehicle lockTurret [(_x select 3), true];
			_lockedTurrets pushBack (_x select 3);
			
		};
	
	} forEach fullCrew _vehicle;
	
	if (count _lockedTurrets > 0) then {_vehicle setVariable ["SAC_locked_turrets", _lockedTurrets]};
	
};

SAC_fnc_unlockLockedTurrets = {

	params ["_vehicle"];
	
	private _lockedTurrets = _vehicle getVariable ["SAC_locked_turrets", []];
	
	{
	
		_vehicle lockTurret [_x, false];
	
	} foreach _lockedTurrets;

	_vehicle setVariable ["SAC_locked_turrets", []];

};

SAC_fnc_getSideFromCfg = {

	params ["_class"];
	
	private _side = (configFile >> "cfgVehicles" >> _class >> "side") call BIS_fnc_getCfgData;
	
	_side call BIS_fnc_sideType;

};

SAC_fnc_findEnemySides = {

	params ["_side"];

	private _enemySides = [];

	if (_side == civilian) exitWith {_enemySides};
	
	switch (_side) do {
		
		case west: {
		
			_enemySides pushBack east;
		
			if ([west, resistance] call BIS_fnc_sideIsEnemy) then {_enemySides pushBack resistance};
		
		};

		case east: {
		
			_enemySides pushBack west;
		
			if ([east, resistance] call BIS_fnc_sideIsEnemy) then {_enemySides pushBack resistance};
			
		};
		
		case resistance: {
		
			if ([resistance, east] call BIS_fnc_sideIsEnemy) then {_enemySides pushBack east};
			
			if ([resistance, west] call BIS_fnc_sideIsEnemy) then {_enemySides pushBack west};
		
		};
		
		default {(format["ERROR: SAC_fnc_findEnemySides - No se puede evaluar el bando especificado (%1).", _side]) call SAC_fnc_debugNotify};
		
	};
	
	_enemySides
	
};

SAC_fnc_getAllMagazines = {

	params ["_unit"];
	
	private _allMagazines = [];

	//esto me da todas las 'magazines' en el inventario (incluídas granadas), menos las cargadas actualmente en cada arma
	{

		_allMagazines pushBackUnique _x;

	} forEach magazines _unit;
	
	//esto me da el 'magazine' cargada en el arma que tiene en uso
	_allMagazines pushBackUnique (currentMagazine _unit);
	
	//esto me da las 'magazines' de los launchers, si la unidad tuviera uno
	if (secondaryWeapon _unit != "") then {

		{
		
			_allMagazines pushBackUnique _x;
		
		} forEach ([secondaryWeapon _unit] call SAC_fnc_getMagazineTypes);

	};
	
	//Esta función tienen varias limitaciones, pero es la mejor aproximación
	//que se me ocurre. Diría que en la mayoría de los casos, va a funcionar,
	//y para todo lo demás, por eso les agrego 'Arsenal' a las fuentes de suministros.
	
	_allMagazines

};
 
 SAC_fnc_ammoDrop = {
 
	 //null = [getpos thistrigger] execVM "ammoDrop.sqf";
	hint "Cargo Deployed";
	_pos = _this select 0;// The position to spawn cargo.
	_cargo = "B_supplyCrate_F" createVehicle _pos;//Cannot spawn creates in the air. Why BIS, why do you torment us?
	_cargo setPos [_pos select 0, _pos select 1, 100];// So set it up in the air.
	_cargo setDir (random 360);// AmmoCrates need spontaneity too.
	[_cargo] spawn SAC_GEAR_fnc_activateSupplies;
	
	[objnull, _cargo] call BIS_fnc_curatorObjectEdited;// Where the magic happens.. spawns parachute, attaches cargo AND plays aircraft whoosh sound.
	//Remove the following if you don't want smoke marker.
	while {(getPos _cargo) select 2 > 2} do
	{
	sleep 0.2;
	};
	_smoke = "SmokeShellGreen" createVehicle position _cargo;
	_smoke setPos (getPos _cargo);
	_smoke attachTo [_cargo,[0,0,2]];
	detach _smoke;

};

SAC_fnc_transferOnlyOutfit = {

	params ["_sourceUnit", "_unit"];
	
	private ["_loadout", "_uniformArray", "_vestArray", "_backpackArray", "_allItems"];

	if !(_unit isKindOf "Man") exitWith {};
	if !(_sourceUnit isKindOf "Man") exitWith {};
	
	_loadout  = getUnitLoadout _unit;
	
	//reemplazo uniforme
	_uniformArray = _loadout select 3;

	_uniformArray set [0, uniform _sourceUnit];
	_uniformArray set [1, []];
	
	_loadout set [3, _uniformArray];
	
	//reemplazo chaleco
	_vestArray = _loadout select 4;

	_vestArray set [0, vest _sourceUnit];
	_vestArray set [1, []];
	
	_loadout set [4, _vestArray];

	//reemplazo mochila
	_backpackArray = _loadout select 5;

	_backpackArray set [0, backpack _sourceUnit];
	_backpackArray set [1, []];
	
	_loadout set [5, _backpackArray];
	
	//reemplazo el casco
	_loadout set [6, headgear _sourceUnit];
	
	//reemplazo los goggles
	_loadout set [7, goggles _sourceUnit];
	
	//leo lista con todo lo que lleva la unidad en uniforme, chaleco, y mochila
	_allItems = itemsWithMagazines _unit;
	
	//aplico el loadout original pero con los items que cambié (todos los contenedores quedan vacíos)
	_unit setUnitLoadout _loadout;
	
	if (backpack _sourceUnit != "") then {
	
		waitUntil {!isNull backpackContainer _unit};
	
	};
	
	sleep 1; //creo que si la unidad es remota (otro player), puede tardar en actualizarce su loadout nuevo en mi PC
	
	//le agrego lo que tenía la unidad, asegurandome de que no se pierda nada mientras haya un contenedor con espacio
	{_unit addItem _x} forEach _allItems;
	
};

SAC_fnc_mark_line_and_watch_direction = {

	private _startPoint = [];
	private _endPoint = [];
	private _formationDirectionPoint = [];
	private _tempMarkers = [];
	private _valid = false;
	
	//Pedirle al jugador que marque los dos puntos de la línea de distribución.
	hint "Mark the FIRST point of the line. Escape to cancel.";
	_startPoint = [] call SAC_fnc_select_position_in_map;
	hint "";

	if (_startPoint isNotEqualTo [0,0,0]) then {

		_tempMarkers pushBack ([_startPoint, "ColorBlack", "", "mil_destroy", [0.5, 0.5]] call SAC_fnc_createMarkerLocal);

		hint "Mark the SECOND point of the line. Escape to cancel.";
		_endPoint = [] call SAC_fnc_select_position_in_map;
		hint "";

		if (_endPoint isNotEqualTo [0,0,0]) then {

			_tempMarkers pushBack ([_endPoint, "ColorBlack", format["%1m", _startPoint distance _endPoint], "mil_destroy", [0.5, 0.5]] call SAC_fnc_createMarkerLocal);
			_tempMarkers pushBack ([_startPoint, _endPoint, false] call SAC_fnc_drawLine);

			hint "Mark the watch direction point of the formation. Escape to cancel.";
			_formationDirectionPoint = [] call SAC_fnc_select_position_in_map;
			hint "";
			
			{deleteMarker _x} forEach _tempMarkers;

			if (_formationDirectionPoint isNotEqualTo [0,0,0]) then {
			
				if (_startPoint distance _endPoint > 1) then {

					_valid = true;
				
				};
			
			};
			
		};

	};

	[_startPoint, _endPoint, _formationDirectionPoint, _valid]

};

SAC_fnc_select_building_in_map = {

	private _building = objNull;
	
	hint "Left click on the map to select the building. Escape to cancel.";
	private _destination = [] call SAC_fnc_select_position_in_map;
	hint "";

	if (_destination isNotEqualTo [0,0,0]) then {

		//[_centralPos, _minDistance, _maxDistance, _minPositions, _bannedTypes, _playerExclusionDistance, _blacklist, [_method]] call SAC_fnc_findBuilding;
		_building = [_destination, 0, 10, 2, SAC_fucked_up_buildings, 999, [], "closest"] call SAC_fnc_findBuilding;

	};
	
	_building

};

SAC_fnc_return_units_by_color = {

	params ["_color"];
	
	private _units = [];
	
	{
	
		if (assignedTeam _x == _color) then {_units pushBack _x}
		
	} forEach units group player - [player];

	_units

};

 //el nombre de esta función es inconsistente
SAC_fnc_applySurvivalLoadout = {

	params ["_unit"];

	for "_i" from 1 to 2 do {_unit addItemToUniform "FirstAidKit";};
	_unit addVest "V_BandollierB_blk";
	for "_i" from 1 to 3 do {_unit addItemToVest "30Rnd_556x45_Stanag";};
	_unit addWeapon "arifle_TRG20_F";
	_unit addPrimaryWeaponItem "acc_flashlight";

};

SAC_fnc_verifyArrayOfClasses = {

	//el array puede tener elementos individuales ["class1", "class2", "class3"],
	//o también subarrays ["class1", ["class3", "class4", "class5"], "class2"]

	{

		if (_x isEqualType "") then {
			if (!isClass(configFile >> "CfgVehicles" >> _x)) then {(format["Warning: SAC_FNC - Invalid class in UDS: %1", _x]) call SAC_fnc_debugNotify};
		} else {
			{
				if (!isClass(configFile >> "CfgVehicles" >> _x)) then {(format["Warning: SAC_FNC - Invalid class in UDS: %1", _x]) call SAC_fnc_debugNotify};
			} forEach _x;
		};
	} foreach _this;

};

SAC_fnc_isUnitDamaged = {

	if  (damage _this + (_this getHit "arms") + (_this getHit "hands") + (_this getHit "legs") > 0) then {true} else {false};

};

SAC_fnc_healUnit = {

	if (SAC_ACE) then {
	
		[objNull, _this] call ace_medical_treatment_fnc_fullHeal
		
	};

	if (_this getVariable ["sac_incapacitated", false]) then {

		_this setVariable ["sac_incapacitated", false, true];
		
		if (local _this) then {
		
			_this setUnconscious false;
			_this allowDammage true;
			_this setCaptive false;
		
		} else {
		
			[_this, false] remoteExec ["setUnconscious", _this];
			[_this, true] remoteExec ["allowDammage", _this];
			[_this, false] remoteExec ["setCaptive", _this];
			
		};
		
	};
	
	_this setDamage 0;


};

SAC_fnc_passwordCheck = {

	params ["_password"];

	if (_password == "") exitWith {true};

	sac_password_response = ["",""];
	
	0 = createdialog "SAC_passwordControl";
	waitUntil { !dialog };
	
	if (sac_password_response select 0 in ["", "Cancelar"]) exitWith {false};
	
	if (sac_password_response select 1 != _password) exitWith {systemChat "Codigo Incorrecto"; false};
	
	true

};

SAC_fnc_generatePassword = {

	//evita los ceros y las oes, para evitar confusiones con los tipos de letras que no los diferencian

	params ["_digits"];

	private _password = "";
	private _char = "";
	
	for "_i" from 1 to _digits do {
	
		if (random 1 < 0.5) then {
		
			if (random 1 > 0.5) then {
			
				_char = toString [[65, 78] call SAC_fnc_numberBetween];
				
			} else {
			
				_char = toString [[80, 90] call SAC_fnc_numberBetween];
			
			};
			
		} else {
		
			_char = toString [[49, 57] call SAC_fnc_numberBetween];
			
		};
		
		_password = _password + _char;
	
	};

	_password

};

SAC_fnc_markObjectsPositions = {

	params ["_objects"];

	private _markerText = "";
	{

		if (!isNull _x) then {
		
			_markerText = _x getVariable ["SAC_markerText",  " Ubicación descubierta"];
			
			[getPos _x, "ColorRed", _markerText, "hd_objective", [0.5, 0.5]] call SAC_fnc_createMarker;
		
		};
		
	} forEach _objects;

};

SAC_fnc_addTracker = {

	params ["_o", "_blindzones"];
	
	private _marker = [getPos _o, "ColorBlue", ""] call SAC_fnc_createMarker;
	_marker setMarkerAlpha 0;
	
	private _markerAlpha = 0;
	
	while {!isNull _o} do {
	
		sleep 2;
		
		_marker setMarkerPos getPos _o;
		
		if ([getPos _o, _blindzones] call SAC_fnc_isBlacklisted) then {
		
			if (_markerAlpha == 1) then {
			
				"LOCALIZADOR DESACTIVADO" call SAC_fnc_MPtitleText;
				_marker setMarkerAlpha 0;
				_markerAlpha = 0;
				
			};
			
		} else {
		
			if (_markerAlpha == 0) then {
			
				"LOCALIZADOR ACTIVADO" call SAC_fnc_MPtitleText;
				_marker setMarkerAlpha 1;
				_markerAlpha = 1;
				
			};
		
		};
	
	};

};
/*
SAC_fnc_haloUnitToPos = {

	params ["_u","_p","_altitude",["_parachute", "B_Parachute"]];
	
	_backpackClass = backpack _u;
	
	_backpackItems = backpackItems _u;
	
	removeBackpack _u; //si no se la quito, cuando le pongo otra la anterior queda en el suelo
	
	_u addBackPack _parachute;
	
	{_u addItemToBackpack _x} foreach _backpackItems;
	
	_p set [2,_altitude];
	
	_u setPosATL _p;
	
	//waitUntil {sleep 1; (!alive _u || getPosATL _u < 1)};
	waitUntil {sleep 1; (!alive _u || backpack _u == "")};
	
	_u addBackPack _backpackClass;
	
	{_u addItemToBackpack _x} foreach _backpackItems;
	
	

};
*/

SAC_fnc_haloUnitToPos = {

	params ["_u","_p","_altitude",["_openingAltitude",200],["_setCaptive", true],["_goggles", ""]];
	
	private ["_bis_fnc_halo_action","_chute","_unitGoggles"];
	
	_p set [2,_altitude];
	
	_u setCaptive _setCaptive;
	
	if (_goggles != "" && isClass(configFile >> "cfgGlasses" >> _goggles)) then {
	
		_unitGoggles = goggles _u;
		
		_u addGoggles _goggles;
	
	};
	
	_u setPosATL _p;
	
	//agregar accion para abrir paracaidas
	if (isPlayer _u) then {
	
		_bis_fnc_halo_action = _u addaction ["<t color='#ff0000'>Open Chute</t>","A3\functions_f\misc\fn_HALO.sqf",[],1,true,true,"Eject"];
	
	};
	
	waituntil {!alive _u ||(getPosATL _u select 2) <= _openingAltitude || !isNull objectParent _u};

	if (isPlayer _u) then {_u removeAction _bis_fnc_halo_action};
	
	if (!alive _u) exitWith {};

	if (!isNull objectParent _u) exitWith {
	
		if (_goggles != "" && isClass(configFile >> "cfgGlasses" >> _goggles)) then {
		
			_u addGoggles _unitGoggles;
		
		};
		
		[_u] spawn SAC_fnc_captiveUntilGround;
		
	};
	
	_chute = createVehicle ["Steerable_Parachute_F", getpos _u, [], 0, "can_collide"];  
    
	_chute setDir (getDir _u);
	
	_u moveInDriver _chute;
	
	if (_goggles != "" && isClass(configFile >> "cfgGlasses" >> _goggles)) then {
	
		_u addGoggles _unitGoggles;
	
	};
	
	waitUntil {!isNull objectParent _u};
	
	sleep 2;
	
	[_u] spawn SAC_fnc_captiveUntilGround;


};

SAC_fnc_captiveUntilGround = {

	params ["_u"];
	
	waitUntil {isTouchingGround (vehicle _u)};
	
	_u setCaptive false;
	
};

SAC_fnc_deleteAllDeadMen = {

	//_pd = playerDistance
	params [["_pd", 50]];

	{
	
		if (local _x) then {
	
			if ([_x, _pd] call SAC_fnc_notNearPlayers) then {
			
				if !(_x getVariable ["DO_NOT_DELETE", false]) then {
	
					[_x] call SAC_fnc_deleteUnit;
					
				};
				
			};
			
		};


	} forEach allDeadMen;

};

SAC_fnc_markGroupsForDeleteWhenEmpty = {

	{

		if (local _x) then {
		
			_x deleteGroupWhenEmpty true;
			
		};
	
	} forEach allGroups;
	
};

SAC_fnc_deleteUnit = {

	params ["_unit"];
	
	if (isNull objectParent _x) then {
	
		deleteVehicle _x;
		
	} else {
	
		if (alive _x) then {
		
			(vehicle _x) deleteVehicleCrew _x;
		
		} else {
			
			//Si esta en un vehiculo y no es local, no se lo puede borrar
			//porque moveOut solo toma argumentos locales.
			if (local _x) then {
			
				moveOut _x;
				deleteVehicle _x;
			
			};
			
		};
	
	};




};

fn_iconViewer = {
	params [
		["_mode", "", [""]],
		["_args", [], [[]]]
	];

	if (!hasInterface) exitWith {};
	disableSerialization;

	private _fnc_GRID_X = {
		pixelW * pixelGridNoUIScale * (((_this) * (2)) / 4)
	};

	private _fnc_GRID_Y = {
		pixelH * pixelGridNoUIScale * ((_this * 2) / 4)
	};	

	switch _mode do {
		case "onload": {
			private _display = findDisplay 46 createDisplay "RscDisplayEmpty";
			if (isNull _display) exitWith {};

			uiNamespace setVariable ["HALs_icons_idd", _display];

			["create", []] call fn_iconViewer;

			if (isNil {localNamespace getVariable "HALs_gameIcons"}) then {
				private _h = [] spawn {
					systemChat "Fetching images from available pbos.";

					private _icons = [];
					private _addons = allAddonsInfo apply {_x select 0};
					{
						_icons append (addonFiles [_x, ".paa"]);
						_icons append (addonFiles [_x, ".jpg"]);
						_icons append (addonFiles [_x, ".tga"]);
						_icons append (addonFiles [_x, ".bmp"]);
					} forEach _addons;

					localNamespace setVariable ["HALs_gameIcons", _icons];
					localNamespace setVariable ["HALs_icons_numIcons", count _icons];
					localNamespace setVariable ["HALs_icons", _icons];

					["update", []] call fn_iconViewer;
				};
			} else {
				["update", []] call fn_iconViewer;
			};
		};

		case "create": {
			private _display = uiNamespace getVariable ["HALs_icons_idd", displayNull];
			if (isNull _display) exitWith {};

			private _TABLE_WIDTH = 130;
			private _TABLE_HEIGHT = 120;

			private _totW = ((_TABLE_WIDTH) call _fnc_GRID_X);
			private _totH = ((_TABLE_HEIGHT) call _fnc_GRID_Y);

			private _pos = [
				safeZoneX + (safeZoneW / 2) - (((_TABLE_WIDTH / 2) call _fnc_GRID_X)),
				safeZoneY + (safeZoneH / 2) - (((_TABLE_HEIGHT / 2) call _fnc_GRID_Y)),
				((_TABLE_WIDTH) call _fnc_GRID_X),
				((_TABLE_HEIGHT) call _fnc_GRID_Y)
			];

			private _ctrlGroupMain = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
			_ctrlGroupMain ctrlSetPosition _pos;
			_ctrlGroupMain ctrlCommit 0;

			private _background = _display ctrlCreate ["RscText", -1, _ctrlGroupMain];
			_background ctrlSetPosition [0, 0, _pos select 2, _pos select 3];
			_background ctrlSetBackgroundColor [0.05, 0.05, 0.05, 0.95];
			_background ctrlEnable false;
			_background ctrlCommit 0;

			private _headerBackground = _display ctrlCreate ["RscText", -1, _ctrlGroupMain];
			_headerBackground ctrlSetPosition [0, 0, _pos select 2, ((3) call _fnc_GRID_Y)];
			_headerBackground ctrlSetBackgroundColor [
				profilenamespace getvariable ['GUI_BCG_RGB_R', 0.3843],
				profilenamespace getvariable ['GUI_BCG_RGB_G', 0.7019],
				profilenamespace getvariable ['GUI_BCG_RGB_B', 0.8862],
				1
			];
			_headerBackground ctrlEnable false;
			_headerBackground ctrlCommit 0;

			private _headerText = _display ctrlCreate ["RscText", -1, _ctrlGroupMain];
			_headerText ctrlSetPosition [0, 0, _pos select 2, ((3) call _fnc_GRID_Y)];
			_headerText ctrlSetFont "RobotoCondensed";
			_headerText ctrlSetTextColor [0.95, 0.95, 0.95, 1];
			_headerText ctrlSetFontHeight (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			_headerText ctrlSetText "Icon Viewer";
			_headerText ctrlEnable false;
			_headerText ctrlCommit 0;

			private _closeButton = _display ctrlCreate ["ctrlButtonPictureKeepAspect", -1, _ctrlGroupMain];
			_closeButton ctrlSetText "\a3\3DEN\Data\Displays\Display3DEN\search_end_ca.paa";
			_closeButton ctrlSetPosition [(_pos select 2) - ((3 + 0.5) call _fnc_GRID_X), 0, ((3 + 0.5) call _fnc_GRID_X), ((3) call _fnc_GRID_Y)];
			_closeButton ctrlAddEventHandler ["ButtonClick", {
				private _display = uiNamespace getVariable ["HALs_icons_idd", displayNull];
				if (!isNull _display) then {_display closeDisplay 2;};
			}];
			_closeButton ctrlCommit 0;

			private _footerBackground = _display ctrlCreate ["RscText", -1, _ctrlGroupMain];
			_footerBackground ctrlSetPosition [0, (_pos select 3) - ((5) call _fnc_GRID_Y), _pos select 2, ((5) call _fnc_GRID_Y)];
			_footerBackground ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
			_footerBackground ctrlEnable false;
			_footerBackground ctrlCommit 0;

			private _ctrlGroupList = _display ctrlCreate ["RscControlsGroupNoScrollbars", 12002, _ctrlGroupMain];
			_ctrlGroupList ctrlSetPosition [
				0,
				((3 + 0.5) call _fnc_GRID_Y),
				_pos select 2,
				(_pos select 3) - ((3 + 0.5 + 0.5 + 5) call _fnc_GRID_Y)
			];
			_ctrlGroupList ctrlSetBackgroundColor [1, 1, 1, 0.9];
			_ctrlGroupList ctrlCommit 0;

			private _origPos = ctrlPosition _ctrlGroupList;
			private _boxesX = localNamespace getVariable ["HALs_icons_boxesX", 5];
			private _boxesY = localNamespace getVariable ["HALs_icons_boxesY", 5];

			private _w0 = (
				(_origPos select 2) - ((_boxesX + 1) * ((0.5) call _fnc_GRID_X))
			) / _boxesX;
			private _h0 = (
				(_origPos select 3) - ((_boxesY + 1) * ((0.5) call _fnc_GRID_Y))
			) / _boxesY;
			private _x0 = (0.5) call _fnc_GRID_X;
			private _y0 = (0.5) call _fnc_GRID_Y;

			private _ctrls = [];
			for [{_i = 0}, {_i < _boxesY}, {_i = _i + 1}] do {
				private _y = _y0 + (((0.5) call _fnc_GRID_Y) + _h0) * _i;
				private _x = _x0;
				
				for [{_j = 0}, {_j < _boxesX}, {_j = _j + 1}] do {
					_x = _x0 + (((0.5) call _fnc_GRID_X) + _w0) * _j;
					private _pos = [_x, _y, _w0, _h0];

					private _ctrlBox = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGroupList];
					_ctrlBox setVariable ["data", ""];
					_ctrlBox ctrlShow false;

					_ctrlBox ctrlSetPosition _pos;
					_ctrlBox ctrlCommit 0;

					private _ctrlTextBG = _display ctrlCreate ["RscText", -1, _ctrlBox];
					_ctrlTextBG ctrlSetBackgroundColor [1, 1, 1, 0.15];

					_ctrlTextBG ctrlSetPosition [0, 0, _pos select 2, _pos select 3];
					_ctrlTextBG ctrlEnable false;
					_ctrlTextBG ctrlCommit 0;

					private _ctrlPicture = _display ctrlCreate ["RscPictureKeepAspect", -1, _ctrlBox];
					_ctrlPicture ctrlSetText "";
					_ctrlPicture ctrlSetBackgroundColor [1, 1, 1, 0.25];

					_ctrlPicture ctrlSetPosition [0, 0, _pos select 2, _pos select 3];
					_ctrlPicture ctrlEnable false;
					_ctrlPicture ctrlCommit 0;

					private _ctrlTextTitle = _display ctrlCreate ["RscStructuredText", -1, _ctrlBox];
					_ctrlTextTitle ctrlSetStructuredText parseText format ["<t size='0.9' shadow='2' font='puristaMedium' align='center' >%1</t>",
						"a3\ui_f_oldman\data\displays\rscdisplaymain\spotlight_1_old_man_ca.paa"
					];
					_ctrlTextTitle setVariable ["bg", _ctrlTextBG];

					_ctrlTextTitle ctrlSetPosition [0, 0, _pos select 2, (ctrlTextHeight _ctrlTextTitle) min (_pos select 3)];
					_ctrlTextTitle ctrlEnable false;
					_ctrlTextTitle ctrlCommit 0;

					private _ctrlButton = _display ctrlCreate ["ctrlActivePictureKeepAspect", -1, _ctrlBox];
					_ctrlButton setVariable ["bg", _ctrlTextBG];
					_ctrlButton ctrlAddEventHandler ["ButtonDown", {
						private _ctrl = _this select 0;
						private _data = _ctrl getVariable "data";

						if (!isNil "_data") then {
							copyToClipboard str _data;
							hint "Copied to clipboard.";
						};
					}];
					_ctrlButton ctrlAddEventHandler ["MouseEnter", {
						private _ctrl = (_this select 0) getVariable "bg";
						_ctrl ctrlSetBackgroundColor [0, 0.3, 0.6, 0.6];
					}];
					_ctrlButton ctrlAddEventHandler ["MouseExit", {
						private _ctrl = (_this select 0) getVariable "bg";
						_ctrl ctrlSetBackgroundColor [1, 1, 1, 0.15];
					}];

					_ctrlButton ctrlSetText "\a3\Data_f\clear_empty.paa";
					_ctrlButton ctrlSetPosition [0, 0, _pos select 2, _pos select 3];
					_ctrlButton ctrlEnable true;
					_ctrlButton ctrlCommit 0;

					_ctrlBox setVariable ["ctrls", [_ctrlTextBG, _ctrlTextTitle, _ctrlPicture, _ctrlButton]];
					_ctrls pushBack _ctrlBox;
				};
			};

			_ctrlGroupList setVariable ["ctrls", _ctrls];
			_display setVariable ["ctrlList", _ctrlGroupList];

			private _ctrlSearchInfo = _display ctrlCreate ["RscStructuredText", -1, _ctrlGroupMain];
			_ctrlSearchInfo ctrlSetPosition [
				((0.5) call _fnc_GRID_X),
				(_pos select 3) - ((1 + 3) call _fnc_GRID_Y),
				((_TABLE_WIDTH - 0.5*2) call _fnc_GRID_X),
				((3) call _fnc_GRID_Y)
			];
			_ctrlSearchInfo ctrlSetTextColor [0.95, 0.95, 0.95, 1];
			_ctrlSearchInfo ctrlEnable false;
			_ctrlSearchInfo ctrlSetFontHeight (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			_ctrlSearchInfo ctrlSetStructuredText parseText format ["<t align='right'>%1 images found</t>", 0];
			_ctrlSearchInfo ctrlCommit 0;

			_display setVariable ["searchInfo", _ctrlSearchInfo];

			private _ctrlSearchCheckbox = _display ctrlCreate ["ctrlCheckbox", 12001, _ctrlGroupMain];
			_ctrlSearchCheckbox ctrlSetPosition [
				((_TABLE_WIDTH / 2) call _fnc_GRID_X) - ((_TABLE_WIDTH / 4) call _fnc_GRID_X) - ((3 + 0.5) call _fnc_GRID_X),
				(_pos select 3) - ((1 + 3) call _fnc_GRID_Y),
				((3) call _fnc_GRID_X),
				((3) call _fnc_GRID_Y)
			];
			_ctrlSearchCheckbox ctrlAddEventHandler ["CheckedChanged", {
				private _checked = (_this select 1) == 1;

				(_this select 0) ctrlSetTooltip (["Case Insensitive.", "Case Sensitive."] select _checked);
				localNamespace setVariable ["HALs_icons_caseSensitive", _checked];

				["filterItems", []] call fn_iconViewer;
			}];
			_ctrlSearchCheckbox ctrlCommit 0;

			private _checked = localNamespace getVariable ["HALs_icons_caseSensitive", true];
			_ctrlSearchCheckbox ctrlSetTooltip (["Case Insensitive.", "Case Sensitive."] select _checked);
			_ctrlSearchCheckbox cbSetChecked _checked;

			private _ctrlSearch = _display ctrlCreate ["RscEdit", 12001, _ctrlGroupMain];
			_ctrlSearch ctrlSetPosition [
				((_TABLE_WIDTH / 2) call _fnc_GRID_X) - ((_TABLE_WIDTH / 4) call _fnc_GRID_X),
				(_pos select 3) - ((1 + 3) call _fnc_GRID_Y),
				((_TABLE_WIDTH / 2) call _fnc_GRID_X),
				((3) call _fnc_GRID_Y)
			];
			_ctrlSearch ctrlSetFont "RobotoCondensed";
			_ctrlSearch ctrlSetTextColor [0.95, 0.95, 0.95, 1];
			_ctrlSearch ctrlSetText (localNamespace getVariable ["HALs_icons_searchText", ""]);
			_ctrlSearch ctrlSetFontHeight (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			_ctrlSearch ctrlSetBackgroundColor [0, 0, 0, 0.7];
			_ctrlSearch ctrlCommit 0;

			private _ctrlButtonSearch = _display ctrlCreate ["ctrlButtonPictureKeepAspect", 12001, _ctrlGroupMain];
			_ctrlButtonSearch ctrlSetPosition [
				((_TABLE_WIDTH / 2) call _fnc_GRID_X) - ((_TABLE_WIDTH / 4) call _fnc_GRID_X) + ((_TABLE_WIDTH / 2) call _fnc_GRID_X) + ((0.5) call _fnc_GRID_Y),
				(_pos select 3) - ((4) call _fnc_GRID_Y),
				((3) call _fnc_GRID_X),
				((3) call _fnc_GRID_Y)
			];
			_ctrlButtonSearch ctrlSetText "\a3\3DEN\Data\Displays\Display3DEN\search_start_ca.paa";
			_ctrlButtonSearch ctrlSetBackgroundColor [0, 0, 0, 0];
			_ctrlSearch setVariable ["button", _ctrlButtonSearch];
			_ctrlButtonSearch setVariable ["edit", _ctrlSearch];
			
			_ctrlButtonSearch ctrlAddEventHandler ["ButtonClick", {
				params [
					["_ctrl", controlNull, [controlNull]]
				];

				private _ctrlEditSearch = _ctrl getVariable ["edit", controlNull];
				private _searchText = ctrlText _ctrlEditSearch;
				private _oldText = localNamespace getVariable ["HALs_icons_searchText", ""];

				if (_searchText != _oldText) then {
					localNamespace setVariable ["HALs_icons_searchText", _searchText];

					["filterItems", []] call fn_iconViewer;
				};
			}];
			_ctrlButtonSearch ctrlCommit 0;

			private _ctrlPageInfo = _display ctrlCreate ["RscStructuredText", -1, _ctrlGroupMain];
			_ctrlPageInfo ctrlSetPosition [
				(1 + 3 + 0.5) call _fnc_GRID_X,
				(_pos select 3) - ((1 + 3) call _fnc_GRID_Y),
				((10) call _fnc_GRID_X),
				((5) call _fnc_GRID_Y)
			];
			_ctrlPageInfo ctrlSetTextColor [0.95, 0.95, 0.95, 1];
			_ctrlPageInfo ctrlSetFontHeight (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			_ctrlPageInfo ctrlSetStructuredText parseText format ["<t align='center'>1 | %2</t>", 99, 99];
			_ctrlPageInfo ctrlEnable false;
			_ctrlPageInfo ctrlCommit 0;

			_display setVariable ["pageInfo", _ctrlPageInfo];

			private _ctrlButtonL = _display ctrlCreate ["ctrlButton", -1, _ctrlGroupMain];
			_ctrlButtonL ctrlSetPosition [
				(1) call _fnc_GRID_X,
				(_pos select 3) - ((1 + 3) call _fnc_GRID_Y),
				((3) call _fnc_GRID_X),
				((3) call _fnc_GRID_Y)
			];
			_ctrlButtonL ctrlSetFont "PuristaMedium";
			_ctrlButtonL ctrlSetText "<";
			_ctrlButtonL ctrlSetTooltip "Previous page.";
			_ctrlButtonL ctrlSetBackgroundColor [1, 1, 1, 0.15];
			_ctrlButtonL ctrlSetFontHeight (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			_ctrlButtonL ctrlSetTextColor [0.95, 0.95, 0.95, 1];
			_ctrlButtonL ctrlAddEventHandler ["ButtonClick", {["changePage", [-1]] call fn_iconViewer;}];
			_ctrlButtonL ctrlCommit 0;

			private _ctrlButtonR = _display ctrlCreate ["ctrlButton", -1, _ctrlGroupMain];
			_ctrlButtonR ctrlSetPosition [
				(1 + 3 + 0.5 + 10 + 0.5) call _fnc_GRID_X,
				(_pos select 3) - ((1 + 3) call _fnc_GRID_Y),
				((3) call _fnc_GRID_X),
				((3) call _fnc_GRID_Y)
			];
			_ctrlButtonR ctrlSetFont "PuristaMedium";
			_ctrlButtonR ctrlSetText ">";
			_ctrlButtonR ctrlSetTooltip "Next page.";
			_ctrlButtonR ctrlSetBackgroundColor [1, 1, 1, 0.15];
			_ctrlButtonR ctrlSetFontHeight (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			_ctrlButtonR ctrlSetTextColor [0.95, 0.95, 0.95, 1];
			_ctrlButtonR ctrlAddEventHandler ["ButtonClick", {["changePage", [1]] call fn_iconViewer;}];
			_ctrlButtonR ctrlCommit 0;
		};

		case "filterItems": {
			private _searchText = localNamespace getVariable ["HALs_icons_searchText", ""];
			private _items = localNamespace getVariable ["HALs_gameIcons", []];

			if (_searchText != "") then {
				if (localNamespace getVariable ["HALs_icons_caseSensitive", true]) then {
					_items = _items select {(_x find _searchText) > -1};
				} else {
					_searchText = toLowerANSI _searchText;

					_items = _items select {(toLowerANSI _x find _searchText) > -1};
				};
			};

			localNamespace setVariable ["HALs_icons", _items];
			localNamespace setVariable ["HALs_icons_page", 0];
			["update", []] call fn_iconViewer;
		};

		case "changePage": {
			private _maxIcons = count (localNamespace getVariable ["HALs_icons", []]);
			private _iconsPerPage = (localNamespace getVariable ["HALs_icons_boxesX", 5]) * (localNamespace getVariable ["HALs_icons_boxesY", 5]);
			private _maxPages = ceil (_maxIcons / _iconsPerPage);

			if (_maxPages == 0) exitWith {
				localNamespace setVariable ["HALs_icons_page", 0];
				["update", []] call fn_iconViewer;
			};

			private _page = localNamespace getVariable ["HALs_icons_page", 0];
			private _amt = (_args param [0, 0, [0]]) + _page;

			if (_amt < 0) then {
				_amt = _maxPages - 1;
			} else {
				_amt = _amt % _maxPages;
			};

			localNamespace setVariable ["HALs_icons_page", _amt];
			["update", []] call fn_iconViewer;
		};

		case "update": {
			private _display = uiNamespace getVariable ["HALs_icons_idd", displayNull];
			private _ctrlGroupList = _display getVariable ["ctrlList", controlNull];
			private _ctrls = _ctrlGroupList getVariable ["ctrls", []];

			private _items = localNamespace getVariable ["HALs_icons", []];
			if (_items isEqualTo []) then {
				{_x ctrlShow false} forEach _ctrls;

				(_display getVariable ["pageInfo", controlNull]) ctrlSetStructuredText parseText format ["<t align='center'>0 | 0</t>"];
				(_display getVariable ["searchInfo", controlNull]) ctrlSetStructuredText parseText format ["<t align='right'>0 images found.</t>"];
			} else {
				private _page = localNamespace getVariable ["HALs_icons_page", 0];
				private _iconsPerPage = (localNamespace getVariable ["HALs_icons_boxesX", 5]) * (localNamespace getVariable ["HALs_icons_boxesY", 5]);
				private _maxPages = ceil (count _items / _iconsPerPage);

				private _n = count _items;
				for [{_i = 0}, {_i < _iconsPerPage}, {_i = _i + 1}] do { 
					private _ctrlBox = _ctrls select _i;

					private _idx = _page * _iconsPerPage + _i;
					if (_idx < _n) then {
						private _img = _items select _idx;
						(_ctrlBox getVariable ["ctrls", []]) params ["", "_ctrlTextTitle", "_ctrlPicture", "_ctrlButton"];

						_ctrlPicture ctrlSetText _img;
						_ctrlTextTitle ctrlSetStructuredText parseText format ["<t size='0.9' shadow='2' font='puristaMedium' align='center' >%1</t>", _img];
						_ctrlButton setVariable ["data", _img];

						_ctrlBox ctrlShow true;
					} else {
						_ctrlBox ctrlShow false;
					};
				};

				(_display getVariable ["pageInfo", controlNull]) ctrlSetStructuredText parseText format ["<t align='center'>%1 | %2</t>", _page + 1, _maxPages];
				(_display getVariable ["searchInfo", controlNull]) ctrlSetStructuredText parseText format ["<t align='right'>%1 images found.</t>", count _items];
			};
		};
	};
};
















#include <uds.sqf> //inicializar UDS

//************************************************************************************************

//verificar que las clases de infanteria definidas sean válidas.
SAC_UDS_O_G_Soldiers call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_Soldiers call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_SF_Soldiers call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_AA_Soldiers call SAC_fnc_verifyArrayOfClasses;

[[SAC_UDS_O_HeliPilot]] call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_TankCrews call SAC_fnc_verifyArrayOfClasses;


SAC_UDS_C_Men call SAC_fnc_verifyArrayOfClasses;


SAC_UDS_B_G_Soldiers call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_Soldiers call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_SF_Soldiers call SAC_fnc_verifyArrayOfClasses;

[[SAC_UDS_B_HeliPilot]] call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_TankCrews call SAC_fnc_verifyArrayOfClasses;


//verificar que las clases de vehículos definidas sean válidos.

SAC_UDS_O_G_garrisonVeh call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_garrisonVeh call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_patrolVeh call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_ambushVeh call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_trafficArmed call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_trafficUnarmed call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_insurgencyTraffic call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_unarmedTransport call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_unarmedTransport call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_armedTransport call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_armedTransport call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_APC call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_APC call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_IFV call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_IFV call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_Tanks call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_Tanks call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_transportHelicopter call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_transportHelicopter call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_G_attackHelicopter call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_O_AAVehicles call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_C_garrisonVeh call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_C_trafficVeh call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_C_VIPVeh call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_G_garrisonVeh call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_garrisonVeh call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_G_unarmedTransport call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_unarmedTransport call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_G_armedTransport call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_armedTransport call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_G_APC call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_APC call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_G_IFV call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_IFV call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_G_Tanks call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_Tanks call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_G_transportHelicopter call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_transportHelicopter call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_G_attackHelicopter call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_attackHelicopter call SAC_fnc_verifyArrayOfClasses;

SAC_UDS_B_bigUAVs call SAC_fnc_verifyArrayOfClasses;

//****************************************************************************************




if (isClass(configFile >> "CfgVehicles" >> SAC_UDS_O_Soldiers select 0)) then {

	SAC_O_REGULAR_SIDE = [SAC_UDS_O_Soldiers select 0] call SAC_fnc_getSideFromCfg;
	
};

if (isClass(configFile >> "CfgVehicles" >> SAC_UDS_O_G_Soldiers select 0)) then {

	SAC_O_MILITIA_SIDE = [SAC_UDS_O_G_Soldiers select 0] call SAC_fnc_getSideFromCfg;
	
};

if (isNil "SAC_O_REGULAR_SIDE" || {!(SAC_O_REGULAR_SIDE in [west, east, resistance])}) then {

	"Error: SAC_FNC - No se pudo identificar 'SAC_O_REGULAR_SIDE'" call SAC_fnc_MPhintC;

};

if (isNil "SAC_O_MILITIA_SIDE" || {!(SAC_O_MILITIA_SIDE in [west, east, resistance])}) then {

	"Error: SAC_FNC - No se pudo identificar 'SAC_O_MILITIA_SIDE'" call SAC_fnc_MPhintC;

};

//en este punto, si player es null, este código está corriendo en el servidor dedicado
if (!isNull player) then {

	SAC_PLAYER_SIDE = [typeOf player] call SAC_fnc_getSideFromCfg;

} else {

	SAC_PLAYER_SIDE = [typeOf (playableUnits select 0)] call SAC_fnc_getSideFromCfg;

};

if !(SAC_PLAYER_SIDE in [west, east, resistance]) then {

	"Error: SAC_FNC - No se pudo identificar 'SAC_PLAYER_SIDE'" call SAC_fnc_MPhintC;
	
};

//Verificar que los bandos de las unidades OPFOR sean enemigos del bando del jugador.
if ([SAC_PLAYER_SIDE, SAC_O_REGULAR_SIDE] call BIS_fnc_sideIsFriendly) then {

	format ["Error: SAC_FNC - SAC_O_REGULAR_SIDE (%1) es amigo de SAC_PLAYER_SIDE (%2).", SAC_O_REGULAR_SIDE, SAC_PLAYER_SIDE] call SAC_fnc_MPhintC;
	
};

if ([SAC_PLAYER_SIDE, SAC_O_MILITIA_SIDE] call BIS_fnc_sideIsFriendly) then {

	format ["Error: SAC_FNC - SAC_O_MILITIA_SIDE (%1) es amigo de SAC_PLAYER_SIDE (%2).", SAC_O_MILITIA_SIDE, SAC_PLAYER_SIDE] call SAC_fnc_MPhintC;
	
};

switch (SAC_PLAYER_SIDE) do {

	case west: {
	
		SAC_markers_color_pool = ["ColorWEST", "ColorGUER", "ColorYellow", "ColorOrange", "colorCivilian", "ColorBlack"];
	
	};

	case east: {
	
		SAC_markers_color_pool = ["ColorEAST", "ColorGUER", "ColorYellow", "ColorOrange", "colorCivilian", "ColorBlack"];
	
	};
	
	case resistance: {
	
		SAC_markers_color_pool = ["ColorGUER", "ColorYellow", "ColorOrange", "colorCivilian", "ColorBlack"];
	
	};
	
	default {
	
		SAC_markers_color_pool = ["ColorYellow", "ColorOrange", "colorCivilian", "ColorBlack"];
	
	};
	
};

SAC_trackerColor = "";

SAC_initialViewDistance = viewDistance;
SAC_initialObjectViewDistance = getObjectviewDistance select 0;

//[] call SAC_fnc_initializeMasterBuildingArray;

//esto es porque los civiles si tienen armas son hostiles a lo que diga el seteo del
//bando independiente/resistance
civilian setFriend [SAC_PLAYER_SIDE, 1];

SAC_FNC = true;

//hiddenSelectionsTextures[] = {"A3\Air_F\Heli_Light_02\Data\Heli_Light_02_ext_CO.paa"};
