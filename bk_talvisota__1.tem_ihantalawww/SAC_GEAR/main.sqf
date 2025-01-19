SAC_GEAR_fnc_activateSupplies = {

	params ["_object"];
	
	_object setVariable ["SAC_GEAR_INITIALIZED", true, true];
	
	_object setVariable ["SAC_interact_arsenal", true, true];
	
	if (SAC_ace) then {
	
		[_object, true, true] call ace_arsenal_fnc_initBox;
	
	};
	
	
	clearWeaponCargoGlobal _object;
	clearMagazineCargoGlobal _object;
	clearItemCargoGlobal _object;
	clearBackpackCargoGlobal _object;
	
	
	private _allMagazines = [];
	
	//Recabar todos los tipos de magazines que usa cada jugador y su squad.
	{
	
		{
		
			if (!isPlayer _x) then {
			
				{
				
					_allMagazines pushBackUnique _x;
				
				} forEach ([_x] call SAC_fnc_getAllMagazines);
			
			};

		
		} forEach units group _x;
		
		{
		
			_allMagazines pushBackUnique _x;
		
		} forEach ([_x] call SAC_fnc_getAllMagazines);
	
	} forEach allPlayers;
	
	{
	
		_object addMagazineCargoGlobal [_x, 20];
		
	} forEach _allMagazines;
	
	//agregar algunos pocos lanzadores descartables
	if (SAC_PLAYER_SIDE == west) then {
	
		if (SAC_RHS) then {
		
			//_object addMagazineCargoGlobal ["rhs_m136_mag", 1];
			//_object addWeaponCargoGlobal ["rhs_weap_M136", 1];
			
			_object addMagazineCargoGlobal ["rhs_m72a7_mag", 1];
			_object addWeaponCargoGlobal ["rhs_weap_m72a7", 1];
		
		};
		
		//_object addMagazineCargoGlobal ["NLAW_F", 1];
		//_object addWeaponCargoGlobal ["launch_NLAW_F", 1];
		
		//_object addMagazineCargoGlobal ["MRAWS_HEAT_F", 1];
		//_object addWeaponCargoGlobal ["launch_MRAWS_green_rail_F", 1];
		
	};
	
	if (SAC_PLAYER_SIDE == east) then {
	
		if (SAC_RHS) then {
		
			_object addWeaponCargoGlobal ["rhs_weap_rpg26", 1];
			
			_object addMagazineCargoGlobal ["rhs_rpg7_PG7V_mag", 3];
			_object addWeaponCargoGlobal ["rhs_weap_rpg7", 1];
		
		};
		
		//_object addMagazineCargoGlobal ["RPG32_F", 1];
		//_object addWeaponCargoGlobal ["launch_RPG32_F", 1];
		
		//_object addMagazineCargoGlobal ["Vorona_HEAT", 1];
		//_object addWeaponCargoGlobal ["launch_O_Vorona_green_F", 1];
		
	};
	
};

SAC_GEAR_fnc_initializeRearm = {

	params ["_unit"];

	if (side _unit != SAC_PLAYER_SIDE) exitWith {};
	
	if (primaryWeapon _unit == "") exitWith {};
	
	private ["_wpnMags"];

	//Rifle y UGL
	_wpnMags = primaryWeaponMagazine _unit;
	if (count _wpnMags > 0) then {

		_unit setVariable ["SAC_GEAR_rifleMagazine", (_wpnMags select 0)];

		if (count _wpnMags > 1) then {

			_unit setVariable ["SAC_GEAR_rifleGLMagazine", (_wpnMags select 1)];

		};
	};

	//Launcher
	switch (secondaryWeapon _unit) do {
	
		case "rhs_weap_M136": {
		
			_unit setVariable ["SAC_GEAR_launcherMagazine", "M136"];
		
		};
		
		case "rhs_weap_m72a7": {
		
			_unit setVariable ["SAC_GEAR_launcherMagazine", "M72"];
		
		};
		
		default {
		
			_wpnMags = secondaryWeaponMagazine _unit;
			if (count _wpnMags > 0) then {

				_unit setVariable ["SAC_GEAR_launcherMagazine", (_wpnMags select 0)];

			};
			
		};
	};
	
	//Handgun
	_wpnMags = handgunMagazine _unit;
	if (count _wpnMags > 0) then {

		_unit setVariable ["SAC_GEAR_handgunMagazine", (_wpnMags select 0)];

	};

	private ["_array", "_biggestMagazineCapacity", "_normalCount"];
	//Determinar si alguna magazine tiene 100 balas o más, porque eso influiría en los cálculos de cuántas pretende llevar, y cuándo se considera ammo low.
	_array = magazinesAmmo _unit;

	_biggestMagazineCapacity = 0;
	{

		if (_x select 1 > _biggestMagazineCapacity) then {_biggestMagazineCapacity = _x select 1};

	} forEach _array;

	switch (true) do {

		case (_biggestMagazineCapacity >= 200): {

			_normalCount = 3;

		};

		case (_biggestMagazineCapacity >= 100): {

			_normalCount = 6;

		};

		case (_biggestMagazineCapacity < 100): {

			_normalCount = 10;

		};
	};

	_unit setVariable ["SAC_GEAR_rifleMagazineNormalCount", _normalCount];
	
	_unit setVariable ["SAC_GEAR_rearmEnabled", true];

};

SAC_GEAR_fnc_rearm = {

	//Esta rutina agrega magazines a la unidad, según los tipos de armas que porte. Las unidades tienen que haber sido inicializadas previamente.

	params ["_unit"];

	private ["_rifleMagazine", "_rifleGLMagazine", "_launcherMagazine", "_handgunMagazine", "_rifleMagazineNormalCount", "_magazinesAmmoFull", "_rifleMagazineCount", "_neededRifleMags",
	"_rifleGLMagazineCount", "_neededRifleGLMags", "_launcherMagazineCount", "_neededLauncherMags", "_handgunMagazineCount", "_neededHandgunMags"];

	//Agregar primero los medikits.
	if ({_x == "FirstAidKit"} count items _unit < 2) then {[_unit, "FirstAidKit", 2] call SAC_fnc_addItems};

	if (_unit getVariable ["SAC_GEAR_rearmEnabled", false]) then {
	
		_rifleMagazine = _unit getVariable ["SAC_GEAR_rifleMagazine", ""];
		//systemChat format["_rifleMagazine %1", _rifleMagazine];

		_rifleGLMagazine = _unit getVariable ["SAC_GEAR_rifleGLMagazine", ""];

		_launcherMagazine = _unit getVariable ["SAC_GEAR_launcherMagazine", ""];

		_handgunMagazine = _unit getVariable ["SAC_GEAR_handgunMagazine", ""];

		_rifleMagazineNormalCount = _unit getVariable ["SAC_GEAR_rifleMagazineNormalCount", 0];

		_magazinesAmmoFull = magazinesAmmoFull _unit;

		if (_rifleMagazine != "") then {

			_rifleMagazineCount = {(_x select 0) == _rifleMagazine} count _magazinesAmmoFull;
			//systemChat format["_rifleMagazineCount %1", _rifleMagazineCount];

			_neededRifleMags = _rifleMagazineNormalCount - _rifleMagazineCount;

			if (_neededRifleMags > 0) then {[_unit, _rifleMagazine, _neededRifleMags] call SAC_fnc_addMagazines};
			//systemChat format["_neededRifleMags %1", _neededRifleMags];

		};

		if (_rifleGLMagazine != "") then {

			_rifleGLMagazineCount = {(_x select 0) == _rifleGLMagazine} count _magazinesAmmoFull;

			_neededRifleGLMags = 6 - _rifleGLMagazineCount;

			if (_neededRifleGLMags > 0) then {[_unit, _rifleGLMagazine, _neededRifleGLMags] call SAC_fnc_addMagazines};

		};

		switch (_launcherMagazine) do {
		
			case "M136": {
			
				if (secondaryWeapon _unit == "") then {[_unit] call SAC_GEAR_fnc_giveRHS_M136AT};
			
			};
			case "M72": {
			
				if (secondaryWeapon _unit == "") then {[_unit] call SAC_GEAR_fnc_giveRHS_LAW};
			
			};
			default {
			
				if (_launcherMagazine != "") then {

					_launcherMagazineCount = {(_x select 0) == _launcherMagazine} count _magazinesAmmoFull;

					_neededLauncherMags = 2 - _launcherMagazineCount;

					if (_neededLauncherMags > 0) then {[_unit, _launcherMagazine, _neededLauncherMags] call SAC_fnc_addMagazines};

				};
		
			};
	
		};

		if (_handgunMagazine != "") then {

			_handgunMagazineCount = {(_x select 0) == _handgunMagazine} count _magazinesAmmoFull;

			_neededHandgunMags = 3 - _handgunMagazineCount;

			if (_neededHandgunMags > 0) then {[_unit, _handgunMagazine, _neededHandgunMags] call SAC_fnc_addMagazines};

		};
		
	} else {
	
		systemChat "Se llamo a SAC_GEAR_fnc_rearm pero la unidad no esta inicializada.";
	
	};


};

SAC_GEAR_fnc_orderTakeWeaponFromDeadUnit = {

	params ["_unit"];
	
	private ["_weapon", "_ammoForEachMuzzle", "_magazine"];
	
	if (primaryWeapon _unit == "") then {
	
		_weapon = [getPos _unit, 50] call SAC_fnc_getRandomWeaponFromDeadUnits;
		
		if (_weapon != "") then {
		
			_ammoForEachMuzzle = [_weapon] call SAC_fnc_getMagazines;
			
			{
			
				[_unit, _x select 0, 4] call  SAC_fnc_addMagazines;
				
			} forEach _ammoForEachMuzzle;
			
			_unit addWeapon _weapon;
		
		} else {
		
			[_unit, false] call SAC_GEAR_fnc_giveP07_9mm;
		
		};
		
		[_unit] call SAC_GEAR_fnc_initializeRearm;
	
	} else {
	
		_unit groupChat "I already have a weapon!"
	
	};
	
	
};

SAC_GEAR_fnc_orderRearm = {

	if (!hasInterface) exitWith {};

	private ["_unit", "_type", "_canRearm", "_ammoPos", "_unitType", "_faction", "_nearAmmo", "_unitPos"];

	_unit = _this select 0;
	_type = _this select 1;

	//29/03/2017 caso de que no tengan armas y tengan que tomar una de una unidad muerta (o los soldados les dan una pistola)
	//06/01/2021 lo desactivo porque ahora se hace desde sac_interact
	/*	if (primaryWeapon _unit == "") exitWith {
		
			_unit addVest "V_TacVest_blk";
			[_unit] call SAC_GEAR_fnc_orderTakeWeaponFromDeadUnit;
			
		
		};
	*/
		
	if !(_unit getVariable ["SAC_GEAR_rearmEnabled", false]) exitWith {
	
		systemChat "Se llamo a SAC_GEAR_fnc_orderRearm pero la unidad no esta inicializada.";
	
	};
	
	_unitType = typeOf _unit;

	_canRearm = true;
	if (_type == "MOVE") then {

		//Ejecutar solo si _unit esta cerca de un ammo source valido.
		_nearAmmo = [];
		{

			if (_x getVariable ["SAC_GEAR_INITIALIZED", false]) then {
				_nearAmmo pushBack _x;
			};

		} forEach nearestObjects [_unit, ["ReammoBox_F", "Car", "Tank", "Man", "Air"], 100];

		if (count _nearAmmo == 0) then {

			{

				if (_x getVariable ["SAC_GEAR_INITIALIZED", false]) then {
					_nearAmmo pushBack _x;
				};

			} forEach nearestObjects [player, ["ReammoBox_F", "Car", "Tank", "Man", "Air"], 100];

		};

		if (count _nearAmmo > 0) then {

			_ammoPos = getPos ([_nearAmmo, _unit] call BIS_fnc_nearestPosition);

			//Stopped units can't be moved or detected as stopped, and hence there's no workaround if the player issues a rearm command to a stopped unit.
			//Update: It can be detected, using unitReady, but the check should be made before calling _unit routine. I do re-check here just in case, but
			//note that no message is given reporting the problem to the player. That's the calling routine's responsability.
			if (unitReady _unit) then {

				_unitPos = getPos _unit;
				
				_unit doMove _ammoPos;
				_unit groupChat selectRandom ["On it.", "On the move.", "On my way."];
				sleep 1;

				waitUntil {(unitReady _unit) || (moveToFailed _unit)};
				sleep 1;
				if ((_unit distance _ammoPos) > 7) then {_canRearm = false};

			} else {_canRearm = false};

		} else {_canRearm = false; _unit groupChat "I don't see any ammo container!"};

	};

	if (_canRearm) then {

		[_unit] call SAC_GEAR_fnc_rearm;
		//[[_unit], SAC_SQUAD_gearSelection] call SAC_GEAR_fnc_applyLoadout;

		sleep 5;

		if (_type == "MOVE") then {

			_unit groupChat "Done.";
			"defaultNotification" call SAC_fnc_playSound;
			
			_unit doMove _unitPos;

		};

	} else {

		_unit groupChat "Negative. Can't get to the ammo box.";

	};

};

//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitwith {hintC """SAC_FNC"" is not initialized in SAC_GEAR."};
if (isnil "SAC_GEAR_B_loadoutProfile") exitwith {hintC """SAC_GEAR_B_loadoutProfile"" is not initialized in SAC_GEAR."};
if (isnil "SAC_GEAR_B_G_loadoutProfile") exitwith {hintC """SAC_GEAR_B_G_loadoutProfile"" is not initialized in SAC_GEAR."};
if (isnil "SAC_GEAR_O_loadoutProfile") exitwith {hintC """SAC_GEAR_O_loadoutProfile"" is not initialized in SAC_GEAR."};
if (isnil "SAC_GEAR_O_SF_loadoutProfile") exitwith {hintC """SAC_GEAR_O_SF_loadoutProfile"" is not initialized in SAC_GEAR."};
if (isnil "SAC_GEAR_O_G_loadoutProfile") exitwith {hintC """SAC_GEAR_O_G_loadoutProfile"" is not initialized in SAC_GEAR."};
if (isNil "GEAR_NVG") then {hintC "Falta definir GEAR_NVG"};

SAC_GEAR_playerSquad_magazines = [];

SAC_GEAR_resupplyPoints = [];
_count = 1;
while {getMarkerColor format ["SAC_resupply_%1", _count] != ""} do {

	SAC_GEAR_resupplyPoints pushBack format ["SAC_resupply_%1", _count];
	_count = _count + 1;
};

//*****************************************************************************************
//Definiciones de accesorios para cada tipo de arma.
//Este es el sistema que permite asignar accesorios diferentes según SAC_UDS_weaponColor.
//*****************************************************************************************

switch (SAC_UDS_weaponColor) do {

	case "BLACK": {

		SAC_GEAR_MK20s = ["arifle_Mk20C_F", "arifle_Mk20_F"];
		SAC_GEAR_MK20_sil = "muzzle_snds_M";
		SAC_GEAR_MK20_pointerIR = "acc_pointer_IR";

		SAC_GEAR_MK20GL = "arifle_Mk20_GL_F";
		
		SAC_GEAR_MK200 = "LMG_Mk200_black_F";
		SAC_GEAR_MK200_ir = "acc_pointer_IR";
		SAC_GEAR_MK200_sil = "muzzle_snds_H";
		SAC_GEAR_MK200_optic = "optic_Arco_blk_F";
		SAC_GEAR_MK200_mag = "200Rnd_65x39_cased_Box";
		
		SAC_GEAR_MXs = ["arifle_MX_Black_F", "arifle_MXC_Black_F"];
		SAC_GEAR_MX_sil = "muzzle_snds_65_TI_blk_F";//"muzzle_snds_H";
		SAC_GEAR_MX_irs = ["acc_pointer_IR"];
		SAC_GEAR_MX_optics_regular = ["optic_Hamr"];
		SAC_GEAR_MX_optics_sof = ["optic_Hamr"];
		SAC_GEAR_MX_mag = "30Rnd_65x39_caseless_black_mag";
		
		SAC_GEAR_MXGL = "arifle_MX_GL_Black_F";
		
		SAC_GEAR_MXM = "arifle_MXM_Black_F";
		SAC_GEAR_MXM_optic = "optic_DMS";
		
		SAC_GEAR_MXSW = "arifle_MX_SW_Black_F";
		SAC_GEAR_MXSW_mag = "100Rnd_65x39_caseless_black_mag";
		
		SAC_GEAR_MKIs = ["srifle_DMR_03_F", "srifle_DMR_03_woodland_F"];
		SAC_GEAR_MKI_sil = "muzzle_snds_B";
		SAC_GEAR_MKI_optic = "optic_AMS";
		
		SAC_GEAR_MK18EBR_optics = ["optic_DMS", "optic_AMS", "optic_SOS", "optic_KHS_blk"];
		
		SAC_GEAR_bis_bipod = "bipod_01_F_blk";
		
		SAC_GEAR_TITAN_at = "launch_O_Titan_short_F";
		
		SAC_GEAR_TITAN_aa = "launch_B_Titan_tna_F";
		
		SAC_GEAR_SPAR16 = "arifle_SPAR_01_blk_F";
		SAC_GEAR_SPAR16_mag = "30Rnd_556x45_Stanag";
		SAC_GEAR_SPAR16_sil = "muzzle_snds_M";
		SAC_GEAR_SPAR16_irs = ["acc_pointer_IR"];
		SAC_GEAR_SPAR16_optics = ["optic_Hamr"];
		
		SAC_GEAR_SPAR16GL = "arifle_SPAR_01_GL_blk_F";
		
		SAC_GEAR_SPAR16S = "arifle_SPAR_02_blk_F";
		SAC_GEAR_SPAR16S_mag = "150Rnd_556x45_Drum_Mag_F";
		
		SAC_GEAR_SPAR17 = "arifle_SPAR_03_blk_F";
		SAC_GEAR_SPAR17_sil = "muzzle_snds_B";
		SAC_GEAR_SPAR17_irs = ["acc_pointer_IR"];
		SAC_GEAR_SPAR17_optics = ["optic_AMS"];
		
		SAC_GEAR_AK12s = ["arifle_AK12U_F", "arifle_AK12_F"];
		SAC_GEAR_AK12GL = ["arifle_AK12_GL_F"];
		SAC_GEAR_AK12_sil = "muzzle_snds_B";
		SAC_GEAR_AK12_optics = ["optic_Arco_AK_blk_F", "optic_Holosight_blk_F"];
		SAC_GEAR_AK12_MM_optics = ["optic_AMS"];
		SAC_GEAR_AK12_mag = "30Rnd_762x39_AK12_Mag_F";
		SAC_GEAR_AK12_AR_mag = "75rnd_762x39_AK12_Mag_F";
		SAC_GEAR_AK12_bipod = "bipod_02_F_blk";
		
		SAC_GEAR_RHS_SR25 = "rhs_weap_sr25_ec";
		SAC_GEAR_RHS_SR25_sil = "rhsgref_sdn6_suppressor";
		SAC_GEAR_RHS_SR25_optic = "optic_KHS_blk";
		SAC_GEAR_RHS_SR25_ir = "rhsusf_acc_anpeq15side_bk";
		SAC_GEAR_RHS_SR25_bipod = "bipod_01_F_blk";
		
		SAC_GEAR_RHS_MK18 = ["rhs_weap_mk18", "rhs_weap_mk18_KAC"];
		SAC_GEAR_RHS_MK18_sil = "rhsusf_acc_nt4_black";
		SAC_GEAR_RHS_MK18_irs = ["rhsusf_acc_anpeq15side"];
		SAC_GEAR_RHS_MK18_optics = ["rhsusf_acc_su230_3d"];
		
		SAC_GEAR_RHS_MK18_GL = "rhs_weap_mk18_m320";
		
		SAC_GEAR_RHS_HK416 = ["rhs_weap_hk416d145", "rhs_weap_hk416d10_LMT", "rhs_weap_hk416d10"];
		SAC_GEAR_RHS_HK416_optics = ["rhsusf_acc_su230"];
		SAC_GEAR_RHS_HK416_sil = "rhsusf_acc_nt4_black";
		SAC_GEAR_RHS_HK416_irs = ["rhsusf_acc_anpeq15side_bk"];
		SAC_GEAR_RHS_HK416_mag = "rhs_mag_30Rnd_556x45_Mk262_PMAG";
		
		SAC_GEAR_RHS_HK416GL = ["rhs_weap_hk416d10_m320", "rhs_weap_hk416d145_m320"];
		
		SAC_GEAR_RHS_M4A1_PIP = ["rhs_weap_m4a1_mstock"];
		SAC_GEAR_RHS_M4A1_PIP_optics = ["rhsusf_acc_ACOG"];
		SAC_GEAR_RHS_M4A1_PIP_sil = "rhsusf_acc_nt4_black";
		SAC_GEAR_RHS_M4A1_PIP_irs = ["rhsusf_acc_anpeq15"];
		SAC_GEAR_RHS_M4A1_PIP_mag = "rhs_mag_30Rnd_556x45_Mk262_PMAG";
		
		SAC_GEAR_RHS_M4A1_PIP_M203 = ["rhs_weap_m4a1_m203s"];
		
		SAC_GEAR_BIS_LIM85_irs = ["rhsusf_acc_anpeq15side"];
		SAC_GEAR_BIS_LIM85_optics_sof = ["rhsusf_acc_su230"];
		
		SAC_GEAR_M4A1blockII = ["rhs_weap_m4a1_blockII", "rhs_weap_m4a1_blockII_KAC"];
		
		SAC_GEAR_M4A1blockIIGL = "rhs_weap_m4a1_blockII_M203";
		
		//SAC_GEAR_P07 = "hgun_P07_F"; //es sand
		SAC_GEAR_P07 = "hgun_P07_blk_F";
		
		SAC_GEAR_KATIBA_sil = "muzzle_snds_H";
		SAC_GEAR_KATIBA_irs = ["acc_pointer_IR"];
		SAC_GEAR_KATIBA_optics_sof = ["optic_Hamr"];
		
		SAC_GEAR_car95_mg = "arifle_CTARS_blk_F";
		
		SAC_GEAR_car95 = "arifle_CTAR_blk_F";
		SAC_GEAR_car95_sil = "muzzle_snds_58_blk_F";
		SAC_GEAR_car95_optics_sof = ["optic_Arco_blk_F"];
		
		SAC_GEAR_car95_gl = "arifle_CTAR_GL_blk_F";
		
		SAC_GEAR_cmr76 = "srifle_DMR_07_blk_F";
		SAC_GEAR_cmr76_sil = "muzzle_snds_65_TI_blk_F";
		SAC_GEAR_cmr76_optics = ["optic_DMS"];
		
		SAC_GEAR_4five_45ACP = "hgun_Pistol_heavy_01_green_F";
		SAC_GEAR_4five_45ACP_sil = "muzzle_snds_acp";
		SAC_GEAR_4five_45ACP_scope = "optic_MRD_black";
		
		SAC_GEAR_bis_nvg = "NVGoggles_OPFOR";
		
	};
	case "SAND": {
	
		SAC_GEAR_MK20s = ["arifle_Mk20C_plain_F", "arifle_Mk20_plain_F"];
		SAC_GEAR_MK20_sil = "muzzle_snds_m_snd_F";
		SAC_GEAR_MK20_pointerIR = "acc_pointer_IR";
		
		SAC_GEAR_MK20GL = "arifle_Mk20_GL_plain_F";
		
		SAC_GEAR_MK200 = "LMG_Mk200_F";
		SAC_GEAR_MK200_ir = "acc_pointer_IR";
		SAC_GEAR_MK200_sil = "muzzle_snds_H_MG";
		SAC_GEAR_MK200_optic = "optic_Arco";
		SAC_GEAR_MK200_mag = "200Rnd_65x39_cased_Box";
		
		SAC_GEAR_MXs = ["arifle_MX_F", "arifle_MXC_F"];
		SAC_GEAR_MX_sil = "muzzle_snds_65_TI_blk_F";//"muzzle_snds_H";
		SAC_GEAR_MX_irs = ["acc_pointer_IR"];
		SAC_GEAR_MX_optics_regular = ["optic_Hamr"];
		SAC_GEAR_MX_optics_sof = ["optic_Hamr"];
		SAC_GEAR_MX_mag = "30Rnd_65x39_caseless_mag";
		
		SAC_GEAR_MXGL = "arifle_MX_GL_F";
		
		SAC_GEAR_MXM = "arifle_MXM_F";
		SAC_GEAR_MXM_optic = "optic_DMS";
		
		SAC_GEAR_MXSW = "arifle_MX_SW_F";
		SAC_GEAR_MXSW_mag = "100Rnd_65x39_caseless_mag";
		
		SAC_GEAR_MKIs = ["srifle_DMR_03_tan_F", "srifle_DMR_03_multicam_F"];
		SAC_GEAR_MKI_sil = "muzzle_snds_B";
		SAC_GEAR_MKI_optic = "optic_AMS_snd";
		
		SAC_GEAR_MK18EBR_optics = ["optic_DMS", "optic_AMS_snd", "optic_SOS", "optic_KHS_tan"];
		
		SAC_GEAR_bis_bipod = "bipod_01_F_snd";
		
		SAC_GEAR_TITAN_at = "launch_O_Titan_short_F";
		
		SAC_GEAR_TITAN_aa = "launch_B_Titan_tna_F";
		
		SAC_GEAR_SPAR16 = "arifle_SPAR_01_snd_F";
		SAC_GEAR_SPAR16_mag = "30Rnd_556x45_Stanag_Sand";
		SAC_GEAR_SPAR16_sil = "muzzle_snds_M";
		SAC_GEAR_SPAR16_irs = ["acc_pointer_IR"];
		SAC_GEAR_SPAR16_optics = ["optic_Hamr"];
		
		SAC_GEAR_SPAR16GL = "arifle_SPAR_01_GL_snd_F";
		
		SAC_GEAR_SPAR16S = "arifle_SPAR_02_snd_F";
		SAC_GEAR_SPAR16S_mag = "150Rnd_556x45_Drum_Sand_Mag_F";
		
		SAC_GEAR_SPAR17 = "arifle_SPAR_03_snd_F";
		SAC_GEAR_SPAR17_sil = "muzzle_snds_B_snd_F";
		SAC_GEAR_SPAR17_irs = ["rhsusf_acc_anpeq15side"];
		SAC_GEAR_SPAR17_optics = ["optic_AMS_snd"];
		
		SAC_GEAR_AK12s = ["arifle_AK12U_arid_F", "arifle_AK12_arid_F"];
		SAC_GEAR_AK12GL = ["arifle_AK12_GL_arid_F"];
		SAC_GEAR_AK12_sil = "muzzle_snds_B_arid_F";
		SAC_GEAR_AK12_optics = ["optic_Arco_AK_arid_F", "optic_Holosight_arid_F"];
		SAC_GEAR_AK12_MM_optics = ["optic_KHS_tan"];
		SAC_GEAR_AK12_mag = "30rnd_762x39_AK12_Arid_Mag_F";
		SAC_GEAR_AK12_AR_mag = "75rnd_762x39_AK12_Arid_Mag_F";
		SAC_GEAR_AK12_bipod = "bipod_02_F_arid";
		
		SAC_GEAR_RHS_SR25 = "rhs_weap_sr25_ec_d";
		SAC_GEAR_RHS_SR25_sil = "rhsgref_sdn6_suppressor";
		SAC_GEAR_RHS_SR25_optic = "optic_KHS_tan";
		SAC_GEAR_RHS_SR25_ir = "rhsusf_acc_anpeq15side";
		SAC_GEAR_RHS_SR25_bipod = "bipod_01_F_snd";
		
		SAC_GEAR_RHS_MK18 = ["rhs_weap_mk18_d", "rhs_weap_mk18_KAC_d"];
		SAC_GEAR_RHS_MK18_sil = "rhsusf_acc_nt4_tan";		
		SAC_GEAR_RHS_MK18_irs = ["rhsusf_acc_anpeq15side"];
		SAC_GEAR_RHS_MK18_optics = ["rhsusf_acc_su230_c_3d"];
		
		SAC_GEAR_RHS_MK18_GL = "rhs_weap_mk18_m320";
		
		SAC_GEAR_RHS_HK416 = ["rhs_weap_hk416d10_LMT_d"];
		SAC_GEAR_RHS_HK416_optics = ["rhsusf_acc_su230_c"];
		SAC_GEAR_RHS_HK416_sil = "rhsusf_acc_nt4_tan";
		SAC_GEAR_RHS_HK416_irs = ["rhsusf_acc_anpeq15side"];
		SAC_GEAR_RHS_HK416_mag = "rhs_mag_30Rnd_556x45_Mk262_PMAG_Tan";
		
		SAC_GEAR_RHS_HK416GL = ["rhs_weap_hk416d10_m320", "rhs_weap_hk416d145_m320"];

		SAC_GEAR_RHS_M4A1_PIP = ["rhs_weap_m4a1_d_mstock"];
		SAC_GEAR_RHS_M4A1_PIP_optics = ["rhsusf_acc_ACOG_d"];
		SAC_GEAR_RHS_M4A1_PIP_sil = "rhsusf_acc_nt4_tan";
		SAC_GEAR_RHS_M4A1_PIP_irs = ["rhsusf_acc_anpeq15"];
		SAC_GEAR_RHS_M4A1_PIP_mag = "rhs_mag_30Rnd_556x45_Mk262_PMAG_Tan";
		
		SAC_GEAR_RHS_M4A1_PIP_M203 = ["rhs_weap_m4a1_m203s_d"];

		SAC_GEAR_BIS_LIM85_irs = ["rhsusf_acc_anpeq15side"];
		SAC_GEAR_BIS_LIM85_optics_sof = ["rhsusf_acc_su230_c"];
		
		SAC_GEAR_M4A1blockII = "rhs_weap_m4a1_blockII_d";
		SAC_GEAR_M4A1blockII = ["rhs_weap_m4a1_blockII_d", "rhs_weap_m4a1_blockII_KAC_d"];
		
		SAC_GEAR_M4A1blockIIGL = "rhs_weap_m4a1_blockII_M203_d";
		
		//SAC_GEAR_P07 = "hgun_P07_F"; //es sand
		SAC_GEAR_P07 = "hgun_P07_blk_F";
		
		SAC_GEAR_KATIBA_sil = "muzzle_snds_H";
		SAC_GEAR_KATIBA_irs = ["acc_pointer_IR"];
		SAC_GEAR_KATIBA_optics_sof = ["optic_Hamr"];
		
		SAC_GEAR_car95_mg = "arifle_CTARS_hex_F";
		
		SAC_GEAR_car95 = "arifle_CTAR_hex_F";
		SAC_GEAR_car95_sil = "muzzle_snds_58_hex_F";
		SAC_GEAR_car95_optics_sof = ["optic_Arco"];
		
		SAC_GEAR_car95_gl = "arifle_CTAR_GL_hex_F";
		
		SAC_GEAR_cmr76 = "srifle_DMR_07_hex_F";
		SAC_GEAR_cmr76_sil = "muzzle_snds_65_TI_hex_F";
		SAC_GEAR_cmr76_optics = ["optic_DMS"];
		
		SAC_GEAR_4five_45ACP = "hgun_Pistol_heavy_01_F";
		SAC_GEAR_4five_45ACP_sil = "muzzle_snds_acp";
		SAC_GEAR_4five_45ACP_scope = "optic_MRD";
		
		SAC_GEAR_bis_nvg = "NVGoggles";
		
	};
	case "KHAKI": {

		SAC_GEAR_MK20s = ["arifle_Mk20C_F", "arifle_Mk20_F"];
		SAC_GEAR_MK20_sil = "muzzle_snds_M";
		SAC_GEAR_MK20_pointerIR = "acc_pointer_IR";
		
		SAC_GEAR_MK20GL = "arifle_Mk20_GL_F";
		
		SAC_GEAR_MK200 = "LMG_Mk200_black_F";
		SAC_GEAR_MK200_ir = "acc_pointer_IR";
		SAC_GEAR_MK200_sil = "muzzle_snds_H";
		SAC_GEAR_MK200_optic = "optic_Hamr_khk_F";
		SAC_GEAR_MK200_mag = "200Rnd_65x39_cased_Box";
		
		SAC_GEAR_MXs = ["arifle_MX_Khk_F", "arifle_MXC_Khk_F"];
		SAC_GEAR_MX_sil = "muzzle_snds_65_TI_blk_F";//"muzzle_snds_H";
		SAC_GEAR_MX_irs = ["acc_pointer_IR"];
		SAC_GEAR_MX_optics_regular = ["optic_Hamr_khk_F"];
		SAC_GEAR_MX_optics_sof = ["optic_Hamr_khk_F"];
		SAC_GEAR_MX_mag = "30Rnd_65x39_caseless_khaki_mag";
		
		SAC_GEAR_MXGL = "arifle_MX_GL_Khk_F";
		
		SAC_GEAR_MXM = "arifle_MXM_Khk_F";
		SAC_GEAR_MXM_optic = "optic_DMS_ghex_F";
		
		SAC_GEAR_MXSW = "arifle_MX_SW_Khk_F";
		SAC_GEAR_MXSW_mag = "100Rnd_65x39_caseless_khaki_mag";
		
		SAC_GEAR_MKIs = ["srifle_DMR_03_khaki_F", "srifle_DMR_03_woodland_F"];
		SAC_GEAR_MKI_sil = "muzzle_snds_B";
		SAC_GEAR_MKI_optic = "optic_AMS_khk";
		
		SAC_GEAR_MK18EBR_optics = ["optic_DMS_ghex_F", "optic_AMS_khk", "optic_SOS_khk_F", "optic_KHS_blk"];
		
		SAC_GEAR_bis_bipod = "bipod_01_F_khk";
		
		SAC_GEAR_TITAN_at = "launch_I_Titan_short_F";
		
		SAC_GEAR_TITAN_aa = "launch_B_Titan_tna_F";
		
		//SAC_GEAR_SPAR16 = "arifle_SPAR_01_khk_F";
		SAC_GEAR_SPAR16 = "arifle_SPAR_01_blk_F";
		SAC_GEAR_SPAR16_mag = "30Rnd_556x45_Stanag";
		//SAC_GEAR_SPAR16_sil = "muzzle_snds_m_khk_F";
		SAC_GEAR_SPAR16_sil = "muzzle_snds_M";
		SAC_GEAR_SPAR16_irs = ["acc_pointer_IR"];
		//SAC_GEAR_SPAR16_optics = ["optic_Hamr_khk_F"];
		SAC_GEAR_SPAR16_optics = ["optic_Hamr"];
		
		//SAC_GEAR_SPAR16GL = "arifle_SPAR_01_GL_khk_F";
		SAC_GEAR_SPAR16GL = "arifle_SPAR_01_GL_blk_F";
		
		//SAC_GEAR_SPAR16S = "arifle_SPAR_02_khk_F";
		//SAC_GEAR_SPAR16S_mag = "150Rnd_556x45_Drum_Green_Mag_F";
		SAC_GEAR_SPAR16S = "arifle_SPAR_02_blk_F";
		SAC_GEAR_SPAR16S_mag = "150Rnd_556x45_Drum_Mag_F";
		
		//SAC_GEAR_SPAR17 = "arifle_SPAR_03_khk_F";
		//SAC_GEAR_SPAR17_sil = "muzzle_snds_B_khk_F";
		SAC_GEAR_SPAR17 = "arifle_SPAR_03_blk_F";
		SAC_GEAR_SPAR17_sil = "muzzle_snds_B";
		SAC_GEAR_SPAR17_irs = ["acc_pointer_IR"];
		//SAC_GEAR_SPAR17_optics = ["optic_AMS_khk"];
		SAC_GEAR_SPAR17_optics = ["optic_AMS"];
		
		SAC_GEAR_AK12s = ["arifle_AK12U_lush_F", "arifle_AK12_lush_F"];
		SAC_GEAR_AK12GL = ["arifle_AK12_GL_lush_F"];
		SAC_GEAR_AK12_sil = "muzzle_snds_B_lush_F";
		SAC_GEAR_AK12_optics = ["optic_Arco_AK_lush_F", "optic_Holosight_lush_F"];
		SAC_GEAR_AK12_MM_optics = ["optic_AMS_khk"];
		SAC_GEAR_AK12_mag = "30rnd_762x39_AK12_Lush_Mag_F";
		SAC_GEAR_AK12_AR_mag = "75rnd_762x39_AK12_Lush_Mag_F";
		SAC_GEAR_AK12_bipod = "bipod_02_F_lush";
		
		
		SAC_GEAR_RHS_SR25 = "rhs_weap_sr25_ec_wd";
		SAC_GEAR_RHS_SR25_sil = "rhsgref_sdn6_suppressor";
		SAC_GEAR_RHS_SR25_optic = "optic_AMS_khk";
		SAC_GEAR_RHS_SR25_ir = "rhsusf_acc_anpeq15side_bk";
		SAC_GEAR_RHS_SR25_bipod = "bipod_01_F_khk";
		
		SAC_GEAR_RHS_MK18 = ["rhs_weap_mk18_wd", "rhs_weap_mk18_KAC_wd"];
		SAC_GEAR_RHS_MK18_sil = "rhsusf_acc_nt4_black";
		SAC_GEAR_RHS_MK18_irs = ["rhsusf_acc_anpeq15side_bk"];
		SAC_GEAR_RHS_MK18_optics = ["rhsusf_acc_su230_3d"];
		
		SAC_GEAR_RHS_MK18_GL = "rhs_weap_mk18_m320";
		
		SAC_GEAR_RHS_HK416 = ["rhs_weap_hk416d10_LMT_wd"];
		SAC_GEAR_RHS_HK416_optics = ["rhsusf_acc_su230"];
		SAC_GEAR_RHS_HK416_sil = "rhsusf_acc_nt4_black";
		SAC_GEAR_RHS_HK416_irs = ["rhsusf_acc_anpeq15side_bk"];
		SAC_GEAR_RHS_HK416_mag = "rhs_mag_30Rnd_556x45_Mk262_PMAG";
		
		SAC_GEAR_RHS_HK416GL = ["rhs_weap_hk416d10_m320", "rhs_weap_hk416d145_m320"];

		SAC_GEAR_RHS_M4A1_PIP = ["rhs_weap_m4a1_wd_mstock"];
		SAC_GEAR_RHS_M4A1_PIP_optics = ["rhsusf_acc_ACOG_wd"];
		SAC_GEAR_RHS_M4A1_PIP_sil = "rhsusf_acc_nt4_black";
		SAC_GEAR_RHS_M4A1_PIP_irs = ["rhsusf_acc_anpeq15_bk"];
		SAC_GEAR_RHS_M4A1_PIP_mag = "rhs_mag_30Rnd_556x45_Mk262_Stanag";
		
		SAC_GEAR_RHS_M4A1_PIP_M203 = ["rhs_weap_m4a1_m203s_wd"];

		SAC_GEAR_BIS_LIM85_irs = ["rhsusf_acc_anpeq15side_bk"];
		SAC_GEAR_BIS_LIM85_optics_sof = ["rhsusf_acc_su230"];
		
		SAC_GEAR_M4A1blockII = "rhs_weap_m4a1_blockII_wd";
		SAC_GEAR_M4A1blockII = ["rhs_weap_m4a1_blockII_wd", "rhs_weap_m4a1_blockII_KAC_wd"];
		
		SAC_GEAR_M4A1blockIIGL = "rhs_weap_m4a1_blockII_M203_wd";
		
		//SAC_GEAR_P07 = "hgun_P07_khk_F";
		SAC_GEAR_P07 = "hgun_P07_blk_F";
		
		SAC_GEAR_KATIBA_sil = "muzzle_snds_H";
		SAC_GEAR_KATIBA_irs = ["acc_pointer_IR"];
		SAC_GEAR_KATIBA_optics_sof = ["optic_Hamr"];
		
		SAC_GEAR_car95_mg = "arifle_CTARS_ghex_F";
		
		SAC_GEAR_car95 = "arifle_CTAR_ghex_F";
		SAC_GEAR_car95_sil = "muzzle_snds_58_ghex_F";
		SAC_GEAR_car95_optics_sof = ["optic_Arco_ghex_F"];
		
		SAC_GEAR_car95_gl = "arifle_CTAR_GL_ghex_F";
		
		SAC_GEAR_cmr76 = "srifle_DMR_07_ghex_F";
		SAC_GEAR_cmr76_sil = "muzzle_snds_65_TI_ghex_F";
		SAC_GEAR_cmr76_optics = ["optic_DMS_ghex_F"];
		
		SAC_GEAR_4five_45ACP = "hgun_Pistol_heavy_01_green_F";
		SAC_GEAR_4five_45ACP_sil = "muzzle_snds_acp";
		SAC_GEAR_4five_45ACP_scope = "optic_MRD_black";
		
		SAC_GEAR_bis_nvg = "NVGoggles_INDEP";
		
		
	};

};


SAC_GEAR_IAR_optics_sof = ["rhsusf_acc_ACOG_MDO", "rhsusf_acc_ACOG_RMR"]; //"SU-260/P(MDO)", "TA31RCO-RMR"

SAC_GEAR_rhs_rifles_ak74m = ["rhs_weap_ak74m_2mag", "rhs_weap_ak74m_2mag_camo", "rhs_weap_ak74m_camo", "rhs_weap_ak74m_plummag","rhs_weap_ak74m_fullplum"];
SAC_GEAR_rhs_rifles_ak74m_gl = ["rhs_weap_ak74m_fullplum_gp25", "rhs_weap_ak74m_gp25"];



//*************************************************************************************************************************
//Definiciones de uniformes, chalecos, facegear, cascos, etc.
//*************************************************************************************************************************

sac_gear_bis_nato_mtp_uniforms = ["U_B_CombatUniform_mcam", "U_B_CombatUniform_mcam_vest"];

sac_gear_bis_nato_tna_uniforms = ["U_B_T_Soldier_F", "U_B_T_Soldier_SL_F"];

sac_gear_bis_nato_wdl_uniforms = ["U_B_CombatUniform_mcam_wdl_f", "U_B_CombatUniform_vest_mcam_wdl_f"];

sac_gear_bis_nato_vests_rgr = ["V_PlateCarrier2_rgr", "V_PlateCarrier1_rgr"];
sac_gear_bis_nato_vests_blk = ["V_PlateCarrier2_blk", "V_PlateCarrier1_blk"];
sac_gear_bis_nato_vests_wdl = ["V_PlateCarrier2_wdl", "V_PlateCarrier1_wdl"];
sac_gear_bis_nato_vests_tna = ["V_PlateCarrier2_tna_F", "V_PlateCarrier1_tna_F"];

sac_gear_bis_nato_sf_headgear_light = ["H_HelmetB_light_snakeskin", "H_HelmetB_light_sand", "H_HelmetB_light_grass", "H_HelmetB_light_desert",
"H_HelmetB_light_black", "H_HelmetB_light"];
sac_gear_bis_nato_sf_headgear_special = ["H_HelmetSpecB_snakeskin", "H_HelmetSpecB_sand", "H_HelmetSpecB_paint1", "H_HelmetSpecB_paint2", "H_HelmetSpecB_blk",
"H_HelmetSpecB"];
sac_gear_bis_nato_sf_headgear = sac_gear_bis_nato_sf_headgear_light + sac_gear_bis_nato_sf_headgear_special;

sac_gear_bis_nato_facegear = ["G_Lowprofile", "G_Combat"];
sac_gear_bis_nato_facegear_tna = ["G_Lowprofile", "G_Combat_Goggles_tna_F"];

sac_gear_rhs_mbav_vests_gen = ["rhsusf_mbav_light", "rhsusf_mbav_medic", "rhsusf_mbav_rifleman"];
sac_gear_rhs_mbav_vests_ar = ["rhsusf_mbav_mg"]; //ar
sac_gear_rhs_mbav_vests_gl = ["rhsusf_mbav_grenadier"]; //gl

if (SAC_CUP) then {

	sac_gear_cup_vests_jpc_rngr = ["CUP_V_JPC_Fast_rngr", "CUP_V_JPC_tl_rngr", "CUP_V_JPC_medical_rngr", "CUP_V_JPC_communications_rngr"];
	sac_gear_cup_vests_jpc_mc = ["CUP_V_JPC_Fast_mc", "CUP_V_JPC_tl_mc", "CUP_V_JPC_medical_mc", "CUP_V_JPC_communications_mc"];
	sac_gear_cup_vests_jpc_coy = ["CUP_V_JPC_Fast_coy", "CUP_V_JPC_tl_coy", "CUP_V_JPC_medical_coy", "CUP_V_JPC_communications_coy"];
	
	sac_gear_cup_facewear_d = ["CUP_FR_NeckScarf5","CUP_FR_NeckScarf2","CUP_FR_NeckScarf3",
	"CUP_G_White_Scarf_Shades","CUP_G_Tan_Scarf_Shades","CUP_G_Oakleys_Drk","CUP_G_Oakleys_Clr",
	"CUP_G_Scarf_Face_Tan","CUP_G_Scarf_Face_Red","CUP_G_Scarf_Face_Blk","CUP_G_ESS_BLK_Scarf_Face_Red",
	"CUP_G_ESS_BLK_Scarf_Face_Blk","CUP_G_ESS_KHK_Scarf_Tan","CUP_G_ESS_BLK_Scarf_Red","CUP_G_ESS_BLK",
	"CUP_G_ESS_BLK_Dark"] call SAC_fnc_shuffleArray;
	
	sac_gear_cup_facewear_spc1 = ["CUP_FR_NeckScarf4","CUP_FR_NeckScarf5","CUP_FR_NeckScarf2",
	"CUP_G_White_Scarf_Shades","CUP_G_Tan_Scarf_Shades","CUP_G_Scarf_Face_White",
	"CUP_G_Scarf_Face_Tan","CUP_G_Scarf_Face_Red","CUP_G_ESS_BLK_Scarf_Face_White",
	"CUP_G_ESS_KHK_Scarf_Face_Tan","CUP_G_ESS_BLK_Scarf_Face_Red","CUP_G_ESS_KHK_Scarf_Tan",
	"CUP_G_ESS_BLK_Scarf_Red","CUP_G_ESS_BLK_Facewrap_Black"] call SAC_fnc_shuffleArray;
	
	sac_gear_cup_facewear_w = ["CUP_FR_NeckScarf","CUP_FR_NeckScarf3","CUP_G_Grn_Scarf_Shades",
	"CUP_G_Oakleys_Drk","CUP_G_Oakleys_Clr","CUP_G_Scarf_Face_Grn","CUP_G_Scarf_Face_Blk",
	"CUP_G_ESS_BLK_Scarf_Face_Grn","CUP_G_ESS_BLK_Scarf_Face_Blk","CUP_G_ESS_BLK_Scarf_Grn",
	"CUP_G_ESS_BLK_Scarf_Blk","CUP_G_ESS_BLK_Facewrap_Black_GPS","CUP_G_ESS_RGR_Facewrap_Tropical",
	"CUP_G_ESS_RGR_Facewrap_Ranger","CUP_G_ESS_RGR","CUP_G_ESS_RGR_Dark","CUP_RUS_Balaclava_rgr"
	] call SAC_fnc_shuffleArray;
	
	sac_gear_cup_facewear = [
	"CUP_G_ESS_BLK",
	"CUP_G_ESS_BLK_Scarf_Red",
	"CUP_G_ESS_BLK_Scarf_Grn",
	"CUP_G_Oakleys_Clr",
	"CUP_G_Scarf_Face_Tan",
	"CUP_G_ESS_KHK_Scarf_Tan",
	"CUP_G_ESS_KHK_Scarf_Face_Tan",
	"CUP_G_ESS_BLK_Scarf_Face_Grn",
	"CUP_G_Tan_Scarf_Shades",
	"CUP_G_ESS_BLK_Scarf_Face_Red",
	"CUP_G_Oakleys_Drk",
	"CUP_FR_NeckScarf",
	"CUP_G_ESS_BLK_Dark",
	"CUP_FR_NeckScarf5",
	"CUP_FR_NeckScarf2"
	];
	
	sac_gear_cup_uc_uniforms = ["CUP_I_B_PARA_Unit_5","CUP_I_B_PMC_Unit_37","CUP_I_B_PMC_Unit_38",
	"CUP_I_B_PMC_Unit_36","CUP_I_B_PMC_Unit_39","CUP_I_B_PMC_Unit_40","CUP_I_B_PMC_Unit_43",
	"CUP_I_B_PMC_Unit_41","CUP_I_B_PMC_Unit_42","CUP_I_B_PARA_Unit_3","CUP_I_B_PARA_Unit_1",
	"CUP_I_B_PARA_Unit_4","CUP_I_B_PARA_Unit_9","CUP_I_B_PARA_Unit_2","CUP_I_B_PARA_Unit_10",
	"CUP_I_B_PARA_Unit_6","CUP_I_B_PARA_Unit_7","CUP_I_B_PARA_Unit_8","CUP_I_B_PARA_Unit_14",
	"CUP_I_B_PARA_Unit_15","CUP_I_B_PARA_Unit_12","CUP_I_B_PARA_Unit_13","CUP_I_B_PARA_Unit_11"
	] call SAC_fnc_shuffleArray;
	
};

if (SAC_ERHS) then {
	sac_gear_erhs_mbav_vests_rgr_gen = ["mbavr_r", "mbavr_m", "mbavr_l"];
	sac_gear_erhs_mbav_vests_rgr_ar = ["mbavr_mg"]; //ar
	sac_gear_erhs_mbav_vests_rgr_gl = ["mbavr_gl"]; //gl

	sac_gear_erhs_mbav_vests_blk_gen = ["mbavblk_r", "mbavblk_m", "mbavblk_l"];
	sac_gear_erhs_mbav_vests_blk_ar = ["mbavblk_mg"]; //ar
	sac_gear_erhs_mbav_vests_blk_gl = ["mbavblk_gl"]; //gl
	
	sac_gear_erhs_nato_sf_mcblack_backpacks_sl = ["eagle_a3_blk"];
	if (SAC_spec4_lbt) then {sac_gear_erhs_nato_sf_mcblack_backpacks_sl pushBack "fatpack_od"};
};

RHS_MILITIA_GEN_weaponFamily = selectRandom ["AK74M", "AKM", "AKMS", "AKS74", "AKS74n", "M21", "M70"];

if (SAC_FLB) then {

	sac_gear_flb_backpacks_mc_common = ["flb_mappack_Standard_mc","flb_mappack_Standard_mc","flb_511std_A_mcm","flb_talon22_A_mcm"];
	sac_gear_flb_backpacks_mc_comms = ["flb_mappack_Radio_mc","flb_mappack_Radio_mc","flb_511radio_A_mcm","flb_talon22_A_mcm"];
	sac_gear_flb_backpacks_mc_medical = ["flb_mappack_Medical_mc"];

	sac_gear_flb_backpacks_rg_common = ["flb_mappack_Standard_od","flb_mappack_Standard_od","flb_511std_A_rgr","flb_talon22_A_rgr"];
	sac_gear_flb_backpacks_rg_comms = ["flb_mappack_Radio_od","flb_mappack_Radio_od","flb_511radio_A_rgr","flb_talon22_A_rgr"];
	sac_gear_flb_backpacks_rg_medical = ["flb_mappack_Medical_od"];

	sac_gear_flb_backpacks_tan_common = ["flb_mappack_Standard_tan","flb_mappack_Standard_tan","flb_511std_A_tan","flb_talon22_A_tan"];
	sac_gear_flb_backpacks_tan_comms = ["flb_mappack_Radio_tan","flb_mappack_Radio_tan","flb_511radio_A_tan","flb_talon22_A_tan"];
	sac_gear_flb_backpacks_tan_medical = ["flb_mappack_Medical_tan"];

};

sac_gear_bis_altis_guer_uniforms = ["U_BG_Guerrilla_6_1", "U_BG_Guerilla1_1", "U_BG_Guerilla2_2", "U_BG_Guerilla2_1",
"U_BG_Guerilla2_3", "U_BG_Guerilla3_1", "U_BG_leader", "U_I_C_Soldier_Para_2_F", "U_I_C_Soldier_Para_3_F",
"U_I_C_Soldier_Para_4_F", "U_I_C_Soldier_Para_1_F", "U_I_C_Soldier_Camo_F", "U_I_L_Uniform_01_deserter_F",
"U_I_E_Uniform_01_tanktop_F", "U_I_E_Uniform_01_sweater_F"] call SAC_fnc_shuffleArray;

sac_gear_bis_altis_guer_vests = ["V_TacChestrig_oli_F", "V_TacChestrig_grn_F", "V_TacChestrig_cbr_F",
"V_BandollierB_ghex_F", "V_HarnessO_ghex_F", "V_I_G_resistanceLeader_F",	"V_TacVest_oli", "V_TacVest_khk",
"V_TacVest_camo", "V_TacVest_brn", "V_TacVest_blk", "V_BandollierB_oli", "V_BandollierB_khk",
"V_BandollierB_rgr", "V_BandollierB_cbr", "V_BandollierB_blk", "V_HarnessO_gry", "V_HarnessO_brn"] call SAC_fnc_shuffleArray;

sac_gear_bis_most_backpacks = ["B_FieldPack_ghex_F", "B_AssaultPack_tna_F", "B_TacticalPack_oli", "B_TacticalPack_rgr",
"B_TacticalPack_blk","B_Kitbag_sgg", "B_Kitbag_mcamo", "B_Kitbag_rgr", "B_Kitbag_cbr", "B_FieldPack_oucamo", "B_FieldPack_oli",
"B_FieldPack_khk", "B_FieldPack_cbr","B_FieldPack_blk", "B_Carryall_oucamo", "B_Carryall_oli", "B_Carryall_mcamo",
"B_Carryall_khk", "B_Carryall_cbr", "B_AssaultPack_sgg", "B_AssaultPack_mcamo","B_AssaultPack_khk", "B_AssaultPack_rgr",
 "B_AssaultPack_cbr", "B_AssaultPack_blk"] call SAC_fnc_shuffleArray;

sac_gear_bis_most_carryall_backpacks = ["B_Carryall_oucamo", "B_Carryall_oli", "B_Carryall_mcamo","B_Carryall_khk", "B_Carryall_cbr"];

sac_gear_bis_altis_guer_goggles = ["G_Aviator", "G_Spectacles", "G_Shades_Black", "G_Bandanna_sport",
"G_Bandanna_shades", "G_Bandanna_oli", "G_Bandanna_khk","G_Bandanna_blk", "G_Bandanna_aviator",
"G_Balaclava_oli", "G_Balaclava_blk"] call SAC_fnc_shuffleArray;

sac_gear_bis_altis_guer_headgear = ["H_ShemagOpen_khk", "H_ShemagOpen_tan", "H_Shemag_olive",
"H_Booniehat_khk", "H_Booniehat_oli", "H_Booniehat_wdl", "H_Booniehat_mgrn"] call SAC_fnc_shuffleArray;


sac_gear_bis_tanoa_syndikat_uniforms = ["U_I_C_Soldier_Para_5_F", "U_I_C_Soldier_Para_2_F", "U_I_C_Soldier_Para_3_F",
"U_I_C_Soldier_Para_4_F", "U_I_C_Soldier_Para_1_F", "U_I_C_Soldier_Camo_F"] call SAC_fnc_shuffleArray;

sac_gear_bis_tanoa_syndikat_vests = ["V_TacChestrig_oli_F", "V_TacChestrig_grn_F", "V_TacChestrig_cbr_F",
"V_BandollierB_ghex_F", "V_HarnessO_ghex_F", "V_BandollierB_oli", "V_BandollierB_khk", "V_BandollierB_rgr",
"V_BandollierB_cbr", "V_BandollierB_blk", "V_TacVest_camo"] call SAC_fnc_shuffleArray;

sac_gear_bis_tanoa_syndikat_backpacks = ["B_FieldPack_taiga_F", "B_Carryall_green_F", "B_FieldPack_ghex_F",
"B_Carryall_ghex_F", "B_TacticalPack_oli", "B_TacticalPack_rgr", "B_TacticalPack_blk","B_FieldPack_oli",
"B_FieldPack_khk"] call SAC_fnc_shuffleArray;

sac_gear_bis_tanoa_syndikat_goggles = ["G_Aviator", "G_Spectacles", "G_Shades_Black", "G_Bandanna_sport",
"G_Bandanna_shades", "G_Bandanna_oli", "G_Bandanna_khk","G_Bandanna_blk", "G_Bandanna_aviator",
"G_Balaclava_oli", "G_Balaclava_blk"] call SAC_fnc_shuffleArray;

sac_gear_bis_tanoa_syndikat_headgear = ["H_Booniehat_wdl", "H_Booniehat_taiga", "H_Booniehat_mgrn",
"H_Booniehat_tna_F", "H_Booniehat_dgtl", "H_Booniehat_oli", "H_Booniehat_khk", "H_Bandanna_camo",
"H_Bandanna_surfer_blk", "H_Bandanna_sand", "H_Bandanna_sgg", "H_Bandanna_mcamo", "H_Bandanna_khk",
"H_Bandanna_cbr", "H_Bandanna_blu", "H_Bandanna_gry"] call SAC_fnc_shuffleArray;

sac_gear_bis_tanoa_syndikat_weaponFamily = "BIS_AKM";
if (SAC_RHS) then {sac_gear_bis_tanoa_syndikat_weaponFamily = RHS_MILITIA_GEN_weaponFamily};

sac_gear_bis_altis_guer_weaponFamily = "BIS_AKM";
if (SAC_RHS) then {sac_gear_bis_altis_guer_weaponFamily = RHS_MILITIA_GEN_weaponFamily};


sac_gear_rhs_goggles = [
"rhs_googles_black",
"rhs_googles_black",
"rhs_googles_black",
"rhs_googles_black",
"rhs_googles_black",
"rhs_ess_black",
"rhsusf_oakley_goggles_clr",
"rhsusf_oakley_goggles_blk"
] call SAC_fnc_shuffleArray;

sac_gear_bis_uc_uniforms = ["U_I_L_Uniform_01_tshirt_black_F","U_I_C_Soldier_Para_3_F",
"U_BG_Guerilla2_3","U_BG_Guerilla2_1","U_BG_Guerilla2_2"];


if (isClass(configFile >> "CfgWeapons" >> "gen3p_crye_tee4_uni")) then {

	sac_gear_nsw_g3 = ["gen3p_crye_tee4_uni","gen2p_cryes_o","gen2p_cryes_n","gen3p_crye_cut_uni","gen3_cryes_l","gen3_cryes_e","gen3_cryes_d","gen3_pata_rs_e","gen3p_crye_tee1_uni","gen3p_crye_rugby1_uni"];

};


if (SAC_75TH) then {

	sac_gear_75th_uniforms_ucp = ["G3_Ranger_PCU_Rpants_1_w", "G3_Ranger_USMC_1_w", "G3_Ranger_Rpants_1_w"];
	
	sac_gear_75th_uniforms_3cd = ["G3_Ranger_PCU_Rpants_2_w", "G3_Ranger_USMC_2_w", "G3_Ranger_Rpants_2_w"];
	
	sac_gear_75th_uniforms_mc = ["G3_Ranger_PCU_Rpants_3_w", "G3_Ranger_Rpants_3_w"];

	sac_gear_75th_uniforms_ronin_all = [
	"G3_Ranger_PCU_Rpants_2_w_green",
	"G3_Ranger_PCU_Rpants_3_w_tan",
	"G3_Ranger_PCU_Rpants_2_w_tan",
	"G3_Ranger_PCU_Rpants_1_w_tan",
	"G3_Ranger_PCU_Rpants_1_w_old",
	"G3_Ranger_PCU_Rpants_3_w_old",
	"G3_Ranger_Rpants_2_w",
	"G3_Ranger_Rpants_2_w_g2_mc",
	"G3_Ranger_Rpants_2_w_g3",
	"G3_Ranger_Rpants_2_w_g2",
	"G3_Ranger_Rpants_2_w_g2_khk",
	"G3_Ranger_Rpants_3_w_g2_3cd",
	"G3_Ranger_Rpants_1_w_g3",
	"G3_Ranger_Rpants_3_w_g2_khk",
	"G3_Ranger_Rpants_2_w_g3_ucp",
	"G3_Ranger_Rpants_3_w_g2",
	"G3_Ranger_Rpants_3_w_g3",
	"G3_Ranger_Rpants_3_w",
	"G3_Ranger_Rpants_3_w_g2_tan",
	"G3_Ranger_Rpants_1_w",
	"G3_Ranger_Rpants_1_w_g2",
	"G3_Ranger_Rpants_2_w_g2_tan",
	"G3_Ranger_Rpants_1_w_g2_3cd",
	"G3_Ranger_Rpants_1_w_g2_khk",
	"G3_Ranger_PCU_Rpants_2_w_old",
	"G3_Ranger_Rpants_1_w_g2_tan"
	];
	
	sac_gear_75th_vests = [
	"G_TacVest_PACA_Ranger_v1_1",
	"G_TacVest_PACA_Ranger_v2_2",
	"G_MBAV_Ranger_v7_1",
	"R_MBAV_Ranger_v8_1",
	"G_MBAV_Ranger_v5_1",
	"G_MBAV_Ranger_v4_1",
	"G_MBAV_Ranger_v3_1",
	"R_MBAV_Ranger_v10_1",
	"R_MBAV_Ranger_v2_1",
	"R_MBAV_Ranger_v3_1",
	"G_MBAV_Ranger_v10_1",
	"G_AFG_MBAV_Ranger_v9_1",
	"M_MAR_CIRAS_Ranger_v4_1",
	"G_AFG_MBAV_Ranger_v9_2",
	"M_MAR_CIRAS_Ranger_v2_1",
	"G_TacVest_PACA_Ranger_v3_3",
	"M_MAR_CIRAS_Ranger_v5_1",
	"M_MAR_CIRAS_Ranger_v1_1"
	];

	sac_gear_75_belts = ["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"];
	
	sac_gear_75th_facegear = [
	"AD_Scarf_Neck_b3",
	"AD_SP_Scarf_Neck_ESS_b5",
	"AD_Shemag_b3",
	"AD_Scarf_Neck_b1",
	"AD_Shemag_b4",
	"AD_SP_Scarf_Neck_ESS_b1",
	"AD_SP_Scarf_Neck_ESS_b7",
	"AD_Scarf_Neck_b4",
	"AD_ESS_Glasses_b1",
	"AD_SP_Scarf_Neck_ESS_b6",
	"AD_SP_Scarf_Neck_ESS_b2",
	"AD_Shemag_b5",
	"AD_SP_Shemag_ESS_b7",
	"AD_SP_Shemag_ESS_b3",
	"AD_SP_Shemag_ESS_b4",
	"AD_SP_Shemag_ESS_b8",
	"AD_ESS_Glasses_b2"
	];
	
	sac_gear_75th_facegear_spc1 = ["AD_Scarf_Neck_b3","AD_SP_Scarf_Neck_ESS_b4","AD_SP_Scarf_Neck_ESS_b6",
	"AD_Shemag_b3","AD_Shemag_b4","AD_Shemag_b5","AD_SP_Shemag_ESS_b8","AD_SP_Shemag_ESS_b4"];

	sac_gear_pr_sf_uniforms = ["G3_Ranger_PCU_Rpants_2_w","G3_Ranger_PCU_Rpants_4_w","G3_Ranger_PCU_Rpants_5_w",
	"G3_Ranger_PCU_Rpants_3_w","G3_Ranger_PCU_BDU_1_w","G3_Ranger_PCU_BDU_2_w","G3_Ranger_PCU_BDU_3_w",
	"G3_Ranger_PCU_BDU_5_w","G3_Ranger_PCU_BDU_4_w","G3_Ranger_Base_3_w","G3_Ranger_Base_2_w",
	"G3_Ranger_Base_1_w","G3_Ranger_Coverall_3_w","G3_Ranger_Coverall_1_w","G3_Ranger_Rshirt_Base_1_w",
	"G3_Ranger_Rshirt_Base_2_w","G3_Ranger_Rshirt_Base_4_w","G3_Ranger_Rshirt_Base_3_w",
	"G3_Ranger_Rpants_Base_2_w","G3_Ranger_Rpants_Base_1_w","G3_Ranger_KGloves_3_w","G3_Ranger_KGloves_1_w",
	"G3_Ranger_Flight_Gloves_3_w","G3_Ranger_Flight_Gloves_1_w","G2_Ranger_KG_2_w","G2_Ranger_KG_1_w",
	"BDU_Rshirt_Ranger_1_w","BDU_Rshirt_Ranger_4_w","BDU_Rshirt_Ranger_5_w","BDU_Rshirt_Ranger_2_w",
	"BDU_Rshirt_Ranger_3_w","BDU_Rshirt_Ranger_6_w","BDU_Rshirt_Ranger_7_w","G3_Ranger_PCU_Rpants_1_w"];
	sac_gear_pr_sf_vests = ["G_TacVest_Ranger_v4_4","G_TacVest_Ranger_v3_3","G_TacVest_Ranger_v2_2","G_TacVest_Ranger_v1_1",
	"G_TacVest_PACA_Ranger_v3_3","G_TacVest_PACA_Ranger_v2_2","G_TacVest_PACA_Ranger_v1_1","G_AFG_MBAV_Ranger_v9_1",
	"G_AFG_MBAV_Ranger_v8_1","G_AFG_MBAV_Ranger_v7_1","G_AFG_MBAV_Ranger_v6_1","G_AFG_MBAV_Ranger_v5_1",
	"G_AFG_MBAV_Ranger_v4_1","G_AFG_MBAV_Ranger_v3_1","G_AFG_MBAV_Ranger_v2_1","G_AFG_MBAV_Ranger_v10_1",
	"G_AFG_MBAV_Ranger_v1_1"];
	
	sac_gear_pr_vests_khaki_common = ["G_AFG_MBAV_Ranger_v5_1","G_AFG_MBAV_Ranger_v9_1"];
	sac_gear_pr_vests_khaki_gl = ["G_AFG_MBAV_Ranger_v6_1","G_AFG_MBAV_Ranger_v2_1"];
	
	//superpowerrangers
	sac_gear_pr_vests_with_backpacks = [
	"M_MAR_CIRAS_Ranger_v1_1",
	"M_MAR_CIRAS_Ranger_v2_1",
	"M_MAR_CIRAS_Ranger_v4_1",
	"G_AFG_MBAV_Ranger_v9_2",
	"G_AFG_MBAV_Ranger_v9_1",
	"G_MBAV_Ranger_v10_1",
	"G_MBAV_Ranger_v2_1",
	"G_MBAV_Ranger_v3_1",
	"G_MBAV_Ranger_v4_1",
	"G_MBAV_Ranger_v5_1",
	"G_MBAV_Ranger_v7_1",
	"R_MBAV_Ranger_v10_1",
	"R_MBAV_Ranger_v3_1",
	"R_MBAV_Ranger_v4_1",
	"R_MBAV_Ranger_v7_1",
	"R_MBAV_Ranger_v8_1",
	"R_MBAV_Ranger_v9_1",
	"G_TacVest_PACA_Ranger_v2_2",
	"G_TacVest_PACA_Ranger_v3_3"
	];
	
	//superpowerrangers
	sac_gear_pr_uniforms_g3 = [
	"G3_Ranger_Flight_Gloves_1_w",//full sleves, flight gloves, mc
	"G3_Ranger_Flight_Gloves_1_w",//full sleves, flight gloves, mc
	"G3_Ranger_Flight_Gloves_3_w",//full sleves, flight gloves, ocp
	
	"G3_Ranger_Flight_Gloves_1_w",//full sleves, flight gloves, mc
	"G3_Ranger_Flight_Gloves_1_w",//full sleves, flight gloves, mc
	"G3_Ranger_Flight_Gloves_3_w",//full sleves, flight gloves, ocp
	
	"G3_Ranger_Rshirt_Base_1_w",//tan t-shirt, g3 pants mc
	"G3_Ranger_Rshirt_Base_2_w",//khaki t-shirt, g3 pants mc
	"G3_Ranger_Rshirt_Base_3_w",//grey t-shirt, g3 pants mc
	"G3_Ranger_Rshirt_Base_4_w"//grey t-shirt, g3 pants ocp
	];
	
	//superpowerrangers
	sac_gear_pr_facewear_night = [
	"AD_Shemag_b5",
	"AD_Shemag_b4",
	"AD_Shemag_b3",
	"AD_Shemag_b1",
	"",
	"",
	""	
	];
	
	//superpowerrangers
	sac_gear_pr_facewear_day = [
	"AD_SP_Shemag_ESS_b1",
	"AD_SP_Shemag_ESS_b2",
	"AD_SP_Shemag_ESS_b3",
	"AD_SP_Shemag_ESS_b4",
	"AD_SP_Shemag_ESS_b5",
	"AD_SP_Shemag_ESS_b6",
	"AD_SP_Shemag_ESS_b7",
	"AD_SP_Shemag_ESS_b8",
	"AD_SP_Shemag_ESS_b9",
	"AD_SP_Shemag_ESS_b10",
	"AD_Shemag_b5",
	"AD_Shemag_b4",
	"AD_Shemag_b3",
	"AD_Shemag_b1",
	"",
	"",
	""	
	];
	

};

if (SAC_bumps) then {

	sac_gear_bumps_black = ["COD_Bump_21","COD_Bump_22","COD_Bump_8","COD_Bump_7"];
	sac_gear_bumps_green = ["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20",
	"COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"];
	sac_gear_bumps_grey = ["COD_Bump_6","COD_Bump_5","COD_Bump_26","COD_Bump_25","COD_Bump_4"];
	sac_gear_bumps_tan = ["COD_Bump_13","COD_Bump_16","COD_Bump_15","COD_Bump_2","COD_Bump_17","COD_Bump_14"];
	sac_gear_bumps_mc = ["COD_Bump_33","COD_Bump_35","COD_Bump_34","COD_Bump_32","COD_Bump_29","COD_Bump_36",
	"COD_Bump_31","COD_Bump_28","COD_Bump_30","COD_Bump_27"];

};



if (SAC_NSW) then {

	sac_gear_nsw_uniforms = ["cargoflannel_5_uni","cargoflannel_4_uni","cargoflannel_3_uni","cargoflannel_2_uni",
	"cargoflannel_1_uni","jeanrugbylong_1_uni","jeantee_2_uni","jeanrugby_2_uni","jeanrugby_1_uni","jeancoat_tan_uni",
	"jeancoat_black_uni","jeanflannel_8_uni","jeanflannel_7_uni","jeanflannel_6_uni","jeanflannel_5_uni",
	"jeanflannel_4_uni","jeanflannel_3_uni","jeanflannel_2_uni","jeanflannel_1_uni","cargorugbylong_1_uni",
	"cargotee_5_uni","cargotee_4_uni","cargotee_2_uni","cargorugby_2_uni","cargorugby_1_uni","cargocoat_tan_uni_2",
	"cargocoat_tan_uni","cargocoat_black_uni_4","cargocoat_black_uni_3","cargocoat_black_uni_2","cargocoat_black_uni",
	"cargoflannel_49_uni","cargoflannel_48_uni","cargoflannel_47_uni","cargoflannel_46_uni","cargoflannel_45_uni",
	"cargoflannel_44_uni","cargoflannel_43_uni","cargoflannel_42_uni","cargoflannel_41_uni","cargoflannel_40_uni",
	"cargoflannel_39_uni","cargoflannel_38_uni","cargoflannel_37_uni","cargoflannel_36_uni","cargoflannel_35_uni",
	"cargoflannel_34_uni","cargoflannel_33_uni","cargoflannel_32_uni","cargoflannel_31_uni","cargoflannel_30_uni",
	"cargoflannel_29_uni","cargoflannel_28_uni","cargoflannel_26_uni","cargoflannel_24_uni","cargoflannel_23_uni",
	"cargoflannel_22_uni","cargoflannel_21_uni","cargoflannel_20_uni","cargoflannel_19_uni","cargoflannel_18_uni",
	"cargoflannel_17_uni","cargoflannel_16_uni","cargoflannel_15_uni","cargoflannel_14_uni","cargoflannel_13_uni",
	"cargoflannel_12_uni","cargoflannel_11_uni","cargoflannel_10_uni","cargoflannel_9_uni","cargoflannel_8_uni",
	"cargoflannel_7_uni","cargoflannel_6_uni","cargoflannel_25_uni","cargoflannel_27_uni"];

};

if (SAC_TFN) then {

	sac_gear_tfn_uniforms = [
	"TFN_Gen3_Gen3_rs_or_cb_Flag_uniform",
	"TFN_Gen3_Gen3_fs_or_cb_Flag_uniform"
	];
	
	sac_gear_tfn_vests = [
	"AVS_Ronin_B_Sling",
	"AVS_Ronin_A_Sling",
	"AVS_Tyr_A_Sling"
	];
	
	sac_gear_tfn_vests_gl = ["AVS_40mm_Sling"];
	
	sac_gear_tfn_backpacks = [
	"TL_556_C",
	"TL_556_B",
	"TL_556_A",
	"Assaulter_556_C",
	"Assaulter_556_B",
	"Assaulter_556_A"	
	];
	
	sac_gear_tfn_backpacks_mg = [
	"MG_556_C",
	"MG_556_B",
	"MG_762_A",
	"MG_556_A"
	];
	
	sac_gear_tfn_facewear = [
	"TFN_Mframeb_WH_shemagh",
	"TFN_Mframeb_BLK_shemagh",
	"TFN_Mframeb_WH",
	"TFN_Mframeb_BLK"	
	];


};

if (SAC_TFL) then {

	sac_gear_tfl_uniforms_g3_mc = [
	"tfl_g3_field_uniform",
	"tfl_g3_field_r_uniform",
	"tfl_g3_field_uniform",
	"tfl_g3_field_r_uniform",
	"tfl_g3_field_uniform",
	"tfl_g3_field_r_uniform",
	"tfl_new_MC_rs_uniform_g",
	"tfl_new_MC_fs_uniform_g",
	"tfl_new_MC_rs_uniform_g",
	"tfl_new_MC_fs_uniform_g",
	"tfl_new_MC_rs_uniform_g",
	"tfl_new_MC_fs_uniform_g",
	"tfl_new_MC_rs_uniform_g",
	"tfl_new_MC_fs_uniform_g",
	"tfl_new_MC_rs_uniform_g",
	"tfl_new_MC_fs_uniform_g",
	"tfl_new_MC_rs_uniform_g",
	"tfl_new_MC_fs_uniform_g",
	"tfl_new_MC_rs_uniform_g",
	"tfl_new_MC_fs_uniform_g",
	"gatekeep_Y19_2_uniform",
	"louetta_g3_mc_rugby_tan_uniform",
	"gatekeep_Y19_2_uniform",
	"louetta_g3_mc_rugby_tan_uniform",
	"gatekeep_Y19_2_uniform",
	"louetta_g3_mc_rugby_tan_uniform",
	"gatekeep_Y19_2_uniform",
	"louetta_g3_mc_rugby_tan_uniform"
	];
	
	sac_gear_tfl_uniforms_g3_mc_regular = ["tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g"];
	
	sac_gear_tfl_uniforms_g3_mca = [
	"tfl_new_MCA_fs_uniform_g",
	"tfl_new_MCA_rs_uniform_g",
	"tfl_new_MCA_fs_uniform_g",
	"tfl_new_MCA_rs_uniform_g",
	"tfl_new_MCA_fs_uniform_g",
	"tfl_new_MCA_rs_uniform_g",
	"tfl_new_MCA_fs_uniform_g",
	"tfl_new_MCA_rs_uniform_g",
	"tfs_g3_codpcu_fde_MCA_uni",
	"tfl_pcu_brown_mca_g_uniform"
	];
	
	sac_gear_tfl_uniforms_g3_mix_solid = [
	"tfl_new_CBGRY_rs_uniform_g",
	"tfl_new_CBMCB_rs_uniform_g",
	"tfl_new_CBRG_rs_uniform_g",
	"tfl_new_GRYCB_rs_uniform_g",
	"tfl_new_GRYMCB_rs_uniform_g",
	"tfl_new_GRYRG_rs_uniform_g",
	"tfl_new_MCBCB_rs_uniform_g",
	"tfl_new_MCBGRY_rs_uniform_g",
	"tfl_new_MCBRG_rs_uniform_g",
	"tfl_new_RGMCB_rs_uniform_g",
	"tfl_new_RGGRY_rs_uniform_g"
	];
	
	sac_gear_tfl_uniforms_g3_mct = [
	"tfl_g3_field_mct_uniform",
	"tfl_g3_field_mct_r_uniform",
	"tfl_new_MCT_fs_uniform_g",
	"tfl_new_MCT_rs_uniform_g",
	"tfl_new_MCT_fs_uniform_g",
	"tfl_new_MCT_rs_uniform_g",
	"tfl_new_MCT_fs_uniform_g",
	"tfl_new_MCT_rs_uniform_g",
	"tfl_new_MCT_fs_uniform_g",
	"tfl_new_MCT_rs_uniform_g"
	];

	sac_gear_tfl_uniforms_g3_mcb = [
	"tfl_new_MCB_rs_uniform_g",
	"tfl_new_MCB_fs_uniform_g",
	"tfl_new_MCB_rs_uniform_g",
	"tfl_new_MCB_fs_uniform_g",
	"tfl_new_MCB_rs_uniform_g",
	"tfl_new_MCB_fs_uniform_g",
	"tfl_new_MCB_rs_uniform_g",
	"tfl_new_MCB_fs_uniform_g",
	"tfs_g3_codpcu_blk_mcb_uni",
	"tfl_pcu_b_mcb_g_uniform"
	];

	sac_gear_tfl_uniforms_g3_rg = ["tfl_new_RG_rs_uniform_g","tfl_new_RG_fs_uniform_g"];

	//chalecos TFL multicam
	sac_gear_tfl_vests_mc_common_no_belt = ["Crye_JPC_TeamLeader_MC_9_NoBelt","Crye_JPC_TeamLeader_MC_3_NoBelt",
	"Crye_JPC_TeamLeader_MC_2_NoBelt","Crye_JPC_TeamLeader_MC_1_NoBelt","Crye_JPC_MC_11_NoBelt",
	"Crye_JPC_MC_10_NoBelt","Crye_AVS_MC_TeamLeader_9_NoBelt","Crye_AVS_MC_TeamLeader_2_NoBelt",
	"Crye_AVS_MC_TeamLeader_1_NoBelt","Crye_AVS_MC_11_NoBelt","Crye_AVS_MC_10_NoBelt"];
	sac_gear_tfl_vests_mc_common_belt = ["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3",
	"Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10",
	"Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1",
	"Crye_AVS_MC_11","Crye_AVS_MC_10"];
	sac_gear_tfl_vests_mc_avs_common_belt = ["Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2",
	"Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"];
	sac_gear_tfl_vests_mc_common = sac_gear_tfl_vests_mc_common_no_belt + sac_gear_tfl_vests_mc_common_belt;
	sac_gear_tfl_vests_mc_medic_no_belt = ["Crye_JPC_Medic_MC_NoBelt","Crye_AVS_MC_Medic_1_NoBelt"];
	sac_gear_tfl_vests_mc_medic_belt = ["Crye_JPC_Medic_MC_1","Crye_AVS_MC_Medic_1"];
	sac_gear_tfl_vests_mc_avs_medic_belt = ["Crye_AVS_MC_Medic_1"];
	sac_gear_tfl_vests_mc_medic = sac_gear_tfl_vests_mc_medic_no_belt + sac_gear_tfl_vests_mc_medic_belt;

	//chalecos TFL coyote brown
	sac_gear_tfl_vests_cb_common_no_belt = ["Crye_AVS_CB_TeamLeader_9_NoBelt","Crye_AVS_CB_TeamLeader_2_NoBelt",
	"Crye_AVS_CB_TeamLeader_1_NoBelt","Crye_AVS_CB_11_NoBelt","Crye_AVS_CB_10_NoBelt",
	"Crye_JPC_TeamLeader_CB_9_NoBelt","Crye_JPC_TeamLeader_CB_2_NoBelt",
	"Crye_JPC_TeamLeader_CB_1_NoBelt","Crye_JPC_CB_11_NoBelt","Crye_JPC_CB_10_NoBelt"];
	sac_gear_tfl_vests_cb_common_belt = ["Crye_AVS_CB_TeamLeader_9","Crye_AVS_CB_TeamLeader_2",
	"Crye_AVS_CB_TeamLeader_1","Crye_AVS_CB_11","Crye_AVS_CB_10","Crye_JPC_TeamLeader_CB_2",
	"Crye_JPC_TeamLeader_CB_1","Crye_JPC_CB_11","Crye_JPC_CB_10"];
	sac_gear_tfl_vests_cb_avs_common_belt = ["Crye_AVS_CB_TeamLeader_9","Crye_AVS_CB_TeamLeader_2",
	"Crye_AVS_CB_TeamLeader_1","Crye_AVS_CB_11","Crye_AVS_CB_10"];
	sac_gear_tfl_vests_cb_common = sac_gear_tfl_vests_cb_common_no_belt + sac_gear_tfl_vests_cb_common_belt;
	sac_gear_tfl_vests_cb_medic_no_belt = ["Crye_AVS_CB_Medic_1_NoBelt","Crye_JPC_Medic_CB_NoBelt"];
	sac_gear_tfl_vests_cb_medic_belt = ["Crye_AVS_CB_Medic_1","Crye_JPC_TeamLeader_CB_9"];
	sac_gear_tfl_vests_cb_avs_medic_belt = ["Crye_AVS_CB_Medic_1"];
	sac_gear_tfl_vests_cb_medic = sac_gear_tfl_vests_cb_medic_no_belt + sac_gear_tfl_vests_cb_medic_belt;

	//chalecos TFL ranger green
	sac_gear_tfl_vests_rg_common_no_belt = ["Crye_JPC_TeamLeader_RG_9_NoBelt","Crye_JPC_TeamLeader_RG_3_NoBelt",
	"Crye_JPC_RG_12_NoBelt","Crye_JPC_RG_11_NoBelt","Crye_JPC_RG_10_NoBelt","Crye_AVS_RG_TeamLeader_9_NoBelt",
	"Crye_AVS_RG_TeamLeader_2_NoBelt","Crye_AVS_RG_TeamLeader_1_NoBelt","Crye_AVS_RG_11_NoBelt",
	"Crye_AVS_RG_10_NoBelt"];
	sac_gear_tfl_vests_rg_common_belt = ["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3",
	"Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10",
	"Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"];
	sac_gear_tfl_vests_rg_avs_common_belt = ["Crye_AVS_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2",
	"Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"];
	sac_gear_tfl_vests_rg_common = sac_gear_tfl_vests_rg_common_no_belt + sac_gear_tfl_vests_rg_common_belt;
	sac_gear_tfl_vests_rg_medic_no_belt = ["Crye_JPC_Medic_RG_NoBelt","Crye_AVS_RG_Medic_1_NoBelt"];
	sac_gear_tfl_vests_rg_medic_belt = ["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"];
	sac_gear_tfl_vests_rg_avs_medic_belt = ["Crye_AVS_RG_Medic_1"];
	sac_gear_tfl_vests_rg_medic = sac_gear_tfl_vests_rg_medic_no_belt + sac_gear_tfl_vests_rg_medic_belt;

	sac_gear_tfl_facewear = ["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk",
	"tfl_arc_bala_blk","tfl_arc_bala_glasses","tfl_arc_bala","tfl_ess_blackshaded","nid_gatorzblk_1","nid_detc"];
	sac_gear_tfl_facewear_set1 = ["tfl_m_frame_blackshaded","tfl_arc_bala_glasses","tfl_ess_blackshaded","tfl_jtf2_safety","nid_gatorzblk_1","nid_detc"]; //day, arid
	sac_gear_tfl_facewear_set2 = ["tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety","nid_gatorzblk_1","nid_detc"]; //day, woodland
	sac_gear_tfl_facewear_set3 = ["tfl_m_frame_blackclear","tfl_arc_bala_glasses_blk","tfl_jtf2_safety"]; //night, woodland
	sac_gear_tfl_facewear_set4 = ["tfl_m_frame_blackclear","tfl_arc_bala_glasses_blk","tfl_arc_bala_glasses","tfl_jtf2_safety"]; //night, arid

	sac_gear_tfl_nvgs = [
	"Louetta_PVS31A_2",
	"Louetta_PVS31A_2_alt",
	"Louetta_PVS31A_4",
	"Louetta_PVS31A_4_alt",
	"Louetta_PVS31A_6",
	"Louetta_PVS31A_6_alt"
	];
	
	sac_gear_tfl_caps = [
	"mac_cap_usatgs_coms",
	"mac_cap_usamc_coms",
	"mac_cap_sealsnipertgs_coms",
	"mac_cap_raiders_coms",
	"mac_cap_marsoc2_coms",
	"mac_cap_ex17_coms",
	"mac_cap_browns_coms",
	"mac_cap_blackhawks_coms",
	"tfl_cap_arcblk_coms"	
	];
	
	sac_gear_tfl_beanies = [
	"tfl_fleece_hat_peltors",
	"tfl_fleece_tan_hat_peltors",
	"tfl_beanie_hat_peltors",
	"tfl_beanie_hat_green_peltors",
	"tfl_beanie_tan_hat_peltors"
	];
	
	sac_gear_tfc_boonies = ["TFCH19"];
	
	sac_gear_tfc_backpacks = ["TFC_P19"]; //Mystery Ranch 3DA
	
	sac_gear_avalon_backpacks = ["AVLN_Gunslinger"];
	
	sac_gear_tfl_opscore_mt_mc = [
	"Maritime_NR_ComtacIII153",
	"Maritime_ComtacIII_Arc153",
	"Maritime_Cover_ComtacIV_Arc153",
	"Maritime_Cover_ComtacIII_Arc153",
	"Maritime_Cover_ComtacIV_Arc153",
	"Maritime_Cover_ComtacIII_Arc153"
	];
	

};

if (isNil "SAC_GEAR_preferred_nvg") then {

	SAC_GEAR_preferred_nvg = "rhsusf_ANPVS_14";
	//SAC_GEAR_preferred_nvg = "meu_ANPVS_14";
	//SAC_GEAR_preferred_nvg = SAC_GEAR_bis_nvg;
	//SAC_GEAR_preferred_nvg = sac_gear_tfl_nvgs;

};

if (isNil "sac_gear_preferredWeaponFamily") then {

	//sac_gear_preferredWeaponFamily = "RHS_HK416";
	sac_gear_preferredWeaponFamily = "MX";

};



//**********************************************************************************



SAC_GEAR_applyLoadoutByClass = {

	params ["_unit"];

	if (faction _unit == "CIV_F") exitWith {};

	switch (typeOf _unit) do {

		case "B_Soldier_SL_F": {[_unit, SAC_GEAR_B_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		case "B_Soldier_TL_F": {[_unit, SAC_GEAR_B_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};
		case "B_Soldier_F": {[_unit, SAC_GEAR_B_loadoutProfile, "RIFLEMAN"] call SAC_GEAR_applyLoadout};
		case "B_Soldier_GL_F": {[_unit, SAC_GEAR_B_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		case "B_soldier_AR_F": {[_unit, SAC_GEAR_B_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		case "B_HeavyGunner_F": {[_unit, SAC_GEAR_B_loadoutProfile, "MG"] call SAC_GEAR_applyLoadout};
		case "B_medic_F": {[_unit, SAC_GEAR_B_loadoutProfile, "MEDIC"] call SAC_GEAR_applyLoadout};
		case "B_soldier_repair_F": {[_unit, SAC_GEAR_B_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		case "B_soldier_LAT_F": {[_unit, SAC_GEAR_B_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		case "B_soldier_AT_F": {[_unit, SAC_GEAR_B_loadoutProfile, "HAT"] call SAC_GEAR_applyLoadout};
		case "B_soldier_AA_F": {[_unit, SAC_GEAR_B_loadoutProfile, "AA"] call SAC_GEAR_applyLoadout};
		case "B_soldier_M_F": {[_unit, SAC_GEAR_B_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		case "B_crew_F": {[_unit, SAC_GEAR_B_loadoutProfile, "CREW"] call SAC_GEAR_applyLoadout};
		case "B_Helipilot_F": {[_unit, SAC_GEAR_B_loadoutProfile, "HELIPILOT"] call SAC_GEAR_applyLoadout};
		case "B_Survivor_F": {[_unit, SAC_GEAR_B_loadoutProfile, "UNARMED"] call SAC_GEAR_applyLoadout};
		case "B_Soldier_unarmed_F": {[_unit, SAC_GEAR_B_loadoutProfile, "UNARMED"] call SAC_GEAR_applyLoadout};

		case "B_G_Soldier_SL_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		case "B_G_Soldier_TL_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};
		case "B_G_Soldier_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "RIFLEMAN"] call SAC_GEAR_applyLoadout};
		case "B_G_Soldier_GL_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		case "B_G_Soldier_AR_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		case "B_G_medic_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "MEDIC"] call SAC_GEAR_applyLoadout};
		case "B_G_engineer_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		case "B_G_Soldier_LAT_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		case "B_G_Soldier_M_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		case "B_G_Soldier_unarmed_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "UNARMED"] call SAC_GEAR_applyLoadout};
		case "B_G_Survivor_F": {[_unit, SAC_GEAR_B_G_loadoutProfile, "UNARMED"] call SAC_GEAR_applyLoadout};

		// case "O_Soldier_SL_F": {[_unit, SAC_GEAR_O_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		// case "O_Soldier_TL_F": {[_unit, SAC_GEAR_O_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};
		// case "O_Soldier_F": {[_unit, SAC_GEAR_O_loadoutProfile, "RIFLEMAN"] call SAC_GEAR_applyLoadout};
		// case "O_Soldier_GL_F": {[_unit, SAC_GEAR_O_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		// case "O_Soldier_AR_F": {[_unit, SAC_GEAR_O_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		// case "O_HeavyGunner_F": {[_unit, SAC_GEAR_O_loadoutProfile, "MG"] call SAC_GEAR_applyLoadout};
		// case "O_medic_F": {[_unit, SAC_GEAR_O_loadoutProfile, "MEDIC"] call SAC_GEAR_applyLoadout};
		// case "O_engineer_F": {[_unit, SAC_GEAR_O_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		// case "O_Soldier_LAT_F": {[_unit, SAC_GEAR_O_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		// case "O_Soldier_AT_F": {[_unit, SAC_GEAR_O_loadoutProfile, "HAT"] call SAC_GEAR_applyLoadout};
		// case "O_Soldier_AA_F": {[_unit, SAC_GEAR_O_loadoutProfile, "AA"] call SAC_GEAR_applyLoadout};
		// case "O_soldier_M_F": {[_unit, SAC_GEAR_O_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		// case "O_crew_F": {[_unit, SAC_GEAR_O_loadoutProfile, "CREW"] call SAC_GEAR_applyLoadout};
		// case "O_Soldier_unarmed_F": {[_unit, SAC_GEAR_O_loadoutProfile, "UNARMED"] call SAC_GEAR_applyLoadout};
		// case "O_Survivor_F": {[_unit, SAC_GEAR_O_loadoutProfile, "UNARMED"] call SAC_GEAR_applyLoadout};
		
		// case "O_T_Soldier_SL_F": {[_unit, SAC_GEAR_O_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		// case "O_T_Soldier_TL_F": {[_unit, SAC_GEAR_O_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};
		// case "O_T_Soldier_F": {[_unit, SAC_GEAR_O_loadoutProfile, "RIFLEMAN"] call SAC_GEAR_applyLoadout};
		// case "O_T_Soldier_GL_F": {[_unit, SAC_GEAR_O_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		// case "O_T_Soldier_AR_F": {[_unit, SAC_GEAR_O_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		// case "O_T_Medic_F": {[_unit, SAC_GEAR_O_loadoutProfile, "MEDIC"] call SAC_GEAR_applyLoadout};
		// case "O_T_Engineer_F": {[_unit, SAC_GEAR_O_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		// case "O_T_Soldier_LAT_F": {[_unit, SAC_GEAR_O_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		// case "O_T_Soldier_AT_F": {[_unit, SAC_GEAR_O_loadoutProfile, "HAT"] call SAC_GEAR_applyLoadout};
		// case "O_T_Soldier_AA_F": {[_unit, SAC_GEAR_O_loadoutProfile, "AA"] call SAC_GEAR_applyLoadout};
		// case "O_T_Soldier_M_F": {[_unit, SAC_GEAR_O_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		// case "O_T_Crew_F": {[_unit, SAC_GEAR_O_loadoutProfile, "CREW"] call SAC_GEAR_applyLoadout};
		// case "O_T_Soldier_unarmed_F": {[_unit, SAC_GEAR_O_loadoutProfile, "UNARMED"] call SAC_GEAR_applyLoadout};

		case "O_recon_TL_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "TL", true] call SAC_GEAR_applyLoadout};
		case "O_recon_JTAC_F";
		case "O_recon_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "RIFLEMAN", true] call SAC_GEAR_applyLoadout};
		case "O_recon_medic_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "MEDIC", true] call SAC_GEAR_applyLoadout};
		case "O_recon_exp_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "ENG", true] call SAC_GEAR_applyLoadout};
		case "O_recon_LAT_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "LAT", true] call SAC_GEAR_applyLoadout};
		case "O_Pathfinder_F";
		case "O_recon_M_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "MM", true] call SAC_GEAR_applyLoadout};
		
		case "O_T_Recon_TL_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "TL", true] call SAC_GEAR_applyLoadout};
		case "O_T_Recon_JTAC_F";
		case "O_T_Recon_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "RIFLEMAN", true] call SAC_GEAR_applyLoadout};
		case "O_T_Recon_Medic_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "MEDIC", true] call SAC_GEAR_applyLoadout};
		case "O_T_Recon_Exp_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "ENG", true] call SAC_GEAR_applyLoadout};
		case "O_T_Recon_LAT_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "LAT", true] call SAC_GEAR_applyLoadout};
		case "O_T_Recon_M_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "MM", true] call SAC_GEAR_applyLoadout};

		// case "O_G_Soldier_SL_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		// case "O_G_Soldier_TL_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};
		// case "O_G_Soldier_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "RIFLEMAN"] call SAC_GEAR_applyLoadout};
		// case "O_G_Soldier_GL_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		// case "O_G_Soldier_AR_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		// case "O_G_medic_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "MEDIC"] call SAC_GEAR_applyLoadout};
		// case "O_G_engineer_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		// case "O_G_Soldier_LAT_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		// case "O_G_Soldier_M_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		// case "O_G_Survivor_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "UNARMED"] call SAC_GEAR_applyLoadout};
		// case "O_G_Soldier_unarmed_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "UNARMED"] call SAC_GEAR_applyLoadout};
		
		case "I_C_Soldier_Para_2_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		case "I_C_Soldier_Para_7_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};
		case "I_C_Soldier_Para_1_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "RIFLEMAN"] call SAC_GEAR_applyLoadout};
		case "I_C_Soldier_Para_6_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		case "I_C_Soldier_Para_4_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		case "I_C_Soldier_Para_3_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "MEDIC"] call SAC_GEAR_applyLoadout};
		case "I_C_Soldier_Para_8_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		case "I_C_Soldier_Para_5_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		case "I_C_Soldier_base_unarmed_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "UNARMED"] call SAC_GEAR_applyLoadout};
		
		case "VW_VC_LAR": {[_unit, SAC_GEAR_O_G_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		case "VW_VC_AR": {[_unit, SAC_GEAR_O_G_loadoutProfile, "MG"] call SAC_GEAR_applyLoadout};
		case "VW_VC_MEDIC": {[_unit, SAC_GEAR_O_G_loadoutProfile, "MEDIC"] call SAC_GEAR_applyLoadout};
		case "VW_VC_ENG": {[_unit, SAC_GEAR_O_G_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		case "VW_VC_BRFL": {[_unit, SAC_GEAR_O_G_loadoutProfile, "B_RIFLEMAN"] call SAC_GEAR_applyLoadout};
		case "VW_VC_RFL": {[_unit, SAC_GEAR_O_G_loadoutProfile, "RIFLEMAN"] call SAC_GEAR_applyLoadout};
		case "VW_VC_MRK": {[_unit, SAC_GEAR_O_G_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		case "VW_VC_AT": {[_unit, SAC_GEAR_O_G_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		case "VW_VC_SL": {[_unit, SAC_GEAR_O_G_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		case "VW_VC_TL": {[_unit, SAC_GEAR_O_G_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};

		case "O_R_recon_AR_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		case "O_R_recon_exp_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		case "O_R_recon_GL_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		case "O_R_recon_JTAC_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "RIFLEMAN"] call SAC_GEAR_applyLoadout};
		case "O_R_recon_M_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		case "O_R_recon_medic_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "MEDIC"] call SAC_GEAR_applyLoadout};
		case "O_R_recon_LAT_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		case "O_R_recon_TL_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};

		case "O_R_Soldier_AR_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		case "O_R_soldier_exp_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		case "O_R_Soldier_GL_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		case "O_R_JTAC_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "RIFLEMAN"] call SAC_GEAR_applyLoadout};
		case "O_R_soldier_M_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		case "O_R_medic_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "MEDIC"] call SAC_GEAR_applyLoadout};
		case "O_R_Soldier_LAT_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		case "O_R_Soldier_TL_F": {[_unit, SAC_GEAR_O_SF_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};

		// MANU
		// SYRIAN_ARMY_ALTIS
		case "LOP_SYR_Infantry_SL":         {[_unit, SAC_GEAR_O_G_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_TL":         {[_unit, SAC_GEAR_O_G_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_Rifleman":   {[_unit, SAC_GEAR_O_G_loadoutProfile, "RIF"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_Rifleman_2": {[_unit, SAC_GEAR_O_G_loadoutProfile, "RIF"] call SAC_GEAR_applyLoadout};
		case "LOP_TKA_Infantry_Rifleman_3": {[_unit, SAC_GEAR_O_G_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_Marksman":   {[_unit, SAC_GEAR_O_G_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_MG":         {[_unit, SAC_GEAR_O_G_loadoutProfile, "H_MG"] call SAC_GEAR_applyLoadout};
		case "LOP_TKA_Infantry_MG":         {[_unit, SAC_GEAR_O_G_loadoutProfile, "L_MG"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_MG_Asst":    {[_unit, SAC_GEAR_O_G_loadoutProfile, "MG_Asst"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_Grenadier":  {[_unit, SAC_GEAR_O_G_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_Engineer":   {[_unit, SAC_GEAR_O_G_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_Corpsman":   {[_unit, SAC_GEAR_O_G_loadoutProfile, "MED"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_AT":         {[_unit, SAC_GEAR_O_G_loadoutProfile, "AT"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_AT_Asst":    {[_unit, SAC_GEAR_O_G_loadoutProfile, "AT_Asst"] call SAC_GEAR_applyLoadout};
		case "LOP_TKA_Infantry_AA":         {[_unit, SAC_GEAR_O_G_loadoutProfile, "AA"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_Crewman":    {[_unit, SAC_GEAR_O_G_loadoutProfile, "CREW"] call SAC_GEAR_applyLoadout};
		case "LOP_SYR_Infantry_Pilot":      {[_unit, SAC_GEAR_O_G_loadoutProfile, "PILOT"] call SAC_GEAR_applyLoadout};

		// zombies independiente
		case "Zombie_G_RC_LDF": {[_unit, SAC_GEAR_O_loadoutProfile, "LDF"] call SAC_GEAR_applyLoadout};
		case "Zombie_G_RC_FIA": {[_unit, SAC_GEAR_O_loadoutProfile, "FIA"] call SAC_GEAR_applyLoadout};
		case "Zombie_G_RC_Civ": {[_unit, SAC_GEAR_O_loadoutProfile, "Civ"] call SAC_GEAR_applyLoadout};

		//rusia_2022_loadout
		case "rhs_vdv_sergeant":                {[_unit, SAC_GEAR_O_G_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_efreitor":                {[_unit, SAC_GEAR_O_G_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_machinegunner":           {[_unit, SAC_GEAR_O_G_loadoutProfile, "HMG"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_machinegunner_assistant": {[_unit, SAC_GEAR_O_G_loadoutProfile, "MG_A"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_arifleman_rpk":           {[_unit, SAC_GEAR_O_G_loadoutProfile, "LMG"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_at":                      {[_unit, SAC_GEAR_O_G_loadoutProfile, "AT"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_aa":                      {[_unit, SAC_GEAR_O_G_loadoutProfile, "AT_A"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_strelok_rpg_assist":      {[_unit, SAC_GEAR_O_G_loadoutProfile, "AA"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_rifleman":                {[_unit, SAC_GEAR_O_G_loadoutProfile, "RIF"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_rifleman_lite":           {[_unit, SAC_GEAR_O_G_loadoutProfile, "RIF_L"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_LAT":                     {[_unit, SAC_GEAR_O_G_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_grenadier":               {[_unit, SAC_GEAR_O_G_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_engineer":                {[_unit, SAC_GEAR_O_G_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_medic":                   {[_unit, SAC_GEAR_O_G_loadoutProfile, "MED"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_marksman":                {[_unit, SAC_GEAR_O_G_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_officer":                 {[_unit, SAC_GEAR_O_G_loadoutProfile, "RO"] call SAC_GEAR_applyLoadout};
		case "rhs_pilot_combat_heli":           {[_unit, SAC_GEAR_O_G_loadoutProfile, "PILOT"] call SAC_GEAR_applyLoadout};
		case "rhs_vdv_crew":                    {[_unit, SAC_GEAR_O_G_loadoutProfile, "CREW"] call SAC_GEAR_applyLoadout}; 

		// korea_50_summer
		case "O_soldier_M_F":       {[_unit, SAC_GEAR_O_G_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		case "O_Soldier_A_F":       {[_unit, SAC_GEAR_O_G_loadoutProfile, "MG_ammo"] call SAC_GEAR_applyLoadout};
		case "O_soldier_UAV_F":     {[_unit, SAC_GEAR_O_G_loadoutProfile, "RO"] call SAC_GEAR_applyLoadout};
		case "O_officer_F":         {[_unit, SAC_GEAR_O_G_loadoutProfile, "OFC"] call SAC_GEAR_applyLoadout};
		case "O_medic_F":           {[_unit, SAC_GEAR_O_G_loadoutProfile, "MED"] call SAC_GEAR_applyLoadout};
		case "O_Soldier_SL_F":      {[_unit, SAC_GEAR_O_G_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		case "O_Soldier_TL_F":      {[_unit, SAC_GEAR_O_G_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};
		case "O_engineer_F":        {[_unit, SAC_GEAR_O_G_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		case "O_Soldier_GL_F":      {[_unit, SAC_GEAR_O_G_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		case "O_Soldier_AR_F":      {[_unit, SAC_GEAR_O_G_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		case "O_Soldier_lite_F":    {[_unit, SAC_GEAR_O_G_loadoutProfile, "RIF_L"] call SAC_GEAR_applyLoadout};
		case "O_Soldier_unarmed_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "RIF_ALT"] call SAC_GEAR_applyLoadout};
		case "O_Soldier_LAT_F":     {[_unit, SAC_GEAR_O_G_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		case "O_Soldier_HAT_F":     {[_unit, SAC_GEAR_O_G_loadoutProfile, "HAT"] call SAC_GEAR_applyLoadout};
		case "O_Soldier_F":         {[_unit, SAC_GEAR_O_G_loadoutProfile, "RIF"] call SAC_GEAR_applyLoadout};
		case "O_HeavyGunner_F":     {[_unit, SAC_GEAR_O_G_loadoutProfile, "MG"] call SAC_GEAR_applyLoadout};
		case "O_crew_F":     		{[_unit, SAC_GEAR_O_G_loadoutProfile, "CREW"] call SAC_GEAR_applyLoadout};

		// china_50
		case "O_G_officer_F":         {[_unit, SAC_GEAR_O_G_loadoutProfile, "OF"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_SL_F":      {[_unit, SAC_GEAR_O_G_loadoutProfile, "SL"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_TL_F":      {[_unit, SAC_GEAR_O_G_loadoutProfile, "TL"] call SAC_GEAR_applyLoadout};
		case "O_G_medic_F":           {[_unit, SAC_GEAR_O_G_loadoutProfile, "MED"] call SAC_GEAR_applyLoadout};
		case "O_G_engineer_F":        {[_unit, SAC_GEAR_O_G_loadoutProfile, "ENG"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_F":         {[_unit, SAC_GEAR_O_G_loadoutProfile, "SLD"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_lite_F":    {[_unit, SAC_GEAR_O_G_loadoutProfile, "SMG"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_AR_F":      {[_unit, SAC_GEAR_O_G_loadoutProfile, "AR"] call SAC_GEAR_applyLoadout};
		case "O_G_Survivor_F":        {[_unit, SAC_GEAR_O_G_loadoutProfile, "MG"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_A_F":       {[_unit, SAC_GEAR_O_G_loadoutProfile, "MG_A"] call SAC_GEAR_applyLoadout};
		case "O_G_Sharpshooter_F":    {[_unit, SAC_GEAR_O_G_loadoutProfile, "MM"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_M_F":       {[_unit, SAC_GEAR_O_G_loadoutProfile, "TD"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_GL_F":      {[_unit, SAC_GEAR_O_G_loadoutProfile, "GL"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_LAT_F":     {[_unit, SAC_GEAR_O_G_loadoutProfile, "LAT"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_LAT2_F":    {[_unit, SAC_GEAR_O_G_loadoutProfile, "AT"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_unarmed_F": {[_unit, SAC_GEAR_O_G_loadoutProfile, "CREW"] call SAC_GEAR_applyLoadout};
		case "O_G_Soldier_exp_F":     {[_unit, SAC_GEAR_O_G_loadoutProfile, "MOR"] call SAC_GEAR_applyLoadout};

		case "O_soldier_Melee":       {[_unit, SAC_GEAR_O_G_loadoutProfile, "MELEE"] call SAC_GEAR_applyLoadout};

		//default  {[format["%1 clase no reconocida por GEAR!", typeOf _unit]] call SAC_fnc_debugNotify};

	};
	
	//[_unit] call SAC_GEAR_fnc_initializeRearm;

};

SAC_GEAR_applyLoadout = {

	params ["_unit", "_profile", "_role", "_silencer"];
	
	if (_profile == "NONE") exitWith {};
	
	_unit setVariable ["BIS_enableRandomization", false]; 
	
	/*
	
	_profile = decide todo lo que viste a la unidad
	_role = "SL", "TL", etc.
	_silencer = en algunas armas, no solo determina si el se usa silenciador, también determina si se usan miras de SOF o regulares
	
	*/
	
	switch (_profile) do {


		//**************************************************
		//	BIS
		//**************************************************
		case "BIS_GUER": {

			if (_role == "HELIPILOT") exitWith {[_unit] call SAC_GEAR_fnc_applyLoadoutHeliPilot_NATO}; //quick hack
			
			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
			_unit forceAddUniform (selectRandom sac_gear_bis_altis_guer_uniforms);
			
			if (_role == "UNARMED") exitWith {};
			
			_unit addVest (selectRandom sac_gear_bis_altis_guer_vests);

			//if (random 1 < 0.45) then {_unit addGoggles (selectRandom sac_gear_bis_altis_guer_goggles)};
			
			_unit addBackpack (selectRandom sac_gear_bis_most_backpacks);

			[_unit, sac_gear_bis_altis_guer_weaponFamily, _role, false, false] call SAC_GEAR_fnc_giveWeapons;

			if (count backpackItems _unit == 0) then {removeBackpack _unit};
			
			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";
			_unit linkItem "ItemRadio";

			if (random 1 < 0.75) then {_unit addHeadgear selectRandom sac_gear_bis_altis_guer_headgear};
			
		};
		
		case "BIS_GUER_TANOA": { //*************** REVISION FEBRERO 21 ************************

			if (_role == "HELIPILOT") exitWith {[_unit] call SAC_GEAR_fnc_applyLoadoutHeliPilot_NATO}; //quick hack
			
			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
			_unit forceAddUniform (selectRandom sac_gear_bis_tanoa_syndikat_uniforms);
			
			if (_role == "UNARMED") exitWith {};
			
			_unit addVest (selectRandom sac_gear_bis_tanoa_syndikat_vests);

			//if (random 1 < 0.45) then {_unit addGoggles (selectRandom sac_gear_bis_tanoa_syndikat_goggles)};
			
			_unit addBackpack (selectRandom sac_gear_bis_tanoa_syndikat_backpacks);

			[_unit, sac_gear_bis_tanoa_syndikat_weaponFamily, _role, false, false] call SAC_GEAR_fnc_giveWeapons;

			if (count backpackItems _unit == 0) then {removeBackpack _unit};
			
			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";
			_unit linkItem "ItemRadio";

			if (random 1 < 0.75) then {_unit addHeadgear selectRandom sac_gear_bis_tanoa_syndikat_headgear};
			
		};
		
		//legacy profile (lo usan un par de misiones)
		case "BIS_GENDARMERIE": {
		
			[_unit, 
			["U_B_GEN_Commander_F"],
			["V_TacChestrig_grn_F"],
			["V_TacChestrig_grn_F"],
			["V_TacChestrig_grn_F"],
			["V_TacChestrig_grn_F"],
			["V_TacChestrig_grn_F"],
			["V_TacChestrig_grn_F"],
			sac_gear_bis_most_backpacks,
			sac_gear_bis_most_backpacks,
			sac_gear_bis_most_carryall_backpacks,
			sac_gear_bis_most_carryall_backpacks,
			sac_gear_bis_most_carryall_backpacks,
			["H_MilCap_gen_F"],
			[""],
			"",
			"TRG",
			false,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "BIS_NATO_SF_MTP": {  //*************** REVISION MAYO 23 ************************
		
			[_unit, 
			sac_gear_bis_nato_mtp_uniforms,
			["V_PlateCarrier1_rgr"], //sl
			sac_gear_bis_nato_vests_rgr, //ar
			sac_gear_bis_nato_vests_rgr, //rifleman
			sac_gear_bis_nato_vests_rgr, //gl
			sac_gear_bis_nato_vests_rgr, //medical
			[], //crew
			["B_Kitbag_tan"], //sl
			["B_Kitbag_tan"], //assault
			["B_Kitbag_tan"], //support
			["B_Carryall_cbr"], //medic
			["B_RadioBag_01_mtp_F"], //radio
			["H_HelmetB_light_sand"],
			sac_gear_bis_nato_facegear,
			"NVGoggles",
			"MX",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "BIS_NATO_MTP": {  //*************** REVISION MAYO 23 ************************
		
			if (_role == "HELIPILOT") exitWith {[_unit] call SAC_GEAR_fnc_applyLoadoutHeliPilot_NATO}; //quick hack

			[_unit, 
			sac_gear_bis_nato_mtp_uniforms,
			["V_PlateCarrier1_rgr"], //sl
			sac_gear_bis_nato_vests_rgr, //ar
			sac_gear_bis_nato_vests_rgr, //rifleman
			sac_gear_bis_nato_vests_rgr, //gl
			sac_gear_bis_nato_vests_rgr, //medical
			sac_gear_bis_nato_vests_rgr, //crew
			["B_AssaultPack_mcamo", "B_Kitbag_mcamo", "B_Carryall_cbr", "B_Carryall_mcamo"], //sl
			["B_AssaultPack_mcamo", "B_Kitbag_mcamo", "B_Carryall_cbr", "B_Carryall_mcamo"], //assault
			["B_Kitbag_mcamo", "B_Kitbag_mcamo", "B_Carryall_cbr", "B_Carryall_mcamo"], //support
			["B_Carryall_cbr", "B_Carryall_mcamo"], //medic
			["B_RadioBag_01_mtp_F"], //radio
			["H_HelmetSpecB_snakeskin", "H_HelmetSpecB_paint1", "H_HelmetSpecB_paint2", "H_HelmetSpecB", "H_HelmetB", "H_HelmetB_snakeskin",
			"H_HelmetB_desert", "H_HelmetB_grass"],
			sac_gear_bis_nato_facegear,
			"NVGoggles",
			"MX",
			false,
			"H_HelmetCrew_B",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;
			
		};
		
		case "BIS_NATO_SF_APEX": {  //*************** REVISION MAYO 23 ************************
		
			[_unit, 
			sac_gear_bis_nato_tna_uniforms,
			["V_PlateCarrier1_tna_F"], //sl
			sac_gear_bis_nato_vests_tna, //ar
			sac_gear_bis_nato_vests_tna, //rifleman
			sac_gear_bis_nato_vests_tna, //gl
			sac_gear_bis_nato_vests_tna, //medical
			[],
			["B_AssaultPack_tna_F", "B_Kitbag_sgg"],
			["B_AssaultPack_tna_F", "B_Kitbag_sgg"],
			["B_AssaultPack_tna_F", "B_Kitbag_sgg"],
			["B_AssaultPack_tna_F", "B_Carryall_oli"],
			["B_RadioBag_01_tropic_F"],
			["H_HelmetB_Light_tna_F"],
			sac_gear_bis_nato_facegear_tna,
			"NVGoggles_tna_F",
			"MX",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "BIS_NATO_APEX": {  //*************** REVISION MAYO 23 ************************
		
			if (_role == "HELIPILOT") exitWith {[_unit] call SAC_GEAR_fnc_applyLoadoutHeliPilot_NATO}; //quick hack

			[_unit, 
			sac_gear_bis_nato_tna_uniforms,
			sac_gear_bis_nato_vests_tna, //sl
			sac_gear_bis_nato_vests_tna, //ar
			sac_gear_bis_nato_vests_tna, //rifleman
			sac_gear_bis_nato_vests_tna, //gl
			sac_gear_bis_nato_vests_tna, //medical
			sac_gear_bis_nato_vests_tna, //crew
			["B_AssaultPack_tna_F", "B_Carryall_oli"],
			["B_AssaultPack_tna_F", "B_Carryall_oli"],
			["B_AssaultPack_tna_F", "B_Carryall_oli"],
			["B_AssaultPack_tna_F", "B_Carryall_oli"],
			["B_RadioBag_01_tropic_F"],
			["H_HelmetB_tna_F", "H_HelmetB_Enh_tna_F"],
			sac_gear_bis_nato_facegear_tna,
			"NVGoggles_tna_F",
			"MX",
			false,
			"H_HelmetCrew_B",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;
			
		};
		
		case "BIS_NATO_SF_WDL": {  //*************** REVISION MAYO 23 ************************
		
			[
			_unit,
			sac_gear_bis_nato_wdl_uniforms,
			["V_PlateCarrier1_wdl"], //sl
			sac_gear_bis_nato_vests_wdl, //ar
			sac_gear_bis_nato_vests_wdl, //rifleman
			sac_gear_bis_nato_vests_wdl, //gl
			sac_gear_bis_nato_vests_wdl, //medical
			[], //crew
			["B_AssaultPack_wdl_F", "B_Kitbag_rgr"], //sl
			["B_AssaultPack_wdl_F", "B_Kitbag_rgr"], //assault
			["B_Kitbag_rgr"], //support
			["B_Carryall_wdl_F"], //medic
			["B_RadioBag_01_wdl_F"], //radio
			["H_HelmetB_light_wdl"],
			sac_gear_bis_nato_facegear,
			"NVGoggles_OPFOR",
			"MX",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "BIS_NATO_WDL": {  //*************** REVISION MAYO 23 ************************
		
			if (_role == "HELIPILOT") exitWith {[_unit] call SAC_GEAR_fnc_applyLoadoutHeliPilot_NATO}; //quick hack
		
			[
			_unit,
			sac_gear_bis_nato_wdl_uniforms,
			["V_PlateCarrier1_wdl"], //sl
			sac_gear_bis_nato_vests_wdl, //ar
			sac_gear_bis_nato_vests_wdl, //rifleman
			sac_gear_bis_nato_vests_wdl, //gl
			sac_gear_bis_nato_vests_wdl, //medical
			sac_gear_bis_nato_vests_wdl, //crew
			["B_AssaultPack_wdl_F", "B_Kitbag_rgr"], //sl
			["B_AssaultPack_wdl_F", "B_Kitbag_rgr"], //assault
			["B_Kitbag_rgr"], //support
			["B_Carryall_wdl_F"], //medic
			["B_RadioBag_01_wdl_F"], //radio
			["H_HelmetSpecB_wdl", "H_HelmetB_plain_wdl"],
			sac_gear_bis_nato_facegear,
			"NVGoggles_OPFOR",
			"MX",
			false,
			"H_HelmetCrew_B",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "BIS_NATO_UC": {  //*************** REVISION MAYO 23 ************************
		
			[
			_unit,
			sac_gear_bis_uc_uniforms,
			["V_PlateCarrier1_wdl"], //sl
			["V_PlateCarrier1_wdl"], //ar
			["V_PlateCarrier1_wdl"], //rifleman
			["V_PlateCarrier1_wdl"], //gl
			["V_PlateCarrier1_wdl"], //medical
			[], //crew
			["B_Kitbag_cbr"], //sl
			["B_Kitbag_cbr", "B_Carryall_cbr"], //assault
			["B_Kitbag_cbr", "B_Carryall_cbr"], //support
			["B_Carryall_wdl_F"], //medic
			["B_RadioBag_01_wdl_F"], //radio
			["H_HelmetB_light_wdl","H_HelmetB_light_desert"],
			[],
			"NVGoggles_OPFOR",
			"MX",
			true,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

	/*		
			//no revisado
			case "BIS_CSAT": {
			
				if (_role == "HELIPILOT") exitWith {[_unit] call SAC_GEAR_fnc_applyLoadoutHeliPilot_CSAT}; //quick hack

				[_unit, 
				["U_O_CombatUniform_ocamo"],
				["V_HarnessO_brn"],
				["V_HarnessO_brn"],
				["V_HarnessO_brn"],
				["V_HarnessOGL_brn"],
				["V_HarnessO_brn"],
				["V_HarnessO_brn"], //crew
				["B_FieldPack_oli", "B_FieldPack_khk", "B_AssaultPack_rgr", "B_AssaultPack_blk"],
				["B_FieldPack_oli", "B_FieldPack_khk", "B_AssaultPack_rgr", "B_AssaultPack_blk"],
				["B_ViperHarness_oli_F", "B_ViperHarness_khk_F", "B_ViperHarness_hex_F", "B_ViperHarness_blk_F","B_Carryall_oli", "B_Carryall_khk",
				"B_Carryall_ocamo", "B_Carryall_cbr"],
				["B_ViperHarness_oli_F", "B_ViperHarness_khk_F", "B_ViperHarness_hex_F", "B_ViperHarness_blk_F","B_Carryall_oli", "B_Carryall_khk",
				"B_Carryall_ocamo", "B_Carryall_cbr"],
				["B_ViperHarness_oli_F", "B_ViperHarness_khk_F", "B_ViperHarness_hex_F", "B_ViperHarness_blk_F","B_Carryall_oli", "B_Carryall_khk",
				"B_Carryall_ocamo", "B_Carryall_cbr"],
				["H_HelmetO_ocamo"],
				[""],
				"NVGoggles_OPFOR",
				"CAR95",
				false,
				"H_HelmetCrew_O",
				_role,
				false
				] call SAC_GEAR_fnc_applyLoadoutSquema_1;

			};
	*/	
/*
		
		case "BIS_CSAT_APEX": { //*************** REVISION FEBRERO 21 ************************
		
			if (_role == "HELIPILOT") exitWith {[_unit] call SAC_GEAR_fnc_applyLoadoutHeliPilot_CSAT}; //quick hack

			[_unit, 
			["U_O_T_Soldier_F"],
			["V_HarnessO_ghex_F"], //sl
			["V_HarnessO_ghex_F"], //ar
			["V_HarnessO_ghex_F"], //rifleman
			["V_HarnessOGL_ghex_F"], //gl
			["V_HarnessO_ghex_F"], //medical
			["V_HarnessO_ghex_F"], //crew
			["B_FieldPack_ghex_F", "B_Carryall_ghex_F"],
			["B_FieldPack_ghex_F", "B_Carryall_ghex_F"],
			["B_FieldPack_ghex_F", "B_Carryall_ghex_F"],
			["B_FieldPack_ghex_F", "B_Carryall_ghex_F"],
			["H_HelmetO_ghex_F"],
			[""],
			"O_NVGoggles_ghex_F",
			"CAR95",
			false,
			"H_HelmetCrew_O_ghex_F",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
*/

		//**************************************************
		//	RHS
		//**************************************************

		case "RHS_TLA": {

			if (_role == "HELIPILOT") exitWith {[_unit] call SAC_GEAR_fnc_applyLoadoutHeliPilot_NATO}; //quick hack
			
			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
			_unit forceAddUniform (selectRandom ["rhsgref_uniform_TLA_1","rhsgref_uniform_TLA_2"]);
			
			if (_role == "UNARMED") exitWith {};
			
			_unit addVest (selectRandom ["rhsgref_alice_webbing","rhsgref_alice_webbing","rhsgref_alice_webbing","rhsgref_chestrig","rhsgref_chestrig","rhsgref_chestrig","rhsgref_chestrig","rhsgref_TacVest_ERDL"]);

			//if (random 1 < 0.45) then {_unit addGoggles (selectRandom sac_gear_bis_altis_guer_goggles)};
			
			switch (_role) do {
			
				case "LAT": {_unit addBackpack "rhs_rpg_empty"};
				case "MEDIC": {_unit addBackpack "rhs_medic_bag"};
				default {_unit addBackpack "rhs_sidor"};
			
			};
			
			[_unit, sac_gear_bis_altis_guer_weaponFamily, _role, false, false] call SAC_GEAR_fnc_giveWeapons;

			if (count backpackItems _unit == 0) then {removeBackpack _unit};
			
			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";
			_unit linkItem "ItemRadio";

			_unit addHeadgear selectRandom ["H_Bandanna_khk","H_Booniehat_oli","rhsgref_M56","rhs_ssh68"];
			
		};
	
		case "RHS_NATO_OCP_ACU_IOTV": { //*************** REVISION MAYO 23 ************************
		
			if (_role == "HELIPILOT") exitWith {[_unit] call SAC_GEAR_fnc_applyLoadoutHeliPilot_NATO}; //quick hack
		
			[
			_unit,
			["rhs_uniform_acu_oefcp"],
			["rhsusf_iotv_ocp_Squadleader", "rhsusf_iotv_ocp_Teamleader"], //sl
			["rhsusf_iotv_ocp_SAW"], //ar
			["rhsusf_iotv_ocp_Rifleman"], //rifleman
			["rhsusf_iotv_ocp_Grenadier"], //gl
			["rhsusf_iotv_ocp_Medic"], //medic
			["rhsusf_spcs_ocp"], //crew
			["rhsusf_assault_eagleaiii_ocp"], //sl backpacks
			["rhsusf_assault_eagleaiii_ocp"], //assault backpacks
			["rhsusf_assault_eagleaiii_ocp"], //support backpacks
			["B_Carryall_cbr"], //medic backpacks
			["rhsusf_assault_eagleaiii_ocp"], //radio backpacks
			["rhsusf_ach_helmet_ocp_norotos", "rhsusf_ach_helmet_ocp"],
			["rhs_googles_black"],
			["rhsusf_ANPVS_14"],
			"RHS_M4A1_PIP",
			false,
			"rhsusf_cvc_green_helmet",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
	
		case "RHS_NATO_UCP_ACU_IOTV": { //*************** REVISION MAYO 23 ************************
		
			if (_role == "HELIPILOT") exitWith {[_unit] call SAC_GEAR_fnc_applyLoadoutHeliPilot_NATO}; //quick hack
		
			[
			_unit,
			["rhs_uniform_acu_ucp2"],
			["rhsusf_iotv_ucp_Squadleader", "rhsusf_iotv_ucp_Teamleader"], //sl
			["rhsusf_iotv_ucp_SAW"], //ar
			["rhsusf_iotv_ucp_Rifleman"], //rifleman
			["rhsusf_iotv_ucp_Grenadier"], //gl
			["rhsusf_iotv_ucp_Medic"], //medic
			["rhsusf_spcs_ucp"], //crew
			["rhsusf_assault_eagleaiii_ucp"], //sl backpacks
			["rhsusf_assault_eagleaiii_ucp"], //assault backpacks
			["rhsusf_assault_eagleaiii_ucp"], //support backpacks
			["B_Carryall_cbr", "rhs_tortila_grey"], //medic backpacks
			["rhsusf_assault_eagleaiii_ucp"], //radio backpacks
			["rhsusf_ach_helmet_ucp_norotos", "rhsusf_ach_helmet_headset_ucp_alt", "rhsusf_ach_helmet_headset_ucp",
			"rhsusf_ach_helmet_ucp_alt", "rhsusf_ach_helmet_ucp"],
			["rhs_googles_black"],
			["rhsusf_ANPVS_14"],
			"RHS_M4A1_PIP",
			false,
			"rhsusf_cvc_green_helmet",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "RHS_RU_GORKA_YELLOW": {

			[
			_unit,
			["rhs_uniform_gorka_r_y"],
			["rhs_6b23_6sh116_od"], //sl
			["rhs_6b23_6sh116_od"], //ar
			["rhs_6b23_6sh116_od"], //rifleman
			["rhs_6b23_6sh116_od"], //gl
			["rhs_6b23_6sh116_od"], //medical
			[], //crew
			["rhs_tortila_emr","B_Carryall_wdl_F"],
			["rhs_tortila_emr","B_Carryall_wdl_F"],
			["rhs_tortila_emr","B_Carryall_wdl_F"],
			["rhs_tortila_emr","B_Carryall_wdl_F"],
			["rhs_tortila_emr","B_Carryall_wdl_F"],
			["rhs_stsh81", "rhs_stsh81", "rhs_stsh81", "rhs_stsh81", "rhs_stsh81", "rhs_stsh81_butan"],
			["rhs_scarf"],
			SAC_GEAR_preferred_nvg,
			sac_gear_preferredWeaponFamily,
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "RHS_NATO_SF_BLACK_DE_01": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["rhs_uniform_g3_blk"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			[],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_mtp_F"],
			["mich_rhino_blk"],
			["rhs_googles_clear"],
			["meu_ANPVS_14"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "RHS_NATO_SF_M81_DE_01": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["rhs_uniform_g3_m81"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			[],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_mtp_F"],
			["mich_rhino_rgr","mich_rhino_rgr","mich_rhino_spray1","mich_rhino_rgr","mich_rhino_spray4","tfl_beanie_hat_green_peltors","tfl_beanie_tan_hat_peltors"],
			["rhs_googles_black"],
			["meu_ANPVS_14"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		

/*
		case "RHS_MILITIA": {

			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
			_unit forceAddUniform selectRandom ["rhssaf_uniform_m93_oakleaf_summer", "rhssaf_uniform_m93_oakleaf", "rhsgref_uniform_woodland_olive", "rhsgref_uniform_woodland",
			"rhsgref_uniform_olive", "rhsgref_uniform_og107_erdl", "rhsgref_uniform_og107", "rhsgref_uniform_flecktarn_full", "rhsgref_uniform_flecktarn", "rhsgref_uniform_ERDL",
			"rhsgref_uniform_dpm_olive", "rhsgref_uniform_dpm", "rhsgref_uniform_altis_lizard_olive", "rhsgref_uniform_altis_lizard", "rhsgref_uniform_para_ttsko_urban",
			"rhsgref_uniform_para_ttsko_oxblood", "rhsgref_uniform_para_ttsko_mountain"];
			
			if (_role == "UNARMED") exitWith {};
			
			_unit addVest selectRandom ["V_Pocketed_olive_F", "V_Pocketed_coyote_F", "V_Pocketed_black_F", "V_LegStrapBag_olive_F", "V_LegStrapBag_coyote_F", "V_LegStrapBag_black_F",
			"rhs_6sh92_vsr", "rhs_6sh92_digi", "rhs_6sh92", "V_TacChestrig_oli_F", "V_TacChestrig_grn_F", "V_TacChestrig_cbr_F", "V_BandollierB_ghex_F", "V_HarnessO_ghex_F",
			"V_BandollierB_oli", "V_BandollierB_khk", "V_BandollierB_rgr", "V_BandollierB_cbr", "V_BandollierB_blk", "V_HarnessO_gry", "V_HarnessO_brn"];
		
			if (_role in ["AR", "MG", "ENG", "HAT", "AA"]) then {
				_unit addBackpack selectRandom ["rhssaf_alice_smb", "rhssaf_alice_md2camo", "rhsgref_wdl_alicepack", "rhsgref_ttsko_alicepack", "rhsgref_hidf_alicepack",
				"B_Carryall_ghex_F", "B_Carryall_oli", "B_Carryall_khk"];
			} else {
				if ((_role == "LAT") && {random 1 < 0.35}) then {
					_unit addBackpack selectRandom ["rhs_rpg_empty"];
				} else {
					_unit addBackpack selectRandom ["rhssaf_kitbag_smb", "rhssaf_kitbag_md2camo", "rhssaf_kitbag_digital", "rhs_sidor", "B_TacticalPack_oli", "B_TacticalPack_blk",
					"B_Kitbag_rgr"];
				};
			};
			
			[_unit, RHS_MILITIA_GEN_weaponFamily, _role, false] call SAC_GEAR_fnc_giveWeapons;

			if (count backpackItems _unit == 0) then {removeBackpack _unit};

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";
			_unit linkItem "ItemRadio";
			//if (!isNil "GEAR_NVG" && {GEAR_NVG}) then {_unit linkItem "NVGoggles_OPFOR"};
			
			if (_role == "CREW") then {
			
				_unit addHeadgear selectRandom ["rhs_tsh4_ess_bala", "rhs_tsh4_ess", "rhs_tsh4_bala", "rhs_tsh4"];
				
			} else {
			
				if (random 1 < 0.75) then {_unit addHeadgear selectRandom ["rhs_beanie", "rhs_beanie_green", "H_ShemagOpen_khk", "H_ShemagOpen_tan", "H_Shemag_olive",
				"H_Booniehat_dgtl", "H_Booniehat_oli", "H_Booniehat_khk", "rhssaf_booniehat_woodland", "rhssaf_booniehat_md2camo",
				"rhssaf_booniehat_digital"]};
				
				if (random 1 < 0.35) then {_unit addGoggles selectRandom ["rhs_scarf", "rhs_googles_clear"]};
			
			};

		};
*/


		//*****************************************************************************************************
		//	CUP
		//*****************************************************************************************************

		case "CUP_NATO_SF_M81_DE_01": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["CUP_U_CRYE_G3C_M81"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["flb_mappack_Standard_od"],
			["flb_mappack_Standard_od"],
			["flb_mappack_Standard_od"],
			["flb_mappack_Medical_od"],
			["flb_mappack_Radio_od"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["rhs_googles_black","rhs_googles_black","rhs_googles_black","rhs_googles_clear","rhs_ess_black","rhsusf_oakley_goggles_clr","rhsusf_oakley_goggles_blk"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "CUP_NATO_SF_M81_DE_02": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["CUP_U_CRYE_G3C_M81"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["rhs_googles_black","rhs_googles_black","rhs_googles_black","rhs_googles_clear","rhs_ess_black","rhsusf_oakley_goggles_clr","rhsusf_oakley_goggles_blk"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "CUP_NATO_SF_MC_DE_01": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["CUP_U_CRYE_G3C_MC_US_V2"],
			["mbavr_r","mbavr_m","mbavr_l"],
			["mbavr_mg"],
			["mbavr_r","mbavr_m","mbavr_l"],
			["mbavr_gl"],
			["mbavr_r","mbavr_m","mbavr_l"],
			[],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_mtp_F"],
			["COD_Bump_13","COD_Bump_16","COD_Bump_15","COD_Bump_2","COD_Bump_17","COD_Bump_14"],
			["rhs_googles_black"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "CUP_NATO_SF_MC_DE_02": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["CUP_U_CRYE_G3C_MC_US_V2"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			["lbt_tl_coy","lbt_operator_coy","lbt_medical_coy","lbt_comms_coy"],
			[],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_mtp_F"],
			["Maritime_NR_ComtacIII153","Maritime_ComtacIII_Arc153","Maritime_Cover_ComtacIV_Arc153","Maritime_Cover_ComtacIII_Arc153","Maritime_Cover_ComtacIV_Arc153","Maritime_Cover_ComtacIII_Arc153"],
			["rhs_googles_black","rhs_googles_black","rhs_googles_black","rhs_googles_clear","rhs_ess_black","rhsusf_oakley_goggles_clr","rhsusf_oakley_goggles_blk"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "CUP_NATO_SF_MC_DE_03": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["CUP_U_CRYE_G3C_MC_US_V2"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_Medic_MC_1","Crye_AVS_MC_Medic_1"],
			[],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["COD_Bump_33","COD_Bump_35","COD_Bump_34","COD_Bump_32","COD_Bump_29","COD_Bump_36","COD_Bump_31","COD_Bump_28","COD_Bump_30","COD_Bump_27"],
			["rhs_googles_black","rhs_googles_black","rhs_googles_black","rhs_googles_clear","rhs_ess_black","rhsusf_oakley_goggles_clr","rhsusf_oakley_goggles_blk"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "CUP_NATO_SF_MC_DE_04": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["CUP_U_CRYE_G3C_MC_US_V2"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			["AVS_40mm_Sling"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			[],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["MG_556_C","MG_556_B","MG_762_A","MG_556_A"],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["COD_Bump_33","COD_Bump_35","COD_Bump_34","COD_Bump_32","COD_Bump_29","COD_Bump_36","COD_Bump_31","COD_Bump_28","COD_Bump_30","COD_Bump_27"],
			["rhs_googles_black","rhs_googles_black","rhs_googles_black","rhs_googles_clear","rhs_ess_black","rhsusf_oakley_goggles_clr","rhsusf_oakley_goggles_blk"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		//*****************************************************************************************************
		//	Extra RHS Uniform Retextures
		//*****************************************************************************************************

		case "ERHS_NATO_SF_RGR_DE_01": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["CryGen2_rgr"],
			["mbavr_r","mbavr_m","mbavr_l"],
			["mbavr_mg"],
			["mbavr_r","mbavr_m","mbavr_l"],
			["mbavr_gl"],
			["mbavr_r","mbavr_m","mbavr_l"],
			[],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_mtp_F"],
			["mich_rhino_rgr","mich_rhino_rgr","mich_rhino_spray1","mich_rhino_rgr","mich_rhino_spray4","tfl_beanie_hat_green_peltors","tfl_beanie_tan_hat_peltors"],
			["rhs_googles_black"],
			["meu_ANPVS_14"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ERHS_NATO_SF_RGR_DE_02": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["CryGen2_rgr"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["rhs_googles_black","rhs_googles_black","rhs_googles_black","rhs_googles_clear","rhs_ess_black","rhsusf_oakley_goggles_clr","rhsusf_oakley_goggles_blk"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ERHS_NATO_SF_MCB_DE_01": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["CryGen3_mcblk"],
			["mbavr_r","mbavr_m","mbavr_l"],
			["mbavr_mg"],
			["mbavr_r","mbavr_m","mbavr_l"],
			["mbavr_gl"],
			["mbavr_r","mbavr_m","mbavr_l"],
			[],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_mtp_F"],
			["mich_rhino_rgr","mich_rhino_rgr","mich_rhino_spray1","mich_rhino_rgr","mich_rhino_spray4"],
			["rhs_googles_clear"],
			["meu_ANPVS_14"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ERHS_NATO_SF_MCB_DE_02": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["CryGen3_mcblk"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["COD_Bump_21","COD_Bump_22","COD_Bump_8","COD_Bump_7"],
			["rhs_googles_clear"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
	
		//*****************************************************************************************************
		//	Wolf's Retexture Project
		//*****************************************************************************************************

		case "WRP_NATO_SF_RGR_DE_01": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["wrp_uniform_g3c_rgr"],
			["mbavr_r","mbavr_m","mbavr_l"],
			["mbavr_mg"],
			["mbavr_r","mbavr_m","mbavr_l"],
			["mbavr_gl"],
			["mbavr_r","mbavr_m","mbavr_l"],
			[],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_mtp_F"],
			["rhsusf_ach_bare_des_headset"],
			["rhs_googles_black"],
			["meu_ANPVS_14"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "WRP_NATO_SF_RGR_DE_02": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["wrp_uniform_g3c_rgr"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["rhs_googles_black","rhs_googles_black","rhs_googles_black","rhs_googles_clear","rhs_ess_black","rhsusf_oakley_goggles_clr","rhsusf_oakley_goggles_blk"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		//*****************************************************************************************************
		//	SuperPowerRangers
		//*****************************************************************************************************

		//g3 ********************************************************************
		
		
		case "PR_NATO_SF_G3_MC_DE_01": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_3_w","G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_3_w","G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_3_w","G3_Ranger_Rshirt_Base_1_w","G3_Ranger_Rshirt_Base_2_w","G3_Ranger_Rshirt_Base_3_w","G3_Ranger_Rshirt_Base_4_w"],
			["G_TacVest_PACA_Ranger_v1_1","G_TacVest_PACA_Ranger_v2_2","G_MBAV_Ranger_v7_1","R_MBAV_Ranger_v8_1","G_MBAV_Ranger_v5_1","G_MBAV_Ranger_v4_1","G_MBAV_Ranger_v3_1","R_MBAV_Ranger_v10_1","R_MBAV_Ranger_v2_1","R_MBAV_Ranger_v3_1","G_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v9_1","M_MAR_CIRAS_Ranger_v4_1","G_AFG_MBAV_Ranger_v9_2","M_MAR_CIRAS_Ranger_v2_1","G_TacVest_PACA_Ranger_v3_3","M_MAR_CIRAS_Ranger_v5_1","M_MAR_CIRAS_Ranger_v1_1"],
			["G_TacVest_PACA_Ranger_v1_1","G_TacVest_PACA_Ranger_v2_2","G_MBAV_Ranger_v7_1","R_MBAV_Ranger_v8_1","G_MBAV_Ranger_v5_1","G_MBAV_Ranger_v4_1","G_MBAV_Ranger_v3_1","R_MBAV_Ranger_v10_1","R_MBAV_Ranger_v2_1","R_MBAV_Ranger_v3_1","G_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v9_1","M_MAR_CIRAS_Ranger_v4_1","G_AFG_MBAV_Ranger_v9_2","M_MAR_CIRAS_Ranger_v2_1","G_TacVest_PACA_Ranger_v3_3","M_MAR_CIRAS_Ranger_v5_1","M_MAR_CIRAS_Ranger_v1_1"],
			["G_TacVest_PACA_Ranger_v1_1","G_TacVest_PACA_Ranger_v2_2","G_MBAV_Ranger_v7_1","R_MBAV_Ranger_v8_1","G_MBAV_Ranger_v5_1","G_MBAV_Ranger_v4_1","G_MBAV_Ranger_v3_1","R_MBAV_Ranger_v10_1","R_MBAV_Ranger_v2_1","R_MBAV_Ranger_v3_1","G_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v9_1","M_MAR_CIRAS_Ranger_v4_1","G_AFG_MBAV_Ranger_v9_2","M_MAR_CIRAS_Ranger_v2_1","G_TacVest_PACA_Ranger_v3_3","M_MAR_CIRAS_Ranger_v5_1","M_MAR_CIRAS_Ranger_v1_1"],
			["G_TacVest_PACA_Ranger_v1_1","G_TacVest_PACA_Ranger_v2_2","G_MBAV_Ranger_v7_1","R_MBAV_Ranger_v8_1","G_MBAV_Ranger_v5_1","G_MBAV_Ranger_v4_1","G_MBAV_Ranger_v3_1","R_MBAV_Ranger_v10_1","R_MBAV_Ranger_v2_1","R_MBAV_Ranger_v3_1","G_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v9_1","M_MAR_CIRAS_Ranger_v4_1","G_AFG_MBAV_Ranger_v9_2","M_MAR_CIRAS_Ranger_v2_1","G_TacVest_PACA_Ranger_v3_3","M_MAR_CIRAS_Ranger_v5_1","M_MAR_CIRAS_Ranger_v1_1"],
			["G_TacVest_PACA_Ranger_v1_1","G_TacVest_PACA_Ranger_v2_2","G_MBAV_Ranger_v7_1","R_MBAV_Ranger_v8_1","G_MBAV_Ranger_v5_1","G_MBAV_Ranger_v4_1","G_MBAV_Ranger_v3_1","R_MBAV_Ranger_v10_1","R_MBAV_Ranger_v2_1","R_MBAV_Ranger_v3_1","G_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v9_1","M_MAR_CIRAS_Ranger_v4_1","G_AFG_MBAV_Ranger_v9_2","M_MAR_CIRAS_Ranger_v2_1","G_TacVest_PACA_Ranger_v3_3","M_MAR_CIRAS_Ranger_v5_1","M_MAR_CIRAS_Ranger_v1_1"],
			[],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "PR_NATO_SF_G3_MC_DE_02": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_3_w","G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_3_w","G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_1_w","G3_Ranger_Flight_Gloves_3_w","G3_Ranger_Rshirt_Base_1_w","G3_Ranger_Rshirt_Base_2_w","G3_Ranger_Rshirt_Base_3_w","G3_Ranger_Rshirt_Base_4_w"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_Medic_MC_1","Crye_AVS_MC_Medic_1"],
			[],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["COD_Bump_33","COD_Bump_35","COD_Bump_34","COD_Bump_32","COD_Bump_29","COD_Bump_36","COD_Bump_31","COD_Bump_28","COD_Bump_30","COD_Bump_27"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		

		//ronin mix ********************************************************************
		
		
		case "PR_NATO_SF_RONIN_DE_01": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["G3_Ranger_PCU_Rpants_2_w_green","G3_Ranger_PCU_Rpants_3_w_tan","G3_Ranger_PCU_Rpants_2_w_tan","G3_Ranger_PCU_Rpants_1_w_tan","G3_Ranger_PCU_Rpants_1_w_old","G3_Ranger_PCU_Rpants_3_w_old","G3_Ranger_Rpants_2_w","G3_Ranger_Rpants_2_w_g2_mc","G3_Ranger_Rpants_2_w_g3","G3_Ranger_Rpants_2_w_g2","G3_Ranger_Rpants_2_w_g2_khk","G3_Ranger_Rpants_3_w_g2_3cd","G3_Ranger_Rpants_1_w_g3","G3_Ranger_Rpants_3_w_g2_khk","G3_Ranger_Rpants_2_w_g3_ucp","G3_Ranger_Rpants_3_w_g2","G3_Ranger_Rpants_3_w_g3","G3_Ranger_Rpants_3_w","G3_Ranger_Rpants_3_w_g2_tan","G3_Ranger_Rpants_1_w","G3_Ranger_Rpants_1_w_g2","G3_Ranger_Rpants_2_w_g2_tan","G3_Ranger_Rpants_1_w_g2_3cd","G3_Ranger_Rpants_1_w_g2_khk","G3_Ranger_PCU_Rpants_2_w_old","G3_Ranger_Rpants_1_w_g2_tan"],
			["G_TacVest_PACA_Ranger_v1_1","G_TacVest_PACA_Ranger_v2_2","G_MBAV_Ranger_v7_1","R_MBAV_Ranger_v8_1","G_MBAV_Ranger_v5_1","G_MBAV_Ranger_v4_1","G_MBAV_Ranger_v3_1","R_MBAV_Ranger_v10_1","R_MBAV_Ranger_v2_1","R_MBAV_Ranger_v3_1","G_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v9_1","M_MAR_CIRAS_Ranger_v4_1","G_AFG_MBAV_Ranger_v9_2","M_MAR_CIRAS_Ranger_v2_1","G_TacVest_PACA_Ranger_v3_3","M_MAR_CIRAS_Ranger_v5_1","M_MAR_CIRAS_Ranger_v1_1"],
			["G_TacVest_PACA_Ranger_v1_1","G_TacVest_PACA_Ranger_v2_2","G_MBAV_Ranger_v7_1","R_MBAV_Ranger_v8_1","G_MBAV_Ranger_v5_1","G_MBAV_Ranger_v4_1","G_MBAV_Ranger_v3_1","R_MBAV_Ranger_v10_1","R_MBAV_Ranger_v2_1","R_MBAV_Ranger_v3_1","G_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v9_1","M_MAR_CIRAS_Ranger_v4_1","G_AFG_MBAV_Ranger_v9_2","M_MAR_CIRAS_Ranger_v2_1","G_TacVest_PACA_Ranger_v3_3","M_MAR_CIRAS_Ranger_v5_1","M_MAR_CIRAS_Ranger_v1_1"],
			["G_TacVest_PACA_Ranger_v1_1","G_TacVest_PACA_Ranger_v2_2","G_MBAV_Ranger_v7_1","R_MBAV_Ranger_v8_1","G_MBAV_Ranger_v5_1","G_MBAV_Ranger_v4_1","G_MBAV_Ranger_v3_1","R_MBAV_Ranger_v10_1","R_MBAV_Ranger_v2_1","R_MBAV_Ranger_v3_1","G_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v9_1","M_MAR_CIRAS_Ranger_v4_1","G_AFG_MBAV_Ranger_v9_2","M_MAR_CIRAS_Ranger_v2_1","G_TacVest_PACA_Ranger_v3_3","M_MAR_CIRAS_Ranger_v5_1","M_MAR_CIRAS_Ranger_v1_1"],
			["G_TacVest_PACA_Ranger_v1_1","G_TacVest_PACA_Ranger_v2_2","G_MBAV_Ranger_v7_1","R_MBAV_Ranger_v8_1","G_MBAV_Ranger_v5_1","G_MBAV_Ranger_v4_1","G_MBAV_Ranger_v3_1","R_MBAV_Ranger_v10_1","R_MBAV_Ranger_v2_1","R_MBAV_Ranger_v3_1","G_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v9_1","M_MAR_CIRAS_Ranger_v4_1","G_AFG_MBAV_Ranger_v9_2","M_MAR_CIRAS_Ranger_v2_1","G_TacVest_PACA_Ranger_v3_3","M_MAR_CIRAS_Ranger_v5_1","M_MAR_CIRAS_Ranger_v1_1"],
			["G_TacVest_PACA_Ranger_v1_1","G_TacVest_PACA_Ranger_v2_2","G_MBAV_Ranger_v7_1","R_MBAV_Ranger_v8_1","G_MBAV_Ranger_v5_1","G_MBAV_Ranger_v4_1","G_MBAV_Ranger_v3_1","R_MBAV_Ranger_v10_1","R_MBAV_Ranger_v2_1","R_MBAV_Ranger_v3_1","G_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v9_1","M_MAR_CIRAS_Ranger_v4_1","G_AFG_MBAV_Ranger_v9_2","M_MAR_CIRAS_Ranger_v2_1","G_TacVest_PACA_Ranger_v3_3","M_MAR_CIRAS_Ranger_v5_1","M_MAR_CIRAS_Ranger_v1_1"],
			[],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_Kitbag_cbr"],
			["rhsusf_ach_bare_des_headset"],
			["AD_Scarf_Neck_b3","AD_SP_Scarf_Neck_ESS_b5","AD_Shemag_b3","AD_Scarf_Neck_b1","AD_Shemag_b4","AD_SP_Scarf_Neck_ESS_b1","AD_SP_Scarf_Neck_ESS_b7","AD_Scarf_Neck_b4","AD_ESS_Glasses_b1","AD_SP_Scarf_Neck_ESS_b6","AD_SP_Scarf_Neck_ESS_b2","AD_Shemag_b5","AD_SP_Shemag_ESS_b7","AD_SP_Shemag_ESS_b3","AD_SP_Shemag_ESS_b4","AD_SP_Shemag_ESS_b8","AD_ESS_Glasses_b2"],
			["meu_ANPVS_14"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "PR_NATO_SF_RONIN_DE_02": {  //*************** REVISION JUNIO 23 ************************

			[
			_unit,
			["BDU_Rshirt_Ranger_6_w","BDU_Rshirt_Ranger_1_w","BDU_Rshirt_Ranger_2_w","G3_Ranger_PCU_Rpants_2_w","G3_Ranger_PCU_Rpants_4_w","G3_Ranger_PCU_Rpants_3_w","G3_Ranger_PCU_Rpants_1_w_tan","G3_Ranger_PCU_Rpants_1_w_blue","G3_Ranger_PCU_Rpants_1_w_old","G3_Ranger_PCU_Rpants_3_w_blue","G3_Ranger_PCU_Rpants_3_w_old","G3_Ranger_PCU_Rpants_3_w_green","G3_Ranger_PCU_Rpants_2_w_tan","G3_Ranger_PCU_Rpants_3_w_tan","G3_Ranger_PCU_Rpants_2_w_blue","G3_Ranger_PCU_Rpants_2_w_green","G3_Ranger_PCU_Rpants_2_w_old","G3_Ranger_PCU_BDU_2_w","G3_Ranger_PCU_BDU_1_w","G3_Ranger_Rpants_1_w_g2_khk","G3_Ranger_PCU_BDU_5_w","G3_Ranger_Rpants_1_w_g2_3cd","G3_Ranger_Rpants_3_w_g2_tan","G3_Ranger_Rpants_1_w","G3_Ranger_Rpants_2_w_g3_ucp","G3_Ranger_Rpants_2_w_g2_khk","G3_Ranger_Rpants_2_w_g2_mc","G3_Ranger_Rpants_3_w","BDU_Rshirt_Ranger_3_w","BDU_Rshirt_Ranger_7_w","G3_Ranger_Rpants_2_w","G3_Ranger_PCU_BDU_4_w","G3_Ranger_PCU_BDU_3_w","G3_Ranger_Rpants_1_w_g2_tan","G3_Ranger_Rpants_3_w_g2_khk","G3_Ranger_Rpants_2_w_g2_tan","BDU_Rshirt_Ranger_4_w","G3_Ranger_Rpants_3_w_g2_3cd","BDU_Rshirt_Ranger_5_w"],
			["G_TacVest_Ranger_v4_4","G_TacVest_Ranger_v3_3","G_TacVest_Ranger_v2_2","G_TacVest_Ranger_v1_1","G_TacVest_PACA_Ranger_v3_3","G_TacVest_PACA_Ranger_v2_2","G_TacVest_PACA_Ranger_v1_1","G_AFG_MBAV_Ranger_v9_1","G_AFG_MBAV_Ranger_v8_1","G_AFG_MBAV_Ranger_v7_1","G_AFG_MBAV_Ranger_v6_1","G_AFG_MBAV_Ranger_v5_1","G_AFG_MBAV_Ranger_v4_1","G_AFG_MBAV_Ranger_v3_1","G_AFG_MBAV_Ranger_v2_1","G_AFG_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v1_1"],
			["G_TacVest_Ranger_v4_4","G_TacVest_Ranger_v3_3","G_TacVest_Ranger_v2_2","G_TacVest_Ranger_v1_1","G_TacVest_PACA_Ranger_v3_3","G_TacVest_PACA_Ranger_v2_2","G_TacVest_PACA_Ranger_v1_1","G_AFG_MBAV_Ranger_v9_1","G_AFG_MBAV_Ranger_v8_1","G_AFG_MBAV_Ranger_v7_1","G_AFG_MBAV_Ranger_v6_1","G_AFG_MBAV_Ranger_v5_1","G_AFG_MBAV_Ranger_v4_1","G_AFG_MBAV_Ranger_v3_1","G_AFG_MBAV_Ranger_v2_1","G_AFG_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v1_1"],
			["G_TacVest_Ranger_v4_4","G_TacVest_Ranger_v3_3","G_TacVest_Ranger_v2_2","G_TacVest_Ranger_v1_1","G_TacVest_PACA_Ranger_v3_3","G_TacVest_PACA_Ranger_v2_2","G_TacVest_PACA_Ranger_v1_1","G_AFG_MBAV_Ranger_v9_1","G_AFG_MBAV_Ranger_v8_1","G_AFG_MBAV_Ranger_v7_1","G_AFG_MBAV_Ranger_v6_1","G_AFG_MBAV_Ranger_v5_1","G_AFG_MBAV_Ranger_v4_1","G_AFG_MBAV_Ranger_v3_1","G_AFG_MBAV_Ranger_v2_1","G_AFG_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v1_1"],
			["G_TacVest_Ranger_v4_4","G_TacVest_Ranger_v3_3","G_TacVest_Ranger_v2_2","G_TacVest_Ranger_v1_1","G_TacVest_PACA_Ranger_v3_3","G_TacVest_PACA_Ranger_v2_2","G_TacVest_PACA_Ranger_v1_1","G_AFG_MBAV_Ranger_v9_1","G_AFG_MBAV_Ranger_v8_1","G_AFG_MBAV_Ranger_v7_1","G_AFG_MBAV_Ranger_v6_1","G_AFG_MBAV_Ranger_v5_1","G_AFG_MBAV_Ranger_v4_1","G_AFG_MBAV_Ranger_v3_1","G_AFG_MBAV_Ranger_v2_1","G_AFG_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v1_1"],
			["G_TacVest_Ranger_v4_4","G_TacVest_Ranger_v3_3","G_TacVest_Ranger_v2_2","G_TacVest_Ranger_v1_1","G_TacVest_PACA_Ranger_v3_3","G_TacVest_PACA_Ranger_v2_2","G_TacVest_PACA_Ranger_v1_1","G_AFG_MBAV_Ranger_v9_1","G_AFG_MBAV_Ranger_v8_1","G_AFG_MBAV_Ranger_v7_1","G_AFG_MBAV_Ranger_v6_1","G_AFG_MBAV_Ranger_v5_1","G_AFG_MBAV_Ranger_v4_1","G_AFG_MBAV_Ranger_v3_1","G_AFG_MBAV_Ranger_v2_1","G_AFG_MBAV_Ranger_v10_1","G_AFG_MBAV_Ranger_v1_1"],
			[],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["BDU_RangerBelt_v7_1"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["AD_Scarf_Neck_b3","AD_SP_Scarf_Neck_ESS_b5","AD_Shemag_b3","AD_Scarf_Neck_b1","AD_Shemag_b4","AD_SP_Scarf_Neck_ESS_b1","AD_SP_Scarf_Neck_ESS_b7","AD_Scarf_Neck_b4","AD_ESS_Glasses_b1","AD_SP_Scarf_Neck_ESS_b6","AD_SP_Scarf_Neck_ESS_b2","AD_Shemag_b5","AD_SP_Shemag_ESS_b7","AD_SP_Shemag_ESS_b3","AD_SP_Shemag_ESS_b4","AD_SP_Shemag_ESS_b8","AD_ESS_Glasses_b2"],
			["meu_ANPVS_14"],
			"RHS_M4A1_PIP",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;
			
		};
		
		


		//*****************************************************************************************************
		//	TFN
		//*****************************************************************************************************

		case "TFN_NATO_SF_DE_MC": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["TFN_Gen3_Gen3_rs_or_cb_Flag_uniform","TFN_Gen3_Gen3_fs_or_cb_Flag_uniform","TFN_Gen3_Gen3_rs_or_cb_Flag_uniform","TFN_Gen3_Gen3_fs_or_cb_Flag_uniform","TFN_Gen3_Gen3_rs_or_cb_Flag_uniform","TFN_Gen3_Gen3_fs_or_cb_Flag_uniform","TFN_PCU_Grey_Gen3_PCU_or_cb_Flag_uniform","TFN_PCU_MC_Gen3_PCU_or_cb_Flag_uniform"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			["AVS_40mm_Sling"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			[],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["MG_556_C","MG_556_B","MG_762_A","MG_556_A"],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["COD_Bump_33","COD_Bump_35","COD_Bump_34","COD_Bump_32","COD_Bump_29","COD_Bump_36","COD_Bump_31","COD_Bump_28","COD_Bump_30","COD_Bump_27"],
			["TFN_Mframeb_WH_shemagh","TFN_Mframeb_BLK_shemagh","TFN_Mframeb_WH","TFN_Mframeb_BLK"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		




		//*****************************************************************************************************
		//	TFL
		//*****************************************************************************************************

		//mc ********************************************************************

		case "TFL_NATO_SF_MC_DE_01": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_g3_field_uniform","tfl_g3_field_r_uniform","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_Medic_MC_1","Crye_AVS_MC_Medic_1"],
			[],
			["flb_mappack_Standard_mc"],
			["flb_mappack_Standard_mc"],
			["flb_mappack_Standard_mc"],
			["flb_mappack_Medical_mc"],
			["flb_mappack_Radio_mc"],
			["COD_Bump_33","COD_Bump_35","COD_Bump_34","COD_Bump_32","COD_Bump_29","COD_Bump_36","COD_Bump_31","COD_Bump_28","COD_Bump_30","COD_Bump_27"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "TFL_NATO_SF_MC_DE_02": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_g3_field_uniform","tfl_g3_field_r_uniform","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_TeamLeader_MC_9","Crye_JPC_TeamLeader_MC_3","Crye_JPC_TeamLeader_MC_2","Crye_JPC_TeamLeader_MC_1","Crye_JPC_MC_11","Crye_JPC_MC_10","Crye_AVS_MC_TeamLeader_9","Crye_AVS_MC_TeamLeader_2","Crye_AVS_MC_TeamLeader_1","Crye_AVS_MC_11","Crye_AVS_MC_10"],
			["Crye_JPC_Medic_MC_1","Crye_AVS_MC_Medic_1"],
			[],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["COD_Bump_33","COD_Bump_35","COD_Bump_34","COD_Bump_32","COD_Bump_29","COD_Bump_36","COD_Bump_31","COD_Bump_28","COD_Bump_30","COD_Bump_27"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "TFL_NATO_SF_MC_DE_03": {  //*************** REVISION JUNIO 23 ************************
		
			[_unit,
			["tfl_g3_field_uniform","tfl_g3_field_r_uniform","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			["AVS_40mm_Sling"],
			["AVS_Ronin_B_Sling","AVS_Ronin_A_Sling","AVS_Tyr_A_Sling"],
			[],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["MG_556_C","MG_556_B","MG_762_A","MG_556_A"],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["TL_556_C","TL_556_B","TL_556_A","Assaulter_556_C","Assaulter_556_B","Assaulter_556_A"],
			["COD_Bump_33","COD_Bump_35","COD_Bump_34","COD_Bump_32","COD_Bump_29","COD_Bump_36","COD_Bump_31","COD_Bump_28","COD_Bump_30","COD_Bump_27"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "TFL_NATO_SF_MC_DE_04": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_g3_field_uniform","tfl_g3_field_r_uniform","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g","tfl_new_MC_rs_uniform_g","tfl_new_MC_fs_uniform_g"],
			["V_PlateCarrier1_rgr"],
			["V_PlateCarrier2_rgr","V_PlateCarrier1_rgr"],
			["V_PlateCarrier2_rgr","V_PlateCarrier1_rgr"],
			["V_PlateCarrier2_rgr","V_PlateCarrier1_rgr"],
			["V_PlateCarrier2_rgr","V_PlateCarrier1_rgr"],
			[],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_mtp_F"],
			["H_HelmetB_light_sand"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["NVGoggles_OPFOR"],
			"MX",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};


		//solid colors mix **************************************************************

		case "TFL_NATO_UC_DE_01": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_new_CBGRY_rs_uniform_g","tfl_new_CBMCB_rs_uniform_g","tfl_new_CBRG_rs_uniform_g","tfl_new_GRYCB_rs_uniform_g","tfl_new_GRYMCB_rs_uniform_g","tfl_new_GRYRG_rs_uniform_g","tfl_new_MCBCB_rs_uniform_g","tfl_new_MCBGRY_rs_uniform_g","tfl_new_MCBRG_rs_uniform_g","tfl_new_RGMCB_rs_uniform_g","tfl_new_RGGRY_rs_uniform_g"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["flb_mappack_Standard_od"],
			["flb_mappack_Standard_od"],
			["flb_mappack_Standard_od"],
			["flb_mappack_Medical_od"],
			["flb_mappack_Radio_od"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "TFL_NATO_UC_DE_02": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_new_CBGRY_rs_uniform_g","tfl_new_CBMCB_rs_uniform_g","tfl_new_CBRG_rs_uniform_g","tfl_new_GRYCB_rs_uniform_g","tfl_new_GRYMCB_rs_uniform_g","tfl_new_GRYRG_rs_uniform_g","tfl_new_MCBCB_rs_uniform_g","tfl_new_MCBGRY_rs_uniform_g","tfl_new_MCBRG_rs_uniform_g","tfl_new_RGMCB_rs_uniform_g","tfl_new_RGGRY_rs_uniform_g"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		
		
		//mc tropic **************************************************************
		
		case "TFL_NATO_SF_MCT_DE_01": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_g3_field_mct_uniform","tfl_g3_field_mct_r_uniform","tfl_new_MCT_fs_uniform_g","tfl_new_MCT_rs_uniform_g","tfl_new_MCT_fs_uniform_g","tfl_new_MCT_rs_uniform_g","tfl_new_MCT_fs_uniform_g","tfl_new_MCT_rs_uniform_g"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["flb_mappack_Standard_od"],
			["flb_mappack_Standard_od"],
			["flb_mappack_Standard_od"],
			["flb_mappack_Medical_od"],
			["flb_mappack_Radio_od"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "TFL_NATO_SF_MCT_DE_02": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_g3_field_mct_uniform","tfl_g3_field_mct_r_uniform","tfl_new_MCT_fs_uniform_g","tfl_new_MCT_rs_uniform_g","tfl_new_MCT_fs_uniform_g","tfl_new_MCT_rs_uniform_g","tfl_new_MCT_fs_uniform_g","tfl_new_MCT_rs_uniform_g"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		
		//ranger green **************************************************************
		
		case "TFL_NATO_SF_RG_DE_01": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_new_RG_rs_uniform_g","tfl_new_RG_fs_uniform_g"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["flb_mappack_Standard_od"],
			["flb_mappack_Standard_od"],
			["flb_mappack_Standard_od"],
			["flb_mappack_Medical_od"],
			["flb_mappack_Radio_od"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "TFL_NATO_SF_RG_DE_02": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_new_RG_rs_uniform_g","tfl_new_RG_fs_uniform_g"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["COD_Bump_12","COD_Bump_11","COD_Bump_18","COD_Bump_19","COD_Bump_20","COD_Bump_24","COD_Bump_10","COD_Bump","COD_Bump_9","COD_Bump_23"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		


		//mc black **************************************************************

		case "TFL_NATO_SF_MCB_DE_01": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_new_MCB_rs_uniform_g","tfl_new_MCB_fs_uniform_g","tfl_new_MCB_rs_uniform_g","tfl_new_MCB_fs_uniform_g","tfl_new_MCB_rs_uniform_g","tfl_new_MCB_fs_uniform_g","tfl_new_MCB_rs_uniform_g","tfl_new_MCB_fs_uniform_g","tfs_g3_codpcu_blk_mcb_uni","tfl_pcu_b_mcb_g_uniform"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["flb_mappack_Standard_od"],
			["flb_mappack_Standard_od"],
			["flb_mappack_Standard_od"],
			["flb_mappack_Medical_od"],
			["flb_mappack_Radio_od"],
			["COD_Bump_21","COD_Bump_22","COD_Bump_8","COD_Bump_7"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "TFL_NATO_SF_MCB_DE_02": {  //*************** REVISION JUNIO 23 ************************
		
			[
			_unit,
			["tfl_new_MCB_rs_uniform_g","tfl_new_MCB_fs_uniform_g","tfl_new_MCB_rs_uniform_g","tfl_new_MCB_fs_uniform_g","tfl_new_MCB_rs_uniform_g","tfl_new_MCB_fs_uniform_g","tfl_new_MCB_rs_uniform_g","tfl_new_MCB_fs_uniform_g","tfs_g3_codpcu_blk_mcb_uni","tfl_pcu_b_mcb_g_uniform"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_TeamLeader_RG_9","Crye_AVS_RG_10","Crye_JPC_TeamLeader_RG_3","Crye_JPC_TeamLeader_RG_2","Crye_JPC_RG_12","Crye_JPC_TeamLeader_RG_1","Crye_JPC_RG_11","Crye_JPC_RG_10","Crye_AVS_RG_TeamLeader_9","Crye_AVS_RG_TeamLeader_2","Crye_AVS_RG_TeamLeader_1","Crye_AVS_RG_11"],
			["Crye_JPC_Medic_RG_1","Crye_AVS_RG_Medic_1"],
			[],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["S_RangerBelt_v5_1","S_RangerBelt_v6_1","S_RangerBelt_v6_2","S_RangerBelt_v7_1"],
			["COD_Bump_21","COD_Bump_22","COD_Bump_8","COD_Bump_7"],
			["tfl_m_frame_tanclear","tfl_m_frame_blackshaded","tfl_arc_bala_glasses_blk","tfl_ess_blackshaded","tfl_jtf2_safety"],
			["Louetta_PVS31A_2","Louetta_PVS31A_2_alt","Louetta_PVS31A_4","Louetta_PVS31A_4_alt","Louetta_PVS31A_6","Louetta_PVS31A_6_alt"],
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		
		
		
		
		
		

		
		//*****************************************************************************************************
		//	Ratnik Plus (CUP)
		//*****************************************************************************************************

/*
		case "ECUP_RU_RATNIK_ARID": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_hxa"],
			["grcb_6b45_sh117_SURPAT_Arid", "grcb_6b45_sh117_Khaki"], //sl
			["grcb_6b45_sh117_SURPAT_Arid", "grcb_6b45_sh117_Khaki"], //ar
			["grcb_6b45_sh117_SURPAT_Arid", "grcb_6b45_sh117_Khaki"], //rifleman
			["grcb_6b45_sh117_SURPAT_Arid", "grcb_6b45_sh117_Khaki"], //gl
			["grcb_6b45_sh117_SURPAT_Arid", "grcb_6b45_sh117_Khaki"], //medical
			[], //crew
			["grcb_rus_patrol_bag_khaki", "grcb_rus_patrol_bag_hxa"],
			["grcb_rus_patrol_bag_khaki", "grcb_rus_patrol_bag_hxa"],
			["grcb_rus_patrol_bag_khaki", "grcb_rus_patrol_bag_hxa"],
			["grcb_rus_patrol_bag_khaki", "grcb_rus_patrol_bag_hxa"],
			["grcb_rus_patrol_bag_khaki", "grcb_rus_patrol_bag_hxa"],
			["grcb_6b47_gogglesup_hxa", "grcb_6b47_gogglesdown_hxa",
			"grcb_6b47_gogglesclosed_hxa", "grcb_6b47_hxa"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_BLUE_REED": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_kmb"],
			["grcb_6b45_sh117_flora"], //sl
			["grcb_6b45_sh117_flora"], //ar
			["grcb_6b45_sh117_flora"], //rifleman
			["grcb_6b45_sh117_flora"], //gl
			["grcb_6b45_sh117_flora"], //medical
			[], //crew
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_6b47_gogglesup_kmb", "grcb_6b47_gogglesdown_kmb",
			"grcb_6b47_gogglesclosed_kmb", "grcb_6b47_kmb"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_EMR2_SUMMER": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_emrp"],
			["grcb_6b45_sh117_surpat_3d"], //sl
			["grcb_6b45_sh117_surpat_3d"], //ar
			["grcb_6b45_sh117_surpat_3d"], //rifleman
			["grcb_6b45_sh117_surpat_3d"], //gl
			["grcb_6b45_sh117_surpat_3d"], //medical
			[], //crew
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_6b47_gogglesup_surpat_3d", "grcb_6b47_gogglesdown_surpat_3d",
			"grcb_6b47_gogglesclosed_surpat_3d", "grcb_6b47_surpat_3d"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_EMR2_WINTER": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_emrw"],
			["grcb_6b45_sh117_surpat_3d"], //sl
			["grcb_6b45_sh117_surpat_3d"], //ar
			["grcb_6b45_sh117_surpat_3d"], //rifleman
			["grcb_6b45_sh117_surpat_3d"], //gl
			["grcb_6b45_sh117_surpat_3d"], //medical
			[], //crew
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_6b47_gogglesup_surpat_3d", "grcb_6b47_gogglesdown_surpat_3d",
			"grcb_6b47_gogglesclosed_surpat_3d", "grcb_6b47_surpat_3d"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_FOREST": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_les"],
			["grcb_6b45_sh117_Flora2"], //sl
			["grcb_6b45_sh117_Flora2"], //ar
			["grcb_6b45_sh117_Flora2"], //rifleman
			["grcb_6b45_sh117_Flora2"], //gl
			["grcb_6b45_sh117_Flora2"], //medical
			[], //crew
			["grcb_rus_patrol_bag_Flora2"],
			["grcb_rus_patrol_bag_Flora2"],
			["grcb_rus_patrol_bag_Flora2"],
			["grcb_rus_patrol_bag_Flora2"],
			["grcb_rus_patrol_bag_Flora2"],
			["grcb_6b47_gogglesup_les", "grcb_6b47_gogglesdown_les",
			"grcb_6b47_gogglesclosed_les", "grcb_6b47_les"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_GOROD": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_grd"],
			["grcb_6b45_sh117_Olive"], //sl
			["grcb_6b45_sh117_Olive"], //ar
			["grcb_6b45_sh117_Olive"], //rifleman
			["grcb_6b45_sh117_Olive"], //gl
			["grcb_6b45_sh117_Olive"], //medical
			[], //crew
			["grcb_rus_patrol_bag_olive"],
			["grcb_rus_patrol_bag_olive"],
			["grcb_rus_patrol_bag_olive"],
			["grcb_rus_patrol_bag_olive"],
			["grcb_rus_patrol_bag_olive"],
			["grcb_6b47_gogglesup_grd", "grcb_6b47_gogglesdown_grd",
			"grcb_6b47_gogglesclosed_grd", "grcb_6b47_grd"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_CSAT_HEX_ARID": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_csh"],
			["grcb_6b45_sh117_SURPAT_Arid"], //sl
			["grcb_6b45_sh117_SURPAT_Arid"], //ar
			["grcb_6b45_sh117_SURPAT_Arid"], //rifleman
			["grcb_6b45_sh117_SURPAT_Arid"], //gl
			["grcb_6b45_sh117_SURPAT_Arid"], //medical
			[], //crew
			["grcb_rus_patrol_bag_SURPAT_Arid"],
			["grcb_rus_patrol_bag_SURPAT_Arid"],
			["grcb_rus_patrol_bag_SURPAT_Arid"],
			["grcb_rus_patrol_bag_SURPAT_Arid"],
			["grcb_rus_patrol_bag_SURPAT_Arid"],
			["grcb_6b47_gogglesup_csh", "grcb_6b47_gogglesdown_csh",
			"grcb_6b47_gogglesclosed_csh", "grcb_6b47_csh"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_CSAT_HEX_TROPIC": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_cst"],
			["grcb_6b45_sh117_cst"], //sl
			["grcb_6b45_sh117_cst"], //ar
			["grcb_6b45_sh117_cst"], //rifleman
			["grcb_6b45_sh117_cst"], //gl
			["grcb_6b45_sh117_cst"], //medical
			[], //crew
			["grcb_rus_patrol_bag_cst"],
			["grcb_rus_patrol_bag_cst"],
			["grcb_rus_patrol_bag_cst"],
			["grcb_rus_patrol_bag_cst"],
			["grcb_rus_patrol_bag_cst"],
			["grcb_6b47_gogglesup_cst", "grcb_6b47_gogglesdown_cst",
			"grcb_6b47_gogglesclosed_cst", "grcb_6b47_cst"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_CSAT_HEX_WDL": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_hxw"],
			["grcb_6b45_sh117_Khaki"], //sl
			["grcb_6b45_sh117_Khaki"], //ar
			["grcb_6b45_sh117_Khaki"], //rifleman
			["grcb_6b45_sh117_Khaki"], //gl
			["grcb_6b45_sh117_Khaki"], //medical
			[], //crew
			["grcb_rus_patrol_bag_hxw"],
			["grcb_rus_patrol_bag_hxw"],
			["grcb_rus_patrol_bag_hxw"],
			["grcb_rus_patrol_bag_hxw"],
			["grcb_rus_patrol_bag_hxw"],
			["grcb_6b47_gogglesup_hxw", "grcb_6b47_gogglesdown_hxw",
			"grcb_6b47_gogglesclosed_hxw", "grcb_6b47_hxw"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_KKO_BLUE": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_kkob"],
			["grcb_6b45_sh117_Black"], //sl
			["grcb_6b45_sh117_Black"], //ar
			["grcb_6b45_sh117_Black"], //rifleman
			["grcb_6b45_sh117_Black"], //gl
			["grcb_6b45_sh117_Black"], //medical
			[], //crew
			["grcb_rus_patrol_bag_Black"],
			["grcb_rus_patrol_bag_Black"],
			["grcb_rus_patrol_bag_Black"],
			["grcb_rus_patrol_bag_Black"],
			["grcb_rus_patrol_bag_Black"],
			["grcb_6b47_gogglesup_kkob", "grcb_6b47_gogglesdown_kkob",
			"grcb_6b47_gogglesclosed_kkob", "grcb_6b47_kkob"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_KKO_MINT": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_kkow"],
			["grcb_6b45_sh117_Khaki"], //sl
			["grcb_6b45_sh117_Khaki"], //ar
			["grcb_6b45_sh117_Khaki"], //rifleman
			["grcb_6b45_sh117_Khaki"], //gl
			["grcb_6b45_sh117_Khaki"], //medical
			[], //crew
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_6b47_gogglesup_kkow", "grcb_6b47_gogglesdown_kkow",
			"grcb_6b47_gogglesclosed_kkow", "grcb_6b47_kkow"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_KKO_URBAN": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_kkou"],
			["grcb_6b45_sh117_Khaki"], //sl
			["grcb_6b45_sh117_Khaki"], //ar
			["grcb_6b45_sh117_Khaki"], //rifleman
			["grcb_6b45_sh117_Khaki"], //gl
			["grcb_6b45_sh117_Khaki"], //medical
			[], //crew
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_6b47_gogglesup_kkou", "grcb_6b47_gogglesdown_kkou",
			"grcb_6b47_gogglesclosed_kkou", "grcb_6b47_kkou"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_KKO_GREEN": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_kko"],
			["grcb_6b45_sh117_Khaki"], //sl
			["grcb_6b45_sh117_Khaki"], //ar
			["grcb_6b45_sh117_Khaki"], //rifleman
			["grcb_6b45_sh117_Khaki"], //gl
			["grcb_6b45_sh117_Khaki"], //medical
			[], //crew
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_6b47_gogglesup_kko", "grcb_6b47_gogglesdown_kko",
			"grcb_6b47_gogglesclosed_kko", "grcb_6b47_kko"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_MOSS": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_sobr"],
			["grcb_6b45_sh117_Olive", "grcb_6b45_sh117_Black"], //sl
			["grcb_6b45_sh117_SURPAT_Arid", "grcb_6b45_sh117_Black"], //ar
			["grcb_6b45_sh117_SURPAT_Arid", "grcb_6b45_sh117_Black"], //rifleman
			["grcb_6b45_sh117_SURPAT_Arid", "grcb_6b45_sh117_Black"], //gl
			["grcb_6b45_sh117_SURPAT_Arid", "grcb_6b45_sh117_Black"], //medical
			[], //crew
			["grcb_rus_patrol_bag_olive", "grcb_rus_patrol_bag_Black"],
			["grcb_rus_patrol_bag_olive", "grcb_rus_patrol_bag_Black"],
			["grcb_rus_patrol_bag_olive", "grcb_rus_patrol_bag_Black"],
			["grcb_rus_patrol_bag_olive", "grcb_rus_patrol_bag_Black"],
			["grcb_rus_patrol_bag_olive", "grcb_rus_patrol_bag_Black"],
			["grcb_6b47_gogglesup_olive", "grcb_6b47_gogglesdown_olive",
			"grcb_6b47_gogglesclosed_olive", "grcb_6b47_olive",
			"grcb_6b47_gogglesup_Black", "grcb_6b47_gogglesdown_Black",
			"grcb_6b47_gogglesclosed_Black", "grcb_6b47_Black"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_NORTH": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_n"],
			["CUP_Vest_RUS_6B45_Sh117"], //sl
			["CUP_Vest_RUS_6B45_Sh117"], //ar
			["CUP_Vest_RUS_6B45_Sh117"], //rifleman
			["CUP_Vest_RUS_6B45_Sh117"], //gl
			["CUP_Vest_RUS_6B45_Sh117"], //medical
			[], //crew
			["CUP_O_RUS_Patrol_bag_Summer"],
			["CUP_O_RUS_Patrol_bag_Summer"],
			["CUP_O_RUS_Patrol_bag_Summer"],
			["CUP_O_RUS_Patrol_bag_Summer"],
			["CUP_O_RUS_Patrol_bag_Summer"],
			["CUP_H_RUS_6B47_v2_GogglesUp_Summer", "CUP_H_RUS_6B47_v2_GogglesDown_Summer",
			"CUP_H_RUS_6B47_v2_GogglesClosed_Summer", "CUP_H_RUS_6B47_v2_Summer"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_PALM_SPRING": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_plv"],
			["grcb_6b45_sh117_surpat_3d"], //sl
			["grcb_6b45_sh117_surpat_3d"], //ar
			["grcb_6b45_sh117_surpat_3d"], //rifleman
			["grcb_6b45_sh117_surpat_3d"], //gl
			["grcb_6b45_sh117_surpat_3d"], //medical
			[], //crew
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_6b47_gogglesup_plv", "grcb_6b47_gogglesdown_plv",
			"grcb_6b47_gogglesclosed_plv", "grcb_6b47_plv"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_PARTISAN_M": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_pml"],
			["grcb_6b45_sh117_Olive"], //sl
			["grcb_6b45_sh117_Olive"], //ar
			["grcb_6b45_sh117_Olive"], //rifleman
			["grcb_6b45_sh117_Olive"], //gl
			["grcb_6b45_sh117_Olive"], //medical
			[], //crew
			["grcb_rus_patrol_bag_olive"],
			["grcb_rus_patrol_bag_olive"],
			["grcb_rus_patrol_bag_olive"],
			["grcb_rus_patrol_bag_olive"],
			["grcb_rus_patrol_bag_olive"],
			["grcb_6b47_gogglesup_pml", "grcb_6b47_gogglesdown_pml",
			"grcb_6b47_gogglesclosed_pml", "grcb_6b47_pml"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "ECUP_RU_RATNIK_PIXEL_1": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_emr_summer"],
			["CUP_Vest_RUS_6B45_Sh117"], //sl
			["CUP_Vest_RUS_6B45_Sh117"], //ar
			["CUP_Vest_RUS_6B45_Sh117"], //rifleman
			["CUP_Vest_RUS_6B45_Sh117"], //gl
			["CUP_Vest_RUS_6B45_Sh117"], //medical
			[], //crew
			["CUP_O_RUS_Patrol_bag_Summer"],
			["CUP_O_RUS_Patrol_bag_Summer"],
			["CUP_O_RUS_Patrol_bag_Summer"],
			["CUP_O_RUS_Patrol_bag_Summer"],
			["CUP_O_RUS_Patrol_bag_Summer"],
			["CUP_H_RUS_6B47_v2_GogglesUp_Summer", "CUP_H_RUS_6B47_v2_GogglesDown_Summer",
			"CUP_H_RUS_6B47_v2_GogglesClosed_Summer", "CUP_H_RUS_6B47_v2_Summer"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_PIXEL_2": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_emr_desert"],
			["grcb_6b45_sh117_Khaki"], //sl
			["grcb_6b45_sh117_Khaki"], //ar
			["grcb_6b45_sh117_Khaki"], //rifleman
			["grcb_6b45_sh117_Khaki"], //gl
			["grcb_6b45_sh117_Khaki"], //medical
			[], //crew
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_rus_patrol_bag_khaki"],
			["grcb_6b47_gogglesup_khaki", "grcb_6b47_gogglesdown_khaki",
			"grcb_6b47_khaki", "grcb_6b47_gogglesclosed_khaki"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_SPECTER_SKWO": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_spb"],
			["grcb_6b45_sh117_spb"], //sl
			["grcb_6b45_sh117_spb"], //ar
			["grcb_6b45_sh117_spb"], //rifleman
			["grcb_6b45_sh117_spb"], //gl
			["grcb_6b45_sh117_spb"], //medical
			[], //crew
			["grcb_rus_patrol_bag_spb"],
			["grcb_rus_patrol_bag_spb"],
			["grcb_rus_patrol_bag_spb"],
			["grcb_rus_patrol_bag_spb"],
			["grcb_rus_patrol_bag_spb"],
			["grcb_6b47_gogglesup_spb", "grcb_6b47_gogglesdown_spb",
			"grcb_6b47_spb", "grcb_6b47_gogglesclosed_spb"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_SPECTER_SUMMER": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_spg"],
			["grcb_6b45_sh117_spg"], //sl
			["grcb_6b45_sh117_spg"], //ar
			["grcb_6b45_sh117_spg"], //rifleman
			["grcb_6b45_sh117_spg"], //gl
			["grcb_6b45_sh117_spg"], //medical
			[], //crew
			["grcb_rus_patrol_bag_spg"],
			["grcb_rus_patrol_bag_spg"],
			["grcb_rus_patrol_bag_spg"],
			["grcb_rus_patrol_bag_spg"],
			["grcb_rus_patrol_bag_spg"],
			["grcb_6b47_gogglesup_spg", "grcb_6b47_gogglesdown_spg",
			"grcb_6b47_spg", "grcb_6b47_gogglesclosed_spg"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_SURPAT_3D": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_surpat_3d"],
			["grcb_6b45_sh117_surpat_3d"], //sl
			["grcb_6b45_sh117_surpat_3d"], //ar
			["grcb_6b45_sh117_surpat_3d"], //rifleman
			["grcb_6b45_sh117_surpat_3d"], //gl
			["grcb_6b45_sh117_surpat_3d"], //medical
			[], //crew
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_rus_patrol_bag_SURPAT_3D"],
			["grcb_6b47_gogglesup_surpat_3d", "grcb_6b47_gogglesdown_surpat_3d",
			"grcb_6b47_gogglesclosed_surpat_3d", "grcb_6b47_surpat_3d"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_SURPAT_ARID": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_SURPAT_Arid"],
			["grcb_6b45_sh117_SURPAT_Arid"], //sl
			["grcb_6b45_sh117_SURPAT_Arid"], //ar
			["grcb_6b45_sh117_SURPAT_Arid"], //rifleman
			["grcb_6b45_sh117_SURPAT_Arid"], //gl
			["grcb_6b45_sh117_SURPAT_Arid"], //medical
			[], //crew
			["grcb_rus_patrol_bag_SURPAT_Arid"],
			["grcb_rus_patrol_bag_SURPAT_Arid"],
			["grcb_rus_patrol_bag_SURPAT_Arid"],
			["grcb_rus_patrol_bag_SURPAT_Arid"],
			["grcb_rus_patrol_bag_SURPAT_Arid"],
			["grcb_6b47_gogglesup_SURPAT_Arid", "grcb_6b47_gogglesdown_SURPAT_Arid",
			"grcb_6b47_gogglesclosed_SURPAT_Arid", "grcb_6b47_SURPAT_Arid"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_SURPAT": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_SURPAT"],
			["grcb_6b45_sh117_SURPAT"], //sl
			["grcb_6b45_sh117_SURPAT"], //ar
			["grcb_6b45_sh117_SURPAT"], //rifleman
			["grcb_6b45_sh117_SURPAT"], //gl
			["grcb_6b45_sh117_SURPAT"], //medical
			[], //crew
			["grcb_rus_patrol_bag_SURPAT"],
			["grcb_rus_patrol_bag_SURPAT"],
			["grcb_rus_patrol_bag_SURPAT"],
			["grcb_rus_patrol_bag_SURPAT"],
			["grcb_rus_patrol_bag_SURPAT"],
			["grcb_6b47_gogglesup_SURPAT", "grcb_6b47_gogglesdown_SURPAT",
			"grcb_6b47_gogglesclosed_SURPAT", "grcb_6b47_SURPAT"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_TAIGA": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_hxt"],
			["grcb_6b45_sh117_Green"], //sl
			["grcb_6b45_sh117_Green"], //ar
			["grcb_6b45_sh117_Green"], //rifleman
			["grcb_6b45_sh117_Green"], //gl
			["grcb_6b45_sh117_Green"], //medical
			[], //crew
			["grcb_rus_patrol_bag_hxt"],
			["grcb_rus_patrol_bag_hxt"],
			["grcb_rus_patrol_bag_hxt"],
			["grcb_rus_patrol_bag_hxt"],
			["grcb_rus_patrol_bag_hxt"],
			["grcb_6b47_gogglesup_hxt", "grcb_6b47_gogglesdown_hxt",
			"grcb_6b47_gogglesclosed_hxt", "grcb_6b47_hxt"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_VSR98_AUTUMN": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_flora_autumn"],
			["grcb_6b45_sh117_flora"], //sl
			["grcb_6b45_sh117_flora"], //ar
			["grcb_6b45_sh117_flora"], //rifleman
			["grcb_6b45_sh117_flora"], //gl
			["grcb_6b45_sh117_flora"], //medical
			[], //crew
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_6b47_gogglesup_flora", "grcb_6b47_gogglesdown_flora",
			"grcb_6b47_gogglesclosed_flora", "grcb_6b47_flora"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_VSR98_BROWN": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_flora2"],
			["grcb_6b45_sh117_Flora2"], //sl
			["grcb_6b45_sh117_Flora2"], //ar
			["grcb_6b45_sh117_Flora2"], //rifleman
			["grcb_6b45_sh117_Flora2"], //gl
			["grcb_6b45_sh117_Flora2"], //medical
			[], //crew
			["grcb_rus_patrol_bag_Flora2"],
			["grcb_rus_patrol_bag_Flora2"],
			["grcb_rus_patrol_bag_Flora2"],
			["grcb_rus_patrol_bag_Flora2"],
			["grcb_rus_patrol_bag_Flora2"],
			["grcb_6b47_gogglesup_flora2", "grcb_6b47_gogglesdown_flora2",
			"grcb_6b47_gogglesclosed_flora2", "grcb_6b47_flora2"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_VSR98_GREY": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_flora3"],
			["grcb_6b45_sh117_Flora3"], //sl
			["grcb_6b45_sh117_Flora3"], //ar
			["grcb_6b45_sh117_Flora3"], //rifleman
			["grcb_6b45_sh117_Flora3"], //gl
			["grcb_6b45_sh117_Flora3"], //medical
			[], //crew
			["grcb_rus_patrol_bag_Flora3"],
			["grcb_rus_patrol_bag_Flora3"],
			["grcb_rus_patrol_bag_Flora3"],
			["grcb_rus_patrol_bag_Flora3"],
			["grcb_rus_patrol_bag_Flora3"],
			["grcb_6b47_gogglesup_flora3", "grcb_6b47_gogglesdown_flora3",
			"grcb_6b47_gogglesclosed_flora3", "grcb_6b47_flora3"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "ECUP_RU_RATNIK_VSR98": { //*************** REVISION FEBRERO 21 ************************

			[
			_unit,
			["grcb_uniform_ratnik_flora"],
			["grcb_6b45_sh117_flora"], //sl
			["grcb_6b45_sh117_flora"], //ar
			["grcb_6b45_sh117_flora"], //rifleman
			["grcb_6b45_sh117_flora"], //gl
			["grcb_6b45_sh117_flora"], //medical
			[], //crew
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_rus_patrol_bag_flora"],
			["grcb_6b47_gogglesup_flora", "grcb_6b47_gogglesdown_flora",
			"grcb_6b47_gogglesclosed_flora", "grcb_6b47_flora"],
			["CUP_RUS_Balaclava_blk", "CUP_RUS_Balaclava_emr", "CUP_G_RUS_Balaclava_Ratnik_v2", "CUP_G_RUS_Balaclava_Ratnik"],
			SAC_GEAR_preferred_nvg,
			"KATIBA",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
*/

		//*****************************************************************************************************
		//	FFCP
		//*****************************************************************************************************

/*		case "FFCP_CSAT_SF_BLUE": { //*************** REVISION FEBRERO 21 ************************
		
			[_unit, 
			["CsatU_blue"],
			["Harness_Green"], //sl
			["Harness_Green"], //ar
			["Harness_Green"], //rifleman
			["Harness_Green_gl"], //gl
			["Harness_Green"], //medical
			[], //crew
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_RadioBag_01_wdl_F"],
			["CSAT_helmet_blue", "H_HelmetAggressor_F"],
			[""],
			"O_NVGoggles_grn_F",
			"KATIBA",
			_silencer,
			"",
			_role,
			true
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_CSAT_SF_BEREZCA": { //*************** REVISION FEBRERO 21 ************************
		
			[_unit, 
			["CsatU_Berezka"],
			["Harness_Green"], //sl
			["Harness_Green"], //ar
			["Harness_Green"], //rifleman
			["Harness_Green_gl"], //gl
			["Harness_Green"], //medical
			[], //crew
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_RadioBag_01_wdl_F"],
			["CSAT_helmet_Green", "H_HelmetAggressor_F"],
			[""],
			"O_NVGoggles_grn_F",
			"KATIBA",
			_silencer,
			"",
			_role,
			true
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_CSAT_SF_BEREZCA_YELLOW": { //*************** REVISION FEBRERO 21 ************************
		
			[_unit, 
			["CsatU_BerezkaY"],
			["Harness_Green"], //sl
			["Harness_Green"], //ar
			["Harness_Green"], //rifleman
			["Harness_Green_gl"], //gl
			["Harness_Green"], //medical
			[], //crew
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_RadioBag_01_wdl_F"],
			["CSAT_helmet_Green", "H_HelmetAggressor_F"],
			[""],
			"O_NVGoggles_grn_F",
			"KATIBA",
			_silencer,
			"",
			_role,
			true
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_CSAT_SF_EMR": { //*************** REVISION FEBRERO 21 ************************
		
			[_unit, 
			["CsatU_EMR"],
			["Harness_Green"], //sl
			["Harness_Green"], //ar
			["Harness_Green"], //rifleman
			["Harness_Green_gl"], //gl
			["Harness_Green"], //medical
			[], //crew
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_RadioBag_01_wdl_F"],
			["CSAT_helmet_EMR", "H_HelmetAggressor_F"],
			[""],
			"O_NVGoggles_grn_F",
			"KATIBA",
			_silencer,
			"",
			_role,
			true
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_CSAT_SF_GREEN": { //*************** REVISION FEBRERO 21 ************************
		
			[_unit, 
			["CsatU_Green"],
			["Harness_Green"], //sl
			["Harness_Green"], //ar
			["Harness_Green"], //rifleman
			["Harness_Green_gl"], //gl
			["Harness_Green"], //medical
			[], //crew
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_FieldPack_green_F", "B_Carryall_green_F"],
			["B_RadioBag_01_wdl_F"],
			["CSAT_helmet_Green", "H_HelmetAggressor_F"],
			[""],
			"O_NVGoggles_grn_F",
			"KATIBA",
			_silencer,
			"",
			_role,
			true
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_CSAT_SF_KHAKI": { //*************** REVISION FEBRERO 21 ************************
		
			[_unit, 
			["CsatU_khaki"],
			["Harness_Khaki"], //sl
			["Harness_Khaki"], //ar
			["Harness_Khaki"], //rifleman
			["Harness_Khaki_gl"], //gl
			["Harness_Khaki"], //medical
			[], //crew
			["B_FieldPack_khk", "B_Carryall_khk"],
			["B_FieldPack_khk", "B_Carryall_khk"],
			["B_FieldPack_khk", "B_Carryall_khk"],
			["B_FieldPack_khk", "B_Carryall_khk"],
			["B_RadioBag_01_hex_F"],
			["CSAT_helmet_Green", "H_HelmetAggressor_F"],
			[""],
			"O_NVGoggles_grn_F",
			"KATIBA",
			_silencer,
			"",
			_role,
			true
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_MARPATW": {

			[
			_unit,
			["CamoU_MarpatW", "CamoU_MarpatW_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_hex_F"],
			["Helmet_SF_marpatW", "Helmet_L_marpatw"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			sac_gear_preferredWeaponFamily,
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_MARPATW_FLB": { //versión alternativa con cascos de FLB

			[
			_unit,
			["CamoU_MarpatW", "CamoU_MarpatW_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_hex_F"],
			["flb_opscover_peltor_C_01", "flb_opscover_throatmic_01", "flb_opscover_peltor_B_01", "flb_opscover_peltor_A_01",
			"flb_opscover_comtac_01"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			sac_gear_preferredWeaponFamily,
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_ATACS": {

			[
			_unit,
			["CamoU_atacs", "CamoU_atacs_rs"],
			["V_PlateCarrier1_blk"], //sl
			["V_PlateCarrier1_blk"], //ar
			["V_PlateCarrier1_blk"], //rifleman
			["V_PlateCarrier1_blk"], //gl
			["V_PlateCarrier1_blk"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_oucamo_F"],
			["Helmet_SF_atacs", "Helmet_L_atacs"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			sac_gear_preferredWeaponFamily,
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_ATACS_FLB": { //versión alternativa con cascos de FLB

			[
			_unit,
			["CamoU_atacs", "CamoU_atacs_rs"],
			["V_PlateCarrier1_blk"], //sl
			["V_PlateCarrier1_blk"], //ar
			["V_PlateCarrier1_blk"], //rifleman
			["V_PlateCarrier1_blk"], //gl
			["V_PlateCarrier1_blk"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_oucamo_F"],
			["flb_opscover_peltor_C_01", "flb_opscover_throatmic_01", "flb_opscover_peltor_B_01", "flb_opscover_peltor_A_01",
			"flb_opscover_comtac_01"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_ACU": {

			[
			_unit,
			["CamoU_ACU", "CamoU_ACU_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_oucamo_F"],
			["Helmet_SF_acu", "Helmet_L_acu"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_alpenflage": {

			[
			_unit,
			["CamoU_alpenflage", "CamoU_alpenflage_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_wdl_F"],
			["H_HelmetAggressor_F"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_BLACK": {

			[
			_unit,
			["CamoU_Black", "CamoU_Black_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["H_HelmetB_light_black"],
			["G_Balaclava_blk"],
			"NVGoggles",
			"MX",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_BLACK_HEAVY": { //basado en screenshot, chalecos heavy y todo negro

			[
			_unit,
			["CamoU_Black", "CamoU_Black_rs"],
			["V_PlateCarrierSpec_blk"], //sl
			["V_PlateCarrierSpec_blk", "V_PlateCarrierGL_blk"], //ar
			["V_PlateCarrierSpec_blk", "V_PlateCarrierGL_blk"], //rifleman
			["V_PlateCarrierSpec_blk", "V_PlateCarrierGL_blk"], //gl
			["V_PlateCarrierSpec_blk"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["H_HelmetB_light_black"],
			["G_Balaclava_blk"],
			"NVGoggles",
			"MX",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_BLACK_FLB": { //con cascos de FLB

			[
			_unit,
			["CamoU_Black", "CamoU_Black_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_wdl_F"],
			["FLB_OpsCore_Plain_A_02", "FLB_OpsCore_Plain_A_03", "FLB_OpsCore_Plain_A_02"],
			["G_Balaclava_blk"],
			"NVGoggles",
			"MX",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_BLACK_FLB_MNP": { //con cascos de FLB y chaleco de Killoch's Multi-National Pack

			[
			_unit,
			["CamoU_Black", "CamoU_Black_rs"],
			["MNP_Vest_USMC"], //sl
			["MNP_Vest_USMC"], //ar
			["MNP_Vest_USMC"], //rifleman
			["MNP_Vest_USMC"], //gl
			["MNP_Vest_USMC"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_wdl_F"],
			["FLB_OpsCore_Plain_A_02", "FLB_OpsCore_Plain_A_03", "FLB_OpsCore_Plain_A_02"],
			["G_Balaclava_blk"],
			"NVGoggles",
			"MX",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_BLUE": {

			[
			_unit,
			["CamoU_blue", "CamoU_blue_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["H_HelmetSpecB_blk", "H_HelmetB_light_black"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_CADPAT": {

			[
			_unit,
			["CamoU_cadpat", "CamoU_cadpat_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_wdl_F", "B_Carryall_ghex_F"],
			["B_RadioBag_01_ghex_F"],
			["Helmet_SF_cadpat", "Helmet_L_cadpat"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		case "FFCP_NATO_SF_CADPAT_KILLOCH_RHS": { //version alternativa con chalecos de killoch y velo facial de rhs

			[
			_unit,
			["CamoU_cadpat", "CamoU_cadpat_rs"],
			["MNP_Vest_Canada_T"], //sl
			["MNP_Vest_Canada_T", "MNP_Vest_Canada_T2"], //ar
			["MNP_Vest_Canada_T", "MNP_Vest_Canada_T2"], //rifleman
			["MNP_Vest_Canada_T", "MNP_Vest_Canada_T2"], //gl
			["MNP_Vest_Canada_T", "MNP_Vest_Canada_T2"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_wdl_F", "B_Carryall_ghex_F"],
			["B_RadioBag_01_ghex_F"],
			["Helmet_SF_cadpat", "Helmet_L_cadpat"],
			["rhssaf_veil_Green"],
			SAC_GEAR_preferred_nvg,
			"SPAR",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_DBDU": {

			[
			_unit,
			["CamoU_dbdu", "CamoU_dbdu_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_eaf_F"],
			sac_gear_bis_nato_sf_headgear,
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_MARPATD": {

			[
			_unit,
			["CamoU_MarpatD", "CamoU_MarpatD_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_eaf_F"],
			["Helmet_SF_marpatd", "Helmet_L_marpatd"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_DPM": {

			[
			_unit,
			["CamoU_dpm", "CamoU_dpm_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_wdl_F"],
			["rhsusf_opscore_mar_ut_pelt"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};

		case "FFCP_NATO_SF_FLECKTARN": {

			[
			_unit,
			["CamoU_Flecktarn", "CamoU_Flecktarn_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_wdl_F"],
			["Helmet_SF_flecktarn", "Helmet_L_flecktarn"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_FLORA_FLB": { //versión alternativa con cascos de FLB

			[
			_unit,
			["CamoU_flora_sweater", "CamoU_flora_sweater", "CamoU_flora_sweater", "CamoU_flora", "CamoU_flora_rs"],
			["V_PlateCarrier1_blk"], //sl
			["V_PlateCarrier1_blk"], //ar
			["V_PlateCarrier1_blk"], //rifleman
			["V_PlateCarrier1_blk"], //gl
			["V_PlateCarrier1_blk"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_cbr"],
			["B_RadioBag_01_wdl_F"],
			["flb_opscover_peltor_C_01", "flb_opscover_throatmic_01", "flb_opscover_peltor_B_01", "flb_opscover_peltor_A_01",
			"flb_opscover_comtac_01"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_GRANITB": {

			[
			_unit,
			["CamoU_GranitB", "CamoU_GranitB_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["Helmet_SF_GranitB", "Helmet_L_GranitB"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_GREEN": {

			[
			_unit,
			["CamoU_green", "CamoU_green_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["Helmet_SF_green", "Helmet_L_green"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		case "FFCP_NATO_SF_M90": {

			[
			_unit,
			["CamoU_m90", "CamoU_m90_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_sgg"],
			["B_Kitbag_sgg"],
			["B_Kitbag_sgg"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["Helmet_SF_green", "Helmet_L_green"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		case "FFCP_NATO_SF_M90_FLB_CUP": { //versión alternativa con cascos de FLB y balaclavas de CUP

			[
			_unit,
			["CamoU_m90", "CamoU_m90_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_sgg"],
			["B_Kitbag_sgg"],
			["B_Kitbag_sgg"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["FLB_Mich2001_PT_A_03"],
			["CUP_RUS_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_IZLOM": {

			[
			_unit,
			["CamoU_izlom", "CamoU_izlom_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_eaf_F"],
			["H_HelmetAggressor_F"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_IZLOM_CUP": { //basado en screenshot

			[
			_unit,
			["CamoU_izlom", "CamoU_izlom_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_eaf_F"],
			sac_gear_bis_nato_sf_headgear,
			[],
			"NVGoggles_OPFOR",
			"RHS_MK18",
			_silencer,
			"",
			_role,
			true
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_KAMYSH": {

			[
			_unit,
			["CamoU_Kamysh", "CamoU_Kamysh_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_eaf_F"],
			["H_HelmetAggressor_F", "H_HelmetAggressor_cover_F", "H_HelmetAggressor_cover_F"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_M81": {

			[
			_unit,
			["CamoU_M81", "CamoU_M81_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["Helmet_SF_m81", "Helmet_L_m81"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		case "FFCP_NATO_SF_M81_FLB": { //versión alternativa con cascos de FLB

			[
			_unit,
			["CamoU_M81", "CamoU_M81_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["flb_opscover_peltor_03", "flb_opscover_earpiece_03"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		case "FFCP_NATO_SF_DPM95": {

			[
			_unit,
			["CamoU_M81", "CamoU_M81_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["Helmet_SF_m81", "Helmet_L_m81"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		case "FFCP_NATO_SF_DPM95_FLB": { //versión alternativa con cascos de FLB

			[
			_unit,
			["CamoU_dpm95", "CamoU_dpm95_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["FLB_OpsCore_Plain_A_02"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_MDU10": {

			[
			_unit,
			["CamoU_mdu10", "CamoU_mdu10_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["H_HelmetAggressor_F"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_OCP": {

			[
			_unit,
			["CamoU_OCP", "CamoU_OCP_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Kitbag_rgr"],
			["B_Carryall_oli"],
			["B_RadioBag_01_wdl_F"],
			["Helmet_SF_OCP", "Helmet_L_OCP"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_PARTIZANA": {

			[
			_unit,
			["CamoU_PartizanA", "CamoU_PartizanA_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_khk"],
			["B_RadioBag_01_hex_F"],
			["H_HelmetAggressor_F"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_PARTIZANS": {

			[
			_unit,
			["CamoU_PartizanS", "CamoU_PartizanS_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_sgg"],
			["B_Kitbag_sgg"],
			["B_Kitbag_sgg"],
			["B_Carryall_oli"],
			["B_RadioBag_01_ghex_F"],
			["H_HelmetAggressor_F"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_DIGIRU": {

			[
			_unit,
			["CamoU_digiru", "CamoU_digiru_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_sgg"],
			["B_Kitbag_sgg"],
			["B_Kitbag_sgg"],
			["B_Carryall_oli"],
			["B_RadioBag_01_ghex_F"],
			["H_HelmetAggressor_F"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_TTSKO": {

			[
			_unit,
			["CamoU_ttsko", "CamoU_ttsko_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_khk"],
			["B_RadioBag_01_hex_F"],
			["H_HelmetAggressor_F"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
		
		case "FFCP_NATO_SF_WZ93": {

			[
			_unit,
			["CamoU_wz93", "CamoU_wz93_rs"],
			["V_PlateCarrier1_rgr"], //sl
			["V_PlateCarrier1_rgr"], //ar
			["V_PlateCarrier1_rgr"], //rifleman
			["V_PlateCarrier1_rgr"], //gl
			["V_PlateCarrier1_rgr"], //medical
			[], //crew
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Kitbag_cbr"],
			["B_Carryall_khk"],
			["B_RadioBag_01_hex_F"],
			["H_HelmetAggressor_F"],
			["G_Balaclava_blk"],
			SAC_GEAR_preferred_nvg,
			"RHS_MK18",
			_silencer,
			"",
			_role,
			false
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

		};
*/		
		

		

		
		//*****************************************************************************************************
		//	VIETNAM
		//*****************************************************************************************************
		
		case "FIST_VC": { //s&s + unsung + cup + dhi for the full experience ;)

			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
			_unit forceAddUniform selectRandom ["UNS_VC_G", "UNS_VC_K", "UNS_VC_B", "UNS_VC_U", "UNS_VC_U", "UNS_VC_B", "UNS_VC_B", "UNS_VC_B", "UNS_VC_U"];
			
			if (_role == "UNARMED") exitWith {};
			
			_unit addVest selectRandom ["V_Simc_mk56", "V_Simc_mk56_sks"];
			
			if (_role in ["MG", "ENG", "MEDIC", "AT"]) then {
			
				_unit addBackpack selectRandom ["CUP_B_AlicePack_Khaki", "CUP_B_AlicePack_OD", "usm_pack_alice"];
				
			} else {
			
				_unit addBackpack "UNS_VC_R1";
				
			};
			
			[_unit, "CUP_VC", _role, false] call SAC_GEAR_fnc_giveWeapons;

			if ((count backpackItems _unit == 0) && (random 1 > 0.4)) then {removeBackpack _unit};

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";

			_unit addHeadgear selectRandom ["H_Simc_nasi", "H_Simc_nasi", "UNS_Headband_VC", "UNS_Boonie_VC", "UNS_Boonie_VC", "UNS_Boonie_VC", "uns_vc_headband_blue", "UNS_Boonie3_VC", "UNS_Boonie3_VC"];

			_unit addGoggles selectRandom ["CUP_FR_NeckScarf4", "CUP_FR_NeckScarf5", "CUP_FR_NeckScarf5", "CUP_FR_NeckScarf5", "", "", ""];

		};

		//*****************************************************************************************************
		//	MANU
		//*****************************************************************************************************

		case "china_50_winter": { 
			
			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
		
			if (_role == "UNARMED") exitWith {};

			_face = selectRandom [
				"AsianHead_A3_05", "LIB_AsianHead_02_Dirt",
				"LIB_AsianHead_02_Camo", "AsianHead_A3_02",
				"AsianHead_A3_04", "LIB_AsianHead_03_Camo",
				"LIB_AsianHead_03_Dirt", "AsianHead_A3_03",
				"AsianHead_A3_07", "AsianHead_A3_01",
				"LIB_AsianHead_01_Dirt", "LIB_AsianHead_01_Camo"
			];

			_voice = selectRandom ["Male01CHI","Male02CHI","Male03CHI"];

			[_unit,_face,_voice] call BIS_fnc_setIdentity;

			// guantes como nvg 
			_unit linkItem selectRandom [
				"G_NORTH_FIN_Gloves",
				"G_NORTH_FIN_Gloves_2",
				"G_NORTH_FIN_Gloves_3",
				"G_NORTH_FIN_Gloves_4"
			];
			
			// uniform
			if (_role in ["OF","SL","TL","MED","MM"]) then {
				if (_role in ["OF"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr31_W_Polushubuk",
						"U_NORTH_SOV_Obr31_W_Polushubuk_2",
						"U_NORTH_SOV_Obr31_W_Polushubuk_3",
						"U_NORTH_SOV_Obr31_W_Polushubuk_3",
						"U_NORTH_SOV_Obr35_W_Greatcoat_NKVD_Cpt",
						"U_NORTH_SOV_Obr35_W_Greatcoat_NKVD_Lt",
						"U_NORTH_SOV_Obr35_W_Greatcoat_NKVD_1stLt"
					];
				};
				if (_role in ["SL"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr43_W_Telogreika_Sergeant",
						"U_NORTH_SOV_Obr43_W_Telogreika_Sergeant",
						"U_NORTH_SOV_Obr43_W_Telogreika_Sergeant_2",
						"U_NORTH_SOV_Obr43_W_Telogreika_Sergeant_2",
						"U_NORTH_SOV_Obr43_W_Telogreika_Lt"
					];
				};
				if (_role in ["TL"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr43_W_Telogreika_Corporal",
						"U_NORTH_SOV_Obr43_W_Telogreika_Corporal_2"
					];
				};
				if (_role in ["MED"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr35_W_Greatcoat_Private",
						"U_NORTH_SOV_Obr35_W_Greatcoat_Private_2",
						"U_NORTH_SOV_Obr35_W_Greatcoat_Private_3",
						"U_NORTH_SOV_Obr35_W_Greatcoat_Private_4",
						"U_NORTH_SOV_Obr35_W_Greatcoat_Private_5"
					];
				};
				if (_role in ["MM"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr37_43_W_MKK_hooded_5",
						"U_NORTH_SOV_Obr37_43_W_MKK_5"
					];
				};
				
			} else {
				_unit forceAddUniform selectRandom [
					"U_NORTH_SOV_Obr32_W_Telogreika",
					"U_NORTH_SOV_Obr32_W_Telogreika_2",
					"U_NORTH_SOV_Obr32_W_Telogreika_3",
					"U_NORTH_SOV_Obr32_W_Telogreika_4",
					"U_NORTH_SOV_Obr32_W_Telogreika_5",
					"U_NORTH_SOV_Obr32_W_Telogreika_6"
				];
			};
				
			// vest
			// definido en la parte de giveWeapon			
			
			// backpack
			if (_role in ["MED","ENG","AR","MG","MG_A","MOR"]) then {

				if (_role in ["MED"]) then {
					_unit addBackpack "fow_b_tornister_medic";
					
					_unit  addGoggles "G_NORTH_FIN_Medicalarmband";
				};
				if (_role in ["ENG"]) then {
					_unit addBackpack "NORTH_SOV_M38bpk";
					_unit addItemToBackpack "ToolKit";
					_unit addItem "ATMine_Range_Mag";
					_unit addItem "DemoCharge_Remote_Mag";
				};
				if (_role in ["AR", "MG_A"]) then {
					_unit addBackpack selectRandom [
						"EAW_IJA_LMG_AmmoBearer_Bag",
						"EAW_IJA_LMG_AmmoBearer_Bag",
						"EAW_IJA_LMG_AmmoBearer_Bag",
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel",
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel_2",
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel_3"
					];
				};
				if (_role in ["MG"]) then {
					_unit addBackpack selectRandom [
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel",
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel_2",
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel_3"
					];
				};
				if (_role in ["MOR"]) then {
					_unit addBackpack "NORTH_fin_MolotovBag";
					for "_i" from 1 to 4 do {_unit addItemToBackpack "EAW_Type89_Grenade_HE";};
				};
				
			} else {
				_unit addBackpack selectRandom [
					"EAW_Chinese_Backpack_4",
					"EAW_Chinese_Backpack_6",
					"EAW_Chinese_Backpack_1",
					"EAW_Chinese_Backpack_3",
					"EAW_Chinese_Backpack_2_1",
					"EAW_Chinese_Backpack_2_2",
					"EAW_Chinese_Backpack_2_3",
					"EAW_Chinese_Backpack_3_1",
					"EAW_Chinese_Backpack_3_2",
					"EAW_Chinese_Backpack_3_3",
					"EAW_Chinese_Backpack_2_1",
					"EAW_Chinese_Backpack_2_2",
					"EAW_Chinese_Backpack_2_3",
					"EAW_Chinese_Backpack_3_1",
					"EAW_Chinese_Backpack_3_2",
					"EAW_Chinese_Backpack_3_3",
					"NORTH_SOV_Gasmaskbag",
					"NORTH_SOV_Gasmaskbag_Shinel",
					"NORTH_SOV_Veshmeshok",
					"NORTH_SOV_Veshmeshok_2",
					"NORTH_SOV_Veshmeshok_3",
					"NORTH_SOV_Veshmeshok_Shinel",
					"NORTH_SOV_Veshmeshok_Shinel_2",
					"NORTH_SOV_Veshmeshok_Shinel_3",
					"NORTH_SOV_Plash",
					"NORTH_SOV_Shinel"
				];
			};
			
			// [_unit, "korea_50_summer_wapons", _role, false] call SAC_GEAR_fnc_giveWeapons;
			[_unit, "china_50_winter_wapons", _role, false] call SAC_GEAR_fnc_giveWeapons;

			if ((count backpackItems _unit == 0) && (random 1 > 0.4)) then {removeBackpack _unit};

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";

			//helmet
			if (_role in ["CREW"]) then {
				
				_unit addHeadgear "H_NORTH_SOV_Tankerhelmet_beige_dustgoggles";
				
			} else {
				if (random 1 < 0.2) then {
					_unit addHeadgear selectRandom [
						"H_NORTH_SOV_SSh39_Helmet_Winter_1",
						"H_NORTH_SOV_SSh39_Helmet_Winter_2",
						"H_NORTH_SOV_SSh39_Helmet_Winter_2",
						"H_NORTH_SOV_SSh40_Helmet_camo_winter_3",
						"H_NORTH_SOV_SSh40_Helmet_camo_winter_5"
					];
				} else {
					
					_unit addHeadgear selectRandom [
						"H_LIB_SOV_Ushanka2","H_LIB_SOV_Ushanka2","H_LIB_SOV_Ushanka2",
						"H_LIB_SOV_Ushanka2","H_LIB_SOV_Ushanka2","H_LIB_SOV_Ushanka2",
						"H_NORTH_SOV_Obr40_Ushanka_SBD","H_NORTH_SOV_Obr40_Ushanka_SBD_2",
						"H_NORTH_SOV_Obr40_Ushanka_SBD_3","H_NORTH_SOV_Obr40_Ushanka_SBD_4"
					];
					
				};
			};
			
		};

		case "china_50_summer": { 
			
			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
		
			if (_role == "UNARMED") exitWith {};

			_face = selectRandom [
				"AsianHead_A3_05", "LIB_AsianHead_02_Dirt",
				"LIB_AsianHead_02_Camo", "AsianHead_A3_02",
				"AsianHead_A3_04", "LIB_AsianHead_03_Camo",
				"LIB_AsianHead_03_Dirt", "AsianHead_A3_03",
				"AsianHead_A3_07", "AsianHead_A3_01",
				"LIB_AsianHead_01_Dirt", "LIB_AsianHead_01_Camo"
			];

			_voice = selectRandom ["Male01CHI","Male02CHI","Male03CHI"];

			[_unit,_face,_voice] call BIS_fnc_setIdentity;
			
			// uniform
			if (_role in ["OF","SL","TL"]) then {
				if (_role in ["OF"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr35_Uniform_SBD_Cpt",
						"U_NORTH_SOV_Obr35_Uniform_SBD_Lt",
						"U_NORTH_SOV_Obr35_Uniform_SBD_1stLt",
						"U_NORTH_SOV_Obr43_Uniform_ARM_Cpt",
						"U_NORTH_SOV_Obr43_Uniform_ARM_Lt",
						"U_NORTH_SOV_Obr43_Uniform_ARM_2ndLt",
						"U_NORTH_SOV_Obr43_Uniform_ARM_1stLt"
					];
				};
				if (_role in ["SL"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr43_Uniform_ART_Corporal",
						"U_NORTH_SOV_Obr43_Uniform_ART_Corporal",
						"U_NORTH_SOV_Obr43_Uniform_ART_Sergeant",
						"U_NORTH_SOV_Obr43_Uniform_ART_Sergeant",
						"U_NORTH_SOV_Obr35_Uniform_SBD_Sergeant",
						"U_NORTH_SOV_Obr43_Uniform_ARM_Lt",
						"U_NORTH_SOV_Obr43_Uniform_ARM_Lt",
						"U_NORTH_SOV_Obr35_Uniform_SBD_Sergeant_2",
						"U_NORTH_SOV_Obr35_Uniform_SBD_Staff_Sergeant",
						"U_NORTH_SOV_Obr35_Uniform_SBD_Staff_Sergeant_2"
					];
				};
				if (_role in ["TL"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr43_Uniform_ART_Sergeant",
						"U_NORTH_SOV_Obr43_Uniform_ART_Corporal",
						"U_NORTH_SOV_Obr35_Uniform_SBD_Corporal",
						"U_NORTH_SOV_Obr35_Uniform_SBD_Corporal_2"
					];
				};				
			} else {
				_unit forceAddUniform selectRandom [
					"U_NORTH_SOV_Obr43_Uniform_ART_Private",
					"U_NORTH_SOV_Obr43_Uniform_ART_Private_2",
					"U_NORTH_SOV_Obr43_Uniform_ART_Private_1CL",
					"U_NORTH_SOV_Obr35_Uniform_Penal",
					"U_NORTH_SOV_Obr35_Uniform_Penal_2",
					"U_NORTH_SOV_Obr35_Uniform_Penal_3",
					"U_NORTH_SOV_Obr35_Uniform_Penal_4",
					"U_NORTH_SOV_Obr35_Uniform_Penal_5",
					"U_NORTH_SOV_Obr35_Uniform_Penal_6",
					"U_NORTH_SOV_Obr35_Uniform_SBD_Private_2",
					"U_NORTH_SOV_Obr35_Uniform_SBD_Private_1CL",
					"U_NORTH_SOV_Obr35_Uniform_SBD_Private_1CL_2",
					"U_NORTH_SOV_Obr35_Uniform_SBD_Private_4"
				];
			};
				
			// vest
			// definido en la parte de giveWeapon			
			
			// backpack
			if (_role in ["MED","ENG","AR","MG","MG_A","MOR"]) then {

				if (_role in ["MED"]) then {
					_unit addBackpack "fow_b_tornister_medic";
					
					_unit  addGoggles "G_NORTH_FIN_Medicalarmband";
				};
				if (_role in ["ENG"]) then {
					_unit addBackpack "NORTH_SOV_M38bpk";
					_unit addItemToBackpack "ToolKit";
					_unit addItem "ATMine_Range_Mag";
					_unit addItem "DemoCharge_Remote_Mag";
				};
				if (_role in ["AR", "MG_A"]) then {
					_unit addBackpack selectRandom [
						"EAW_IJA_LMG_AmmoBearer_Bag",
						"EAW_IJA_LMG_AmmoBearer_Bag",
						"EAW_IJA_LMG_AmmoBearer_Bag",
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel",
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel_2",
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel_3"
					];
				};
				if (_role in ["MG"]) then {
					_unit addBackpack selectRandom [
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel",
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel_2",
						"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel_3"
					];
				};
				if (_role in ["MOR"]) then {
					_unit addBackpack "NORTH_fin_MolotovBag";
					for "_i" from 1 to 4 do {_unit addItemToBackpack "EAW_Type89_Grenade_HE";};
				};
				
			} else {
				_unit addBackpack selectRandom [
					"EAW_Chinese_Backpack_4",
					"EAW_Chinese_Backpack_6",
					"EAW_Chinese_Backpack_1",
					"EAW_Chinese_Backpack_3",
					"EAW_Chinese_Backpack_2_1",
					"EAW_Chinese_Backpack_2_2",
					"EAW_Chinese_Backpack_2_3",
					"EAW_Chinese_Backpack_3_1",
					"EAW_Chinese_Backpack_3_2",
					"EAW_Chinese_Backpack_3_3",
					"EAW_Chinese_Backpack_2_1",
					"EAW_Chinese_Backpack_2_2",
					"EAW_Chinese_Backpack_2_3",
					"EAW_Chinese_Backpack_3_1",
					"EAW_Chinese_Backpack_3_2",
					"EAW_Chinese_Backpack_3_3",
					"NORTH_SOV_Gasmaskbag",
					"NORTH_SOV_Gasmaskbag_Shinel",
					"NORTH_SOV_Veshmeshok",
					"NORTH_SOV_Veshmeshok_2",
					"NORTH_SOV_Veshmeshok_3",
					"NORTH_SOV_Veshmeshok_Shinel",
					"NORTH_SOV_Veshmeshok_Shinel_2",
					"NORTH_SOV_Veshmeshok_Shinel_3",
					"NORTH_SOV_Plash",
					"NORTH_SOV_Shinel"
				];
			};
			
			// [_unit, "korea_50_summer_wapons", _role, false] call SAC_GEAR_fnc_giveWeapons;
			[_unit, "china_50_winter_wapons", _role, false] call SAC_GEAR_fnc_giveWeapons;

			if ((count backpackItems _unit == 0) && (random 1 > 0.4)) then {removeBackpack _unit};

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";

			//helmet
			if (_role in ["CREW"]) then {
				
				_unit addHeadgear "H_NORTH_SOV_Tankerhelmet_beige_dustgoggles";
				
			} else {

				if (_role in ["OF", "SL"]) then {

					if (_role in ["OF"]) then {
						_unit addHeadgear selectRandom [
							"H_NORTH_SOV_Obr35_Furazhka_Field",
							"H_NORTH_SOV_Obr35_Furazhka_Field_2",
							"H_NORTH_SOV_Obr35_Furazhka_Field_3",
							"H_NORTH_SOV_Obr35_Furazhka_Field_4"
						];
					};		
					if (_role in ["SL"]) then {
						_unit addHeadgear selectRandom [
							"H_NORTH_SOV_SSh39_Helmet",
							"H_NORTH_SOV_SSh40_Helmet",
							"H_NORTH_SOV_SSh40_Helmet_2",
							"H_NORTH_SOV_SSh40_Helmet_3"
						];
					};			
				
				} else {
					if (random 1 < 0.33) then {
						_unit addHeadgear selectRandom [
							"H_NORTH_SOV_SSh39_Helmet",
							"H_NORTH_SOV_SSh40_Helmet",
							"H_NORTH_SOV_SSh40_Helmet_2",
							"H_NORTH_SOV_SSh40_Helmet_3"
						];
					} else {
						_unit addHeadgear selectRandom [
							"EAW_Chinese_Cap_1_Camo_Brown2",
							"EAW_Chinese_Cap_2_Camo_Brown2",
							"EAW_Chinese_Cap_1_Camo_Brown",
							"EAW_Chinese_Cap_2_Camo_Brown",
							"EAW_Chinese_Cap_1_Camo_Green2",
							"EAW_Chinese_Cap_1_Camo_Green2",
							"EAW_Chinese_Cap_1_Camo_Green2",
							"EAW_Chinese_Cap_1_Camo_Green2",
							"EAW_Chinese_Cap_2_Camo_Green2",
							"EAW_Chinese_Cap_1_Camo_Green",
							"EAW_Chinese_Cap_1_Camo_Green",
							"EAW_Chinese_Cap_1_Camo_Green",
							"EAW_Chinese_Cap_2_Camo_Green",
							"EAW_Chinese_Cap_1_Camo_Tan",
							"EAW_Chinese_Cap_2_Camo_Tan",

							"EAW_Chinese_Cap_Green2",
							"EAW_Chinese_Cap_Green",
							"EAW_Chinese_Cap_Tan"
						];
					};
				};				
			};			
		};

		case "korea_50_summer": { 
			
			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
		
			if (_role == "UNARMED") exitWith {};

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
				"LIB_AsianHead_01_Camo"
			];

			_voice = selectRandom [
				"Male01CHI","Male02CHI","Male03CHI"
			];

			[_unit,_face,_voice] call BIS_fnc_setIdentity;
			
			// uniform
			if (_role in ["CREW","OFC","SL","TL","MED","MM","MG"]) then {
				
				if (_role in ["CREW"]) then {
					_unit forceAddUniform "U_NORTH_SOV_Obr43_Uniform_ART_Private_2";
				};
				if (_role in ["OFC"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr35_Uniform_Early_Cpt",
						"U_NORTH_SOV_Obr35_Uniform_Early_Cpt_2"
					];
				};
				if (_role in ["SL"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr35_Uniform_Early_Staff_Sergeant",
						"U_NORTH_SOV_Obr35_Uniform_Early_Staff_Sergeant",
						"U_NORTH_SOV_Obr35_Uniform_Early_Staff_Sergeant",
						"U_NORTH_SOV_Obr35_Uniform_Early_Staff_Sergeant_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Staff_Sergeant_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Staff_Sergeant_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant_Major",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant_Major",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant_Major",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant_Major_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant_Major_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant_Major_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Lt",
						"U_NORTH_SOV_Obr35_Uniform_Early_Lt_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_2ndLt",
						"U_NORTH_SOV_Obr35_Uniform_Early_2ndLt_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_1stLt",
						"U_NORTH_SOV_Obr35_Uniform_Early_1stLt_2"
					];
				};
				if (_role in ["TL"]) then {
					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Sergeant_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private_3",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private_4",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private_5",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private_6"
					];
				};
				if (_role in ["MED","MM","MG"]) then {

					_unit forceAddUniform selectRandom [
						"U_NORTH_SOV_Obr35_Uniform_Early_Private",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private_2",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private_3",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private_4",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private_5",
						"U_NORTH_SOV_Obr35_Uniform_Early_Private_6"
					];
				};
				
			} else {
				_unit forceAddUniform selectRandom [
					"U_NORTH_SOV_Obr35_Uniform_Penal",
					"U_NORTH_SOV_Obr35_Uniform_Penal_2",
					"U_NORTH_SOV_Obr35_Uniform_Penal_3",
					"U_NORTH_SOV_Obr35_Uniform_Penal_4",
					"U_NORTH_SOV_Obr35_Uniform_Penal_5",
					"U_NORTH_SOV_Obr35_Uniform_Early_Private_3",
					"U_NORTH_SOV_Obr35_Uniform_Early_Private_4",
					"U_NORTH_SOV_Obr35_Uniform_Penal_6"
				];
			};
				
			// vest
			// definido en la parte de giveWeapon			
			
			// backpack
			if (_role in ["ENG","MED","RO"]) then {

				if (_role in ["ENG"]) then {
					_unit addBackpack "NORTH_SOV_M38bpk";
					_unit addItemToBackpack "ToolKit";
					_unit addItem "ATMine_Range_Mag";
					_unit addItem "DemoCharge_Remote_Mag";
				};
				if (_role in ["MED"]) then {
					_unit addBackpack selectRandom [
						"B_LIB_SOV_RA_MedicalBag_Empty",
						"B_LIB_GER_MedicBackpack_Empty"
					];
					if (random 1 < 0.5) then {
						_unit  addGoggles "G_NORTH_FIN_Medicalarmband";
					};
				};
				if (_role in ["RO"]) then {
					_unit addBackpack selectRandom [
						"B_LIB_SOV_RA_Radio",
						"NORTH_fin_Kyynel"
					];
				};
				
			} else {
				_unit addBackpack selectRandom [
					"NORTH_SOV_Gasmaskbag",
					"NORTH_SOV_Gasmaskbag_Shinel",
					"NORTH_SOV_M35bpk",
					"NORTH_SOV_Veshmeshok",
					"NORTH_SOV_Veshmeshok_2",
					"NORTH_SOV_Veshmeshok_3",
					"NORTH_SOV_Veshmeshok_Gasmaskbag",
					"NORTH_SOV_Veshmeshok_Gasmaskbag_2",
					"NORTH_SOV_Veshmeshok_Gasmaskbag_3",
					"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel",
					"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel_2",
					"NORTH_SOV_Veshmeshok_Gasmaskbag_Shinel_3",
					"NORTH_SOV_Veshmeshok_Shinel",
					"NORTH_SOV_Veshmeshok_Shinel_2",
					"NORTH_SOV_Veshmeshok_Shinel_3",
					"NORTH_SOV_Plash",
					"NORTH_SOV_Shinel"
				];
			};
			
			[_unit, "korea_50_summer_wapons", _role, false] call SAC_GEAR_fnc_giveWeapons;

			if ((count backpackItems _unit == 0) && (random 1 > 0.4)) then {removeBackpack _unit};

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";

			//helmet
			if (_role in ["CREW", "SL", "TL", "OFC"]) then {
				if (_role in ["CREW"]) then {
					_unit addHeadgear "H_NORTH_SOV_Tankerhelmet_beige_dustgoggles";
				};
				if (_role in ["OFC"]) then {
					_unit addHeadgear selectRandom [
						"H_NORTH_SOV_Obr35_Furazhka_Field",
						"H_NORTH_SOV_Obr35_Furazhka_Field_2",
						"H_NORTH_SOV_Obr35_Furazhka_Field_3",
						"H_NORTH_SOV_Obr35_Furazhka_Field_4",
						"H_NORTH_SOV_Obr35_Furazhka_Field_5",
						"H_NORTH_SOV_Obr35_Furazhka_Field_6"
					];
				};
				if (_role in ["SL", "TL"]) then {
					_unit addHeadgear selectRandom [
						"H_NORTH_SOV_SSh36_Helmet",
						"H_NORTH_SOV_SSh36_Helmet_2",
						"H_NORTH_SOV_SSh36_Helmet_3",
						"H_NORTH_SOV_SSh36_Helmet_smallstar",
						"H_NORTH_SOV_SSh36_Helmet_empty",
						"H_NORTH_SOV_SSh39_Helmet",
						"H_NORTH_SOV_SSh39_Helmet_2",
						"H_NORTH_SOV_SSh39_Helmet_Moss_1",
						"H_NORTH_SOV_SSh39_Helmet_Moss_2",
						"H_NORTH_SOV_SSh40_Helmet",
						"H_NORTH_SOV_SSh40_Helmet_2",
						"H_NORTH_SOV_SSh40_Helmet_3",
						"H_NORTH_SOV_SSh40_Helmet_Moss_1",
						"H_NORTH_SOV_SSh40_Helmet_Moss_2"
					];
				};
			} else {
				if (random 1 < 0.2) then {
					_unit addHeadgear selectRandom [
						"H_NORTH_SOV_SSh36_Helmet",
						"H_NORTH_SOV_SSh36_Helmet_2",
						"H_NORTH_SOV_SSh36_Helmet_3",
						"H_NORTH_SOV_SSh36_Helmet_smallstar",
						"H_NORTH_SOV_SSh36_Helmet_empty",
						"H_NORTH_SOV_SSh39_Helmet",
						"H_NORTH_SOV_SSh39_Helmet_2",
						"H_NORTH_SOV_SSh39_Helmet_Moss_1",
						"H_NORTH_SOV_SSh39_Helmet_Moss_2",
						"H_NORTH_SOV_SSh40_Helmet",
						"H_NORTH_SOV_SSh40_Helmet_2",
						"H_NORTH_SOV_SSh40_Helmet_3",
						"H_NORTH_SOV_SSh40_Helmet_Moss_1",
						"H_NORTH_SOV_SSh40_Helmet_Moss_2"
					];
				} else {
					if (random 1 < 0.25) then {
						_unit addHeadgear selectRandom [
							"H_NORTH_SOV_Obr38_Panamanka",
							"H_NORTH_SOV_Obr38_Panamanka_2",
							"H_NORTH_SOV_Obr38_Panamanka_3",
							"H_NORTH_SOV_Obr38_Panamanka_4",
							"H_NORTH_SOV_Obr38_Panamanka_5"
						];
					} else {
						_unit addHeadgear selectRandom [
							"H_NORTH_SOV_Obr35_Pilotka",
							"H_NORTH_SOV_Obr35_Pilotka_2",
							"H_NORTH_SOV_Obr35_Pilotka_3",
							"H_NORTH_SOV_Obr35_Pilotka_4"
						];
					};
				};
			};
			
		};	

		case "rusia_2022_loadout": { 
			
			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
		
			if (_role == "UNARMED") exitWith {};
			
			// uniform
			if (_role in ["CREW"]) then {
				
				_unit forceAddUniform selectRandom ["Z_P_1","Z_P_2"];
				
			} else {
				_unit forceAddUniform selectRandom [
					"Z_5","Z_6","Z_11"
				];
			};
				
			// vest
			if (_role in ["CREW"]) then {
				
				_unit addVest "V_SmershVest_01_radio_F";
				
			};
			if (_role in ["PILOT"]) then {
				
				_unit forceAddUniform "U_I_E_Uniform_01_coveralls_F";
				_unit addVest "V_SmershVest_01_radio_F";
				
			};
			if (_role in ["SL", "RO"]) then {
				
				_unit addVest "rhs_6sh117_nco_azart";
				
			};
			if (_role in ["TL"]) then {
				
				_unit addVest "rhs_6sh117_nco";
				
			};
			if (_role in ["GL"]) then {
				
				_unit addVest "rhs_6sh117_grn";
				
			};
			if (_role in ["HMG"]) then {
				
				_unit addVest "rhs_6sh117_mg";
				
			};
			if (_role in ["LMG", "MG_A", "ENG", "MED"]) then {
				
				_unit addVest "rhs_6sh117_ar";
				
			};
			if (_role in ["AT", "AT_A", "AA", "RIF", "RIF_L", "LAT"]) then {
				
				_unit addVest "rhs_6sh117_rifleman";
				
			};
			if (_role in ["MM"]) then {
				
				_unit addVest "rhs_6sh117_svd";
				
			};
			
			
			// backpack
			if (_role in ["SL","TL","HMG","MG_A","LMG","RIF","RIF_L","LAT","GL","MM"]) then {
			
				_unit addBackpack selectRandom ["CUP_O_RUS_Patrol_bag_Summer", "CUP_O_RUS_Patrol_bag_Summer_Shovel"];
				
			};
			if (_role in ["AT", "AT_A", "AA"]) then {
			
				_unit addBackpack "rhs_rpg_2";
				
			};
			if (_role in ["ENG"]) then {
			
				_unit addBackpack "rhs_rk_sht_30_emr_engineer_empty";
				_unit addItemToBackpack "ToolKit";
				_unit addItem "ATMine_Range_Mag";
				_unit addItem "DemoCharge_Remote_Mag";
				
			};
			if (_role in ["RO"]) then {
			
				_unit addBackpack "MTW_RadioBackpack";
				
			};
			
			[_unit, "rusia_2022_wapons", _role, false] call SAC_GEAR_fnc_giveWeapons;

			if ((count backpackItems _unit == 0) && (random 1 > 0.4)) then {removeBackpack _unit};

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";

			//helmet
			if (_role in ["CREW", "PILOT", "SL", "MM"]) then {
				if (_role in ["CREW"]) then {
					_unit addHeadgear "rhs_6b48";
				};
				if (_role in ["PILOT"]) then {
					_unit addHeadgear "rhs_zsh7a_mike_green";
				};
				if (_role in ["SL"]) then {
					_unit addHeadgear selectRandom ["Z5", "Z13"];
					_unit addGoggles selectRandom ["G_Bandanna_oli","G_Bandanna_blk","G_Balaclava_blk","G_Balaclava_oli","rhs_scarf","CUP_G_RUS_Balaclava_Ratnik","CUP_PMC_Facewrap_Tropical"];
				};
				if (_role in ["MM"]) then {
					_unit addHeadgear selectRandom ["rhs_Booniehat_digi","rhs_beanie_green","rhs_beanie"];
					_unit addGoggles selectRandom ["G_Bandanna_oli","G_Bandanna_blk","G_Balaclava_blk","G_Balaclava_oli","rhs_scarf","CUP_G_RUS_Balaclava_Ratnik","CUP_PMC_Facewrap_Tropical"];
				};
			} else {
				_unit addHeadgear selectRandom ["Z9","Z7","Z12","Z13","Z7","Z6","Z15","Z7","Z1","Z7"];
				_unit addGoggles selectRandom ["G_Bandanna_oli","G_Bandanna_blk","G_Balaclava_blk","G_Balaclava_oli","rhs_scarf","CUP_G_RUS_Balaclava_Ratnik","CUP_PMC_Facewrap_Tropical"];
			};
			

		};	
		
		case "SYRIAN_ARMY_ALTIS_loadout": { 
			
			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
		
			if (_role == "UNARMED") exitWith {};
			
			// uniform and vest
			if (_role in ["SL","TL"]) then {
				
				_unit forceAddUniform "U_I_E_Uniform_01_F";
				_unit addVest "V_SmershVest_01_radio_F";
				
			};
			if (_role in ["RIF","LAT","MM","H_MG","L_MG","MG_Asst","GL","ENG","MED","AT","AT_Asst","AA"]) then {
			
				_unit forceAddUniform selectRandom [
					"U_I_E_Uniform_01_shortsleeve_F",
					"U_I_E_Uniform_01_sweater_F",
					"U_I_L_Uniform_01_deserter_F",
					"U_I_L_Uniform_01_camo_F"
				];
				_unit addVest "V_SmershVest_01_F";
				
			}; 
			if (_role in ["CREW"]) then {
				
				_unit forceAddUniform "U_I_E_Uniform_01_sweater_F";
				_unit addVest "V_SmershVest_01_radio_F";
				_unit addHeadgear "H_Tank_eaf_F";
				
			};
			if (_role in ["PILOT"]) then {
				
				_unit forceAddUniform "U_I_E_Uniform_01_coveralls_F";
				_unit addVest "V_SmershVest_01_radio_F";
				_unit addHeadgear "H_PilotHelmetHeli_I_E";
				
			};
			// backpack
			if (_role in ["GL"]) then {
			
				_unit addBackpack "BDU_RangerBelt_v2_1";
				
			};
			if (_role in ["MG_Asst"]) then {
			
				_unit addBackpack "LOP_IA_FalconII_SVD";
				
			};
			if (_role in ["H_MG"]) then {
			
				_unit addBackpack "B_Carryall_eaf_F";
				
			};
			if (_role in ["L_MG"]) then {
			
				_unit addBackpack "B_FieldPack_green_F";
				
			};
			if (_role in ["AT","AT_Asst","AA"]) then {
			
				_unit addBackpack "rhs_rpg_2";
				
			};
			
			if (_role in ["LAT"]) then {
			
				_unit addBackpack "UK3CB_B_Invisible";
				
			}; 

			if (_role in ["ENG"]) then {
			
				_unit addBackpack "LOP_IA_FalconII_SVD";
				_unit addItemToBackpack "ToolKit";
				_unit addItem "ATMine_Range_Mag";
				_unit addItem "DemoCharge_Remote_Mag";
			};
			
			[_unit, "Syrian_army_altis_wapons", _role, false] call SAC_GEAR_fnc_giveWeapons;

			if ((count backpackItems _unit == 0) && (random 1 > 0.4)) then {removeBackpack _unit};

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";

			//helmet
			if (_role in ["SL"]) then {
				_unit addHeadgear "H_MilCap_eaf";
			} else {
				if (random 1 < 0.2) then {
					_unit addHeadgear selectRandom ["UK3CB_LDF_B_H_HB97_GEO","UK3CB_LDF_B_H_HB97_ESS_GEO"];
				} else {
					_unit addHeadgear selectRandom ["H_Booniehat_eaf"];
				};
			};

			if (random 1 < 0.5) then {
				_unit linkItem "WBK_HeadLampItem";
			};

			// _unit addGoggles selectRandom ["UK3CB_G_Gloves_Green", "UK3CB_G_Gloves_Black"];

		};		

		case "ZOMBIES_loadout": { 
		
			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
		
			if (_role == "UNARMED") exitWith {};
			
			if (_role in ["LDF"]) then {
				
				_unit forceAddUniform selectRandom [
					"U_I_E_Uniform_01_shortsleeve_F",
					"U_I_E_Uniform_01_sweater_F",
					"U_I_L_Uniform_01_deserter_F",
					"U_I_L_Uniform_01_camo_F",
					"U_I_E_Uniform_01_F",
					"U_I_E_Uniform_01_officer_F"
				];
				_unit addVest selectRandom [
					"V_SmershVest_01_radio_F", 
					"V_SmershVest_01_F", 
					"V_CarrierRigKBT_01_heavy_EAF_F",
					"V_CarrierRigKBT_01_heavy_Olive_F",
					"V_CarrierRigKBT_01_light_EAF_F",
					"V_CarrierRigKBT_01_light_Olive_F",
					"V_CarrierRigKBT_01_EAF_F"
				];
				
				_unit addHeadgear selectRandom["H_MilCap_eaf", "UK3CB_LDF_B_H_HB97_GEO", "UK3CB_LDF_B_H_HB97_ESS_GEO", "H_Booniehat_eaf"];
				
				if (random 1 < 0.3) then {
					_unit linkItem "WBK_HeadLampItem";
				};
			};

			if (_role in ["FIA"]) then {
				
				_unit forceAddUniform selectRandom [
					"U_BG_Guerilla3_1",
					"U_BG_Guerilla1_1",
					"U_C_HunterBody_grn",
					"U_BG_Guerrilla_6_1",
					"U_I_G_resistanceLeader_F",
					"U_I_G_Story_Protagonist_F",
					"UK3CB_ADE_O_U_02_D",
					"UK3CB_ADE_O_U_02_C",
					"UK3CB_ADE_O_U_02_F"
				];
				_unit addVest selectRandom [
					"V_BandollierB_oli",
					"V_PlateCarrier1_blk",
					"V_TacVestIR_blk",
					"V_TacVest_oli",
					"UK3CB_TKA_O_V_6b23_ml_Oli_ADPM",
					"UK3CB_V_PlateCarrier1_oli",
					"UK3CB_AAF_O_V_Eagle_SL_DIGI_BRN",
					"UK3CB_AAF_I_V_Falcon_2_DIGI_GRN",
					"UK3CB_TKA_B_V_GA_LITE_BLK",
					"UK3CB_ANP_B_V_GA_LITE_TAN",
					"UK3CB_TKA_B_V_GA_HEAVY_NDIGI"
				];
				_unit addHeadgear selectRandom[
					"H_Beret_blk",
					"H_Cap_grn_BI",
					"H_Cap_Lyfe",
					"H_Cap_blk",
					"H_Cap_oli",
					"H_Booniehat_tan",
					"H_Booniehat_khk",
					"H_Booniehat_oli",
					"H_Shemag_olive",
					"H_Bandanna_sand",
					"H_Bandanna_camo",
					"H_Bandanna_khk",
					"H_Bandanna_cbr"					
				];
				
				if (random 1 < 0.2) then {
					_unit linkItem "WBK_HeadLampItem";
				};
			};

			if (_role in ["Civ"]) then {
				
				_unit forceAddUniform selectRandom [
					"U_I_C_Soldier_Bandit_1_F", "U_I_C_Soldier_Bandit_2_F", "U_I_C_Soldier_Bandit_3_F", "U_I_C_Soldier_Bandit_5_F", "U_C_HunterBody_grn", "U_I_L_Uniform_01_deserter_F", "U_C_Mechanic_01_F", "U_I_L_Uniform_01_tshirt_skull_F", "U_I_L_Uniform_01_tshirt_sport_F", "U_I_L_Uniform_01_tshirt_black_F", "U_I_L_Uniform_01_tshirt_olive_F", "U_C_E_LooterJacket_01_F", "U_C_Man_casual_5_F", "U_C_Man_casual_4_F", "U_C_Man_casual_6_F", "U_C_IDAP_Man_Tee_F", "U_C_IDAP_Man_TeeShorts_F", "U_C_IDAP_Man_Jeans_F", "U_C_Poor_1", "U_C_Poloshirt_stripped", "U_C_Poloshirt_blue", "U_C_Poloshirt_burgundy", "U_C_Poloshirt_redwhite", "U_C_Poloshirt_salmon", "U_C_Poloshirt_tricolour", "U_C_Man_casual_1_F", "U_C_Man_casual_2_F", "U_C_Man_casual_3_F"
				];
			};

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";

		};

		//*****************************************************************************************************
		//	Usos especiales
		//*****************************************************************************************************
		case "ADD_NVG_RU_RHS": {

			_unit linkItem "rhs_1PN138";
			
		};
/*		
		case "GRINCH": {

			private _loadout  = getUnitLoadout _unit;
	
			//reemplazo uniforme
			private _uniformArray = _loadout select 3;

			_uniformArray set [0, "nombre_uniforme"];
			
			_loadout set [3, _uniformArray];
			
			//reemplazo el casco
			_loadout set [6, "nombre_casco"];
			
			_unit setUnitLoadout _loadout;
			
		};
*/
		case "ADD_PRIM_MAGS": {

			_unit enableFatigue false;
			
			[_unit, 30] call SAC_fnc_addPrimaryMagazines;
			
		};



		//*****************************************************************************************************

		
	};

};

SAC_GEAR_fnc_applyLoadoutSquema_1 = {

	/*

			["_unit",
			"_uniforms",
			"_slVests",
			"_arVests",
			"_riflemanVests",
			"_glVests",
			"_medicVests",
			"_crewVests",
			"_slBackpacks",
			"_assaultBackpacks",
			"_supportBackpacks",
			"_medicalBackpacks",
			"_radioBackpacks",
			"_headGear",
			"_faceGear",
			"_nvg",
			"_weaponFamily",
			"_silencer",
			"_headGearCrew",
			"_role",
			"_neededBackpacksOnly"
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

	*/

		params ["_unit", "_uniforms", "_slVests", "_arVests", "_riflemanVests", "_glVests", "_medicVests", "_crewVests",
		"_slBackpacks", "_assaultBackpacks", "_supportBackpacks", "_medicalBackpacks", "_radioBackpacks", "_headGear",
		"_faceGear", "_nvg", "_weaponFamily", "_silencer", "_headGearCrew", "_role", "_neededBackpacksOnly"];

		_unit setVariable ["BIS_enableRandomization", false];
		
		if (count _this != 21) exitWith {hintC "Missing parameter in SAC_GEAR_fnc_applyLoadoutSquema_1"};
		
		sleep 0.5;

		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		
		
		_unit forceAddUniform selectRandom _uniforms;
		
		_unit setVariable ["SAC_GEAR_role", _role];
		
		if (_role == "UNARMED") exitWith {removeGoggles _unit};
		
		switch (_role) do {

			case "TL";
			case "SL": {
				_unit addVest selectRandom _slVests;
			};
			case "MG";
			case "AR": {
				_unit addVest selectRandom _arVests;
			};
			
			case "CREW": {
				_unit addVest selectRandom _crewVests;
			};
			
			case "ENG";
			case "LAT";
			case "HAT";
			case "AA";
			case "MM";
			case "RIFLEMAN": {
				_unit addVest selectRandom _riflemanVests;
			};
			case "GL": {
				_unit addVest selectRandom _glVests;
			};
			case "MEDIC": {
				_unit addVest selectRandom _medicVests;
			};
		};
		
		switch (_role) do {

			case "SL": {
				_unit addBackpack (selectRandom _slBackpacks);
			};
			case "MM": {
				_unit addBackpack (selectRandom _radioBackpacks);
			};
			case "CREW";
			case "GL";
			case "TL";
			case "RIFLEMAN": {
				_unit addBackpack (selectRandom _assaultBackpacks);
			};
			case "LAT";
			case "HAT";
			case "AA";
			case "ENG";
			case "MG";
			case "AR": {
				_unit addBackpack (selectRandom _supportBackpacks);
			};
			case "MEDIC": {
				_unit addBackpack (selectRandom _medicalBackpacks);
			};
			
		};
		
		[_unit, _weaponFamily, _role, _silencer, true] call SAC_GEAR_fnc_giveWeapons;

		if (_neededBackpacksOnly) then {
		
			if (!(_role in ["LAT", "HAT", "AA", "ENG", "MEDIC"]) && {count backpackItems _unit == 0}) then {removeBackpack _unit};
			
		};

		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
		
		if (_nvg isEqualType []) then {_nvg = selectRandom _nvg};
		
		if ((_nvg != "") && {!isNil "GEAR_NVG"} && {GEAR_NVG}) then {
		
			_unit linkItem _nvg;
			_unit setVariable ["SAC_GEAR_nvg_class", _nvg];
			
		};
		
		_unit linkItem "B_UavTerminal";
		
		removeHeadgear _unit;
		if (_role == "CREW") then {
		
			_unit addHeadgear _headGearCrew;
		
		} else {
		
			_unit addHeadgear selectRandom _headGear;
			
		};
		
		removeGoggles _unit;
		_unit addGoggles selectRandom _faceGear;


};

SAC_GEAR_fnc_applyLoadoutSquema_2 = {

	/*

			["_unit",
			"_slUniforms",
			"_medicUniforms",
			"_otherUniforms",
			"_slVests",
			"_arVests",
			"_riflemanVests",
			"_glVests",
			"_medicVests",
			"_crewVests",
			"_slBackpacks",
			"_assaultBackpacks",
			"_supportBackpacks",
			"_medicalBackpacks",
			"_radioBackpacks",
			"_headGear",
			"_faceGear",
			"_nvg",
			"_weaponFamily",
			"_silencer",
			"_headGearCrew",
			"_role",
			"_neededBackpacksOnly"
			] call SAC_GEAR_fnc_applyLoadoutSquema_1;

	*/

		params ["_unit", "_slUniforms", "_medicUniforms", "_otherUniforms", "_slVests", "_arVests", "_riflemanVests", "_glVests", "_medicVests", "_crewVests",
		"_slBackpacks", "_assaultBackpacks", "_supportBackpacks", "_medicalBackpacks", "_radioBackpacks", "_headGear",
		"_faceGear", "_nvg", "_weaponFamily", "_silencer", "_headGearCrew", "_role", "_neededBackpacksOnly"];

		_unit setVariable ["BIS_enableRandomization", false];
		
		if (count _this != 23) exitWith {hintC "Missing parameter in SAC_GEAR_fnc_applyLoadoutSquema_1"};
		
		sleep 0.5;

		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;

		switch (_role) do {

			case "SL": { _unit forceAddUniform selectRandom _slUniforms; };
			
			case "MEDIC": { _unit forceAddUniform selectRandom _medicUniforms; };
			
			default { _unit forceAddUniform selectRandom _otherUniforms; };

		};
		
		_unit setVariable ["SAC_GEAR_role", _role];
		
		if (_role == "UNARMED") exitWith {removeGoggles _unit};
		
		switch (_role) do {

			case "TL";
			case "SL": {
				_unit addVest selectRandom _slVests;
			};
			case "MG";
			case "AR": {
				_unit addVest selectRandom _arVests;
			};
			
			case "CREW": {
				_unit addVest selectRandom _crewVests;
			};
			
			case "ENG";
			case "LAT";
			case "HAT";
			case "AA";
			case "MM";
			case "RIFLEMAN": {
				_unit addVest selectRandom _riflemanVests;
			};
			case "GL": {
				_unit addVest selectRandom _glVests;
			};
			case "MEDIC": {
				_unit addVest selectRandom _medicVests;
			};
		};
		
		switch (_role) do {

			case "SL": {
				_unit addBackpack (selectRandom _slBackpacks);
			};
			case "MM": {
				_unit addBackpack (selectRandom _radioBackpacks);
			};
			case "CREW";
			case "GL";
			case "TL";
			case "RIFLEMAN": {
				_unit addBackpack (selectRandom _assaultBackpacks);
			};
			case "LAT";
			case "HAT";
			case "AA";
			case "ENG";
			case "MG";
			case "AR": {
				_unit addBackpack (selectRandom _supportBackpacks);
			};
			case "MEDIC": {
				_unit addBackpack (selectRandom _medicalBackpacks);
			};
			
		};
		
		[_unit, _weaponFamily, _role, _silencer, true] call SAC_GEAR_fnc_giveWeapons;

		if (_neededBackpacksOnly) then {
		
			if (!(_role in ["LAT", "HAT", "AA", "ENG", "MEDIC"]) && {count backpackItems _unit == 0}) then {removeBackpack _unit};
			
		};

		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
		
		if (_nvg isEqualType []) then {_nvg = selectRandom _nvg};
		
		if ((_nvg != "") && {!isNil "GEAR_NVG"} && {GEAR_NVG}) then {
		
			_unit linkItem _nvg;
			_unit setVariable ["SAC_GEAR_nvg_class", _nvg];
			
		};
		
		_unit linkItem "B_UavTerminal";
		
		removeHeadgear _unit;
		if (_role == "CREW") then {
		
			_unit addHeadgear _headGearCrew;
		
		} else {
		
			_unit addHeadgear selectRandom _headGear;
			
		};
		
		removeGoggles _unit;
		_unit addGoggles selectRandom _faceGear;


};

SAC_GEAR_fnc_applyLoadoutHeliPilot_RU = {

	params ["_unit"];
	
	comment "Exported from Arsenal by Sebastian";

	comment "Remove existing items";
	removeAllWeapons _unit;
	removeAllItems _unit;
	removeAllAssignedItems _unit;
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;

	comment "Add containers";
	_unit forceAddUniform "rhs_uniform_df15";
	_unit addItemToUniform "FirstAidKit";
	_unit addItemToUniform "SmokeShell";
	for "_i" from 1 to 2 do {_unit addItemToUniform "rhs_30Rnd_545x39_7N6M_AK";};
	_unit addVest "rhs_6b23_digi";
	_unit addItemToVest "FirstAidKit";
	for "_i" from 1 to 3 do {_unit addItemToVest "SmokeShell";};
	_unit addHeadgear "rhs_zsh7a_mike_alt";

	comment "Add weapons";
	_unit addWeapon "rhs_weap_aks74u";
	_unit addWeapon "Binocular";

	comment "Add items";
	_unit linkItem "ItemMap";
	_unit linkItem "ItemCompass";
	_unit linkItem "ItemWatch";
	_unit linkItem "ItemRadio";
	_unit linkItem "ItemGPS";
	_unit linkItem "rhs_1PN138";


};

SAC_GEAR_fnc_applyLoadoutHeliPilot_NATO = {

	params ["_unit"];
	
	comment "Exported from Arsenal by Sebastian";

	comment "Remove existing items";
	removeAllWeapons _unit;
	removeAllItems _unit;
	removeAllAssignedItems _unit;
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;

	comment "Add containers";
	if (SAC_75TH) then {
	
		_unit forceAddUniform "USAF_Overalls_Ranger_2_w";
		_unit addVest "G_PACA_Ranger_v1_1";
		
	} else {
	
		_unit forceAddUniform "U_B_HeliPilotCoveralls";
		_unit addVest "V_TacVest_oli";
	
	};
	
	_unit addItemToUniform "FirstAidKit";
	_unit addItemToVest "FirstAidKit";
	for "_i" from 1 to 4 do {_unit addItemToVest "SmokeShell";};
	for "_i" from 1 to 6 do {_unit addItemToVest "30Rnd_45ACP_Mag_SMG_01";};
	_unit addBackpack "B_AssaultPack_rgr";
	for "_i" from 1 to 4 do {_unit addItemToBackpack "SmokeShell";};
	
	if (SAC_RHS) then {
	
		_unit addHeadgear "rhsusf_hgu56p_visor";
		
	} else {
	
		_unit addHeadgear "H_PilotHelmetHeli_B";
		
	};

	comment "Add weapons";
	_unit addWeapon "SMG_01_F";
	_unit addPrimaryWeaponItem "muzzle_snds_acp";
	_unit addPrimaryWeaponItem "optic_Aco";

	comment "Add items";
	_unit linkItem "ItemMap";
	_unit linkItem "ItemCompass";
	_unit linkItem "ItemWatch";
	_unit linkItem "ItemRadio";
	_unit linkItem "ItemGPS";
	_unit linkItem "NVGoggles_OPFOR";

	[_unit,"TFAegis"] call bis_fnc_setUnitInsignia;


};

SAC_GEAR_fnc_applyLoadoutHeliPilot_CSAT = {

	params ["_unit"];
	
	comment "Exported from Arsenal by Sebastian";

	comment "Remove existing items";
	removeAllWeapons _unit;
	removeAllItems _unit;
	removeAllAssignedItems _unit;
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;

	comment "Add containers";
	_unit forceAddUniform "U_O_PilotCoveralls";
	_unit addItemToUniform "FirstAidKit";
	_unit addVest "V_HarnessO_brn";
	_unit addItemToVest "FirstAidKit";
	for "_i" from 1 to 4 do {_unit addItemToVest "SmokeShell";};
	for "_i" from 1 to 6 do {_unit addItemToVest "30Rnd_9x21_Mag_SMG_02";};
	_unit addBackpack "B_FieldPack_khk";
	for "_i" from 1 to 4 do {_unit addItemToBackpack "SmokeShell";};
	_unit addHeadgear "H_PilotHelmetHeli_O";

	comment "Add weapons";
	_unit addWeapon "SMG_02_F";
	_unit addPrimaryWeaponItem "muzzle_snds_L";
	_unit addPrimaryWeaponItem "optic_ACO_grn";

	comment "Add items";
	_unit linkItem "ItemMap";
	_unit linkItem "ItemCompass";
	_unit linkItem "ItemWatch";
	_unit linkItem "ItemRadio";
	_unit linkItem "ItemGPS";
	_unit linkItem "NVGoggles_OPFOR";

	comment "Set identity";
	_unit setFace "asczHead_neumann_A3";
	_unit setSpeaker "male03eng";
	[_unit,"GryffinRegiment"] call bis_fnc_setUnitInsignia;



};

SAC_GEAR_fnc_giveMEDICAL = {

	params ["_unit"];

	private _added = [_unit, "FirstAidKit", 6] call SAC_fnc_addItems;
	
	if (_added == 0) then {false} else {true}; //devuelve false si no se agrego un minimo aceptable

};

SAC_GEAR_fnc_giveSMOKE = {

	params ["_unit", "_count"];

	private _added = [_unit, "SmokeShell", _count] call SAC_fnc_addMagazines;

	_added //devuelve la cantidad agregada
	
};

SAC_GEAR_fnc_giveFRAGS = {

	params ["_unit"];

	[_unit, "HandGrenade", 4] call SAC_fnc_addMagazines;
	//[_unit, "MiniGrenade", 4] call SAC_fnc_addMagazines;
	
	//no devuelvo nada porque si no entran no justifico una mochila

};

SAC_GEAR_fnc_giveMK20 = {

	params ["_unit", "_silencer"];

	[_unit, "30Rnd_556x45_Stanag", 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom SAC_GEAR_MK20s);
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_MK20_sil;
		_unit addPrimaryWeaponItem (selectRandom ["optic_MRCO"]);
	} else {
		_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn", "optic_MRCO"]);
	};
	_unit addPrimaryWeaponItem SAC_GEAR_MK20_pointerIR;

};

SAC_GEAR_fnc_giveMK20GL = {

	params ["_unit", "_silencer"];

	[_unit, "30Rnd_556x45_Stanag", 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;
	
	_unit addWeapon SAC_GEAR_MK20GL;
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_MK20_sil;
		_unit addPrimaryWeaponItem (selectRandom ["optic_MRCO"]);
	} else {
		_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn", "optic_MRCO"]);
	};
	_unit addPrimaryWeaponItem SAC_GEAR_MK20_pointerIR;

};

SAC_GEAR_fnc_giveMP5 = {

	params ["_unit", "_silencer"];

	[_unit, "30Rnd_9x21_Mag_SMG_02", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "SMG_05_F";
	if (_silencer) then {
		_unit addPrimaryWeaponItem "muzzle_snds_L";
		_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn_smg", "optic_Holosight_smg"]);
	};

};

SAC_GEAR_fnc_giveVermin = {

	params ["_unit", "_silencer"];

	[_unit, "30Rnd_45ACP_Mag_SMG_01", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "SMG_01_F";
	if (_silencer) then {
		_unit addPrimaryWeaponItem "muzzle_snds_acp";
		_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn_smg", "optic_Holosight_smg"]);
	};

};

SAC_GEAR_fnc_giveSTING = {

	params ["_unit", "_silencer"];

	[_unit, "30Rnd_9x21_Mag_SMG_02", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "SMG_02_F";
	if (_silencer) then {
		_unit addPrimaryWeaponItem "muzzle_snds_L";
		_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn_smg", "optic_Holosight_smg"]);
	};

};

SAC_GEAR_fnc_give4five_45ACP = {

	params ["_unit", "_silencer"];

	[_unit, "11Rnd_45ACP_Mag", 3] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_4five_45ACP;
	if (_silencer) then {
		_unit addHandgunItem SAC_GEAR_4five_45ACP_sil;
		_unit addHandgunItem SAC_GEAR_4five_45ACP_scope;
	};
};

SAC_GEAR_fnc_giveACP_C2_45ACP = {

	params ["_unit", "_silencer"];

	[_unit, "9Rnd_45ACP_Mag", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "hgun_ACPC2_F";
	if (_silencer) then {_unit addHandgunItem "muzzle_snds_acp"};
};

SAC_GEAR_fnc_giveP07_9mm = {

	params ["_unit", "_silencer"];

	[_unit, "16Rnd_9x21_Mag", 3] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_P07;
	if (_silencer) then {_unit addHandgunItem "muzzle_snds_L"};
};

SAC_GEAR_fnc_giveROOK40_9mm = {

	params ["_unit", "_silencer"];

	[_unit, "16Rnd_9x21_Mag", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "hgun_Rook40_F";
	if (_silencer) then {_unit addHandgunItem "muzzle_snds_L"};
};

SAC_GEAR_fnc_giveRHS_glock17_9mm = {

	params ["_unit", "_silencer"];

	[_unit, "rhsusf_mag_17Rnd_9x19_JHP", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "rhsusf_weap_glock17g4";
	if (_silencer) then {_unit addHandgunItem "rhsusf_acc_omega9k"};
};

SAC_GEAR_fnc_giveRHS_1911_45 = {

	params ["_unit"];

	[_unit, "rhsusf_mag_7x45acp_MHP", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "rhsusf_weap_m1911a1";
};

SAC_GEAR_fnc_giveRHS_m9beretta_9mm = {

	params ["_unit"];

	[_unit, "rhsusf_mag_15Rnd_9x19_JHP", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "rhsusf_weap_m9";
};

SAC_GEAR_fnc_giveMX = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_MX_mag, 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom SAC_GEAR_MXs);
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_MX_sil;
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_optics_sof);
		//if (random 1 < 0.45) then {_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod};
	} else {
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_optics_regular);
	};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_irs);

};

SAC_GEAR_fnc_giveBIS_AK12 = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_AK12_mag, 8] call SAC_fnc_addMagazines;

	_unit addWeapon selectRandom SAC_GEAR_AK12s;
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_AK12_optics);
	_unit addPrimaryWeaponItem "acc_pointer_IR";
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_AK12_sil;
	};

};

SAC_GEAR_fnc_giveBIS_AK12_GL = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_AK12_mag, 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;

	_unit addWeapon selectRandom SAC_GEAR_AK12GL;
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_AK12_optics);
	_unit addPrimaryWeaponItem "acc_pointer_IR";
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_AK12_sil;
	};

};

SAC_GEAR_fnc_giveBIS_AK12_MM = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_AK12_mag, 8] call SAC_fnc_addMagazines;

	_unit addWeapon selectRandom SAC_GEAR_AK12s;
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_AK12_MM_optics);
	_unit addPrimaryWeaponItem "acc_pointer_IR";
	_unit addPrimaryWeaponItem SAC_GEAR_AK12_bipod;
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_AK12_sil;
	};

};

SAC_GEAR_fnc_giveBIS_AK12_AR = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_AK12_AR_mag, 8] call SAC_fnc_addMagazines;

	_unit addWeapon selectRandom SAC_GEAR_AK12s;
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_AK12_optics);
	_unit addPrimaryWeaponItem "acc_pointer_IR";
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_AK12_sil;
	};

};

SAC_GEAR_fnc_giveRHS_AKS74N_NPZ = {

	params ["_unit", "_silencer"];

	[_unit, selectRandom ["rhs_30Rnd_545x39_7N6M_AK", "rhs_30Rnd_545x39_7N10_2mag_plum_AK", "rhs_30Rnd_545x39_7N10_2mag_AK",
	"rhs_30Rnd_545x39_7N10_plum_AK", "rhs_30Rnd_545x39_7N10_2mag_camo_AK"], 8] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_aks74n_2_npz";
	if (_silencer) then {
		_unit addPrimaryWeaponItem "rhs_acc_dtk4short";
	};
	_unit addPrimaryWeaponItem "rhsusf_acc_su230";
	_unit addPrimaryWeaponItem "rhs_acc_perst1ik";

};

SAC_GEAR_fnc_giveRHS_AKS74N_NPZ_holo = {

	params ["_unit", "_silencer"];

	[_unit, selectRandom ["rhs_30Rnd_545x39_7N6M_AK", "rhs_30Rnd_545x39_7N10_2mag_plum_AK", "rhs_30Rnd_545x39_7N10_2mag_AK",
	"rhs_30Rnd_545x39_7N10_plum_AK", "rhs_30Rnd_545x39_7N10_2mag_camo_AK"], 8] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_aks74n_2_npz";
	if (_silencer) then {
		_unit addPrimaryWeaponItem "rhs_acc_dtk4short";
	};
	_unit addPrimaryWeaponItem "rhs_acc_ekp8_18";
	_unit addPrimaryWeaponItem "rhs_acc_perst1ik";

};

SAC_GEAR_fnc_giveRHS_AKS74N_NPZ_GP25 = {

	params ["_unit", "_silencer"];

	[_unit, selectRandom ["rhs_30Rnd_545x39_7N6M_AK", "rhs_30Rnd_545x39_7N10_2mag_plum_AK", "rhs_30Rnd_545x39_7N10_2mag_AK",
	"rhs_30Rnd_545x39_7N10_plum_AK", "rhs_30Rnd_545x39_7N10_2mag_camo_AK"], 8] call SAC_fnc_addMagazines;
	[_unit, "rhs_VOG25", 8] call SAC_fnc_addMagazines;
	
	_unit addWeapon "rhs_weap_aks74n_gp25_npz";
	if (_silencer) then {
		_unit addPrimaryWeaponItem "rhs_acc_dtk4short";
	};
	_unit addPrimaryWeaponItem "rhsusf_acc_su230";
	_unit addPrimaryWeaponItem "rhs_acc_perst1ik";

};

SAC_GEAR_fnc_giveRHS_SVDS_NPZ = {

	params ["_unit", "_silencer"];

	[_unit, "rhs_10Rnd_762x54mmR_7N14", 8] call SAC_fnc_addMagazines;
	
	_unit addWeapon selectRandom ["rhs_weap_svds_npz", "rhs_weap_svdp_wd_npz"];
	if (_silencer) then {
		_unit addPrimaryWeaponItem "rhs_acc_tgpv";
	};
	_unit addPrimaryWeaponItem "rhs_acc_dh520x56";

};

SAC_GEAR_fnc_giveRHS_AK74M_Zenitco_45rnd = {

	params ["_unit", "_silencer"];

	[_unit, "rhs_45Rnd_545X39_7N10_AK", 12] call SAC_fnc_addMagazines;
	
	_unit addWeapon "rhs_weap_ak74m_zenitco01_b33";
	if (_silencer) then {
		_unit addPrimaryWeaponItem "rhs_acc_tgpa";
	};
	_unit addPrimaryWeaponItem "optic_Arco_blk_F";
	_unit addPrimaryWeaponItem selectRandom ["rhs_acc_perst3", "rhs_acc_perst3_2dp_h", "rhs_acc_perst3_top"];

};

SAC_GEAR_fnc_giveRHS_AK74M_zenitco_b33 = {

	params ["_unit", "_silencer"];

	[_unit, "rhs_30Rnd_545x39_7N22_camo_AK", 12] call SAC_fnc_addMagazines;
	
	_unit addWeapon "rhs_weap_ak74m_zenitco01_b33";
	if (_silencer) then {
		_unit addPrimaryWeaponItem "rhs_acc_dtk4short";
	};
	_unit addPrimaryWeaponItem "optic_Arco_blk_F";
	_unit addPrimaryWeaponItem selectRandom ["rhs_acc_perst3", "rhs_acc_perst3_2dp_h", "rhs_acc_perst3_top"];

};

SAC_GEAR_fnc_giveRHS_AK74M_GP25 = {

	params ["_unit", "_silencer"];

	[_unit, "rhs_30Rnd_545x39_7N22_camo_AK", 12] call SAC_fnc_addMagazines;
	[_unit, "rhs_VOG25", 8] call SAC_fnc_addMagazines;
	
	_unit addWeapon "rhs_weap_ak74mr_gp25";
	if (_silencer) then {
		_unit addPrimaryWeaponItem "rhs_acc_dtk4short";
	};
	_unit addPrimaryWeaponItem "optic_Holosight_blk_F";
	_unit addPrimaryWeaponItem selectRandom ["rhs_acc_perst3", "rhs_acc_perst3_2dp_h", "rhs_acc_perst3_top"];

};

SAC_GEAR_fnc_giveKATIBA = {

	params ["_unit", "_silencer"];

	[_unit, "30Rnd_65x39_caseless_green", 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom ["arifle_Katiba_F", "arifle_Katiba_C_F"]);
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_KATIBA_sil;
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_KATIBA_optics_sof);
	} else {
		_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn", "optic_Hamr"]);
	};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_KATIBA_irs);

};

SAC_GEAR_fnc_giveAK12 = {

	params ["_unit"];

	[_unit, "30Rnd_762x39_Mag_F", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "arifle_AK12_F";

};

SAC_GEAR_fnc_giveAK12GL = {

	params ["_unit"];

	[_unit, "30Rnd_762x39_Mag_F", 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "arifle_AK12_GL_F";

};

SAC_GEAR_fnc_giveCAR95 = { //no soporta bípodes, y sólo los silenciadores de BIS de 5.8mm

	params ["_unit", "_silencer"];

	[_unit, "30Rnd_580x42_Mag_F", 8] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_car95;
	
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_car95_sil;
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_car95_optics_sof);
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_irs);
	} else {
	
		_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn", "optic_MRCO"]);
	
	};

};

SAC_GEAR_fnc_giveCAR95GL = {

	params ["_unit", "_silencer"];

	[_unit, "30Rnd_580x42_Mag_F", 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;
	
	_unit addWeapon SAC_GEAR_car95_gl;
	
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_car95_sil;
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_car95_optics_sof);
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_irs);
	} else {
	
		_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn", "optic_MRCO"]);
	
	};

};

SAC_GEAR_fnc_giveCAR95_mg = {

	params ["_unit", "_silencer"];

	[_unit, "100Rnd_580x42_Mag_F", 4] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_car95_mg;
	
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_car95_sil;
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_car95_optics_sof);
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_irs);
	} else {
	
		_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn", "optic_MRCO"]);
	
	};

};

SAC_GEAR_fnc_giveCMR76 = { //no soporta bípode (lo trae incorporado)

	params ["_unit", "_silencer"];

	[_unit, "20Rnd_650x39_Cased_Mag_F", 8] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_cmr76;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_MX_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MK18EBR_optics);

};

SAC_GEAR_fnc_giveMXGL = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_MX_mag, 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_MXGL;
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_MX_sil;
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_optics_sof);
	} else {
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_optics_regular);
	};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_irs);
	
};

SAC_GEAR_fnc_giveKATIBAGL = {

	params ["_unit", "_silencer"];

	[_unit, "30Rnd_65x39_caseless_green", 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "arifle_Katiba_GL_F";
	if (_silencer) then {
		_unit addPrimaryWeaponItem SAC_GEAR_KATIBA_sil;
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_KATIBA_optics_sof);
	} else {
		_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn", "optic_Hamr"]);
	};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_KATIBA_irs);
	
};

SAC_GEAR_fnc_giveMXM = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_MX_mag, 8] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_MXM;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_MX_sil};
	_unit addPrimaryWeaponItem SAC_GEAR_MXM_optic;
	_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod;
	
};

SAC_GEAR_fnc_giveMXSW = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_MXSW_mag, 4] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_MXSW;
	if (_silencer) then {
		_unit addPrimaryWeaponItem "muzzle_snds_H";
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_optics_sof);
	} else {
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_optics_regular);
	};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_irs);
	_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod;
};

SAC_GEAR_fnc_giveMKI = {

	params ["_unit", "_silencer"];

	[_unit, "20Rnd_762x51_Mag", 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom SAC_GEAR_MKIs);
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_MKI_sil};
	_unit addPrimaryWeaponItem SAC_GEAR_MKI_optic;
	_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod;
	
};

SAC_GEAR_fnc_giveMK18EBR = {

	params ["_unit", "_silencer"];

	[_unit, "20Rnd_762x51_Mag", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "srifle_EBR_F";
	if (_silencer) then {_unit addPrimaryWeaponItem "muzzle_snds_B"};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MK18EBR_optics);
	_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod;
	
};

SAC_GEAR_fnc_giveMK14 = {

	params ["_unit", "_silencer"];

	[_unit, "20Rnd_762x51_Mag", 8] call SAC_fnc_addMagazines;

	if (_silencer) then {
	
		_unit addWeapon (selectRandom ["srifle_DMR_06_camo_F", "srifle_DMR_06_olive_F"]);
		_unit addPrimaryWeaponItem "muzzle_snds_B";
		_unit addPrimaryWeaponItem "optic_KHS_blk";
		_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod;
		
	} else {
	
		_unit addWeapon "srifle_DMR_06_olive_F";
		_unit addPrimaryWeaponItem "optic_KHS_old";
	};

};


SAC_GEAR_fnc_giveMK200 = {

	params ["_unit", "_silencer", "_scopes"];

	[_unit, SAC_GEAR_MK200_mag, 3] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_MK200;
	
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_MK200_sil};
	if (_scopes) then {
	
		_unit addPrimaryWeaponItem SAC_GEAR_MK200_ir;
		_unit addPrimaryWeaponItem SAC_GEAR_MK200_optic;

	};

};

SAC_GEAR_fnc_giveUC_MK200_RHS = {

	params ["_unit", "_silencer"];

	[_unit, "200Rnd_65x39_cased_Box", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "LMG_Mk200_F";
	_unit addPrimaryWeaponItem "rhsusf_acc_su230";
	if (random 1 < 0.65) then {_unit addPrimaryWeaponItem "rhs_acc_harris_swivel"};
	if (random 1 < 0.65) then {_unit addPrimaryWeaponItem "rhsusf_acc_M952V"};
	if (_silencer) then {
		_unit addPrimaryWeaponItem "muzzle_snds_H_MG_blk_F";
	};

};

SAC_GEAR_fnc_giveZAFIR = { //no soporta silenciador ni bípode (al bípode lo trae)

	params ["_unit", "_silencer"];

	[_unit, "150Rnd_762x54_Box", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "LMG_Zafir_F";

	if (_silencer) then {
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_KATIBA_optics_sof);
	} else {
		_unit addPrimaryWeaponItem "optic_ACO_grn";
	};

};

SAC_GEAR_fnc_giveZAFIR_GUER = {

	params ["_unit"];

	[_unit, "150Rnd_762x54_Box", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "LMG_Zafir_F";

};

SAC_GEAR_fnc_giveBIS_RPK = {

	params ["_unit"];

	[_unit, "75rnd_762x39_AK12_Mag_F", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "arifle_RPK12_F";

};

SAC_GEAR_fnc_giveLIM85 = { //BIS M249

	params ["_unit", "_silencer", "_scopes"];

	[_unit, "200Rnd_556x45_Box_F", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "LMG_03_F";
	
	if (_silencer) then {_unit addPrimaryWeaponItem "muzzle_snds_H_MG_blk_F"};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_BIS_LIM85_irs);
	if (_scopes) then {
	
		if (_silencer) then {
			_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_BIS_LIM85_optics_sof);
		} else {
			_unit addPrimaryWeaponItem "optic_Holosight_blk_F";
		};
	};

};

SAC_GEAR_fnc_giveRHS_M249 = {

	params ["_unit", "_silencer", "_scopes"];

	[_unit, "rhsusf_200rnd_556x45_M855_mixed_box", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_m249_pip_S";
	
	if (_silencer) then {_unit addPrimaryWeaponItem "rhsusf_acc_nt4_black"};
	if (_scopes) then {_unit addPrimaryWeaponItem "rhsusf_acc_ACOG2_USMC"}; //AN/PVQ-31A

};

SAC_GEAR_fnc_givePCML = {

	params ["_unit"];

	[_unit, "NLAW_F", 2] call SAC_fnc_addMagazines;

	_unit addWeapon "launch_NLAW_F";

};

SAC_GEAR_fnc_giveTITAN_at = {

	params ["_unit"];

	[_unit, "Titan_AT", 1] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_TITAN_at;

};

SAC_GEAR_fnc_giveTITAN_aa = {

	params ["_unit"];

	[_unit, "Titan_AA", 1] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_TITAN_aa;

};

SAC_GEAR_fnc_giveRHS_LAW = {

	params ["_unit"];

	[_unit, "rhs_m72a7_mag", 1] call SAC_fnc_addMagazines;
	_unit addWeapon "rhs_weap_m72a7";

};

SAC_GEAR_fnc_giveRHS_M136AT = {

	params ["_unit"];

	[_unit, "rhs_m136_mag", 1] call SAC_fnc_addMagazines;
	_unit addWeapon "rhs_weap_M136";

};

SAC_GEAR_fnc_giveRHS_RPG45 = {

	params ["_unit"];

	[_unit, "rhs_rpg75_mag", 1] call SAC_fnc_addMagazines;
	_unit addWeapon "rhs_weap_rpg75";

};

SAC_GEAR_fnc_giveRHS_STINGER = {

	params ["_unit"];

	[_unit, "rhs_fim92_mag", 1] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_fim92";

};

SAC_GEAR_fnc_giveRHS_SMAW = {

	params ["_unit"];

	[_unit, "rhs_mag_smaw_HEAA", 2] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_smaw_green";

};

SAC_GEAR_fnc_giveRHS_JAVELIN = {

	params ["_unit"];

	[_unit, "rhs_fgm148_magazine_AT", 2] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_fgm148";

};

SAC_GEAR_fnc_giveSPAR16 = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_SPAR16_mag, 8] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_SPAR16;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_SPAR16_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_SPAR16_irs);
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_SPAR16_optics);
	//if (random 1 < 0.45) then {_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod};
	
};

SAC_GEAR_fnc_giveSPAR16GL = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_SPAR16_mag, 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_SPAR16GL;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_SPAR16_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_SPAR16_irs);
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_SPAR16_optics);
	
};

SAC_GEAR_fnc_giveSPAR16S = { //LMG

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_SPAR16S_mag, 4] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_SPAR16S;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_SPAR16_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_SPAR16_irs);
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_SPAR16_optics);
	_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod;
	
};

SAC_GEAR_fnc_giveSPAR17 = { //dmr

	params ["_unit", "_silencer"];

	[_unit, "20Rnd_762x51_Mag", 8] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_SPAR17;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_SPAR17_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_SPAR17_irs);
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_SPAR17_optics);
	_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod;
	
};

SAC_GEAR_fnc_giveTRG = {

	params ["_unit", "_silencer", "_scopes"];

	[_unit, "30Rnd_556x45_Stanag", 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom ["arifle_TRG20_F", "arifle_TRG21_F"]);
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_SPAR16_sil};
	if (_scopes) then {
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_irs);
		if (_silencer) then {
			_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_optics_sof);
		} else {
			_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn", "optic_MRCO"]);
		};
	};

};

SAC_GEAR_fnc_giveTRGGL = {

	params ["_unit", "_silencer", "_scopes"];

	[_unit, "30Rnd_556x45_Stanag", 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "arifle_TRG21_GL_F";
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_SPAR16_sil};
	if (_scopes) then {
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_irs);
		if (_silencer) then {
			_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_optics_sof);
		} else {
			_unit addPrimaryWeaponItem (selectRandom ["optic_ACO_grn", "optic_MRCO"]);
		};
	};

};

SAC_GEAR_fnc_giveRHS_HK416 = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_RHS_HK416_mag, 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom SAC_GEAR_RHS_HK416);
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_RHS_HK416_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_HK416_irs);
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_HK416_optics);
	//if (random 1 < 0.45) then {_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod};
	
};

SAC_GEAR_fnc_giveRHS_HK416GL = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_RHS_HK416_mag, 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom SAC_GEAR_RHS_HK416GL);
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_RHS_HK416_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_HK416_irs);
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_HK416_optics);
	
};

SAC_GEAR_fnc_giveRHS_IAR = {

	params ["_unit", "_silencer"];

	[_unit, "rhs_mag_30Rnd_556x45_Mk318_Stanag", 12] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_m27iar";
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_RHS_MK18_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_MX_irs);
	if (_silencer) then {
	
		_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_IAR_optics_sof);
	} else {
	
		_unit addPrimaryWeaponItem "rhsusf_acc_ACOG2"; //AN/PVQ-31A
	};
	
	_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod;
	
};

SAC_GEAR_fnc_giveRHS_SR25 = { //Mk11

	params ["_unit", "_silencer"];

	[_unit, "rhsusf_20Rnd_762x51_SR25_m118_special_Mag", 8] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_RHS_SR25;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_RHS_SR25_sil};
	_unit addPrimaryWeaponItem SAC_GEAR_RHS_SR25_optic;
	_unit addPrimaryWeaponItem SAC_GEAR_RHS_SR25_ir;
	_unit addPrimaryWeaponItem SAC_GEAR_RHS_SR25_bipod;
	
};

SAC_GEAR_fnc_giveRHS_MK18 = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_RHS_HK416_mag, 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom SAC_GEAR_RHS_MK18);
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_RHS_MK18_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_MK18_irs);
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_MK18_optics);
	//if (random 1 < 0.45) then {_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod};
	
};

SAC_GEAR_fnc_giveRHS_MK18GL = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_RHS_HK416_mag, 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;
	
	_unit addWeapon SAC_GEAR_RHS_MK18_GL;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_RHS_MK18_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_MK18_irs);
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_MK18_optics);
	
};

SAC_GEAR_fnc_giveRHS_M4A1blockII = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_RHS_HK416_mag, 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom SAC_GEAR_M4A1blockII);
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_RHS_MK18_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_MK18_irs);
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_MK18_optics);
	//if (random 1 < 0.45) then {_unit addPrimaryWeaponItem SAC_GEAR_bis_bipod};
	
};

SAC_GEAR_fnc_giveRHS_M4A1blockIIGL = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_RHS_HK416_mag, 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;

	_unit addWeapon SAC_GEAR_M4A1blockIIGL;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_RHS_MK18_sil};
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_MK18_irs);
	_unit addPrimaryWeaponItem (selectRandom SAC_GEAR_RHS_MK18_optics);
	
};

SAC_GEAR_fnc_giveRHS_M4A1_PIP = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_RHS_M4A1_PIP_mag, 8] call SAC_fnc_addMagazines;

	_unit addWeapon selectRandom SAC_GEAR_RHS_M4A1_PIP;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_RHS_M4A1_PIP_sil};
	_unit addPrimaryWeaponItem selectRandom SAC_GEAR_RHS_M4A1_PIP_irs;
	_unit addPrimaryWeaponItem selectRandom SAC_GEAR_RHS_M4A1_PIP_optics;
	
};

SAC_GEAR_fnc_giveRHS_M4A1_PIP_GL = {

	params ["_unit", "_silencer"];

	[_unit, SAC_GEAR_RHS_M4A1_PIP_mag, 8] call SAC_fnc_addMagazines;
	[_unit, "1Rnd_HE_Grenade_shell", 8] call SAC_fnc_addMagazines;

	_unit addWeapon selectRandom SAC_GEAR_RHS_M4A1_PIP_M203;
	if (_silencer) then {_unit addPrimaryWeaponItem SAC_GEAR_RHS_M4A1_PIP_sil};
	_unit addPrimaryWeaponItem "rhsusf_acc_anpeq15side_bk";
	_unit addPrimaryWeaponItem selectRandom SAC_GEAR_RHS_M4A1_PIP_optics;
	
};

SAC_GEAR_fnc_giveRHS_M240B = {

	params ["_unit"];

	[_unit, "rhsusf_50Rnd_762x51", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_m240B_CAP";
	_unit addPrimaryWeaponItem "rhsusf_acc_ELCAN_ard";

};

//*****************************************************
/*
SAC_GEAR_fnc_giveCUP_AK47 = {

	params ["_unit"];

	[_unit, "CUP_30Rnd_762x39_AK47_M", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_arifle_AK47";

};
*/

SAC_GEAR_fnc_giveCUP_RPK74 = {

	params ["_unit"];

	[_unit, "CUP_75Rnd_TE4_LRT4_Green_Tracer_762x39_RPK_M", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_arifle_RPK74";

};

/*
SAC_GEAR_fnc_giveCUP_PKM = {

	params ["_unit"];

	[_unit, "CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_lmg_PKM";

};

*/

SAC_GEAR_fnc_giveRHS_svds = {

	params ["_unit"];

	[_unit, "rhs_10Rnd_762x54mmR_7N1", 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom ["rhs_weap_svds", "rhs_weap_svdp_wd"]);
	_unit addPrimaryWeaponItem "rhs_acc_pso1m2";
	
};

SAC_GEAR_fnc_giveRHS_AK74M = {

	params ["_unit", "_silencer"];

	[_unit, "rhs_30Rnd_545x39_AK", 8] call SAC_fnc_addMagazines;

	if (_silencer) then {
		_unit addWeapon (selectRandom ["rhs_weap_ak74m_zenitco01_b33", "rhs_weap_ak74m_fullplum_npz", "rhs_weap_ak74m_plummag_npz",
		"rhs_weap_ak74m_npz", "rhs_weap_ak74m_camo_npz", "rhs_weap_ak74m_2mag_npz"]);
		_unit addPrimaryWeaponItem "rhs_acc_dtk4short";
		_unit addPrimaryWeaponItem "rhs_acc_perst1ik";
		_unit addPrimaryWeaponItem "rhsusf_acc_SpecterDR";
	} else {
		_unit addWeapon (selectRandom SAC_GEAR_rhs_rifles_ak74m);
		_unit addPrimaryWeaponItem "rhs_acc_dtk1";
	};
};

SAC_GEAR_fnc_giveRHS_AK74M_gl = {

	params ["_unit", "_silencer"];

	[_unit, "rhs_30Rnd_545x39_AK", 8] call SAC_fnc_addMagazines;
	[_unit, "rhs_VOG25", 8] call SAC_fnc_addMagazines;

	if (_silencer) then {
		_unit addWeapon (selectRandom ["rhs_weap_ak74m_fullplum_gp25_npz", "rhs_weap_ak74m_gp25_npz"]);
		_unit addPrimaryWeaponItem "rhs_acc_dtk4short";
		_unit addPrimaryWeaponItem "rhs_acc_perst1ik";
		_unit addPrimaryWeaponItem "rhsusf_acc_SpecterDR";
	} else {
		_unit addWeapon (selectRandom SAC_GEAR_rhs_rifles_ak74m_gl);
		_unit addPrimaryWeaponItem "rhs_acc_dtk1";
	};

};

SAC_GEAR_fnc_giveBIS_AKM = {

	params ["_unit"];

	[_unit, "30Rnd_762x39_Mag_F", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "arifle_AKM_F";

};

SAC_GEAR_fnc_giveBIS_AKU = {

	params ["_unit"];

	[_unit, "30Rnd_545x39_Mag_F", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "arifle_AKS_F";

};

SAC_GEAR_fnc_giveCUP_AK47_early = {

	params ["_unit"];

	[_unit, "CUP_30Rnd_762x39_AK47_M", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_arifle_AK47_Early";

};

SAC_GEAR_fnc_giveCUP_mosin_nagant = {

	params ["_unit"];

	[_unit, "CUP_5Rnd_762x54_Mosin_M", 13] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_srifle_Mosin_Nagant";
	_unit addPrimaryWeaponItem "CUP_optic_PEM_pip";

};

SAC_GEAR_fnc_giveCUP_mosin_nagant_noscope = {

	params ["_unit"];

	[_unit, "CUP_5Rnd_762x54_Mosin_M", 13] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_srifle_Mosin_Nagant";

};

SAC_GEAR_fnc_giveCUP_lee_enfield = {

	params ["_unit"];

	[_unit, "CUP_10x_303_M", 9] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_srifle_LeeEnfield";

};

SAC_GEAR_fnc_giveCUP_TYPE52_2_early = {

	params ["_unit"];

	[_unit, "CUP_30Rnd_762x39_AK47_bakelite_M", 7] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_arifle_TYPE_56_2_Early";

};

SAC_GEAR_fnc_giveCUP_UK59 = {

	params ["_unit"];

	[_unit, "CUP_50Rnd_UK59_762x54R_Tracer", 7] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_lmg_UK59";

};

SAC_GEAR_fnc_giveRHS_AKM = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_762x39mm", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_akm";

};

SAC_GEAR_fnc_giveRHS_AKMGL = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_762x39mm", 8] call SAC_fnc_addMagazines;
	[_unit, "rhs_VOG25", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_akm_gp25";

};

SAC_GEAR_fnc_giveRHS_AKMS = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_762x39mm", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_akms";

};

SAC_GEAR_fnc_giveRHS_AKMSGL = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_762x39mm", 8] call SAC_fnc_addMagazines;
	[_unit, "rhs_VOG25", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_akms_gp25";

};

SAC_GEAR_fnc_giveRHS_AKS74 = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_545x39_AK", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_aks74";
	_unit addPrimaryWeaponItem "rhs_acc_dtk1983";

};

SAC_GEAR_fnc_giveRHS_AKS74GL = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_545x39_AK", 8] call SAC_fnc_addMagazines;
	[_unit, "rhs_VOG25", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_aks74_gp25";
	_unit addPrimaryWeaponItem "rhs_acc_dtk1983";

};

SAC_GEAR_fnc_giveRHS_AKS74n = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_545x39_AK", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_aks74n";
	_unit addPrimaryWeaponItem "rhs_acc_dtk1983";

};

SAC_GEAR_fnc_giveRHS_AKS74nGL = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_545x39_AK", 8] call SAC_fnc_addMagazines;
	[_unit, "rhs_VOG25", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_aks74n_gp25";
	_unit addPrimaryWeaponItem "rhs_acc_dtk1983";

};

SAC_GEAR_fnc_giveRHS_PKM = {

	params ["_unit"];

	[_unit, "rhs_100Rnd_762x54mmR", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_pkm";

};

SAC_GEAR_fnc_giveRHS_PKP = {

	params ["_unit"];

	[_unit, "rhs_100Rnd_762x54mmR", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_pkp";
	_unit addPrimaryWeaponItem "rhs_acc_1p29";

};

SAC_GEAR_fnc_giveRHS_m84 = { //pk servia

	params ["_unit"];

	[_unit, "rhs_100Rnd_762x54mmR", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_m84";

};

SAC_GEAR_fnc_giveRHS_m21 = {

	params ["_unit", "_silencer"];

	[_unit, "rhsgref_30rnd_556x45_m21", 8] call SAC_fnc_addMagazines;

	if (_silencer) then {
	
		_unit addWeapon "rhs_weap_m21s_pr";
		_unit addPrimaryWeaponItem "rhsusf_acc_nt4_black";
		_unit addPrimaryWeaponItem "rhsusf_acc_SpecterDR";
		
	} else {
	
		_unit addWeapon "rhs_weap_m21s";
	
	};

};

SAC_GEAR_fnc_giveRHS_m21_gl = {

	params ["_unit", "_silencer"];

	[_unit, "rhsgref_30rnd_556x45_m21", 8] call SAC_fnc_addMagazines;
	[_unit, "rhs_VOG25", 4] call SAC_fnc_addMagazines;

	if (_silencer) then {
	
		_unit addWeapon "rhs_weap_m21a_pr_pbg40";
		_unit addPrimaryWeaponItem "rhsusf_acc_nt4_black";
		_unit addPrimaryWeaponItem "rhsusf_acc_SpecterDR";
		
	} else {
	
		_unit addWeapon "rhs_weap_m21a_pbg40";
	
	};
	
};

SAC_GEAR_fnc_giveRHS_minimi_para = {

	params ["_unit", "_silencer"];

	[_unit, "rhs_200rnd_556x45_M_SAW", 4] call SAC_fnc_addMagazines;

	if (_silencer) then {
	
		_unit addWeapon "rhs_weap_minimi_para_railed";
		_unit addPrimaryWeaponItem "rhsusf_acc_nt4_black";
		_unit addPrimaryWeaponItem "rhsusf_acc_ACOG_MDO"; //SU-260/P(MDO)
		
	} else {
	
		_unit addWeapon "rhs_weap_minimi_para_railed";
	
	};

};

SAC_GEAR_fnc_giveRHS_m70 = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_762x39mm", 8] call SAC_fnc_addMagazines;

	_unit addWeapon (selectRandom ["rhs_weap_m70ab2", "rhs_weap_m70b1"]);
	
};

SAC_GEAR_fnc_giveRHS_m70gl = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_762x39mm", 8] call SAC_fnc_addMagazines;
	[_unit, "rhs_VOG25", 4] call SAC_fnc_addMagazines;
	
	_unit addWeapon "rhs_weap_m70b3n_pbg40";
	
};

SAC_GEAR_fnc_giveRHS_m76 = { //dmr

	params ["_unit"];

	[_unit, "rhsgref_10Rnd_792x57_m76", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_m76";
	_unit addPrimaryWeaponItem "rhs_acc_pso1m2";
	
};

SAC_GEAR_fnc_giveRPG7 = {

	params ["_unit"];

	[_unit, "RPG7_F", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "launch_RPG7_F";

};
/*
	SAC_GEAR_fnc_giveRandomMilitiaRifle = {

		params ["_unit"];

		switch (selectRandom [1,2,3,4,5,6,7,8, 9]) do {

			case 1: {[_unit] call SAC_GEAR_fnc_giveCUP_AK47};
			case 2: {[_unit] call SAC_GEAR_fnc_giveRHS_AK74M};
			case 3: {[_unit] call SAC_GEAR_fnc_giveRHS_AKM};
			case 4: {[_unit] call SAC_GEAR_fnc_giveRHS_AKMS};
			case 5: {[_unit] call SAC_GEAR_fnc_giveRHS_M92FOLDED};
			case 6: {[_unit] call SAC_GEAR_fnc_giveRHS_M92};
			case 7: {[_unit] call SAC_GEAR_fnc_giveRHS_M70AB2};
			case 8: {[_unit] call SAC_GEAR_fnc_giveRHS_M70FOLDED};
			case 9: {[_unit] call SAC_GEAR_fnc_giveRHS_M70B1};

		};
	};

	SAC_GEAR_fnc_giveRandomMilitiaRifleGL = {

		params ["_unit"];

		switch (selectRandom [1,2]) do {

			case 1: {[_unit] call SAC_GEAR_fnc_giveRHS_AKMGL};
			case 2: {[_unit] call SAC_GEAR_fnc_giveRHS_AKMSGL};

		};
	};
*/

	// --------------------------------------------
	// MANU
	// --------------------------------------------

SAC_GEAR_fnc_manu_giveMosinNagantSOV = {

	params ["_unit"];

	[_unit, "NORTH_5Rnd_m39_tracer_mag", 5] call SAC_fnc_addMagazines;
	[_unit, "NORTH_5Rnd_m39_mag", 5] call SAC_fnc_addMagazines;

	_unit addWeapon "NORTH_sov_M9130";
	
};

SAC_GEAR_fnc_manu_giveSvtSOV = {

	params ["_unit"];

	[_unit, "NORTH_10rnd_SVT_mag", 5] call SAC_fnc_addMagazines;

	_unit addWeapon "NORTH_SVT40";
	
};

SAC_GEAR_fnc_manu_givePpsh41SOV = {

	params ["_unit","_type"];

	if (_type < 2) then {
		[_unit, "NORTH_71rnd_ppsh41_mag", 5] call SAC_fnc_addMagazines;
	} else {
		[_unit, "NORTH_35rnd_ppsh41_mag", 8] call SAC_fnc_addMagazines;
	};
	
	_unit addWeapon "NORTH_ppsh41";
	
};

SAC_GEAR_fnc_manu_givePpsh43 = {

	params ["_unit"];

	[_unit, "NORTH_35rnd_pps43_mag", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "NORTH_PPS43";
	
};

SAC_GEAR_fnc_manu_givePpd34 = {

	params ["_unit"];

	[_unit, "NORTH_34rnd_PPD_mag", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "NORTH_PPD34";
	
};

SAC_GEAR_fnc_manu_giveDp27 = {

	params ["_unit"];

	[_unit, "NORTH_47rnd_dp27_mag_Tracer", 4] call SAC_fnc_addMagazines;
	[_unit, "NORTH_47rnd_dp27_mag", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "NORTH_dp27";
	
};

SAC_GEAR_fnc_manu_giveDt = {

	params ["_unit"];

	[_unit, "NORTH_63rnd_dt_mag_Tracer", 4] call SAC_fnc_addMagazines;
	[_unit, "NORTH_63rnd_dt_mag", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "NORTH_DT_hand";
	
};

SAC_GEAR_fnc_manu_giveMosinScopeSOV = {

	params ["_unit"];

	[_unit, "NORTH_5Rnd_m39_tracer_mag", 5] call SAC_fnc_addMagazines;
	[_unit, "NORTH_5Rnd_m39_mag", 5] call SAC_fnc_addMagazines;

	_unit addWeapon "NORTH_sov_m9130_PU";
	
};

SAC_GEAR_fnc_manu_giveC96 = {

	params ["_unit"];

	[_unit, "EAW_C96_Auto20_Magazine", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "EAW_C96_Auto_Carbine";
	
};

korea_give_vest_MG = {
	params ["_unit"];

	_unit addVest selectRandom[
		"V_LIB_SOV_RA_MGBelt_Kit"
	];
};

korea_give_vest_armor = {
	params ["_unit"];

	_unit addVest selectRandom[
		"V_NORTH_SOV_SN42"
	];
};

korea_give_vest_map = {
	params ["_unit"];

	_unit addVest selectRandom[
		"V_NORTH_SOV_Belt_Officer",
		"V_NORTH_SOV_Belt_Officer_3"
	];
};

korea_give_vest_pistoMap = {
	params ["_unit"];

	_unit addVest selectRandom[
		"V_NORTH_SOV_Belt_Pistol_2"
	];
};

korea_give_vest_rif = {
	params ["_unit"];

	_unit addVest selectRandom[
		"V_NORTH_SOV_Belt_Mosin",
		"V_NORTH_SOV_Belt_Mosin_2",
		"V_NORTH_SOV_Belt_Mosin_3",
		"V_NORTH_SOV_Belt_Mosin_4",
		"V_NORTH_SOV_Belt_Mosin_5",
		"V_NORTH_FIN_Rifleman_1",
		"V_NORTH_FIN_Rifleman_8",
		"V_NORTH_FIN_Rifleman_4",
		"V_NORTH_FIN_Rifleman_10",
		"V_NORTH_SOV_Belt_Mosin_Imperial",
		"V_NORTH_SOV_Belt_Mosin_Imperial_4",
		"V_NORTH_SOV_Belt_SVT_2"
	];
};

korea_give_vest_medic = {
	params ["_unit"];

	_unit addVest selectRandom[
		"V_NORTH_SOV_Belt_Mosin_Imperial_3"
	];
};

korea_give_vest_smgRounded = {
	params ["_unit"];

	_unit addVest selectRandom[
		"V_NORTH_SOV_Belt_SMG_2",
		"V_NORTH_SOV_Belt_SMG_4",
		"V_NORTH_FIN_Assault_8",
		"V_NORTH_FIN_Assault_3",
		"V_NORTH_FIN_Assault_6",
		"V_NORTH_FIN_Assault_5",
		"V_NORTH_SOV_Belt_Officer_Assault"
	];
};

korea_give_vest_smgStraight = {
	params ["_unit"];

	_unit addVest selectRandom[
		"V_NORTH_SOV_Belt_SMG_5",
		"V_NORTH_SOV_Belt_Officer_Assault_2"
	];
};

//---china - vests

china_giveVest_smg_rounded = {
	params["_unit"];

	_unit addVest selectRandom [
		"V_NORTH_FIN_Pioneer_Assault_1",
		"V_NORTH_FIN_Pioneer_Assault_2",
		"V_NORTH_FIN_Pioneer_Assault_3",
		"V_NORTH_FIN_Pioneer_Assault_4"
	];
};

china_giveVest_smg_straight = {
	params["_unit"];

	_unit addVest selectRandom[
		"EAW_Chinese_MP28_Kit",
		"V_LIB_UK_P37_Sten_Blanco",
		"V_LIB_UK_P37_Sten_Blanco"
	];
};

china_giveVest_rifle = {
	params["_unit"];

	_unit addVest selectRandom[
		"EAW_Chinese_Bandolier2_Rifle",
		"EAW_Chinese_Bandolier2_Rifle_Grey",
		"EAW_Chinese_Bandolier2_Rifle_Grenade",
		"EAW_Chinese_Bandolier2_Rifle_GrenadeGrey",
		"EAW_Chinese_Bandolier_Rifle_Grenadier",
		"EAW_Chinese_Bandolier_Rifle_Grenade",
		"EAW_Chinese_Bandolier_Rifle_Grenade_2",
		"EAW_Chinese_Bandolier_Rifle_Alt_Grenade",
		"EAW_NRA_PouchesTop",
		"EAW_NRA_PouchesTop_Grey",

		"V_NORTH_FIN_Rifleman_2",
		"V_NORTH_FIN_Pioneer_1",
		"V_NORTH_FIN_Pioneer_2"
	];
};

china_giveVest_gl = {
	params["_unit"];

	_unit addVest selectRandom[
		"EAW_Chinese_Bandolier2_Rifle_GrenadeGrey",
		"EAW_Chinese_Bandolier2_Rifle_Grenade",

		"EAW_Chinese_Bandolier_Rifle_Grenadier",
		"EAW_Chinese_Bandolier_Rifle_Grenadier",
		"EAW_Chinese_Bandolier_Rifle_Grenade",
		"EAW_Chinese_Bandolier_Rifle_Grenade"
	];

	removeBackpack _unit;
	_unit addBackpack "EAW_Jyuban_GrenadierBag";
};

china_giveVest_ar = {
	params["_unit"];

	_pWeap = primaryWeapon _unit;

	switch (_pWeap) do {
		case "EAW_Type99": { 
			_unit addVest "EAW_IJA_LMG_Kit";
			[_unit, "EAW_Type99_Magazine", 10] call SAC_fnc_addMagazines;
		};
		case "NORTH_Madsen1922": { 
			_unit addVest "EAW_IJA_LMG_Kit";
			[_unit, "NORTH_25rnd_Madsen1922_mag", 10] call SAC_fnc_addMagazines;
		};
		case "EAW_FN30_Base": { 
			_unit addVest "EAW_ZB_Bandolier";
			[_unit, "EAW_FN30_Magazine", 15] call SAC_fnc_addMagazines;
		};
		case "EAW_ZB26_Base": { 
			_unit addVest "EAW_ZB_Bandolier";
			[_unit, "EAW_ZB26_Magazine", 15] call SAC_fnc_addMagazines;
		};
		default { 
			_unit addVest "EAW_ZB_Bandolier";
			[_unit, "EAW_ZB26_Magazine", 15] call SAC_fnc_addMagazines;
		};
	};

	if (_pWeap in["EAW_ZB26_Base", "EAW_FN30_Base"]) then {
		_unit addVest "EAW_ZB_Bandolier";
	} else {
		_unit addVest "EAW_IJA_LMG_Kit";
	};
};

//---china - guns 

china_give_c96 = {
	params["_unit"];

	[_unit, "EAW_C96_Auto20_Magazine", 15] call SAC_fnc_addMagazines;

	_unit addWeapon "EAW_C96_Auto_Carbine";
};

china_give_at = {
	params["_unit"];

	_gun = selectRandom[
		"LIB_M1A1_Bazooka","LIB_M1A1_Bazooka",
		"LIB_PIAT"
	];

	switch (_gun) do {
		case "LIB_M1A1_Bazooka": { 
			[_unit, "LIB_1Rnd_60mm_M6", 2] call SAC_fnc_addMagazines;

			_unit addWeapon "LIB_M1A1_Bazooka";
		};
		case "LIB_PIAT": { 
			[_unit, "LIB_1Rnd_89m_PIAT", 2] call SAC_fnc_addMagazines;

			_unit addWeapon "LIB_PIAT";
		};
		default { };
	};

};

china_give_meleeWeapon = {
	params["_unit"];

	_unit addWeapon selectRandom[
		"EAW_Type30",
		"EAW_Hanyang_Bayonet",
		"Sashka_Russian",
		"WBK_survival_weapon_4"
	];
};

china_give_boltRifle = {
	params["_unit"];

	_gun = selectRandom[
		"NORTH_sov_M9130","NORTH_sov_M9130","NORTH_sov_M9130","NORTH_sov_M9130","NORTH_sov_M9130",
		"EAW_Type30_Rifle",
		"EAW_Type24_Rifle_Stock2","EAW_Type24_Rifle_Stock2",
		"EAW_Hanyang88_Base",
		"LIB_LeeEnfield_No1",
		"NORTH_fin_m24","NORTH_fin_m24"
	];

	switch (_gun) do {
		case "NORTH_sov_M9130": { 
			[_unit, "NORTH_5Rnd_m39_tracer_mag", 6] call SAC_fnc_addMagazines;
			[_unit, "NORTH_5Rnd_m39_mag", 6] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_sov_M9130";
		};
		case "NORTH_fin_m24": { 
			[_unit, "NORTH_5Rnd_m39_tracer_mag", 6] call SAC_fnc_addMagazines;
			[_unit, "NORTH_5Rnd_m39_mag", 6] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_fin_m24";
		};
		case "EAW_Type30_Rifle": { 
			[_unit, "EAW_Type38_Magazine", 12] call SAC_fnc_addMagazines;
			
			_unit addWeapon "EAW_Type30_Rifle";
		};
		case "EAW_Type24_Rifle_Stock2": { 
			[_unit, "EAW_Hanyang88_Magazine", 12] call SAC_fnc_addMagazines;
			
			_unit addWeapon "EAW_Type24_Rifle_Stock2";
			if (random 1 < 0.5) then {
				_unit addPrimaryWeaponItem "EAW_Type24_Bayonet_Attach";			
			};
		};
		case "EAW_Hanyang88_Base": { 
			[_unit, "EAW_Hanyang88_Magazine", 12] call SAC_fnc_addMagazines;
			
			_unit addWeapon "EAW_Hanyang88_Base";
			if (random 1 < 0.5) then {
				_unit addPrimaryWeaponItem "EAW_Hanyang_Bayonet_Attach";			
			};
		};
		case "LIB_LeeEnfield_No1": { 
			[_unit, "LIB_10Rnd_770x56", 12] call SAC_fnc_addMagazines;
			
			_unit addWeapon "LIB_LeeEnfield_No1";
			_unit addPrimaryWeaponItem "LIB_ACC_P1903_Bayo";
		};
		default { 
			[_unit, "NORTH_5Rnd_m39_tracer_mag", 6] call SAC_fnc_addMagazines;
			[_unit, "NORTH_5Rnd_m39_mag", 6] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_sov_M9130";
		};
	};

};

china_give_sniper = {
	params["_unit"];

	_gun = selectRandom[
		"NORTH_sov_m9130_PU",
		"fow_w_type99_sniper",
		"NORTH_nor_krag1894_optics",
		"EAW_Type97_Sniper"
	];

	switch (_gun) do {
		case "NORTH_sov_m9130_PU": { 
			[_unit, "NORTH_5Rnd_m39_tracer_mag", 6] call SAC_fnc_addMagazines;
			[_unit, "NORTH_5Rnd_m39_mag", 6] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_sov_m9130_PU";
		};
		case "fow_w_type99_sniper": { 
			[_unit, "fow_5Rnd_77x58", 12] call SAC_fnc_addMagazines;

			_unit addWeapon "fow_w_type99_sniper";
		};
		case "NORTH_nor_krag1894_optics": { 
			[_unit, "NORTH_5Rnd_krag_bullets", 12] call SAC_fnc_addMagazines;
			
			_unit addWeapon "NORTH_nor_krag1894_optics";
		};
		case "EAW_Type97_Sniper": { 
			[_unit, "EAW_Type38_Magazine", 12] call SAC_fnc_addMagazines;
			
			_unit addWeapon "EAW_Type97_Sniper";
			
			_unit addPrimaryWeaponItem "EAW_Type97_Sniper_Scope";
		};
		default { };
	};

};

china_give_autoRifle = {
	params["_unit"];

	_gun = selectRandom[
		"NORTH_Fedorov_Avtomat",
		"NORTH_SVT40","NORTH_SVT40","NORTH_SVT40"
	];

	switch (_gun) do {
		case "NORTH_Fedorov_Avtomat": { 
			[_unit, "NORTH_25rnd_Fedorov_mag", 8] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_Fedorov_Avtomat";
		};
		case "NORTH_SVT40": { 
			[_unit, "NORTH_10rnd_SVT_mag", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_SVT40";
		};
		default { 
			[_unit, "NORTH_10rnd_SVT_mag", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_SVT40";
		};
	};
};

china_give_smg_straight = {
	params["_unit"];

	_gun = selectRandom[
		"fow_w_m3","fow_w_m3",
		"LIB_Sten_Mk2","LIB_Sten_Mk2",
		"EAW_MP28","EAW_MP28","EAW_MP28","EAW_MP28",
		"NORTH_PPS43",
		"NORTH_ppsh41"
	];

	switch (_gun) do {
		case "fow_w_m3": { 
			[_unit, "fow_30Rnd_45acp", 8] call SAC_fnc_addMagazines;

			_unit addWeapon "fow_w_m3";
		};
		case "LIB_Sten_Mk2": { 
			[_unit, "LIB_32Rnd_9x19_Sten", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "LIB_Sten_Mk2";
		};
		case "EAW_MP28": { 
			[_unit, "EAW_MP28_20_Magazine", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "EAW_MP28";
		};
		case "NORTH_PPS43": { 
			[_unit, "NORTH_35rnd_pps43_mag", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_PPS43";
		};
		case "NORTH_ppsh41": { 
			[_unit, "NORTH_35rnd_ppsh41_mag", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_ppsh41";
		};
		default { 
			[_unit, "EAW_MP28_20_Magazine", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "EAW_MP28";
		};
	};
};

china_give_smg_rounded = {
	params["_unit"];

	_gun = selectRandom[
		"NORTH_ppsh41","NORTH_ppsh41",
		"NORTH_kp44"
	];

	switch (_gun) do {
		case "NORTH_kp44": { 
			[_unit, "NORTH_71rnd_kp31_mag", 5] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_kp44";
		};
		case "NORTH_ppsh41": { 
			[_unit, "NORTH_71rnd_ppsh41_mag", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_ppsh41";
		};
		default { 
			[_unit, "NORTH_71rnd_ppsh41_mag", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_ppsh41";
		};
	};
};

china_give_mg = {
	params["_unit"];

	_gun = selectRandom[
		"EAW_Type11_Base","EAW_Type11_Base",
		"dp27","dp27",
		"dt"
	];

	switch (_gun) do {
		case "EAW_Type11_Base": { 
			[_unit, "EAW_Type11_Magazine", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "EAW_Type11_Base";
			_unit addPrimaryWeaponItem "EAW_Type11_Bipod";
		};
		case "dp27": { 
			[_unit] call SAC_GEAR_fnc_manu_giveDp27;
		};
		case "dt": { 
			[_unit] call SAC_GEAR_fnc_manu_giveDt;
		};
		default { [_unit] call SAC_GEAR_fnc_manu_giveDp27; };
	};
};

china_give_ar = {
	params["_unit"];

	_gun = selectRandom[
		"EAW_Type99","EAW_Type99",
		"EAW_FN30_Base",
		"NORTH_Madsen1922","NORTH_Madsen1922",
		"EAW_ZB26_Base","EAW_ZB26_Base","EAW_ZB26_Base","EAW_ZB26_Base"
	];

	switch (_gun) do {
		case "EAW_Type99": { 
			[_unit, "EAW_Type99_Magazine", 7] call SAC_fnc_addMagazines;

			_unit addWeapon "EAW_Type99";
			_unit addPrimaryWeaponItem "EAW_Type99_Bipod";
		};
		case "EAW_FN30_Base": { 
			[_unit, "EAW_FN30_Magazine", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "EAW_FN30_Base";
			_unit addPrimaryWeaponItem "EAW_FN30_Bipod";
		};
		case "NORTH_Madsen1922": { 
			[_unit, "NORTH_25rnd_Madsen1922_mag", 7] call SAC_fnc_addMagazines;

			_unit addWeapon "NORTH_Madsen1922";
		};
		case "EAW_ZB26_Base": { 
			[_unit, "EAW_ZB26_Magazine", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "EAW_ZB26_Base";
			_unit addPrimaryWeaponItem "EAW_ZB26_Bipod";
		};
		default { 
			[_unit, "EAW_ZB26_Magazine", 10] call SAC_fnc_addMagazines;

			_unit addWeapon "EAW_ZB26_Base";
			_unit addPrimaryWeaponItem "EAW_ZB26_Bipod";
		};
	};
};

//---china end

SAC_GEAR_fnc_manu_giveAK12_CUP = {

	params ["_unit", "_role"];

	[_unit, "CUP_30Rnd_TE1_Green_Tracer_545x39_AK12_M", 4] call SAC_fnc_addMagazines;
	[_unit, "CUP_30Rnd_545x39_AK12_M", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_arifle_AK12_black";
	
};

SAC_GEAR_fnc_manu_giveAK74U_RHS = {

	params ["_unit", "_role"];

	[_unit, "rhs_30Rnd_545x39_AK_green", 6] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_aks74un";
	_unit addPrimaryWeaponItem "rhs_acc_pgs64_74u";
	
};

SAC_GEAR_fnc_manu_giveAK12GL_CUP = {

	params ["_unit", "_role"];

	[_unit, "CUP_30Rnd_TE1_Green_Tracer_545x39_AK12_M", 2] call SAC_fnc_addMagazines;
	[_unit, "CUP_30Rnd_545x39_AK12_M", 3] call SAC_fnc_addMagazines;
	[_unit, "CUP_1Rnd_HE_GP25_M", 5] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_arifle_AK12_GP34_black";
	
};

SAC_GEAR_fnc_manu_giveAK74M_CUP = {

	params ["_unit", "_role"];

	[_unit, "CUP_30Rnd_TE1_Green_Tracer_545x39_AK74M_M", 4] call SAC_fnc_addMagazines;
	[_unit, "CUP_30Rnd_545x39_AK74M_M", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_arifle_AK74M";
	
};

SAC_GEAR_fnc_manu_giveRPK74M_CUP = {

	params ["_unit", "_role"];

	[_unit, "CUP_60Rnd_TE1_Green_Tracer_545x39_AK74M_M", 8] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_arifle_RPK74M_railed";
	
};

SAC_GEAR_fnc_manu_givePKP_CUP = {

	params ["_unit", "_role"];

	[_unit, "150Rnd_762x54_Box_Tracer", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "CUP_lmg_Pecheneg_B50_vfg";
	
};

SAC_GEAR_fnc_manu_giveRPG7_RHS = {

	params ["_unit", "_role"];

	[_unit, "rhs_rpg7_PG7VL_mag", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_rpg7";
	
};

SAC_GEAR_fnc_manu_giveAK74MR = {

	params ["_unit", "_role"];

	[_unit, "rhs_30Rnd_545x39_7N10_AK", 4] call SAC_fnc_addMagazines;
	[_unit, "rhs_30Rnd_545x39_AK_plum_green", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_ak74mr";

	_unit addPrimaryWeaponItem "rhs_acc_uuk";
	_unit addPrimaryWeaponItem "rhs_acc_2dpZenit";
	_unit addPrimaryWeaponItem "rhs_acc_grip_ffg2";

	switch (_role) do {
		case "SL": { _unit addPrimaryWeaponItem "optic_MRCO"; };
		default { _unit addPrimaryWeaponItem "rhs_acc_1p87"; };
	};
	
};

SAC_GEAR_fnc_manu_giveAK74M_Zenetico01 = {

	params ["_unit", "_role"];

	[_unit, "rhs_30Rnd_545x39_7N10_AK", 4] call SAC_fnc_addMagazines;
	[_unit, "rhs_30Rnd_545x39_AK_plum_green", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_ak74m_zenitco01";

	_unit addPrimaryWeaponItem "rhs_acc_uuk";
	_unit addPrimaryWeaponItem "rhs_acc_2dpZenit_ris";
	_unit addPrimaryWeaponItem "rhs_acc_grip_ffg2";

	if (random 1 < 0.3) then {
		_unit addPrimaryWeaponItem "rhsusf_acc_T1_low_fwd";
	};
	
};

SAC_GEAR_fnc_manu_giveAK74MR_GP25 = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_545x39_7N10_AK", 3] call SAC_fnc_addMagazines;
	[_unit, "rhs_30Rnd_545x39_AK_plum_green", 3] call SAC_fnc_addMagazines;
	[_unit, "rhs_VOG25", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_ak74mr_gp25";

	_unit addPrimaryWeaponItem "rhs_acc_uuk";
};

SAC_GEAR_fnc_manu_giveSVD_camo = {

	params ["_unit"];

	[_unit, "rhs_10Rnd_762x54mmR_7N14", 5] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_svdp_wd";
	_unit addPrimaryWeaponItem "rhs_acc_pso1m21";

};

SAC_GEAR_fnc_manu_giveRPK74M = {

	params ["_unit"];

	[_unit, "rhs_45Rnd_545X39_AK_Green", 7] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_rpk74m";
	_unit addPrimaryWeaponItem "rhs_acc_dtkrpk";

};

SAC_GEAR_fnc_manu_giveRPK12_F = {

	params ["_unit"];

	[_unit, "75rnd_762x39_AK12_Mag_Tracer_F", 7] call SAC_fnc_addMagazines;

	_unit addWeapon "arifle_RPK12_F";
	_unit addPrimaryWeaponItem "optic_MRCO";

};

SAC_GEAR_fnc_manu_giveAK105_Zenetico01 = {

	params ["_unit"];

	[_unit, "rhs_30Rnd_545x39_7N10_AK", 4] call SAC_fnc_addMagazines;
	[_unit, "rhs_30Rnd_545x39_AK_plum_green", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_ak105_zenitco01";
	
	_unit addPrimaryWeaponItem "rhs_acc_uuk";
	_unit addPrimaryWeaponItem "rhs_acc_2dpZenit_ris";
	_unit addPrimaryWeaponItem "rhs_acc_grip_ffg2";

	if (random 1 < 0.3) then {
		_unit addPrimaryWeaponItem "rhsusf_acc_T1_low_fwd";
	};

};

SAC_GEAR_fnc_manu_giveRPG7_F = {

	params ["_unit"];

	[_unit, "RPG7_F", 3] call SAC_fnc_addMagazines;

	_unit addWeapon "launch_RPG7_F";

};

SAC_GEAR_fnc_manu_giveIGLA = {

	params ["_unit"];

	[_unit, "rhs_mag_9k38_rocket", 2] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_igla";

};

SAC_GEAR_fnc_manu_giveMP_443 = {

	params ["_unit"];

	[_unit, "rhs_mag_9x19_17", 2] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_pya";

};

SAC_GEAR_fnc_manu_givePP2000 = {

	params ["_unit"];

	[_unit, "rhs_mag_9x19mm_7n21_20", 4] call SAC_fnc_addMagazines;

	_unit addWeapon "rhs_weap_pp2000";

};

SAC_GEAR_fnc_giveWeapons = {

	params ["_unit", "_weaponFamily", "_role", "_silencer", "_scopes"];

	switch (_weaponFamily) do {
/*
		case "MX": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMX;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_giveP07_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMX;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMX;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMXGL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no hay buenas MG en vanilla
				case "AR": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMXSW;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMX;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMX;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMX;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMX;
					[_unit] call SAC_GEAR_fnc_giveTITAN_at;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMX;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMXM;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "KATIBA": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveKATIBA;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_giveROOK40_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveKATIBA;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveKATIBA;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveKATIBAGL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no hay buenas MG en vanilla
				case "AR": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveZAFIR;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveKATIBA;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveKATIBA;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveKATIBA;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveKATIBA;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveKATIBA;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCMR76;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "AK12": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveAK12;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_giveROOK40_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveAK12;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveAK12;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveAK12GL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no hay buenas MG en vanilla
				case "AR": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveZAFIR;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveAK12;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveAK12;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveAK12;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveAK12;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveAK12;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCMR76;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};

		case "CAR95": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCAR95;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_giveROOK40_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCAR95;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCAR95;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCAR95GL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no hay buenas MG en vanilla
				case "AR": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCAR95_mg;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCAR95;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCAR95;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCAR95;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCAR95;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCAR95;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveCMR76;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "MK20": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMK20;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_giveP07_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMK20;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMK20;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMK20GL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG"; //falta implementar
				case "AR": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveMK200;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMK20;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMK20;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMK20;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMK20;
					[_unit] call SAC_GEAR_fnc_giveTITAN_at;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMK20;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				
				case "MM": {

					switch (selectRandom [1, 2, 3]) do {
						case 1: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK14};
						case 2: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK18EBR};
						case 3: {[_unit, _silencer] call SAC_GEAR_fnc_giveMKI};
					};
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "MP5": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMP5;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_giveP07_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "GL";
				case "RIFLEMAN";
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMP5;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "MG"; //falta implementar
				case "AR": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveMK200;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMP5;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMP5;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMP5;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMP5;
					[_unit] call SAC_GEAR_fnc_giveTITAN_at;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMP5;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				
				case "MM": {

					switch (selectRandom [1, 2, 3]) do {
						case 1: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK14};
						case 2: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK18EBR};
						case 3: {[_unit, _silencer] call SAC_GEAR_fnc_giveMKI};
					};
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "VERMIN": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveVermin;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_giveP07_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "GL";
				case "RIFLEMAN";
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveVermin;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "MG"; //falta implementar
				case "AR": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveMK200;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveVermin;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveVermin;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveVermin;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveVermin;
					[_unit] call SAC_GEAR_fnc_giveTITAN_at;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveVermin;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				
				case "MM": {

					switch (selectRandom [1, 2, 3]) do {
						case 1: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK14};
						case 2: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK18EBR};
						case 3: {[_unit, _silencer] call SAC_GEAR_fnc_giveMKI};
					};
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "STING": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSTING;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_giveP07_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "GL";
				case "RIFLEMAN";
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSTING;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG"; //falta implementar
				case "AR": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveMK200;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSTING;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSTING;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSTING;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSTING;
					[_unit] call SAC_GEAR_fnc_giveTITAN_at;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSTING;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				
				case "MM": {

					switch (selectRandom [1, 2, 3]) do {
						case 1: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK14};
						case 2: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK18EBR};
						case 3: {[_unit, _silencer] call SAC_GEAR_fnc_giveMKI};
					};
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "PISTOLS": {

			[_unit, _silencer] call SAC_GEAR_fnc_giveROOK40_9mm;
			[_unit] call SAC_GEAR_fnc_giveMEDICAL;

		};
		
		case "SPAR": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSPAR16;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_give4five_45ACP;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSPAR16;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSPAR16;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSPAR16GL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no hay buenas MG en vanilla
				case "AR": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveMK200;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSPAR16;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSPAR16;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSPAR16;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSPAR16;
					[_unit] call SAC_GEAR_fnc_giveTITAN_at;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveSPAR16;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					switch (selectRandom [1, 2, 3]) do {
						case 1: {[_unit, _silencer] call SAC_GEAR_fnc_giveSPAR17};
						case 2: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK18EBR};
						case 3: {[_unit, _silencer] call SAC_GEAR_fnc_giveMKI};
					};
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "TRG": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer, _scopes] call SAC_GEAR_fnc_giveTRG;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_giveROOK40_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer, _scopes] call SAC_GEAR_fnc_giveTRG;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit, _silencer, _scopes] call SAC_GEAR_fnc_giveTRG;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer, _scopes] call SAC_GEAR_fnc_giveTRGGL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no hay buenas MG en vanilla
				case "AR": {

					[_unit, _silencer, _scopes] call SAC_GEAR_fnc_giveMK200;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer, _scopes] call SAC_GEAR_fnc_giveTRG;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer, _scopes] call SAC_GEAR_fnc_giveTRG;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer, _scopes] call SAC_GEAR_fnc_giveTRG;
					if (_scopes) then {[_unit] call SAC_GEAR_fnc_givePCML} else {[_unit] call SAC_GEAR_fnc_giveRPG7};
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer, _scopes] call SAC_GEAR_fnc_giveTRG;
					[_unit] call SAC_GEAR_fnc_giveTITAN_at;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer, _scopes] call SAC_GEAR_fnc_giveTRG;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					switch (selectRandom [1, 2, 3]) do {
						case 1: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK14};
						case 2: {[_unit, _silencer] call SAC_GEAR_fnc_giveMK18EBR};
						case 3: {[_unit, _silencer] call SAC_GEAR_fnc_giveMKI};
					};
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "RHS_HK416": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_HK416;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
					if (isPlayer _unit) then {

						[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_glock17_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_HK416;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_HK416;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_HK416GL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no quiero usar MGs en SOF
				case "AR": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveRHS_M249;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_HK416;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_HK416;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_HK416;
					[_unit] call SAC_GEAR_fnc_giveRHS_M136AT;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_HK416;
					[_unit] call SAC_GEAR_fnc_giveRHS_JAVELIN;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_HK416;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_SR25;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};

		case "RHS_MK18": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_MK18;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
					if (isPlayer _unit) then {

						[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_glock17_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_MK18;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_MK18;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_MK18GL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no quiero usar MGs en SOF
				case "AR": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveRHS_M249;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_MK18;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_MK18;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_MK18;
					[_unit] call SAC_GEAR_fnc_giveRHS_M136AT;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_MK18;
					[_unit] call SAC_GEAR_fnc_giveRHS_JAVELIN;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_MK18;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_SR25;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "RHS_M4A1_blockII": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_M4A1blockII;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
					if (isPlayer _unit) then {

						[_unit] call SAC_GEAR_fnc_giveRHS_1911_45;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_M4A1blockII;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_M4A1blockII;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_M4A1blockIIGL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no quiero usar MGs en SOF
				case "AR": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveLIM85;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_M4A1blockII;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_M4A1blockII;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_M4A1blockII;
					[_unit] call SAC_GEAR_fnc_giveRHS_M136AT;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_M4A1blockII;
					[_unit] call SAC_GEAR_fnc_giveRHS_JAVELIN;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_M4A1blockII;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_SR25;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};

		case "RHS_M4A1_PIP": {

			switch (_role) do {

				case "SL": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M4A1_PIP;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
					if (isPlayer _unit) then {

						[_unit] call SAC_GEAR_fnc_giveRHS_m9beretta_9mm;

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M4A1_PIP;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "RIFLEMAN": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M4A1_PIP;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M4A1_PIP_GL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "AR": {

					//[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_IAR;
					[_unit, false, false] call SAC_GEAR_fnc_giveRHS_M249;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M240B;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M4A1_PIP;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M4A1_PIP;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M4A1_PIP;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M4A1_PIP;
					[_unit] call SAC_GEAR_fnc_giveTITAN_at;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M4A1_PIP;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_SR25;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "CREW": {

					[_unit, false] call SAC_GEAR_fnc_giveRHS_M4A1_PIP;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "AK74M": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					
					if (isPlayer _unit) then {

						_unit addWeapon "Binocular";
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M_gl;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";
				case "AR": {

					[_unit] call SAC_GEAR_fnc_giveRHS_PKM;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MM": {

					[_unit] call SAC_GEAR_fnc_giveRHS_svds;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "AKM": {

			switch (_role) do {

				case "SL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKM;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

					if (isPlayer _unit) then {_unit addWeapon "Binocular"};

				};
				case "TL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKM;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKM;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "GL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKMGL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";
				case "AR": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m84;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKM;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKM;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKM;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKM;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "AA": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKM;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MM": {

					[_unit] call SAC_GEAR_fnc_giveRHS_svds;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "AKMS": {

			switch (_role) do {

				case "SL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKMS;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

					if (isPlayer _unit) then {_unit addWeapon "Binocular"};

				};
				case "TL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKMS;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKMS;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "GL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKMSGL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";
				case "AR": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m84;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKMS;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKMS;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKMS;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKMS;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "AA": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKMS;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MM": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m76;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "AKS74": {

			switch (_role) do {

				case "SL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

					if (isPlayer _unit) then {_unit addWeapon "Binocular"};

				};
				case "TL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "GL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74GL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";
				case "AR": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m84;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "AA": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MM": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m76;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "AKS74n": { //este perfil es para uso de la IA

			switch (_role) do {

				case "SL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74n;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

					if (isPlayer _unit) then {_unit addWeapon "Binocular"};

				};
				case "TL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74n;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74n;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "GL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74nGL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";
				case "AR": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m84;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74n;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74n;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74n;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74n;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "AA": {

					[_unit] call SAC_GEAR_fnc_giveRHS_AKS74n;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MM": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m76;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "RHS_AKS74N_NPZ": { //este es el perfil para usar con los players

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AKS74N_NPZ;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
					[_unit] call SAC_GEAR_fnc_giveRHS_RPG45;

					if (isPlayer _unit) then {
					
						[_unit, _silencer] call SAC_GEAR_fnc_giveROOK40_9mm;

						if (_silencer) then {_unit addWeapon "rhs_pdu4"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AKS74N_NPZ;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AKS74N_NPZ;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AKS74N_NPZ_GP25;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveRHS_PKP;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "AR": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveRHS_AK74M_Zenitco_45rnd;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AKS74N_NPZ_holo;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AKS74N_NPZ;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AKS74N_NPZ_holo;
					[_unit] call SAC_GEAR_fnc_giveRHS_RPG45;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AKS74N_NPZ_holo;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AKS74N_NPZ_holo;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_SVDS_NPZ;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "RHS_AKS74M_SPNZ": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M_zenitco_b33;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
					[_unit] call SAC_GEAR_fnc_giveRHS_RPG45;
					
					if (isPlayer _unit) then {

						[_unit, _silencer] call SAC_GEAR_fnc_giveROOK40_9mm;

						_unit addWeapon "rhs_pdu4";
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M_zenitco_b33;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M_zenitco_b33;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M_GP25;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveRHS_PKP;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "AR": {

					[_unit, _silencer, true] call SAC_GEAR_fnc_giveRHS_AK74M_Zenitco_45rnd;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M_zenitco_b33;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M_zenitco_b33;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M_zenitco_b33;
					[_unit] call SAC_GEAR_fnc_giveRHS_RPG45;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M_zenitco_b33;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_AK74M_zenitco_b33;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveMKI;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "M21": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_m21;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					
					if (isPlayer _unit) then {

						if (_silencer) then {_unit addWeapon "Rangefinder"} else {_unit addWeapon "Binocular"};
						
					};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_m21;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_m21;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_m21_gl;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";
				case "AR": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_minimi_para;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_m21;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_m21;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_m21;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_m21;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveRHS_m21;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MM": {

					[_unit] call SAC_GEAR_fnc_giveRHS_svds;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "M70": {

			switch (_role) do {

				case "SL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m70;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

					if (isPlayer _unit) then {_unit addWeapon "Binocular"};

				};
				case "TL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m70;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m70;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "GL": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m70gl;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";
				case "AR": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m84;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m70;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m70;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m70;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m70;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "AA": {

					[_unit] call SAC_GEAR_fnc_giveRHS_m70;
					[_unit] call SAC_GEAR_fnc_giveRHS_STINGER;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MM": {

					[_unit] call SAC_GEAR_fnc_giveRHS_M76;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "BIS_AK12": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

					if (isPlayer _unit) then {[_unit, _silencer] call SAC_GEAR_fnc_giveP07_9mm};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;
					[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12_GL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no hay buenas MG en vanilla
				case "AR": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12_AR;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 4] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12_MM;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 8] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};

		case "BIS_AK12_UC": {

			switch (_role) do {

				case "SL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 2] call SAC_GEAR_fnc_giveSMOKE;
					//[_unit] call SAC_GEAR_fnc_giveFRAGS;

					if (isPlayer _unit) then {[_unit, _silencer] call SAC_GEAR_fnc_giveP07_9mm};

				};
				case "TL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 2] call SAC_GEAR_fnc_giveSMOKE;
					//[_unit] call SAC_GEAR_fnc_giveFRAGS;
					
				};
				case "CREW";
				case "RIFLEMAN": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 2] call SAC_GEAR_fnc_giveSMOKE;
					//[_unit] call SAC_GEAR_fnc_giveFRAGS;

				};
				case "GL": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12_GL;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 2] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MG";//es igual que el "AR" porque no hay buenas MG en vanilla
				case "AR": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12_AR;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 2] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "MEDIC": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 2] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "ENG": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					_unit addItemToBackpack "ToolKit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 2] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "LAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 2] call SAC_GEAR_fnc_giveSMOKE;

				};
				case "HAT": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_givePCML;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "AA": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12;
					[_unit] call SAC_GEAR_fnc_giveTITAN_aa;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, _silencer] call SAC_GEAR_fnc_giveBIS_AK12_MM;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					[_unit, 2] call SAC_GEAR_fnc_giveSMOKE;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "CUP_VC": {

			switch (_role) do {

				case "SL": {

					[_unit] call SAC_GEAR_fnc_giveCUP_AK47_early;
					if (random 1 < 0.35) then {[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines};
					[_unit, "CUP_HandGrenade_RGD5", 1] call SAC_fnc_addMagazines;

					if (isPlayer _unit) then {_unit addWeapon "Binocular"};

				};
				case "TL": {

					[_unit] call SAC_GEAR_fnc_giveCUP_AK47_early;
					if (random 1 < 0.35) then {[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines};
					[_unit, "CUP_HandGrenade_RGD5", 1] call SAC_fnc_addMagazines;
					
				};
				case "CREW";
				case "GL";
				case "RIFLEMAN": {
				
					[_unit] call SAC_GEAR_fnc_giveCUP_AK47_early;
					if (random 1 < 0.35) then {[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines};
					[_unit, "CUP_HandGrenade_RGD5", 1] call SAC_fnc_addMagazines;

				};
				case "B_RIFLEMAN": {
				
					[_unit] call SAC_GEAR_fnc_giveCUP_mosin_nagant_noscope;
					if (random 1 < 0.35) then {[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines};
					[_unit, "CUP_HandGrenade_RGD5", 1] call SAC_fnc_addMagazines;

				};
				case "MG": {

					[_unit] call SAC_GEAR_fnc_giveCUP_UK59;
					if (random 1 < 0.35) then {[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines};
					[_unit, "CUP_HandGrenade_RGD5", 1] call SAC_fnc_addMagazines;

				};
				case "AR": {

					[_unit] call SAC_GEAR_fnc_giveCUP_RPK74;
					if (random 1 < 0.35) then {[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines};
					[_unit, "CUP_HandGrenade_RGD5", 1] call SAC_fnc_addMagazines;

				};
				case "MEDIC": {

					[_unit] call SAC_GEAR_fnc_giveCUP_AK47_early;
					if (random 1 < 0.35) then {[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines};
					[_unit, "CUP_HandGrenade_RGD5", 1] call SAC_fnc_addMagazines;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "ENG": {

					[_unit] call SAC_GEAR_fnc_giveCUP_TYPE52_2_early;
					_unit addItemToBackpack "ToolKit";
					if (random 1 < 0.35) then {[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines};
					[_unit, "CUP_HandGrenade_RGD5", 1] call SAC_fnc_addMagazines;
					_unit addItem "ATMine_Range_Mag";
					for "_i" from 1 to 2 do {_unit addItem "VW_NVA_Bouncing_Betty";};
					_unit addItem "DemoCharge_Remote_Mag";


				};
				case "AA";
				case "HAT";
				case "LAT": {

					[_unit] call SAC_GEAR_fnc_giveCUP_TYPE52_2_early;
					if (random 1 < 0.35) then {[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines};
					[_unit, "CUP_HandGrenade_RGD5", 1] call SAC_fnc_addMagazines;
					[_unit] call SAC_GEAR_fnc_giveRPG7;

				};
				case "MM": {

					[_unit] call SAC_GEAR_fnc_giveCUP_mosin_nagant;
					if (random 1 < 0.35) then {[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines};

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
		
		case "BIS_AKM": {

			switch (_role) do {

				case "SL": {

					if (random 1 < 0.5) then {
					
						[_unit] call SAC_GEAR_fnc_giveBIS_AKM;
						
					} else {
					
						[_unit] call SAC_GEAR_fnc_giveBIS_AKU;
					
					};
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "HandGrenade", 2] call SAC_fnc_addMagazines;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					
					if (isPlayer _unit) then {_unit addWeapon "Binocular"};
					
				};
				case "TL": {

					if (random 1 < 0.5) then {
					
						[_unit] call SAC_GEAR_fnc_giveBIS_AKM;
						
					} else {
					
						[_unit] call SAC_GEAR_fnc_giveBIS_AKU;
					
					};
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "HandGrenade", 2] call SAC_fnc_addMagazines;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					
				};
				case "GL": {

					[_unit] call SAC_GEAR_fnc_giveAK12GL;
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "HandGrenade", 2] call SAC_fnc_addMagazines;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;
					
				};
				case "CREW";
				case "RIFLEMAN": {
				
					if (random 1 < 0.5) then {
					
						[_unit] call SAC_GEAR_fnc_giveBIS_AKM;
						
					} else {
					
						[_unit] call SAC_GEAR_fnc_giveBIS_AKU;
					
					};
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "HandGrenade", 2] call SAC_fnc_addMagazines;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MG";
				case "AR": {

					if (random 1 < 0.5) then {
					
						[_unit] call SAC_GEAR_fnc_giveBIS_RPK;
						
					} else {
					
						[_unit, false] call SAC_GEAR_fnc_giveZAFIR_GUER;
					
					};
					[_unit, "SmokeShell", 2] call SAC_fnc_addMagazines;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MEDIC": {

					[_unit] call SAC_GEAR_fnc_giveBIS_AKU;
					[_unit, "SmokeShell", 2] call SAC_fnc_addMagazines;
					_unit addItemToBackpack "Medikit";
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "ENG": {

					[_unit] call SAC_GEAR_fnc_giveBIS_AKU;
					_unit addItemToBackpack "ToolKit";
					[_unit, "SmokeShell", 2] call SAC_fnc_addMagazines;
					_unit addItem "SatchelCharge_Remote_Mag";
					for "_i" from 1 to 3 do {_unit addItem "DemoCharge_Remote_Mag";};
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "LAT": {

					if (random 1 < 0.5) then {
					
						[_unit] call SAC_GEAR_fnc_giveBIS_AKM;
						
					} else {
					
						[_unit] call SAC_GEAR_fnc_giveBIS_AKU;
					
					};
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit] call SAC_GEAR_fnc_giveRPG7;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				case "MM": {

					[_unit, false] call SAC_GEAR_fnc_giveMK14;
					[_unit, "SmokeShell", 2] call SAC_fnc_addMagazines;
					[_unit] call SAC_GEAR_fnc_giveMEDICAL;

				};
				default  {[format["%1 rol no reconocido en %2 por GEAR!", _role, _weaponFamily]] call SAC_fnc_debugNotify};

			};

		};
*/
		// MANU 
		case "rusia_2022_wapons": {
			[_unit, "FirstAidKit", 3] call SAC_fnc_addItems;
			
			switch (_role) do {

				case "SL": {
					[_unit,_role] call SAC_GEAR_fnc_manu_giveAK12_CUP;	
					[_unit, "rhs_mag_rdg2_white", 1] call SAC_fnc_addMagazines;
					[_unit, "rhs_mag_rgd5", 1] call SAC_fnc_addMagazines;
				};
				case "TL": {
					if (random 1 < 0.75) then {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK12_CUP;
					} else {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK74M_CUP;
					};
					[_unit, "rhs_mag_rgd5", 1] call SAC_fnc_addMagazines;
				};
				case "LAT": {
					if (random 1 < 0.5) then {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK12_CUP;
					} else {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK74M_CUP;
					};
					_unit addWeapon "rhs_weap_rpg26";
					if (random 1 < 0.25) then { [_unit, "rhs_mag_rgd5", 1] call SAC_fnc_addMagazines; };
				};
				case "MM": {
					[_unit] call SAC_GEAR_fnc_giveRHS_svds;
					if (random 1 < 0.3) then { [_unit, "rhs_mag_rdg2_white", 1] call SAC_fnc_addMagazines; };
				};
				case "HMG": {
					[_unit] call SAC_GEAR_fnc_manu_givePKP_CUP;
				};
				case "LMG": {
					[_unit] call SAC_GEAR_fnc_manu_giveRPK74M_CUP;
				};
				case "MG_A": {
					if (random 1 < 0.5) then {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK12_CUP;
						[_unit, "150Rnd_762x54_Box_Tracer", 1] call SAC_fnc_addMagazines;
					} else {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK74M_CUP;
						[_unit, "CUP_60Rnd_TE1_Green_Tracer_545x39_AK74M_M", 8] call SAC_fnc_addMagazines;
					};
				};
				case "GL": {
					[_unit] call SAC_GEAR_fnc_manu_giveAK12GL_CUP;
					[_unit, "rhs_mag_rgd5", 1] call SAC_fnc_addMagazines;
				};
				case "AT": {
					if (random 1 < 0.5) then {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK12_CUP;
					} else {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK74M_CUP;
					};
					[_unit,_role] call SAC_GEAR_fnc_manu_giveRPG7_RHS;
				};
				case "AT_A": {
					if (random 1 < 0.5) then {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK12_CUP;
					} else {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK74M_CUP;
					};
					[_unit, "rhs_rpg7_PG7VL_mag", 3] call SAC_fnc_addMagazines;
				};
				case "AA": {
					if (random 1 < 0.5) then {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK12_CUP;
					} else {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK74M_CUP;
					};
					[_unit] call SAC_GEAR_fnc_manu_giveIGLA;
				};
				case "CREW": {
					[_unit] call SAC_GEAR_fnc_manu_giveAK74U_RHS;
				};
				case "PILOT": {
					[_unit] call SAC_GEAR_fnc_manu_giveAK74U_RHS;
				};
				default  {
					if (random 1 < 0.5) then {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK12_CUP;
						[_unit, "rhs_mag_rgd5", 1] call SAC_fnc_addMagazines;
					} else {
						[_unit,_role] call SAC_GEAR_fnc_manu_giveAK74M_CUP;
					};
				};
			};

		};

		case "china_50_winter_wapons": {
			[_unit, "FirstAidKit", 3] call SAC_fnc_addItems;
			
			switch (_role) do {
				case "OF": {
					_unit addWeapon "EAW_C96_Carbine";
					_unit addPrimaryWeaponItem "EAW_C96_Magazine";
					_unit addWeapon "Sashka_Russian";
					
					_unit addVest "V_NORTH_SOV_Belt_Officer";
					_unit addWeapon "NORTH_Binocular_Huet";

					_unit addItemToVest "ZSN_Bugle";
					_unit addItemToVest "ZSN_TrenchWhistle";
					// for "_i" from 1 to 9 do {_unit addItemToVest "EAW_C96_Magazine";};
					for "_i" from 1 to 9 do {_unit addItem "EAW_C96_Magazine";};

					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};	
				case "SL": {
					_unit addItemToUniform "ZSN_Bugle";
					_unit addItemToUniform "ZSN_TrenchWhistle";
					_unit addGoggles "G_mapcase";

					_gun = selectRandom ["smg_r","smg_r","smg_s","smg_s","c96"];

					switch (_gun) do {
						case "smg_r": { //smg redondo
							_unit addVest selectRandom ["V_NORTH_FIN_Officer_Assault_1", "V_NORTH_FIN_Officer_Assault_2", "V_NORTH_FIN_Officer_Assault_3"];
							[_unit] call china_give_smg_rounded;
						};
						case "smg_s": { //smg recto
							[_unit] call china_giveVest_smg_straight;
							[_unit] call china_give_smg_straight;
						};
						case "c96": { //pisto
							_unit addVest "EAW_C96_Vest";
							[_unit] call china_give_c96;
						};
					};					
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "TL": {
					_unit addItemToUniform "ZSN_Bugle";
					_unit addItemToUniform "ZSN_TrenchWhistle";

					_gun = selectRandom ["smg_r","smg_s","smg_s","smg_s"];

					switch (_gun) do {
						case "smg_r": { //smg redondo
							[_unit] call china_giveVest_smg_rounded;
							[_unit] call china_give_smg_rounded;
						};
						case "smg_s": { //smg recto
							[_unit] call china_giveVest_smg_straight;
							[_unit] call china_give_smg_straight;
						};
					};					
					[_unit, "NORTH_F1Grenade_mag", 2] call SAC_fnc_addMagazines;
				};
				case "MED": {
					_unit addVest "EAW_Type90_RifleKit_Medic";
					if (random 1 < 0.6) then {
						[_unit] call china_give_boltRifle;
					} else {
						[_unit] call china_give_c96;						
					};
					[_unit, "FirstAidKit", 3] call SAC_fnc_addItems;
					if (random 1 < 0.5) then { [_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;};
				};
				case "ENG": {
					_unit addVest "V_LIB_SOV_IShBrVestPPShMag";
					[_unit] call china_give_smg_straight;				
					
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_molotov", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_KasapanosImpr3kg_mag", 1] call SAC_fnc_addMagazines;
				};
				case "SLD": {
					[_unit] call china_giveVest_rifle;
					[_unit] call china_give_boltRifle;

					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "SMG": {
					[_unit] call china_giveVest_smg_straight;
					[_unit] call china_give_smg_straight;

					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "AR": {
					[_unit] call china_give_ar;// en este caso particular, el vest le da la municion 
					[_unit] call china_giveVest_ar;

					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "MG": {
					_unit addVest "V_LIB_SOV_RA_MGBelt_Kit";
					
					[_unit] call china_give_mg;					
					
					if (random 1 < 0.5) then { [_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;};
				};
				case "MG_A": {
					[_unit] call china_giveVest_rifle;
					[_unit] call china_give_boltRifle;

					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "MM":  {
					[_unit] call china_giveVest_rifle;
					[_unit] call china_give_sniper;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "TD":  {
					[_unit] call china_giveVest_rifle;
					[_unit] call china_give_autoRifle;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "GL": {
					[_unit] call china_giveVest_gl;
					[_unit] call china_give_boltRifle;

					[_unit, "NORTH_F1Grenade_mag", 3] call SAC_fnc_addMagazines;
					[_unit, "NORTH_molotov", 2] call SAC_fnc_addMagazines;
				};
				case "LAT": {
					if (random 1 < 0.8) then {
						[_unit] call china_giveVest_rifle;
						[_unit] call china_give_boltRifle;					
					} else {
						[_unit] call china_giveVest_smg_straight;
						[_unit] call china_give_smg_straight;
					};
					
					_unit addWeapon "LIB_PzFaust_60m";

					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_molotov", 2] call SAC_fnc_addMagazines;
					[_unit, "NORTH_KasapanosImpr3kg_mag", 1] call SAC_fnc_addMagazines;
				};
				case "AT": {
					if (random 1 < 0.6) then {
						[_unit] call china_giveVest_rifle;
						[_unit] call china_give_boltRifle;					
					} else {
						[_unit] call china_giveVest_smg_straight;
						[_unit] call china_give_smg_straight;
					};

					[_unit] call china_give_at;

					[_unit, "NORTH_F1Grenade_mag", 3] call SAC_fnc_addMagazines;
					[_unit, "NORTH_molotov", 2] call SAC_fnc_addMagazines;
				};
				case "CREW": {
					[_unit] call china_giveVest_smg_straight;
					[_unit] call china_give_smg_straight;
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "MOR": {
					[_unit] call china_giveVest_rifle;
					[_unit] call china_give_boltRifle;
					
					_unit addWeapon "EAW_Type89_Discharger";
					_unit addSecondaryWeaponItem "EAW_Type89_Grenade_HE";
					[_unit, "EAW_Type89_Grenade_HE", 4] call SAC_fnc_addMagazines;

					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "MELEE": {
					[_unit] call china_giveVest_rifle;
					[_unit] call china_give_meleeWeapon;

					[_unit, "NORTH_molotov", 2] call SAC_fnc_addMagazines;
				};
				default  { };
			};

		};

		case "korea_50_summer_wapons": {
			[_unit, "FirstAidKit", 3] call SAC_fnc_addItems;
			
			switch (_role) do {
				case "CREW": {
					if (random 1 < 0.5) then {
						[_unit] call korea_give_vest_smgStraight;
						[_unit] call SAC_GEAR_fnc_manu_givePpsh43;	
					} else {
						[_unit] call korea_give_vest_pistoMap;
						[_unit] call SAC_GEAR_fnc_manu_giveC96;						
					};
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "OFC": {
					[_unit] call korea_give_vest_pistoMap;

					[_unit] call SAC_GEAR_fnc_manu_giveC96;	
					
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "SL": {

					_gun = selectRandom ["1","2","3","4","5","6"];

					switch (_gun) do {
						case "1": { 
							[_unit] call korea_give_vest_pistoMap;
							[_unit] call SAC_GEAR_fnc_manu_giveC96;	
						};
						case "2": { 
							[_unit] call korea_give_vest_rif;
							[_unit] call SAC_GEAR_fnc_manu_giveMosinNagantSOV;
							_unit linkItem "mapcas_addon";
						};
						case "3": { 
							[_unit] call korea_give_vest_rif;
							[_unit] call SAC_GEAR_fnc_manu_giveSvtSOV;
							_unit linkItem "mapcas_addon";
						};
						case "4": { 
							[_unit] call korea_give_vest_smgRounded;
							[_unit, 1] call SAC_GEAR_fnc_manu_givePpsh41SOV;
							_unit linkItem "mapcas_addon";
						};
						case "5": { 
							[_unit] call korea_give_vest_smgStraight;
							[_unit] call SAC_GEAR_fnc_manu_givePpsh43;
							_unit linkItem "mapcas_addon";
						};
						case "6": { 
							[_unit] call korea_give_vest_smgStraight;
							[_unit] call SAC_GEAR_fnc_manu_givePpd34;
							_unit linkItem "mapcas_addon";
						};
						default { };
					};					
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "TL": {

					_gun = selectRandom ["1","2","3","4","5","6"];

					switch (_gun) do {
						case "1": { 
							[_unit] call korea_give_vest_smgStraight;
							[_unit] call SAC_GEAR_fnc_manu_givePpsh43;	
						};
						case "2": { 
							[_unit] call korea_give_vest_rif;
							[_unit] call SAC_GEAR_fnc_manu_giveMosinNagantSOV;
						};
						case "3": { 
							[_unit] call korea_give_vest_rif;
							[_unit] call SAC_GEAR_fnc_manu_giveSvtSOV;
						};
						case "4": { 
							[_unit] call korea_give_vest_smgRounded;
							[_unit, 1] call SAC_GEAR_fnc_manu_givePpsh41SOV;
						};
						case "5": { 
							[_unit] call korea_give_vest_smgStraight;
							[_unit] call SAC_GEAR_fnc_manu_givePpsh43;
						};
						case "6": { 
							[_unit] call korea_give_vest_smgStraight;
							[_unit] call SAC_GEAR_fnc_manu_givePpd34;
						};
						default { };
					};					
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "MED": {
					[_unit] call korea_give_vest_medic;
					[_unit] call SAC_GEAR_fnc_manu_giveMosinNagantSOV;
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					if (random 1 < 0.5) then { [_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;};
				};
				case "MG": {
					[_unit] call korea_give_vest_MG;
					if (random 1 < 0.65) then {
						[_unit] call SAC_GEAR_fnc_manu_giveDp27;					
					} else {
						[_unit] call SAC_GEAR_fnc_manu_giveDt;
					};
					if (random 1 < 0.5) then { [_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;};
					if (random 1 < 0.5) then { [_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;};
				};
				case "AR": {
					[_unit] call korea_give_vest_MG;
					if (random 1 < 0.5) then {
						[_unit] call SAC_GEAR_fnc_manu_giveDp27;					
					} else {
						[_unit] call SAC_GEAR_fnc_manu_giveDt;
					};
					if (random 1 < 0.7) then { [_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;};
				};
				case "MM":  {
					[_unit] call korea_give_vest_rif;
					[_unit] call SAC_GEAR_fnc_manu_giveMosinScopeSOV;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
				case "ENG": {
					[_unit] call korea_give_vest_armor;
					if (random 1 < 0.5) then {
						[_unit] call korea_give_vest_smgStraight;
						[_unit] call SAC_GEAR_fnc_manu_givePpsh43;					
					} else {
						[_unit] call korea_give_vest_smgStraight;
						[_unit,2] call SAC_GEAR_fnc_manu_givePpsh41SOV;
					};
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_molotov", 1] call SAC_fnc_addMagazines;
					[_unit, "NORTH_KasapanosImpr3kg_mag", 1] call SAC_fnc_addMagazines;
				};
				case "GL": {
					[_unit] call korea_give_vest_armor;
					if (random 1 < 0.5) then {
						[_unit] call korea_give_vest_smgStraight;
						[_unit] call SAC_GEAR_fnc_manu_givePpsh43;					
					} else {
						[_unit] call korea_give_vest_smgStraight;
						[_unit,2] call SAC_GEAR_fnc_manu_givePpsh41SOV;
					};
					[_unit, "NORTH_F1Grenade_mag", 3] call SAC_fnc_addMagazines;
					[_unit, "NORTH_molotov", 2] call SAC_fnc_addMagazines;
				};
				default  {
					[_unit] call korea_give_vest_rif;
					[_unit] call SAC_GEAR_fnc_manu_giveMosinNagantSOV;
					[_unit, "NORTH_F1Grenade_mag", 1] call SAC_fnc_addMagazines;
				};
			};

		};

		case "Syrian_army_altis_wapons": {
			[_unit, "FirstAidKit", 3] call SAC_fnc_addItems;
			
			switch (_role) do {

				case "SL": {
					[_unit,_role] call SAC_GEAR_fnc_manu_giveAK74MR;	
					[_unit, "SmokeShell", 1] call SAC_fnc_addMagazines;
					[_unit, "rhs_mag_rgd5", 1] call SAC_fnc_addMagazines;
				};
				case "TL": {
					[_unit,_role] call SAC_GEAR_fnc_manu_giveAK74MR;
	 				[_unit, "rhs_mag_rgd5", 1] call SAC_fnc_addMagazines;
					if (random 1 < 0.3) then { [_unit, "SmokeShell", 1] call SAC_fnc_addMagazines; };
				};
				case "RIF": {
					[_unit] call SAC_GEAR_fnc_manu_giveAK74M_Zenetico01;
					if (random 1 < 0.25) then { [_unit, "rhs_mag_rgd5", 1] call SAC_fnc_addMagazines; };
				};
				case "LAT": {
					[_unit] call SAC_GEAR_fnc_manu_giveAK74M_Zenetico01;
					_unit addWeapon "rhs_weap_rpg18";
					if (random 1 < 0.25) then { [_unit, "rhs_mag_rgd5", 1] call SAC_fnc_addMagazines; };
				};
				case "MM": {
					[_unit] call SAC_GEAR_fnc_manu_giveSVD_camo;
					if (random 1 < 0.3) then { [_unit, "SmokeShell", 1] call SAC_fnc_addMagazines; };
				};
				case "H_MG": {
					[_unit] call SAC_GEAR_fnc_manu_giveRPK12_F;
				};
				case "L_MG": {
					[_unit] call SAC_GEAR_fnc_manu_giveRPK74M;
				};
				case "MG_Asst": {
					if (random 1 < 0.5) then {
						[_unit] call SAC_GEAR_fnc_manu_giveAK74M_Zenetico01;					
					} else {
						[_unit] call SAC_GEAR_fnc_manu_giveAK105_Zenetico01;
					};
					[_unit, "75rnd_762x39_AK12_Mag_Tracer_F", 1] call SAC_fnc_addMagazines;
					[_unit, "rhs_45Rnd_545X39_AK_Green", 1] call SAC_fnc_addMagazines;
				};
				case "GL": {
					[_unit] call SAC_GEAR_fnc_manu_giveAK74MR_GP25;
					[_unit, "rhs_mag_rgd5", 1] call SAC_fnc_addMagazines;
				};
				case "ENG": {
					[_unit] call SAC_GEAR_fnc_manu_giveAK105_Zenetico01;
				};
				case "MED": {
					if (random 1 < 0.5) then {
						[_unit] call SAC_GEAR_fnc_manu_giveAK74M_Zenetico01;					
					} else {
						[_unit] call SAC_GEAR_fnc_manu_giveAK105_Zenetico01;
					};
				};
				case "AT": {
					[_unit] call SAC_GEAR_fnc_manu_giveAK105_Zenetico01;
					[_unit] call SAC_GEAR_fnc_manu_giveRPG7_F;
				};
				case "AT_Asst": {
					if (random 1 < 0.5) then {
						[_unit] call SAC_GEAR_fnc_manu_giveAK74M_Zenetico01;					
					} else {
						[_unit] call SAC_GEAR_fnc_manu_giveAK105_Zenetico01;
					};
					[_unit, "RPG7_F", 3] call SAC_fnc_addMagazines;
				};
				case "AA": {
					[_unit] call SAC_GEAR_fnc_manu_giveAK105_Zenetico01;
					[_unit] call SAC_GEAR_fnc_manu_giveIGLA;
				};
				case "CREW": {
					[_unit] call SAC_GEAR_fnc_manu_giveAK105_Zenetico01;
				};
				case "PILOT": {
					[_unit] call SAC_GEAR_fnc_manu_givePP2000;
				};
				default  { };
			};
			
			[_unit] call SAC_GEAR_fnc_manu_giveMP_443;

		};

	};
};



















if ((isServer) && {SAC_ACE}) then {

	//inicializar el arsenal de ace en todas las cajas que lo tengan por sac_interact
	{

		if (_x getVariable ["SAC_interact_arsenal", false]) then {
		
			[_x, true, true] call ace_arsenal_fnc_initBox;
		
		};


	} forEach vehicles;

};




SAC_GEAR = true;

if (hasInterface) then {systemChat "GEAR initialized."};
