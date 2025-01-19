getUniform_srg
getUniform_pri
getUniform_sld

getVest_med
getVest_rif_srg
getVest_pioneer
getVest_rif_sld

getBasicEquipment

getRifle
getSniper
getFl

BACKPACK_SLD
BACKPACK_ENG
BACKPACK_MG
BACKPACK_MED
BACKPACK_RO
BACKPACK_FL


// https://forums.bohemia.net/forums/topic/171557-radio-sound-files-from-hq/
playSound3D [
		"\a3\dubbing_f\modules\supports\artillery_acknowledged.ogg", 
		player, 
		false
		];





mochila
"NORTH_fin_BreadBag",
"NORTH_fin_BreadBag2",
"NORTH_fin_BreadBag3",
"NORTH_fin_GasmaskBag",
"NORTH_SOV_Gasmaskbag",

eng
"NORTH_fin_Sipuli",

mg
"NORTH_fin_LS26Bag",

med
"NORTH_fin_MedicNCOBag",

radio PROBAR
"NORTH_fin_Kyynel",


lanzallamas
"41_Flammenwerfer_Balloons"

chalecos
medic
"V_NORTH_FIN_Generic_4",

fusilero
"V_NORTH_FIN_Rifleman_10",
"V_NORTH_FIN_Rifleman_7",
"V_NORTH_FIN_Rifleman_6",
"V_NORTH_FIN_Rifleman_5",
"V_NORTH_FIN_Rifleman_4",
"V_NORTH_FIN_Rifleman_3",
"V_NORTH_FIN_Rifleman_9",
"V_NORTH_FIN_Pioneer_1",
"V_NORTH_FIN_Rifleman_1",


casco
"H_NORTH_FIN_M39_furhat_open",
"H_NORTH_FIN_M39_furhat_open_2",
"H_NORTH_FIN_M39_furhat_1",
"H_NORTH_FIN_M39_furhat_2",
"H_NORTH_FIN_M39_furhat_3",
"H_NORTH_FIN_M39_furhat_4",
"H_NORTH_FIN_M39_furhat_5",

"H_NORTH_FIN_M16_Helmet_Winter_Whitewash",
"H_NORTH_FIN_M16_Helmet_Winter_Whitewash_2",
"H_NORTH_FIN_M16_Helmet_Winter_Camo",
"H_NORTH_FIN_M16_Helmet_Winter_Camo_2",
"H_NORTH_FIN_M16_Helmet_Winter",
"H_NORTH_FIN_M16_Helmet_Winter_2",

"H_NORTH_FIN_M39_furhat_fancy_officer",

uniforme
"H_NORTH_Workercap_Bl", "H_NORTH_Workercap_G",
"U_NORTH_CIV_Wool_1",
"U_NORTH_CIV_Wool_4",
"U_NORTH_CIV_Wool_5",
"U_NORTH_CIV_Wool_7",

"H_NORTH_Workercap_R",
"U_NORTH_CIV_Wool_2",
"U_NORTH_CIV_Wool_6",

"H_NORTH_Workercap",
"U_NORTH_CIV_Wool_3",


"U_NORTH_FIN_M36_W_Uniform_Private",
"U_NORTH_FIN_M36_W_Uniform_Private_2",
"U_NORTH_FIN_M36_W_Uniform_Private_3",
"U_NORTH_FIN_M36_W_Uniform_Private_4",
"U_NORTH_FIN_M36_W_Uniform_Private_5",
"U_NORTH_FIN_M36_W_Uniform_Private_6",
"U_NORTH_FIN_M36_W_Uniform_INF_Private",
"U_NORTH_FIN_M36_W_Uniform_INF_Private_2",

"U_NORTH_FIN_M36_W_Uniform_INF_CPL",
"U_NORTH_FIN_M36_W_Uniform_INF_CPL_2",
"U_NORTH_FIN_M36_W_Uniform_INF_Private_1CL",
"U_NORTH_FIN_M36_W_Uniform_INF_Private_1CL_2",

"U_NORTH_FIN_M36_W_Uniform_INF_SGT",


this addAction [
 "Soldado",
 {
	[player] spawn dressAs_rifleman;
 }, nil, 1.5, true, true, "", "true", 7
];

this addAction [
 "Cabo",
 {
	[player] spawn dressAs_private;
 }, nil, 1.5, true, true, "", "true", 7
];

this addAction [
 "Sargento",
 {
	[player] spawn dressAs_sargent;
 }, nil, 1.5, true, true, "", "true", 7
];