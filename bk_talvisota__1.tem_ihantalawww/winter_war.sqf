// BACKPACKS
BACKPACK_SLD = [
	"NORTH_fin_BreadBag",
	"NORTH_fin_BreadBag2",
	"NORTH_fin_BreadBag3",
	"NORTH_fin_GasmaskBag",
	"NORTH_fin_GasmaskBag",
	"NORTH_SOV_Gasmaskbag"
];

BACKPACK_ENG = [
	"NORTH_fin_Sipuli"
];

BACKPACK_MG = [
	"NORTH_fin_LS26Bag"
];

BACKPACK_MED = [
	"NORTH_fin_MedicNCOBag"
];

BACKPACK_RO = [
	"NORTH_fin_Kyynel"
];

BACKPACK_FL = [
	"41_Flammenwerfer_Balloons"
];

// VESTS
VEST_MED = [
	"V_NORTH_FIN_Generic_4"
];

VEST_RIF_PIO = [
	"V_NORTH_FIN_Pioneer_2",
	"V_NORTH_FIN_Pioneer_1"
];

VEST_RIF_SLD = [
	"V_NORTH_FIN_Pioneer_1",
	"V_NORTH_FIN_Rifleman_1",
	"V_NORTH_FIN_Rifleman_3",
	"V_NORTH_FIN_Rifleman_4",
	"V_NORTH_FIN_Rifleman_5",
	"V_NORTH_FIN_Rifleman_6",
	"V_NORTH_FIN_Rifleman_7",
	"V_NORTH_FIN_Rifleman_9",
	"V_NORTH_FIN_Rifleman_10"
];

VEST_RIF_SRG = [
	"V_NORTH_FIN_Officer_1",
	"V_NORTH_FIN_Officer_3",
	"V_NORTH_FIN_Officer_4",
	"V_NORTH_FIN_Officer_5"
];

VEST_PIS = [
	"V_NORTH_FIN_Officer_2",
	"V_NORTH_FIN_Generic_1",
	"V_NORTH_FIN_Officer_3",
	"V_NORTH_FIN_Officer_4",
	"V_NORTH_FIN_Officer_5"
];

// HELMETS
HELMET_FUR_SLD = [
	"H_NORTH_FIN_M39_furhat_open",
	"H_NORTH_FIN_M39_furhat_open_2",
	"H_NORTH_FIN_M39_furhat_1",
	"H_NORTH_FIN_M39_furhat_2",
	"H_NORTH_FIN_M39_furhat_3",
	"H_NORTH_FIN_M39_furhat_4",
	"H_NORTH_FIN_M39_furhat_5"
];

HELMET_FUR_SRG = ["H_NORTH_FIN_M39_furhat_fancy_officer"];

HELMET_M16 = [
	"H_NORTH_FIN_M16_Helmet_Winter_Whitewash",
	"H_NORTH_FIN_M16_Helmet_Winter_Whitewash_2",
	"H_NORTH_FIN_M16_Helmet_Winter_Camo",
	"H_NORTH_FIN_M16_Helmet_Winter_Camo_2",
	"H_NORTH_FIN_M16_Helmet_Winter",
	"H_NORTH_FIN_M16_Helmet_Winter_2"
];

// UNIFORMS 
UNIFORM_SLD = [
	"U_NORTH_FIN_M36_W_Uniform_Private",
	"U_NORTH_FIN_M36_W_Uniform_Private_2",
	"U_NORTH_FIN_M36_W_Uniform_Private_3",
	"U_NORTH_FIN_M36_W_Uniform_Private_4",
	"U_NORTH_FIN_M36_W_Uniform_Private_5",
	"U_NORTH_FIN_M36_W_Uniform_Private_6",
	"U_NORTH_FIN_M36_W_Uniform_INF_Private",
	"U_NORTH_FIN_M36_W_Uniform_INF_Private_2"
];

UNIFORM_PRI = [
	"U_NORTH_FIN_M36_W_Uniform_INF_CPL",
	"U_NORTH_FIN_M36_W_Uniform_INF_CPL_2",
	"U_NORTH_FIN_M36_W_Uniform_INF_Private_1CL",
	"U_NORTH_FIN_M36_W_Uniform_INF_Private_1CL_2"
];

UNIFORM_SRG = [
	"U_NORTH_FIN_M36_W_Uniform_INF_SGT"
];

// uniforms
getUniform_sld = {
	params ["_player"];

	if (random 1 < 0.55) then {
		_cap = selectRandom ["bl","gr"];
		switch (_cap) do {
			case "bl": { 
				_player forceAddUniform selectRandom [
					"U_NORTH_CIV_Wool_1",
					"U_NORTH_CIV_Wool_4",
					"U_NORTH_CIV_Wool_5",
					"U_NORTH_CIV_Wool_7"
				];
				_player addHeadgear selectRandom["H_NORTH_Workercap_Bl", "H_NORTH_Workercap_G"];
			};
			case "gr": { 
				_player forceAddUniform "U_NORTH_CIV_Wool_3";
				_player addHeadgear "H_NORTH_Workercap";
			};
			default { };
		};
	} else {
		_player forceAddUniform selectRandom UNIFORM_SLD;
		if (random 1 < 0.2) then {
			_player addHeadgear selectRandom HELMET_M16;	
		} else {
			_player addHeadgear selectRandom HELMET_FUR_SLD;
		};		
	};
};

getUniform_pri = {
	params ["_player"];

	_player forceAddUniform selectRandom UNIFORM_PRI;
	if (random 1 < 0.2) then {
		_player addHeadgear selectRandom HELMET_M16;	
	} else {
		_player addHeadgear selectRandom HELMET_FUR_SLD;
	};
};

getUniform_srg = {
	params ["_player"];

	_player forceAddUniform selectRandom UNIFORM_SRG;
	if (random 1 < 0.45) then {
		_player addHeadgear selectRandom HELMET_M16;	
	} else {
		_player addHeadgear selectRandom HELMET_FUR_SRG;
	};
};
// uniforms

// vests 
getVest_rif_sld = {
	params ["_player"];
	_player addVest selectRandom VEST_RIF_SLD;
};

getVest_pioneer = {
	params ["_player"];
	_player addVest selectRandom VEST_RIF_SLD;
};

getVest_rif_srg = {
	params ["_player"];
	_player addVest selectRandom VEST_RIF_SRG;
};

getVest_med = {
	params ["_player"];
	_player addVest selectRandom VEST_MED;
};
// vests 


// equipments
getBasicEquipment = {
	params ["_player"];

	removeAllItems _player;
	removeAllAssignedItems _player;

	_player addItemToUniform "ACE_EarPlugs";
	for "_i" from 1 to 2 do {_player addItemToUniform "kat_chestSeal";};
	for "_i" from 1 to 2 do {_player addItemToUniform "ACE_tourniquet";};
	for "_i" from 1 to 5 do {_player addItemToUniform "ACE_elasticBandage";};
	for "_i" from 1 to 25 do {_player addItemToUniform "ACE_packingBandage";};
	for "_i" from 1 to 2 do {_player addItemToUniform "ACE_plasmaIV_500";};
	for "_i" from 1 to 2 do {_player addItemToUniform "ACE_splint";};
	_player addItemToUniform "kat_IV_16";

	_player linkItem "ItemMap";
	_player linkItem "ItemCompass";
	_player linkItem "ItemWatch";
};
// equipments

// weapons
getRifle = {
	params ["_player"];

	_wp = selectRandom[
		"NORTH_fin_M27",
		"NORTH_fin_m27rv",
		"NORTH_fin_M28",
		"NORTH_fin_M28_30",
		"NORTH_fin_M9130",
		"NORTH_fin_m39",
		"NORTH_fin_m91",
		"NORTH_fin_91_vkt",
		"NORTH_fin_m24"
	];
	switch (_wp) do {
		case "NORTH_fin_M27": { 
			_player addWeapon "NORTH_fin_M27";
			_player addPrimaryWeaponItem "NORTH_5Rnd_m39_tracer_mag";
			_player addItemToUniform "NORTH_Bayonet_FinM28";
		};
		case "NORTH_fin_m27rv": { 
			_player addWeapon "NORTH_fin_m27rv";
			_player addPrimaryWeaponItem "NORTH_5Rnd_m39_tracer_mag";
			_player addItemToUniform "NORTH_Bayonet_FinM28";
		};
		case "NORTH_fin_M28": { 
			_player addWeapon "NORTH_fin_M28";
			_player addPrimaryWeaponItem "NORTH_5Rnd_m39_tracer_mag";
			_player addItemToUniform "NORTH_Bayonet_FinM28";
		};
		case "NORTH_fin_M28_30": { 
			_player addWeapon "NORTH_fin_M28_30";
			_player addPrimaryWeaponItem "NORTH_5Rnd_m39_tracer_mag";
			_player addItemToUniform "NORTH_Bayonet_FinM28";
		};
		case "NORTH_fin_M9130": { 
			_player addWeapon "NORTH_fin_M9130";
			_player addPrimaryWeaponItem "NORTH_5Rnd_m39_tracer_mag";
			_player addItemToUniform "NORTH_Bayonet_SovM91";
		};
		case "NORTH_fin_m39": { 
			_player addWeapon "NORTH_fin_m39";
			_player addPrimaryWeaponItem "NORTH_5Rnd_m39_tracer_mag";
			_player addItemToUniform "NORTH_Bayonet_FinM39";
		};
		case "NORTH_fin_m91": { 
			_player addWeapon "NORTH_fin_m91";
			_player addPrimaryWeaponItem "NORTH_5Rnd_m39_tracer_mag";
			_player addItemToUniform "NORTH_Bayonet_SovM91";
		};
		case "NORTH_fin_91_vkt": { 
			_player addWeapon "NORTH_fin_91_vkt";
			_player addPrimaryWeaponItem "NORTH_5Rnd_m39_tracer_mag";
			_player addItemToUniform "NORTH_Bayonet_SovM91";
		};
		case "NORTH_fin_m24": { 
			_player addWeapon "NORTH_fin_m24";
			_player addPrimaryWeaponItem "NORTH_5Rnd_m39_tracer_mag";
			_player addItemToUniform "NORTH_Bayonet_SovM91";
		};
		default { };
	};
	for "_i" from 1 to 15 do { _player addItemToVest "NORTH_5Rnd_m39_tracer_mag"; };
};

getSniper = {
	params ["_player"];

	_player addWeapon selectRandom [
		"NORTH_fin_m27_optics",
		"NORTH_fin_m39_optics",
		"NORTH_fin_m39_PEM"
	];
	_player addPrimaryWeaponItem "NORTH_5Rnd_m39_tracer_mag";
	for "_i" from 1 to 15 do { _player addItemToVest "NORTH_5Rnd_m39_tracer_mag"; };
};

getFl = {
	params ["_player"];

	_player addWeapon "41_Flammenwerfer_02_F";
	_player addPrimaryWeaponItem "41_Fuel_Tank";
	_player addItemToBackpack "41_Fuel_Tank"; 
};
// weapons

// slots 
dressAs_rifleman = {
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

	[_player] spawn getUniform_sld;
	sleep 0.5;
	[_player] spawn getVest_rif_sld;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_SLD;

	sleep 1;

	[_player] spawn getBasicEquipment;
	sleep 0.5;
	[_player] spawn getRifle;
	sleep 0.5;
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_molotov";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_M32Grenade_mag";};
	_player addItemToBackpack "NORTH_M43SmokeGrenade_mag";
};
// this addItemToUniform "ZSN_TrenchWhistle";
// this addItemToUniform "ZSN_Whistle";
dressAs_private = {
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

	[_player] spawn getUniform_pri;
	sleep 0.5;
	[_player] spawn getVest_rif_sld;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_SLD;

	sleep 1;

	[_player] spawn getBasicEquipment;
	sleep 0.5;
	[_player] spawn getRifle;
	sleep 0.5;
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_molotov";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_M32Grenade_mag";};
	_player addItemToBackpack "NORTH_M43SmokeGrenade_mag";

	_player addItemToUniform "ZSN_TrenchWhistle";
};

dressAs_sargent = {
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

	[_player] spawn getUniform_pri;
	sleep 0.5;
	[_player] spawn getVest_rif_sld;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_SLD;

	sleep 1;

	[_player] spawn getBasicEquipment;
	sleep 0.5;
	[_player] spawn getRifle;
	sleep 0.5;
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_molotov";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_M32Grenade_mag";};
	_player addItemToBackpack "NORTH_M43SmokeGrenade_mag";

	_player addItemToUniform "ZSN_TrenchWhistle";
	_player addItemToUniform "ZSN_Whistle";

	_player addWeapon "NORTH_l35";
	_player addHandgunItem "NORTH_8Rnd_l35_mag";
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_8Rnd_l35_mag";};
};
// slots

//-------------------