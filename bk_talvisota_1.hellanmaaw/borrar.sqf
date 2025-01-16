for "_i" from 0 to (count waypoints convoy_2 - 1) do 
{ deleteWaypoint [convoy_2, 0]; };

{ deleteWaypoint _x } forEachReversed waypoints convoy_2; // Arma 3 v2.14+ only


convoy_2 setBehaviourStrong "SAFE";
c_2_g_1 setBehaviourStrong "SAFE";
c_2_g_2 setBehaviourStrong "SAFE";
c_2_g_3 setBehaviourStrong "SAFE";
c_2_g_4 setBehaviourStrong "SAFE";

0 spawn { 
  {  
    moveOut _x; 
    unassignVehicle _x; 
    sleep 0.3; 
  } forEach units c_3_g_1;  
  units c_3_g_1 allowGetIn false; 
}; 
0 spawn { 
  {  
    moveOut _x; 
    unassignVehicle _x; 
    sleep 0.3; 
  } forEach units c_3_g_2; 
  units c_3_g_2 allowGetIn false; 
}; 
0 spawn { 
  {  
    moveOut _x; 
    unassignVehicle _x; 
    sleep 0.3; 
  } forEach units c_3_g_3; 
  units c_3_g_3 allowGetIn false; 
}; 
0 spawn { 
  {  
    moveOut _x; 
    unassignVehicle _x; 
    sleep 0.3; 
  } forEach units c_3_g_4; 
  units c_3_g_4 allowGetIn false; 
};
0 spawn { 
  {  
    moveOut _x; 
    unassignVehicle _x; 
    sleep 0.3; 
  } forEach units c_3_g_5; 
  units c_3_g_5 allowGetIn false; 
};










1-10 al 1-10 a end_1
11-17 al 11-17 a end_2

1-3
4-6
7-10



[  
 [  
  ["2_spw_1", "2_des_1", "2_des_end_1"], 
  ["2_spw_2", "2_des_2", "2_des_end_1"],
  ["2_spw_3", "2_des_3", "2_des_end_1"]
 ],    
 f_2_w_1_1, 
 5, 9, SAC_UDS_O_G_Soldiers,  
 [15,20,30], 180, 60, 3  
] spawn SAC_fnc_waveAttack_v2; 
[  
 [  
  ["2_spw_4", "2_des_4", "2_des_end_1"], 
  ["2_spw_5", "2_des_5", "2_des_end_1"],
  ["2_spw_6", "2_des_6", "2_des_end_1"]
 ],    
 f_2_w_1_2, 
 5, 9, SAC_UDS_O_G_Soldiers,  
 [15,20,30], 180, 60, 3  
] spawn SAC_fnc_waveAttack_v2; 
[  
 [  
  ["2_spw_7", "2_des_7", "2_des_end_1"], 
  ["2_spw_8", "2_des_8", "2_des_end_1"],
  ["2_spw_9", "2_des_9", "2_des_end_1"],
  ["2_spw_10", "2_des_10", "2_des_end_1"]
 ],    
 f_2_w_1_3, 
 5, 9, SAC_UDS_O_G_Soldiers,  
 [15,20,30], 180, 60, 3  
] spawn SAC_fnc_waveAttack_v2; 




[  
 [  
  ["1_spw_2_1", "1_des_2_1", "1_des_2_2"], 
  ["1_spw_2_2", "1_des_2_1", "1_des_2_2"]
 ],    
 flag_1_2, 
 5, 9, SAC_UDS_O_G_Soldiers,  
 [15,20,30], 180, 30, 3  
] spawn SAC_fnc_waveAttack_v2; 
[  
 [  
  ["1_spw_3_1", "1_des_3_1", "1_des_3_2"], 
  ["1_spw_3_1", "1_des_3_3", "1_des_3_4"]
 ],    
 flag_1_3, 
 5, 9, SAC_UDS_O_G_Soldiers,  
 [15,20,30], 180, 30, 3  
] spawn SAC_fnc_waveAttack_v2; 

[  
 [  
  ["1_spw_1_1", "1_des_1_1", "1_des_1_2"], 
  ["1_spw_1_2", "1_des_1_1", "1_des_1_2"],

  ["1_spw_2_1", "1_des_2_1", "1_des_2_2"], 
  ["1_spw_2_2", "1_des_2_1", "1_des_2_2"],

  ["1_spw_3_1", "1_des_3_1", "1_des_3_2"], 
  ["1_spw_3_1", "1_des_3_3", "1_des_3_4"]
 ],    
 flag_1_4, 
 5, 9, SAC_UDS_O_G_Soldiers,  
 [15,20,30], 180, 60, -1  
] spawn SAC_fnc_waveAttack_v2; 



call SAC_interact_handleRevealNotifications_3;

"m_19" setMarkerAlpha 0;
"m_20" setMarkerAlpha 0;
"m_21" setMarkerAlpha 0;

"m_22" setMarkerAlpha 1;
"m_23" setMarkerAlpha 1;
"m_24" setMarkerAlpha 1;
"m_25" setMarkerAlpha 1;
"m_26" setMarkerAlpha 1;
"m_27" setMarkerAlpha 1;
"m_28" setMarkerAlpha 1;
"m_29" setMarkerAlpha 1;
"m_30" setMarkerAlpha 1;
"m_31" setMarkerAlpha 1;






"m_36" setMarkerAlpha 1; 
"m_37" setMarkerAlpha 1; 
"m_38" setMarkerAlpha 1; 
"m_39" setMarkerAlpha 1; 

"m_40" setMarkerAlpha 1; 
"m_41" setMarkerAlpha 1; 
"m_42" setMarkerAlpha 1; 
"m_43" setMarkerAlpha 1; 
"m_44" setMarkerAlpha 1; 
"m_45" setMarkerAlpha 1; 
"m_46" setMarkerAlpha 1; 
"m_47" setMarkerAlpha 1; 
"m_48" setMarkerAlpha 1; 
"m_49" setMarkerAlpha 1; 

"m_50" setMarkerAlpha 1; 
"m_51" setMarkerAlpha 1; 
"m_52" setMarkerAlpha 1; 
"m_53" setMarkerAlpha 1; 
"m_54" setMarkerAlpha 1; 
"m_55" setMarkerAlpha 1; 



"m_56" setMarkerAlpha 1; 
"m_57" setMarkerAlpha 1; 
"m_58" setMarkerAlpha 1; 
"m_59" setMarkerAlpha 1; 
"m_60" setMarkerAlpha 1; 
"m_61" setMarkerAlpha 1; 
"m_62" setMarkerAlpha 1; 
"m_63" setMarkerAlpha 1; 
"m_64" setMarkerAlpha 1; 
"m_65" setMarkerAlpha 1; 
"m_66" setMarkerAlpha 1; 


deleteVehicle f_2_w_1_1;
deleteVehicle f_2_w_1_2;
deleteVehicle f_2_w_1_3;

[
  [
    ["1_spw_1_1", "1_des_1_"]
  ]
] spawn SAC_fnc_waveAttack_v2;


0 spawn { 
 ["zsn_trenchlongfar", true] remoteExec ["BIS_fnc_playSound", 0];  
 sleep 5; 
 ["zsn_trenchshortshortlongfar", true] remoteExec ["BIS_fnc_playSound", 0]; 
 sleep 2; 

 [  
  [  
   ["1_spwn_1", "1_des_1", "1_des_end_1"], 
   ["1_spwn_2", "1_des_1", "1_des_end_1"], 
   ["1_spwn_3", "1_des_1", "1_des_end_1"] 
  ],  
  east,  
  flag_1_1, 
  4, 5, SAC_UDS_O_G_Soldiers,  
  [15,20,30], 180, 60, 2  
 ] spawn SAC_fnc_waveAttack_v2; 
 
 [  
  [  
   ["1_spwn_4", "1_des_4", "1_des_end_1"], 
   ["1_spwn_5", "1_des_5", "1_des_end_1"], 
   ["1_spwn_6", "1_des_6", "1_des_end_1"] 
  ],  
  east,  
  flag_1_2, 
  4, 5, SAC_UDS_O_G_Soldiers,  
  [15,20,30], 180, 60, -1  
 ] spawn SAC_fnc_waveAttack_v2; 
 
 [  
  [  
   ["1_spwn_7", "1_des_7", "1_des_end_1"], 
   ["1_spwn_8", "1_des_8", "1_des_end_1"],    
   ["1_spwn_9", "1_des_9", "1_des_end_1"] 
  ],  
  east,  
  flag_1_3, 
  5, 6, SAC_UDS_O_G_Soldiers,  
  [15,20,30], 180, 60, -1  
 ] spawn SAC_fnc_waveAttack_v2; 
 
 [  
  [  
   ["1_spwn_10", "1_des_end_1"] 
  ],  
  east,  
  flag_1_4, 
  5, 6, SAC_UDS_O_G_Soldiers,  
  [15,20,30], 180, 60, -1  
 ] spawn SAC_fnc_waveAttack_v2; 
 
 [  
  [   
   ["1_spwn_mele_1", "1_des_end_1"] 
  ],  
  east,  
  flag_1_5, 
  5, 6, ["O_soldier_Melee"],  
  [0,0,0], 180, 60, -1  
 ] spawn SAC_fnc_waveAttack_v2; 
};




SAC_fnc_waveAttack_v2 = 
{
  // ahora _markersNameArray toma el select 0 como spawn y el resto como waypoints 
  params["_arrayMarkersNameArray", "_side", "_endFlag", 
  ["_minUnits", 6], ["_maxUnits", 10], ["_enemyArray", SAC_UDS_O_G_Soldiers],
  ["_wpTimeout",[0,0,0]], 
  ["_wavesDelay", 300], 
  ["_deathTimeOut", 0], 
  ["_maxWaves", 0]];













[   
 [   
  ["2_spw_1", "2_des_1", "2_des_end_1"],  
  ["2_spw_2", "2_des_2", "2_des_end_1"], 
  ["2_spw_3", "2_des_3", "2_des_end_1"] 
 ],     
 f_2_w_2,  
 4, 6, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;  
[   
 [   
  ["2_spw_4", "2_des_4", "2_des_end_1"],  
  ["2_spw_5", "2_des_5", "2_des_end_1"], 
  ["2_spw_6", "2_des_6", "2_des_end_1"] 
 ],     
 f_2_w_2,  
 4, 6, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;  
[   
 [   
  ["2_spw_7", "2_des_7", "2_des_end_1"],  
  ["2_spw_8", "2_des_8", "2_des_end_1"], 
  ["2_spw_9", "2_des_9", "2_des_end_1"], 
  ["2_spw_10", "2_des_10", "2_des_end_1"] 
 ],     
 f_2_w_2,  
 4, 6, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2; 


8-10 a 1
11-14 a 2
15-17 a 2
[   
 [   
  ["2_spw_1", "2_des_1", "2_des_end_1"], 
  ["2_spw_2", "2_des_2", "2_des_end_1"], 
  ["2_spw_3", "2_des_3", "2_des_end_1"], 
  ["2_spw_4", "2_des_4", "2_des_end_1"], 
  ["2_spw_5", "2_des_5", "2_des_end_1"], 
  ["2_spw_6", "2_des_6", "2_des_end_1"], 
  ["2_spw_7", "2_des_7", "2_des_end_1"]
 ],     
 f_2_w_3_1,  
 5, 7, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2; 
[   
 [   
  ["2_spw_8", "2_des_8", "2_des_end_1"], 
  ["2_spw_9", "2_des_9", "2_des_end_1"], 
  ["2_spw_10", "2_des_10", "2_des_end_1"]
 ],     
 f_2_w_3_2,  
 4, 7, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;
[   
 [  
  ["2_spw_11", "2_des_11", "2_des_end_2"],
  ["2_spw_12", "2_des_12", "2_des_end_2"],
  ["2_spw_13", "2_des_13", "2_des_end_2"],
  ["2_spw_14", "2_des_14", "2_des_end_2"]
 ],     
 f_2_w_3_3,  
 4, 7, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;
[   
 [  
  ["2_spw_15", "2_des_15", "2_des_end_2"],
  ["2_spw_16", "2_des_16", "2_des_end_2"],
  ["2_spw_17", "2_des_17", "2_des_end_2"]
 ],     
 f_2_w_3_4,  
 4, 7, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;

call SAC_interact_handleRevealNotifications_5;
deleteVehicle f_2_w_3_1;
deleteVehicle f_2_w_3_2;
deleteVehicle f_2_w_3_3;
deleteVehicle f_2_w_3_4;
[   
 [  
  ["2_spw_11", "2_des_11", "2_des_end_2"],
  ["2_spw_12", "2_des_12", "2_des_end_2"],
  ["2_spw_13", "2_des_13", "2_des_end_2"],
  ["2_spw_14", "2_des_14", "2_des_end_2"]
 ],     
 f_2_w_3_5,  
 4, 7, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;
[   
 [  
  ["2_spw_15", "2_des_15", "2_des_end_2"],
  ["2_spw_16", "2_des_16", "2_des_end_2"],
  ["2_spw_17", "2_des_17", "2_des_end_2"]
 ],     
 f_2_w_3_5,  
 4, 7, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;


deleteVehicle f_2_w_3_5;
[   
 [  
  ["3_spw_1", "3_des_1", "3_des_end"],
  ["3_spw_2", "3_des_2", "3_des_end"],
  ["3_spw_3", "3_des_3", "3_des_end"]
 ],     
 f_3_w_1,  
 5, 7, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;
[   
 [  
  ["3_spw_4", "3_des_4", "3_des_end"],
  ["3_spw_5", "3_des_5", "3_des_end"],
  ["3_spw_6", "3_des_6", "3_des_end"]
 ],     
 f_3_w_2,  
 5, 7, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;
[   
 [  
  ["3_spw_7", "3_des_7", "3_des_end"],
  ["3_spw_8", "3_des_8", "3_des_end"],
  ["3_spw_9", "3_des_9", "3_des_end"]
 ],     
 f_3_w_3,  
 5, 7, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;
[   
 [  
  ["3_spw_10", "3_des_10", "3_des_end"],
  ["3_spw_11", "3_des_11", "3_des_end"],
  ["3_spw_12", "3_des_12", "3_des_end"]
 ],     
 f_3_w_4,  
 5, 7, SAC_UDS_O_G_Soldiers,   
 [15,20,30], 180, 60, -1   
] spawn SAC_fnc_waveAttack_v2;