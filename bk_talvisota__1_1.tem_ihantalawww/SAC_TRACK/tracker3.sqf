private ["_handler", "_updateTime", "_command", "_title", "_deleted", "_eastMenAlive", "_guerMenAlive", "_civMenAlive", "_menDead",
 "_groups", "_emptyGroups", "_line1", "_line2", "_line3", "_line4", "_line5", "_line6", "_line7", "_line8", "_marker", "_m"];


//_handler = [1, "ON"] execVM "SAC_fnc\tracker.sqf";

_updateTime = _this select 0;
_command = _this select 1;

if (_command == "ON") then {
	if (!SAC_tracker_ON) then {
		/*
		EYE 1.0
		Author: Zapat

		Shows all units on map in a relatively system friendly way.
		Dot: infantry
		Rectangle: ground vehicles
		Triangle: air vehicles

		Blue: west
		Red: east
		Black: civilian OR damaged in movement thus left vehicle

		Green: player
		Yellow: player's team
		*/

		//you can turn on and off the EYE by the following Global Variable 
		SAC_tracker_ON = true;


		//player sideChat "EYE is running";
		EYE_targets_obj = [];
		EYE_markers_str = [];

		//data handler
		[] spawn 
		{
			private ["_title", "_deleted", "_line1"];
			
			_title  = "<t color='#ff0000' size='1.3' shadow='1' shadowColor='#000000' align='center'>SAC Tracker</t><br/><br/>";
			
			while {SAC_tracker_ON} do
			{
				sleep 2;

				EYE_targets_obj = position player nearEntities [["Ship","LandVehicle","Air","CAManBase"], 50000];
				
				EYE_targets_str = [];
				{
					EYE_targets_str pushBack (format["%1",_x]);
				}foreach EYE_targets_obj;

				_deleted = EYE_markers_str - EYE_targets_str;

				{
					deleteMarkerLocal _x;
					EYE_markers_str = EYE_markers_str - [_x];
				}foreach _deleted;
				
				_line1 = 
				format ["<t align='left' size='1.3'>MEN</t><br/>"] +
				format ["<t align='left'>East: %1</t><br/>", count units east] +
				format ["<t align='left'>Resistance: %1</t><br/>", count units resistance] +
				format ["<t align='left'>Civilian: %1</t><br/>", count units civilian] +
				format ["<t align='left'>West: %1</t><br/>", count units west] +
				format ["<t align='left'>TOTAL: %1</t><br/>", count allUnits] +
				format ["<br/>"] +
				format ["<t align='left' size='1.3'>GROUPS</t><br/>"] +
				format ["<t align='left'>East: %1</t><br/>", count groups east] +
				format ["<t align='left'>Resistance: %1</t><br/>", count groups resistance] +
				format ["<t align='left'>Civilian: %1</t><br/>", count groups civilian] +
				format ["<t align='left'>West: %1</t><br/>", count groups west] +
				format ["<t align='left'>TOTAL: %1</t><br/>", count allGroups] +
				format ["<br/>"] +
				format ["<t align='left' size='1.3'>Dead Units: %1</t><br/>", count allDeadMen] +
				format ["<t align='left' size='1.3'>Dead Vehicles: %1</t><br/>", count allDead - count allDeadMen] +
				format ["<t align='left' size='1.3'>Empty Groups: %1</t><br/>", {(count units _x) == 0} count allGroups];
				hint parseText (_title + _line1);
				
			};
		
		};

		//visualiser
		[] spawn
		{
			private ["_marker", "_m"];
			
			while {SAC_tracker_ON} do
			{
				sleep 1;
				{
					if (!isNull _x) then
					{
						_marker = format["%1",_x];
						//create marker
						if (getMarkerType _marker == "") then
						{
							_m = createMarkerLocal[_marker,position _x];
							
							_m setMarkerShapeLocal "ICON";
							_m setMarkerSizeLocal [0.5, 0.5];
							
							if (_x isKindof "CAManBase") then {_m setMarkerTypeLocal "mil_dot_noshadow";};
							if (_x isKindof "Ship") then {_m setMarkerTypeLocal "mil_box_noshadow";};
							if (_x isKindof "LandVehicle") then {_m setMarkerTypeLocal "mil_box_noshadow";};                    
							if (_x isKindof "Air") then {_m setMarkerTypeLocal "mil_triangle_noshadow";};
							
							// if (side _x == east) then {_m setMarkerColorLocal "ColorRed";};
							// if (side _x == west) then {_m setMarkerColorLocal "ColorBlue";};
							
							switch (side _x) do {
								case east: {_m setMarkerColorLocal "ColorRed"};
								case west: {_m setMarkerColorLocal "ColorBlue"};
								case resistance: {_m setMarkerColorLocal "ColorYellow"};
								case civilian: {_m setMarkerColorLocal "ColorGreen"};
								default {_m setMarkerColorLocal "ColorBlack"};
							};
							
							//if (_x in units group player) then {_m setMarkerColorLocal "ColorYellow";};
							//if (_x == player) then {_m setMarkerColorLocal "ColorGreen";};

							EYE_markers_str pushBack _marker;
						}
						//update marker
						else
						{
							_marker setMarkerPosLocal position _x;
							if (getMarkerColor _marker != "ColorBlack" && (!alive _x || !canMove _x) ) then {_marker setMarkerColorLocal "ColorBlack"};
						};
					};
				}foreach EYE_targets_obj;
			};
			
			{
				deleteMarker _x;
			}foreach EYE_markers_str;
		
		};
	};
} else {
	SAC_tracker_ON = false;
};
