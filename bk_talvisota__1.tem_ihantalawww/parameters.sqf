SAC_UDS_unitsProfile = "china_50_winter"; 
SAC_SQUAD_loadoutProfile = "NONE"; 
SAC_GEAR_B_loadoutProfile = "NONE"; 
SAC_GEAR_O_loadoutProfile = "NONE"; 
SAC_GEAR_O_G_loadoutProfile = "china_50_summer"; 
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
SAC_UDS_O_G_vehicleProfile = "china_50_winter_V_G"; 
SAC_UDS_C_vehicleProfile = "korea_50_summer_V_civ";
SAC_UDS_weaponColor = "BLACK"; 

COP_TAC_interval = 5;
COP_TAC_dynamic_greenzones = true;
COP_TAC_intervalVariation = 0;
COP_TAC_delay = 1;
COP_TAC_groupsPerRun = 2;
COP_TAC_groupsPerRunVariation = 2;
COP_TAC_maxGroupsTAC = 25;
COP_TAC_responseTypesSquematicRegular = ["INF_FOOT", 1];
COP_TAC_responseTypesSquematicMilitia = ["INF_FOOT", 10];
COP_TAC_markerNamesRegular = ["TAC_TARGET_REGULAR", "TAC_TARGET"]; 
COP_TAC_markerNamesMilitia = ["TAC_TARGET_MILITIA", "TAC_TARGET"];
COP_TAC_playersAsTargets = true;
COP_TAC_playersAsTargets_prob = 0.25;
COP_TAC_dynamicGreenzonesTTL = 21;

COP_IPS_patrols_count = 1;
COP_IPS_interval = 4;
COP_IPS_trackFlyingPlayers = false;

COP_DGS_groups_count = 1;

// CAMBIAAAAR// CAMBIAAAAR// CAMBIAAAAR// CAMBIAAAAR// CAMBIAAAAR// CAMBIAAAAR// CAMBIAAAAR "UNARMED", 20, "ARMED_SOFT", 10, "APC", 5
COP_MTS_trafficTypesSquematic = ["UNARMED", 20]; // CAMBIAAAAR "UNARMED", 20, "ARMED_SOFT", 10, "APC", 5
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
// call SAC_interact_handleRevealNotifications_1;
SAC_COP_reveal_createDiaryEntry = true;
SAC_COP_reveal_1_flag = false;
SAC_COP_reveal_diaryEntrySubject = "newIntel";//do not change
SAC_COP_reveal_diaryEntryDisplayName = "SCRIPT";
SAC_COP_reveal_diaryEntryTitle = "USO DEL SCRIPT";
SAC_COP_reveal_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'>
Recuerden que en esta serie de misiones NO hay zeus, es decir, lo que haga y como se comporte la IA no depende de mí, sino del servidor.<br/>
<br/>
Si estamos fuera de una zona segura (el spawn) el script genera: <br/>
   -  trafico militar: autos/camiones random andando por carreteras.<br/>
   -  trafico civil. <br/>
   -  patrullas random: una patrulla con un patron random, es decir, puede que nos la crucemos, puede que no. (no están alerta y no saben donde estamos). <br/>
   -  si entran en combate la IA puede pedir refuerzos, estos a su vez son aleatorios: pueden pedir infantería, infantería motorizada, APC, IFV, Tanques o infantería heli-transportada. Cada x tiempo se genera una cierta pausa de refuerzos, para que no sean infinitos, pero al mismo tiempo, si se quedan infinitamente en el área eventualmente esa pausa se quita y vuelven a aparecer más refuerzos. <br/>
<br/>
RESPAWN: <br/>
<br/>
   Si mueren tienen una espera de 5 minutos, una vez que re aparecen, tienen 5 minutos para apretar control + T, eso les abrirá una lista con todos los miembros de su unidad VIVOS, si seleccionan cualquiera de esos nombres los tele transporta a esa unidad especifica. <br/>
<br/>
   Esto puede modificarse dependiendo de la misión, si hay re inserción aérea, por vehiculo, o si juntan a mucha gente en el espawn y prefieren ir a pie/vehiculo etc etc. Depende de la misión y el momento. La idea es tener esto para que no te quedes solo en la base al pedo sin nadie que te haga re inserción (como no hay Zeus tampoco te puedo re insertar con tp) <br/>
<br/>
  Si pasan más de 5 minutos y no te hiciste tp avísame por el chat y te traigo a mi posición. 
</t>";

SAC_COP_reveal_useSpecialSystemChatText = true;
SAC_COP_reveal_specialSystemChatText = "Revisa tu mapa y tu diario.";

// call SAC_interact_handleRevealNotifications_2;
SAC_COP_reveal_2_flag = false;
SAC_COP_reveal_2_createDiaryEntry = true;
SAC_COP_reveal_2_diaryEntrySubject = "newIntel";//do not change
SAC_COP_reveal_2_diaryEntryDisplayName = "SCRIPT";
SAC_COP_reveal_2_diaryEntryTitle = "CONTROLES DEL SCRIPT";
SAC_COP_reveal_2_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'><br></br>
CONTROLES DEL SCRIPT<br/>
<br/>
   -  TP: control + t<br/>
   -  view distance: control + u<br/>
   -  abrir arsenal: (mirando el objeto) U. <br/>
   -  desbloquear vehiculo: (mirando al vehiculo) U. <br/>
   -  interrogar civil: (mirando al civil) U. <br/>

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
08 de junio del 2023. <br></br>
Novogorsk - Oblast de Zaporiyia. <br></br>
47º Brigada mecanizada independiente. - 25º Batallón de Asalto.<br></br>
<br></br>
Op.  Sturmmann. <br></br>
<br></br>
	Hace ya casi un siglo las potencias militares europeas se encontraron a sí mismas estancadas en una guerra de trincheras sin salida, donde cada metro ganado por el uso de tácticas o mera artillería, era recuperado por el enemigo utilizando las mismas tácticas con la misma eficacia. Con el tiempo los alemanes desarrollarían la idea de las compañías de “Sturmtruppen”. Estas compañías estaban especializadas en asaltos concretos, precisos y extremadamente violentos, haciendo especial énfasis en las tácticas de infiltración. Casi 100 años más tarde, sus tácticas se probarían igual de efectivas como necesarias. <br></br>
<br></br>
Contexto:<br></br>
	<br></br>
	El pasado 4 de junio las fuerzas armadas lanzaron una gran contraofensiva con la intención de tomar Melitopol, en la costa del mar Azov, con combates principalmente en los oblasts de Donetsk y Zaporiyia.<br></br>
	Si bien la ofensiva fue planeada para inicios de la primavera, debido a varios factores, tanto meteorológicos, como demoras en la entrega de armamento y equipos, la ofensiva sufrió de constantes retrasos. Todo ese tiempo fue bien aprovechado por el bando invasor, quien fortifico toda la línea de frente como pocas veces se ha visto en la historia. Fortificaciones, trincheras interminables, dientes de dragón, erizos checos, fosas anti tanque y un sinfín de minas componen lo que hoy conocemos como “línea Surovikin”. Los primeros días de la ofensiva representaron un elevado costo material para Ucrania, pasando ésta a un tipo de ataque más metódico y por lo tanto, lento. De esta forma se logra minimizar el costo en vidas humanas, pero se pierde la posibilidad de explotar cualquier rotura en el frente. Sumado a todo eso, los rusos, por alguna razón que no comprendemos, no están utilizando la profundidad de sus defensas a su favor, retirándose y permitiendo que nosotros suframos las bajas, por lo contrario, envían tropas blindadas a taponar cualquier tipo de brecha en la línea de frente. Por esta razón se nos ha encomendado la tarea de realizar una brecha en el frente de Novogorsk. <br></br>
Los grupos de reconocimiento han detectado un punto débil en las defensas rusas, una estrecha franja de tierra que no fue debidamente minada. Se concentrarán frente a dicho punto débil durante la noche, deberán acercarse lo máximo que les sea posible a la trinchera enemiga, y comenzar el asalto final justo antes del amanecer, para así reducir al máximo la capacidad de respuesta enemiga, así como el fuego de su artillería.<br></br>
Si logran abrirse paso a través de la línea enemiga, deberán despejar las dos rutas principales que conectan con la ciudad. <br></br>
<br></br>
Objetivos:<br></br>
	<br></br>
 - Infiltrarse antes del amanecer.<br></br>
 - Tomar la iglesia de Novogorsk.<br></br>
 -  Despejar las rutas de acceso. <br></br>
 - Alcanzar la intersección vidnobinsk-vyazino-loyarsk y despejar la zona.<br></br>
 - Tomar la posición “zhukova” en solnevny y neutralizar toda presencia enemiga.<br></br>
	

<br></br>
<br><br/>
Equipamiento: <br></br>
- Drones AT o Mavic, (PERO solo hasta después de la infiltración)<br></br>
Caballero y Lancer (cada escuadra): <br></br>
 - (los CHAD van sin mira B) )<br></br>
 - 1 MG pesada + 1 MG ligera. <br></br>
 - 1 rpg-7 con municion frag (granadero) + 1 con municion AT. <br></br>
 - descartables. <br></br>
 - cargas de demolición + kit de desactivación + herramientas. <br></br>
Armas: <br></br>
 - MG de Apoyo: PKP / PKM<br></br>
 - MG de Asalto: RPK<br></br>
 - Tirador: SVD (mira soviética), ASS-Vall, SR3<br></br>
 - Granadero: sin GL, RPG con munición frag. <br></br>
 - AT: rpg (podemos ver alguno americano, pero nada guiado como el javelin) y descartable <br></br>
  - Fusiles: <br></br>
  - AK-74 / 74u / 103/ 105 / AKM<br></br>
  - M16, M4.<br></br>
  - FAL<br></br>
  - SCAR-H<br></br>
</t>";

SAC_COP_reveal_3_useSpecialSystemChatText = false;
SAC_COP_reveal_3_specialSystemChatText = ".";

// call SAC_interact_handleRevealNotifications_4;
SAC_COP_reveal_4_flag = false;
SAC_COP_reveal_4_createDiaryEntry = true;
SAC_COP_reveal_4_diaryEntrySubject = "newIntel3";//do not change
SAC_COP_reveal_4_diaryEntryDisplayName = "Estado";
SAC_COP_reveal_4_diaryEntryTitle = "Situacion";
SAC_COP_reveal_4_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'>
*mensaje de radio*<br/>
HQ: Retirada a la línea Baker.
</t>";

SAC_COP_reveal_4_useSpecialSystemChatText = false;
SAC_COP_reveal_4_specialSystemChatText = ".";

// call SAC_interact_handleRevealNotifications_5;
SAC_COP_reveal_5_flag = false;
SAC_COP_reveal_5_createDiaryEntry = true;
SAC_COP_reveal_5_diaryEntrySubject = "newIntel3";//do not change
SAC_COP_reveal_5_diaryEntryDisplayName = "Estado 2";
SAC_COP_reveal_5_diaryEntryTitle = "Situacion";
SAC_COP_reveal_5_diaryEntryDescription = "<t color='#FFFFFF' size='1.1'>
*mensaje de radio*<br/>
HQ: Retirada a la línea Charlie.
</t>";

SAC_COP_reveal_5_useSpecialSystemChatText = false;
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
