clearGear = {
	params["_player"];

	removeAllWeapons _player;
	removeAllItems _player;
	removeAllAssignedItems _player;
	removeUniform _player;
	removeVest _player;
	removeBackpack _player;
	removeHeadgear _player;
	removeGoggles _player;

	_player linkItem selectRandom GLOVES;
};

dressAs_sld = {
	params["_player"];

	_player setVariable ["rol", "sld", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_sld;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_SLD;
	 
	sleep 0.5; 

	[_player] spawn getEquipment_basic;
	sleep 0.5; 
	
	_player spawn getFrags;
	_player spawn getMolotovs;
};

dressAs_pio = {
	params["_player"];

	_player setVariable ["rol", "pio", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_pio;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_PIO;
	sleep 0.5;
	 

	[_player] spawn getEquipment_basic;
	sleep 0.5;
	
	[_player] spawn getEquipment_pio;
};
// this addItemToUniform "ZSN_TrenchWhistle";
// this addItemToUniform "ZSN_Whistle";
dressAs_pri = {
	params["_player"];

	_player setVariable ["rol", "pri", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_pri;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_SLD;
	sleep 0.5;
	 

	[_player] spawn getEquipment_basic;
	sleep 0.5;

	[_player] spawn getEquipment_pri;
	sleep 0.5;

	_player spawn getFrags;
	_player spawn getMolotovs;
};

dressAs_srg = {
	params["_player"];

	_player setVariable ["rol", "srg", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_srg;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_SLD;
	sleep 0.5;

	[_player] spawn getEquipment_basic;
	sleep 0.5;
	[_player] spawn getEquipment_srg;
	sleep 0.5;

	[_player] spawn getFrags;
	[_player] spawn getMolotovs;
	[_player] spawn getSmokes;

	_player addWeapon "NORTH_l35";
	_player addHandgunItem "NORTH_8Rnd_l35_mag";
	for "_i" from 1 to 2 do {_player addItemToBackpack "NORTH_8Rnd_l35_mag";};
};

dressAs_med = {
	params["_player"];

	_player setVariable ["rol", "med", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_med;
	_player addGoggles "G_NORTH_FIN_Medicalarmband";
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_MED;
	sleep 0.5;

	[_player] spawn getEquipment_med;
};

dressAs_par = {
	params["_player"];

	_player setVariable ["rol", "par", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_sld;
	_player addGoggles "G_NORTH_FIN_Medicalarmband";
	sleep 0.5;
	_player addBackpack "NORTH_fin_MedicBag";
	sleep 0.5;

	[_player] spawn getEquipment_par;
};

dressAs_HMG = {
	params["_player"];

	_player setVariable ["rol", "hmg", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_pri;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_HMG;
	sleep 0.5;

	[_player] spawn getEquipment_basic;
};

dressAs_HMG_A = {
	params["_player"];

	_player setVariable ["rol", "hmg_a", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_sld;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_HMG_A;
	sleep 0.5;

	[_player] spawn getEquipment_basic;
	sleep 0.5;
	[_player] spawn getEquipment_hmg_a;  
	// gives 2 ammo boxes + 2 frags + 2 molotovs 
	// and adds action to deploy box with maxim supplys
};

dressAs_HAT = {
	params["_player"];

	_player setVariable ["rol", "hat", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_pri;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_HAT;
	sleep 0.5;

	[_player] spawn getEquipment_basic;
	sleep 0.5;	
	[_player] spawn getHAT; // adds script to deploy "light" at 
};

dressAs_HAT_A = {
	params["_player"];

	_player setVariable ["rol", "hat_a", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_sld;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_HAT_A;
	sleep 0.5;

	[_player] spawn getEquipment_basic;
	sleep 0.5;
	[_player] spawn getEquipment_hat_a; // adds hat_a script + ammo for hat
};

dressAs_L26 = {
	params["_player"];

	_player setVariable ["rol", "l26", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_pri;
	sleep 0.5;
	_player addBackpack "NORTH_fin_LS26Bag";
	sleep 0.5;

	[_player] spawn getEquipment_basic;
};

dressAs_L26_A = {
	params["_player"];

	_player setVariable ["rol", "l26_a", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_sld;
	sleep 0.5;
	_player addBackpack "NORTH_fin_LS26Bag";
	sleep 0.5;

	[_player] spawn getEquipment_basic;
	[_player] spawn getEquipment_l26_a;
};

dressAs_MAD = {
	params["_player"];

	_player setVariable ["rol", "mad", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_pri;	
	sleep 0.5;
	_player addBackpack "NORTH_nor_MadsenBag";
	sleep 0.5;

	[_player] spawn getEquipment_basic;
};

dressAs_MAD_A = {
	params["_player"];

	_player setVariable ["rol", "mad_a", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_sld;
	sleep 0.5;
	_player addBackpack "NORTH_nor_MadsenBag";
	sleep 0.5;

	[_player] spawn getEquipment_basic;
	sleep 0.5;
	[_player] spawn getEquipment_basic;
};

dressAs_ro = {
	params["_player"];

	_player setVariable ["rol", "ro", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_sld;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_RO;
	sleep 0.5;

	[_player] spawn getEquipment_basic;
	sleep 0.5;
	
	_player addGoggles "G_LIB_GER_Headset";

	_player addItemToUniform "ZSN_TrenchWhistle";
};

dressAs_sni = {
	params["_player"];

	_player setVariable ["rol", "sni", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_sni;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_SLD;
	sleep 0.5;

	[_player] spawn getEquipment_basic;
	sleep 0.5;
	[_player] spawn getFrags;
	[_player] spawn getMolotovs;
};

dressAs_eng = {
	params["_player"];

	_player setVariable ["rol", "eng", true];

	[_player] spawn clearGear;
	sleep 0.5;

	[_player] spawn getUniform_sld;
	sleep 0.5;
	_player addBackpack selectRandom BACKPACK_ENG;
	sleep 0.5;

	[_player] spawn getEquipment_basic;
	sleep 0.5;
	[_player] spawn getEquipment_eng;	
};