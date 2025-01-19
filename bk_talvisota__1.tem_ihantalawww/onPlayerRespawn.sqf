params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

_oldUnit setPos [0,0,0]; //lo saca de un vehiculo si murio a bordo
deleteVehicle _oldUnit;

if  (!scriptdone SAC_TEL_managerHandle) then {terminate SAC_TEL_managerHandle; sleep 1};

hint (parseText "<t color='#00FFFF' size='1.2'><br/>Tienes 5 minutos para usar Reconnect Teleport.<br/><br/></t>");
SAC_TEL_allow = true;

SAC_TEL_managerHandle = 6 spawn SAC_TEL_manager;

//Responear con equipo
/*removeAllWeapons player;
removeGoggles player;
removeHeadgear player;
removeVest player;
removeUniform player;
removeAllAssignedItems player;
clearAllItemsFromBackpack player;
removeBackpack player;
player setUnitLoadout(player getVariable["Saved_Loadout",[]]);*/

[player, [missionNamespace, "inventory_var"]] call BIS_fnc_loadInventory;