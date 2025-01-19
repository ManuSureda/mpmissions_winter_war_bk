
{

	private ["_parseResult", "_markerText"];
	
	if (markerText _x != "") then {	
	
		_parseResult = (markerText _x) splitString "@";
		_markerText = _parseResult select 0;

		if (_markerText in [

		"CRASH_SITE",
		"BLUE_BROKEN_VEHICLE",
		"DRONE",
		"BLUE_GROUP",
		"AAA",
		"TECHNICAL",
		"APC",
		"IFV",
		"TANK",
		"CREW",
		
		"HOSTAGE_PILOTS",
		
		"HOSTAGE_SOLDIERS",
		
		"GARRISON",
		
		"FORTIFY",
		
		"PATROLS_FOOT",
		
		"SAC_GREEN_ZONE",
		
		"HIDE",
		
		"TAC_TARGET",
		"TAC_TARGET_MILITIA",
		"TAC_TARGET_REGULAR",
		
		"REVEAL",
		
		"SAC_COP_KILLTARGET",
		"SAC_COP_INFORMANTKILLTARGET",
		"SAC_COP_EXTRACTIONGUYKILLTARGET",
		
		"STATIC_GROUPS",
		
		"SAC_NO_TAC_ZONE",
		"SAC_NO_CTS_SPAWN",
		"SAC_NO_MTS_SPAWN",
		"SAC_CTS_GREEN_ZONE",
		
		"ARTY",
		"MORTAR",
		"SENDINFANTRY",
		"SENDMOTORINFANTRY",
		"SENDHELIINFANTRY",
		"SENDTECHNICALS",
		"SENDAPC",
		"SENDIFV",
		"SENDTANK",
		
		"COP_TRACKER_BLINDZONE"
		
		]) then {
		
			_x setMarkerAlpha 0;
		
		};
		
	};
	
} forEach allMapMarkers;
