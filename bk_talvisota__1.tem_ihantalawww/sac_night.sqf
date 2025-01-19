if (!isServer) exitwith {};

private ["_allPos", "_flarePos", "_flareObj", "_marker"];

//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitwith {"""SAC_FNC"" is not initialized in SAC_NIGHT." call SAC_fnc_MPhintC};
if (isnil "SAC_flares") exitwith {"""SAC_flares"" is not initialized in SAC_NIGHT." call SAC_fnc_MPhintC};

if (SAC_STUI && {!("flares" in _this)}) exitwith {};

if (!SAC_STUI) then {
	_marker = [[0, 0, 0], "ColorBlack", "", "", [50000, 50000], ["ELLIPSE", "Solid"]] call SAC_fnc_createMarker;

	if (call SAC_fnc_isNight) then {_marker setMarkeralpha 1} else {_marker setMarkeralpha 0};

	sleep 10;

	if (call SAC_fnc_isNight) then {_marker setMarkeralpha 1} else {_marker setMarkeralpha 0};

	sleep 10;

	if (call SAC_fnc_isNight) then {_marker setMarkeralpha 1} else {_marker setMarkeralpha 0};
};

while {true} do {

	sleep ((5 + floor random 3)*60);
	
	if (call SAC_fnc_isNight) then {
	
		if (!SAC_STUI) then {_marker setMarkeralpha 1};
		
		if ("flares" in _this) then {
		
			_allPos = [];
			
			{

				if ((side _x in [SAC_O_REGULAR_SIDE, SAC_O_MILITIA_SIDE]) && {alive leader _x} && {isNull objectParent leader _x}) then {
				
					_allPos pushBack getPos leader _x;
				
				};

			} forEach allGroups;
			
			if (count _allPos > 0) then {
			
				//Crear flare.
				_flarePos = selectRandom _allPos;
				_flareObj = (selectRandom SAC_flares) createVehicle [_flarePos select 0, _flarePos select 1, (_flarePos select 2) + 250];
				_flareObj setVelocity [wind select 0, wind select 1, -10];
				
			};
		};
		
	} else {
	
		if (!SAC_STUI) then {_marker setMarkeralpha 0};
	
	};

	
};
