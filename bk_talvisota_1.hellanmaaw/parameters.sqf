SAC_UDS_unitsProfile = "sov_w_39"; 
SAC_SQUAD_loadoutProfile = "NONE"; 
SAC_GEAR_B_loadoutProfile = "NONE"; 
SAC_GEAR_O_loadoutProfile = "NONE"; 
SAC_GEAR_O_G_loadoutProfile = "ADD_PRIM_MAGS"; 
GEAR_NVG = false; 
AMB_IED = false; 
CTS_ON = false; 
AMB_ON = false; 
ITS_ON = false; 
IPS_ON = true; 
DGS_ON = true; 
MTS_ON = false;

COP_visualCaching = true; 
COP_visualCaching_distance = 1500;

TAC_B_REGULAR = false; TAC_B_MILITIA = false;
TAC_O_REGULAR = false; TAC_O_MILITIA = true; 
SAC_UDS_O_vehicleProfile = "BIS_CSAT"; 
SAC_UDS_O_G_vehicleProfile = "sov_w_39_V_G"; 
SAC_UDS_C_vehicleProfile = "syrian_army_altis_uds_v_civ";
SAC_UDS_weaponColor = "BLACK"; 

COP_TAC_interval = 5;
COP_TAC_dynamic_greenzones = true;
COP_TAC_intervalVariation = 0;
COP_TAC_delay = 1;
COP_TAC_groupsPerRun = 2;
COP_TAC_groupsPerRunVariation = 2;
COP_TAC_maxGroupsTAC = 25;
COP_TAC_responseTypesSquematicRegular = ["INF_FOOT", 1];
COP_TAC_responseTypesSquematicMilitia = ["INF_FOOT", 60, "INF_VEHICLE", 10, "VEHICLE_ARMOR_APC", 10, 
										"VEHICLE_ARMOR_TANK", 20];
COP_TAC_markerNamesRegular = ["TAC_TARGET_REGULAR", "TAC_TARGET"]; 
COP_TAC_markerNamesMilitia = ["TAC_TARGET_MILITIA", "TAC_TARGET"];
COP_TAC_playersAsTargets = true;
COP_TAC_playersAsTargets_prob = 0.25;
COP_TAC_dynamicGreenzonesTTL = 21;

COP_IPS_patrols_count = 1;
COP_IPS_interval = 4;
COP_IPS_trackFlyingPlayers = false;

COP_DGS_groups_count = 1;

COP_MTS_trafficTypesSquematic = ["UNARMED", 20, "ARMED_SOFT", 10, "APC", 5];
COP_MTS_interval = 10; //recomended 10+
COP_MTS_trackFlyingPlayers = true;

COP_CTS_interval = 7;
COP_CTS_trackFlyingPlayers = false;

SAC_PLAYER_SIDE = west; //tiene que estar definido aca porque depende de cada misi�n -west(blufor) -east(opfor) -resistance(independent)

SAC_randomizeTime = false;

/*COP_TAC_responseTypesSquematicMilitia = [
"INF_FOOT": infanter�a a pie
"INF_VEHICLE": { //infanter�a en veh�culo (no artillado)
"INF_HELICOPTER": { //infanter�a en helic�ptero
"VEHICLE_NOARMOR": { //veh�culo artillado sin protecci�n, se puede deshabilitar con un rifle de asalto
"VEHICLE_ARMOR_APC": { //veh�culo artillado con protecci�n media, se necesita un explosivo para deshabilitarlo
"VEHICLE_ARMOR_IFV": { //mejor que un APC, puede ayudar a la infanter�a en la primera l�nea; t�picamente tiene orugas
"VEHICLE_ARMOR_TANK": { //veh�culo artillado con protecci�n completa, se necesita alto explosivo (javelin, PCML, titan, gunship)
]
*/


/**********************************************************************************************************
REVEAL config data
***********************************************************************************************************/
// call SAC_interact_handleRevealNotifications;
SAC_COP_reveal_createDiaryEntry = true;
SAC_COP_reveal_1_flag = false;
SAC_COP_reveal_diaryEntrySubject = "newIntel";//do not change
SAC_COP_reveal_diaryEntryDisplayName = "Situacion";
SAC_COP_reveal_diaryEntryTitle = "Informe del oficial";
SAC_COP_reveal_diaryEntryDescription = "<t color='#FFFFFF' size='1.1' align='left'><br/>
Oficial: ¡la situación es un caos absoluto!  toda la ciudad se ha vuelto loca, y nuestros vecinos 
se matan los unos a los otros <br/>
<br/>
Al comienzo de las operaciones un grupo fue enviado al hospital de Kavala para rescatar a nuestros 
hermanos retenidos allí dentro, pero entonces todo se fue a la mierda. Perdí todo tipo de contacto 
con la compañía, y no eh vuelto a ver a nadie de mi pelotón.  <br/>
<br/>
Lo último que llegue a escuchar por radio fue que Alexios, comandante de la 3º Brigada, convocaba a 
todas las fuerzas cercanas a reagruparse en el castillo de Kastro, en Kavala. <br/>
<br/>
Diríjanse allí, y de seguro recibirán nuevas órdenes, yo me quedare aquí para asistir a cualquier rezagado.  
</t>";

SAC_COP_reveal_useSpecialSystemChatText = true;
SAC_COP_reveal_specialSystemChatText = "Revisa tu mapa y tu diario.";

// call SAC_interact_handleRevealNotifications_2;
SAC_COP_reveal_2_flag = false;
SAC_COP_reveal_2_createDiaryEntry = true;
SAC_COP_reveal_2_diaryEntrySubject = "newIntel";//do not change
SAC_COP_reveal_2_diaryEntryDisplayName = "Situacion";
SAC_COP_reveal_2_diaryEntryTitle = "Actualizacion";
SAC_COP_reveal_2_diaryEntryDescription = "<t color='#FFFFFF' size='1.1' align='left'><br/>
HQ: Las fuerzas del norte tuvieron que replegarse. <br/>
Un nuevo pelotón se dirige a cubrir el sector sur. Retírense hacia el NW, pasando Kangas, hasta la posición PE Deonis. <br/>
Defiendan la posición, y embosquen cualquier convoy que pase por en dirección a Hoopaka.
</t>";

SAC_COP_reveal_2_useSpecialSystemChatText = true;
SAC_COP_reveal_2_specialSystemChatText = "Revisa tu mapa y tu diario.";


// call SAC_interact_handleRevealNotifications_3;
SAC_COP_reveal_3_flag = false;
SAC_COP_reveal_3_createDiaryEntry = true;
SAC_COP_reveal_3_diaryEntrySubject = "newIntel2";//do not change
SAC_COP_reveal_3_diaryEntryDisplayName = "Briefing";
SAC_COP_reveal_3_diaryEntryTitle = "Situacion";
SAC_COP_reveal_3_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'><br></br>
HQ: Elementos de reconocimiento nos alertan de un contingente enemigo aproximándose desde Huhtala. 
</t>";

SAC_COP_reveal_3_useSpecialSystemChatText = true;
SAC_COP_reveal_3_specialSystemChatText = ".";

// call SAC_interact_handleRevealNotifications_4;
SAC_COP_reveal_4_flag = false;
SAC_COP_reveal_4_createDiaryEntry = true;
SAC_COP_reveal_4_diaryEntrySubject = "newIntel3";//do not change
SAC_COP_reveal_4_diaryEntryDisplayName = "Estado";
SAC_COP_reveal_4_diaryEntryTitle = "Situacion";
SAC_COP_reveal_4_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'>
HQ: Las fuerzas del norte tuvieron que replegarse, y se esperan contactos bajando en dirección a Hoopaka. <br/>
Mantengan la posición hasta que se les ordene la retirada a Hoopaka.
</t>";

SAC_COP_reveal_4_useSpecialSystemChatText = true;
SAC_COP_reveal_4_specialSystemChatText = ".";

// call SAC_interact_handleRevealNotifications_5;
SAC_COP_reveal_5_flag = false;
SAC_COP_reveal_5_createDiaryEntry = true;
SAC_COP_reveal_5_diaryEntrySubject = "newIntel3";//do not change
SAC_COP_reveal_5_diaryEntryDisplayName = "Estado 2";
SAC_COP_reveal_5_diaryEntryTitle = "Situacion";
SAC_COP_reveal_5_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'>
HQ: Retírense a Hoopaka y defiendan el pueblo.
</t>";

SAC_COP_reveal_5_useSpecialSystemChatText = true;
SAC_COP_reveal_5_specialSystemChatText = ".";

// call SAC_interact_handleRevealNotifications_6;
SAC_COP_reveal_6_flag = false;
SAC_COP_reveal_6_createDiaryEntry = true;
SAC_COP_reveal_6_diaryEntrySubject = "newIntel3";//do not change
SAC_COP_reveal_6_diaryEntryDisplayName = "Estado 2";
SAC_COP_reveal_6_diaryEntryTitle = "Situacion";
SAC_COP_reveal_6_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'>
*mensaje de radio*<br/>
HQ: Retirada a la línea Dog.
</t>";

SAC_COP_reveal_6_useSpecialSystemChatText = false;
SAC_COP_reveal_6_specialSystemChatText = ".";

// call SAC_interact_handleRevealNotifications_7;
SAC_COP_reveal_7_flag = false;
SAC_COP_reveal_7_createDiaryEntry = true;
SAC_COP_reveal_7_diaryEntrySubject = "newIntel3";//do not change
SAC_COP_reveal_7_diaryEntryDisplayName = "Estado 2";
SAC_COP_reveal_7_diaryEntryTitle = "Situacion";
SAC_COP_reveal_7_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'>
HQ: situación critica<br/>
El 3º pelotón fue sobre pasado. <br/>
La compañía Fox a su izquierda no podrá contener el avance y se retira. <br/>
El 1º intento auxiliar al 3º pero encontraron presencia enemiga rodeando su posición. <br/>
Re agrúpense en la posición “Easy”, estarán rodeados!!! <br/>
Vamos a intentar conseguirles algo de artillería para abrirles paso, buena suerte!
</t>";

SAC_COP_reveal_7_useSpecialSystemChatText = false;
SAC_COP_reveal_7_specialSystemChatText = ".";

/**********************************************************************************************************
PASSWORDS SYSTEM config data
***********************************************************************************************************/
SAC_passwords_name = "Sistemas";
SAC_passwords_name_2 = "Dispositivo";
//SAC_passwords_name_3 = "Sitio 3";


// call SAC_interact_handleRevealNotifications_8;
SAC_COP_reveal_8_flag = false;
SAC_COP_reveal_8_createDiaryEntry = true;
SAC_COP_reveal_8_diaryEntrySubject = "newIntel3";//do not change
SAC_COP_reveal_8_diaryEntryDisplayName = "Estado 2";
SAC_COP_reveal_8_diaryEntryTitle = "Situacion";
SAC_COP_reveal_8_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'>
*mensaje de radio*<br/>
HQ: Retirada!<br/><br/>
Abandonen la línea Elizabeth y reagrúpense en Erika.
</t>";

SAC_COP_reveal_8_useSpecialSystemChatText = false;
SAC_COP_reveal_8_specialSystemChatText = ".";

/**********************************************************************************************************
PASSWORDS SYSTEM config data
***********************************************************************************************************/
SAC_passwords_name = "Sistemas";
SAC_passwords_name_2 = "Dispositivo";
//SAC_passwords_name_3 = "Sitio 3";

// call SAC_interact_handleRevealNotifications_9;
SAC_COP_reveal_9_flag = false;
SAC_COP_reveal_9_createDiaryEntry = true;
SAC_COP_reveal_9_diaryEntrySubject = "newIntel3";//do not change
SAC_COP_reveal_9_diaryEntryDisplayName = "Estado 2";
SAC_COP_reveal_9_diaryEntryTitle = "Situacion";
SAC_COP_reveal_9_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'>
*mensaje de radio*<br/>
HQ: Retirada!<br/><br/>
Abandonen la línea Erika y reagrúpense en El Alamo.
</t>";

SAC_COP_reveal_9_useSpecialSystemChatText = false;
SAC_COP_reveal_9_specialSystemChatText = ".";

/**********************************************************************************************************
PASSWORDS SYSTEM config data
***********************************************************************************************************/
SAC_passwords_name = "Sistemas";
SAC_passwords_name_2 = "Dispositivo";
//SAC_passwords_name_3 = "Sitio 3";

// call SAC_interact_handleRevealNotifications_10;
SAC_COP_reveal_10_flag = false;
SAC_COP_reveal_10_createDiaryEntry = true;
SAC_COP_reveal_10_diaryEntrySubject = "newIntel3";//do not change
SAC_COP_reveal_10_diaryEntryDisplayName = "Estado 2";
SAC_COP_reveal_10_diaryEntryTitle = "Situacion";
SAC_COP_reveal_10_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'>
*mensaje de radio*<br/>
HQ: El segundo batallón que se encontraba en el flanco derecho fue totalmente rebasado y la 3º división a su izquierda se retiró antes de lo previsto<br/>
Es de suponer que se encuentran rodeados.<br/>
Mantengan la posición, un pelotón de blindados se dirige a su posición para asistirlos.<br/>
Una vez contacten con ellos, síganlos hasta el punto de retirada.<br/><br/>
Buena suerte, y que dios los proteja. 
</t>";

SAC_COP_reveal_10_useSpecialSystemChatText = false;
SAC_COP_reveal_10_specialSystemChatText = ".";

/**********************************************************************************************************
PASSWORDS SYSTEM config data
***********************************************************************************************************/
SAC_passwords_name = "Sistemas";
SAC_passwords_name_2 = "Dispositivo";
//SAC_passwords_name_3 = "Sitio 3";
