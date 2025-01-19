aux = {
	params["_flag"];

	_array_a = ["a_0","a_1","a_2","a_3","a_4","a_5","a_6","a_7","a_8","a_9"];
	_array_b = ["b_0","b_1","b_2","b_3","b_4","b_5","b_6","b_7","b_8","b_9"];
	_array_c = ["c_0","c_1","c_2","c_3","c_4","c_5","c_6","c_7","c_8","c_9"];
	//_array_d = ["d_0","d_1","d_2","d_3","d_4","d_5","d_6","d_7","d_8","d_9"];
	//_array_e = ["e_0","e_1","e_2","e_3","e_4","e_5","e_6","e_7","e_8","e_9"];

	_fullArray = _array_a + _array_b + _array_c;// + _array_d + _array_e;

	while {alive _flag} do {
		_array_shuffle_1 = _fullArray call BIS_fnc_arrayShuffle;
		_array_shuffle_2 = _fullArray call BIS_fnc_arrayShuffle;
		_array_shuffle_3 = _fullArray call BIS_fnc_arrayShuffle;
		_array_shuffle_4 = _fullArray call BIS_fnc_arrayShuffle;

		sleep 1;
		[_array_shuffle_1, "Sh_155mm_AMOS", 1, 3] spawn SAC_fnc_artilleryAttack;
		sleep 1.5;
		[_array_shuffle_2, "Sh_155mm_AMOS", 1, 3] spawn SAC_fnc_artilleryAttack;
		sleep 2;
		[_array_shuffle_3, "Sh_155mm_AMOS", 1, 3] spawn SAC_fnc_artilleryAttack;
		sleep 2.5;
		[_array_shuffle_4, "Sh_155mm_AMOS", 1, 3] spawn SAC_fnc_artilleryAttack;

		sleep 60;
	};
};

give_asianFace = {
	params["_player"];

	_face = selectRandom ["AsianHead_A3_05",
		"LIB_AsianHead_02_Dirt",
		"LIB_AsianHead_02_Camo",
		"AsianHead_A3_02",
		"AsianHead_A3_04",
		"LIB_AsianHead_03_Camo",
		"LIB_AsianHead_03_Dirt",
		"AsianHead_A3_03",
		"AsianHead_A3_07",
		"AsianHead_A3_01",
		"LIB_AsianHead_01_Dirt",
		"LIB_AsianHead_01_Camo"];

	[_player,_face,"ace_novoice"] call BIS_fnc_setIdentity; 
};

give_basicEquipment = {
	params ["_player"];

	removeAllItems _player;
	removeAllAssignedItems _player;

	for "_i" from 1 to 8 do {_player addItemToUniform "ACE_packingBandage";};
	for "_i" from 1 to 6 do {_player addItemToUniform "ACE_elasticBandage";};
	for "_i" from 1 to 6 do {_player addItemToUniform "ACE_quikclot";};
	for "_i" from 1 to 4 do {_player addItemToUniform "ACE_fieldDressing";};
	_player addItemToUniform "ACE_EarPlugs";
	for "_i" from 1 to 2 do {_player addItemToUniform "ACE_tourniquet";};
	for "_i" from 1 to 2 do {_player addItemToUniform "kat_PainkillerItem";};
	_player addItemToUniform "ACE_plasmaIV_500";
	for "_i" from 1 to 2 do {_player addItemToUniform "kat_chestSeal";};
	for "_i" from 1 to 2 do {_player addItemToUniform "ACE_splint";};

	_player linkItem "ItemMap";
	_player linkItem "ItemCompass";
	_player linkItem "ItemWatch";
};

give_backPack = {
	params ["_player"];

	_player addBackpack selectRandom [
		"B_simc_USMC_M41_OD7",
		"B_simc_USMC_M41_OD7_M10",
		"B_simc_USMC_M41_OD7_M10_nife",
		"B_simc_USMC_M41_OD7_nife",
		"B_simc_USMC_M41_Roll3_OD7",
		"B_simc_USMC_M41_Roll_OD7",
		"B_simc_USMC_M41_Roll3_OD7",
		"B_simc_USMC_M41_M10_Roll_OD7"
	];

	sleep 0.5;

	for "_i" from 1 to 2 do {_player addItemToBackpack "fow_e_mk2";};
	for "_i" from 1 to 3 do {_player addItemToBackpack "SmokeShell";};
};

give_basicUniform = {
	params["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;

	sleep 0.5;

	_player forceAddUniform selectRandom [
		"U_Simc_mcparca",
		"U_Simc_mcparca_legging",
		"U_Simc_mcparca_snew",
		"U_Simc_mcparca_snew_alt"
	];
	sleep 0.5;
	[_player] spawn give_basicEquipment;
	[_player] spawn give_backPack;

	_player addHeadgear selectRandom [
		"H_Simc_M1_Helmet_Chad_w","H_Simc_M1_Helmet_Dzeep_w",
		"H_Simc_M1_Helmet_os_w","H_Simc_M1_Helmet_w",
		"H_Simc_M1_Helmet_Cover_2_w","H_Simc_M1_Helmet_Cover_w"
	];

	_player addGoggles selectRandom [
		"","",
		"G_Nomex_scharf","G_Nomex_scharf",
		"G_Scharf"
	];
};

give_riflemanVest = {
	params ["_player"];

	removeVest _player;
	sleep 0.5;

	_player addVest selectRandom [
		"V_Simc_USMC_Vest_Cartridge_GP_OD7",
		"V_Simc_USMC_Vest_Cartridge_nife_od7",
		"V_Simc_USMC_Vest_Cartridge_canteen_transgender",
		"V_Simc_USMC_Vest_Cartridge_nife_jfak",
		"V_Simc_USMC_Vest_Cartridge_GP",
		"V_Simc_USMC_Vest_Cartridge_nife",
		"V_Simc_USMC_Vest_Cartridge_canteen"
	];

	// if (goggles _player == "") then {
	// 	if (random 1 < 0.6) then {
	// 		_player addGoggles selectRandom [
	// 			"G_simc_US_Bandoleer","G_simc_US_Bandoleer_2","G_simc_US_Bandoleer_3","G_simc_US_Bandoleer_left","G_simc_US_Bandoleer_right"
	// 		];
	// 	};
	// };
	_player linkItem selectRandom [
		"bandolier_addon","bandolier_addon_left",
		"bandolier_addon_left_ligt","bandolier_addon_ligt",
		"bandolier_addon_mix","bandolier_addonr_right",
		"bandolier_addonr_right_ligt"
	];
};

give_smgVest = {
	params ["_player"];

	removeVest _player;
	sleep 0.5;

	_player addVest selectRandom [
		"V_Simc_USMC_Vest_SMG_OD7_sekop",
		"V_Simc_USMC_Vest_SMG_OD7",
		"V_Simc_USMC_Vest_SMG_sekop",
		"V_Simc_USMC_Vest_SMG_sekop_GP",
		"V_Simc_USMC_Vest_smg"
	];
};

give_smgVest_sideArm = {
	params ["_player"];

	removeVest _player;
	sleep 0.5;

	_player addVest "V_Simc_USMC_Vest_SMG_45";
};

give_carabineVest = {
	params ["_player"];

	removeVest _player;
	sleep 0.5;

	_player addVest selectRandom [
		"V_Simc_USMC_Vest_Carbine_sekop_OD7",
		"V_Simc_USMC_Vest_Carbine_sekop_43",
		"V_Simc_USMC_Vest_Carbine_jfak",
		"V_Simc_USMC_Vest_Carbine_eng"
	];
};

give_carabineVest_sideArm = {
	params ["_player"];

	removeVest _player;
	sleep 0.5;

	_player addVest selectRandom [
		"V_Simc_US_Vest_Carbine_45_jfak",
		"V_Simc_USMC_Vest_Carbine_45"
	];
};

give_barVest = {
	params ["_player"];

	removeVest _player;
	sleep 0.5;

	_player addVest selectRandom [
		"V_Simc_USMC_Vest_bar",
		"V_Simc_USMC_Vest_bar_jfak",
		"V_Simc_USMC_Vest_bar_sekop",
		"V_Simc_USMC_Vest_bar_sekop_43"
	];
	
	_player linkItem selectRandom [
		"bandolier_addon_BAR","bandolier_addon_BAR_left"
	];
};

give_m1Garand_if = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_riflemanVest;

	sleep 1;

	_player addWeapon "LIB_M1_Garand";
	_player addPrimaryWeaponItem "LIB_8Rnd_762x63_t";
	_player addItemToVest "LIB_ACC_M1_Bayo";
	for "_i" from 1 to 8 do { _player addItemToVest "LIB_8Rnd_762x63_t"; };
};

give_springfield_if = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_riflemanVest;

	sleep 1;

	_player addWeapon "LIB_M1903A3_Springfield";
	_player addPrimaryWeaponItem "LIB_5Rnd_762x63";
	_player addItemToVest "LIB_ACC_M1_Bayo";
	for "_i" from 1 to 10 do { _player addItemToVest "LIB_5Rnd_762x63"; };
};

give_springfield_fow = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_riflemanVest;

	sleep 1.5;

	_player addWeapon "fow_w_m1903A1";
	_player addPrimaryWeaponItem "fow_5Rnd_762x63";
	_player addItemToVest "LIB_ACC_M1_Bayo";
	for "_i" from 1 to 10 do { _player addItemToVest "fow_5Rnd_762x63"; };
};

give_m1Carbine_if = {
	params ["_player", "_role"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	switch (_role) do {
		case "1": { 
			_player spawn give_carabineVest_sideArm;
		};
		default { _player spawn give_carabineVest; };
	};

	sleep 1.5;

	_player addWeapon "LIB_M1_Carbine";
	_player addPrimaryWeaponItem "LIB_15Rnd_762x33_t";
	for "_i" from 1 to 10 do { _player addItemToVest "LIB_15Rnd_762x33_t"; };
};

give_m1Carbine_fow = {
	params ["_player", "_role"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	switch (_role) do {
		case "1": { 
			_player spawn give_carabineVest_sideArm;
		};
		default { _player spawn give_carabineVest; };
	};

	sleep 1.5;

	_player addWeapon "fow_w_m1_carbine";
	_player addPrimaryWeaponItem "fow_15Rnd_762x33";
	for "_i" from 1 to 10 do { _player addItemToVest "fow_15Rnd_762x33"; };
};

give_shotgun = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_carabineVest;

	sleep 1.5;

	_player addWeapon "fow_w_M1912";
	_player addPrimaryWeaponItem "fow_6Rnd_12G_Pellets";
	_player addItemToVest "fow_w_acc_M1897_bayo";
	for "_i" from 1 to 10 do { _player addItemToVest "fow_6Rnd_12G_Pellets"; };
};

give_thompson_if = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_smgVest_sideArm;
	sleep 1.5;
	_player addWeapon "LIB_M1A1_Thompson";
	_player addPrimaryWeaponItem "LIB_30Rnd_45ACP";
	for "_i" from 1 to 5 do { _player addItemToVest "LIB_30Rnd_45ACP"; };
};

give_thompson_fow = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_smgVest_sideArm;
	sleep 1.5;
	_player addWeapon "fow_w_m1a1_thompson";
	_player addPrimaryWeaponItem "fow_30Rnd_45acp";
	for "_i" from 1 to 5 do { _player addItemToVest "fow_30Rnd_45acp"; };
};

give_smg_if = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_smgVest;
	sleep 1.5;
	
	_player addWeapon "LIB_M3_GreaseGun";
	_player addPrimaryWeaponItem "LIB_30Rnd_45ACP";
	for "_i" from 1 to 5 do { _player addItemToVest "LIB_30Rnd_45ACP"; };
};

give_smg_fow = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_smgVest;
	sleep 1.5;

	_player addWeapon "fow_w_m3";
	_player addPrimaryWeaponItem "fow_30Rnd_45acp";
	for "_i" from 1 to 5 do { _player addItemToVest "fow_30Rnd_45acp"; };
};

give_sniper_if = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_riflemanVest;
	sleep 1.5;
	
	_player addWeapon "LIB_M1903A4_Springfield";
	_player addPrimaryWeaponItem "LIB_5Rnd_762x63";
	for "_i" from 1 to 5 do { _player addItemToVest "LIB_5Rnd_762x63"; };
};

give_sniper_fow = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_riflemanVest;
	sleep 1.5;
	
	_player addWeapon "fow_w_m1903A1_sniper";
	_player addPrimaryWeaponItem "fow_5Rnd_762x63";
	for "_i" from 1 to 5 do { _player addItemToVest "fow_5Rnd_762x63"; };
};

give_flamethrower = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_carabineVest_sideArm;
	sleep 1.5;
	
	_player addWeapon "M2_Flamethrower_01_F";
	_player addPrimaryWeaponItem "M2_Fuel_Tank";
	for "_i" from 1 to 1 do { _player addItemToBackpack "M2_Fuel_Tank"; };

	sleep 0.5;
	_player addWeapon "LIB_Colt_M1911";
	_player addPrimaryWeaponItem "LIB_7Rnd_45ACP";
	for "_i" from 1 to 3 do { _player addItemToVest "LIB_7Rnd_45ACP"; };

	removeBackpack _player;
	_player addBackpack "M2_Flamethrower_Balloons_Pipe";
	_player addGoggles "G_SWDG_Face";
	_player linkItem "nomex_addon";
};

give_AT = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	removeBackpack _player;
	sleep 1;
	_player addBackpack "B_simc_USMC_M41_rocketbag";
	sleep 1.5;
	_player addWeapon "LIB_M1A1_Bazooka";
	_player addSecondaryWeaponItem "LIB_1Rnd_60mm_M6";
	for "_i" from 1 to 2 do {_player addItemToBackpack "LIB_1Rnd_60mm_M6";};
};

give_HMG = {
	params ["_player"];

	_player addWeapon "LIB_Colt_M1911";
	_player addHandgunItem "LIB_7Rnd_45ACP";
	_player addWeapon "NORTH_SOV_Maxim_Gun_Bag_Lnr";

	_player addItemToVest "NORTH_200Rnd_762mm_Maxim_Inf";
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_200Rnd_762mm_Maxim_Inf";};
	
	sleep 0.5;

	_player addAction[
		"desplegar MG",
		{
			[5, [], {
				player removeWeapon "NORTH_SOV_Maxim_Gun_Bag_Lnr";

				_maxim = "NORTH_FIN_S_Maxim_41" createVehicle position player;
				_maxim setPos position player;

				_maxim addAction [ 
					"desmontar", 
					{ 
						[5, [], { }, {hint "Failure!"}, "Desmontando"] call ace_common_fnc_progressBar;
						sleep 5;
						player addWeapon "NORTH_SOV_Maxim_Gun_Bag_Lnr";
						deleteVehicle (_this select 0);
					} 
				];
			}, {hint "Failure!"}, "Desplegando"] call ace_common_fnc_progressBar;
		},nil,1.5,true,true,"","_target == _this",5,false,"",""
	];

};

give_M1919_fow = {
	params ["_player"];

	_player addWeapon "LIB_Colt_M1911";
	_player addHandgunItem "LIB_7Rnd_45ACP";

	removeVest _player;
	sleep 0.5;

	_player addVest "V_Simc_US_Vest_medic";
	_player addWeapon "fow_w_m1919a6";
	_player addPrimaryWeaponItem "fow_50Rnd_762x63";
	for "_i" from 1 to 2 do { _player addItemToVest "fow_50Rnd_762x63"; };
};

give_M1919_if = {
	params ["_player"];

	_player addWeapon "LIB_Colt_M1911";
	_player addHandgunItem "LIB_7Rnd_45ACP";

	removeVest _player;
	sleep 0.5;

	_player addVest "V_Simc_US_Vest_medic";
	_player addWeapon "LIB_M1919A6";
	_player addPrimaryWeaponItem "LIB_50Rnd_762x63";
	for "_i" from 1 to 2 do { _player addItemToVest "LIB_50Rnd_762x63"; };
};

give_HMG_bipod = {
	params ["_player"];

	_player addWeapon "NORTH_Maxim_Tripod_Bag_Lnr";

	for "_i" from 1 to 2 do {_player removeItemFromBackpack "fow_e_mk2";};
	for "_i" from 1 to 3 do {_player removeItemFromBackpack "SmokeShell";};

	sleep 1.5;

	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_200Rnd_762mm_Maxim_Inf";};

	_player linkItem selectRandom [
		"fow_i_nvg_GER_ammo_belt",
		"fow_i_nvg_GER_ammoboxes"
	];
};

give_bar_fow = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_barVest;
	sleep 1.5;
	
	_player addWeapon "fow_w_m1918a2_bak";
	_player addPrimaryWeaponItem "fow_w_acc_m1918a2_handle";
	_player addPrimaryWeaponItem "fow_20Rnd_762x63";
	_player addPrimaryWeaponItem "fow_w_acc_m1918a2_bipod";
	for "_i" from 1 to 8 do { _player addItemToVest "fow_20Rnd_762x63"; };
};

give_bar_if = {
	params ["_player"];

	_pWeap = primaryWeapon _player;
	if (_pWeap != "") then { _player removeWeapon _pWeap; };

	_player spawn give_barVest;
	sleep 1.5;
	
	_player addWeapon "LIB_M1918A2_BAR";
	_player addPrimaryWeaponItem "LIB_M1918A2_BAR_Handle";
	_player addPrimaryWeaponItem "LIB_20Rnd_762x63";
	_player addPrimaryWeaponItem "LIB_M1918A2_BAR_Bipod";
	for "_i" from 1 to 8 do { _player addItemToVest "LIB_20Rnd_762x63"; };
};

// ---------------

dressAs_srg = {
	params ["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;

	sleep 0.5;
	removeHeadgear _player;
	sleep 1.5;
	_player addHeadgear selectRandom [
		"H_Simc_M1_Helmet_Offizer_w",
		"H_Simc_M1_Helmet_Net_Offizer_late_w",
		"H_Simc_M1_Helmet_Net_Offizer_w"
	];

	removeGoggles _player;

	_player addWeapon "LIB_Colt_M1911";
	_player addHandgunItem "LIB_7Rnd_45ACP";
	_player addWeapon "LIB_Binocular_US";
	_player addItemToBackpack "ZSN_TrenchWhistle";
	_player addGoggles selectRandom ["G_mapcase","G_mapcase_od7"];
};

dressAs_cabo = {
	params ["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;

	sleep 0.5;
	removeHeadgear _player;
	sleep 1.5;
	_player addHeadgear selectRandom [
		"H_Simc_M1_Helmet_Net_NCO_late_w",
		"H_Simc_M1_Helmet_Net_NCO_w",
		"H_Simc_M1_Helmet_NCO_w"
	];

	_player addItemToBackpack "ZSN_TrenchWhistle";
};

dressAs_sld = {
	params ["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;
};

dessAs_medic = {
	params ["_player", "_gun"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;
	sleep 1.5;
	removeHeadgear _player;
	sleep 1.5;
	_player addHeadgear "H_Simc_M1_Helmet_med_w";

	removeGoggles _player;
	_player addGoggles "G_NORTH_FIN_Medicalarmband";
	_player addVest selectRandom [
		"V_Simc_US_Vest_medic",
		"V_Simc_US_Vest_medic_od7"
	];

	removeBackpack _player;
	sleep 2;
	[_player] spawn give_backPack;

	sleep 1.5;

	for "_i" from 1 to 8 do {_player addItemToUniform "ACE_packingBandage";};
	for "_i" from 1 to 6 do {_player addItemToUniform "ACE_elasticBandage";};
	for "_i" from 1 to 6 do {_player addItemToUniform "ACE_quikclot";};
	for "_i" from 1 to 4 do {_player addItemToUniform "ACE_fieldDressing";};
	for "_i" from 1 to 2 do {_player addItemToUniform "ACE_tourniquet";};
	_player addItemToUniform "ACE_EarPlugs";
	for "_i" from 1 to 2 do {_player addItemToUniform "kat_PainkillerItem";};
	for "_i" from 1 to 2 do {_player addItemToUniform "kat_chestSeal";};
	for "_i" from 1 to 2 do {_player addItemToUniform "ACE_splint";};
	_player addItemToUniform "ACE_plasmaIV_500";
	for "_i" from 1 to 20 do {_player addItemToVest "ACE_packingBandage";};
	for "_i" from 1 to 5 do {_player addItemToVest "ACE_quikclot";};
	for "_i" from 1 to 10 do {_player addItemToVest "ACE_elasticBandage";};
	for "_i" from 1 to 5 do {_player addItemToVest "ACE_fieldDressing";};
	for "_i" from 1 to 2 do {_player addItemToVest "ACE_plasmaIV_500";};
	for "_i" from 1 to 2 do {_player addItemToVest "ACE_salineIV_500";};
	for "_i" from 1 to 12 do {_player addItemToBackpack "kat_IV_16";};
	_player addItemToBackpack "kat_accuvac";
	_player addItemToBackpack "kat_pocketBVM";
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_guedel";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "kat_EACA";};
	for "_i" from 1 to 6 do {_player addItemToBackpack "ACE_epinephrine";};
	_player addItemToBackpack "kat_stethoscope";
	for "_i" from 1 to 4 do {_player addItemToBackpack "ACE_splint";};
	for "_i" from 1 to 8 do {_player addItemToBackpack "kat_ketamine";};
	for "_i" from 1 to 6 do {_player addItemToBackpack "kat_aatKit";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "KAT_Empty_bloodIV_500";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "KAT_Empty_bloodIV_250";};
	_player addItemToBackpack "ACE_surgicalKit";
	for "_i" from 1 to 6 do {_player addItemToBackpack "ACE_morphine";};
	for "_i" from 1 to 6 do {_player addItemToBackpack "kat_naloxone";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_nitroglycerin";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_norepinephrine";};
	_player addItemToBackpack "kat_Pulseoximeter";
	for "_i" from 1 to 2 do {_player addItemToBackpack "ACE_salineIV_500";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "ACE_plasmaIV_500";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "kat_chestSeal";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_larynx";};
	_player addItemToBackpack "kat_oxygenTank_300_Item";
	for "_i" from 1 to 3 do {_player addItemToBackpack "kat_CarbonateItem";};
	for "_i" from 1 to 17 do {_player addItemToBackpack "ACE_packingBandage";};
	for "_i" from 1 to 5 do {_player addItemToBackpack "ACE_elasticBandage";};
	for "_i" from 1 to 5 do {_player addItemToBackpack "ACE_quikclot";};

	sleep 0.5;

	switch (_gun) do {
		case "m1": { 
			_player addWeapon "LIB_M1_Garand";
			_player addPrimaryWeaponItem "LIB_8Rnd_762x63_t";
			_player addItemToVest "LIB_ACC_M1_Bayo";
			for "_i" from 1 to 8 do { _player addItemToVest "LIB_8Rnd_762x63_t"; };
		};
		case "carbine_if": { 
			_player addWeapon "LIB_M1_Carbine";
			_player addPrimaryWeaponItem "LIB_15Rnd_762x33_t";
			for "_i" from 1 to 10 do { _player addItemToVest "LIB_15Rnd_762x33_t"; };
		};
		case "carbine_fow": { 
			_player addWeapon "fow_w_m1_carbine";
			_player addPrimaryWeaponItem "fow_15Rnd_762x33";
			for "_i" from 1 to 10 do { _player addItemToVest "fow_15Rnd_762x33"; };
		};
		case "smg": { 
			_player addWeapon "fow_w_m55_reising";
			_player addPrimaryWeaponItem "fow_20Rnd_45acp";
			for "_i" from 1 to 5 do { _player addItemToVest "fow_20Rnd_45acp"; };
		};
		default { };
	};
};

dressAs_paraMedic = {
	params ["_player"];

	[_player] spawn dressAs_sld;
	sleep 0.5;
	removeHeadgear _player;
	sleep 1.5;
	_player addHeadgear "H_Simc_M1_Helmet_med_w";
	removeGoggles _player;
	_player addGoggles "G_NORTH_FIN_Medicalarmband";
	sleep 1.5;

	for "_i" from 1 to 14 do {_player addItemToBackpack "kat_IV_16";};
	_player addItemToBackpack "kat_pocketBVM";
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_guedel";};
	for "_i" from 1 to 10 do {_player addItemToBackpack "ACE_epinephrine";};
	for "_i" from 1 to 10 do {_player addItemToBackpack "ACE_morphine";};
	_player addItemToBackpack "kat_stethoscope";
	for "_i" from 1 to 4 do {_player addItemToBackpack "ACE_splint";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_ketamine";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_aatKit";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "KAT_Empty_bloodIV_250";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "KAT_Empty_bloodIV_500";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_norepinephrine";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "kat_Pulseoximeter";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "ACE_plasmaIV_500";};
	for "_i" from 1 to 5 do {_player addItemToBackpack "kat_chestSeal";};
	for "_i" from 1 to 6 do {_player addItemToBackpack "kat_larynx";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_vacuum";};
	for "_i" from 1 to 10 do {_player addItemToBackpack "ACE_elasticBandage";};
	for "_i" from 1 to 10 do {_player addItemToBackpack "ACE_packingBandage";};
	for "_i" from 1 to 10 do {_player addItemToBackpack "ACE_quikclot";};
	_player addItemToBackpack "kat_Painkiller";
	for "_i" from 1 to 2 do {_player addItemToBackpack "kat_Carbonate";};

};

dressAs_AT_ass = {
	params ["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;
	sleep 0.5;
	removeBackpack _player;
	sleep 1.5;
	_player addBackpack "B_simc_USMC_M41_rocketbag";
	for "_i" from 1 to 2 do {_player addItemToBackpack "LIB_1Rnd_60mm_M6";};
};

dressAs_HMG_v2 = {
	params ["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;
};

dressAs_HMG_asst_v2 = {
	params ["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;

	_player linkItem selectRandom [
		"fow_i_nvg_GER_ammo_belt","fow_i_nvg_GER_ammoboxes"
	];
};

dressAs_HMG = {
	params ["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;
	sleep 0.5;
	_player spawn give_HMG;
};

dressAs_HMG_ass = {
	params ["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;
	sleep 2;
	_player spawn give_HMG_bipod;
	_player linkItem selectRandom [
		"fow_i_nvg_GER_ammo_belt",
		"fow_i_nvg_GER_ammoboxes"
	];
};

dressAs_AR_ass = {
	params ["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;
	sleep 0.5;

	_player linkItem selectRandom [
		"bandolier_addon_BAR","bandolier_addon_BAR_left"
	];
};

dressAs_eng = {
	params ["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;
	sleep 0.5;

	[_player] spawn give_basicUniform;
	sleep 1.5;
	removeHeadgear _player;
	sleep 1.5;
	_player addHeadgear "H_Simc_M1_Helmet_SWDG_w";

	_player addItemToBackpack "ACE_DefusalKit";
	_player addItemToBackpack "ACE_LIB_FireCord";
	_player addItemToBackpack "NORTH_Kasapanos4kg_mag";
	for "_i" from 1 to 7 do {_player addItemToBackpack "LIB_Ladung_Small_MINE_mag";};

	removeGoggles _player;
	_player addGoggles "G_SWDG_Face";
};

dressAs_RO = {
	params ["_player"];

	[_player] spawn dressAs_sld;

	sleep 0.5;

	removeBackpack _player;

	sleep 1.5;

	_player addBackpack "B_LIB_US_Radio";
};