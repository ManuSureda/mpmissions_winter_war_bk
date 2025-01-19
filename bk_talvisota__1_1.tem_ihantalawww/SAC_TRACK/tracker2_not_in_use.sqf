private ["_updateTime", "_command", "_colorOPFOR", "_colorBLUFOR", "_colorGUERR", "_colorCIV", "_handler", "_nromarkersMen",
 "_menUnits", "_i", "_markerName", "_markerStr", "_k"];

_updateTime = _this select 0;
_command = _this select 1;

_colorOPFOR = "ColorRed";
_colorBLUFOR = "ColorBlue";
_colorGUERR = "ColorYellow";
_colorCIV = "ColorGreen";

//_handler = [1, "ON"] execVM "SAC_fnc\tracker.sqf";

if (_command == "ON") then {
	if (!SAC_tracker_ON) then {
		_nromarkersMen = 0;
		SAC_tracker_ON = true;
		while {SAC_tracker_ON} do
		{
			if (_nromarkersMen == 0) then {
				_menUnits = allUnits;
				_i = 0;
				{
					_markerName = format["SAC_tracker_mr%1", _i + 1];
					_markerStr = createMarkerLocal[_markerName, position _x];
					_markerStr setMarkerShapeLocal "ICON";
					_markerName setMarkerTypeLocal "DOT";
					_markerName setMarkerSizeLocal [0.5, 0.5];
					switch (side _x) do {
						case east: {_markerName setMarkerColorLocal _colorOPFOR};
						case west: {_markerName setMarkerColorLocal _colorBLUFOR};
						case resistance: {_markerName setMarkerColorLocal _colorGUERR};
						case civilian: {_markerName setMarkerColorLocal _colorCIV};
						default {_markerName setMarkerColorLocal "ColorBlack"};
					};
					_i = _i + 1;
				} forEach _menUnits;
				_nromarkersMen = _i;
			} else	{
				for "_k" from 1 to _nromarkersMen do
				{
					deleteMarkerLocal format["SAC_tracker_mr%1",_k]
				};
				_nromarkersMen = 0;
			
				_menUnits = allUnits;
				_i = 0;
				{
					_markerName = format["SAC_tracker_mr%1",_i+1];
					_markerStr = createMarkerLocal[_markerName, position _x];
					_markerStr setMarkerShapeLocal "ICON";
					_markerName setMarkerTypeLocal "DOT";
					_markerName setMarkerSizeLocal [0.5, 0.5];
					switch (side _x) do {
						case east: {_markerName setMarkerColorLocal _colorOPFOR};
						case west: {_markerName setMarkerColorLocal _colorBLUFOR};
						case resistance: {_markerName setMarkerColorLocal _colorGUERR};
						case civilian: {_markerName setMarkerColorLocal _colorCIV};
						default {_markerName setMarkerColorLocal "ColorBlack"};
					};
					_i = _i + 1;
				} forEach _menUnits;
				_nromarkersMen = _i;
			};
			
			_eastMenAlive = east countSide allUnits;
			_civMenAlive = civilian countSide allUnits;
			_menDead = count allDeadMen;
			_groups = count allGroups;
			_emptyGroups = {(count units _x) == 0} count allGroups;
			hint format["%1,%2,%3,%4,%5", _eastMenAlive, _civMenAlive, _menDead, _groups, _emptyGroups];
			
			sleep _updateTime;
		};

		if (_nromarkersMen > 0) then
		{
			for "_k" from 1 to _nromarkersMen do
			{
				deleteMarkerLocal format["SAC_tracker_mr%1",_k]
			};
			_nromarkersMen = 0;
		};
	};
} else {
	SAC_tracker_ON = false;
};
