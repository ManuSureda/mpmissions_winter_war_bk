//***************************************************************************************************
//Inicializar UDS
//***************************************************************************************************

//*********************************
//Infanteria
//*********************************

if (isNil "SAC_GEAR_B_loadoutProfile") then {SAC_GEAR_B_loadoutProfile = "NONE"};
if (isNil "SAC_GEAR_B_G_loadoutProfile") then {SAC_GEAR_B_G_loadoutProfile = "NONE"};
if (isNil "SAC_GEAR_B_SF_loadoutProfile") then {SAC_GEAR_B_SF_loadoutProfile = "NONE"};
if (isNil "SAC_GEAR_O_loadoutProfile") then {SAC_GEAR_O_loadoutProfile = "NONE"};
if (isNil "SAC_GEAR_O_SF_loadoutProfile") then {SAC_GEAR_O_SF_loadoutProfile = "NONE"};
if (isNil "SAC_GEAR_O_G_loadoutProfile") then {SAC_GEAR_O_G_loadoutProfile = "NONE"};

//Ahora se definen las clases bases para cada requerimiento de funcionalidad. A estas clases se les aplican
//los perfiles definidos arriba (o se la deja como viene si el perfil correspondiente se define como "NONE").

if (isNil "SAC_UDS_unitsProfile") then {SAC_UDS_unitsProfile = "BIS_ALTIS"};

switch (SAC_UDS_unitsProfile) do {

	case "BIS_ALTIS": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = SAC_bis_o_guerilla_soldiers;
		SAC_UDS_O_G_AA_Soldiers = SAC_bis_o_guerilla_aa_soldiers;

		SAC_UDS_O_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = SAC_bis_altis_civilian_men;

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "BIS_TANOA": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = SAC_bis_syndikat_paramilitary_soldiers;
		SAC_UDS_O_G_AA_Soldiers = SAC_bis_o_guerilla_aa_soldiers;

		SAC_UDS_O_Soldiers = SAC_bis_csat_pacific_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_pacific_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_pacific_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_pacific_tank_crew];

		//civiles
		SAC_UDS_C_Men = SAC_bis_tanoan_civilian_men;

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "FGN_INS": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = ["FGN_CauR_Rifleman1", "FGN_CauR_Rifleman2", "FGN_CauR_Rifleman3", "FGN_CauR_Rifleman4", "FGN_CauR_RiflemanGP",
		"FGN_CauR_RiflemanAT", "FGN_CauR_RPGGren", "FGN_CauR_Sapper", "FGN_CauR_TeamLeader", "FGN_CauR_MGunner", "FGN_CauR_GroupLeader",
		"FGN_CauR_Medic", "FGN_CauR_AssRPGGren", "FGN_CauR_AssMGunner"];
		SAC_UDS_O_G_AA_Soldiers = ["FGN_CauR_AAGunner"];

		SAC_UDS_O_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		if (SAC_RDS) then {

			SAC_UDS_C_Men = ["RDS_PL_Citizen_Random","RDS_PL_Profiteer_Random","RDS_PL_Villager_Random","RDS_PL_Woodlander_Random","RDS_PL_Worker_Random"];

		} else {

			if (SAC_3CBF) then {

				SAC_UDS_C_Men = ["UK3CB_CHC_C_ACT","UK3CB_CHC_C_CIT","UK3CB_CHC_C_COACH","UK3CB_CHC_C_HIKER","UK3CB_CHC_C_LABOUR","UK3CB_CHC_C_PROF",
				"UK3CB_CHC_C_VILL","UK3CB_CHC_C_CAN","UK3CB_CHC_C_WOOD","UK3CB_CHC_C_WORKER"];

			};

		};

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "CUP_TK_M": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"CUP_O_TK_INS_Soldier_TL",
			"CUP_O_TK_INS_Soldier_MG",
			"CUP_O_TK_INS_Soldier_GL",
			"CUP_O_TK_INS_Soldier_AT",
			"CUP_O_TK_INS_Soldier",
			"CUP_O_TK_INS_Soldier_MG",
			"CUP_O_TK_INS_Soldier_AR",
			"CUP_O_TK_INS_Sniper",
			"CUP_O_TK_INS_Soldier_Enfield",
			"CUP_O_TK_INS_Soldier_FNFAL"
		];

		SAC_UDS_O_G_AA_Soldiers = ["CUP_O_TK_INS_Soldier_AA"];

		SAC_UDS_O_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = SAC_bis_altis_civilian_men;

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "CUP_SLA_P": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"CUP_O_Partisans_soldier_SL",
			"CUP_O_Partisans_Soldier_MG",
			"CUP_O_Partisans_Soldier_AT",
			"CUP_O_Partisans_soldier_TTsKO",
			"CUP_O_Partisans_Soldier_MG",
			"CUP_O_Partisans_Soldier_AT",
			"CUP_O_Partisans_Medic",
			"CUP_O_Partisans_soldier_TTsKO",
			"CUP_O_Partisans_Engineer"
		];

		SAC_UDS_O_G_AA_Soldiers = ["CUP_O_sla_Soldier_AA"];

		SAC_UDS_O_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = SAC_bis_altis_civilian_men;

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "BIS_MALDEN": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = SAC_bis_syndikat_paramilitary_soldiers;
		SAC_UDS_O_G_AA_Soldiers = SAC_bis_o_guerilla_aa_soldiers;

		SAC_UDS_O_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = SAC_bis_altis_civilian_men;

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "BIS_AFRICA": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = SAC_bis_syndikat_paramilitary_soldiers;
		SAC_UDS_O_G_AA_Soldiers = SAC_bis_o_guerilla_aa_soldiers;

		SAC_UDS_O_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = SAC_bis_afro_civilian_men;

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "3CB_TAKISTAN": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = ["UK3CB_TKM_O_AT", "UK3CB_TKM_O_AR", "UK3CB_TKM_O_DEM", "UK3CB_TKM_O_ENG",
		"UK3CB_TKM_O_GL", "UK3CB_TKM_O_LAT", "UK3CB_TKM_O_MG", "UK3CB_TKM_O_MD", "UK3CB_TKM_O_RIF_1",
		"UK3CB_TKM_O_RIF_2", "UK3CB_TKM_O_SL", "UK3CB_TKM_O_SNI", "UK3CB_TKM_O_TL", "UK3CB_TKM_O_WAR"];
		SAC_UDS_O_G_AA_Soldiers = ["UK3CB_TKM_O_AA"];

		SAC_UDS_O_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = ["UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV",
		"UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV"];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "3CB_CHERNARUS": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = ["UK3CB_NAP_O_AT","UK3CB_NAP_O_AR","UK3CB_NAP_O_DEM","UK3CB_NAP_O_ENG","UK3CB_NAP_O_GL","UK3CB_NAP_O_LAT",
		"UK3CB_NAP_O_MG","UK3CB_NAP_O_MK","UK3CB_NAP_O_MD","UK3CB_NAP_O_OFF","UK3CB_NAP_O_RIF_1","UK3CB_NAP_O_SEN_3","UK3CB_NAP_O_TL"];
		SAC_UDS_O_G_AA_Soldiers = ["UK3CB_NAP_O_AA"];

		SAC_UDS_O_Soldiers = SAC_bis_spetsnaz_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_spetsnaz_recon;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = ["UK3CB_CHC_C_ACT","UK3CB_CHC_C_CIT","UK3CB_CHC_C_COACH","UK3CB_CHC_C_HIKER","UK3CB_CHC_C_LABOUR","UK3CB_CHC_C_PROF",
		"UK3CB_CHC_C_VILL","UK3CB_CHC_C_CAN","UK3CB_CHC_C_WOOD","UK3CB_CHC_C_WORKER"];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "3CB_AFRICA": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
		"UK3CB_ADE_O_AT",
		"UK3CB_ADE_O_AR",
		"UK3CB_ADE_O_ENG",
		"UK3CB_ADE_O_GL",
		"UK3CB_ADE_O_LAT",
		"UK3CB_ADE_O_MG",
		"UK3CB_ADE_O_MK",
		"UK3CB_ADE_O_MD",
		"UK3CB_ADE_O_RIF_1",
		"UK3CB_ADE_O_RIF_1",
		"UK3CB_ADE_O_RIF_2",
		"UK3CB_ADE_O_RIF_2",
		"UK3CB_ADE_O_SL",
		"UK3CB_ADE_O_SNI",
		"UK3CB_ADE_O_TL",
		"UK3CB_ADE_O_WAR",
		"UK3CB_ADM_O_AT",
		"UK3CB_ADM_O_AR",
		"UK3CB_ADM_O_ENG",
		"UK3CB_ADM_O_GL",
		"UK3CB_ADM_O_LAT",
		"UK3CB_ADM_O_MG",
		"UK3CB_ADM_O_MK",
		"UK3CB_ADM_O_MD",
		"UK3CB_ADM_O_RIF_1",
		"UK3CB_ADM_O_RIF_1",
		"UK3CB_ADM_O_RIF_2",
		"UK3CB_ADM_O_RIF_2",
		"UK3CB_ADM_O_SL",
		"UK3CB_ADM_O_SNI",
		"UK3CB_ADM_O_TL"
		];
		SAC_UDS_O_G_AA_Soldiers = ["UK3CB_ADM_O_AA","UK3CB_ADE_O_AA"];

		SAC_UDS_O_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = [
		"UK3CB_ADC_C_CIV_CHR_01",
		"UK3CB_ADC_C_CIV_CHR_02",
		"UK3CB_ADC_C_CIV_ISL_01",
		"UK3CB_ADC_C_HUNTER_CHR",
		"UK3CB_ADC_C_CIT",
		"UK3CB_ADC_C_COACH",
		"UK3CB_ADC_C_PROF",
		"UK3CB_ADC_C_VILL",
		"UK3CB_ADC_C_WOOD",
		"UK3CB_ADC_C_LABOURER_CHR",
		"UK3CB_ADC_C_LABOURER_ISL",
		"UK3CB_ADC_C_WORKER"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "rus_chechenia_cold": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"rhs_vdv_mflora_sergeant",
			"rhs_vdv_mflora_machinegunner",
			"rhs_vdv_mflora_machinegunner_assistant",
			"rhs_vdv_mflora_at",
			"rhs_vdv_mflora_strelok_rpg_assist",
			"rhs_vdv_mflora_efreitor",
			"rhs_vdv_mflora_arifleman_rpk",
			"rhs_vdv_mflora_rifleman",
			"rhs_vdv_mflora_rifleman_lite",
			"rhs_vdv_mflora_LAT",
			"rhs_vdv_mflora_RShG2",
			"rhs_vdv_mflora_engineer",
			"rhs_vdv_mflora_medic",
			"rhs_vdv_mflora_marksman"
		];
		SAC_UDS_O_G_AA_Soldiers = ["rhs_vdv_mflora_at"];

		SAC_UDS_O_Soldiers = [
			"rhs_vdv_mflora_sergeant",
			"rhs_vdv_mflora_machinegunner",
			"rhs_vdv_mflora_machinegunner_assistant",
			"rhs_vdv_mflora_at",
			"rhs_vdv_mflora_strelok_rpg_assist",
			"rhs_vdv_mflora_efreitor",
			"rhs_vdv_mflora_arifleman_rpk",
			"rhs_vdv_mflora_rifleman",
			"rhs_vdv_mflora_rifleman_lite",
			"rhs_vdv_mflora_LAT",
			"rhs_vdv_mflora_RShG2",
			"rhs_vdv_mflora_engineer",
			"rhs_vdv_mflora_medic",
			"rhs_vdv_mflora_marksman"
		];
		SAC_UDS_O_SF_Soldiers = ["rhs_vdv_mflora_rifleman"];

		SAC_UDS_O_G_HeliPilot = "rhs_pilot_transport_heli";
		SAC_UDS_O_G_TankCrews = [
			"rhs_vdv_flora_crew",
			"rhs_vdv_flora_combatcrew",
			"rhs_vdv_flora_driver",
			"rhs_vdv_flora_crew_commander"
		];

		SAC_UDS_O_HeliPilot = "rhs_pilot_transport_heli";
		SAC_UDS_O_TankCrews = [
			"rhs_vdv_flora_crew",
			"rhs_vdv_flora_combatcrew",
			"rhs_vdv_flora_driver",
			"rhs_vdv_flora_crew_commander"
		];

		//civiles
		SAC_UDS_C_Men = [
			"UK3CB_CHC_C_ACT",
			"UK3CB_CHC_C_CIT",
			"UK3CB_CHC_C_COACH",
			"UK3CB_CHC_C_HIKER",
			"UK3CB_CHC_C_LABOUR",
			"UK3CB_CHC_C_CIV",
			"UK3CB_CHC_C_VILL",
			"UK3CB_CHC_C_WOOD",
			"UK3CB_CHC_C_WORKER"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [];

		SAC_UDS_B_Soldiers = [];
		SAC_UDS_B_SF_Soldiers = [];
		SAC_UDS_B_Officers = [];

		SAC_UDS_B_HeliPilot = "O_support_AMG_F";
		SAC_UDS_B_TankCrews = ["O_support_AMG_F"];


	};

	case "syrian_army_altis_uds": {
		// es el ejercito sirio pero en un caso de fantasia, en altis, asi q los civiles son griegos y los sirios tienen ropa del LDF

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"LOP_SYR_Infantry_TL",
			"LOP_SYR_Infantry_SL",
			"LOP_SYR_Infantry_Rifleman",
			"LOP_SYR_Infantry_Rifleman_2",
			"LOP_TKA_Infantry_Rifleman_3",
			"LOP_SYR_Infantry_Marksman",
			"LOP_SYR_Infantry_MG",
			"LOP_TKA_Infantry_MG",
			"LOP_SYR_Infantry_MG_Asst",
			"LOP_SYR_Infantry_Grenadier",
			"LOP_SYR_Infantry_Engineer",
			"LOP_SYR_Infantry_Corpsman",
			"LOP_SYR_Infantry_AT",
			"LOP_SYR_Infantry_AT_Asst",
			"LOP_TKA_Infantry_AA"
		]; // LOP_TKA_Infantry_MG = fusilero automatico 
		// LOP_TKA_Infantry_Rifleman_3 = LAT
		SAC_UDS_O_G_AA_Soldiers = ["LOP_TKA_Infantry_AA"];

		SAC_UDS_O_Soldiers = [
			"Zombie_G_RC_LDF",
			"Zombie_G_RC_LDF",
			"Zombie_G_RC_FIA",
			"Zombie_G_RC_FIA",
			"Zombie_G_RC_Civ",
			"Zombie_G_RC_Civ"
		];
		SAC_UDS_O_SF_Soldiers = SAC_UDS_O_Soldiers;

		SAC_UDS_O_G_HeliPilot = "LOP_SYR_Infantry_Pilot";
		SAC_UDS_O_G_TankCrews = ["LOP_SYR_Infantry_Crewman"];

		SAC_UDS_O_HeliPilot = "Zombie_G_RC_LDF";
		SAC_UDS_O_TankCrews = ["Zombie_G_RC_LDF"];

		//civiles
		SAC_UDS_C_Men = ["C_man_1", "C_Man_casual_1_F", "C_Man_casual_2_F", "C_Man_casual_3_F", "C_man_sport_1_F", "C_man_sport_2_F", "C_man_sport_3_F", "C_Man_formal_1_F", "C_Man_casual_4_v2_F", "C_Man_casual_5_v2_F", "C_Man_casual_7_F", "C_Man_UtilityWorker_01_F", "C_Man_Messenger_01_F", "C_Man_ConstructionWorker_01_Blue_F", "C_Man_ConstructionWorker_01_Red_F", "C_Man_ConstructionWorker_01_Vrana_F", "C_Man_Paramedic_01_F", "C_Man_Fisherman_01_F"];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [
			"B_G_Soldier_SL_F",
			"B_G_Soldier_TL_F",
			"B_G_medic_F",
			"B_G_Soldier_M_F",
			"B_G_Soldier_AR_F",
			"B_G_Soldier_A_F",
			"B_G_Soldier_F",
			"B_G_Soldier_lite_F",
			"B_G_Soldier_LAT_F",
			"B_G_Soldier_LAT2_F"
		];

		SAC_UDS_B_Soldiers = SAC_UDS_B_G_Soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_UDS_B_G_Soldiers;
		SAC_UDS_B_Officers = ["B_G_officer_F"];

		SAC_UDS_B_HeliPilot = "B_G_Soldier_lite_F";
		SAC_UDS_B_TankCrews = ["B_G_Soldier_lite_F"];

	};

	case "korea_50_summer": {
		
		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"O_soldier_M_F",
			"O_Soldier_A_F",
			"O_soldier_UAV_F",
			"O_officer_F",
			"O_medic_F",
			"O_Soldier_SL_F",
			"O_Soldier_TL_F",
			"O_engineer_F",
			"O_Soldier_GL_F",
			"O_Soldier_AR_F",
			"O_Soldier_lite_F",
			"O_Soldier_lite_F",
			"O_Soldier_lite_F",
			"O_Soldier_unarmed_F",
			"O_Soldier_unarmed_F",
			"O_Soldier_unarmed_F",
			"O_Soldier_F",
			"O_Soldier_F",
			"O_Soldier_F",
			"O_Soldier_LAT_F",
			"O_Soldier_HAT_F",
			"O_HeavyGunner_F"
		]; 
		SAC_UDS_O_G_AA_Soldiers = ["O_Soldier_F"];

		SAC_UDS_O_Soldiers = SAC_UDS_O_G_Soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_UDS_O_G_Soldiers;

		SAC_UDS_O_G_HeliPilot = "O_Helicrew_F"; 
		SAC_UDS_O_G_TankCrews = ["O_crew_F"];

		SAC_UDS_O_HeliPilot = "O_Helicrew_F";
		SAC_UDS_O_TankCrews = ["O_crew_F"];

		//civiles
		SAC_UDS_C_Men = ["EAW_Civ_1","EAW_Civ_1_Brown","EAW_Civ_1_Grey","EAW_Civ_1_Tan","EAW_Civ_1_White","EAW_Civ_Robe_Blue","EAW_Civ_Robe_Grey","EAW_Civ_Robe_BlueGrey","EAW_Femoid_ChineseDress_White"];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = ["B_G_Soldier_F"];

		SAC_UDS_B_Soldiers = SAC_UDS_B_G_Soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_UDS_B_G_Soldiers;
		SAC_UDS_B_Officers = ["B_G_Soldier_F"];

		SAC_UDS_B_HeliPilot = "B_G_Soldier_F";
		SAC_UDS_B_TankCrews = ["B_G_Soldier_F"];

	};

	case "china_50_winter": {
		
		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"O_G_officer_F",
			"O_G_Soldier_SL_F","O_G_Soldier_SL_F",
			"O_G_Soldier_TL_F","O_G_Soldier_TL_F","O_G_Soldier_TL_F",
			"O_G_medic_F","O_G_medic_F","O_G_medic_F",
			"O_G_engineer_F",
			"O_G_Soldier_F","O_G_Soldier_F","O_G_Soldier_F",
			"O_G_Soldier_F","O_G_Soldier_F","O_G_Soldier_F",
			"O_G_Soldier_lite_F",
			"O_G_Soldier_AR_F","O_G_Soldier_AR_F","O_G_Soldier_AR_F",
			"O_G_Survivor_F",
			"O_G_Soldier_A_F","O_G_Soldier_A_F",
			"O_G_Sharpshooter_F",
			"O_G_Soldier_M_F",
			"O_G_Soldier_GL_F","O_G_Soldier_GL_F",
			"O_G_Soldier_LAT_F","O_G_Soldier_LAT_F",
			"O_G_Soldier_LAT2_F",

			"O_G_Soldier_exp_F"
		]; 
		//	"O_G_Soldier_exp_F", -> mortero 
		SAC_UDS_O_G_AA_Soldiers = ["O_G_Soldier_F"];

		SAC_UDS_O_Soldiers = SAC_UDS_O_G_Soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_UDS_O_G_Soldiers;

		SAC_UDS_O_G_HeliPilot = "O_G_Soldier_unarmed_F"; 
		SAC_UDS_O_G_TankCrews = ["O_G_Soldier_unarmed_F"];

		SAC_UDS_O_HeliPilot = "O_G_Soldier_unarmed_F";
		SAC_UDS_O_TankCrews = ["O_G_Soldier_unarmed_F"];

		//civiles
		SAC_UDS_C_Men = ["EAW_Civ_1","EAW_Civ_1_Brown","EAW_Civ_1_Grey","EAW_Civ_1_Tan","EAW_Civ_1_White","EAW_Civ_Robe_Blue","EAW_Civ_Robe_Grey","EAW_Civ_Robe_BlueGrey","EAW_Femoid_ChineseDress_White"];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = ["B_G_Soldier_F"];

		SAC_UDS_B_Soldiers = SAC_UDS_B_G_Soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_UDS_B_G_Soldiers;
		SAC_UDS_B_Officers = ["B_G_Soldier_F"];

		SAC_UDS_B_HeliPilot = "B_G_Soldier_F";
		SAC_UDS_B_TankCrews = ["B_G_Soldier_F"];

	};

	case "rusia_2022_uds": {
		
		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"rhs_vdv_machinegunner",
			"rhs_vdv_machinegunner_assistant",
			"rhs_vdv_strelok_rpg_assist",
			"rhs_vdv_at",
			"rhs_vdv_efreitor",
			"rhs_vdv_aa",
			"rhs_vdv_rifleman",
			"rhs_vdv_rifleman",
			"rhs_vdv_grenadier",
			"rhs_vdv_rifleman_lite",
			"rhs_vdv_rifleman_lite",
			"rhs_vdv_LAT",
			"rhs_vdv_LAT",
			"rhs_vdv_arifleman_rpk",
			"rhs_vdv_engineer",
			"rhs_vdv_medic",
			"rhs_vdv_sergeant",
			"rhs_vdv_marksman",
			"rhs_vdv_officer"
		]; // rhs_vdv_officer = RO
		SAC_UDS_O_G_AA_Soldiers = ["rhs_vdv_aa"];

		SAC_UDS_O_Soldiers = SAC_UDS_O_G_Soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_UDS_O_G_Soldiers;

		SAC_UDS_O_G_HeliPilot = "rhs_pilot_combat_heli"; 
		SAC_UDS_O_G_TankCrews = ["rhs_vdv_crew"];

		SAC_UDS_O_HeliPilot = "rhs_pilot_combat_heli";
		SAC_UDS_O_TankCrews = ["rhs_vdv_crew"];

		//civiles
		SAC_UDS_C_Men = ["C_Man_1_enoch_F","C_Farmer_01_enoch_F","C_Man_formal_4_F_euro","C_Man_formal_3_F_euro","CUP_C_C_Assistant_01","CUP_C_C_Bully_02","CUP_C_C_Bully_01","CUP_C_C_Citizen_01","CUP_C_C_Citizen_04","CUP_C_C_Citizen_03","CUP_C_C_Priest_01","CUP_C_C_Citizen_03","CUP_C_C_Doctor_01","CUP_C_C_Fireman_01","CUP_C_C_Functionary_jacket_01","CUP_C_C_Worker_05","CUP_C_C_Mechanic_02","CUP_C_C_Profiteer_02","CUP_C_C_Villager_01","CUP_C_C_Villager_04"];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [
		];

		SAC_UDS_B_Soldiers = SAC_UDS_B_G_Soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_UDS_B_G_Soldiers;
		SAC_UDS_B_Officers = ["CUP_B_CDF_Pilot_FST"];

		SAC_UDS_B_HeliPilot = "CUP_B_CDF_Pilot_FST";
		SAC_UDS_B_TankCrews = ["CUP_B_CDF_Pilot_FST"];

	};

	case "MOG_uds": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"LOP_BH_Infantry_SL",
			"LOP_BH_Infantry_TL",
			"LOP_BH_Infantry_IED",
			"LOP_BH_Infantry_Corpsman",
			"LOP_BH_Infantry_AR",
			"LOP_BH_Infantry_AR_2",
			"LOP_BH_Infantry_AR_Asst",
			"LOP_BH_Infantry_Rifleman",
			"LOP_BH_Infantry_Rifleman_lite",
			"LOP_BH_Infantry_Driver",
			"LOP_BH_Infantry_Marksman",
			"LOP_BH_Infantry_AT",
			"LOP_AFR_OPF_Infantry_AT",
			"LOP_AFR_OPF_Infantry_Rifleman"
		];
		SAC_UDS_O_G_AA_Soldiers = ["LOP_AFR_OPF_Infantry_AT"];

		SAC_UDS_O_Soldiers = SAC_UDS_O_G_Soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_UDS_O_G_Soldiers;

		SAC_UDS_O_G_HeliPilot = "LOP_BH_Infantry_Driver";
		SAC_UDS_O_G_TankCrews = [
			"LOP_BH_Infantry_Rifleman",
			"LOP_BH_Infantry_Rifleman_lite",
			"LOP_BH_Infantry_Driver"
		];

		SAC_UDS_O_HeliPilot = SAC_UDS_O_G_HeliPilot;
		SAC_UDS_O_TankCrews = SAC_UDS_O_G_TankCrews;

		//civiles
		SAC_UDS_C_Men = [
			"LOP_AFR_Civ_Man_01",
			"LOP_AFR_Civ_Man_01_S",
			"LOP_AFR_Civ_Man_02",
			"LOP_AFR_Civ_Man_02_S",
			"LOP_AFR_Civ_Man_03",
			"LOP_AFR_Civ_Man_03_S",
			"LOP_AFR_Civ_Man_04",
			"LOP_AFR_Civ_Man_04_S",
			"LOP_AFR_Civ_Man_05",
			"LOP_AFR_Civ_Man_05_S",
			"LOP_AFR_Civ_Man_06",
			"LOP_AFR_Civ_Man_06_S"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = ["UK3CB_CW_US_B_LATE_HELI_PILOT","UK3CB_CW_US_B_LATE_HELI_CREW"];

		SAC_UDS_B_Soldiers = ["UK3CB_CW_US_B_LATE_HELI_PILOT","UK3CB_CW_US_B_LATE_HELI_CREW"];
		SAC_UDS_B_SF_Soldiers = ["UK3CB_CW_US_B_LATE_HELI_PILOT","UK3CB_CW_US_B_LATE_HELI_CREW"];
		SAC_UDS_B_Officers = ["UK3CB_CW_US_B_LATE_HELI_PILOT","UK3CB_CW_US_B_LATE_HELI_CREW"];

		SAC_UDS_B_HeliPilot = "UK3CB_CW_US_B_LATE_HELI_PILOT";
		SAC_UDS_B_TankCrews = ["UK3CB_CW_US_B_LATE_HELI_CREW"];

	};

	case "DualaSacro": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"UK3CB_ADM_O_AT",
			"UK3CB_ADM_O_MG",
			"UK3CB_ADM_O_TL",
			"UK3CB_ADM_O_MD",
			"UK3CB_ADM_O_RIF_1",
			"UK3CB_ADM_O_AR",
			"UK3CB_ADM_O_SPOT",
			"UK3CB_ADM_O_MG_ASST",
			"UK3CB_ADM_O_IED",
			"UK3CB_ADM_O_DEM",
			"UK3CB_ADM_O_AT_ASST",
			"UK3CB_ADM_O_WAR",
			"UK3CB_ADM_O_RIF_2",
			"UK3CB_ADM_O_RIF_1",
			"UK3CB_ADM_O_ENG",
			"UK3CB_ADM_O_LAT",
			"UK3CB_ADM_O_MG",
			"UK3CB_ADM_O_MG_ASST",
			"UK3CB_ADM_O_MD",
			"UK3CB_ADM_O_AT",
			"UK3CB_ADM_O_AT_ASST",
			"UK3CB_ADM_O_LAT",
			"UK3CB_ADM_O_RIF_2",
			"UK3CB_ADM_O_SPOT",
			"UK3CB_ADM_O_AR"
		];
		SAC_UDS_O_G_AA_Soldiers = ["UK3CB_ADM_O_RIF_2"];

		SAC_UDS_O_Soldiers = SAC_UDS_O_G_Soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_UDS_O_G_Soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = ["UK3CB_ADM_O_ENG"];

		//civiles
		SAC_UDS_C_Men = [
			"UK3CB_ADC_C_CIV_CHR_01",
			"UK3CB_ADC_C_CIV_CHR_02",
			"UK3CB_ADC_C_WOOD",
			"UK3CB_ADC_C_COACH",
			"UK3CB_ADC_C_HUNTER_CHR",
			"UK3CB_ADC_C_CIT",
			"UK3CB_ADC_C_DOC_CHR",
			"UK3CB_ADC_C_SPOT_CHR",
			"UK3CB_ADC_C_WORKER",
			"UK3CB_ADC_C_CIV_CHR",
			"UK3CB_ADC_C_LABOURER_CHR",
			"UK3CB_ADC_C_CIT"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "FIST_VIETNAM": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
		"VW_VC_LAR",
		"VW_VC_AR",
		"VW_VC_MEDIC",
		"VW_VC_ENG",
		"VW_VC_MRK",
		"VW_VC_RFL",
		"VW_VC_AT",
		"VW_VC_BRFL",
		"VW_VC_SL",
		"VW_VC_TL"
		];
		SAC_UDS_O_G_AA_Soldiers = ["uns_men_NVA_68_AA","uns_men_NVA_68_AA","uns_men_NVA_68_AA"];

		SAC_UDS_O_Soldiers = [
		"VW_NVA_LAR",
		"VW_NVA_AR",
		"VW_NVA_MEDIC",
		"VW_NVA_ENG",
		"VW_NVA_MRK",
		"VM_NVA_OFFICER2",
		"VW_NVA_RFL",
		"VW_NVA_AT",
		"VW_NVA_SL",
		"VW_NVA_TL"
		];
		SAC_UDS_O_SF_Soldiers = [];

		SAC_UDS_O_HeliPilot = "uns_nvaf_pilot2";
		SAC_UDS_O_TankCrews = ["uns_men_NVA_crew_driver"];

		//civiles
		SAC_UDS_C_Men = [
		"uns_civilian1",
		"uns_civilian1_b1",
		"uns_civilian2",
		"uns_civilian2_b1",
		"uns_civilian3",
		"uns_civilian3_b1",
		"uns_civilian4",
		"uns_civilian4_b1"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [];

		SAC_UDS_B_Soldiers = [
		"VW_US_AR_SAS",
		"VW_US_ENG_SAS",
		"VW_US_MRK_SAS",
		"VW_US_MEDIC_SAS",
		"VW_US_RFL_SAS",
		"VW_US_AT_SAS",
		"VW_US_GL_SAS",
		"VW_US_SL_SAS",
		"VW_US_TL_SAS"
		];
		SAC_UDS_B_SF_Soldiers = [
		"uns_men_US_6SFG_AT",
		"uns_men_US_6SFG_COM",
		"uns_men_US_6SFG_DEM",
		"uns_men_US_6SFG_ENG",
		"uns_men_US_6SFG_GL4",
		"uns_men_US_6SFG_GL3",
		"uns_men_US_6SFG_GL2",
		"uns_men_US_6SFG_HMG",
		"uns_men_US_6SFG_HMG2",
		"uns_men_US_6SFG_MRK",
		"uns_men_US_6SFG_MRK2",
		"uns_men_US_6SFG_MRK4",
		"uns_men_US_6SFG_MED",
		"uns_men_US_6SFG_SL",
		"uns_men_US_6SFG_PL",
		"uns_men_US_6SFG_RTO",
		"uns_men_US_6SFG_SAP",
		"uns_men_US_6SFG_SCT",
		"uns_men_US_6SFG_SP1",
		"uns_men_US_6SFG_SP2",
		"uns_men_US_6SFG_SP3",
		"uns_men_US_6SFG_SP4",
		"uns_men_US_6SFG_SP7",
		"uns_men_US_6SFG_SP5",
		"uns_men_US_6SFG_SP8"
		];
		SAC_UDS_B_Officers = ["VW_US_OFFICERUN_SAS"];

		SAC_UDS_B_HeliPilot = "VW_CAV_HELOPILOT_SAS";
		SAC_UDS_B_TankCrews = ["VW_US_VICCREW_SAS"];

	};

	case "OP_BITING": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
		 "LIB_GER_ober_lieutenant",
		 "LIB_GER_unequip",
		 "LIB_GER_rifleman",
		 "LIB_GER_mgunner",
		 "LIB_GER_unterofficer",
		 "LIB_GER_sapper_gefr",
		 "LIB_GER_medic",
		 "LIB_GER_gun_crew",
		 "LIB_GER_Mgunner_w",
		 "LIB_GER_Gun_crew_w",
		 "LIB_GER_Rifleman_w",
		 "LIB_GER_Rifleman3_w",
		 "LIB_GER_Rifleman_ADS_w",
		 "LIB_GER_Soldier_camo_MP40_w",
		 "LIB_GER_Scout_rifleman_w",
		 "LIB_GER_Radioman_w",
		 "LIB_GER_Medic_w",
		 "LIB_GER_Recruit_w",
		 "LIB_GER_Unterofficer_w",
		 "LIB_GER_Unequip_w",
		 "LIB_GER_Ober_lieutenant_w",
		 "LIB_GER_Scout_sniper_w",
		 "LIB_GER_Sapper_w"
		];
		SAC_UDS_O_G_AA_Soldiers = ["LIB_GER_rifleman","LIB_GER_Recruit_w"];

		SAC_UDS_O_Soldiers = [
			"LIB_GER_ober_lieutenant",
			"LIB_GER_unequip",
			"LIB_GER_rifleman",
			"LIB_GER_mgunner",
			"LIB_GER_unterofficer",
			"LIB_GER_sapper_gefr",
			"LIB_GER_medic",
			"LIB_GER_gun_crew",
			"LIB_GER_Mgunner_w",
			"LIB_GER_Gun_crew_w",
			"LIB_GER_Rifleman_w",
			"LIB_GER_Rifleman3_w",
			"LIB_GER_Rifleman_ADS_w",
			"LIB_GER_Soldier_camo_MP40_w",
			"LIB_GER_Scout_rifleman_w",
			"LIB_GER_Radioman_w",
			"LIB_GER_Medic_w",
			"LIB_GER_Recruit_w",
			"LIB_GER_Unterofficer_w",
			"LIB_GER_Unequip_w",
			"LIB_GER_Ober_lieutenant_w",
			"LIB_GER_Scout_sniper_w",
			"LIB_GER_Sapper_w"
		];
		SAC_UDS_O_SF_Soldiers = [];

		SAC_UDS_O_HeliPilot = "LIB_GER_Sapper_w";
		SAC_UDS_O_TankCrews = ["LIB_GER_tank_crew","LIB_GER_tank_unterofficer","LIB_GER_spg_unterofficer"];

		//civiles
		SAC_UDS_C_Men = [
		"C_NORTH_NOR_CIV_Civilian_1",
		"C_NORTH_NOR_CIV_Civilian_2",
		"C_NORTH_NOR_CIV_Civilian_3",
		"C_NORTH_NOR_CIV_Worker_Jacket_1",
		"C_NORTH_NOR_CIV_Worker_Jacket_2",
		"C_NORTH_NOR_CIV_Worker_Jacket_3",
		"C_NORTH_NOR_CIV_Worker_1",
		"C_NORTH_NOR_CIV_Worker_2",
		"C_NORTH_NOR_CIV_Fisherman_1",
		"C_NORTH_NOR_CIV_Fisherman_2",
		"C_NORTH_NOR_CIV_Farmer_1",
		"C_NORTH_NOR_CIV_Farmer_2",
		"C_NORTH_NOR_CIV_Farmer_3",
		"C_NORTH_NOR_CIV_Civilian_Jacket_3",
		"C_NORTH_NOR_CIV_Civilian_Jacket_2",
		"C_NORTH_NOR_CIV_Civilian_Jacket_3",
		"GELIB_FRA_CitizenFF01"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [];

		SAC_UDS_B_Soldiers = [];
		SAC_UDS_B_SF_Soldiers = [];
		SAC_UDS_B_Officers = [];

		SAC_UDS_B_HeliPilot = "O_support_AMG_F";
		SAC_UDS_B_TankCrews = ["O_support_AMG_F"];

	};

	case "wehrmacht_w_44": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"LIB_GER_Scout_lieutenant_w",
			"LIB_GER_Mgunner_w",
			"LIB_GER_Scout_mgunner_w",
			"LIB_GER_Gun_crew_w",
			"LIB_GER_Gun_unterofficer_w",
			"LIB_GER_Smgunner_w",
			"LIB_GER_Ober_rifleman_w",
			"LIB_GER_Scout_ober_rifleman_w",
			"LIB_GER_Rifleman_w",
			"LIB_GER_Rifleman3_w",
			"LIB_GER_Rifleman_ADS_w",
			"LIB_GER_Soldier_camo_MP40_w",
			"LIB_GER_Scout_rifleman_w",
			"LIB_GER_Medic_w",
			"LIB_GER_Radioman_w",
			"LIB_GER_Recruit_w",
			"LIB_GER_Unterofficer_w",
			"LIB_GER_Stggunner_w",
			"LIB_GER_LAT_Rifleman_w",
			"LIB_GER_AT_soldier_w",
			"LIB_GER_AT_grenadier_w",
			"LIB_GER_Unequip_w",
			"LIB_GER_Ober_lieutenant_w",
			"LIB_GER_Scout_sniper_2_w",
			"LIB_GER_Sapper_w",
			"LIB_GER_Sapper_gefr_w",
			"LIB_GER_stggunner",
			"LIB_GER_unterofficer",
			"LIB_GER_rifleman",
			"LIB_GER_ober_rifleman",
			"LIB_GER_mgunner",
			"LIB_GER_mgunner2",
			"LIB_GER_sapper"
		];
		SAC_UDS_O_G_AA_Soldiers = ["LIB_GER_rifleman","LIB_GER_Recruit_w"];

		SAC_UDS_O_Soldiers = [
			"LIB_GER_Scout_lieutenant_w",
			"LIB_GER_Mgunner_w",
			"LIB_GER_Scout_mgunner_w",
			"LIB_GER_Gun_crew_w",
			"LIB_GER_Gun_unterofficer_w",
			"LIB_GER_Smgunner_w",
			"LIB_GER_Ober_rifleman_w",
			"LIB_GER_Scout_ober_rifleman_w",
			"LIB_GER_Rifleman_w",
			"LIB_GER_Rifleman3_w",
			"LIB_GER_Rifleman_ADS_w",
			"LIB_GER_Soldier_camo_MP40_w",
			"LIB_GER_Scout_rifleman_w",
			"LIB_GER_Medic_w",
			"LIB_GER_Radioman_w",
			"LIB_GER_Recruit_w",
			"LIB_GER_Unterofficer_w",
			"LIB_GER_Stggunner_w",
			"LIB_GER_LAT_Rifleman_w",
			"LIB_GER_AT_soldier_w",
			"LIB_GER_AT_grenadier_w",
			"LIB_GER_Unequip_w",
			"LIB_GER_Ober_lieutenant_w",
			"LIB_GER_Scout_sniper_2_w",
			"LIB_GER_Sapper_w",
			"LIB_GER_Sapper_gefr_w",
			"LIB_GER_stggunner",
			"LIB_GER_unterofficer",
			"LIB_GER_rifleman",
			"LIB_GER_ober_rifleman",
			"LIB_GER_mgunner",
			"LIB_GER_mgunner2",
			"LIB_GER_sapper"
		];
		SAC_UDS_O_SF_Soldiers = [];

		SAC_UDS_O_HeliPilot = "LIB_GER_Sapper_w";
		SAC_UDS_O_TankCrews = ["LIB_GER_tank_crew","LIB_GER_tank_unterofficer","LIB_GER_spg_unterofficer"];

		//civiles
		SAC_UDS_C_Men = [
		"C_NORTH_NOR_CIV_Civilian_1",
		"C_NORTH_NOR_CIV_Civilian_2",
		"C_NORTH_NOR_CIV_Civilian_3",
		"C_NORTH_NOR_CIV_Worker_Jacket_1",
		"C_NORTH_NOR_CIV_Worker_Jacket_2",
		"C_NORTH_NOR_CIV_Worker_Jacket_3",
		"C_NORTH_NOR_CIV_Worker_1",
		"C_NORTH_NOR_CIV_Worker_2",
		"C_NORTH_NOR_CIV_Fisherman_1",
		"C_NORTH_NOR_CIV_Fisherman_2",
		"C_NORTH_NOR_CIV_Farmer_1",
		"C_NORTH_NOR_CIV_Farmer_2",
		"C_NORTH_NOR_CIV_Farmer_3",
		"C_NORTH_NOR_CIV_Civilian_Jacket_3",
		"C_NORTH_NOR_CIV_Civilian_Jacket_2",
		"C_NORTH_NOR_CIV_Civilian_Jacket_3",
		"GELIB_FRA_CitizenFF01"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [];

		SAC_UDS_B_Soldiers = [];
		SAC_UDS_B_SF_Soldiers = [];
		SAC_UDS_B_Officers = [];

		SAC_UDS_B_HeliPilot = "O_support_AMG_F";
		SAC_UDS_B_TankCrews = ["O_support_AMG_F"];

	};

	case "SS_44": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"LIB_GER_unterofficer",
			"LIB_GER_mgunner",
			"LIB_GER_medic",
			"LIB_GER_scout_ober_rifleman",
			"LIB_GER_ober_rifleman",
			"LIB_GER_rifleman",
			"LIB_GER_LAT_Rifleman",
			"LIB_GER_ober_grenadier",
			"LIB_GER_scout_rifleman",
			"LIB_GER_scout_lieutenant",
			"LIB_GER_scout_mgunner2",
			"LIB_GER_smgunner",
			"LIB_GER_stggunner",
			"LIB_GER_sapper",
			"LIB_GER_soldier_camo5_base",
			"LIB_GER_Soldier2",
			"LNRD_Luftwaffe_AT_grenadier",
			"LIB_GER_AT_soldier",
			"LIB_GER_radioman",
			"LIB_GER_unequip",
			"LIB_GER_scout_sniper"
		];
		SAC_UDS_O_G_AA_Soldiers = ["LIB_GER_rifleman","LIB_GER_unequip"];

		SAC_UDS_O_Soldiers = [
			"LIB_GER_unterofficer",
			"LIB_GER_mgunner",
			"LIB_GER_medic",
			"LIB_GER_scout_ober_rifleman",
			"LIB_GER_ober_rifleman",
			"LIB_GER_rifleman",
			"LIB_GER_LAT_Rifleman",
			"LIB_GER_ober_grenadier",
			"LIB_GER_scout_rifleman",
			"LIB_GER_scout_lieutenant",
			"LIB_GER_scout_mgunner2",
			"LIB_GER_smgunner",
			"LIB_GER_stggunner",
			"LIB_GER_sapper",
			"LIB_GER_soldier_camo5_base",
			"LIB_GER_Soldier2",
			"LNRD_Luftwaffe_AT_grenadier",
			"LIB_GER_AT_soldier",
			"LIB_GER_radioman",
			"LIB_GER_unequip",
			"LIB_GER_scout_sniper"
		];
		SAC_UDS_O_SF_Soldiers = [];

		SAC_UDS_O_HeliPilot = "LIB_GER_Sapper_w";
		SAC_UDS_O_TankCrews = ["LIB_GER_tank_crew","LIB_GER_tank_unterofficer","LIB_GER_spg_unterofficer"];

		//civiles
		SAC_UDS_C_Men = [
			"C_NORTH_NOR_CIV_Civilian_1",
			"C_NORTH_NOR_CIV_Civilian_2",
			"C_NORTH_NOR_CIV_Civilian_3",
			"C_NORTH_NOR_CIV_Worker_Jacket_1",
			"C_NORTH_NOR_CIV_Worker_Jacket_2",
			"C_NORTH_NOR_CIV_Worker_Jacket_3",
			"C_NORTH_NOR_CIV_Worker_1",
			"C_NORTH_NOR_CIV_Worker_2",
			"C_NORTH_NOR_CIV_Fisherman_1",
			"C_NORTH_NOR_CIV_Fisherman_2",
			"C_NORTH_NOR_CIV_Farmer_1",
			"C_NORTH_NOR_CIV_Farmer_2",
			"C_NORTH_NOR_CIV_Farmer_3",
			"C_NORTH_NOR_CIV_Civilian_Jacket_3",
			"C_NORTH_NOR_CIV_Civilian_Jacket_2",
			"C_NORTH_NOR_CIV_Civilian_Jacket_3",
			"GELIB_FRA_CitizenFF01"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [];

		SAC_UDS_B_Soldiers = [];
		SAC_UDS_B_SF_Soldiers = [];
		SAC_UDS_B_Officers = [];

		SAC_UDS_B_HeliPilot = "O_support_AMG_F";
		SAC_UDS_B_TankCrews = ["O_support_AMG_F"];

	};

	case "sov_w_39": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"O_NORTH_SOV_W_39_Autorifleman",
			"O_NORTH_SOV_W_39_Rifleman_SSGT",
			"O_NORTH_SOV_W_39_Machinegunner",
			"O_NORTH_SOV_W_39_Machinegunner_Assistant",
			"O_NORTH_SOV_W_39_Medic",
			"O_NORTH_SOV_W_39_Officer",
			"O_NORTH_SOV_W_39_Rifleman",
			"O_NORTH_SOV_W_39_Unequipped",
			"O_NORTH_SOV_W_39_Rifleman_SGT",
			"O_NORTH_SOV_W_39_Sniper",
			"O_NORTH_SOV_C_W_39_Medic",
			"O_NORTH_SOV_C_W_39_Rifleman",
			"O_NORTH_SOV_C_W_39_Unequipped",
			"O_NORTH_SOV_W_39_C_Officer_Cpt",
			"O_NORTH_SOV_N_W_39_Autorifleman",
			"O_NORTH_SOV_N_W_39_Rifleman_SSGT",
			"O_NORTH_SOV_N_W_39_Machinegunner",
			"O_NORTH_SOV_N_W_39_Machinegunner_Assistant",
			"O_NORTH_SOV_N_W_39_Medic",
			"O_NORTH_SOV_N_W_39_Officer",
			"O_NORTH_SOV_N_W_39_Rifleman",
			"O_NORTH_SOV_N_W_39_Unequipped",
			"O_NORTH_SOV_N_W_39_Rifleman_SGT",
			"O_NORTH_SOV_N_W_39_Sniper",
			"O_NORTH_SOV_N_W_39_Submachinegunner",
			"O_NORTH_SOV_W_39_Engineer"
		];
		SAC_UDS_O_G_AA_Soldiers = ["O_NORTH_SOV_W_39_Rifleman"];

		SAC_UDS_O_Soldiers = [
			"O_NORTH_SOV_V_W_39_Autorifleman",
			"O_NORTH_SOV_V_W_39_Autorifleman_Avtomat",
			"O_NORTH_SOV_V_W_39_Machinegunner",
			"O_NORTH_SOV_V_W_39_Machinegunner_Assistant",
			"O_NORTH_SOV_V_W_39_Officer_2ndLt",
			"O_NORTH_SOV_V_W_39_Officer_Lt",
			"O_NORTH_SOV_V_W_39_Rifleman",
			"O_NORTH_SOV_V_W_39_Sniper",
			"O_NORTH_SOV_V_W_39_Submachinegunner"
		];
		SAC_UDS_O_SF_Soldiers = [];

		SAC_UDS_O_G_HeliPilot = "O_NORTH_SOV_W_39_Rifleman";
		SAC_UDS_O_G_TankCrews = ["O_NORTH_SOV_T_W_39_Crewman_SSGT","O_NORTH_SOV_T_W_39_Crewman","O_NORTH_SOV_T_W_39_Officer_Cpt","O_NORTH_SOV_T_W_39_Officer"];

		SAC_UDS_O_HeliPilot = "O_NORTH_SOV_W_39_Rifleman";
		SAC_UDS_O_TankCrews = ["O_NORTH_SOV_T_W_39_Crewman_SSGT","O_NORTH_SOV_T_W_39_Crewman","O_NORTH_SOV_T_W_39_Officer_Cpt","O_NORTH_SOV_T_W_39_Officer"];

		//civiles
		SAC_UDS_C_Men = [
			"C_NORTH_NOR_CIV_Civilian_1",
			"C_NORTH_NOR_CIV_Civilian_2",
			"C_NORTH_NOR_CIV_Civilian_3",
			"C_NORTH_NOR_CIV_Worker_Jacket_1",
			"C_NORTH_NOR_CIV_Worker_Jacket_2",
			"C_NORTH_NOR_CIV_Worker_Jacket_3",
			"C_NORTH_NOR_CIV_Worker_1",
			"C_NORTH_NOR_CIV_Worker_2",
			"C_NORTH_NOR_CIV_Fisherman_1",
			"C_NORTH_NOR_CIV_Fisherman_2",
			"C_NORTH_NOR_CIV_Farmer_1",
			"C_NORTH_NOR_CIV_Farmer_2",
			"C_NORTH_NOR_CIV_Farmer_3",
			"C_NORTH_NOR_CIV_Civilian_Jacket_3",
			"C_NORTH_NOR_CIV_Civilian_Jacket_2",
			"C_NORTH_NOR_CIV_Civilian_Jacket_3",
			"GELIB_FRA_CitizenFF01"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [];

		SAC_UDS_B_Soldiers = [];
		SAC_UDS_B_SF_Soldiers = [];
		SAC_UDS_B_Officers = [];

		SAC_UDS_B_HeliPilot = "O_support_AMG_F";
		SAC_UDS_B_TankCrews = ["O_support_AMG_F"];

	};

	case "sov_41": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"O_NORTH_SOV_41_Officer_Cpt",
			"O_NORTH_SOV_41_Officer_Lt",
			"O_NORTH_SOV_41_Rifleman",
			"O_NORTH_SOV_41_Unequipped",
			"O_NORTH_SOV_41_Rifleman_1CL",
			"O_NORTH_SOV_41_Submachinegunner_SGT",
			"O_NORTH_SOV_41_Rifleman_SGT",
			"O_NORTH_SOV_41_Sniper",
			"O_NORTH_SOV_41_Rifleman_SSGT",
			"O_NORTH_SOV_41_Submachinegunner_SSGT",
			"O_NORTH_SOV_41_Medic",
			"O_NORTH_SOV_41_Machinegunner_Assistant",
			"O_NORTH_SOV_41_Machinegunner",
			"O_NORTH_SOV_41_Rifleman_CPL",
			"O_NORTH_SOV_41_Autorifleman",
			"O_NORTH_SOV_41_Autorifleman_38",
			"O_NORTH_SOV_R_41_Machinegunner",
			"O_NORTH_SOV_R_41_Machinegunner_Assistant",
			"O_NORTH_SOV_R_41_Sniper",
			"O_NORTH_SOV_R_41_Rifleman",
			"O_NORTH_SOV_41_Engineer"
		];
		SAC_UDS_O_G_AA_Soldiers = ["O_NORTH_SOV_41_Unequipped"];

		SAC_UDS_O_Soldiers = [
			"O_NORTH_SOV_B_41_Autorifleman_38",
			"O_NORTH_SOV_B_41_Autorifleman",
			"O_NORTH_SOV_B_41_Rifleman_CPL",
			"O_NORTH_SOV_B_41_Machinegunner",
			"O_NORTH_SOV_B_41_Machinegunner_Assistant",
			"O_NORTH_SOV_B_41_Medic",
			"O_NORTH_SOV_B_41_Officer_Cpt",
			"O_NORTH_SOV_B_41_Officer_Lt",
			"O_NORTH_SOV_B_41_Rifleman",
			"O_NORTH_SOV_B_41_Unequipped",
			"O_NORTH_SOV_B_41_Rifleman_1CL",
			"O_NORTH_SOV_B_41_Rifleman_SGT",
			"O_NORTH_SOV_B_41_Sniper",
			"O_NORTH_SOV_B_41_Submachinegunner_SSGT",
			"O_NORTH_SOV_B_41_Rifleman_SSGT"
		];
		SAC_UDS_O_SF_Soldiers = ["O_NORTH_SOV_B_41_Rifleman"];

		SAC_UDS_O_G_HeliPilot = "O_NORTH_SOV_R_41_Rifleman";
		SAC_UDS_O_G_TankCrews = [
			"O_NORTH_SOV_T_41_Officer_1stLt",
			"O_NORTH_SOV_T_41_Officer_Lt",
			"O_NORTH_SOV_T_41_Officer_2ndLt",
			"O_NORTH_SOV_T_41_Officer_Cpt",
			"O_NORTH_SOV_T_41_Crewman_SSGT",
			"O_NORTH_SOV_T_41_Crewman_SGT",
			"O_NORTH_SOV_T_41_Crewman",
			"O_NORTH_SOV_T_41_Crewman_1CL"
		];

		SAC_UDS_O_HeliPilot = "O_NORTH_SOV_R_41_Rifleman";
		SAC_UDS_O_TankCrews = [
			"O_NORTH_SOV_T_41_Officer_1stLt",
			"O_NORTH_SOV_T_41_Officer_Lt",
			"O_NORTH_SOV_T_41_Officer_2ndLt",
			"O_NORTH_SOV_T_41_Officer_Cpt",
			"O_NORTH_SOV_T_41_Crewman_SSGT",
			"O_NORTH_SOV_T_41_Crewman_SGT",
			"O_NORTH_SOV_T_41_Crewman",
			"O_NORTH_SOV_T_41_Crewman_1CL"
		];

		//civiles
		SAC_UDS_C_Men = [
			"C_NORTH_NOR_CIV_Civilian_1",
			"C_NORTH_NOR_CIV_Civilian_2",
			"C_NORTH_NOR_CIV_Civilian_3"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [];

		SAC_UDS_B_Soldiers = [];
		SAC_UDS_B_SF_Soldiers = [];
		SAC_UDS_B_Officers = [];

		SAC_UDS_B_HeliPilot = "O_support_AMG_F";
		SAC_UDS_B_TankCrews = ["O_support_AMG_F"];

	};

	case "wehrmacht_44": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
			"LIB_GER_lieutenant",
			"LIB_GER_mgunner2",
			"LIB_GER_mgunner",
			"LIB_GER_gun_crew",
			"LIB_GER_gun_unterofficer",
			"LIB_GER_ober_rifleman",
			"LIB_GER_Soldier3",
			"LIB_GER_Soldier2",
			"LIB_GER_rifleman",
			"LIB_GER_medic",
			"LIB_GER_unterofficer",
			"LIB_GER_stggunner",
			"LIB_GER_LAT_Rifleman",
			"LIB_GER_AT_soldier",
			"LIB_GER_AT_grenadier",
			"LIB_GER_unequip",
			"LIB_GER_sapper",
			"LIB_GER_sapper_gefr",
			"fow_s_ger_heer_rifleman",
			"fow_s_ger_heer_radio_operator",
			"fow_s_ger_heer_medic",
			"fow_s_ger_heer_tl_asst",
			"fow_s_ger_heer_mg42_asst",
			"fow_s_ger_heer_mg42_sparebarrel"
		];
		SAC_UDS_O_G_AA_Soldiers = ["LIB_GER_rifleman"];

		SAC_UDS_O_Soldiers = [
			"fow_s_ger_luft_camo_tl_stg",
			"fow_s_ger_luft_camo_tl_mp40",
			"fow_s_ger_luft_camo_rifleman_g43",
			"fow_s_ger_luft_camo_rifleman",
			"fow_s_ger_luft_camo_radio_operator",
			"fow_s_ger_luft_camo_nco_mp40",
			"fow_s_ger_luft_camo_medic",
			"fow_s_ger_luft_camo_mg34_gunner",
			"fow_s_ger_luft_camo_mg42_gunner",
			"fow_s_ger_luft_camo_mg42_sparebarrel",
			"fow_s_ger_luft_camo_mg42_asst",
			"LIB_FSJ_Soldier_2",
			"LIB_FSJ_AT_soldier",
			"LIB_FSJ_LAT_Soldier",
			"LIB_FSJ_AT_grenadier",
			"LIB_FSJ_sapper",
			"LIB_FSJ_sapper_gefr"
		];
		SAC_UDS_O_SF_Soldiers = ["fow_s_ger_luft_camo_rifleman"];

		SAC_UDS_O_G_HeliPilot = "fow_s_ger_luft_camo_rifleman";
		SAC_UDS_O_G_TankCrews = [
			"LIB_GER_spg_lieutenant",
			"LIB_GER_tank_lieutenant",
			"LIB_GER_spg_crew",
			"LIB_GER_spg_unterofficer",
			"LIB_GER_tank_crew",
			"LIB_GER_tank_unterofficer"
		];

		SAC_UDS_O_HeliPilot = "O_NORTH_SOV_R_41_Rifleman";
		SAC_UDS_O_TankCrews = [
			"LIB_GER_spg_lieutenant",
			"LIB_GER_tank_lieutenant",
			"LIB_GER_spg_crew",
			"LIB_GER_spg_unterofficer",
			"LIB_GER_tank_crew",
			"LIB_GER_tank_unterofficer"
		];

		//civiles
		SAC_UDS_C_Men = [
			"C_NORTH_NOR_CIV_Civilian_1",
			"C_NORTH_NOR_CIV_Civilian_2",
			"C_NORTH_NOR_CIV_Civilian_3"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [];

		SAC_UDS_B_Soldiers = [];
		SAC_UDS_B_SF_Soldiers = [];
		SAC_UDS_B_Officers = [];

		SAC_UDS_B_HeliPilot = "O_support_AMG_F";
		SAC_UDS_B_TankCrews = ["O_support_AMG_F"];

	};

	case "El_Alamein": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
		"LIB_DAK_Soldier"
		];
		SAC_UDS_O_G_AA_Soldiers = [];

		SAC_UDS_O_Soldiers = [
		"LIB_DAK_AT_grenadier",
		"LIB_DAK_Soldier",
		"LIB_DAK_Sentry",
		"LIB_DAK_Sentry_2",
		"LIB_DAK_Soldier_2",
		"LIB_DAK_grenadier",
		"LIB_DAK_medic",
		"LIB_DAK_radioman",
		"LIB_DAK_NCO_2",
		"LIB_DAK_NCO",
		"LIB_DAK_AT_soldier",
		"LIB_DAK_Sniper",
		"LIB_DAK_sapper",
		"LIB_DAK_sapper_gefr"
		];
		SAC_UDS_O_SF_Soldiers = [];

		SAC_UDS_O_HeliPilot = "O_helipilot_F";
		SAC_UDS_O_TankCrews = [
		"LIB_GER_Aufklr_CrewUnteroffizier_HeerPzrLhr0tv0tpbcFwMp40",
		"LIB_GER_Aufklr_CrewPrivate_HeerPzrLhr0tv0tpbcGefrMp40",
		"LIB_GER_Aufklr_CrewPrivate_HeerPzrLhr0tv0tpbcGefr6yMp40",
		"LIB_GER_Aufklr_CrewOffizier_HeerPzrLhr0tv0tpbcHptmMp40",
		"LIB_GER_Aufklr_CrewOffizier_HeerPzrLhr0tv0tpbcLtMp40",
		"LIB_GER_Aufklr_CrewUnteroffizier_HeerPzrLhr0tv0tpbcOfwMp40",
		"LIB_GER_Aufklr_CrewPrivate_HeerPzrLhr0tv0tpbcOgefrMp40",
		"LIB_GER_Aufklr_CrewPrivate_HeerPzrLhr0tv0tpbcOschMp40",
		"LIB_GER_Aufklr_CrewPrivate_HeerPzrLhr0tv0tpbcSchMp40",
		"LIB_GER_Aufklr_CrewUnteroffizier_HeerPzrLhr0tv0tpbcStfwMp40",
		"LIB_GER_Aufklr_CrewUnteroffizier_HeerPzrLhr0tv0tpbcUfwMp40",
		"LIB_GER_Aufklr_CrewUnteroffizier_HeerPzrLhr0tv0tpbcUffzMp40"
		];

		//civiles
		SAC_UDS_C_Men = [
		"C_NORTH_NOR_CIV_Civilian_1",
		"C_NORTH_NOR_CIV_Civilian_2",
		"C_NORTH_NOR_CIV_Civilian_3",
		"C_NORTH_NOR_CIV_Worker_Jacket_1",
		"C_NORTH_NOR_CIV_Worker_Jacket_2",
		"C_NORTH_NOR_CIV_Worker_Jacket_3",
		"C_NORTH_NOR_CIV_Worker_1",
		"C_NORTH_NOR_CIV_Worker_2",
		"C_NORTH_NOR_CIV_Fisherman_1",
		"C_NORTH_NOR_CIV_Fisherman_2",
		"C_NORTH_NOR_CIV_Farmer_1",
		"C_NORTH_NOR_CIV_Farmer_2",
		"C_NORTH_NOR_CIV_Farmer_3",
		"C_NORTH_NOR_CIV_Civilian_Jacket_3",
		"C_NORTH_NOR_CIV_Civilian_Jacket_2",
		"C_NORTH_NOR_CIV_Civilian_Jacket_3",
		"GELIB_FRA_CitizenFF01"
		];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = [];

		SAC_UDS_B_Soldiers = [
		"LIB_UK_DR_LanceCorporal",
		"LIB_UK_DR_Corporal",
		"LIB_UK_DR_Rifleman",
		"LIB_UK_DR_Grenadier",
		"LIB_UK_DR_Engineer",
		"LIB_UK_DR_Medic",
		"LIB_UK_DR_Officer",
		"LIB_UK_DR_Radioman",
		"LIB_UK_DR_Sergeant",
		"LIB_UK_DR_AT_Soldier",
		"LIB_UK_DR_Sniper"
		];
		SAC_UDS_B_SF_Soldiers = [];
		SAC_UDS_B_Officers = ["LIB_UK_DR_Officer"];

		SAC_UDS_B_HeliPilot = "LIB_US_Pilot";
		SAC_UDS_B_TankCrews = ["LIB_UK_DR_Tank_Crew"];

	};

	case "FIST_Monkey_Man": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = SAC_bis_syndikat_paramilitary_soldiers;
		SAC_UDS_O_G_AA_Soldiers = ["rhsgref_ins_g_specialist_aa", "rhsgref_ins_g_specialist_aa", "rhsgref_ins_g_specialist_aa"];

		SAC_UDS_O_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_nato_tank_crew];

		//civiles
		SAC_UDS_C_Men = SAC_bis_altis_civilian_men;

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_o_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_B_Officers = ["O_Soldier_SL_F"];

		SAC_UDS_B_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_csat_tank_crew];

	};

	case "FIST_Government_Struggle": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
		"rhsgref_ins_g_squadleader",
		"rhsgref_ins_g_machinegunner",
		"rhsgref_ins_g_grenadier",
		"rhsgref_ins_g_grenadier_rpg",
		"rhsgref_ins_g_rifleman_RPG26",
		"rhsgref_ins_g_machinegunner",
		"rhsgref_ins_g_rifleman",
		"rhsgref_ins_g_rifleman_aks74"
		];

		SAC_UDS_O_G_AA_Soldiers = ["rhsgref_ins_g_specialist_aa", "rhsgref_ins_g_specialist_aa", "rhsgref_ins_g_specialist_aa"];

		SAC_UDS_O_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = ["UK3CB_CHC_C_ACT","UK3CB_CHC_C_CIT","UK3CB_CHC_C_COACH","UK3CB_CHC_C_HIKER","UK3CB_CHC_C_LABOUR","UK3CB_CHC_C_PROF",
		"UK3CB_CHC_C_VILL","UK3CB_CHC_C_CAN","UK3CB_CHC_C_WOOD","UK3CB_CHC_C_WORKER"];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "FIST_Government_Struggle_CSAT_side": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
		"rhsgref_ins_g_squadleader",
		"rhsgref_ins_g_machinegunner",
		"rhsgref_ins_g_grenadier",
		"rhsgref_ins_g_grenadier_rpg",
		"rhsgref_ins_g_rifleman_RPG26",
		"rhsgref_ins_g_machinegunner",
		"rhsgref_ins_g_rifleman",
		"rhsgref_ins_g_rifleman_aks74"
		];

		SAC_UDS_O_G_AA_Soldiers = ["rhsgref_ins_g_specialist_aa", "rhsgref_ins_g_specialist_aa", "rhsgref_ins_g_specialist_aa"];

		SAC_UDS_B_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_B_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = ["UK3CB_CHC_C_ACT","UK3CB_CHC_C_CIT","UK3CB_CHC_C_COACH","UK3CB_CHC_C_HIKER","UK3CB_CHC_C_LABOUR","UK3CB_CHC_C_PROF",
		"UK3CB_CHC_C_VILL","UK3CB_CHC_C_CAN","UK3CB_CHC_C_WOOD","UK3CB_CHC_C_WORKER"];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_o_guerilla_soldiers;

		SAC_UDS_O_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = ["O_Soldier_SL_F"];

		SAC_UDS_O_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "FIST_Night_Terrors": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
		"UK3CB_TKM_O_AT",
		"UK3CB_TKM_O_AR",
		"UK3CB_TKM_O_DEM",
		"UK3CB_TKM_O_ENG",
		"UK3CB_TKM_O_GL",
		"UK3CB_TKM_O_LAT",
		"UK3CB_TKM_O_MG",
		"UK3CB_TKM_O_MD",
		"UK3CB_TKM_O_RIF_1",
		"UK3CB_TKM_O_RIF_2",
		"UK3CB_TKM_O_SL",
		"UK3CB_TKM_O_SNI",
		"UK3CB_TKM_O_TL",
		"UK3CB_TKM_O_WAR"
		];

		SAC_UDS_O_G_AA_Soldiers = ["UK3CB_TKM_O_AA", "UK3CB_TKM_O_AA", "UK3CB_TKM_O_AA"];

		SAC_UDS_O_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_csat_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_csat_tank_crew];

		//civiles
		SAC_UDS_C_Men = ["UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV", "UK3CB_TKC_C_CIV"];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_b_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_B_Officers = SAC_bis_nato_officers;

		SAC_UDS_B_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_B_TankCrews = [SAC_bis_nato_tank_crew];

	};

	case "FIST_Bears_Might": {

		//unidades enemigas
		SAC_UDS_O_G_Soldiers = [
		"LOP_UA_Infantry_Rifleman_3",
		"LOP_UA_Infantry_Rifleman_2",
		"LOP_UA_Infantry_AT_Asst",
		"LOP_UA_Infantry_Engineer",
		"LOP_UA_Infantry_Rifleman_2",
		"LOP_UA_Infantry_Rifleman",
		"LOP_UA_Infantry_Marksman",
		"LOP_UA_Infantry_MG"
		];
		SAC_UDS_O_G_AA_Soldiers = [];

		SAC_UDS_O_Soldiers = SAC_bis_nato_regular_soldiers;
		SAC_UDS_O_SF_Soldiers = SAC_bis_nato_sf_soldiers;

		SAC_UDS_O_HeliPilot = SAC_bis_nato_helicopter_pilot;
		SAC_UDS_O_TankCrews = [SAC_bis_nato_tank_crew];

		//civiles
		SAC_UDS_C_Men = ["UK3CB_CHC_C_ACT","UK3CB_CHC_C_CIT","UK3CB_CHC_C_COACH","UK3CB_CHC_C_HIKER","UK3CB_CHC_C_LABOUR","UK3CB_CHC_C_PROF",
		"UK3CB_CHC_C_VILL","UK3CB_CHC_C_CAN","UK3CB_CHC_C_WOOD","UK3CB_CHC_C_WORKER"];

		//unidades aliadas
		SAC_UDS_B_G_Soldiers = SAC_bis_o_guerilla_soldiers;

		SAC_UDS_B_Soldiers = SAC_bis_csat_regular_soldiers;
		SAC_UDS_B_SF_Soldiers = SAC_bis_csat_sf_soldiers;

		SAC_UDS_B_Officers = ["O_Soldier_SL_F"];

		SAC_UDS_B_HeliPilot = "rhs_vdv_rifleman_lite";
		SAC_UDS_B_TankCrews = ["rhs_vdv_rifleman_lite"];

	};



};



//*********************************
//Vehiculos
//*********************************

//15/03/2018 Nuevo sistema para la definici�n de veh�culos, basado en la definici�n de perfiles en cada archivo de misi�n, en vez del anterior que se basaba en los
//mods cargados.
if (isNil "SAC_UDS_O_vehicleProfile") then {SAC_UDS_O_vehicleProfile = "BIS_CSAT"};
if (isNil "SAC_UDS_O_G_vehicleProfile") then {SAC_UDS_O_G_vehicleProfile = "BIS_GUER"};
if (isNil "SAC_UDS_C_vehicleProfile") then {SAC_UDS_C_vehicleProfile = "BIS_CIV"};
if (isNil "SAC_UDS_B_vehicleProfile") then {SAC_UDS_B_vehicleProfile = "BIS_NATO"};
if (isNil "SAC_UDS_B_G_vehicleProfile") then {SAC_UDS_B_G_vehicleProfile = "BIS_GUER"};

switch (SAC_UDS_O_vehicleProfile) do {

	case "BIS_CSAT": {

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_unarmedTransport = SAC_bis_csat_atv_unarmed + SAC_bis_csat_transport;

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		//y los vehiculos que crea COP cuando se usa el marquer TECHNICAL de color rojo
		SAC_UDS_O_armedTransport = SAC_bis_csat_atv_armed;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_garrisonVeh = SAC_bis_csat_atv_unarmed + SAC_bis_csat_transport;

		SAC_UDS_O_APC = SAC_bis_csat_apcs;
		SAC_UDS_O_IFV = SAC_bis_csat_ifvs;

		SAC_UDS_O_Tanks = SAC_bis_csat_tanks;

		SAC_UDS_O_transportHelicopter = SAC_bis_csat_multirole_helicopters + SAC_bis_csat_transport_helicopters_unarmed + SAC_bis_csat_transport_helicopters_armed;

		SAC_UDS_O_AAVehicles = SAC_bis_csat_aa;

	};

	case "BIS_CSAT_APEX": {

		SAC_UDS_O_unarmedTransport = SAC_bis_csat_pacific_atv_unarmed + SAC_bis_csat_pacific_transport;

		SAC_UDS_O_armedTransport = SAC_bis_csat_pacific_atv_armed;

		SAC_UDS_O_garrisonVeh = SAC_bis_csat_pacific_atv_unarmed + SAC_bis_csat_pacific_transport;

		SAC_UDS_O_APC = SAC_bis_csat_pacific_apcs;
		SAC_UDS_O_IFV = SAC_bis_csat_pacific_ifvs;

		SAC_UDS_O_Tanks = SAC_bis_csat_pacific_tanks;

		SAC_UDS_O_transportHelicopter = SAC_bis_csat_multirole_helicopters + SAC_bis_csat_transport_helicopters_unarmed + SAC_bis_csat_transport_helicopters_armed;

		SAC_UDS_O_AAVehicles = SAC_bis_csat_pacific_aa;

	};

	case "WEHRMACHT44": {

		SAC_UDS_O_unarmedTransport = [
		"LIB_DAK_OpelBlitz_Open",
		"LIB_DAK_OpelBlitz_Tent",
		"LIB_DAK_Kfz1",
		"LIB_DAK_Kfz1_hood",
		"LIB_DAK_SdKfz_7"
		];

		SAC_UDS_O_armedTransport = [
		"LIB_DAK_SdKfz251",
		"LIB_DAK_Scout_M3",
		"LIB_DAK_SdKfz251_FFV",
		"fow_v_sdkfz_250_ger_heer",
		"fow_v_kubelwagen_mg34_ger_heer",
		"LIB_DAK_Kfz1_MG42"
		];

		SAC_UDS_O_garrisonVeh = [
		"LIB_DAK_Kfz1",
		"LIB_DAK_Kfz1_hood",
		"LIB_DAK_OpelBlitz_Open",
		"LIB_DAK_OpelBlitz_Tent",
		"LIB_DAK_SdKfz_7",
		"LIB_SdKfz_7_Ammo",
		"LIB_DAK_OpelBlitz_Fuel",
		"LIB_DAK_OpelBlitz_Ambulance",
		"LIB_DAK_OpelBlitz_Parm"
		];

		SAC_UDS_O_APC = [
		"fow_v_sdkfz_222_ger_heer",
		"fow_v_sdkfz_250_9_ger_heer",
		"LIB_DAK_SdKfz_7_AA",
		"LIB_DAK_SdKfz251",
		"LIB_DAK_SdKfz251_FFV",
		"LIB_DAK_Scout_M3"
		];
		SAC_UDS_O_IFV = [];

		SAC_UDS_O_Tanks = [
		"LIB_DAK_FlakPanzerIV_Wirbelwind",
		"LIB_DAK_PzKpfwIV_H",
		"LIB_DAK_PzKpfwVI_E"
		];

		SAC_UDS_O_transportHelicopter = [];

		SAC_UDS_O_AAVehicles = [];

	};

};

switch (SAC_UDS_O_G_vehicleProfile) do {

	case "rusia_2022_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = [
			"rhs_tigr_sts_vdv","LOP_US_UAZ_DshKM"
		];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"RHS_Ural_VDV_01",
			"RHS_Ural_Open_VDV_01",
			"rhs_tigr_m_vdv"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_unarmedTransport;

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport;
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
			"RHS_Ural_Ammo_VDV_01",
			"RHS_Ural_Fuel_VDV_01",
			"RHS_Ural_Repair_VDV_01"
		];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_unarmedTransport;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = [
			"rhs_btr60_vdv",
			"rhs_btr70_vdv",
			"rhs_btr80_vdv",
			"rhs_btr80a_vdv",
			"rhs_bmp1_vdv",
			"rhs_bmp2e_vdv",
			"rhs_bmp2_vdv",
			"rhs_brm1k_vdv"
		];

		SAC_UDS_O_G_IFV = [
			"rhs_bmp1_vdv",
			"rhs_bmp2e_vdv",
			"rhs_bmp2_vdv",
			"rhs_brm1k_vdv",
			"rhs_bmd1pk",
			"rhs_bmd1r",
			"rhs_bmd2",
			"rhs_bmd2m",
			"rhs_bmd4_vdv",
			"rhs_bmd4ma_vdv"
		];

		SAC_UDS_O_G_Tanks = [
			"rhs_t72ba_tv",
			"rhs_t72bb_tv",
			"rhs_t72be_tv",
			"rhs_t80a",
			"rhs_t90a_tv",
			"rhs_t90sab_tv",
			"rhs_t80bvk",
			"rhs_sprut_vdv"
		];

		SAC_UDS_O_G_transportHelicopter = [
			"RHS_Mi8mt_vdv"
		];

		SAC_UDS_O_G_attackHelicopter = SAC_UDS_O_G_transportHelicopter;

	};

	case "korea_50_summer_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = [
			"NORTH_SOV_39_ZIS5_Maxim_Quad"
		];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh + ["NORTH_SOV_39_T20"];

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"NORTH_SOV_39_ZIS5","NORTH_SOV_39_ZIS5_Open"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_unarmedTransport + ["NORTH_SOV_39_T20"];

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport;
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
			"NORTH_SOV_ZIS5_Repair",
			"NORTH_SOV_ZIS5_Medical",
			"NORTH_SOV_ZIS5_Fuel",
			"NORTH_SOV_ZIS5_Ammo"
		];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_unarmedTransport;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = ["NORTH_SOV_T20"];

		SAC_UDS_O_G_IFV = [
			"NORTH_SOV_BA10", "NORTH_SOV_BA6"
		];

		SAC_UDS_O_G_Tanks = [
			"NORTH_SOV_T34_85_45_Berlin",
			"NORTH_SOV_T34_85_45",
			"NORTH_SOV_T34_85",
			"NORTH_SOV_T34_76_1943",
			"NORTH_SOV_T34_76_1941",
			"NORTH_SOV_T28e",
			"NORTH_SOV_KV1_1940",
			"NORTH_SOV_T70",
			"NORTH_SOV_T26_M33"
		];

		SAC_UDS_O_G_transportHelicopter = [
			
		];

		SAC_UDS_O_G_attackHelicopter = SAC_UDS_O_G_transportHelicopter;

	};

	case "china_50_winter_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = [
			"NORTH_SOV_W_ZIS5_Maxim_Quad", "NORTH_SOV_W_39_T20"
		];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh + ["NORTH_SOV_W_39_T20"];

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"NORTH_SOV_W_ZIS5"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_unarmedTransport + ["NORTH_SOV_W_39_T20"];

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport;
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
			"NORTH_SOV_W_ZIS5_Fuel","LIB_Zis5v_med_w","LIB_Zis5v_fuel_w","LIB_Zis6_parm_w"
		];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_unarmedTransport;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = ["NORTH_SOV_W_39_T20"];

		SAC_UDS_O_G_IFV = ["NORTH_SOV_W_BA10", "NORTH_SOV_W_BA6"];

		SAC_UDS_O_G_Tanks = [
			"NORTH_SOV_W_KV1_1941",
			"NORTH_SOV_W_T26_M33",
			"NORTH_SOV_W_T34_76_1941",
			"NORTH_SOV_W_T34_76_1943",
			"NORTH_SOV_W_T60",
			"NORTH_SOV_W_T70",
			"NORTH_SOV_W_39_T26_M39_OT",
			"NORTH_SOV_W_39_T26_M39_OT"
		];

		SAC_UDS_O_G_transportHelicopter = [
			
		];

		SAC_UDS_O_G_attackHelicopter = SAC_UDS_O_G_transportHelicopter;

	};

	case "syrian_army_altis_uds_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = [
			"UK3CB_ARD_O_GAZ_Vodnik_PKT",
			"UK3CB_LDF_O_Tigr_STS",
			"rhs_tigr_sts_3camo_msv",
			"UK3CB_TKA_O_GAZ_Vodnik_PKT",
			"UK3CB_ARD_O_UAZ_MG",
			"LOP_SYR_UAZ_SPG"
		];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"UK3CB_TKA_O_GAZ_Vodnik",
			"UK3CB_ARD_O_GAZ_Vodnik",
			"UK3CB_CW_SOV_O_EARLY_Gaz66_Covered",
			"UK3CB_CW_SOV_O_EARLY_Gaz66_Open"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_unarmedTransport;

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport;
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
			"UK3CB_CW_SOV_O_EARLY_Gaz66_Ammo",
			"UK3CB_CW_SOV_O_EARLY_Gaz66_Med",
			"UK3CB_CW_SOV_O_EARLY_Gaz66_Repair",
			"UK3CB_CW_SOV_O_EARLY_Gaz66_Radio",
			"UK3CB_TKA_O_GAZ_Vodnik_MedEvac",
			"UK3CB_ARD_O_GAZ_Vodnik_MedEvac",
			"UK3CB_APD_O_GAZ_Vodnik_MedEvac"
		];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_unarmedTransport;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = [
			"UK3CB_ARD_O_GAZ_Vodnik_PKT",
			"UK3CB_TKA_O_GAZ_Vodnik_PKT",
			"LOP_TKA_BTR60"
		];

		SAC_UDS_O_G_IFV = [
			"UK3CB_ARD_O_GAZ_Vodnik_Cannon",
			"UK3CB_ARD_O_GAZ_Vodnik_KVPT"
		];

		SAC_UDS_O_G_Tanks = [
			"rhs_t14_tv",
			"rhs_t72ba_tv",
			"rhs_t80",
			"rhs_t90_tv"
		];

		SAC_UDS_O_G_transportHelicopter = [
			"RHS_Mi8AMT_vdv",
			"RHS_Mi8MTV3_vdv"
		];

		SAC_UDS_O_G_attackHelicopter = SAC_UDS_O_G_transportHelicopter;

	};

	case "BIS_GUER": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = [
		"O_G_Offroad_01_armed_F",
		"O_G_Offroad_01_armed_F",
		"I_C_Offroad_02_LMG_F",
		"I_C_Offroad_02_LMG_F",
		["O_G_Offroad_01_AT_F",
		"I_C_Offroad_02_AT_F"]
		];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = ["I_C_Van_01_transport_F", "I_C_Van_02_transport_F", "O_G_Offroad_01_F", "O_G_Van_01_transport_F", "O_G_Van_02_transport_F",
		"I_C_Offroad_02_unarmed_F","O_T_Truck_02_transport_F","O_T_Truck_02_F"];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh;
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + ["O_G_Van_01_fuel_F"]; //transporte de tropas + log�stica

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = ["C_Van_01_transport_F", "C_Truck_02_covered_F", "C_Offroad_01_F"];

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + ["O_G_Van_01_fuel_F"];

		SAC_UDS_O_G_APC = [];
		SAC_UDS_O_G_IFV = [];

		SAC_UDS_O_G_Tanks = [];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "BIS_GUER_W_RHS": { //est�n complementados con 4 veh�culos de RHS.

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = [
		"O_G_Offroad_01_armed_F",
		"O_G_Offroad_01_armed_F",
		"I_C_Offroad_02_LMG_F",
		"I_C_Offroad_02_LMG_F",
		["O_G_Offroad_01_AT_F",
		"I_C_Offroad_02_AT_F"]
		];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = ["I_C_Van_01_transport_F", "I_C_Van_02_transport_F", "O_G_Offroad_01_F", "O_G_Van_01_transport_F", "O_G_Van_02_transport_F",
		"I_C_Offroad_02_unarmed_F","O_T_Truck_02_transport_F","O_T_Truck_02_F","rhsgref_hidf_M998_2dr","rhsgref_hidf_M998_2dr_fulltop"];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh;
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + ["O_G_Van_01_fuel_F"]; //transporte de tropas + log�stica

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = ["C_Van_01_transport_F", "C_Truck_02_covered_F", "C_Offroad_01_F"];

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + ["O_G_Van_01_fuel_F"];

		SAC_UDS_O_G_APC = ["rhsgref_tla_g_btr60","rhsgref_hidf_m113a3_m2"];
		SAC_UDS_O_G_IFV = [];

		SAC_UDS_O_G_Tanks = [];

		SAC_UDS_O_G_transportHelicopter = ["RHS_Mi8mt_vdv"];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "BIS_GUER_WITH_CUP_TANKS_AND_APCS": {

		SAC_UDS_O_G_patrolVeh = [
		"O_G_Offroad_01_armed_F",
		"O_G_Offroad_01_armed_F",
		"I_C_Offroad_02_LMG_F",
		"I_C_Offroad_02_LMG_F",
		["O_G_Offroad_01_AT_F",
		"I_C_Offroad_02_AT_F"]
		];

		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_unarmedTransport = ["I_C_Van_01_transport_F", "I_C_Van_02_transport_F", "O_G_Offroad_01_F", "O_G_Van_01_transport_F", "O_G_Van_02_transport_F",
		"I_C_Offroad_02_unarmed_F"];

		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh;
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + ["O_G_Van_01_fuel_F"]; //transporte de tropas + log�stica

		SAC_UDS_O_G_insurgencyTraffic = ["C_Van_01_transport_F", "C_Truck_02_covered_F", "C_Offroad_01_F"];

		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + ["O_G_Van_01_fuel_F"];

		SAC_UDS_O_G_APC = [
			["CUP_B_BTR80_CDF",
			"CUP_B_BTR80A_CDF",
			"CUP_B_BTR80_FIA",
			"CUP_O_BTR80_DESERT_RU",
			"CUP_O_BTR80_GREEN_RU",
			"CUP_O_BTR80_WINTER_RU",
			"CUP_O_BTR80A_CAMO_RU",
			"CUP_O_BTR80A_DESERT_RU",
			"CUP_O_BTR80A_GREEN_RU",
			"CUP_O_BTR80A_WINTER_RU",
			"CUP_O_BTR80_CSAT",
			"CUP_O_BTR80A_CSAT",
			"CUP_O_BTR80_CSAT_T",
			"CUP_O_BTR80_TK",
			"CUP_O_BTR80A_TK",
			"CUP_O_BTR80A_CSAT_T",
			"CUP_O_BTR80_CHDKZ",
			"CUP_O_BTR80A_CHDKZ",
			"CUP_B_BTR80A_FIA"],
			["CUP_O_BTR60_Green_RU",
			"CUP_O_BTR60_CSAT",
			"CUP_O_BTR60_SLA",
			"CUP_O_BTR60_CHDKZ",
			"CUP_O_BTR60_TK",
			"CUP_B_BTR60_FIA",
			"CUP_O_BTR60_RU"],

			["CUP_O_BRDM2_RUS",
			"CUP_O_BRDM2_CHDKZ",
			"CUP_O_BRDM2_CSAT",
			"CUP_O_BRDM2_ATGM_CSAT",
			"CUP_O_BRDM2_CSAT_T",
			"CUP_O_BRDM2_ATGM_CSAT_T",
			"CUP_O_BRDM2_SLA",
			"CUP_O_BRDM2_ATGM_SLA",
			"CUP_O_BRDM2_TKA",
			"CUP_O_BRDM2_ATGM_TKA",
			"CUP_O_BRDM2_ATGM_CHDKZ",
			"CUP_B_BRDM2_CDF",
			"CUP_B_BRDM2_ATGM_CDF"],
			["CUP_O_GAZ_Vodnik_BPPU_RU",
			"CUP_O_GAZ_Vodnik_KPVT_RU"],
			["CUP_O_MTLB_pk_WDL_RU",
			"CUP_O_MTLB_pk_TKA",
			"CUP_I_MTLB_pk_SYNDIKAT",
			"CUP_O_MTLB_pk_Green_RU"],
			"CUP_O_BTR90_RU",
			"CUP_O_M113_TKA",
			"CUP_I_BTR40_MG_TKG"
		];

		SAC_UDS_O_G_IFV = [
			["CUP_O_BMP1_CSAT",
			"CUP_O_BMP1P_CSAT",
			"CUP_O_BMP1_CSAT_T",
			"CUP_I_BMP1_TK_GUE",
			"CUP_O_BMP1P_CSAT_T",
			"CUP_O_BMP1_TKA",
			"CUP_O_BMP1P_TKA"],
			["CUP_O_BMP2_RU",
			"CUP_O_BMP2_CHDKZ",
			"CUP_O_BMP2_CSAT",
			"CUP_O_BMP2_CSAT_T",
			"CUP_O_BMP2_ZU_CSAT_T",
			"CUP_O_BMP2_TKA",
			"CUP_O_BMP2_ZU_TKA",
			"CUP_I_BMP2_NAPA",
			"CUP_B_BMP2_CDF",
			"CUP_O_BMP2_SLA",
			"CUP_O_BMP2_ZU_CSAT"],
			"CUP_O_BMP3_RU"
		];

		SAC_UDS_O_G_Tanks = [
			["CUP_I_T72_NAPA",
			"CUP_B_T72_CDF",
			"CUP_O_T72_RU",
			"CUP_O_T72_CHDKZ",
			"CUP_O_T72_CSAT_T",
			"CUP_O_T72_CSAT",
			"CUP_O_T72_TKA"],
			["CUP_I_T55_NAPA",
			"CUP_O_T55_CHDKZ",
			"CUP_O_T55_CSAT",
			"CUP_O_T55_CSAT_T"],
			"CUP_O_T90_RU"
		];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "3CB_TAKISTAN": {

		SAC_UDS_O_G_patrolVeh = [
"UK3CB_TKM_O_Datsun_Pkm",
"UK3CB_TKM_O_Hilux_Dshkm",
"UK3CB_TKM_O_UAZ_Dshkm",
"UK3CB_TKM_O_Hilux_Pkm",
"UK3CB_TKM_O_LR_M2",
"UK3CB_TKM_O_LR_SF_M2",
"UK3CB_TKM_O_Pickup_M2",
"UK3CB_TKM_O_Pickup_DSHKM",
["UK3CB_TKM_O_Hilux_Rocket_Arty",
"UK3CB_TKM_O_Hilux_Rocket",
"UK3CB_TKM_O_Hilux_Spg9",
"UK3CB_TKM_O_LR_SPG9",
"UK3CB_TKM_O_UAZ_SPG9",
"UK3CB_TKM_O_Hilux_Zu23"],
["UK3CB_TKM_O_Hilux_Rocket_Arty",
"UK3CB_TKM_O_Hilux_Rocket",
"UK3CB_TKM_O_Hilux_Spg9",
"UK3CB_TKM_O_LR_SPG9",
"UK3CB_TKM_O_UAZ_SPG9",
"UK3CB_TKM_O_Hilux_Zu23"]
		];

		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_unarmedTransport = [
["UK3CB_TKM_O_Datsun_Open",
"UK3CB_TKM_O_Hilux_Open",
"UK3CB_TKM_O_LR_Closed",
"UK3CB_TKM_O_Pickup",
"UK3CB_TKM_O_LR_Open"],
["UK3CB_TKM_O_V3S_Closed",
"UK3CB_TKM_O_V3S_Open"],
["UK3CB_TKM_O_Ural_Covered",
"UK3CB_TKM_O_Ural_Open"]
		];

		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh;
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
["UK3CB_TKM_O_V3S_Reammo",
"UK3CB_TKM_O_V3S_Refuel",
"UK3CB_TKM_O_V3S_Recovery",
"UK3CB_TKM_O_V3S_Repair"],
["UK3CB_TKM_O_UAZ_Closed",
"UK3CB_TKM_O_UAZ_Open"],
["UK3CB_TKM_O_Ural_Fuel",
"UK3CB_TKM_O_Ural_Ammo",
"UK3CB_TKM_O_Ural_Empty",
"UK3CB_TKM_O_Ural_Repair"]
		]; //transporte de tropas + log�stica

		SAC_UDS_O_G_insurgencyTraffic = ["UK3CB_TKC_C_LR_Closed", "UK3CB_TKC_C_V3S_Closed", "UK3CB_TKC_C_Ural"];

		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + [
["UK3CB_TKM_O_V3S_Reammo",
"UK3CB_TKM_O_V3S_Refuel",
"UK3CB_TKM_O_V3S_Recovery",
"UK3CB_TKM_O_V3S_Repair"],
["UK3CB_TKM_O_UAZ_Closed",
"UK3CB_TKM_O_UAZ_Open"],
["UK3CB_TKM_O_Ural_Fuel",
"UK3CB_TKM_O_Ural_Ammo",
"UK3CB_TKM_O_Ural_Empty",
"UK3CB_TKM_O_Ural_Repair"]
		];

		SAC_UDS_O_G_APC = ["UK3CB_TKM_O_BTR60","UK3CB_TKM_O_MTLB_PKT"];
		SAC_UDS_O_G_IFV = ["UK3CB_TKM_O_BMP1"];

		SAC_UDS_O_G_Tanks = ["UK3CB_TKM_O_T55"];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "3CB_CHERNARUS": {

		SAC_UDS_O_G_patrolVeh = [
"UK3CB_NAP_O_BTR40_MG",
"UK3CB_NAP_O_UAZ_MG",
"UK3CB_NAP_O_Hilux_Pkm",
"UK3CB_NAP_O_Hilux_Dshkm",
"UK3CB_NAP_O_Offroad_M2",
"UK3CB_O_G_Pickup_M2",
"UK3CB_O_G_Pickup_DSHKM",
["UK3CB_NAP_O_Hilux_GMG",
"UK3CB_NAP_O_UAZ_AGS30"],
["UK3CB_NAP_O_Hilux_Rocket_Arty",
"UK3CB_NAP_O_Hilux_Rocket",
"UK3CB_NAP_O_Hilux_Spg9",
"UK3CB_NAP_O_UAZ_SPG9",
"UK3CB_NAP_O_Hilux_Zu23"]
		];

		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_unarmedTransport = [
["UK3CB_NAP_O_Gaz66_Covered",
"UK3CB_NAP_O_Gaz66_Open"],
["UK3CB_NAP_O_Hilux_Open",
"UK3CB_NAP_O_Offroad",
"UK3CB_O_G_Pickup"],
["UK3CB_NAP_O_V3S_Closed",
"UK3CB_NAP_O_V3S_Open"],
"UK3CB_NAP_O_Ural",
"UK3CB_NAP_O_Zil131_Covered",
"UK3CB_NAP_O_Zil131_Open"
		];

		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh;
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
"UK3CB_NAP_O_BTR40",
"UK3CB_NAP_O_Hilux_Closed",
["UK3CB_NAP_O_Kraz255_BMKT",
"UK3CB_NAP_O_Kraz255_Flatbed",
"UK3CB_NAP_O_Kraz255_Open",
"UK3CB_NAP_O_Kraz255_PMP",
"UK3CB_NAP_O_Kraz255_Fuel"],
"UK3CB_NAP_O_UAZ_Closed",
"UK3CB_NAP_O_UAZ_Open",
"UK3CB_NAP_O_Ural_Fuel",
"UK3CB_NAP_O_Ural_Ammo",
"UK3CB_NAP_O_Zil131_Flatbed"
]; //transporte de tropas + log�stica

		SAC_UDS_O_G_insurgencyTraffic = ["UK3CB_TKC_C_LR_Closed", "UK3CB_TKC_C_V3S_Closed", "UK3CB_TKC_C_Ural"];

		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + [
"UK3CB_NAP_O_BTR40",
"UK3CB_NAP_O_Hilux_Closed",
["UK3CB_NAP_O_Kraz255_BMKT",
"UK3CB_NAP_O_Kraz255_Flatbed",
"UK3CB_NAP_O_Kraz255_Open",
"UK3CB_NAP_O_Kraz255_PMP",
"UK3CB_NAP_O_Kraz255_Fuel"],
"UK3CB_NAP_O_UAZ_Closed",
"UK3CB_NAP_O_UAZ_Open",
"UK3CB_NAP_O_Ural_Fuel",
"UK3CB_NAP_O_Ural_Ammo",
"UK3CB_NAP_O_Zil131_Flatbed"
];
		SAC_UDS_O_G_APC = ["UK3CB_NAP_O_BTR60","UK3CB_NAP_O_MTLB_PKT","UK3CB_NAP_O_BRDM2"];
		SAC_UDS_O_G_IFV = ["UK3CB_NAP_O_BMP1","UK3CB_NAP_O_BMP2"];

		SAC_UDS_O_G_Tanks = ["UK3CB_NAP_O_T72A","UK3CB_NAP_O_T72BM"];

		SAC_UDS_O_G_transportHelicopter = ["UK3CB_AAF_O_Mi8"];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "3CB_AFRICA": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = [
		"UK3CB_ADE_O_Hilux_Dshkm",
		"UK3CB_ADM_O_Hilux_Dshkm",
		"UK3CB_ADE_O_Pickup_DSHKM",
		"UK3CB_ADM_O_Pickup_DSHKM",
		"UK3CB_ADE_O_Hilux_Pkm",
		"UK3CB_ADM_O_Hilux_Pkm",
		"UK3CB_ADE_O_LR_M2",
		"UK3CB_ADE_O_Offroad_M2",
		"UK3CB_ADM_O_LR_M2",
		"UK3CB_ADM_O_Offroad_M2",
		["UK3CB_ADE_O_LR_SPG9",
		"UK3CB_ADM_O_Hilux_Spg9",
		"UK3CB_ADM_O_LR_SPG9",
		"UK3CB_ADE_O_LR_AGS30",
		"UK3CB_ADM_O_LR_AGS30",
		"UK3CB_ADE_O_Hilux_GMG",
		"UK3CB_ADM_O_Hilux_GMG",
		"UK3CB_ADE_O_Hilux_Rocket_Arty",
		"UK3CB_ADM_O_Hilux_Rocket_Arty",
		"UK3CB_ADM_O_Hilux_Rocket",
		"UK3CB_ADE_O_V3S_Zu23",
		"UK3CB_ADM_O_Hilux_Zu23",
		"UK3CB_ADM_O_V3S_Zu23"],
		["UK3CB_ADE_O_LR_SPG9",
		"UK3CB_ADM_O_Hilux_Spg9",
		"UK3CB_ADM_O_LR_SPG9",
		"UK3CB_ADE_O_LR_AGS30",
		"UK3CB_ADM_O_LR_AGS30",
		"UK3CB_ADE_O_Hilux_GMG",
		"UK3CB_ADM_O_Hilux_GMG",
		"UK3CB_ADE_O_Hilux_Rocket_Arty",
		"UK3CB_ADM_O_Hilux_Rocket_Arty",
		"UK3CB_ADM_O_Hilux_Rocket",
		"UK3CB_ADE_O_V3S_Zu23",
		"UK3CB_ADM_O_Hilux_Zu23",
		"UK3CB_ADM_O_V3S_Zu23"],
		["UK3CB_ADE_O_LR_SPG9",
		"UK3CB_ADM_O_Hilux_Spg9",
		"UK3CB_ADM_O_LR_SPG9",
		"UK3CB_ADE_O_LR_AGS30",
		"UK3CB_ADM_O_LR_AGS30",
		"UK3CB_ADE_O_Hilux_GMG",
		"UK3CB_ADM_O_Hilux_GMG",
		"UK3CB_ADE_O_Hilux_Rocket_Arty",
		"UK3CB_ADM_O_Hilux_Rocket_Arty",
		"UK3CB_ADM_O_Hilux_Rocket",
		"UK3CB_ADE_O_V3S_Zu23",
		"UK3CB_ADM_O_Hilux_Zu23",
		"UK3CB_ADM_O_V3S_Zu23"]
		];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
		"UK3CB_ADM_O_Hilux_Open",
		"UK3CB_ADM_O_Hilux_Closed",
		"UK3CB_ADM_O_LR_Closed",
		"UK3CB_ADM_O_LR_Open",
		"UK3CB_ADM_O_Pickup",
		"UK3CB_ADM_O_V3S_Closed",
		"UK3CB_ADM_O_V3S_Open",
		"UK3CB_ADE_O_Hilux_Open",
		"UK3CB_ADE_O_LR_Closed",
		"UK3CB_ADE_O_LR_Open",
		"UK3CB_ADE_O_Offroad",
		"UK3CB_ADE_O_Pickup",
		"UK3CB_ADE_O_V3S_Closed",
		"UK3CB_ADE_O_V3S_Open",
		"UK3CB_ADA_O_Ural",
		"UK3CB_ADA_O_Ural_Open"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh;
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
		"UK3CB_ADA_O_Ural_Fuel",
		"UK3CB_ADA_O_Ural_Ammo",
		"UK3CB_ADA_O_Ural_Repair",
		"UK3CB_ADE_O_V3S_Refuel",
		"UK3CB_ADE_O_V3S_Repair",
		"UK3CB_ADM_O_V3S_Refuel",
		"UK3CB_ADM_O_V3S_Repair"
		]; //transporte de tropas + log�stica

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = [
		"UK3CB_ADC_O_Kamaz_Covered",
		"UK3CB_ADC_O_LR_Closed",
		"UK3CB_ADC_O_V3S_Closed",
		"UK3CB_ADC_O_Ural"
		];

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + [
		"UK3CB_ADA_O_Ural_Fuel",
		"UK3CB_ADA_O_Ural_Ammo",
		"UK3CB_ADA_O_Ural_Repair",
		"UK3CB_ADE_O_V3S_Refuel",
		"UK3CB_ADE_O_V3S_Repair",
		"UK3CB_ADM_O_V3S_Refuel",
		"UK3CB_ADM_O_V3S_Repair"
		];
		SAC_UDS_O_G_APC = [
		"UK3CB_ADA_O_BTR60",
		"UK3CB_ADA_O_M113_M2",
		["UK3CB_ADA_O_BRDM2",
		"UK3CB_ADE_O_BRDM2",
		"UK3CB_ADM_O_BRDM2"],
		["UK3CB_ADA_O_MTLB_PKT",
		"UK3CB_ADM_O_MTLB_PKT"]
		];
		SAC_UDS_O_G_IFV = ["UK3CB_ADA_O_BMP1","UK3CB_ADA_O_BMP2"];

		SAC_UDS_O_G_Tanks = ["UK3CB_ADA_O_T72A"];

		SAC_UDS_O_G_transportHelicopter = ["UK3CB_ADA_O_Mi8","UK3CB_ADA_O_UH1H_M240"];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "CUP_GUER": {

		SAC_UDS_O_G_patrolVeh = [
			"CUP_O_Hilux_DSHKM_OPF_G_F",
			"CUP_O_Hilux_M2_OPF_G_F",
			["CUP_O_Hilux_metis_OPF_G_F",
			"CUP_O_UAZ_METIS_CSAT",
			"CUP_O_UAZ_METIS_CHDKZ",
			"CUP_O_UAZ_METIS_SLA",
			"CUP_O_UAZ_METIS_TKA",
			"CUP_B_UAZ_METIS_CDF",
			"CUP_O_UAZ_METIS_RU",
			"CUP_O_Hilux_metis_CHDKZ"],
			["CUP_O_Hilux_MLRS_OPF_G_F",
			"CUP_O_Hilux_MLRS_CHDKZ"],
			["CUP_O_UAZ_SPG9_CSAT",
			"CUP_O_Hilux_SPG9_OPF_G_F",
			"CUP_O_UAZ_SPG9_RU",
			"CUP_O_UAZ_SPG9_SLA",
			"CUP_O_LR_SPG9_TKA",
			"CUP_O_UAZ_SPG9_TKA",
			"CUP_O_UAZ_SPG9_CHDKZ",
			"CUP_B_UAZ_SPG9_CDF",
			"CUP_O_Hilux_SPG9_CHDKZ"],
			["CUP_O_Hilux_UB32_OPF_G_F",
			"CUP_O_Hilux_UB32_CHDKZ"],
			["CUP_O_Hilux_zu23_OPF_G_F",
			"CUP_O_Ural_ZU23_TKA",
			"CUP_O_Ural_ZU23_RU",
			"CUP_O_Ural_ZU23_CHDKZ",
			"CUP_O_Hilux_zu23_CHDKZ",
			"CUP_B_Ural_ZU23_CDF"],
			"CUP_B_UAZ_MG_CDF",
			"CUP_O_Hilux_DSHKM_CHDKZ",
			"CUP_O_UAZ_MG_CHDKZ",
			"CUP_O_UAZ_MG_CSAT",
			"CUP_O_UAZ_MG_SLA",
			"CUP_O_LR_MG_TKA",
			"CUP_O_UAZ_MG_TKA",
			"CUP_O_UAZ_MG_RU"
		];

		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_unarmedTransport = [
			"CUP_B_Kamaz_CDF",
			"CUP_B_Kamaz_Open_CDF",
			"CUP_B_Ural_CDF",
			"CUP_B_Ural_Open_CDF",
			"CUP_O_Kamaz_RU",
			"CUP_O_Kamaz_Open_RU",
			"CUP_O_UAZ_Open_RU",
			"CUP_O_Ural_RU",
			"CUP_O_Ural_Open_RU",
			"CUP_O_Ural_CHDKZ",
			"CUP_O_Ural_Open_CHDKZ",
			"CUP_O_Ural_SLA",
			"CUP_O_Ural_Open_SLA",
			"CUP_O_LR_Transport_TKA",
			"CUP_I_V3S_Open_TKG",
			"CUP_I_V3S_Covered_TKG",
			"CUP_O_Ural_TKA",
			"CUP_O_Ural_Open_TKA"
		];

		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh;
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
			"CUP_B_Kamaz_Refuel_CDF",
			"CUP_B_Kamaz_Repair_CDF",
			"CUP_B_UAZ_Unarmed_CDF",
			"CUP_O_Hilux_unarmed_OPF_G_F",
			"CUP_O_Hilux_unarmed_CHDKZ",
			"CUP_B_UAZ_Open_CDF",
			"CUP_O_UAZ_Open_CHDKZ",
			"CUP_B_Ural_Reammo_CDF",
			"CUP_B_Ural_Refuel_CDF",
			"CUP_B_Ural_Repair_CDF",
			"CUP_O_Kamaz_Refuel_RU",
			"CUP_O_Kamaz_Repair_RU",
			"CUP_O_UAZ_Unarmed_RU",
			"CUP_O_Ural_Reammo_RU",
			"CUP_O_Ural_Refuel_RU",
			"CUP_O_Ural_Repair_RU",
			"CUP_O_UAZ_Unarmed_CHDKZ",
			"CUP_O_Ural_Reammo_CHDKZ",
			"CUP_O_Ural_Refuel_CHDKZ",
			"CUP_O_Ural_Repair_CHDKZ",
			"CUP_O_UAZ_Unarmed_CSAT",
			"CUP_O_UAZ_Open_CSAT",
			"CUP_O_Volha_SLA",
			"CUP_O_UAZ_Unarmed_SLA",
			"CUP_O_UAZ_Militia_SLA",
			"CUP_O_UAZ_Open_SLA",
			"CUP_O_Ural_Reammo_SLA",
			"CUP_O_Ural_Refuel_SLA",
			"CUP_O_Ural_Repair_SLA",
			"CUP_O_UAZ_Unarmed_TKA",
			"CUP_O_UAZ_Open_TKA",
			"CUP_O_Ural_Reammo_TKA",
			"CUP_O_Ural_Refuel_TKA",
			"CUP_O_Ural_Repair_TKA",
			"CUP_I_V3S_Refuel_TKG",
			"CUP_I_V3S_Repair_TKG"
		]; //transporte de tropas + log�stica

		SAC_UDS_O_G_insurgencyTraffic = ["CUP_C_V3S_Covered_TKC", "CUP_C_Ural_Civ_02", "CUP_C_Ural_Civ_03", "CUP_O_Hilux_unarmed_CR_CIV"];

		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + [
			"CUP_B_Kamaz_Refuel_CDF",
			"CUP_B_Kamaz_Repair_CDF",
			"CUP_B_UAZ_Unarmed_CDF",
			"CUP_O_Hilux_unarmed_OPF_G_F",
			"CUP_O_Hilux_unarmed_CHDKZ",
			"CUP_B_UAZ_Open_CDF",
			"CUP_O_UAZ_Open_CHDKZ",
			"CUP_B_Ural_Reammo_CDF",
			"CUP_B_Ural_Refuel_CDF",
			"CUP_B_Ural_Repair_CDF",
			"CUP_O_Kamaz_Refuel_RU",
			"CUP_O_Kamaz_Repair_RU",
			"CUP_O_UAZ_Unarmed_RU",
			"CUP_O_Ural_Reammo_RU",
			"CUP_O_Ural_Refuel_RU",
			"CUP_O_Ural_Repair_RU",
			"CUP_O_UAZ_Unarmed_CHDKZ",
			"CUP_O_Ural_Reammo_CHDKZ",
			"CUP_O_Ural_Refuel_CHDKZ",
			"CUP_O_Ural_Repair_CHDKZ",
			"CUP_O_UAZ_Unarmed_CSAT",
			"CUP_O_UAZ_Open_CSAT",
			"CUP_O_Volha_SLA",
			"CUP_O_UAZ_Unarmed_SLA",
			"CUP_O_UAZ_Militia_SLA",
			"CUP_O_UAZ_Open_SLA",
			"CUP_O_Ural_Reammo_SLA",
			"CUP_O_Ural_Refuel_SLA",
			"CUP_O_Ural_Repair_SLA",
			"CUP_O_UAZ_Unarmed_TKA",
			"CUP_O_UAZ_Open_TKA",
			"CUP_O_Ural_Reammo_TKA",
			"CUP_O_Ural_Refuel_TKA",
			"CUP_O_Ural_Repair_TKA",
			"CUP_I_V3S_Refuel_TKG",
			"CUP_I_V3S_Repair_TKG"
		];

		SAC_UDS_O_G_APC = [
			["CUP_B_BTR80_CDF",
			"CUP_B_BTR80A_CDF",
			"CUP_B_BTR80_FIA",
			"CUP_O_BTR80_DESERT_RU",
			"CUP_O_BTR80_GREEN_RU",
			"CUP_O_BTR80_WINTER_RU",
			"CUP_O_BTR80A_CAMO_RU",
			"CUP_O_BTR80A_DESERT_RU",
			"CUP_O_BTR80A_GREEN_RU",
			"CUP_O_BTR80A_WINTER_RU",
			"CUP_O_BTR80_CSAT",
			"CUP_O_BTR80A_CSAT",
			"CUP_O_BTR80_CSAT_T",
			"CUP_O_BTR80_TK",
			"CUP_O_BTR80A_TK",
			"CUP_O_BTR80A_CSAT_T",
			"CUP_O_BTR80_CHDKZ",
			"CUP_O_BTR80A_CHDKZ",
			"CUP_B_BTR80A_FIA"],
			["CUP_O_BTR60_Green_RU",
			"CUP_O_BTR60_CSAT",
			"CUP_O_BTR60_SLA",
			"CUP_O_BTR60_CHDKZ",
			"CUP_O_BTR60_TK",
			"CUP_B_BTR60_FIA",
			"CUP_O_BTR60_RU"],

			["CUP_O_BRDM2_RUS",
			"CUP_O_BRDM2_CHDKZ",
			"CUP_O_BRDM2_CSAT",
			"CUP_O_BRDM2_ATGM_CSAT",
			"CUP_O_BRDM2_CSAT_T",
			"CUP_O_BRDM2_ATGM_CSAT_T",
			"CUP_O_BRDM2_SLA",
			"CUP_O_BRDM2_ATGM_SLA",
			"CUP_O_BRDM2_TKA",
			"CUP_O_BRDM2_ATGM_TKA",
			"CUP_O_BRDM2_ATGM_CHDKZ",
			"CUP_B_BRDM2_CDF",
			"CUP_B_BRDM2_ATGM_CDF"],
			["CUP_O_GAZ_Vodnik_BPPU_RU",
			"CUP_O_GAZ_Vodnik_KPVT_RU"],
			["CUP_O_MTLB_pk_WDL_RU",
			"CUP_O_MTLB_pk_TKA",
			"CUP_I_MTLB_pk_SYNDIKAT",
			"CUP_O_MTLB_pk_Green_RU"],
			"CUP_O_BTR90_RU",
			"CUP_O_M113_TKA",
			"CUP_I_BTR40_MG_TKG"
		];

		SAC_UDS_O_G_IFV = [
			["CUP_O_BMP1_CSAT",
			"CUP_O_BMP1P_CSAT",
			"CUP_O_BMP1_CSAT_T",
			"CUP_I_BMP1_TK_GUE",
			"CUP_O_BMP1P_CSAT_T",
			"CUP_O_BMP1_TKA",
			"CUP_O_BMP1P_TKA"],
			["CUP_O_BMP2_RU",
			"CUP_O_BMP2_CHDKZ",
			"CUP_O_BMP2_CSAT",
			"CUP_O_BMP2_CSAT_T",
			"CUP_O_BMP2_ZU_CSAT_T",
			"CUP_O_BMP2_TKA",
			"CUP_O_BMP2_ZU_TKA",
			"CUP_I_BMP2_NAPA",
			"CUP_B_BMP2_CDF",
			"CUP_O_BMP2_SLA",
			"CUP_O_BMP2_ZU_CSAT"],
			"CUP_O_BMP3_RU"
		];

		SAC_UDS_O_G_Tanks = [
			["CUP_I_T72_NAPA",
			"CUP_B_T72_CDF",
			"CUP_O_T72_RU",
			"CUP_O_T72_CHDKZ",
			"CUP_O_T72_CSAT_T",
			"CUP_O_T72_CSAT",
			"CUP_O_T72_TKA"],
			["CUP_I_T55_NAPA",
			"CUP_O_T55_CHDKZ",
			"CUP_O_T55_CSAT",
			"CUP_O_T55_CSAT_T"],
			"CUP_O_T90_RU"
		];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "RHS_GUER": {

		SAC_UDS_O_G_patrolVeh = [
			["rhs_gaz66_zu23_msv",
			"RHS_Ural_Zu23_MSV_01",
			"rhsgref_cdf_gaz66_zu23",
			"rhsgref_cdf_ural_Zu23",
			"rhsgref_ins_gaz66_zu23",
			"rhsgref_ins_ural_Zu23",
			"rhsgref_nat_ural_Zu23"],
			"rhsgref_cdf_reg_uaz_dshkm",
			["rhsgref_cdf_reg_uaz_spg9",
			"rhsgref_ins_uaz_spg9",
			"rhsgref_nat_uaz_spg9"],
			["rhsgref_cdf_reg_uaz_ags",
			"rhsgref_ins_uaz_ags",
			"rhsgref_nat_uaz_ags"],
			"rhsgref_ins_uaz_dshkm",
			"rhsgref_nat_uaz_dshkm"
		];

		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_unarmedTransport = [
			"rhs_gaz66_msv",
			"rhs_gaz66o_msv",
			"rhs_kamaz5350_msv",
			"rhs_kamaz5350_open_msv",
			"RHS_Ural_MSV_01",
			"RHS_Ural_Open_MSV_01",
			"rhs_zil131_msv",
			"rhs_zil131_open_msv",
			"rhsgref_cdf_gaz66",
			"rhsgref_cdf_gaz66o",
			"rhsgref_cdf_ural",
			"rhsgref_cdf_ural_open",
			"rhsgref_cdf_zil131",
			"rhsgref_cdf_zil131_open",
			"rhsgref_ins_gaz66",
			"rhsgref_ins_gaz66o",
			"rhsgref_ins_ural",
			"rhsgref_ins_ural_open",
			"rhsgref_ins_zil131",
			"rhsgref_ins_zil131_open",
			"rhsgref_nat_ural",
			"rhsgref_nat_ural_open"
		];

		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh;
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
			"RHS_UAZ_MSV_01",
			"rhs_uaz_open_MSV_01",
			"rhs_gaz66_ammo_msv",
			"rhs_gaz66_r142_msv",
			"rhs_gaz66_ap2_msv",
			"rhs_gaz66_repair_msv",
			"rhs_kraz255b1_bmkt_msv",
			"rhs_kraz255b1_flatbed_msv",
			"rhs_kraz255b1_pmp_msv",
			"rhs_kraz255b1_fuel_msv",
			"RHS_Ural_Fuel_MSV_01",
			"RHS_Ural_Repair_MSV_01",
			"rhsgref_cdf_reg_uaz",
			"rhsgref_cdf_reg_uaz_open",
			"rhsgref_cdf_gaz66_ammo",
			"rhsgref_cdf_gaz66_r142",
			"rhsgref_cdf_gaz66_ap2",
			"rhsgref_cdf_gaz66_repair",
			"rhsgref_cdf_ural_fuel",
			"rhsgref_cdf_ural_repair",
			"rhsgref_cdf_zil131_flatbed_cover",
			"rhsgref_cdf_zil131_flatbed",
			"rhsgref_ins_uaz",
			"rhsgref_ins_uaz_open",
			"rhsgref_ins_gaz66_ammo",
			"rhsgref_ins_gaz66_r142",
			"rhsgref_ins_gaz66_ap2",
			"rhsgref_ins_gaz66_repair",
			"rhsgref_ins_kraz255b1_cargo_open",
			"rhsgref_ins_ural_repair",
			"rhsgref_ins_zil131_flatbed",
			"rhsgref_nat_uaz",
			"rhsgref_nat_uaz_open"
		]; //transporte de tropas + log�stica

		SAC_UDS_O_G_insurgencyTraffic = ["RHS_Ural_Civ_01", "RHS_Ural_Civ_02", "RHS_Ural_Civ_03"];

		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + [
			"RHS_UAZ_MSV_01",
			"rhs_uaz_open_MSV_01",
			"rhs_gaz66_ammo_msv",
			"rhs_gaz66_r142_msv",
			"rhs_gaz66_ap2_msv",
			"rhs_gaz66_repair_msv",
			"rhs_kraz255b1_bmkt_msv",
			"rhs_kraz255b1_flatbed_msv",
			"rhs_kraz255b1_pmp_msv",
			"rhs_kraz255b1_fuel_msv",
			"RHS_Ural_Fuel_MSV_01",
			"RHS_Ural_Repair_MSV_01",
			"rhsgref_cdf_reg_uaz",
			"rhsgref_cdf_reg_uaz_open",
			"rhsgref_cdf_gaz66_ammo",
			"rhsgref_cdf_gaz66_r142",
			"rhsgref_cdf_gaz66_ap2",
			"rhsgref_cdf_gaz66_repair",
			"rhsgref_cdf_ural_fuel",
			"rhsgref_cdf_ural_repair",
			"rhsgref_cdf_zil131_flatbed_cover",
			"rhsgref_cdf_zil131_flatbed",
			"rhsgref_ins_uaz",
			"rhsgref_ins_uaz_open",
			"rhsgref_ins_gaz66_ammo",
			"rhsgref_ins_gaz66_r142",
			"rhsgref_ins_gaz66_ap2",
			"rhsgref_ins_gaz66_repair",
			"rhsgref_ins_kraz255b1_cargo_open",
			"rhsgref_ins_ural_repair",
			"rhsgref_ins_zil131_flatbed",
			"rhsgref_nat_uaz",
			"rhsgref_nat_uaz_open"
		];

		SAC_UDS_O_G_APC = [
			["rhs_btr60_msv",
			"rhsgref_cdf_btr60",
			"rhsgref_ins_btr60"],
			["rhs_btr70_msv",
			"rhsgref_cdf_btr70",
			"rhsgref_ins_btr70",
			"rhsgref_nat_btr70"],
			["rhs_btr80_msv",
			"rhsgref_cdf_btr80"],
			"rhs_btr80a_msv",
			["rhsgref_BRDM2_b",
			"rhsgref_BRDM2_ATGM_b",
			"rhsgref_BRDM2_ins",
			"rhsgref_BRDM2_ATGM_ins"]
		];

		SAC_UDS_O_G_IFV = [
			["rhs_bmp1_msv",
			"rhs_bmp1d_msv",
			"rhs_bmp1k_msv",
			"rhs_bmp1p_msv",
			"rhsgref_cdf_bmp1",
			"rhsgref_cdf_bmp1d",
			"rhsgref_cdf_bmp1k",
			"rhsgref_cdf_bmp1p",
			"rhsgref_ins_bmp1",
			"rhsgref_ins_bmp1d",
			"rhsgref_ins_bmp1k",
			"rhsgref_ins_bmp1p"],
			["rhs_bmp2e_msv",
			"rhs_bmp2_msv",
			"rhs_bmp2d_msv",
			"rhs_bmp2k_msv",
			"rhsgref_cdf_bmp2e",
			"rhsgref_cdf_bmp2",
			"rhsgref_cdf_bmp2d",
			"rhsgref_cdf_bmp2k",
			"rhsgref_ins_bmp2e",
			"rhsgref_ins_bmp2",
			"rhsgref_ins_bmp2d",
			"rhsgref_ins_bmp2k"]
		];

		SAC_UDS_O_G_Tanks = [
			["rhs_bmp3_msv",
			"rhs_bmp3_late_msv",
			"rhs_bmp3m_msv",
			"rhs_bmp3mera_msv"],
			["rhs_t72ba_tv",
			"rhs_t72bb_tv",
			"rhs_t72bc_tv",
			"rhs_t72bd_tv",
			"rhs_t72be_tv",
			"rhsgref_cdf_t72ba_tv",
			"rhsgref_cdf_t72bb_tv",
			"rhsgref_ins_t72ba",
			"rhsgref_ins_t72bb",
			"rhsgref_ins_t72bc"],
			["rhs_t80",
			"rhs_t80a",
			"rhs_t80bk",
			"rhs_t80bvk",
			"rhs_t80u",
			"rhs_t80u45m",
			"rhs_t80ue1",
			"rhs_t80uk",
			"rhs_t80um",
			"rhsgref_cdf_t80b_tv",
			"rhsgref_cdf_t80bv_tv"],
			"rhs_t90_tv",
			"rhs_sprut_vdv"
		];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "OP_BITING_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = ["LIB_Kfz1_MG42_sernyt"];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"LIB_Kfz1_Hood_sernyt",
			"LIB_OpelBlitz_Open_Y_Camo",
			"LIB_OpelBlitz_Tent_Y_Camo",
			"LIB_Kfz1_w",
			"LIB_Kfz1_Hood_w",
			"LIB_OpelBlitz_Tent_Y_Camo_w"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh;
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + ["LIB_OpelBlitz_Parm_w", "LIB_OpelBlitz_Fuel_w", "LIB_OpelBlitz_Ammo_w", "LIB_OpelBlitz_Ambulance_w"];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = [
			"fow_v_sdkfz_251_camo_foliage_ger_heer",
			"fow_v_sdkfz_251_camo_ger_heer",
			"LIB_SdKfz251_FFV_w",
			"LIB_Sdkfz251_w",
			"fow_v_sdkfz_250_camo_foliage_ger_heer",
			"fow_v_sdkfz_250_ger_heer"
		];
		SAC_UDS_O_G_IFV = [
			"fow_v_sdkfz_250_9_ger_heer",
			"fow_v_sdkfz_250_9_camo_foliage_ger_heer",
			"fow_v_sdkfz_234_1"
		];

		SAC_UDS_O_G_Tanks = [
			"LIB_StuG_III_G_WS_w",
			"LIB_SdKfz124",
			"LIB_PzKpfwIV_H_tarn51c",
			"LIB_FlakPanzerIV_Wirbelwind",
			"LIB_PzKpfwIV_H_w"
		];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "wehrmacht_w_44_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = ["LIB_Kfz1_MG42_sernyt"];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"LIB_Kfz1_Hood_sernyt",
			"LIB_OpelBlitz_Open_Y_Camo",
			"LIB_OpelBlitz_Tent_Y_Camo",
			"LIB_Kfz1_w",
			"LIB_Kfz1_Hood_w",
			"LIB_OpelBlitz_Tent_Y_Camo_w"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh;
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + ["LIB_OpelBlitz_Parm_w", "LIB_OpelBlitz_Fuel_w", "LIB_OpelBlitz_Ammo_w", "LIB_OpelBlitz_Ambulance_w"];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = [
			"fow_v_sdkfz_251_camo_foliage_ger_heer",
			"fow_v_sdkfz_251_camo_ger_heer",
			"LIB_SdKfz251_FFV_w",
			"LIB_Sdkfz251_w",
			"fow_v_sdkfz_250_camo_foliage_ger_heer",
			"fow_v_sdkfz_250_ger_heer"
		];
		SAC_UDS_O_G_IFV = [
			"fow_v_sdkfz_250_9_ger_heer",
			"fow_v_sdkfz_250_9_camo_foliage_ger_heer",
			"LIB_SdKfz_7_AA_w",
			"fow_v_sdkfz_234_1"
		];

		SAC_UDS_O_G_Tanks = [
			"LIB_FlakPanzerIV_Wirbelwind_w",
			"LIB_PzKpfwIV_H_w",
			"LIB_PzKpfwV_w",
			"LIB_PzKpfwVI_B_w",
			"LIB_PzKpfwVI_E_w",
			"LIB_StuG_III_G_w",
			"LIB_StuG_III_G_WS_w"
		];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "SS_44_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = [
			"LIB_Kfz1_MG42",
			"LIB_Kfz1_MG42_camo",
			"LIB_Kfz1_MG42_sernyt"
		];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"LIB_OpelBlitz_Tent_Y_Camo",
			"LIB_OpelBlitz_Open_Y_Camo"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = [
			"LIB_SdKfz251",
			"LIB_SdKfz251_FFV",
			"fow_v_sdkfz_250_camo_foliage_ger_heer",
			"fow_v_sdkfz_250_camo_ger_heer",
			"fow_v_sdkfz_251_camo_ger_heer",
			"fow_v_sdkfz_251_camo_foliage_ger_heer"
		];

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport;
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + ["LIB_OpelBlitz_Ambulance","LIB_OpelBlitz_Ammo","LIB_OpelBlitz_Fuel","LIB_OpelBlitz_Parm","LIB_SdKfz_7_Ammo"];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = SAC_UDS_O_G_armedTransport;

		SAC_UDS_O_G_IFV = [
			"fow_v_sdkfz_250_9_camo_foliage_ger_heer",
			"fow_v_sdkfz_250_9_camo_ger_heer",
			"fow_v_sdkfz_222_camo_ger_heer",
			"fow_v_sdkfz_222_camo_foliage_ger_heer",
			"fow_v_sdkfz_234_1"
		];

		SAC_UDS_O_G_Tanks = [
			"fow_v_panther_camo_foliage_ger_heer",
			"fow_v_panther_camo_ger_heer",
			"LIB_PzKpfwIV_H_tarn51c",
			"LIB_PzKpfwIV_H_tarn51d",
			"LIB_PzKpfwV",
			"LIB_PzKpfwVI_B_tarn51c",
			"LIB_PzKpfwVI_E",
			"LIB_PzKpfwVI_E_tarn52d",
			"LIB_SdKfz124",
			"LIB_StuG_III_G"
		];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "sov_w_39_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = ["NORTH_FIN_W_39_FordV8_Maxim_Quad"];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = ["LIB_Zis5v_w","NORTH_FIN_W_39_FordV8"];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_unarmedTransport;

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + ["NORTH_SOV_W_39_T20"];
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + ["LIB_Zis5v_med_w","LIB_Zis5v_fuel_w","LIB_Zis6_parm_w"];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = ["NORTH_SOV_W_39_T20"];

		SAC_UDS_O_G_IFV = ["NORTH_SOV_W_39_T20","NORTH_SOV_W_39_BA10"];

		SAC_UDS_O_G_Tanks = [
			"NORTH_SOV_W_39_T26_M33_OT",
			"NORTH_SOV_W_39_T26_M31",
			"NORTH_SOV_W_39_T26_M33",
			"NORTH_SOV_W_39_T26_M33com",
			"NORTH_SOV_W_39_T38"
		];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "sov_41_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = ["NORTH_FIN_41_FordV8_Maxim_Quad","NORTH_SOV_41_T20"];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = ["LIB_Zis5v"];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_unarmedTransport;

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + ["NORTH_SOV_41_T20"];
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + ["LIB_Zis5v_med","LIB_Zis5v_fuel","LIB_Zis6_parm"];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = ["NORTH_SOV_41_T20"];

		SAC_UDS_O_G_IFV = ["NORTH_SOV_41_T20","NORTH_SOV_41_BA6"];

		SAC_UDS_O_G_Tanks = [
			"NORTH_SOV_41_T26_M33_OT",
			"NORTH_SOV_41_T26_M31",
			"NORTH_SOV_41_T26_M33",
			"NORTH_SOV_41_T38",
			"NORTH_SOV_41_T26_M33_OT",
			"NORTH_SOV_41_BT7",
			"NORTH_SOV_41_BT7_M35"
		];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "wehrmacht_44_v_g": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = ["LIB_Kfz1_MG42", "LIB_Kfz1_MG42_sernyt"];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh + ["fow_v_kubelwagen_camo_ger_heer"];

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"LIB_OpelBlitz_Tent_Y_Camo","LIB_OpelBlitz_Open_Y_Camo","LIB_opelblitz_open_Tarn","LIB_opelblitz_tentB_Feldgrau","LIB_opelblitz_open_Feldgrau","fow_v_kubelwagen_camo_ger_heer","LIB_Kfz1_Hood_sernyt"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = [
			"LIB_SdKfz251_FFV","LIB_SdKfz251","fow_v_sdkfz_250_camo_foliage_ger_heer","fow_v_sdkfz_250_camo_ger_heer","fow_v_sdkfz_251_camo_ger_heer","fow_v_sdkfz_251_camo_foliage_ger_heer"
		];

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + ["NORTH_SOV_41_T20"];
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + ["LIB_OpelBlitz_Ambulance","LIB_OpelBlitz_Ammo","LIB_OpelBlitz_Fuel","LIB_OpelBlitz_Parm","LIB_ger_opelblitz_medical","LIB_ger_opelblitz_citerne"];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = SAC_UDS_O_G_armedTransport;

		SAC_UDS_O_G_IFV = ["fow_v_sdkfz_234_1","fow_v_sdkfz_222_camo_ger_heer","fow_v_sdkfz_222_camo_foliage_ger_heer"];

		SAC_UDS_O_G_Tanks = ["fow_v_panther_camo_foliage_ger_heer","LIB_PzKpfwIV_H_tarn51c","LIB_PzKpfwV","LIB_PzKpfwVI_E","LIB_PzKpfwVI_E_2","LIB_SdKfz124","LIB_StuG_III_G","LIB_PzKpfwIV_H_tarn51d"
		];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "DualaSacro_V_g": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = ["UK3CB_ADM_O_LR_M2","UK3CB_ADM_O_LR_SF_M2"];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"UK3CB_ADM_O_V3S_Open",
			"UK3CB_ADM_O_V3S_Closed",
			"UK3CB_ADM_O_Hilux_Closed"
			
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = [
			"UK3CB_ADM_O_LR_M2",
			"UK3CB_ADM_O_LR_SF_M2"
		];

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport;
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
			"UK3CB_ADM_O_V3S_Reammo",
			"UK3CB_ADM_O_V3S_Refuel",
			"UK3CB_ADM_O_V3S_Repair",
			"UK3CB_ADM_O_V3S_Recovery",
			"UK3CB_ADM_O_Van_Fuel"
		];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = [
			"UK3CB_ADM_O_MTLB_PKT",
			"UK3CB_ADM_O_MTLB_KPVT",
			"UK3CB_ADM_O_MTLB_BMP",
			"UK3CB_ADM_O_BTR40_MG"
		];

		SAC_UDS_O_G_IFV = SAC_UDS_O_G_APC;

		SAC_UDS_O_G_Tanks = [
			"UK3CB_ADM_O_T34",
			"UK3CB_ADM_O_T55"

		];

		SAC_UDS_O_G_transportHelicopter = [];

		SAC_UDS_O_G_attackHelicopter = [];

	};

	case "rus_chechenia_cold_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = ["UK3CB_CW_SOV_O_LATE_VDV_UAZ_MG", "UK3CB_CW_SOV_O_LATE_VDV_UAZ_SPG9"];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"RHS_Ural_VDV_01",
			"RHS_Ural_Open_VDV_01",
			"rhs_zil131_vdv",
			"rhs_zil131_open_vdv"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = ["rhsgref_BRDM2_HQ_vdv"];

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport + SAC_UDS_O_G_armedTransport;
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
			"rhs_gaz66_r142_vdv",
			"rhs_kraz255b1_bmkt_vdv",
			"rhs_kraz255b1_fuel_vdv",
			"RHS_Ural_Repair_VDV_01",
			"UK3CB_ARD_O_Ural_Ammo"
		];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = [
			"rhs_btr60_vdv",
			"rhs_btr70_vdv",
			"rhs_btr80_vdv"
		];

		SAC_UDS_O_G_IFV = ["rhs_bmd1", "rhs_bmp1_vdv"];

		SAC_UDS_O_G_Tanks = ["rhs_t80", "rhs_t90_tv", "rhs_t72ba_tv"];

		SAC_UDS_O_G_transportHelicopter = ["RHS_Mi8mt_vdv"];

		SAC_UDS_O_G_attackHelicopter = ["RHS_Mi8MTV3_heavy_vdv"];

	};

	case "MOG_uds_V_G": {

		//technicals (vehiculos sin blindaje con capacidad de fuego)
		SAC_UDS_O_G_patrolVeh = [
			"LOP_AFR_OPF_Landrover_M2",
			"LOP_AFR_OPF_Nissan_PKM",
			"rhsgref_ins_uaz_dshkm",
			"UK3CB_ADG_O_Datsun_Pkm",
			"UK3CB_ADM_O_Hilux_M2",
			"UK3CB_ADM_O_Hilux_Pkm",
			"UK3CB_ADM_O_Pickup_SPG9",
			"UK3CB_ADG_O_LR_M2_ISL",
			"LOP_AFR_OPF_Landrover_SPG9",
			"UK3CB_TKM_O_UAZ_SPG9"
		];

		//los vehiculos que usa el script de ambush para encerrar al jugador
		SAC_UDS_O_G_ambushVeh = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el modulo de refuerzos para llevar tropas al combate (cuando sale "INF_VEHICLE")
		SAC_UDS_O_G_unarmedTransport = [
			"UK3CB_ADA_O_V3S_Open",
			"UK3CB_ADA_O_Ural",
			"UK3CB_ADG_O_Ikarus_ISL",
			"UK3CB_ADG_O_V3S_Reammo_ISL",
			"UK3CB_ADG_O_Ural_Open_ISL",
			"UK3CB_ADG_O_Ikarus"
		];

		//los vehiculos que usa el modulo de refuerzos para el combate cuando sale "VEHICLE_NOARMOR"
		SAC_UDS_O_G_armedTransport = SAC_UDS_O_G_patrolVeh;

		//los vehiculos que usa el MTS
		SAC_UDS_O_G_trafficArmed = SAC_UDS_O_G_patrolVeh + SAC_UDS_O_G_unarmedTransport;
		//transporte de tropas + log�stica
		SAC_UDS_O_G_trafficUnarmed = SAC_UDS_O_G_unarmedTransport + [
			"UK3CB_ADA_O_Hilux_Closed",
			"UK3CB_ADA_O_LR_Open",
			"UK3CB_ADA_O_Pickup",
			"UK3CB_ADG_O_S1203_ISL",
			"UK3CB_ADG_O_S1203_Amb_ISL",
			"UK3CB_ADG_O_Landcruiser_ISL",
			"UK3CB_ADG_O_Skoda_ISL",
			"UK3CB_ADG_O_Sedan",
			"UK3CB_ADG_O_Lada_ISL",
			"UK3CB_ADG_O_Datsun_Civ_Open_ISL",
			"UK3CB_ADA_O_Ural_Repair",
			"UK3CB_ADA_O_Ural_Ammo",
			"UK3CB_ADA_O_Ural_Fuel",
			"UK3CB_ADA_O_M1030",
			"UK3CB_ADG_O_Gaz24_ISL",
			"UK3CB_ADG_O_Hatchback",
			"UK3CB_ADG_O_OLD_BIKE",
			"UK3CB_ADG_O_TT650",
			"UK3CB_ADG_O_YAVA"
		];

		//los vehiculos civiles que usa ITS para transitar de incognito, con algunos hombres armados que disparan si cruzan jugadores
		SAC_UDS_O_G_insurgencyTraffic = [
			"UK3CB_ADG_O_S1203_ISL",
			"UK3CB_ADG_O_Landcruiser_ISL",
			"UK3CB_ADG_O_Skoda_ISL",
			"UK3CB_ADG_O_Sedan",
			"UK3CB_ADG_O_Ikarus",
			"UK3CB_ADG_O_Lada_ISL",
			"UK3CB_ADG_O_Datsun_Civ_Open_ISL",
			"UK3CB_ADG_O_Gaz24_ISL",
			"UK3CB_ADG_O_Hatchback",
			"UK3CB_ADC_O_Lada_Taxi",
			"UK3CB_ADC_O_UAZ_Open"
		];

		//los vehiculos que se crean al lado de una casa cuando es ocupada (actualmente desactivado por las explosiones que genera :)
		SAC_UDS_O_G_garrisonVeh = SAC_UDS_O_G_patrolVeh;

		SAC_UDS_O_G_APC = [
			"UK3CB_ADA_O_BRDM2",
			"UK3CB_ADA_O_BRDM2_HQ"
		];

		SAC_UDS_O_G_IFV = SAC_UDS_O_G_APC;

		SAC_UDS_O_G_Tanks = ["UK3CB_ADA_O_T34"];

		SAC_UDS_O_G_transportHelicopter = ["RHS_Mi8mt_vdv"];

		SAC_UDS_O_G_attackHelicopter = ["RHS_Mi8MTV3_heavy_vdv"];

	};

	default {

		diag_log SAC_UDS_O_G_vehicleProfile;

	};

};

switch (SAC_UDS_C_vehicleProfile) do {

	case "BIS_CIV": {

		SAC_UDS_C_garrisonVeh = SAC_bis_civilian_logistic_vehicles + SAC_bis_civilian_transport_vehicles;

		SAC_UDS_C_trafficVeh = SAC_bis_civilian_logistic_vehicles + SAC_bis_civilian_transport_vehicles;

		SAC_UDS_C_VIPVeh = SAC_bis_civilian_transport_vehicles;

	};

	case "RDS_CIV_SOVIET": {

		SAC_UDS_C_garrisonVeh = ["RDS_Gaz24_Civ_03", "RDS_Gaz24_Civ_01", "RDS_Gaz24_Civ_02", "RDS_Golf4_Civ_01", "RDS_JAWA353_Civ_01", "RDS_S1203_Civ_01", "RDS_Octavia_Civ_01",
		"RDS_Zetor6945_Base", "RDS_Lada_Civ_01", "RDS_Lada_Civ_03", "RDS_Lada_Civ_02", "RDS_tt650_Civ_01"];

		SAC_UDS_C_trafficVeh = ["RDS_Gaz24_Civ_03", "RDS_Gaz24_Civ_01", "RDS_Gaz24_Civ_02", "RDS_Golf4_Civ_01", "RDS_JAWA353_Civ_01", "RDS_S1203_Civ_01", "RDS_Octavia_Civ_01",
		"RDS_Zetor6945_Base", "RDS_Lada_Civ_01", "RDS_Lada_Civ_03", "RDS_Lada_Civ_02", "RDS_tt650_Civ_01", "RDS_Ikarus_Civ_01", "RHS_Ural_Civ_01", "RHS_Ural_Civ_03", "RHS_Ural_Civ_02"];

		SAC_UDS_C_VIPVeh = ["RDS_Gaz24_Civ_03", "RDS_Gaz24_Civ_01", "RDS_Gaz24_Civ_02", "RDS_Golf4_Civ_01", "RDS_Octavia_Civ_01", "RDS_Lada_Civ_01", "RDS_Lada_Civ_03",
		"RDS_Lada_Civ_02"];

	};

	case "RDS_CIV_MIDDLE_EAST": {

		SAC_UDS_C_garrisonVeh = ["RDS_Gaz24_Civ_03", "RDS_Gaz24_Civ_01", "RDS_Gaz24_Civ_02", "RDS_Golf4_Civ_01", "RDS_JAWA353_Civ_01", "RDS_Octavia_Civ_01",
		"RDS_Lada_Civ_01", "RDS_Lada_Civ_03", "RDS_Lada_Civ_04", "RDS_Lada_Civ_02", "RDS_tt650_Civ_01"];

		SAC_UDS_C_trafficVeh = ["RDS_Gaz24_Civ_03", "RDS_Gaz24_Civ_01", "RDS_Gaz24_Civ_02", "RDS_Golf4_Civ_01", "RDS_JAWA353_Civ_01", "RDS_Octavia_Civ_01",
		"RDS_Lada_Civ_01", "RDS_Lada_Civ_03", "RDS_Lada_Civ_04", "RDS_Lada_Civ_02", "RDS_tt650_Civ_01", "RDS_Ikarus_Civ_02", "RHS_Ural_Civ_01", "RHS_Ural_Civ_03", "RHS_Ural_Civ_02"];

		SAC_UDS_C_VIPVeh = ["RDS_Gaz24_Civ_03", "RDS_Gaz24_Civ_01", "RDS_Gaz24_Civ_02", "RDS_Golf4_Civ_01", "RDS_Octavia_Civ_01", "RDS_Lada_Civ_01", "RDS_Lada_Civ_03",
		"RDS_Lada_Civ_02", "RDS_Lada_Civ_04"];

	};

	case "3CB_CIV_MIDDLE_EAST": {

		SAC_UDS_C_garrisonVeh = ["UK3CB_TKC_C_Datsun_Civ_Closed", "UK3CB_TKC_C_Datsun_Civ_Open", "UK3CB_TKC_C_Hatchback", "UK3CB_TKC_C_Hilux_Civ_Closed",
		"UK3CB_TKC_C_Hilux_Civ_Open", "UK3CB_TKC_C_Kamaz_Covered", "UK3CB_TKC_C_Kamaz_Fuel", "UK3CB_TKC_C_Kamaz_Open", "UK3CB_TKC_C_Kamaz_Repair",
		"UK3CB_TKC_C_Lada", "UK3CB_TKC_C_Lada_Taxi", "UK3CB_TKC_C_LR_Closed", "UK3CB_TKC_C_LR_Open", "UK3CB_TKC_C_V3S_Refuel", "UK3CB_TKC_C_V3S_Recovery",
		"UK3CB_TKC_C_V3S_Repair", "UK3CB_TKC_C_V3S_Closed", "UK3CB_TKC_C_Sedan", "UK3CB_TKC_C_Skoda", "UK3CB_TKC_C_S1203", "UK3CB_TKC_C_S1203_Amb",
		"UK3CB_TKC_C_UAZ_Closed", "UK3CB_TKC_C_UAZ_Open", "UK3CB_TKC_C_Ural", "UK3CB_TKC_C_Ural_Fuel", "UK3CB_TKC_C_Ural_Open", "UK3CB_TKC_C_Ural_Empty",
		"UK3CB_TKC_C_Ural_Recovery", "UK3CB_TKC_C_Ural_Repair", "UK3CB_TKC_C_Gaz24", "UK3CB_TKC_C_Golf", "UK3CB_TKC_C_Pickup"];

		SAC_UDS_C_trafficVeh = ["UK3CB_TKC_C_Ikarus", "UK3CB_TKC_C_Datsun_Civ_Closed", "UK3CB_TKC_C_Datsun_Civ_Open", "UK3CB_TKC_C_Hatchback", "UK3CB_TKC_C_Hilux_Civ_Closed",
		"UK3CB_TKC_C_Hilux_Civ_Open", "UK3CB_TKC_C_Kamaz_Covered", "UK3CB_TKC_C_Kamaz_Fuel", "UK3CB_TKC_C_Kamaz_Open", "UK3CB_TKC_C_Kamaz_Repair",
		"UK3CB_TKC_C_Lada", "UK3CB_TKC_C_Lada_Taxi", "UK3CB_TKC_C_LR_Closed", "UK3CB_TKC_C_LR_Open", "UK3CB_TKC_C_V3S_Refuel", "UK3CB_TKC_C_V3S_Recovery",
		"UK3CB_TKC_C_V3S_Repair", "UK3CB_TKC_C_V3S_Closed", "UK3CB_TKC_C_Sedan", "UK3CB_TKC_C_Skoda", "UK3CB_TKC_C_S1203", "UK3CB_TKC_C_S1203_Amb",
		"UK3CB_TKC_C_UAZ_Closed", "UK3CB_TKC_C_UAZ_Open", "UK3CB_TKC_C_Ural", "UK3CB_TKC_C_Ural_Fuel", "UK3CB_TKC_C_Ural_Open", "UK3CB_TKC_C_Ural_Empty",
		"UK3CB_TKC_C_Ural_Recovery", "UK3CB_TKC_C_Ural_Repair", "UK3CB_TKC_C_Gaz24", "UK3CB_TKC_C_Golf", "UK3CB_TKC_C_Pickup"];

		SAC_UDS_C_VIPVeh = ["UK3CB_TKC_C_LR_Closed"];

	};

	case "3CB_CIV_SOVIET": {

		SAC_UDS_C_garrisonVeh = ["UK3CB_CHC_C_Datsun_Civ_Closed", "UK3CB_CHC_C_Datsun_Civ_Open",
		"UK3CB_CHC_C_Hatchback", "UK3CB_CHC_C_Hilux_Civ_Closed", "UK3CB_CHC_C_Hilux_Civ_Open", "UK3CB_CHC_C_Kamaz_Covered",
		"UK3CB_CHC_C_Kamaz_Fuel", "UK3CB_CHC_C_Kamaz_Open", "UK3CB_CHC_C_Kamaz_Repair", "UK3CB_CHC_C_Lada", "UK3CB_CHC_C_LR_Closed",
		"UK3CB_CHC_C_LR_Open", "UK3CB_CHC_C_V3S_Refuel", "UK3CB_CHC_C_V3S_Recovery", "UK3CB_CHC_C_V3S_Repair", "UK3CB_CHC_C_V3S_Closed",
		"UK3CB_CHC_C_V3S_Open", "UK3CB_CHC_C_S1203", "UK3CB_CHC_C_S1203_Amb", "UK3CB_CHC_C_UAZ_Closed", "UK3CB_CHC_C_UAZ_Open",
		"UK3CB_CHC_C_Ural", "UK3CB_CHC_C_Ural_Fuel", "UK3CB_CHC_C_Ural_Open", "UK3CB_CHC_C_Ural_Empty", "UK3CB_CHC_C_Ural_Repair",
		"UK3CB_CHC_C_Gaz24", "UK3CB_CHC_C_Golf", "UK3CB_CHC_C_Pickup"];

		SAC_UDS_C_trafficVeh = ["UK3CB_CHC_C_Ikarus", "UK3CB_CHC_C_Datsun_Civ_Closed", "UK3CB_CHC_C_Datsun_Civ_Open",
		"UK3CB_CHC_C_Hatchback", "UK3CB_CHC_C_Hilux_Civ_Closed", "UK3CB_CHC_C_Hilux_Civ_Open", "UK3CB_CHC_C_Kamaz_Covered",
		"UK3CB_CHC_C_Kamaz_Fuel", "UK3CB_CHC_C_Kamaz_Open", "UK3CB_CHC_C_Kamaz_Repair", "UK3CB_CHC_C_Lada", "UK3CB_CHC_C_LR_Closed",
		"UK3CB_CHC_C_LR_Open", "UK3CB_CHC_C_V3S_Refuel", "UK3CB_CHC_C_V3S_Recovery", "UK3CB_CHC_C_V3S_Repair", "UK3CB_CHC_C_V3S_Closed",
		"UK3CB_CHC_C_V3S_Open", "UK3CB_CHC_C_S1203", "UK3CB_CHC_C_S1203_Amb", "UK3CB_CHC_C_UAZ_Closed", "UK3CB_CHC_C_UAZ_Open",
		"UK3CB_CHC_C_Ural", "UK3CB_CHC_C_Ural_Fuel", "UK3CB_CHC_C_Ural_Open", "UK3CB_CHC_C_Ural_Empty", "UK3CB_CHC_C_Ural_Repair",
		"UK3CB_CHC_C_Gaz24", "UK3CB_CHC_C_Golf", "UK3CB_CHC_C_Pickup"];

		SAC_UDS_C_VIPVeh = ["UK3CB_CHC_C_LR_Closed"];

	};

	case "3CB_CIV_AFRICA": {

		SAC_UDS_C_garrisonVeh = [
		"UK3CB_ADC_C_Ikarus",
		"UK3CB_ADC_C_Datsun_Civ_Closed",
		"UK3CB_ADC_C_Datsun_Civ_Open",
		"UK3CB_ADC_C_Hatchback",
		"UK3CB_ADC_C_Hilux_Civ_Closed",
		"UK3CB_ADC_C_Hilux_Civ_Open",
		"UK3CB_ADC_C_Kamaz_Covered",
		"UK3CB_ADC_C_Kamaz_Fuel",
		"UK3CB_ADC_C_Kamaz_Open",
		"UK3CB_ADC_C_Kamaz_Repair",
		"UK3CB_ADC_C_Lada_Taxi",
		"UK3CB_ADC_C_LR_Closed",
		"UK3CB_ADC_C_LR_Open",
		"UK3CB_ADC_C_Landcruiser",
		"UK3CB_ADC_C_Pickup",
		"UK3CB_ADC_C_V3S_Refuel",
		"UK3CB_ADC_C_V3S_Recovery",
		"UK3CB_ADC_C_V3S_Repair",
		"UK3CB_ADC_C_V3S_Open",
		"UK3CB_ADC_C_Sedan",
		"UK3CB_ADC_C_Skoda",
		"UK3CB_ADC_C_SUV",
		"UK3CB_ADC_C_TT650",
		"UK3CB_ADC_C_Ural",
		"UK3CB_ADC_C_Ural_Fuel",
		"UK3CB_ADC_C_Ural_Repair",
		"UK3CB_ADC_C_Gaz24",
		"UK3CB_ADC_C_Golf",
		"UK3CB_ADC_C_YAVA"
		];

		SAC_UDS_C_trafficVeh = SAC_UDS_C_garrisonVeh;

		SAC_UDS_C_VIPVeh = ["UK3CB_ADC_C_SUV"];

	};

	case "Chechenian_v_civ": {

		SAC_UDS_C_garrisonVeh = [
			"LOP_CHR_Civ_Ural",
			"LOP_CHR_Civ_Ural_open",
			"LOP_CHR_Civ_UAZ",
			"LOP_CHR_Civ_UAZ_Open",
			"UK3CB_CHC_C_Datsun_Civ_Closed",
			"UK3CB_CHC_C_Datsun_Civ_Open",
			"UK3CB_CHC_C_Hatchback",
			"UK3CB_CHC_C_Lada",
			"UK3CB_CHC_C_MMT",
			"UK3CB_CHC_C_Sedan",
			"UK3CB_CHC_C_Skoda",
			"UK3CB_CHC_C_S1203_Amb",
			"UK3CB_CHC_C_Tractor_Old",
			"UK3CB_CHC_C_YAVA",
			"UK3CB_CHC_C_Gaz24",
			"UK3CB_CHC_C_V3S_Reammo"
		];

		SAC_UDS_C_trafficVeh = SAC_UDS_C_garrisonVeh;

		SAC_UDS_C_VIPVeh = SAC_UDS_C_garrisonVeh;

	};

	case "MOG_v_civ": {

		SAC_UDS_C_garrisonVeh = [
			"UK3CB_ADG_O_S1203_ISL",
			"UK3CB_ADG_O_Landcruiser_ISL",
			"UK3CB_ADG_O_Skoda_ISL",
			"UK3CB_ADG_O_Sedan",
			"UK3CB_ADG_O_Ikarus",
			"UK3CB_ADG_O_Lada_ISL",
			"UK3CB_ADG_O_Datsun_Civ_Open_ISL",
			"UK3CB_ADA_O_M1030",
			"UK3CB_ADG_O_Gaz24_ISL",
			"UK3CB_ADG_O_Hatchback",
			"UK3CB_ADG_O_OLD_BIKE",
			"UK3CB_ADG_O_TT650",
			"UK3CB_ADG_O_YAVA",
			"UK3CB_ADC_O_Lada_Taxi",
			"UK3CB_ADC_O_UAZ_Open"
		];

		SAC_UDS_C_trafficVeh = SAC_UDS_C_garrisonVeh;

		SAC_UDS_C_VIPVeh = SAC_UDS_C_garrisonVeh;

	};

	case "syrian_army_altis_uds_v_civ": {

		SAC_UDS_C_garrisonVeh = [
			"C_Van_02_medevac_F",
			"UK3CB_C_Hilux_Ambulance",
			"UK3CB_C_Ikarus_RED",
			"C_Offroad_02_unarmed_F",
			"UK3CB_C_Lada",
			"UK3CB_C_Landcruiser",
			"UK3CB_C_MMT",
			"UK3CB_C_Octavia",
			"UK3CB_C_SUV",
			"UK3CB_C_TT650",
			"UK3CB_C_Golf",
			"UK3CB_C_YAVA"
		];

		SAC_UDS_C_trafficVeh = SAC_UDS_C_garrisonVeh;

		SAC_UDS_C_VIPVeh = SAC_UDS_C_garrisonVeh;

	};

	case "korea_50_summer_V_civ": {

		SAC_UDS_C_garrisonVeh = [
			"NORTH_SOV_R75",
			"LIB_GazM1",
			"LIB_GazM1_dirty",
			"NORTH_CIV_FordV8"
		];

		SAC_UDS_C_trafficVeh = SAC_UDS_C_garrisonVeh;

		SAC_UDS_C_VIPVeh = SAC_UDS_C_garrisonVeh;

	};

	case "rusia_2022_uds_v_civ": {

		SAC_UDS_C_garrisonVeh = [
			"C_Van_02_medevac_F",
			"CUP_C_Golf4_black_Civ",
			"C_Offroad_02_unarmed_F",
			"CUP_C_Pickup_unarmed_CIV",
			"C_Hatchback_01_F",
			"CUP_C_Octavia_CIV",
			"C_SUV_01_F",
			"C_Offroad_01_F",
			"C_Offroad_01_covered_F",
			"RHS_Ural_Civ_03",
			"CUP_C_Skoda_CR_CIV",
			"CUP_C_Skoda_White_CIV",
			"CUP_C_S1203_CIV_CR",
			"CUP_C_Datsun_Covered",
			"CUP_C_Datsun_Plain",
			"CUP_C_Datsun_Tubeframe",
			"CUP_C_Volha_CR_CIV",
			"CUP_C_Golf4_red_Civ",
			"CUP_O_Hilux_unarmed_CR_CIV",
			"CUP_C_Ikarus_Chernarus",
			"CUP_C_Bus_City_CRCIV",
			"CUP_C_SUV_CIV",
			"CUP_C_Lada_CIV",
			"LOP_CHR_Civ_Landrover",
			"LOP_CHR_Civ_Offroad",
			"LOP_CHR_Civ_UAZ",
			"LOP_CHR_Civ_UAZ_Open",
			"CUP_C_TT650_RU",
			"CUP_C_TT650_CIV",
			"CUP_C_TT650_TK_CIV"
		];

		SAC_UDS_C_trafficVeh = SAC_UDS_C_garrisonVeh;

		SAC_UDS_C_VIPVeh = SAC_UDS_C_garrisonVeh;

	};

	case "CUP_CIV": {

		SAC_UDS_C_garrisonVeh = [
			"CUP_C_Datsun",
			"CUP_C_Golf4_random_Civ",
			"CUP_C_Octavia_CIV",
			"CUP_C_Skoda_CR_CIV",
			"CUP_C_Datsun_Covered",
			"CUP_C_Datsun_Tubeframe",
			"CUP_C_Volha_CR_CIV",
			"CUP_O_Hilux_unarmed_CR_CIV",
			"CUP_C_Ikarus_Chernarus",
			"CUP_C_Bus_City_CRCIV",
			"CUP_C_SUV_CIV",
			"CUP_C_Ural_Civ_03",
			"CUP_C_Ural_Open_Civ_03",
			"CUP_C_Lada_CIV",
			"CUP_C_Ural_Open_Civ_01",
			"CUP_C_Ural_Civ_02",
			"CUP_C_Ural_Open_Civ_02",
			"CUP_C_LR_Transport_CTK",
			"CUP_C_V3S_Open_TKC",
			"CUP_C_V3S_Covered_TKC",
			"CUP_C_SUV_TK",
			"CUP_C_UAZ_Unarmed_TK_CIV",
			"CUP_C_UAZ_Open_TK_CIV",
			"CUP_C_Lada_GreenTK_CIV"
		];

		SAC_UDS_C_trafficVeh = SAC_UDS_C_garrisonVeh;

		SAC_UDS_C_VIPVeh = [
			"CUP_C_SUV_TK",
			"CUP_C_LR_Transport_CTK",
			"CUP_C_SUV_CIV",
			"CUP_C_Volha_CR_CIV",
			"CUP_C_Octavia_CIV"
		];

	};

	case "CIV_WW2_GRAL": {

		SAC_UDS_C_garrisonVeh = [
		"LIB_GazM1",
		"LIB_GazM1_dirty",
		"LIB_FRA_CitC4Ferme",
		"LIB_FRA_CitC4",
		"LIB_CIV_FFI_CitC4_2",
		"LIB_CIV_FFI_CitC4_3",
		"LIB_Zis5v_w"
		];

		SAC_UDS_C_trafficVeh = SAC_UDS_C_garrisonVeh;

		SAC_UDS_C_VIPVeh = [
		"LIB_GazM1",
		"LIB_CIV_FFI_CitC4_2"
		];

	};

};

switch (SAC_UDS_B_vehicleProfile) do {

	case "BIS_NATO": {

		SAC_UDS_B_unarmedTransport = SAC_bis_nato_atv_unarmed + SAC_bis_nato_transport;

		SAC_UDS_B_armedTransport = SAC_bis_nato_atv_armed;

		SAC_UDS_B_garrisonVeh = SAC_bis_nato_atv_unarmed + SAC_bis_nato_transport;

		SAC_UDS_B_APC = SAC_bis_nato_apcs;
		SAC_UDS_B_IFV = SAC_bis_nato_ifvs;

		SAC_UDS_B_Tanks = SAC_bis_nato_tanks;

		SAC_UDS_B_transportHelicopter = SAC_bis_nato_multirole_helicopters + SAC_bis_nato_transport_helicopters_unarmed + SAC_bis_nato_transport_helicopters_armed;

		SAC_UDS_B_attackHelicopter = SAC_bis_nato_attack_helicopters;

		//los usa COP para crear los UAV derribados/capturados
		SAC_UDS_B_bigUAVs = ["B_UAV_02_F", "B_UAV_02_CAS_F", "B_UGV_01_F"];

	};

	case "BIS_NATO_APEX": {

		SAC_UDS_B_unarmedTransport = SAC_bis_nato_pacific_atv_unarmed + SAC_bis_nato_pacific_transport;

		SAC_UDS_B_armedTransport = SAC_bis_nato_pacific_atv_armed;

		SAC_UDS_B_garrisonVeh = SAC_bis_nato_pacific_atv_unarmed + SAC_bis_nato_pacific_transport;

		SAC_UDS_B_APC = SAC_bis_nato_pacific_apcs;
		SAC_UDS_B_IFV = SAC_bis_nato_pacific_ifvs;

		SAC_UDS_B_Tanks = SAC_bis_nato_pacific_tanks;

		SAC_UDS_B_transportHelicopter = SAC_bis_nato_multirole_helicopters + SAC_bis_nato_transport_helicopters_unarmed + SAC_bis_nato_transport_helicopters_armed;

		SAC_UDS_B_attackHelicopter = SAC_bis_nato_attack_helicopters;

		SAC_UDS_B_bigUAVs = ["B_UAV_02_F", "B_UAV_02_CAS_F", "B_UGV_01_F"];

	};

};

switch (SAC_UDS_B_G_vehicleProfile) do {

	case "BIS_GUER": {

		SAC_UDS_B_G_garrisonVeh = SAC_bis_b_guerilla_atv_unarmed + SAC_bis_b_guerilla_transport;

		SAC_UDS_B_G_unarmedTransport = SAC_bis_b_guerilla_atv_unarmed + SAC_bis_b_guerilla_transport;

		SAC_UDS_B_G_armedTransport = SAC_bis_b_guerilla_atv_armed;

		SAC_UDS_B_G_APC = [];
		SAC_UDS_B_G_IFV = [];

		SAC_UDS_B_G_Tanks = [];

		SAC_UDS_B_G_transportHelicopter = [];

		SAC_UDS_B_G_attackHelicopter = [];

	};

};

//Los perfiles de armas eligen elementos diferentes seg�n esta variable.
//Le doy un valor por defecto si no est� definida en la mision.
if (isNil "SAC_UDS_weaponColor") then {

	SAC_UDS_weaponColor = "BLACK";
	"Warning: SAC_UDS_weaponColor is not defined. Defaulting to BLACK." call SAC_fnc_MPhintC;


} else {

	if !(SAC_UDS_weaponColor in ["BLACK", "SAND", "KHAKI"]) then {

		SAC_UDS_weaponColor = "BLACK";
		"Warning: SAC_UDS_weaponColor has an invalid value. Defaulting to BLACK." call SAC_fnc_MPhintC;

	};


};
