getEquipment_basic = {
	params ["_player"];

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

getEquipment_pio = {
	params ["_player"];

	for "_i" from 1 to 3 do {_player addItemToBackpack "NORTH_Kasapanos4kg_mag";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_molotov";};
	for "_i" from 1 to 3 do {_player addItemToBackpack "NORTH_M32Grenade_mag";};
};

getEquipment_pri = {
	params ["_player"];

	_player addItemToUniform "ZSN_TrenchWhistle";
};

getEquipment_srg = {
	params ["_player"];

	_player addItemToUniform "ZSN_Whistle";
	_player addItemToUniform "ZSN_TrenchWhistle";
	_player addWeapon "NORTH_Binocular_Huet"; 

	_player spawn getDeployBikeAction;
};

getDeployBikeAction = {
	params ["_player"];

	// para no agregarle 2 veces el script
	if (isNil {_player getVariable "hasDeployBike"}) then {
		_player addAction[
			"desplegar bici",
			{
				[1.5, [], {
					_bike = "fow_v_truppenfahrrad_ger_heer" createVehicle position player;
					/*
					_bike setPos [(getPos player select 0), (getPos player select 1) + 3, (getPos player select 2)];
					_dir = vectorDir player;
					_bike setVectorDir _dir;
					*/
					// Obtener posición frente al jugador
					private _offset = (vectorDir player) vectorMultiply 2; // Desplazamiento de 2 metros al frente
					private _newPos = (getPos player) vectorAdd _offset;
					_bike setPos _newPos;
					
					_bike setVectorDir (vectorDir player);
				}, {hint "Failure!"}, "Desplegando"] call ace_common_fnc_progressBar;
			},nil,1.5,true,true,"","_target == _this",5,false,"",""
		];
		_player setVariable ["hasDeployBike", true, true];
	};

};

getEquipment_med = {
	params ["_player"];

	_player addItemToUniform "ACE_EarPlugs";
	for "_i" from 1 to 30 do {_player addItemToUniform "ACE_packingBandage";};
	for "_i" from 1 to 10 do {_player addItemToUniform "ACE_elasticBandage";};
	for "_i" from 1 to 5 do  {_player addItemToUniform "ACE_quikclot";};
	for "_i" from 1 to 2 do  {_player addItemToUniform "ACE_tourniquet";};
	for "_i" from 1 to 4 do  {_player addItemToUniform "kat_chestSeal";};
	for "_i" from 1 to 4 do  {_player addItemToUniform "ACE_splint";};
	for "_i" from 1 to 10 do {_player addItemToUniform "kat_IV_16";};
	for "_i" from 1 to 2 do  {_player addItemToUniform "ACE_painkillers";};
	for "_i" from 1 to 10 do {_player addItemToBackpack "ACE_plasmaIV_500";};
	_player addItemToBackpack "kat_accuvac";
	_player addItemToBackpack "kat_pocketBVM";
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_guedel";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "kat_EACA";};
	for "_i" from 1 to 6 do {_player addItemToBackpack "ACE_epinephrine";};
	_player addItemToBackpack "kat_stethoscope";
	for "_i" from 1 to 8 do {_player addItemToBackpack "kat_ketamine";};
	for "_i" from 1 to 3 do {_player addItemToBackpack "kat_aatKit";};
	_player addItemToBackpack "ACE_surgicalKit";
	for "_i" from 1 to 6 do {_player addItemToBackpack "ACE_morphine";};
	for "_i" from 1 to 6 do {_player addItemToBackpack "kat_naloxone";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_nitroglycerin";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_norepinephrine";};
	_player addItemToBackpack "kat_Pulseoximeter";
	for "_i" from 1 to 4 do  {_player addItemToBackpack "kat_larynx";};
	for "_i" from 1 to 5 do  {_player addItemToBackpack "ACE_salineIV_500";};
	for "_i" from 1 to 47 do {_player addItemToBackpack "ACE_packingBandage";};
	_player addItemToBackpack "kat_oxygenTank_300";
	for "_i" from 1 to 3 do  {_player addItemToBackpack "kat_Carbonate";};		

	_player linkItem "ItemMap";
	_player linkItem "ItemCompass";
	_player linkItem "ItemWatch";
};

// reemplaza 47 vendajes de la mochila por 1 granada
getEquipment_par = {
	params ["_player"];

	_player addItemToUniform "ACE_EarPlugs";
	for "_i" from 1 to 30 do {_player addItemToUniform "ACE_packingBandage";};
	for "_i" from 1 to 10 do {_player addItemToUniform "ACE_elasticBandage";};
	for "_i" from 1 to 5 do  {_player addItemToUniform "ACE_quikclot";};
	for "_i" from 1 to 2 do  {_player addItemToUniform "ACE_tourniquet";};
	for "_i" from 1 to 4 do  {_player addItemToUniform "kat_chestSeal";};
	for "_i" from 1 to 4 do  {_player addItemToUniform "ACE_splint";};
	for "_i" from 1 to 10 do {_player addItemToUniform "kat_IV_16";};
	for "_i" from 1 to 2 do  {_player addItemToUniform "ACE_painkillers";};
	for "_i" from 1 to 10 do {_player addItemToBackpack "ACE_plasmaIV_500";};
	_player addItemToBackpack "kat_accuvac";
	_player addItemToBackpack "kat_pocketBVM";
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_guedel";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "kat_EACA";};
	for "_i" from 1 to 6 do {_player addItemToBackpack "ACE_epinephrine";};
	_player addItemToBackpack "kat_stethoscope";
	for "_i" from 1 to 8 do {_player addItemToBackpack "kat_ketamine";};
	for "_i" from 1 to 3 do {_player addItemToBackpack "kat_aatKit";};
	_player addItemToBackpack "ACE_surgicalKit";
	for "_i" from 1 to 6 do {_player addItemToBackpack "ACE_morphine";};
	for "_i" from 1 to 6 do {_player addItemToBackpack "kat_naloxone";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_nitroglycerin";};
	for "_i" from 1 to 4 do {_player addItemToBackpack "kat_norepinephrine";};
	_player addItemToBackpack "kat_Pulseoximeter";
	for "_i" from 1 to 4 do  {_player addItemToBackpack "kat_larynx";};
	for "_i" from 1 to 5 do  {_player addItemToBackpack "ACE_salineIV_500";};
	_player addItemToBackpack "NORTH_M43Grenade_mag";
	_player addItemToBackpack "kat_oxygenTank_300";
	for "_i" from 1 to 3 do  {_player addItemToBackpack "kat_Carbonate";};

	_player linkItem "ItemMap";
	_player linkItem "ItemCompass";
	_player linkItem "ItemWatch";
};

getEquipment_hmg_a = {
	params ["_player"];

	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_200Rnd_762mm_Maxim_Inf";};
	_player spawn getFrags;
	_player spawn getMolotovs;

	_player addWeapon "NORTH_Binocular_Huet"; 

	_player addAction[
		"desplegar municion MG",
		{           
			// params ["_target", "_caller", "_actionId", "_arguments"];

			[3, [], {
				_box = "NORTH_molotov_crate" createVehicle position player; 
				//_box setPos [(getPos player select 0), (getPos player select 1) + 2, (getPos player select 2)]; 

				private _offset = (vectorDir player) vectorMultiply 2; // Desplazamiento de 2 metros al frente
				private _newPos = (getPos player) vectorAdd _offset;
				_box setPos _newPos;
				_box setVectorDir (vectorDir player);

				_box addItemCargoGlobal ["NORTH_200Rnd_762mm_Maxim_Inf", 3];
			}, {hint "Failure!"}, "Desplegando"] call ace_common_fnc_progressBar;

			// despues de usar, se elimina la accion
			(_this select 0) removeaction (_this select 2); // 0 -> _target y 2 -> _actionId
		},nil,1.5,true,true,"","_target == _this",5,false,"",""
	];
};

getEquipment_hat_a = {
	params ["_player"];

	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_10Rnd_20mm_L39_T_Inf";};
	_player spawn getFrags;
	_player spawn getMolotovs;

	_player addWeapon "NORTH_Binocular_Huet"; 

	_player addAction[
		"desplegar municion AT",
		{           
			// params ["_target", "_caller", "_actionId", "_arguments"];

			[3, [], {
				_box = "NORTH_molotov_crate" createVehicle position player; 

				// _box setPos [(getPos player select 0), (getPos player select 1) + 2, (getPos player select 2)]; 
				
				private _offset = (vectorDir player) vectorMultiply 2; // Desplazamiento de 2 metros al frente
				private _newPos = (getPos player) vectorAdd _offset;
				_box setPos _newPos;
				_box setVectorDir (vectorDir player);

				_box addItemCargoGlobal ["NORTH_10Rnd_20mm_L39_T_Inf", 3];

			}, {hint "Failure!"}, "Desplegando"] call ace_common_fnc_progressBar;

			(_this select 0) removeaction (_this select 2); // 0 -> _target y 2 -> _actionId
		},nil,1.5,true,true,"","_target == _this",5,false,"",""
	];
};

getEquipment_l26_a = {
	params ["_player"];

	for "_i" from 1 to 18 do { _player addItemToBackpack "NORTH_25rnd_Madsen1922_mag"; };
};

getEquipment_mad_a = {
	params ["_player"];

	for "_i" from 1 to 13 do { _player addItemToBackpack "NORTH_25rnd_Madsen1922_mag"; };
};

getEquipment_eng = {
	params ["_player"];

	_player addItemToBackpack "ACE_LIB_FireCord";
	_player addItemToBackpack "ACE_LIB_LadungPM";
	_player addItemToBackpack "ACE_DefusalKit";
	for "_i" from 1 to 2 do {_player addItemToBackpack "LIB_US_M1A1_ATMINE_mag";};
	for "_i" from 1 to 2 do {_player addItemToBackpack "LIB_Ladung_Big_MINE_mag";};
	for "_i" from 1 to 5 do {_player addItemToBackpack "LIB_Ladung_Small_MINE_mag";};
};