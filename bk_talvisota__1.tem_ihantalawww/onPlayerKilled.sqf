//player setVariable["Saved_Loadout",getUnitLoadout player];

[player, [missionNamespace, "inventory_var"]] call BIS_fnc_saveInventory;

player unassignItem "ItemAndroid";
player removeItem "ItemAndroid";

player unassignItem "ItemMicroDAGR";
player removeItem "ItemMicroDAGR";