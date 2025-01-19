// [
// ["_markersNamesArray"],
// "_ammo",
// _minSleep,
// _maxSleep,
// ] spawn SAC_fnc_artilleryAttack;

sa_sounds = {

    ["zsn_trenchlongfar", true] call BIS_fnc_playSound;

    sleep 3;
    ["zsn_eld", true] call BIS_fnc_playSound;

    sleep 4;
    ["zsn_trenchlongfar", true] call BIS_fnc_playSound;
    sleep 3;
    ["zsn_eldupphor", true] call BIS_fnc_playSound;

    sleep 3;
    ["zsn_trenchshortshortlongfar", true] call BIS_fnc_playSound;

    sleep 3;
    ["zsn_trenchblow", true] call BIS_fnc_playSound;
    sleep 2;
    ["zsn_trenchblast2", true] call BIS_fnc_playSound;
    sleep 3;
    ["zsn_trenchlongfar", true] call BIS_fnc_playSound;

	hint "..--..";
};

// trench 1
sa_arty_1 = {
	[
		[
		"a_40","4_31","a_42","a_43","a_44","a_45","a_46","a_47","a_48","a_49"
		],
		"Sh_155mm_AMOS",
		0.9,
		1.2
	] spawn SAC_fnc_artilleryAttack;
	sleep 20;
	[
		[
		"a_10","a_11","a_12","a_13","a_14","a_15","a_16","a_17","a_18","a_19"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"a_20","a_21","a_22","a_23","a_24","a_25","a_26","a_27","a_28","a_29"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"a_30","a_31","a_32","a_33","a_34","a_35","a_36","a_37","a_38","a_39"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"a_10","a_11","a_12","a_13","a_14","a_15","a_16","a_17","a_18","a_19",
		"a_20","a_21","a_22","a_23","a_24","a_25","a_26","a_27","a_28","a_29",
		"a_30","a_31","a_32","a_33","a_34","a_35","a_36","a_37","a_38","a_39",
		"a_40","4_31","a_42","a_43","a_44","a_45","a_46","a_47","a_48","a_49"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;

};

sa_arty_2 = {
	[
		[
		"b_10","b_11","b_12","b_13","b_14","b_15","b_16","b_17","b_18","b_19"
		],
		"Sh_155mm_AMOS",
		0.9,
		1.2
	] spawn SAC_fnc_artilleryAttack;
	sleep 20;
	[
		[
		"b_40","4_31","b_42","b_43","b_44","b_45","b_46","b_47","b_48","b_49"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"b_20","b_21","b_22","b_23","b_24","b_25","b_26","b_27","b_28","b_29"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"b_30","b_31","b_32","b_33","b_34","b_35","b_36","b_37","b_38","b_39"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"b_10","b_11","b_12","b_13","b_14","b_15","b_16","b_17","b_18","b_19",
		"b_20","b_21","b_22","b_23","b_24","b_25","b_26","b_27","b_28","b_29",
		"b_30","b_31","b_32","b_33","b_34","b_35","b_36","b_37","b_38","b_39",
		"b_40","4_31","b_42","b_43","b_44","b_45","b_46","b_47","b_48","b_49"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
};

sa_arty_3 = {
	[
		[
		"c_10","c_11","c_12","c_13","c_14","c_15","c_16","c_17","c_18","c_19"
		],
		"Sh_155mm_AMOS",
		0.9,
		1.2
	] spawn SAC_fnc_artilleryAttack;
	sleep 20;
	[
		[
		"c_20","c_21","c_22","c_23","c_24","c_25","c_26","c_27","c_28","c_29"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"c_40","4_31","c_42","c_43","c_44","c_45","c_46","c_47","c_48","c_49"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"c_30","c_31","c_32","c_33","c_34","c_35","c_36","c_37","c_38","c_39"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"c_10","c_11","c_12","c_13","c_14","c_15","c_16","c_17","c_18","c_19",
		"c_20","c_21","c_22","c_23","c_24","c_25","c_26","c_27","c_28","c_29",
		"c_30","c_31","c_32","c_33","c_34","c_35","c_36","c_37","c_38","c_39",
		"c_40","4_31","c_42","c_43","c_44","c_45","c_46","c_47","c_48","c_49"
		],
		"Sh_155mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
};

sa_arty_4 = {
	[
		[
		"d_10","d_11","d_12","d_13","d_14","d_15","d_16","d_17","d_18","d_19"
		],
		"Sh_82mm_AMOS",
		0.9,
		1.2
	] spawn SAC_fnc_artilleryAttack;
	sleep 20;
	[
		[
		"d_20","d_21","d_22","d_23","d_24","d_25","d_26","d_27","d_28","d_29"
		],
		"Sh_82mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"d_40","4_31","d_42","d_43","d_44","d_45","d_46","d_47","d_48","d_49"
		],
		"Sh_82mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"d_30","d_31","d_32","d_33","d_34","d_35","d_36","d_37","d_38","d_39"
		],
		"Sh_82mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
	sleep 12;
	[
		[
		"d_10","d_11","d_12","d_13","d_14","d_15","d_16","d_17","d_18","d_19",
		"d_20","d_21","d_22","d_23","d_24","d_25","d_26","d_27","d_28","d_29",
		"d_30","d_31","d_32","d_33","d_34","d_35","d_36","d_37","d_38","d_39",
		"d_40","4_31","d_42","d_43","d_44","d_45","d_46","d_47","d_48","d_49"
		],
		"Sh_82mm_AMOS",
		0.3,
		0.9
	] spawn SAC_fnc_artilleryAttack;
};