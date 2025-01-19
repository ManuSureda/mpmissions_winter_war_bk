if (!hasInterface) exitWith {};
waitUntil {!isNull player};


addMissionEventHandler ["Draw3D", {

	{

		//if ((_x != player) && {group _x == group player}) then {
		if (_x != player) then {
		
			if ((_x getVariable ["ACE_isUnconscious", false]) && {alive _x} && {group _x == group player}) then {
			//if (lifeState _x == "INCAPACITATED") then {
			
				_iSize = (0.5) - (0.01 / (player distance _x));
				//[texture, color, position, width, height, angle, text, shadow, textSize, font, textAlign, drawSideArrows]
				//drawIcon3D["\A3\ui_f\data\map\Markers\Military\arrow2_ca.paa", [0,0,1,1], getPosATLVisual _x, _iSize, _iSize, 180, "", 0, 1, "RobotoCondensed", "center", true];
				//drawIcon3D["\A3\ui_f\data\map\Markers\Military\circle_ca.paa", [0,0,1,1], getPosATLVisual _x, _iSize, _iSize, 0, "", 0, 1, "RobotoCondensed", "center", true];
				drawIcon3D["\A3\ui_f\data\igui\cfg\actions\heal_ca.paa", [0,0,1,1], getPosATLVisual _x, _iSize, _iSize, 0, "", 0, 1, "RobotoCondensed", "center", true];
			
			};
			
		};
		
	} forEach allPlayers;
	//} forEach allunits;

}];


systemChat "Downed Players Markers initialized.";
