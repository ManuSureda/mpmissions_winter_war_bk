getFrags = {
	params ["_player"];

	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_M32Grenade_mag";};
};

getMolotovs = {
	params ["_player"];

	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_molotov";};
};

getKasapanos = {
	params ["_player"];
	for "_i" from 1 to 1 do {_player addItemToBackpack "NORTH_Kasapanos4kg_mag";};
};

getSmokes = {
	params ["_player"];
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_M43SmokeGrenade_mag";};
};

getRifle = {
	params ["_player"];

	private _rol = _player getVariable "rol";

	switch (_rol) do {
		case "srg": { 
			_player spawn getVest_rif_srg;
		};
		case "pio": { 
			_player spawn getVest_rif_pio;
		};
		case "hmg_a": { 
			_player spawn getVest_hmg_a;
		};
		default { 
			_player spawn getVest_rif_sld;
		};
	};

	sleep 1;

	_wp = selectRandom[
		"NORTH_fin_M27",
		"NORTH_fin_m27rv",
		"NORTH_fin_M28",
		"NORTH_fin_M28",
		"NORTH_fin_M28_30",
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

getSmg = {
	params ["_player"];

	private _rol = _player getVariable "rol";
	private _type = "s";
	private _wp = "NORTH_kp31";

	switch (_rol) do {
		case "srg": { 
			if (random 1 < 0.2) then { _type = "r"; };
			[_player, _type] spawn getVest_smg_srg;
		};
		case "pio": { 
			if (random 1 < 0.4) then { _type = "r"; };
			[_player, _type] spawn getVest_smg_pio;
		};
		default { 
			if (random 1 < 0.2) then { _type = "r"; };
			[_player, _type] spawn getVest_smg_sld;
		};
	};

	if (_type == "s") then {
		_wp = selectRandom ["NORTH_kp31", "NORTH_SIG_M1920"]
	};
	sleep 1;

	switch (_wp) do {
		case "NORTH_kp31": { 
			_player addWeapon "NORTH_kp31";
			if (_type == "s") then {
				_player addPrimaryWeaponItem "NORTH_50rnd_kp31_mag";
				for "_i" from 1 to 3 do { _player addItemToVest "NORTH_50rnd_kp31_mag"; };
			} else {
				_player addPrimaryWeaponItem "NORTH_71rnd_kp31_mag";
				for "_i" from 1 to 3 do { _player addItemToVest "NORTH_71rnd_kp31_mag"; };
			};			
		};
		case "NORTH_SIG_M1920": { 
			_player addWeapon "NORTH_SIG_M1920";
			_player addPrimaryWeaponItem "NORTH_50rnd_SIG_M1920_mag";
			for "_i" from 1 to 3 do { _player addItemToVest "NORTH_50rnd_SIG_M1920_mag"; };				
		};
		default { };
	};
};

getHMG = {
	params ["_player"];

	_player spawn getVest_hmg;

	sleep 1;

	_player addWeapon "NORTH_l35";
	_player addHandgunItem "NORTH_8Rnd_l35_mag";
	for "_i" from 1 to 5 do {_player addItemToVest "NORTH_8Rnd_l35_mag";};
	for "_i" from 1 to 2 do {_player addItemToVest "NORTH_M32Grenade_mag";};

	_player addWeapon "NORTH_SOV_Maxim_Gun_Bag_Lnr";
	for "_i" from 1 to 3 do {_player addItemToBackpack "NORTH_200Rnd_762mm_Maxim_Inf";};

	// para no agregarle 2 veces el script
	if (isNil {_player getVariable "hasHMG"}) then {
		_player addAction[
			"desplegar MG - Baja",
			{
				[3, [], {
					player removeWeapon "NORTH_SOV_Maxim_Gun_Bag_Lnr";

					_maxim = "NORTH_FIN_S_Maxim_41" createVehicle position player;

					private _offset = (vectorDir player) vectorMultiply 2; // Desplazamiento de 2 metros al frente
					private _newPos = (getPos player) vectorAdd _offset;
					_maxim setPos _newPos;
					_maxim setVectorDir (vectorDir player);
					//_maxim setPos [(getPos player select 0), (getPos player select 1) + 2, (getPos player select 2)];

					_maxim setVehicleAmmo 0;

					//_dir = vectorDir player;
					//_maxim setVectorDir _dir;

					_maxim addAction [ 
						"desmontar", 
						{ 
							[5, [], { }, {hint "Failure!"}, "Desmontando"] call ace_common_fnc_progressBar;
							sleep 5;
							player addWeapon "NORTH_SOV_Maxim_Gun_Bag_Lnr";
							_ammoLeft = magazinesAmmo (_this select 0); // [["ammoClassName", ammoLeft],...]
							// _ammoLeft = [["NORTH_200Rnd_762mm_Maxim_Inf", 70]];

							if (_ammoLeft select 0 select 1 > 0) then {
								player addMagazine ["NORTH_200Rnd_762mm_Maxim_Inf", _ammoLeft select 0 select 1];
							};
							deleteVehicle (_this select 0);
						} 
					];
				}, {hint "Failure!"}, "Desplegando"] call ace_common_fnc_progressBar;
			},nil,1.5,true,true,"","_target == _this",5,false,"",""
		];

		_player addAction[ 
			"desplegar MG - Medio", 
			{ 
				[3, [], { 
					player removeWeapon "NORTH_SOV_Maxim_Gun_Bag_Lnr"; 
				
					_maxim = "NORTH_FIN_S_41_Maxim_Medium" createVehicle position player; 
					
					//_maxim setPos [(getPos player select 0), (getPos player select 1) + 2, (getPos player select 2)];
					//_dir = vectorDir player;
					//_maxim setVectorDir _dir;

					private _offset = (vectorDir player) vectorMultiply 2; // Desplazamiento de 2 metros al frente
					private _newPos = (getPos player) vectorAdd _offset;
					_maxim setPos _newPos;
					_maxim setVectorDir (vectorDir player);

					_maxim setVehicleAmmo 0;				

					_maxim addAction [ 
						"desmontar", 
						{ 
							[5, [], { }, {hint "Failure!"}, "Desmontando"] call ace_common_fnc_progressBar;
							sleep 5;
							player addWeapon "NORTH_SOV_Maxim_Gun_Bag_Lnr";
							_ammoLeft = magazinesAmmo (_this select 0); // [["ammoClassName", ammoLeft],...]
							// _ammoLeft = [["NORTH_200Rnd_762mm_Maxim_Inf", 70]];

							if (_ammoLeft select 0 select 1 > 0) then {
								player addMagazine ["NORTH_200Rnd_762mm_Maxim_Inf", _ammoLeft select 0 select 1];
							};
							deleteVehicle (_this select 0);
						} 
					];
				}, {hint "Failure!"}, "Desplegando"] call ace_common_fnc_progressBar; 
			},nil,1.5,true,true,"","_target == _this",5,false,"","" 
		];

		_player setVariable ["hasHMG", true, true];
	};

};

getHAT = {
	params ["_player"];

	_player addWeapon "NORTH_Lahti_L39_Gun_Bag_Lnr";
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_10Rnd_20mm_L39_T_Inf";};

	if (isNil {_player getVariable "hasHAT"}) then {

		_player addAction[
			"desplegar AT",
			{
				[3, [], {
					player removeWeapon "NORTH_Lahti_L39_Gun_Bag_Lnr";

					_at = "NORTH_FIN_W_Lahti_L39" createVehicle position player;
					
					//_at setPos [(getPos player select 0), (getPos player select 1) + 2, (getPos player select 2)];
					//_dir = vectorDir player;
					//_at setVectorDir _dir;

					private _offset = (vectorDir player) vectorMultiply 2; // Desplazamiento de 2 metros al frente
					private _newPos = (getPos player) vectorAdd _offset;
					_at setPos _newPos;
					_at setVectorDir (vectorDir player);

					_at setVehicleAmmo 0;

					_at addAction [ 
						"desmontar", 
						{ 
							[5, [], { }, {hint "Failure!"}, "Desmontando"] call ace_common_fnc_progressBar;
							sleep 5;
							player addWeapon "NORTH_Lahti_L39_Gun_Bag_Lnr";
							_ammoLeft = magazinesAmmo (_this select 0); // [["ammoClassName", ammoLeft],...]
							// _ammoLeft = [["NORTH_10Rnd_20mm_L39_T_Inf", 4]];

							if (_ammoLeft select 0 select 1 > 0) then {
								player addMagazine ["NORTH_10Rnd_20mm_L39_T_Inf", _ammoLeft select 0 select 1];
							};
							deleteVehicle (_this select 0);
						} 
					];
				}, {hint "Failure!"}, "Desplegando"] call ace_common_fnc_progressBar;
			},nil,1.5,true,true,"","_target == _this",5,false,"",""
		];
		_player setVariable ["hasHAT", true, true];
	};
};

getL26 = {
	params ["_player"];

	_player addVest "V_NORTH_FIN_LMG_2";
	sleep 1;

	_player addWeapon "NORTH_ls26";
	_player addPrimaryWeaponItem "NORTH_20Rnd_ls26_mag_Tracer";
	
	for "_i" from 1 to 6 do { _player addItemToVest "NORTH_20Rnd_ls26_mag_Tracer"; };
	_player addItemToVest "NORTH_M43Grenade_mag";
	for "_i" from 1 to 18 do { _player addItemToBackpack "NORTH_20Rnd_ls26_mag_Tracer"; };
};

getMadsen = {
	params ["_player"];

	_player addVest "V_NORTH_FIN_LMG_2";
	sleep 1;

	_player addWeapon "NORTH_Madsen1922";
	_player addPrimaryWeaponItem "NORTH_25rnd_Madsen1922_mag";
	
	for "_i" from 1 to 6 do { _player addItemToVest "NORTH_25rnd_Madsen1922_mag"; };
	_player addItemToVest "NORTH_M43Grenade_mag";
	for "_i" from 1 to 13 do { _player addItemToBackpack "NORTH_25rnd_Madsen1922_mag"; };

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