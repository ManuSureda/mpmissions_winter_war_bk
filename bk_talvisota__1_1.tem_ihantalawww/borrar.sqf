O_G_Soldier_exp_F
O_G_Soldier_F
O_G_Soldier_LAT2_F
O_G_Soldier_LAT_F
O_G_Soldier_unarmed_F
O_G_Soldier_lite_F
O_G_Soldier_AR_F
O_G_Soldier_GL_F
O_G_engineer_F
O_G_Soldier_TL_F
O_G_Soldier_SL_F
O_G_medic_F
O_G_officer_F
O_G_Soldier_A_F
O_G_Survivor_F
O_G_Soldier_M_F
O_G_Sharpshooter_F


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




// this addWeapon "EAW_Type89_Discharger";
// this addSecondaryWeaponItem "EAW_Type89_Grenade_HE";

_unit addGoggles "G_mapcase";
"EAW_Type90_RifleKit_Medic"
//--------------------------------------------------------------------
china_50_winter_wapons
//-----------------------------



//---------------------------
china_giveVest_smg_rounded
china_giveVest_smg_straight
china_giveVest_rifle
china_giveVest_ar
//---------------------------
china_give_boltRifle
china_give_autoRifle
china_give_smg_straight
china_give_smg_rounded
china_give_mg
china_give_ar
china_give_c96
china_give_at
china_give_sniper




O_G_Soldier_exp_F
O_G_Soldier_F
O_G_Soldier_LAT2_F
O_G_Soldier_LAT_F
O_G_Soldier_unarmed_F
O_G_Soldier_lite_F
O_G_Soldier_AR_F
O_G_Soldier_GL_F
O_G_engineer_F
O_G_Soldier_TL_F
O_G_Soldier_SL_F
O_G_medic_F
O_G_officer_F
O_G_Soldier_A_F
O_G_Survivor_F
O_G_Soldier_M_F
O_G_Sharpshooter_F


playSound3D ["zsn_thunderershort", null, false, ];


[
	["1_spw_1"],
	["1_des_1"], 
	east, 
  	flag_1_1_1, 
	6, 
	10, 
	SAC_UDS_O_G_Soldiers,
	[15,20,30], 
  	300, 
	30,
  	5
] spawn SAC_fnc_waveAttack;
[
	["1_spw_2"],
	["1_des_2"], 
	east, 
  	flag_1_1_2, 
	6, 
	10, 
	SAC_UDS_O_G_Soldiers,
	[15,20,30], 
  	300, 
	30,
  	5
] spawn SAC_fnc_waveAttack;
[
	["1_spw_3"],
	["1_des_3"], 
	east, 
  	flag_1_1_3, 
	6, 
	10, 
	SAC_UDS_O_G_Soldiers,
	[15,20,30], 
  	300, 
	30,
  	5
] spawn SAC_fnc_waveAttack;

"_spawnMarkersNameArray", 
"_destinyMarkersNameArray", 
"_side", 
"_endFlag", 
["_minUnits", 6], 
["_maxUnits", 10], 
["_enemyArray", SAC_UDS_O_G_Soldiers],
["_wpTimeout",[0,0,0]], 
["_wavesDelay", 300], 
["_deathTimeOut", 0], 
["_maxWaves", 0]

SAC_fnc_waveAttack = 
{
  params["_spawnMarkersNameArray", "_destinyMarkersNameArray", "_side", 
  "_endFlag", ["_minUnits", 6], ["_maxUnits", 10], ["_enemyArray", SAC_UDS_O_G_Soldiers],
  ["_wpTimeout",[0,0,0]], 
  ["_wavesDelay", 300], 
  ["_deathTimeOut", 0], 
  ["_maxWaves", 0]];

  //_deathTimeOut: al morir toda una wave, espera esa cantidad de tiempo para espawnear la siguiente

  if (!isServer) exitWith {};

  _wavesCount = 0; 

  while {!isNil "_endFlag" && alive _endFlag } do {
    
    _wavesCount = _wavesCount + 1;

    if (_maxWaves > 0 && _wavesCount > _maxWaves) then {
        deleteVehicle _endFlag;
    } else {
        _unitsQuantity = [_minUnits, _maxUnits] call BIS_fnc_randomInt;
        _spawnMarker = selectRandom _spawnMarkersNameArray;

        _group = createGroup [_side, true];

        for "_i" from 0 to _unitsQuantity do {
            _soldier = selectRandom _enemyArray;
            _pos = getMarkerPos _spawnMarker;
            _unit = _group createUnit [_soldier, _pos, [], 1, "NONE"];
            sleep 0.3;
            [_unit] call SAC_GEAR_applyLoadoutByClass;
        };

        [_group] call SAC_fnc_setSkills;

        _group setBehaviourStrong "AWARE";
        _group setCombatMode "GREEN";
        _group setFormation "LINE";

        {
          sleep 0.2;
          _destinyPos = getMarkerPos _x;
          _wp = _group addWaypoint [_destinyPos, 1];
          _wp setWaypointTimeout _wpTimeout;
        } forEach _destinyMarkersNameArray;

        _actualDelay = 0;

        while { _actualDelay < _wavesDelay } do {
          sleep 10;

          if ({(alive _x) && !(_x getVariable ["ACE_isUnconscious", false])} count units _group <= 1) then {
			if ((_actualDelay + _deathTimeOut) < _wavesDelay) then {
	            sleep _deathTimeOut;
			};
            _actualDelay = _wavesDelay;
          } else {
            _actualDelay = _actualDelay + 10;
          };
        };
    };
  };
};


//"Sh_82mm_AMOS"
//"Sh_155mm_AMOS"
[
"a_10","a_11","a_12","a_13","a_14","a_15","a_16","a_17","a_18","a_19",
"a_20","a_21","a_22","a_23","a_24","a_25","a_26","a_27","a_28","a_29",
"a_30","a_31","a_32","a_33","a_34","a_35","a_36","a_37","a_38","a_39"
]

[
	[
	"a_40","4_31","a_42","a_43","a_44","a_45","a_46","a_47","a_48","a_49"
	],
	"Sh_155mm_AMOS",
	0.9,
	1.2
] spawn SAC_fnc_artilleryAttack;
[
	[
	"a_10","a_11","a_12","a_13","a_14","a_15","a_16","a_17","a_18","a_19"
	],
	"Sh_155mm_AMOS",
	0.3,
	0.9
] spawn SAC_fnc_artilleryAttack;
[
	[
	"a_20","a_21","a_22","a_23","a_24","a_25","a_26","a_27","a_28","a_29"
	],
	"Sh_155mm_AMOS",
	0.3,
	0.9
] spawn SAC_fnc_artilleryAttack;
[
	[
	"a_30","a_31","a_32","a_33","a_34","a_35","a_36","a_37","a_38","a_39"
	],
	"Sh_155mm_AMOS",
	0.3,
	0.9
] spawn SAC_fnc_artilleryAttack;

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

[
["_markersNamesArray"],
"_ammo",
_minSleep,
_maxSleep,
] spawn SAC_fnc_artilleryAttack;










// --------------------------------------------------------------------------------------------------
params["_spawnMarkersNameArray", "_destinyMarkersNameArray", "_side", 
  "_endFlag", ["_minUnits", 6], ["_maxUnits", 10], ["_enemyArray", SAC_UDS_O_G_Soldiers],
  ["_wpTimeout",[0,0,0]], 
  ["_wavesDelay", 300], 
  ["_deathTimeOut", 0], 
  ["_maxWaves", 0]];

[
	"_spawnMarkersNameArray", 
	"_destinyMarkersNameArray", 
	"_side", 
	"_endFlag", 
	["_minUnits", 6], 
	["_maxUnits", 10], 
	["_enemyArray", SAC_UDS_O_G_Soldiers],
	["_wpTimeout",[0,0,0]], 
	["_wavesDelay", 300], 
	["_deathTimeOut", 0], 
	["_maxWaves", 0]
] spawn SAC_fnc_waveAttack;



  
[ 
 ["1_spw_1"], 
 ["1_des_1", "1_des_end"],  
 east,  
 flag_1_1_3,  
 6,  
 10,  
 SAC_UDS_O_G_Soldiers, 
 [15,20,30],  
 300,  
 30, 
 5 
] spawn SAC_fnc_waveAttack; 
[ 
 ["1_spw_2"], 
 ["1_des_2", "1_des_end"],  
 east,  
 flag_1_1_4,  
 6,  
 10,  
 SAC_UDS_O_G_Soldiers, 
 [15,20,30],  
 300,  
 30, 
 5 
] spawn SAC_fnc_waveAttack; 
[ 
 ["1_spw_4","1_spw_5"], 
 ["1_des_end"],  
 east,  
 flag_1_1_6,  
 4,  
 6,  
 ["O_soldier_Melee"], 
 [15,20,30],  
 300,  
 30, 
 4 
] spawn SAC_fnc_waveAttack;





["2_spwn_1_2", "2_des_2_1", "2_des_2_2"],
["2_spwn_1_3", "2_des_3_1", "2_des_3_2"]


["2_spwn_1_1", "2_des_1_1", "2_des_1_2"],
["2_spwn_1_4", "2_des_4_1", "2_des_4_2"]
[
	[
		["2_spwn_1_2", "2_des_2_1", "2_des_2_2", "2_des_end"],
		["2_spwn_1_3", "2_des_3_1", "2_des_3_2", "2_des_end"]
	],
	east,
	flag_2_1_1,
	6, 10, SAC_UDS_O_G_Soldiers,
	[15,20,30], 300, 20, 5
] spawn SAC_fnc_waveAttack_v2;

[
	[
		["2_spwn_1_1", "2_des_1_1", "2_des_1_2", "2_des_end"],
		["2_spwn_1_4", "2_des_4_1", "2_des_4_2", "2_des_end"]
	],
	east,
	flag_2_1_2,
	6, 10, SAC_UDS_O_G_Soldiers,
	[15,20,30], 300, 20, 5
] spawn SAC_fnc_waveAttack_v2;

 = 
{
  // ahora _markersNameArray toma el select 0 como spawn y el resto como waypoints 
  params["_markersNameArray", "_side", "_endFlag", 
  ["_minUnits", 6], ["_maxUnits", 10], ["_enemyArray", SAC_UDS_O_G_Soldiers],
  ["_wpTimeout",[0,0,0]], 
  ["_wavesDelay", 300], 
  ["_deathTimeOut", 0], 
  ["_maxWaves", 0]];

[ 
 [ 
  ["4_spwn_1_1", "4_des_1_1", "4_des_1_2", "4_des_end"], 
  ["4_spwn_1_2", "4_des_1_1", "4_des_1_2", "4_des_end"] 
 ], 
 east, 
 flag_4_1_1, 
 6, 10, SAC_UDS_O_G_Soldiers, 
 [15,20,30], 300, 20, 3 
] spawn SAC_fnc_waveAttack_v2; 

7 al 12

1 al 6


[ 
 [ 
  ["a_1", "d_1", "d_2", "d_end"]
 ], 
 east, 
 flag_1, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [10,10,10], 300, 5, -1 
] spawn SAC_fnc_waveAttack_v2; 
[ 
 [ 
  ["a_2", "d_1", "d_2", "d_end"]
 ], 
 east, 
 flag_1, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [10,10,10], 300, 5, -1 
] spawn SAC_fnc_waveAttack_v2; 
[ 
 [ 
  ["a_3", "d_1", "d_2", "d_end"]
 ], 
 east, 
 flag_1, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [10,10,10], 300, 5, -1 
] spawn SAC_fnc_waveAttack_v2; 

[ 
 [ 
  ["a_4", "d_3", "d_4", "d_end"]
 ], 
 east, 
 flag_1, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [10,10,10], 300, 5, -1 
] spawn SAC_fnc_waveAttack_v2; 
[ 
 [ 
  ["a_5", "d_3", "d_4", "d_end"]
 ], 
 east, 
 flag_1, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [10,10,10], 300, 5, -1 
] spawn SAC_fnc_waveAttack_v2; 
[ 
 [ 
  ["a_6", "d_3", "d_4", "d_end"]
 ], 
 east, 
 flag_1, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [10,10,10], 300, 5, -1 
] spawn SAC_fnc_waveAttack_v2; 

[ 
 [ 
  ["a_7", "d_end"]
 ], 
 east, 
 flag_1, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [10,10,10], 300, 5, -1 
] spawn SAC_fnc_waveAttack_v2; 
[ 
 [ 
  ["a_8", "d_end"]
 ], 
 east, 
 flag_1, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [10,10,10], 300, 5, -1 
] spawn SAC_fnc_waveAttack_v2; 



[ 
 [ 
  ["4_spwn_1_1", "4_des_1_1", "4_des_1_2", "4_des_end"], 
  ["4_spwn_1_2", "4_des_1_1", "4_des_1_2", "4_des_end"], 
  ["4_spwn_1_3", "4_des_1_3", "4_des_1_4", "4_des_end"]
 ], 
 east, 
 flag_4_end, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [40,40,40], 300, 40, -1 
] spawn SAC_fnc_waveAttack_v2; 

[ 
 [ 
  ["4_spwn_1_4", "4_des_1_3", "4_des_1_4", "4_des_end"],
  ["4_spwn_1_5", "4_des_1_5", "4_des_1_6", "4_des_end"], 
  ["4_spwn_1_6", "4_des_1_5", "4_des_1_6", "4_des_end"] 
 ], 
 east, 
 flag_4_end, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [40,40,40], 300, 40, -1 
] spawn SAC_fnc_waveAttack_v2; 
 
[ 
 [ 
  ["4_spwn_1_7", "4_des_1_7", "4_des_1_8", "4_des_end"],
  ["4_spwn_1_8", "4_des_1_7", "4_des_1_8", "4_des_end"], 
  ["4_spwn_1_9", "4_des_1_9", "4_des_1_10", "4_des_end"] 
 ], 
 east, 
 flag_4_end, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [40,40,40], 300, 40, -1 
] spawn SAC_fnc_waveAttack_v2; 

[ 
 [ 
  ["4_spwn_1_10", "4_des_1_9", "4_des_1_10", "4_des_end"],
  ["4_spwn_1_11", "4_des_1_11", "4_des_1_12", "4_des_end"],
  ["4_spwn_1_12", "4_des_1_11", "4_des_1_12", "4_des_end"]
 ], 
 east, 
 flag_4_end, 
 5, 7, SAC_UDS_O_G_Soldiers, 
 [40,40,40], 300, 40, -1 
] spawn SAC_fnc_waveAttack_v2; 












[  
 [  
  ["3_spwn_1_9", "3_des_1_7", "3_des_end"] 
 ],  
 east,  
 flag_3_2_5,  
 2, 3, ["O_soldier_Melee"],  
 [0,0,0], 300, 20, 3  
] spawn SAC_fnc_waveAttack_v2;