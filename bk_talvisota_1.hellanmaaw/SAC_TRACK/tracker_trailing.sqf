private ["_updateTime", "_command", "_colorOPFOR", "_colorBLUFOR", "_colorGUERR", "_colorCIV", "_handler", "_menUnits", "_marker", "_line1", "_title"];

_updateTime = _this select 0;
_command = _this select 1;

_colorOPFOR = "ColorRed";
_colorBLUFOR = "ColorBlue";
_colorGUERR = "ColorYellow";
_colorCIV = "ColorGreen";

//_handler = [1, "ON"] execVM "SAC_fnc\tracker.sqf";

if (_command == "ON") then {
	if (!SAC_tracker_ON) then {
		SAC_tracker_ON = true;
		_title  = "<t color='#ff0000' size='1.2' shadow='1' shadowColor='#000000' align='center'>SAC Tracker</t><br/><br/>";
		while {SAC_tracker_ON} do
		{

			_menUnits = allUnits;
			{
				_marker = createMarkerLocal[format["SAC_tracker_mr%1", diag_ticktime], position _x];
				_marker setMarkerShapeLocal "ICON";
				_marker setMarkerTypeLocal "DOT";
				_marker setMarkerSizeLocal [0.5, 0.5];
				switch (side _x) do {
					case east: {_marker setMarkerColorLocal _colorOPFOR};
					case west: {_marker setMarkerColorLocal _colorBLUFOR};
					case resistance: {_marker setMarkerColorLocal _colorGUERR};
					case civilian: {_marker setMarkerColorLocal _colorCIV};
					default {_marker setMarkerColorLocal "ColorBlack"};
				};
				sleep 0.1;
			} forEach _menUnits;
			
			_line1 = 
			format ["<t align='left'>East: %1</t><br/>", east countSide allUnits] +
			format ["<t align='left'>Resistance: %1</t><br/>", resistance countSide allUnits] +
			format ["<t align='left'>Civilian: %1</t><br/>", civilian countSide allUnits] +
			format ["<t align='left'>West: %1</t><br/>", west countSide allUnits] +
			format ["<t align='left'>Total: %1</t><br/>", count allUnits] +
			format ["<t align='left'>Dead: %1</t><br/>", count allDead] +
			format ["<t align='left'>Groups: %1</t><br/>", count allGroups] +
			format ["<t align='left'>Empty: %1</t><br/>", {(count units _x) == 0} count allGroups] +
			format ["<t align='left'>East: %1</t><br/>", east countSide allGroups] +
			format ["<t align='left'>Resistance: %1</t><br/>", resistance countSide allGroups] +
			format ["<t align='left'>Civilian: %1</t><br/>", civilian countSide allGroups] +
			format ["<t align='left'>West: %1</t><br/>", west countSide allGroups];
			hint parseText (_title + _line1);
			
			sleep _updateTime;
		};
	};
} else {
	SAC_tracker_ON = false;
};
