/////////////////////////////////////////////////////////////////////////////////////////
// START getUnifrom - getVest - getBackpack
/////////////////////////////////////////////////////////////////////////////////////////
// start uniforms
getUniform_sld = {
	params ["_player"];

	if (random 1 < 0.55) then {
		_cap = selectRandom ["bl","bl","bl","gr"];
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

getUniform_pio = {
	params["_player"];

	_player spawn getUniform_sld;
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

getUniform_sni = {
	params ["_player"];

	_player forceAddUniform selectRandom UNIFORM_SNI;
	_player addHeadgear selectRandom HELMET_FUR_SLD;

	_player addGoggles selectRandom [
		"G_NORTH_FIN_Balaclava",
		"G_NORTH_FIN_Balaclava_2",
		"G_NORTH_FIN_Balaclava_3",
		"G_NORTH_FIN_Balaclava_4",
		"G_NORTH_FIN_Balaclava_5"
	];
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

getUniform_med = {
	params ["_player"];

	_player forceAddUniform selectRandom UNIFORM_PRI;
	if (random 1 < 0.4) then {
		_player addHeadgear selectRandom HELMET_M16;	
	} else {
		_player addHeadgear selectRandom HELMET_FUR_SLD;
	};
	
};
// end uniforms
// start vests 
getVest_rif_sld = {
	params ["_player"];
	_player addVest selectRandom VEST_RIF_SLD;
};

getVest_rif_pio = {
	params ["_player"];
	_player addVest selectRandom VEST_RIF_PIO;
};

getVest_rif_srg = {
	params ["_player"];
	_player addVest selectRandom VEST_RIF_SRG;
};

getVest_smg_sld = {
	params ["_player", "_type"];
	switch (_type) do {
		case "s": { 
			_player addVest selectRandom VEST_SMG_S_SLD;
		};
		default { 
			_player addVest selectRandom VEST_SMG_R_SLD;
		};
	};
	
};

getVest_smg_pio = {
	params ["_player", "_type"];
	switch (_type) do {
		case "s": { 
			_player addVest selectRandom VEST_SMG_S_PIO;
		};
		default { 
			_player addVest selectRandom VEST_SMG_R_PIO;
		};
	};
	
};

getVest_smg_srg = {
	params ["_player", "_type"];
	switch (_type) do {
		case "s": { 
			_player addVest selectRandom VEST_SMG_S_SRG;
		};
		default { 
			_player addVest selectRandom VEST_SMG_R_SRG;
		};
	};
	
};

getVest_hmg = {
	params ["_player"];
	_player addVest selectRandom VEST_PIS;
};

getVest_hmg_a = {
	params ["_player"];
	_player addVest selectRandom VEST_HMG_A;
};

// end vests 
/////////////////////////////////////////////////////////////////////////////////////////
// END getUnifrom - getVest - getBackpack
/////////////////////////////////////////////////////////////////////////////////////////
