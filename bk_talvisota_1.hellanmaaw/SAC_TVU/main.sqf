if (!hasInterface) exitWith {};
waitUntil {!isNull player};

if !(getPlayerUID player in SAC_TVU_PUIDs) exitWith {};

private ["_radioChannelA", "_radioChannelB", "_marker", "_trg"];

//Marcadores y variables requeridos por el script.
//if !("SAC_TVA_Start" in allMapMarkers) then {hintC """SAC_TVA_Start"" marker is missing."};
//if !("SAC_TVB_Start" in allMapMarkers) then {hintC """SAC_TVB_Start"" marker is missing."};
//if !("SAC_TVA_Start_P2" in allMapMarkers) then {hintC """SAC_TVA_Start_P2"" marker is missing."};
//if !("SAC_TVB_Start_P2" in allMapMarkers) then {hintC """SAC_TVB_Start_P2"" marker is missing."};
if (isnil "SAC_FNC") exitwith {hintC """SAC_FNC"" is not initialized in SAC_TVU."};
if (isnil "SAC_GEAR") exitwith {hintC """SAC_GEAR"" is not initialized in SAC_TVU."};

_radioChannelA = _this select 0;
_radioChannelB = _this select 1;
if (count _this > 3) then {SAC_TVU_ReadyTimeAfterLost = _this select 3} else {SAC_TVU_ReadyTimeAfterLost = 0};
if ("allowattack" in _this) then {SAC_TVU_VehicleCaptive = false} else {SAC_TVU_VehicleCaptive = true};

SAC_TVU_ReadyTimeForProductionA = time;
SAC_TVU_ReadyTimeForProductionB = time;

if (isNil "SAC_onMapSingleClick_Available") then {SAC_onMapSingleClick_Available = true};

SAC_TVU_DestinationDesignationModeA = false;
SAC_TVU_DestinationDesignationModeB = false;
SAC_TVU_RouteDesignationModeA = false;
SAC_TVU_RouteDesignationModeB = false;
SAC_TVU_TerminateCurrentMissionA = false;
SAC_TVU_TerminateCurrentMissionB = false;
SAC_TVU_ReleaseControlA = false;
SAC_TVU_ReleaseControlB = false;
SAC_TVU_VehicleReadyA = false;
SAC_TVU_VehicleReadyB = false;
SAC_TVU_VehicleA = objNull;
SAC_TVU_VehicleB = objNull;
SAC_TVU_VehicleHasSupplyA = true;
SAC_TVU_VehicleHasSupplyB = true;
SAC_TVU_DestinationModeA = "Auto";
SAC_TVU_DestinationModeB = "Auto";

SAC_TVU_StatusA = "";
SAC_TVU_StatusB = "";

SAC_TVU_RouteA = [];
SAC_TVU_RouteB = [];
SAC_TVU_NewWP = [];
SAC_TVU_TerminateRouteDesignation = false;
SAC_TVU_ExfilRouteA = [];
SAC_TVU_ExfilRouteB = [];

SAC_TVU_SpeedModeA = "NORMAL";
SAC_TVU_SpeedModeB = "NORMAL";
SAC_TVU_CombatModeA = "YELLOW";
SAC_TVU_CombatModeB = "YELLOW";
SAC_TVU_BehaviourA = "AWARE";
SAC_TVU_BehaviourB = "AWARE";

SAC_TVU_speedLimitA = 999;
SAC_TVU_speedLimitB = 999;

SAC_TVU_CarsCrewClass = SAC_UDS_B_Soldiers select 0;
SAC_TVU_TanksCrewClass = SAC_UDS_B_TankCrews select 0;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

_trg = createTrigger ["EmptyDetector",[1,0,0]];
_trg setTriggerActivation [_radioChannelA, "PRESENT", true];
_trg setTriggerType "NONE";
_trg setTriggerStatements ["this","SAC_TVU_selectedUnits = groupSelectedUnits player; [""A""] spawn SAC_TVU_OpenRadioInterface",""];
_trg setTriggerText "Transport (A)";

waitUntil {!isNull(findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["keyDown", {
	
	if (dialog) exitWith {false};
	
	private["_shift","_dik"]; 
	_dik = _this select 1; 
	_shift = _this select 2; 
	
	if (_dik in [71]) then {
	
		SAC_TVU_selectedUnits = groupSelectedUnits player;
		["A"] spawn SAC_TVU_OpenRadioInterface;
	
		true
		
	} else {
	
		false
		
	};

}]; 

(findDisplay 12) displayAddEventHandler ["keyDown", {
	
	if (dialog) exitWith {false};
	
	private["_shift","_dik"]; 
	_dik = _this select 1; 
	_shift = _this select 2; 
	
	if (_dik in [71]) then {
	
		SAC_TVU_selectedUnits = groupSelectedUnits player;
		["A"] spawn SAC_TVU_OpenRadioInterface;
	
		true
		
	} else {
	
		false
		
	};

}]; 

if (_radioChannelB != "NONE") then {
	_trg = createTrigger ["EmptyDetector",[1,0,0]];
	_trg setTriggerActivation [_radioChannelB, "PRESENT", true];
	_trg setTriggerType "NONE";
	_trg setTriggerStatements ["this","SAC_TVU_selectedUnits = groupSelectedUnits player; [""B""] spawn SAC_TVU_OpenRadioInterface",""];
	_trg setTriggerText "Transport (B)";
	
	(findDisplay 46) displayAddEventHandler ["keyDown", {
		
		if (dialog) exitWith {false};
		
		private["_shift","_dik"]; 
		_dik = _this select 1; 
		_shift = _this select 2; 
		
		if (_dik in [73]) then {
		
			SAC_TVU_selectedUnits = groupSelectedUnits player;
			["B"] spawn SAC_TVU_OpenRadioInterface;
		
			true
			
		} else {
		
			false
			
		};

	}]; 
	
	(findDisplay 12) displayAddEventHandler ["keyDown", {
		
		if (dialog) exitWith {false};
		
		private["_shift","_dik"]; 
		_dik = _this select 1; 
		_shift = _this select 2; 
		
		if (_dik in [73]) then {
		
			SAC_TVU_selectedUnits = groupSelectedUnits player;
			["B"] spawn SAC_TVU_OpenRadioInterface;
		
			true
			
		} else {
		
			false
			
		};

	}]; 
	
};

systemChat "TVU initialized.";


SAC_TVU_processCoordinates = {

	private ["_p", "_callsign", "_vehicle", "_destinationMode", "_marker", "_markerText", "_pFinal"];
	
	_p = _this select 0; 
	_callsign = _this select 1;
	
	if (_callsign == "A") then {
	
		SAC_TVU_DestinationDesignationModeA = false;
		_vehicle = SAC_TVU_VehicleA;
		_destinationMode = SAC_TVU_DestinationModeA;
		_marker = "SAC_TVU_DestinationA";
		_markerText = "dest kilo-1";
		
	
	} else {
	
		SAC_TVU_DestinationDesignationModeB = false;
		_vehicle = SAC_TVU_VehicleB;
		_destinationMode = SAC_TVU_DestinationModeB;
		_marker = "SAC_TVU_DestinationB";
		_markerText = "dest kilo-2";
	
	};

	hint "";
	
	//_vehicle sideChat "Copy. Coordinates received.";
	//"radiochatter_us_15" call SAC_fnc_playSound;
	onMapSingleClick SAC_DefaultMapClick;
	SAC_onMapSingleClick_Available = true;
	
	if (_destinationMode != "Manual") then {

		_pFinal = _p isflatempty [5/2, 250, 45 * (pi / 180), 5, 0, false, objNull];
		
	} else {
	
		_pFinal = _p;
	
	};
	
	if (count _pFinal > 0) then {
	
		if (_marker in allMapMarkers) then {
		
			_marker setMarkerPosLocal _p;
		
		} else {
		
			_marker = createMarkerLocal [_marker, _p];
			_marker setMarkerColorLocal "ColorBlack";
			_marker setMarkerTypeLocal "hd_dot_noShadow";
			_marker setMarkerTextLocal _markerText;
		
		};
		
	} else {
	
		hint "No valid destination could be put there.";
	
	};
	
};

SAC_TVU_processMoveToCoordinates = {

	private ["_p", "_callsign", "_vehicle", "_destinationMode", "_marker", "_markerText", "_pFinal"];
	
	_p = _this select 0; 
	_callsign = _this select 1;
	
	if (_callsign == "A") then {
	
		SAC_TVU_DestinationDesignationModeA = false;
		_vehicle = SAC_TVU_VehicleA;
		_destinationMode = SAC_TVU_DestinationModeA;
		_marker = "SAC_TVU_TempDestinationA";
		_markerText = "temp kilo-1";
		
	
	} else {
	
		SAC_TVU_DestinationDesignationModeB = false;
		_vehicle = SAC_TVU_VehicleB;
		_destinationMode = SAC_TVU_DestinationModeB;
		_marker = "SAC_TVU_TempDestinationB";
		_markerText = "temp kilo-2";
	
	};

	hint "";
	
	//_vehicle sideChat "Copy. Coordinates received.";
	//"radiochatter_us_15" call SAC_fnc_playSound;
	onMapSingleClick SAC_DefaultMapClick;
	SAC_onMapSingleClick_Available = true;
	
	if (_destinationMode != "Manual") then {
	
		_pFinal = _p isflatempty [5/2, 50, 45 * (pi / 180), 5, 0, false, objNull];
		
	} else {
	
		_pFinal = _p;
	
	};
	
	if (count _pFinal > 0) then {
	
		if (_marker in allMapMarkers) then {
		
			_marker setMarkerPosLocal _p;
		
		} else {
		
			_marker = createMarkerLocal [_marker, _p];
			_marker setMarkerColorLocal "ColorBlack";
			_marker setMarkerTypeLocal "hd_dot_noShadow";
			_marker setMarkerTextLocal _markerText;
		
		};
		
		if (_callsign == "A") then {SAC_TVU_TerminateCurrentMissionA = true} else {SAC_TVU_TerminateCurrentMissionB = true};

		//driver _vehicle disableAI "TARGET";

		//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
		
		if (vehicle player != _vehicle) then {"sac_sounds_waiting_ack" spawn SAC_fnc_playSound};
		[driver _vehicle, "sac_sounds_waiting_ack", 100] spawn SAC_fnc_netSay3D;
		_vehicle sideChat "Copy that Echo One.";
		
		if (_callsign == "A") then {
		
			[_callsign, "SAC_TVU_TempDestinationA", "DIRECTO", "STOP", ""] spawn SAC_TVU_MoveToDestination;
			
		} else {
		
			[_callsign, "SAC_TVU_TempDestinationB", "DIRECTO", "STOP", ""] spawn SAC_TVU_MoveToDestination;
			
		};
		
	} else {
	
		hint "No valid destination could be put there.";
	
	};
	
};

SAC_TVU_OpenRadioInterface = {

	if (dialog) exitWith {false};
	
	private ["_callsign", "_vehicleReady", "_vehicle", "_destinationDesignationMode", "_routeDesignationMode", "_pos", "_waitingPointDesignationMode",
	"_startPointSelected", "_timeForReady", "_ready"];


	_callsign = _this select 0;
	if (_callsign == "A") then {
		_startPointSelected = if (isNil "SAC_TVU_StartPointAPos") then {false} else {true};
		_vehicleReady = SAC_TVU_VehicleReadyA;
		_vehicle = SAC_TVU_VehicleA;
		_destinationDesignationMode = SAC_TVU_DestinationDesignationModeA;
		_routeDesignationMode = SAC_TVU_RouteDesignationModeA;
		if (time >= SAC_TVU_ReadyTimeForProductionA) then {_ready = true} else {_ready = false};
		_timeForReady = SAC_TVU_ReadyTimeForProductionA - time;
	} else {
		_startPointSelected = if (isNil "SAC_TVU_StartPointBPos") then {false} else {true};
		_vehicleReady = SAC_TVU_VehicleReadyB;
		_vehicle = SAC_TVU_VehicleB;
		_destinationDesignationMode = SAC_TVU_DestinationDesignationModeB;
		_routeDesignationMode = SAC_TVU_RouteDesignationModeB;
		if (time >= SAC_TVU_ReadyTimeForProductionB) then {_ready = true} else {_ready = false};
		_timeForReady = SAC_TVU_ReadyTimeForProductionB - time;
	};
	
	if (not _ready) exitWith {systemChat format["New crew will be ready in %1 min.", ceil (_timeForReady / 60)]};

	SAC_user_input = "";
	
	//if (_startPointSelected) then {
	
		if (_vehicleReady) then {
		
			if (_destinationDesignationMode || _routeDesignationMode) then {
			
				0 = createdialog "SAC_1x14_panel";
				ctrlSetText [1800, " Transport Radio Interface (Setting Destination Coordinates) "];
				
				ctrlSetText [1601, "Cancel/Finish"];
				ctrlShow [1602, false ];
				ctrlShow [1603, false ];
				ctrlShow [1604, false ];
				ctrlShow [1605, false ];
				ctrlShow [1606, false ];
				ctrlShow [1607, false ];
				ctrlShow [1608, false ];
				ctrlShow [1609, false ];
				ctrlShow [1610, false ];
				ctrlShow [1611, false ];
				ctrlShow [1612, false ];
				ctrlShow [1613, false ];
				ctrlShow [1614, false ];
				
			} else {
			
				0 = createdialog "SAC_2x12_panel";
				ctrlSetText [1800, " Transport Radio Interface "];
				
				ctrlSetText [1601, "Move To Destination"];
				ctrlSetText [1602, "Follow Waypoints"];
				ctrlSetText [1603, "Move To"];
				ctrlShow [1604, false];
				ctrlSetText [1605, "Stop"];
				ctrlShow [1606, false];
				ctrlShow [1607, false];
				ctrlSetText [1608, "Release Control"];
				ctrlShow [1609, false];
				ctrlShow [1610, false];
				ctrlShow [1611, false];
				ctrlSetText [1612, "RTB"];
				
				ctrlSetText [1613, "Set Destination"];
				ctrlShow [1614, false];
				ctrlSetText [1615, "Set Waypoints"];
				ctrlShow [1616, false];
				ctrlSetText [1617, "Load Supplies"];
				ctrlSetText [1618, "Unload Supplies"];
				ctrlSetText [1619, "Report Status"];
				ctrlShow [1620, false];
				ctrlSetText [1621, "Unstuck"];
				ctrlShow [1622, false];
				ctrlSetText [1623, "Change Parameters"];
				ctrlSetText [1624, "Dismiss Vehicle"];
				
			};
			
		} else {
		
			if (!_startPointSelected) then {
			
					[_callsign] call SAC_TVU_selectStartPoint;
					
					if (SAC_user_input != "") then {_startPointSelected = true};
					
					SAC_user_input = "";
			
			};
			
			if (!_startPointSelected) exitWith {};
		
			0 = createdialog "SAC_1x14_panel";
			ctrlSetText [1800, " Transport Radio Interface (MOD Selector) "];
			
			ctrlSetText [1601, "BIS"];
			ctrlSetText [1602, "RHS"]; if (!SAC_RHS) then {ctrlEnable [1602, false]};
			ctrlSetText [1603, "CUP"]; if (!SAC_CUP) then {ctrlEnable [1603, false]}; ctrlEnable [1603, false];
			ctrlShow [1604, false];
			ctrlShow [1605, false];
			ctrlShow [1606, false];
			ctrlShow [1607, false];
			ctrlShow [1608, false];
			ctrlShow [1609, false];
			ctrlShow [1610, false];
			ctrlShow [1611, false];
			ctrlShow [1612, false];
			ctrlShow [1613, false];
			ctrlSetText [1614, "Change Start Point"];
			
			waitUntil { !dialog };
			
			switch (SAC_user_input) do {
			
				case "BIS": {

					switch ([] call SAC_TVU_VehicleTypeSelector) do {
				
						case "Cars": {
						
							SAC_user_input = "";

							0 = createdialog "SAC_2x12_panel";
							ctrlSetText [1800, " Car Selector "];
							
							ctrlSetText [1601, "Ifrit"];
							ctrlSetText [1602, "Ifrit HMG"];
							ctrlSetText [1603, "Ifrit GMG"];
							ctrlSetText [1604, "Offroad"];
							ctrlSetText [1605, "Offroad (Armed)"];
							ctrlSetText [1606, "Quadbike"];
							ctrlSetText [1607, "Zamak (Covered)"];
							ctrlSetText [1608, "Tempest (Covered)"];
							ctrlSetText [1609, "Truck"];
							ctrlSetText [1610, "Hunter"];
							ctrlSetText [1611, "Hunter GMG"];
							ctrlSetText [1612, "Hunter HMG"];
							
							ctrlSetText [1613, "HEMTT (Covered)"];
							ctrlSetText [1614, "Strider"];
							ctrlSetText [1615, "Strider HMG"];
							ctrlSetText [1616, "Strider GMG"];
							ctrlSetText [1617, "SUV"];
							ctrlShow [1618, false];
							ctrlShow [1619, false];
							ctrlShow [1620, false];
							ctrlShow [1621, false];
							ctrlShow [1622, false];
							ctrlShow [1623, false];
							ctrlShow [1624, false];
							
							waitUntil { !dialog };
			
						};
						case "MBTs": {
						
							SAC_user_input = "";

							0 = createdialog "SAC_2x12_panel";
							ctrlSetText [1800, " MBT Selector "];
							
							ctrlSetText [1601, "M2A1 Slammer"];
							ctrlSetText [1602, "M2A4 Slammer"];
							ctrlSetText [1603, "MBT-52 Kuma"]; ctrlEnable [1603, false];
							ctrlSetText [1604, "T-100 Varsuk"]; ctrlEnable [1604, false];
							ctrlSetText [1605, "T-140 Angara"]; ctrlEnable [1605, false];
							ctrlShow [1606, false];
							ctrlShow [1607, false];
							ctrlShow [1608, false];
							ctrlShow [1609, false];
							ctrlShow [1610, false];
							ctrlShow [1611, false];
							ctrlShow [1612, false];
							
							ctrlShow [1613, false];
							ctrlShow [1614, false];
							ctrlShow [1615, false];
							ctrlShow [1616, false];
							ctrlShow [1617, false];
							ctrlShow [1618, false];
							ctrlShow [1619, false];
							ctrlShow [1620, false];
							ctrlShow [1621, false];
							ctrlShow [1622, false];
							ctrlShow [1623, false];
							ctrlShow [1624, false];
							
							waitUntil { !dialog };
						
						};
						case "APCs": {
						
							SAC_user_input = "";

							0 = createdialog "SAC_2x12_panel";
							ctrlSetText [1800, " APC Selector "];
							
							ctrlSetText [1601, "AMV-7 Marshall"];
							ctrlSetText [1602, "AFV-4 Gorgon"];
							ctrlSetText [1603, "IFV-6c Panther"];
							ctrlSetText [1604, "BTR-K Kamysh"];
							ctrlSetText [1605, "MSE-3 Marid"];
							ctrlSetText [1606, "FV-720 Mora"];
							
							ctrlShow [1607, false];
							ctrlShow [1608, false];
							ctrlShow [1609, false];
							ctrlShow [1610, false];
							ctrlShow [1611, false];
							ctrlShow [1612, false];
							
							ctrlShow [1613, false];
							ctrlShow [1614, false];
							ctrlShow [1615, false];
							ctrlShow [1616, false];
							ctrlShow [1617, false];
							ctrlShow [1618, false];
							ctrlShow [1619, false];
							ctrlShow [1620, false];
							ctrlShow [1621, false];
							ctrlShow [1622, false];
							ctrlShow [1623, false];
							ctrlShow [1624, false];
							
							waitUntil { !dialog };
						
						};
						default {};
					};

				};
				
				case "RHS": {
				
					switch ([] call SAC_TVU_VehicleTypeSelector) do {
				
						case "Cars": {
						
							SAC_user_input = "";

							0 = createdialog "SAC_2x12_panel";
							ctrlSetText [1800, " Car Selector "];
							
							ctrlSetText [1601, "RG-33"];
							ctrlSetText [1602, "RG-33 M2"];
							ctrlSetText [1603, "M1025A2 M2"];
							ctrlSetText [1604, "M1025A2 Unarmed"];
							ctrlSetText [1605, "M1097A2"];
							ctrlSetText [1606, "M1097A2 4D/Open"];
							ctrlSetText [1607, "M1083A1P2-B"];
							ctrlSetText [1608, "M1083A1P2-B M2"];
							ctrlShow [1609, false];
							ctrlShow [1610, false];
							ctrlShow [1611, false];
							ctrlShow [1612, false];
							
							ctrlShow [1613, false];
							ctrlShow [1614, false];
							ctrlShow [1615, false];
							ctrlShow [1616, false];
							ctrlShow [1617, false];
							ctrlShow [1618, false];
							ctrlShow [1619, false];
							ctrlShow [1620, false];
							ctrlShow [1621, false];
							ctrlShow [1622, false];
							ctrlShow [1623, false];
							ctrlShow [1624, false];
							
							waitUntil { !dialog };
			
						};
						case "MBTs": {
						
							SAC_user_input = "";

							0 = createdialog "SAC_2x12_panel";
							ctrlSetText [1800, " MBT Selector "];
							
							ctrlSetText [1601, "M1A1SA"];  ctrlEnable [1601, false];
							ctrlSetText [1602, "M1A1SA (TUSK 1)"]; ctrlEnable [1602, false];
							ctrlSetText [1603, "M1A1SEPv1"]; ctrlEnable [1603, false];
							ctrlSetText [1604, "M1A1SEPv1 (TUSK I)"]; ctrlEnable [1604, false];
							ctrlSetText [1605, "M1A1SEPv1 (TUSK II)"]; ctrlEnable [1605, false];
							ctrlSetText [1606, "M1A1FEP"]; ctrlEnable [1606, false];
							ctrlSetText [1607, "M1A1FEP (O)"]; ctrlEnable [1607, false];
							ctrlSetText [1608, "T-72B (1984)"]; ctrlEnable [1608, false];
							ctrlSetText [1609, "T-80B"]; ctrlEnable [1609, false];
							ctrlSetText [1610, "T-80BK"]; ctrlEnable [1610, false];
							ctrlSetText [1611, "T-90A (2006)"]; ctrlEnable [1611, false];
							ctrlShow [1612, false];
							
							ctrlShow [1613, false];
							ctrlShow [1614, false];
							ctrlShow [1615, false];
							ctrlShow [1616, false];
							ctrlShow [1617, false];
							ctrlShow [1618, false];
							ctrlShow [1619, false];
							ctrlShow [1620, false];
							ctrlShow [1621, false];
							ctrlShow [1622, false];
							ctrlShow [1623, false];
							ctrlShow [1624, false];
							
							waitUntil { !dialog };
						
						};
						case "APCs": {
						
							SAC_user_input = "";

							0 = createdialog "SAC_2x12_panel";
							ctrlSetText [1800, " APC Selector "];
							
							ctrlSetText [1601, "STRIKER M2"];
							ctrlSetText [1602, "BMP-1D"];//  ctrlEnable [1602, false];
							ctrlSetText [1603, "BMP-2D"];//  ctrlEnable [1603, false];
							ctrlSetText [1604, "BMP-3 early"];//  ctrlEnable [1604, false];
							ctrlSetText [1605, "BMP-3 late"];//  ctrlEnable [1605, false];
							ctrlSetText [1606, "BMP-3 Vesna-K"];//  ctrlEnable [1606, false];
							ctrlSetText [1607, "BMP-3 Vesna-K/A"];//  ctrlEnable [1607, false];
							ctrlSetText [1608, "BTR-60PB"];//  ctrlEnable [1608, false];
							ctrlSetText [1609, "BTR-70"];//  ctrlEnable [1609, false];
							ctrlSetText [1610, "BTR-80"];//  ctrlEnable [1610, false];
							ctrlSetText [1611, "M113A3"];//  ctrlEnable [1611, false];
							ctrlSetText [1612, "M2A2"];//  ctrlEnable [1612, false];
							ctrlSetText [1613, "M2A2 BUSK"];//  ctrlEnable [1613, false];
							ctrlSetText [1614, "M2A3"];//  ctrlEnable [1614, false];
							ctrlSetText [1615, "M2A3 BUSK"];//  ctrlEnable [1615, false];
							ctrlSetText [1616, "BRDM 2"];//  ctrlEnable [1616, false];
							
							ctrlShow [1617, false];
							ctrlShow [1618, false];
							ctrlShow [1619, false];
							ctrlShow [1620, false];
							ctrlShow [1621, false];
							ctrlShow [1622, false];
							ctrlShow [1623, false];
							ctrlShow [1624, false];
							
							waitUntil { !dialog };
						
						};
						default {};
					};
					
				};
				case "CUP": {
				
					switch ([] call SAC_TVU_VehicleTypeSelector) do {
				
						case "Cars": {
						
							SAC_user_input = "";

							0 = createdialog "SAC_2x12_panel";
							ctrlSetText [1800, " Car Selector "];
							
							ctrlSetText [1601, "HMMWV M2"];
							ctrlSetText [1602, "HMMWV M240"];
							ctrlSetText [1603, "Ural"];
							ctrlSetText [1604, "Land Rover"];
							ctrlSetText [1605, "Land Rover (M2)"];
							ctrlSetText [1606, "Jackal GMG"];
							ctrlSetText [1607, "Jackal L2A1"];
							ctrlSetText [1608, "Land Rover (Special)"];
							ctrlShow [1609, false];
							ctrlShow [1610, false];
							ctrlShow [1611, false];
							ctrlShow [1612, false];
							
							ctrlShow [1613, false];
							ctrlShow [1614, false];
							ctrlShow [1615, false];
							ctrlShow [1616, false];
							ctrlShow [1617, false];
							ctrlShow [1618, false];
							ctrlShow [1619, false];
							ctrlShow [1620, false];
							ctrlShow [1621, false];
							ctrlShow [1622, false];
							ctrlShow [1623, false];
							ctrlShow [1624, false];
							
							waitUntil { !dialog };
			
						};
						case "MBTs": {
						
							SAC_user_input = "";

							0 = createdialog "SAC_2x12_panel";
							ctrlSetText [1800, " MBT Selector "];
							
							ctrlSetText [1601, "M1A1"];  ctrlEnable [1601, false];
							ctrlSetText [1602, "M1A2 TUSK"];  ctrlEnable [1602, false];
							ctrlSetText [1603, "T-72"];  ctrlEnable [1603, false];
							ctrlSetText [1604, "T-90"];  ctrlEnable [1604, false];
							ctrlShow [1605, false];
							ctrlShow [1606, false];
							ctrlShow [1607, false];
							ctrlShow [1608, false];
							ctrlShow [1609, false];
							ctrlShow [1610, false];
							ctrlShow [1611, false];
							ctrlShow [1612, false];
							
							ctrlShow [1613, false];
							ctrlShow [1614, false];
							ctrlShow [1615, false];
							ctrlShow [1616, false];
							ctrlShow [1617, false];
							ctrlShow [1618, false];
							ctrlShow [1619, false];
							ctrlShow [1620, false];
							ctrlShow [1621, false];
							ctrlShow [1622, false];
							ctrlShow [1623, false];
							ctrlShow [1624, false];
							
							waitUntil { !dialog };
						
						};
						case "APCs": {
						
							SAC_user_input = "";

							0 = createdialog "SAC_2x12_panel";
							ctrlSetText [1800, " APC Selector "];
							
							ctrlSetText [1601, "BMP-2"];  ctrlEnable [1601, false];
							ctrlSetText [1602, "BMP-3"];  ctrlEnable [1602, false];
							ctrlShow [1603, false];
							ctrlShow [1604, false];
							ctrlShow [1605, false];
							ctrlShow [1606, false];
							ctrlShow [1607, false];
							ctrlShow [1608, false];
							ctrlShow [1609, false];
							ctrlShow [1610, false];
							ctrlShow [1611, false];
							ctrlShow [1612, false];
							
							ctrlShow [1613, false];
							ctrlShow [1614, false];
							ctrlShow [1615, false];
							ctrlShow [1616, false];
							ctrlShow [1617, false];
							ctrlShow [1618, false];
							ctrlShow [1619, false];
							ctrlShow [1620, false];
							ctrlShow [1621, false];
							ctrlShow [1622, false];
							ctrlShow [1623, false];
							ctrlShow [1624, false];
							
							waitUntil { !dialog };
						
						};
						default {};
					};
					
				};
				
				case "Change Start Point": {
				
					[_callsign] call SAC_TVU_selectStartPoint;
					
					SAC_user_input = "";
				
				};
				
				default {};
			};
			
		};
		
		waitUntil { !dialog };

		switch (SAC_user_input) do
		{
			case "Cancel/Finish": { //Cancel setting coordinates or designating route
				hint "";
				onMapSingleClick SAC_DefaultMapClick;
				SAC_onMapSingleClick_Available = true;
				//Discrimina entre cancelar el modo de selección de destino y el modo de marcado de ruta.
				if (_destinationDesignationMode) then {
					_destinationDesignationMode = false;
				} else {
					SAC_TVU_TerminateRouteDesignation = true;
					_routeDesignationMode = false;		
				};
			};
			case "Set Destination": {
				if (SAC_onMapSingleClick_Available) then {
					SAC_onMapSingleClick_Available = false;
					_destinationDesignationMode = true;
					hint "Click on the map to set destination point.";
					//"defaultNotification" call SAC_fnc_playSound;
					if (!visibleMap) then {openMap true};
					if (_callsign == "A") then {
						onMapSingleClick "[_pos, ""A""] spawn SAC_TVU_processCoordinates; true";
					} else {
						onMapSingleClick "[_pos, ""B""] spawn SAC_TVU_processCoordinates; true";
					};
				} else {hint "onMapSingleClick is not available."};
			};
			case "Set Waypoints": {
				if (SAC_onMapSingleClick_Available) then {
					SAC_onMapSingleClick_Available = false;
					_routeDesignationMode = true;
					[_callsign] spawn SAC_TVU_CreateRoute;
				} else {hint "onMapSingleClick is not available."};
			};
			case "Move To": {
				if (SAC_onMapSingleClick_Available) then {
					SAC_onMapSingleClick_Available = false;
					_destinationDesignationMode = true;
					hint "Click on the map to set destination point.";
					//"defaultNotification" call SAC_fnc_playSound;
					if (!visibleMap) then {openMap true};
					if (_callsign == "A") then {
						onMapSingleClick "[_pos, ""A""] spawn SAC_TVU_processMoveToCoordinates; true";
					} else {
						onMapSingleClick "[_pos, ""B""] spawn SAC_TVU_processMoveToCoordinates; true";
					};
				} else {hint "onMapSingleClick is not available."};
			};
			case "Move To Destination": {
				hint "";
				if (_callsign == "A") then {SAC_TVU_TerminateCurrentMissionA = true} else {SAC_TVU_TerminateCurrentMissionB = true};

				//driver _vehicle disableAI "TARGET";

				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
				
				if (_callsign == "A") then {
				
					if (vehicle player != _vehicle) then {"sac_sounds_confirmed3" spawn SAC_fnc_playSound};
					[driver _vehicle, "sac_sounds_confirmed3", 100] spawn SAC_fnc_netSay3D;
					_vehicle sideChat "Copy that Nomad, we're rolling, Echo One out.";
					
					[_callsign, "SAC_TVU_DestinationA", "DIRECTO", "STOP", ""] spawn SAC_TVU_MoveToDestination;
					
				} else {
				
					if (vehicle player != _vehicle) then {"sac_sounds_confirmed4" spawn SAC_fnc_playSound};
					[driver _vehicle, "sac_sounds_confirmed4", 100] spawn SAC_fnc_netSay3D;
					_vehicle sideChat "Copy Crossroads, Delta's rolling, out.";
				
					[_callsign, "SAC_TVU_DestinationB", "DIRECTO", "STOP", ""] spawn SAC_TVU_MoveToDestination;
					
				};
				
			};
			case "Follow Waypoints": {
				hint "";
				if (_callsign == "A") then {SAC_TVU_TerminateCurrentMissionA = true} else {SAC_TVU_TerminateCurrentMissionB = true};

				//driver _vehicle disableAI "TARGET";
				
				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
				
				if (_callsign == "A") then {
				
					if (vehicle player != _vehicle) then {"sac_sounds_confirmed3" spawn SAC_fnc_playSound};
					[driver _vehicle, "sac_sounds_confirmed3", 100] spawn SAC_fnc_netSay3D;
					_vehicle sideChat "Copy that Nomad, we're rolling, Echo One out.";
				
					[_callsign, "", "RUTA", "STOP", ""] spawn SAC_TVU_MoveToDestination;
					
				} else {
				
					if (vehicle player != _vehicle) then {"sac_sounds_confirmed4" spawn SAC_fnc_playSound};
					[driver _vehicle, "sac_sounds_confirmed4", 100] spawn SAC_fnc_netSay3D;
					_vehicle sideChat "Copy Crossroads, Delta's rolling, out.";
				
					[_callsign, "", "RUTA", "STOP", ""] spawn SAC_TVU_MoveToDestination;
					
				};
				
			};
			case "Stop": {
				hint "";
				if (_callsign == "A") then {SAC_TVU_TerminateCurrentMissionA = true} else {SAC_TVU_TerminateCurrentMissionB = true};

				//driver _vehicle disableAI "TARGET";
				
				//[_vehicle, format ["Solid copy %1.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
				
				if (vehicle player != _vehicle) then {"sac_sounds_waiting_ack" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_waiting_ack", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Copy that Echo One.";
				
				
				if (_callsign == "A") then {
					[_callsign] spawn SAC_TVU_Stop;
				} else {
					[_callsign] spawn SAC_TVU_Stop;
				};
			};
			case "Release Control": {
				hint "";
				
				if (_callsign == "A") then {
					SAC_TVU_ReleaseControlA = true;
				} else {
					SAC_TVU_ReleaseControlB = true;
				};
			};
			case "RTB": {
				hint "";
				if (_callsign == "A") then {SAC_TVU_TerminateCurrentMissionA = true} else {SAC_TVU_TerminateCurrentMissionB = true};

				//driver _vehicle disableAI "TARGET";
				
				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
				
				if (vehicle player != _vehicle) then {"sac_sounds_RTB2" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_RTB2", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Copy that Eagle, RTB.";
				
				if (_callsign == "A") then {
					[_callsign, SAC_TVU_StartPointAMarkerName, "DIRECTO", "STOP", ""] spawn SAC_TVU_MoveToDestination;
				} else {
					[_callsign, SAC_TVU_StartPointBMarkerName, "DIRECTO", "STOP", ""] spawn SAC_TVU_MoveToDestination;
				};
			};
			case "Report Status": {
				[_callsign] call SAC_TVU_ReportStatus;
			};
			case "Unload Supplies": {
				[_callsign] call SAC_TVU_UnloadSupply;
			};
			case "Load Supplies": {
				[_callsign] call SAC_TVU_LoadSupply;
			};
			case "Unstuck": {
				if (SAC_onMapSingleClick_Available) then {
					SAC_onMapSingleClick_Available = false;
					_destinationDesignationMode = true;
					hint "Click on the map to set destination.";
					
					if (!visibleMap) then {openMap true};
					
					if (_callsign == "A") then {
					
						onMapSingleClick "SAC_TVU_VehicleA setPos _pos; SAC_TVU_DestinationDesignationModeA = false; hint ''; onMapSingleClick SAC_DefaultMapClick; SAC_onMapSingleClick_Available = true; true";
					
					} else {
					
						onMapSingleClick "SAC_TVU_VehicleB setPos _pos; SAC_TVU_DestinationDesignationModeB = false; hint ''; onMapSingleClick SAC_DefaultMapClick; SAC_onMapSingleClick_Available = true; true";
					
					};

				} else {hint "onMapSingleClick is not available."};
			};
			case "Change Parameters": {
				[_callsign] call SAC_TVU_ChangeParameters;
			};
			case "Dismiss Vehicle": {
				[_callsign] call SAC_TVU_DismissVehicle;
			};
			default {
			
				if (SAC_user_input != "") then {
			
					[_callsign, SAC_user_input] call SAC_TVU_CreateVehicle;
					
				};
				
			};
		};
		
/*	} else {
	
		[_callsign] call SAC_TVU_selectStartPoint;
	
	};*/

	if (_callsign == "A") then {
		SAC_TVU_DestinationDesignationModeA = _destinationDesignationMode;
		SAC_TVU_RouteDesignationModeA = _routeDesignationMode;
	} else {
		SAC_TVU_DestinationDesignationModeB = _destinationDesignationMode;
		SAC_TVU_RouteDesignationModeB = _routeDesignationMode;
	};

};

SAC_TVU_selectStartPoint = {

	params ["_callsign"];
	
	SAC_user_input = "";

	0 = createdialog "SAC_1x14_panel";
	ctrlSetText [1800, " Transport Radio Interface (Start Point Selection) "];

	for [{_c=1},{_c<=14},{_c=_c+1}] do {
	
		if (getMarkerColor format ["SAC_TV_StartPoint_%1", _c] != "") then {
		
			ctrlSetText [1600 + _c, format ["SAC_TV_StartPoint_%1", _c]];
		
		} else {
		
			ctrlShow [1600 + _c, false ];
		
		};
	
	};

	waitUntil { !dialog };
	
	if (SAC_user_input == "") exitWith {};
	
	if (_callsign == "A") then {
	
		SAC_TVU_StartPointAPos = getMarkerPos SAC_user_input;
		SAC_TVU_StartPointAMarkerName = SAC_user_input;
		SAC_TVU_StartPointADir = markerDir SAC_user_input;

	} else {

		SAC_TVU_StartPointBPos = getMarkerPos SAC_user_input;
		SAC_TVU_StartPointBMarkerName = SAC_user_input;
		SAC_TVU_StartPointBDir = markerDir SAC_user_input;
	
	};

	//devuelve el valor en SAC_user_input


};

SAC_TVU_VehicleTypeSelector = {

	SAC_user_input = "";

	0 = createdialog "SAC_1x14_panel";
	ctrlSetText [1800, " Transport Radio Interface (Type Selector) "];
	
	ctrlSetText [1601, "Cars"]; ctrlEnable [1601, false];
	ctrlSetText [1602, "MBTs"];
	ctrlSetText [1603, "APCs"];
	ctrlShow [1604, false];
	ctrlShow [1605, false];
	ctrlShow [1606, false];
	ctrlShow [1607, false];
	ctrlShow [1608, false];
	ctrlShow [1609, false];
	ctrlShow [1610, false];
	ctrlShow [1611, false];
	ctrlShow [1612, false];
	ctrlShow [1613, false];
	ctrlShow [1614, false];
	
	waitUntil { !dialog };
	
	SAC_user_input
	
};

SAC_TVU_ChangeParameters = {

	private ["_callsign", "_vehicle", "_status", "_destinationMode", "_combatMode",
	"_speedLimit"];

	_callsign = _this select 0;

	SAC_user_input = "not yet initialized";
	while {SAC_user_input != ""} do {
	
		if (_callsign == "A") then {
		
			_vehicle = SAC_TVU_VehicleA;
			
			_destinationMode = SAC_TVU_DestinationModeA;
			_combatMode = SAC_TVU_CombatModeA;
			_speedLimit = SAC_TVU_speedLimitA;
			
		} else {
		
			_vehicle = SAC_TVU_VehicleB;
			
			_destinationMode = SAC_TVU_DestinationModeB;
			_combatMode = SAC_TVU_CombatModeB;
			_speedLimit = SAC_TVU_speedLimitB;
			
		};
	
		SAC_user_input = "";
		
		0 = createdialog "SAC_1x14_panel";
		ctrlSetText [1800, " Helicopter Radio Interface (Parameters) "];

		ctrlSetText [1601, "Smart Destination ON"]; if (_destinationMode == "Auto") then {((findDisplay 3000) displayCtrl 1601) ctrlSetBackgroundColor [0,0,0.7,1]};
		ctrlSetText [1602, "Smart Destination OFF"]; if (_destinationMode == "Manual") then {((findDisplay 3000) displayCtrl 1602) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1603, "Open Fire"]; if (_combatMode == "YELLOW") then {((findDisplay 3000) displayCtrl 1603) ctrlSetBackgroundColor [0,0,0.7,1]};
		ctrlSetText [1604, "Do Not Fire"]; if (_combatMode == "BLUE") then {((findDisplay 3000) displayCtrl 1604) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1605, "Report Current Start Point"];
		ctrlSetText [1606, "Change Start Point"];
		ctrlSetText [1607, "Speed Limit 15"]; if (_speedLimit == 10) then {((findDisplay 3000) displayCtrl 1607) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1608, "Speed Limit 35"]; if (_speedLimit == 35) then {((findDisplay 3000) displayCtrl 1608) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1609, "Speed Limit 50"]; if (_speedLimit == 60) then {((findDisplay 3000) displayCtrl 1609) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1610, "Speed Limit 70"]; if (_speedLimit == 70) then {((findDisplay 3000) displayCtrl 1610) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1611, "Speed Limit 90"]; if (_speedLimit == 90) then {((findDisplay 3000) displayCtrl 1611) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1612, "Speed Limit 100"]; if (_speedLimit == 100) then {((findDisplay 3000) displayCtrl 1612) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1613, "Speed Limit None"]; if (_speedLimit == 999) then {((findDisplay 3000) displayCtrl 1613) ctrlSetBackgroundColor [0,0,0.7,1]};
		ctrlSetText [1614, ""];
		ctrlSetFocus ((findDisplay 3000) displayCtrl 1614);
		
		waitUntil { !dialog };
		switch (SAC_user_input) do
		{

			case "Smart Destination OFF": {
				if (_callsign == "A") then {SAC_TVU_DestinationModeA = "Manual"} else {SAC_TVU_DestinationModeB = "Manual"};
				
				//[_vehicle, "Manual landing system."] spawn SAC_fnc_messageFromUnit;
				
			};
			case "Smart Destination ON": {
				if (_callsign == "A") then {SAC_TVU_DestinationModeA = "Auto"} else {SAC_TVU_DestinationModeB = "Auto"};

				//[_vehicle, "Safe landing system."] spawn SAC_fnc_messageFromUnit;
			};
			case "Open Fire": {
				if (_callsign == "A") then {SAC_TVU_CombatModeA = "YELLOW"} else {SAC_TVU_CombatModeB = "YELLOW"};
				_vehicle setCombatMode "YELLOW";
				
				//[_vehicle, "Engage hostiles."] spawn SAC_fnc_messageFromUnit;

			};
			case "Do Not Fire": {
				if (_callsign == "A") then {SAC_TVU_CombatModeA = "BLUE"} else {SAC_TVU_CombatModeB = "BLUE"};
				_vehicle setCombatMode "BLUE";

				//[_vehicle, "Hold fire."] spawn SAC_fnc_messageFromUnit;
				
			};
			case "Report Current Start Point": {
			
				if (_callsign == "A") then {
				
					hint ("Current Start Point: " + SAC_TVU_StartPointAMarkerName);
					
				} else {
				
					hint ("Current Start Point: " + SAC_TVU_StartPointBMarkerName);
					
				};

			};
			case "Change Start Point": {
			
				[_callsign] call SAC_TVU_selectStartPoint;

			};
			case "Speed Limit 15": {
			
				if (_callsign == "A") then {SAC_TVU_speedLimitA = 15} else {SAC_TVU_speedLimitB = 15};
				
				if !(_vehicle getVariable ["sac_isforcedSpeedStopped", false]) then {_vehicle forceSpeed (((15 * 1000) / 60) / 60)};

			};
			case "Speed Limit 35": {
			
				if (_callsign == "A") then {SAC_TVU_speedLimitA = 35} else {SAC_TVU_speedLimitB = 35};
				
				if !(_vehicle getVariable ["sac_isforcedSpeedStopped", false]) then {_vehicle forceSpeed (((35 * 1000) / 60) / 60)};

			};
			case "Speed Limit 50": {
			
				if (_callsign == "A") then {SAC_TVU_speedLimitA = 50} else {SAC_TVU_speedLimitB = 50};
				
				if !(_vehicle getVariable ["sac_isforcedSpeedStopped", false]) then {_vehicle forceSpeed (((50 * 1000) / 60) / 60)};

			};
			case "Speed Limit 70": {
			
				if (_callsign == "A") then {SAC_TVU_speedLimitA = 70} else {SAC_TVU_speedLimitB = 70};
				
				if !(_vehicle getVariable ["sac_isforcedSpeedStopped", false]) then {_vehicle forceSpeed (((70 * 1000) / 60) / 60)};

			};
			case "Speed Limit 90": {
			
				if (_callsign == "A") then {SAC_TVU_speedLimitA = 90} else {SAC_TVU_speedLimitB = 90};
				
				if !(_vehicle getVariable ["sac_isforcedSpeedStopped", false]) then {_vehicle forceSpeed (((90 * 1000) / 60) / 60)};

			};
			case "Speed Limit 100": {
			
				if (_callsign == "A") then {SAC_TVU_speedLimitA = 100} else {SAC_TVU_speedLimitB = 100};
				
				if !(_vehicle getVariable ["sac_isforcedSpeedStopped", false]) then {_vehicle forceSpeed (((100 * 1000) / 60) / 60)};

			};
			case "Speed Limit None": {
			
				if (_callsign == "A") then {SAC_TVU_speedLimitA = 999} else {SAC_TVU_speedLimitB = 999};
				
				if !(_vehicle getVariable ["sac_isforcedSpeedStopped", false]) then {_vehicle forceSpeed -1};

			};
			default {SAC_user_input = ""};
		};
	};
};

SAC_TVU_VehicleAI = {

	private ["_vehicle", "_callsign", "_crewGroup", "_vehicleCrew", "_driver", "_continue", "_vehicleReady", "_armed",
	"_returnedArray", "_startPointDir", "_vehicleClass", "_capacity", "_initialCrewCount", "_releaseControl"];


	_vehicle = _this select 0;
	_callsign = _this select 1;
	_protectedParts = _this select 2;
	
	
	_crewGroup = group driver _vehicle;
	_vehicleCrew = units _crewGroup;
	_driver = driver _vehicle;

	//este método dejó de funcionar cuando le pusieron granadas de humo en 1.44
	//_armed = if (count magazines _vehicle > 0) then {true} else {false};
	
	_armed = if ([_vehicle] call SAC_fnc_hasGunner) then {true} else {false};
	
	if (_callsign == "A") then {_vehicleReady = SAC_TVU_VehicleReadyA; _releaseControl = SAC_TVU_ReleaseControlA} else {_vehicleReady = SAC_TVU_VehicleReadyB; _releaseControl = SAC_TVU_ReleaseControlB};
	
	if (count _protectedParts > 0) then {
	
		call compile format["_vehicle addEventHandler ['hit',{{(_this select 0) setHit [_x,0] } foreach %1}]", _protectedParts];
	
	};
	
	
	_outOfAmmoInformed = false;
	_gunnerDeadInformed = false;
	_bingoFuelInformed = false;
	_weaponMalfunctionInformed = false;
	
	"sac_sounds_support_available1" spawn SAC_fnc_playSound;
	_vehicle sideChat "Be advise, support units are now on stand-by.";
	
	_continue = true;
	while {_continue && _vehicleReady && !_releaseControl} do {

		sleep 10; //30
		
		if (_callsign == "A") then {_vehicleReady = SAC_TVU_VehicleReadyA; _releaseControl = SAC_TVU_ReleaseControlA} else {_vehicleReady = SAC_TVU_VehicleReadyB; _releaseControl = SAC_TVU_ReleaseControlB};
		
		if (_vehicleReady) then {
		
			if (alive _vehicle) then {
			
				_crewGroup setBehaviourStrong "AWARE";
			
			};
			
			//if ((!alive _vehicle) || (!canMove _vehicle) || (!alive _driver)) then {
			//
			//Si el driver muere, aunque parezca mentira, el gunner y el commander se bajaron, y volvieron a subirse como driver y gunner.
			//
			if (_releaseControl || (!alive _vehicle) || (!canMove _vehicle) || (units _crewGroup findIf {alive _x} == -1) || (isPlayer driver _vehicle)) then {
			
				if (_callsign == "A") then {
				
					SAC_TVU_VehicleReadyA = false;
					SAC_TVU_TerminateCurrentMissionA = true;
					SAC_TVU_ReadyTimeForProductionA = time + (SAC_TVU_ReadyTimeAfterLost * 60);
					
				} else {
				
					SAC_TVU_VehicleReadyB = false;
					SAC_TVU_TerminateCurrentMissionB = true;
					SAC_TVU_ReadyTimeForProductionB = time + (SAC_TVU_ReadyTimeAfterLost * 60);
					
				};
				
				switch (true) do {
				
					case (_releaseControl): {
					
						{
						
							_vehicle deleteVehicleCrew _x;
						
						} forEach units _crewGroup;
					
					};
				
					case (!alive _vehicle): {
					
						if (_callsign == "A") then {
						
							hint "Kilo 1 has been destroyed.";
						
						} else {
						
							hint "Kilo 2 has been destroyed.";
						
						};
						"defaultNotification" call SAC_fnc_playSound;
						[] spawn {
						
							sleep 5;
							"sac_sounds_cas_KIA" spawn SAC_fnc_playSound;
							systemChat "Alpha be advised, we can't reach Echo, presumed KIA, Papa Bear out.";
							
						};

					
					};
					
					case (!canMove _vehicle): {

						if (_callsign == "A") then {
						
							hint "Kilo 1 can't move due to severe dammage!";
						
						} else {
						
							hint "Kilo 2 can't move due to severe dammage!";
						
						};
						"defaultNotification" call SAC_fnc_playSound;
					
					};
					
					case (units _crewGroup findIf {alive _x} == -1): {
					
						if (_callsign == "A") then {
						
							hint "Kilo 1's crew is dead!";
						
						} else {
						
							hint "Kilo 2's crew is dead!";
						
						};
						"defaultNotification" call SAC_fnc_playSound;
						[] spawn {
						
							sleep 5;
							"sac_sounds_cas_KIA" spawn SAC_fnc_playSound;
							systemChat "Alpha be advised, we can't reach Echo, presumed KIA, Papa Bear out.";
							
						};
					
					};
					
					case (isPlayer driver _vehicle): {
					
						hint "A player took control of the vehicle!";
						"defaultNotification" call SAC_fnc_playSound;
					
					};
				
				};
				
				if (_vehicleCrew findIf {alive _x} != -1) then {
				
					//_vehicleCrew join group player;
					{
					
						_x spawn {
						
							private ["_unit"];
							
							_unit = _this;
							
							if (alive _unit) then {
							
								_unit enableAI "TARGET";
								_unit setCaptive false;
								[_unit] join group player;
								_unit assignTeam "BLUE";
								//removeHeadgear _unit;
								_unit unlinkItem "NVGoggles"; 
								
							};
						};
						
					} forEach _vehicleCrew;
/* 					
					hint "Vehicle is disabled. Some crew members survived!";
					"defaultNotification" call SAC_fnc_playSound;
					 */
				};
				
				_continue = false;
				
			} else {
			
				if ((!_bingoFuelInformed) && {fuel _vehicle < 0.25}) then {

					[_vehicle, format ["%1, we are BINGO FUEL, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
					_bingoFuelInformed = true;
					
				};
				
				if (_armed) then {
				
					if ((!_outOfAmmoInformed) || {!_weaponMalfunctionInformed} || {!_gunnerDeadInformed}) then {
					
						if (!canFire _vehicle) then {
						
							if ((!_outOfAmmoInformed) || {!_weaponMalfunctionInformed}) then {
							
								if (count magazines _vehicle == 0) then {
								
									if (!_outOfAmmoInformed) then {
									
										[_vehicle, format ["%1, we run out of ammo, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
										_outOfAmmoInformed = true;
										
									};
								
								} else {
								
									if (!_weaponMalfunctionInformed) then {
								
										[_vehicle, format ["%1, weapon malfunction, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
										_weaponMalfunctionInformed = true;
										
									}
									
								};
							};
						
						} else {
						
							if ((!_gunnerDeadInformed) && {!alive gunner _vehicle}) then {

								if (([_vehicle] call SAC_fnc_hasCommander) && {alive commander _vehicle}) then {
							
									(commander _vehicle) moveInGunner _vehicle;
									
								} else {
								
									[_vehicle, format ["%1, our Gunner is dead, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
									_gunnerDeadInformed = true;
								
								};
							
							};
							
						};
					};
				};
			
			
			};
		};

	};
	
	_vehicle lockDriver false;
	[_vehicle] call SAC_fnc_unlockLockedTurrets;
	
	systemChat "Se termino una instancia de VehicleAI.";

};

SAC_TVU_fnc_tracker = {

	private ["_vehicle", "_callsign", "_marker", "_vehicleReady"];


	_vehicle = _this select 0;
	_callsign = _this select 1;

	if (_callsign == "A") then {
	
		_vehicleReady = SAC_TVU_vehicleReadyA;
	
	} else {
	
		_vehicleReady = SAC_TVU_vehicleReadyB;
	
	};
	
	_marker = [getPos _vehicle, SAC_trackerColor, format ["%1", groupID (group _vehicle)], "b_armor", [1, 1]] call SAC_fnc_createMarker;
	
	while {_vehicleReady && {alive _vehicle}} do {

		_marker setMarkerPos getPos _vehicle;
		
		sleep 1; //30
		
		if (_callsign == "A") then {_vehicleReady = SAC_TVU_vehicleReadyA} else {_vehicleReady = SAC_TVU_vehicleReadyB};

	};
	
	deleteMarker _marker;
	
};

SAC_TVU_ReportStatus = {

	private ["_callsign", "_vehicle"];

	_callsign = _this select 0;

	if (_callsign == "A") then {
		_vehicle = SAC_TVU_VehicleA;
	} else {
		_vehicle = SAC_TVU_VehicleB;
	};

	if (fuel _vehicle < 0.25) then {

		[_vehicle, format ["%1, we are BINGO FUEL.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
		
	};
	
	if ([_vehicle] call SAC_fnc_hasGunner) then {
		
		if (!canFire _vehicle) then {
			
			if (count magazines _vehicle == 0) then {

				[_vehicle, format ["%1, we run out of ammo.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

			} else {
			
				[_vehicle, format ["%1, weapon malfunction.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
			
			};
		
		};
	
		if (!alive gunner _vehicle) then {
		
			[_vehicle, format ["%1, we have no Gunner.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
		
		};

	};
	
	if ([_vehicle] call SAC_fnc_hasCommander) then {
	
		if (!alive commander _vehicle) then {
		
			[_vehicle, format ["%1, we have no Commander.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
			
		};
		
	};

};

SAC_TVU_DismissVehicle = {
	private ["_callsign", "_vehicle", "_base", "_distanceToBase", "_alt", "_unitsInVehicle", "_crewGroup"];


	_callsign = _this select 0;

	if (_callsign == "A") then {
		_vehicle = SAC_TVU_VehicleA;
		_base = SAC_TVU_StartPointAPos;
	} else {
		_vehicle = SAC_TVU_VehicleB;
		_base = SAC_TVU_StartPointBPos;
	};

	_distanceToBase = _vehicle distance _base;
	_unitsInVehicle = {alive _x} count crew _vehicle;
	_crewGroup = group driver _vehicle;

	if (_distanceToBase > 100) exitWith {hint "The vehicle must be inside the base."};

	if (_unitsInVehicle > ({alive _x} count units _crewGroup)) exitWith {hint "The vehicle has passengers."};

	//"_items", "_positions", "_proximityMode", "_distances", "_checkInterval", "_side", "_aliveCheck", "_TTLCheck"
	[[_vehicle] + units _crewGroup + [_crewGroup], [], 0, [0, 0], 120, civilian, false, false] spawn SAC_fnc_garbageCollector;
	
	if (_callsign == "A") then {SAC_TVU_VehicleReadyA = false} else {SAC_TVU_VehicleReadyB = false};

};

SAC_TVU_CreateRoute = {

	private ["_callsign", "_route", "_vehicle", "_wpColor", "_count", "_lastPos", "_pos", "_temp2DPos", "_lastPos2D",
	"_wpNumber", "_marker", "_distanceFromLastPos", "_heliH", "_dir", "_midWayToNewPos"];

	_callsign = _this select 0;

	if (_callsign == "A") then {
		_route = SAC_TVU_RouteA;
		_vehicle = SAC_TVU_VehicleA;
		_wpColor = "ColorBlack";
	} else {
		_route = SAC_TVU_RouteB;
		_vehicle = SAC_TVU_VehicleB;
		_wpColor = "ColorBlack";
	};

	hint "Click on the map to set route points.";
	
	if (!visibleMap) then {openMap true};

	if ((count _route) > 0) then {
		for "_count" from 1 to (count _route) do {
			deleteMarkerLocal format ["SAC_TVU_wp%1%2", _callsign, _count];
			deleteMarkerLocal format ["SAC_TVU_wp%1%2line", _callsign, _count];
		};
	};

	_route = [];
	SAC_TVU_NewWP = [0,0,0];
	SAC_TVU_TerminateRouteDesignation = false;

	while {!SAC_TVU_TerminateRouteDesignation} do {
		_lastPos = SAC_TVU_NewWP;
		onMapSingleClick "SAC_TVU_NewWP = _pos";
		waitUntil {(str _lastPos != str SAC_TVU_NewWP) || (SAC_TVU_TerminateRouteDesignation)};
		
		if (SAC_TVU_TerminateRouteDesignation) exitWith {};
		
		_temp2DPos = [SAC_TVU_NewWP select 0, SAC_TVU_NewWP select 1];
		_lastPos2D = [_lastPos select 0, _lastPos select 1];

		_route pushBack _temp2DPos;

		_wpNumber = count _route;

		_marker = createMarkerLocal [format["SAC_TVU_wp%1%2", _callsign, _wpNumber], SAC_TVU_NewWP];
		_marker setMarkerTypeLocal "mil_circle";
		_marker setMarkerSizeLocal [0.5, 0.5];
		_marker setMarkerColorLocal _wpColor;
		_marker setMarkerTextLocal format["%1", _wpNumber];
		_marker setMarkerTextLocal format["%1%2", _wpNumber, _callsign];

		if (_wpNumber > 1) then {
			_distanceFromLastPos = _lastPos2D distance _temp2DPos;
			_heliH = createVehicle ["Land_HelipadEmpty_F", _lastPos2D, [], 0, "CAN_COLLIDE"];
			_dir = ((_temp2DPos select 0) - (_lastPos2D select 0)) atan2 ((_temp2DPos select 1) - (_lastPos2D select 1));
			_heliH setDir _dir;
			_midWayToNewPos = _heliH modelToWorld [0, _distanceFromLastPos / 2, 0];
			deleteVehicle _heliH;
			
			_marker = createMarkerLocal [format["SAC_TVU_wp%1%2line", _callsign, _wpNumber], _midWayToNewPos];
			_marker setMarkerShapeLocal "RECTANGLE";
			_marker setMarkerColorLocal "ColorBlack";
			_marker setMarkerSizeLocal [2, _distanceFromLastPos / 2];
			_marker setMarkerDirLocal _dir;
		};
		
	};

	if (_callsign == "A") then {
		 SAC_TVU_RouteA = _route;
	} else {
		 SAC_TVU_RouteB = _route;
	};

};

SAC_TVU_UnloadSupply = {
	private ["_callsign", "_vehicle", "_hasSupply", "_supply", "_boxPos"];

	_callsign = _this select 0;

	if (_callsign == "A") then {
		_vehicle = SAC_TVU_VehicleA;
		_hasSupply = SAC_TVU_VehicleHasSupplyA;
	} else {
		_vehicle = SAC_TVU_VehicleB;
		_hasSupply = SAC_TVU_VehicleHasSupplyB;
	};

	if (!_hasSupply) exitWith {hint "No supplies onboard."};

	if (!isNil "SAC_GEAR") then {
		if (SAC_GEAR) then {
			switch (_vehicle getVariable "SAC_TVU_cargo_capacity") do {
				case "LIGHT": {
					//_supply = createVehicle ["Box_NATO_Ammo_F", _boxPos, [], 0, "CAN_COLLIDE"];
					_boxPos = (getPosATL _vehicle) findEmptyPosition [0, 50, "Box_NATO_Ammo_F"];
					if (count _boxPos == 3) then {
						_supply = createVehicle ["Box_NATO_Ammo_F", _boxPos, [], 0, "NONE"];
						//workaround porque por algún motivo cuando creo las cajas empiezan a tomar daño y no paran hasta que explotan.
						_supply allowDammage false;
						_supply setDammage 0;
						_supply setPosATL _boxPos;
						//[_supply, "SQUAD", "PLAYER_SQUAD_AMMO", "SMALL"] spawn SAC_GEAR_fnc_addContainer;
						[_supply] spawn SAC_GEAR_fnc_activateSupplies;
						if (_callsign == "A") then {SAC_TVU_VehicleHasSupplyA = false} else {SAC_TVU_VehicleHasSupplyB = false};
						
						hint "Supplies unloaded.";
						
					} else {hint "There's no room."};
				};
				case "MEDIUM": {
					_boxPos = (getPosATL _vehicle) findEmptyPosition [0, 50, "B_supplyCrate_F"];
					if (count _boxPos == 3) then {
						_supply = createVehicle ["B_supplyCrate_F", _boxPos, [], 0, "NONE"];
						//workaround porque por algún motivo cuando creo las cajas empiezan a tomar daño y no paran hasta que explotan.
						_supply allowDammage false;
						_supply setDammage 0;
						_supply setPosATL _boxPos;
						//[_supply, "SQUAD", "PLAYER_SQUAD_AMMO", "MEDIUM"] spawn SAC_GEAR_fnc_addContainer;
						[_supply] spawn SAC_GEAR_fnc_activateSupplies;
						if (_callsign == "A") then {SAC_TVU_VehicleHasSupplyA = false} else {SAC_TVU_VehicleHasSupplyB = false};
						
						hint "Supplies unloaded."
						
					} else {hint "There's no room."};
				};
				case "HEAVY": {
					_boxPos = (getPosATL _vehicle) findEmptyPosition [0, 50, "B_supplyCrate_F"];
					if (count _boxPos == 3) then {
						_supply = createVehicle ["B_supplyCrate_F", _boxPos, [], 0, "NONE"];
						//workaround porque por algún motivo cuando creo las cajas empiezan a tomar daño y no paran hasta que explotan.
						_supply allowDammage false;
						_supply setDammage 0;
						_supply setPosATL _boxPos;
						//[_supply, "SQUAD", "PLAYER_SQUAD_AMMO", "LARGE"] spawn SAC_GEAR_fnc_addContainer;
						[_supply] spawn SAC_GEAR_fnc_activateSupplies;
						if (_callsign == "A") then {SAC_TVU_VehicleHasSupplyA = false} else {SAC_TVU_VehicleHasSupplyB = false};
						
						hint "Supplies unloaded."
						
					} else {hint "There's no room."};
				};
			}
		};
	} else {
		
		hint "SAC_GEAR not found.";
		
	};

};

SAC_TVU_LoadSupply = {
	private ["_callsign", "_vehicle", "_hasSupply", "_base", "_distanceToBase", "_alt"];

	_callsign = _this select 0;

	if (_callsign == "A") then {
		_vehicle = SAC_TVU_VehicleA;
		_hasSupply = SAC_TVU_VehicleHasSupplyA;
		_base = SAC_TVU_StartPointAPos;
	} else {
		_vehicle = SAC_TVU_VehicleB;
		_hasSupply = SAC_TVU_VehicleHasSupplyB;
		_base = SAC_TVU_StartPointBPos;
	};

	_distanceToBase = _vehicle distance _base;

	if (_distanceToBase > 100) exitWith {hint "The vehicle must be inside the base."};

	if (_callsign == "A") then {SAC_TVU_VehicleHasSupplyA = true} else {SAC_TVU_VehicleHasSupplyB = true};

	hint "Supplies loaded.";
	
};

SAC_TVU_Stop = {

	private ["_callsign", "_vehicle"];
	
	_callsign = _this select 0;

	if (_callsign == "A") then {
	
		_vehicle = SAC_TVU_VehicleA;

	} else {
	
		_vehicle = SAC_TVU_VehicleB;

	};

	deleteWaypoint [group _vehicle, 1];

	doStop _vehicle;
	
	_vehicle forceSpeed 0;
	_vehicle setVariable ["sac_isforcedSpeedStopped", true];
	
	/*
	_vehicle doMove _destination;

	_vehicle setSpeedMode _speedMode;
	_vehicle setCombatMode _combatMode;
	_vehicle setBehaviourStrong _behaviourMode;
	*/
};

SAC_TVU_MoveToDestination = {

	private ["_callsign", "_destinationMarker", "_ingressType", "_route", "_vehicle", "_speedMode", "_combatMode", "_behaviourMode", "_abortMission",
	"_count", "_destination", "_speedLimit"];


	_callsign = _this select 0;
	_destinationMarker = _this select 1;
	_ingressType = _this select 2;
	//_action = _this select 3;
	//_egressType = _this select 4;

	if ((_ingressType != "RUTA") && !(_destinationMarker in allMapMarkers)) exitWith {hint "Destination is not defined."};

	if (_callsign == "A") then {
		_vehicle = SAC_TVU_VehicleA;
		_speedMode = SAC_TVU_SpeedModeA;
		_speedLimit = SAC_TVU_speedLimitA;
		_combatMode = SAC_TVU_CombatModeA;
		_behaviourMode = SAC_TVU_BehaviourA;
		SAC_TVU_TerminateCurrentMissionA = false;
	} else {
		_vehicle = SAC_TVU_VehicleB;
		_speedMode = SAC_TVU_SpeedModeB;
		_speedLimit = SAC_TVU_speedLimitB;
		_combatMode = SAC_TVU_CombatModeB;
		_behaviourMode = SAC_TVU_BehaviourB;
		SAC_TVU_TerminateCurrentMissionB = false;
	};

	deleteWaypoint [group _vehicle, 1];

	_vehicle setCaptive SAC_TVU_VehicleCaptive;
	
	_abortMission = false;
	
	if (_ingressType == "RUTA") then {

		if (_callsign == "A") then {
		
			_route = SAC_TVU_RouteA;
			
		} else {
		
			_route = SAC_TVU_RouteB;
			
		};
	
	} else {
	
		_route = [getMarkerPos _destinationMarker];
		
	};
	
	if ((count _route) == 0) exitWith {
	
		hint "There are no waypoints.";
	
	};
	
	_vehicle forceSpeed -1;
	_vehicle setVariable ["sac_isforcedSpeedStopped", false];
	//14/03/2019 Esto es para sacarlo del doStop. Honestamente no sé por qué antes funcionaba sin. Posiblemente, sea porque TVU usa "doStop _vehicle" (lo asumo sería equivalente
	//a "doStop leader group _vehicle"), mientras que SAC_fnc_fixGetOut usa "doStop driver _vehicle". La mejor solución fue que a los vehículos de TVU no se les corra SAC_fnc_initVehicle,
	//pero por las dudas agrego esta línea que sirve para recuperarse de un "doStop driver _vehicle".
	units (group leader _vehicle) doFollow leader (group leader _vehicle);
	
	for "_count" from 0 to ((count _route) - 1) do {
	
		_destination = _route select _count;

		//14/3/2019 Hay un problema con los BTR de RHS (ver nota en SAC_fnc_spawnVehicle), que requiere que además de los arreglos mencionados allá,
		//también se cambie el comando "doMove", que usé siempre, por "move". Esto queda a prueba porque no sé cómo lo van a tomar los vehículos que
		//funcionaban perfecto con "doMove".
		_vehicle move _destination;

		_vehicle setSpeedMode _speedMode;
		if (_speedLimit != 999) then {_vehicle forceSpeed (((_speedLimit * 1000) / 60) / 60)};
		_vehicle setCombatMode _combatMode;
		_vehicle setBehaviourStrong _behaviourMode;
		sleep 1;
		////////////////////////////////////////////////////////////////////////
		
		if (_callsign == "A") then {
		
			waitUntil {(unitReady _vehicle) || {moveToFailed _vehicle} || {!canMove _vehicle} || {SAC_TVU_TerminateCurrentMissionA}};
			_abortMission = SAC_TVU_TerminateCurrentMissionA;
			
		} else {
		
			waitUntil {(unitReady _vehicle) || {moveToFailed _vehicle} || {!canMove _vehicle} || {SAC_TVU_TerminateCurrentMissionB}};
			_abortMission = SAC_TVU_TerminateCurrentMissionB;
			
		};
		
		if (_abortMission || (!canMove _vehicle)) exitWith {};
		
		if (_count == (count _route) - 1) then {
		
			//[_vehicle, "Standing by, over."] spawn SAC_fnc_messageFromUnit;
			//hint format ["%1 has reached it's destination.", groupID (group _vehicle)];
			
			if (vehicle player != _vehicle) then {"sac_sounds_waiting" spawn SAC_fnc_playSound};
			[driver _vehicle, "sac_sounds_waiting", 100] spawn SAC_fnc_netSay3D;
			_vehicle sideChat "Echo One to Crossroads, we're in position, over.";
			
			_vehicle forceSpeed 0;
			_vehicle setVariable ["sac_isforcedSpeedStopped", true];
			
		} else {
		
			[_vehicle, format ["Waypoint %1 reached.", _count + 1]] spawn SAC_fnc_messageFromUnit;
			hint format ["Waypoint %1 reached.", _count + 1];		
		
		};

	};
		
	if (_abortMission || (!canMove _vehicle)) exitWith {};

	//doStop _vehicle;

};

SAC_TVU_CreateVehicle = {

	private ["_callsign", "_vehicleType", "_startPoint", "_startPointDir", "_ready", "_crewGroup", "_mapName",
	"_vehicleClass", "_behaviourMode", "_vehicle", "_capacity", "_crewType", "_protectedParts"];

	_callsign = _this select 0;
	_vehicleType = _this select 1;

	if (_callsign == "A") then {
		_startPoint = SAC_TVU_StartPointAPos;
		_startPointDir = SAC_TVU_StartPointADir;
	} else {
		_startPoint = SAC_TVU_StartPointBPos;
		_startPointDir = SAC_TVU_StartPointBDir;
	};

	_protectedParts = [];

	//_mapName = getText (configFile >> "CfgWorlds" >> worldName >> "description");

	switch (_vehicleType) do {
	
		case "IFV-6c Panther": {
			_vehicleClass = switch (toLower worldName) do {
				case "tanoa": {"B_T_APC_Tracked_01_rcws_F"};
				default {"B_APC_Tracked_01_rcws_F"};
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};		
		case "M2A1 Slammer": {
			_vehicleClass = switch (toLower worldName) do {
				case "tanoa": {"B_T_MBT_01_cannon_F"};
				default {"B_MBT_01_cannon_F"};
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M2A4 Slammer": {
			_vehicleClass = switch (toLower worldName) do {
				case "tanoa": {"B_T_MBT_01_TUSK_F"};
				default {"B_MBT_01_TUSK_F"};
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "T-140 Angara": {
			_vehicleClass = switch (toLower worldName) do {
				case "tanoa": {"O_T_MBT_04_cannon_F"};
				default {"O_MBT_04_cannon_F"};
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};	
		case "Hunter HMG": {
			_vehicleClass = "B_MRAP_01_hmg_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};		
		case "HEMTT (Covered)": {
			_vehicleClass = "B_Truck_01_covered_F";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};		
		case "AMV-7 Marshall": {
			_vehicleClass = switch (toLower worldName) do {
				case "tanoa": {"B_T_APC_Wheeled_01_cannon_F"};
				default {"B_APC_Wheeled_01_cannon_F"};
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
			_protectedParts = ["wheel_1_1_steering","wheel_1_2_steering","wheel_1_3_steering","wheel_1_4_steering","wheel_2_1_steering","wheel_2_2_steering","wheel_2_3_steering","wheel_2_4_steering"];
		};
		case "Strider HMG": {
			_vehicleClass = "I_MRAP_03_hmg_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Zamak (Covered)": {
			switch (faction player) do {
		
				case "OPF_F": {_vehicleClass = "O_Truck_02_covered_F"};
				case "OPF_G_F": {_vehicleClass = "O_Truck_02_covered_F "};
				case "BLU_F": {_vehicleClass = "I_Truck_02_covered_F"};
				case "BLU_G_F": {_vehicleClass = "I_Truck_02_covered_F"};
				case "IND_F": {_vehicleClass = "I_Truck_02_covered_F"};
				case "IND_G_F": {_vehicleClass = "I_Truck_02_covered_F"};
				case "CIV_F": {_vehicleClass = "I_Truck_02_covered_F"};
				case "rhsgref_faction_cdf_ground": {_vehicleClass = "I_Truck_02_covered_F"};
				default {_vehicleClass = "I_Truck_02_covered_F"};
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "AFV-4 Gorgon": {
			_vehicleClass = "I_APC_Wheeled_03_cannon_F";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
			_protectedParts = ["wheel_1_1_steering","wheel_1_2_steering","wheel_1_3_steering","wheel_1_4_steering","wheel_2_1_steering","wheel_2_2_steering","wheel_2_3_steering","wheel_2_4_steering"];
		};
		case "FV-720 Mora": {
			_vehicleClass = "I_APC_tracked_03_cannon_F";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "MBT-52 Kuma": {
			_vehicleClass = "I_MBT_03_cannon_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "Ifrit": {
			_vehicleClass = "O_MRAP_02_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Ifrit HMG": {
			_vehicleClass = "O_MRAP_02_hmg_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Ifrit GMG": {
			_vehicleClass = "O_MRAP_02_gmg_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Offroad": {
			switch (faction player) do {
			
				case "OPF_F";
				case "OPF_G_F": {_vehicleClass = "O_G_Offroad_01_F"};
				case "BLU_F";
				case "BLU_G_F": {_vehicleClass = "B_G_Offroad_01_F"};
				case "IND_F";
				case "IND_G_F": {_vehicleClass = "I_G_Offroad_01_F"};
				case "CIV_F": {_vehicleClass = "C_Offroad_01_F"};
				case "rhsgref_faction_cdf_ground": {_vehicleClass = "I_G_Offroad_01_F"};
				default {_vehicleClass = "C_Offroad_01_F"};
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Offroad (Armed)": {
			switch (faction player) do {
			
				case "OPF_F";
				case "OPF_G_F": {_vehicleClass = "O_G_Offroad_01_armed_F"};
				case "BLU_F";
				case "BLU_G_F": {_vehicleClass = "B_G_Offroad_01_armed_F"};
				case "IND_F";
				case "IND_G_F": {_vehicleClass = "I_G_Offroad_01_armed_F"};
				case "CIV_F": {_vehicleClass = "I_G_Offroad_01_armed_F"};
				case "rhsgref_faction_cdf_ground": {_vehicleClass = "I_G_Offroad_01_armed_F"};
				default {_vehicleClass = "I_G_Offroad_01_armed_F"};
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Quadbike": {
			switch (faction player) do {
		
				case "OPF_F": {_vehicleClass = "O_Quadbike_01_F"};
				case "OPF_G_F": {_vehicleClass = "O_G_Quadbike_01_F"};
				case "BLU_F": {_vehicleClass = "B_Quadbike_01_F"};
				case "BLU_G_F": {_vehicleClass = "B_G_Quadbike_01_F"};
				case "IND_F": {_vehicleClass = "I_Quadbike_01_F"};
				case "IND_G_F": {_vehicleClass = "I_G_Quadbike_01_F"};
				case "CIV_F": {_vehicleClass = "C_Quadbike_01_F"};
				case "rhsgref_faction_cdf_ground": {_vehicleClass = "I_G_Quadbike_01_F"};
				default {_vehicleClass = "C_Quadbike_01_F"};
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Tempest (Covered)": {
			_vehicleClass = "O_Truck_03_covered_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Truck": {
			switch (faction player) do {
		
				case "OPF_F": {_vehicleClass = "O_G_Van_01_transport_F"};
				case "OPF_G_F": {_vehicleClass = "O_G_Van_01_transport_F"};
				case "BLU_F": {_vehicleClass = "B_G_Van_01_transport_F"};
				case "BLU_G_F": {_vehicleClass = "B_G_Van_01_transport_F"};
				case "IND_F": {_vehicleClass = "I_G_Van_01_transport_F"};
				case "IND_G_F": {_vehicleClass = "I_G_Van_01_transport_F"};
				case "CIV_F": {_vehicleClass = "C_Van_01_transport_F"};
				case "rhsgref_faction_cdf_ground": {_vehicleClass = "I_G_Van_01_transport_F"};
				default {_vehicleClass = "C_Van_01_transport_F"};
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Hunter": {
			_vehicleClass = "B_MRAP_01_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Hunter GMG": {
			_vehicleClass = "B_MRAP_01_gmg_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "HEMTT (Covered)": {
			_vehicleClass = "B_Truck_01_covered_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Strider": {
			_vehicleClass = "I_MRAP_03_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Strider GMG": {
			_vehicleClass = "I_MRAP_03_gmg_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "SUV": {
			_vehicleClass = "C_SUV_01_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "T-100 Varsuk": {
			_vehicleClass = "O_MBT_02_cannon_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "BTR-K Kamysh": {
			_vehicleClass = "O_APC_Tracked_02_cannon_F";
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "MSE-3 Marid": {
			_vehicleClass = switch (toLower worldName) do {
				case "tanoa": {"O_T_APC_Wheeled_02_rcws_v2_ghex_F"};
				default {"O_APC_Wheeled_02_rcws_v2_F"};
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
	
		
		case "M1A1SA": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "ruha";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m1a1aimwd_usarmy"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m1a1aimwd_usarmy"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m1a1aimd_usarmy"};
				case "zargabad": {_vehicleClass = "rhsusf_m1a1aimd_usarmy"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m1a1aimd_usarmy"};
				case "fata": {_vehicleClass = "rhsusf_m1a1aimwd_usarmy"};
				case "praa_av": {_vehicleClass = "rhsusf_m1a1aimd_usarmy"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m1a1aimd_usarmy"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m1a1aimd_usarmy"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m1a1aimwd_usarmy"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m1a1aimwd_usarmy"};
				case "bornholm": {_vehicleClass = "rhsusf_m1a1aimwd_usarmy"};
				case "isladuala3": {_vehicleClass = "rhsusf_m1a1aimwd_usarmy"};
				case "panthera3": {_vehicleClass = "rhsusf_m1a1aimwd_usarmy"};
				case "pja305": {_vehicleClass = "rhsusf_m1a1aimwd_usarmy"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m1a1aimwd_usarmy"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M1A1SA (TUSK 1)": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m1a1aim_tuski_wd"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m1a1aim_tuski_wd"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m1a1aim_tuski_d"};
				case "zargabad": {_vehicleClass = "rhsusf_m1a1aim_tuski_d"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m1a1aim_tuski_d"};
				case "fata": {_vehicleClass = "rhsusf_m1a1aim_tuski_wd"};
				case "praa_av": {_vehicleClass = "rhsusf_m1a1aim_tuski_d"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m1a1aim_tuski_d"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m1a1aim_tuski_d"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m1a1aim_tuski_wd"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m1a1aim_tuski_wd"};
				case "bornholm": {_vehicleClass = "rhsusf_m1a1aim_tuski_wd"};
				case "isladuala3": {_vehicleClass = "rhsusf_m1a1aim_tuski_wd"};
				case "panthera3": {_vehicleClass = "rhsusf_m1a1aim_tuski_wd"};
				case "pja305": {_vehicleClass = "rhsusf_m1a1aim_tuski_wd"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m1a1aim_tuski_wd"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M1A1SEPv1": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m1a2sep1wd_usarmy"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m1a2sep1wd_usarmy"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m1a2sep1d_usarmy"};
				case "zargabad": {_vehicleClass = "rhsusf_m1a2sep1d_usarmy"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m1a2sep1d_usarmy"};
				case "fata": {_vehicleClass = "rhsusf_m1a2sep1wd_usarmy"};
				case "praa_av": {_vehicleClass = "rhsusf_m1a2sep1d_usarmy"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m1a2sep1d_usarmy"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m1a2sep1d_usarmy"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m1a2sep1wd_usarmy"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m1a2sep1wd_usarmy"};
				case "bornholm": {_vehicleClass = "rhsusf_m1a2sep1wd_usarmy"};
				case "isladuala3": {_vehicleClass = "rhsusf_m1a2sep1wd_usarmy"};
				case "panthera3": {_vehicleClass = "rhsusf_m1a2sep1wd_usarmy"};
				case "pja305": {_vehicleClass = "rhsusf_m1a2sep1wd_usarmy"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m1a2sep1wd_usarmy"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M1A1SEPv1 (TUSK I)": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m1a2sep1tuskiwd_usarmy"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m1a2sep1tuskiwd_usarmy"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m1a2sep1tuskid_usarmy"};
				case "zargabad": {_vehicleClass = "rhsusf_m1a2sep1tuskid_usarmy"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m1a2sep1tuskid_usarmy"};
				case "fata": {_vehicleClass = "rhsusf_m1a2sep1tuskiwd_usarmy"};
				case "praa_av": {_vehicleClass = "rhsusf_m1a2sep1tuskid_usarmy"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m1a2sep1tuskid_usarmy"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m1a2sep1tuskid_usarmy"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m1a2sep1tuskiwd_usarmy"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m1a2sep1tuskiwd_usarmy"};
				case "bornholm": {_vehicleClass = "rhsusf_m1a2sep1tuskiwd_usarmy"};
				case "isladuala3": {_vehicleClass = "rhsusf_m1a2sep1tuskiwd_usarmy"};
				case "panthera3": {_vehicleClass = "rhsusf_m1a2sep1tuskiwd_usarmy"};
				case "pja305": {_vehicleClass = "rhsusf_m1a2sep1tuskiwd_usarmy"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m1a2sep1tuskiwd_usarmy"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M1A1SEPv1 (TUSK II)": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m1a2sep1tuskiiwd_usarmy"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m1a2sep1tuskiiwd_usarmy"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m1a2sep1tuskiid_usarmy"};
				case "zargabad": {_vehicleClass = "rhsusf_m1a2sep1tuskiid_usarmy"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m1a2sep1tuskiid_usarmy"};
				case "fata": {_vehicleClass = "rhsusf_m1a2sep1tuskiiwd_usarmy"};
				case "praa_av": {_vehicleClass = "rhsusf_m1a2sep1tuskiid_usarmy"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m1a2sep1tuskiid_usarmy"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m1a2sep1tuskiid_usarmy"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m1a2sep1tuskiiwd_usarmy"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m1a2sep1tuskiiwd_usarmy"};
				case "bornholm": {_vehicleClass = "rhsusf_m1a2sep1tuskiiwd_usarmy"};
				case "isladuala3": {_vehicleClass = "rhsusf_m1a2sep1tuskiiwd_usarmy"};
				case "panthera3": {_vehicleClass = "rhsusf_m1a2sep1tuskiiwd_usarmy"};
				case "pja305": {_vehicleClass = "rhsusf_m1a2sep1tuskiiwd_usarmy"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m1a2sep1tuskiiwd_usarmy"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M1A1FEP": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m1a1fep_wd"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m1a1fep_wd"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m1a1fep_d"};
				case "zargabad": {_vehicleClass = "rhsusf_m1a1fep_d"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m1a1fep_d"};
				case "fata": {_vehicleClass = "rhsusf_m1a1fep_wd"};
				case "praa_av": {_vehicleClass = "rhsusf_m1a1fep_d"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m1a1fep_d"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m1a1fep_d"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m1a1fep_wd"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m1a1fep_wd"};
				case "bornholm": {_vehicleClass = "rhsusf_m1a1fep_wd"};
				case "isladuala3": {_vehicleClass = "rhsusf_m1a1fep_wd"};
				case "panthera3": {_vehicleClass = "rhsusf_m1a1fep_wd"};
				case "pja305": {_vehicleClass = "rhsusf_m1a1fep_wd"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m1a1fep_wd"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M1A1FEP (O)": {
			_vehicleClass = "rhsusf_m1a1fep_od";
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		
		
		
		case "T-72B (1984)": {
			_vehicleClass = "rhs_t72ba_tv";
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "T-80B": {
			_vehicleClass = "rhs_t80b";
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "T-80BK": {
			_vehicleClass = "rhs_t80bk";
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "T-90A (2006)": {
			_vehicleClass = "rhs_t90a_tv";
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		
		
		case "M1A1": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "chernarus": {_vehicleClass = "CUP_B_M1A1_Woodland_US_Army"};
				case "woodland_acr": {_vehicleClass = "CUP_B_M1A1_Woodland_US_Army"};//Bystrica
				case "fallujah": {_vehicleClass = "CUP_B_M1A1_DES_US_Army"};
				case "zargabad": {_vehicleClass = "CUP_B_M1A1_DES_US_Army"};
				case "mcm_aliabad": {_vehicleClass = "CUP_B_M1A1_DES_US_Army"};
				case "fata": {_vehicleClass = "CUP_B_M1A1_Woodland_US_Army"};
				case "praa_av": {_vehicleClass = "CUP_B_M1A1_DES_US_Army"};//afghan village
				case "kunduz": {_vehicleClass = "CUP_B_M1A1_DES_US_Army"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "CUP_B_M1A1_DES_US_Army"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "CUP_B_M1A1_Woodland_US_Army"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "CUP_B_M1A1_Woodland_US_Army"};
				case "bornholm": {_vehicleClass = "CUP_B_M1A1_Woodland_US_Army"};
				case "isladuala3": {_vehicleClass = "CUP_B_M1A1_Woodland_US_Army"};
				case "panthera3": {_vehicleClass = "CUP_B_M1A1_Woodland_US_Army"};
				case "pja305": {_vehicleClass = "CUP_B_M1A1_Woodland_US_Army"};//Nziwasogo
				case default {_vehicleClass = "CUP_B_M1A1_Woodland_US_Army"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M1A2 TUSK": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "chernarus": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_US_Army"};
				case "woodland_acr": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_US_Army"};//Bystrica
				case "fallujah": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_DES_US_Army"};
				case "zargabad": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_DES_US_Army"};
				case "mcm_aliabad": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_DES_US_Army"};
				case "fata": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_US_Army"};
				case "praa_av": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_DES_US_Army"};//afghan village
				case "kunduz": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_DES_US_Army"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_DES_US_Army"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_US_Army"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_US_Army"};
				case "bornholm": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_US_Army"};
				case "isladuala3": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_US_Army"};
				case "panthera3": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_US_Army"};
				case "pja305": {_vehicleClass = "CUP_B_M1A2_TUSK_MG_US_Army"};//Nziwasogo
				case default {_vehicleClass = "CUP_B_M1A2_TUSK_MG_US_Army"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "T-72": {
			_vehicleClass = "CUP_O_T72_RU";
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "T-90": {
			_vehicleClass = "CUP_O_T90_RU";
			_capacity = "SMALL";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};		
		
		case "BMP-1D": {
			_vehicleClass = "rhs_bmp1d_msv";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "BMP-2D": {
			_vehicleClass = "rhs_bmp2d_msv";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "BMP-3 early": {
			_vehicleClass = "rhs_bmp3_msv";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "BMP-3 late": {
			_vehicleClass = "rhs_bmp3_late_msv";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "BMP-3 Vesna-K": {
			_vehicleClass = "rhs_bmp3m_msv";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "BMP-3 Vesna-K/A": {
			_vehicleClass = "rhs_bmp3mera_msv";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "BTR-60PB": {
			_vehicleClass = "rhs_btr60_msv";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "BTR-70": {
			_vehicleClass = "rhs_btr70_msv";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "BTR-80": {
			_vehicleClass = "rhs_btr80_msv";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "BRDM 2": {
			_vehicleClass = "rhsgref_brdm2_msv";
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "AWARE";
		};
		case "STRIKER M2": {
			_vehicleClass = switch (toLower worldName) do {
				case "fallujah";
				case "zargabad";
				case "mcm_aliabad";
				case "praa_av";//afghan village
				case "kunduz";
				case "dya"; //Diyala
				case "lythium";
				case "kidal";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {"rhsusf_stryker_m1126_m2_d"};
				case default {"rhsusf_stryker_m1126_m2_wd"};
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
			//_protectedParts = ["wheel_1_1_steering","wheel_1_2_steering","wheel_1_3_steering","wheel_1_4_steering","wheel_2_1_steering","wheel_2_2_steering","wheel_2_3_steering","wheel_2_4_steering"];
		};
		
		//CUP
		case "HMMWV M2": {
			_vehicleClass = "CUP_B_HMMWV_M2_USMC";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "HMMWV M240": {
			_vehicleClass = "CUP_B_HMMWV_M1114_USMC";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Ural": {
			_vehicleClass = "CUP_B_Ural_CDF";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Land Rover": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "chernarus": {_vehicleClass = "CUP_B_LR_Transport_GB_W"};
				case "woodland_acr": {_vehicleClass = "CUP_B_LR_Transport_GB_W"};//Bystrica
				case "fallujah": {_vehicleClass = "CUP_B_LR_Transport_GB_D"};
				case "zargabad": {_vehicleClass = "CUP_B_LR_Transport_GB_D"};
				case "mcm_aliabad": {_vehicleClass = "CUP_B_LR_Transport_GB_D"};
				case "fata": {_vehicleClass = "CUP_B_LR_Transport_GB_W"};
				case "praa_av": {_vehicleClass = "CUP_B_LR_Transport_GB_D"};//afghan village
				case "kunduz": {_vehicleClass = "CUP_B_LR_Transport_GB_D"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "CUP_B_LR_Transport_GB_D"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "CUP_B_LR_Transport_GB_W"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "CUP_B_LR_Transport_GB_W"};
				case "bornholm": {_vehicleClass = "CUP_B_LR_Transport_GB_W"};
				case "isladuala3": {_vehicleClass = "CUP_B_LR_Transport_GB_W"};
				case "panthera3": {_vehicleClass = "CUP_B_LR_Transport_GB_W"};
				case "pja305": {_vehicleClass = "CUP_B_LR_Transport_GB_W"};//Nziwasogo
				case default {_vehicleClass = "CUP_B_LR_Transport_GB_W"};
				
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Land Rover (M2)": {
			_vehicleClass = "CUP_B_LR_MG_GB_W";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Jackal GMG": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "chernarus": {_vehicleClass = "CUP_BAF_Jackal2_GMG_W"};
				case "woodland_acr": {_vehicleClass = "CUP_BAF_Jackal2_GMG_W"};//Bystrica
				case "fallujah": {_vehicleClass = "CUP_BAF_Jackal2_GMG_D"};
				case "zargabad": {_vehicleClass = "CUP_BAF_Jackal2_GMG_D"};
				case "mcm_aliabad": {_vehicleClass = "CUP_BAF_Jackal2_GMG_D"};
				case "fata": {_vehicleClass = "CUP_BAF_Jackal2_GMG_W"};
				case "praa_av": {_vehicleClass = "CUP_BAF_Jackal2_GMG_D"};//afghan village
				case "kunduz": {_vehicleClass = "CUP_BAF_Jackal2_GMG_D"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "CUP_BAF_Jackal2_GMG_D"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "CUP_BAF_Jackal2_GMG_W"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "CUP_BAF_Jackal2_GMG_W"};
				case "bornholm": {_vehicleClass = "CUP_BAF_Jackal2_GMG_W"};
				case "isladuala3": {_vehicleClass = "CUP_BAF_Jackal2_GMG_W"};
				case "panthera3": {_vehicleClass = "CUP_BAF_Jackal2_GMG_W"};
				case "pja305": {_vehicleClass = "CUP_BAF_Jackal2_GMG_W"};//Nziwasogo
				case default {_vehicleClass = "CUP_BAF_Jackal2_GMG_W"};
				
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Jackal L2A1": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "chernarus": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_W"};
				case "woodland_acr": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_W"};//Bystrica
				case "fallujah": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_D"};
				case "zargabad": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_D"};
				case "mcm_aliabad": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_D"};
				case "fata": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_W"};
				case "praa_av": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_D"};//afghan village
				case "kunduz": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_D"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_D"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_W"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_W"};
				case "bornholm": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_W"};
				case "isladuala3": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_W"};
				case "panthera3": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_W"};
				case "pja305": {_vehicleClass = "CUP_BAF_Jackal2_L2A1_W"};//Nziwasogo
				case default {_vehicleClass = "CUP_BAF_Jackal2_L2A1_W"};
				
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "Land Rover (Special)": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "chernarus": {_vehicleClass = "CUP_B_LR_Special_CZ_W"};
				case "woodland_acr": {_vehicleClass = "CUP_B_LR_Special_CZ_W"};//Bystrica
				case "fallujah": {_vehicleClass = "CUP_B_LR_Special_CZ_D"};
				case "zargabad": {_vehicleClass = "CUP_B_LR_Special_CZ_D"};
				case "mcm_aliabad": {_vehicleClass = "CUP_B_LR_Special_CZ_D"};
				case "fata": {_vehicleClass = "CUP_B_LR_Special_CZ_W"};
				case "praa_av": {_vehicleClass = "CUP_B_LR_Special_CZ_D"};//afghan village
				case "kunduz": {_vehicleClass = "CUP_B_LR_Special_CZ_D"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "CUP_B_LR_Special_CZ_D"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "CUP_B_LR_Special_CZ_W"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "CUP_B_LR_Special_CZ_W"};
				case "bornholm": {_vehicleClass = "CUP_B_LR_Special_CZ_W"};
				case "isladuala3": {_vehicleClass = "CUP_B_LR_Special_CZ_W"};
				case "panthera3": {_vehicleClass = "CUP_B_LR_Special_CZ_W"};
				case "pja305": {_vehicleClass = "CUP_B_LR_Special_CZ_W"};//Nziwasogo
				case default {_vehicleClass = "CUP_B_LR_Special_CZ_W"};
				
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		
		case "BMP-2": {
			_vehicleClass = "CUP_O_BMP2_RU";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		
		case "BMP-3": {
			_vehicleClass = "CUP_O_BMP3_RU";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		
		case "M113A3 (M2)": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m113_usarmy"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m113_usarmy"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m113d_usarmy"};
				case "zargabad": {_vehicleClass = "rhsusf_m113d_usarmy"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m113d_usarmy"};
				case "fata": {_vehicleClass = "rhsusf_m113_usarmy"};
				case "praa_av": {_vehicleClass = "rhsusf_m113d_usarmy"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m113d_usarmy"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m113d_usarmy"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m113_usarmy"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m113_usarmy"};
				case "bornholm": {_vehicleClass = "rhsusf_m113_usarmy"};
				case "isladuala3": {_vehicleClass = "rhsusf_m113_usarmy"};
				case "panthera3": {_vehicleClass = "rhsusf_m113_usarmy"};
				case "pja305": {_vehicleClass = "rhsusf_m113_usarmy"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m113_usarmy"};
				
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M2A2": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "RHS_M2A2_wd"};
				case "woodland_acr": {_vehicleClass = "RHS_M2A2_wd"};//Bystrica
				case "fallujah": {_vehicleClass = "RHS_M2A2"};
				case "zargabad": {_vehicleClass = "RHS_M2A2"};
				case "mcm_aliabad": {_vehicleClass = "RHS_M2A2"};
				case "fata": {_vehicleClass = "RHS_M2A2_wd"};
				case "praa_av": {_vehicleClass = "RHS_M2A2"};//afghan village
				case "kunduz": {_vehicleClass = "RHS_M2A2"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "RHS_M2A2"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "RHS_M2A2_wd"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "RHS_M2A2_wd"};
				case "bornholm": {_vehicleClass = "RHS_M2A2_wd"};
				case "isladuala3": {_vehicleClass = "RHS_M2A2_wd"};
				case "panthera3": {_vehicleClass = "RHS_M2A2_wd"};
				case "pja305": {_vehicleClass = "RHS_M2A2_wd"};//Nziwasogo
				case default {_vehicleClass = "RHS_M2A2_wd"};
				
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M2A2 BUSK": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "RHS_M2A2_BUSKI_WD"};
				case "woodland_acr": {_vehicleClass = "RHS_M2A2_BUSKI_WD"};//Bystrica
				case "fallujah": {_vehicleClass = "RHS_M2A2_BUSKI"};
				case "zargabad": {_vehicleClass = "RHS_M2A2_BUSKI"};
				case "mcm_aliabad": {_vehicleClass = "RHS_M2A2_BUSKI"};
				case "fata": {_vehicleClass = "RHS_M2A2_BUSKI_WD"};
				case "praa_av": {_vehicleClass = "RHS_M2A2_BUSKI"};//afghan village
				case "kunduz": {_vehicleClass = "RHS_M2A2_BUSKI"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "RHS_M2A2_BUSKI"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "RHS_M2A2_BUSKI_WD"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "RHS_M2A2_BUSKI_WD"};
				case "bornholm": {_vehicleClass = "RHS_M2A2_BUSKI_WD"};
				case "isladuala3": {_vehicleClass = "RHS_M2A2_BUSKI_WD"};
				case "panthera3": {_vehicleClass = "RHS_M2A2_BUSKI_WD"};
				case "pja305": {_vehicleClass = "RHS_M2A2_BUSKI_WD"};//Nziwasogo
				case default {_vehicleClass = "RHS_M2A2_BUSKI_WD"};
				
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M2A3": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "RHS_M2A3_wd"};
				case "woodland_acr": {_vehicleClass = "RHS_M2A3_wd"};//Bystrica
				case "fallujah": {_vehicleClass = "RHS_M2A3"};
				case "zargabad": {_vehicleClass = "RHS_M2A3"};
				case "mcm_aliabad": {_vehicleClass = "RHS_M2A3"};
				case "fata": {_vehicleClass = "RHS_M2A3_wd"};
				case "praa_av": {_vehicleClass = "RHS_M2A3"};//afghan village
				case "kunduz": {_vehicleClass = "RHS_M2A3"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "RHS_M2A3"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "RHS_M2A3_wd"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "RHS_M2A3_wd"};
				case "bornholm": {_vehicleClass = "RHS_M2A3_wd"};
				case "isladuala3": {_vehicleClass = "RHS_M2A3_wd"};
				case "panthera3": {_vehicleClass = "RHS_M2A3_wd"};
				case "pja305": {_vehicleClass = "RHS_M2A3_wd"};//Nziwasogo
				case default {_vehicleClass = "RHS_M2A3_wd"};
				
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		case "M2A3 BUSK": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "RHS_M2A3_BUSKI_wd"};
				case "woodland_acr": {_vehicleClass = "RHS_M2A3_BUSKI_wd"};//Bystrica
				case "fallujah": {_vehicleClass = "RHS_M2A3_BUSKI"};
				case "zargabad": {_vehicleClass = "RHS_M2A3_BUSKI"};
				case "mcm_aliabad": {_vehicleClass = "RHS_M2A3_BUSKI"};
				case "fata": {_vehicleClass = "RHS_M2A3_BUSKI_wd"};
				case "praa_av": {_vehicleClass = "RHS_M2A3_BUSKI"};//afghan village
				case "kunduz": {_vehicleClass = "RHS_M2A3_BUSKI"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "RHS_M2A3_BUSKI"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "RHS_M2A3_BUSKI_wd"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "RHS_M2A3_BUSKI_wd"};
				case "bornholm": {_vehicleClass = "RHS_M2A3_BUSKI_wd"};
				case "isladuala3": {_vehicleClass = "RHS_M2A3_BUSKI_wd"};
				case "panthera3": {_vehicleClass = "RHS_M2A3_BUSKI_wd"};
				case "pja305": {_vehicleClass = "RHS_M2A3_BUSKI_wd"};//Nziwasogo
				case default {_vehicleClass = "RHS_M2A3_BUSKI_wd"};
				
			};
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_TanksCrewClass;
			_behaviourMode = "AWARE";
		};
		
		
		case "RG-33": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_rg33_wd"};
				case "woodland_acr": {_vehicleClass = "rhsusf_rg33_wd"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_rg33_d"};
				case "zargabad": {_vehicleClass = "rhsusf_rg33_d"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_rg33_d"};
				case "fata": {_vehicleClass = "rhsusf_rg33_wd"};
				case "praa_av": {_vehicleClass = "rhsusf_rg33_d"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_rg33_d"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_rg33_d"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_rg33_wd"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_rg33_wd"};
				case "bornholm": {_vehicleClass = "rhsusf_rg33_wd"};
				case "isladuala3": {_vehicleClass = "rhsusf_rg33_wd"};
				case "panthera3": {_vehicleClass = "rhsusf_rg33_wd"};
				case "pja305": {_vehicleClass = "rhsusf_rg33_wd"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_rg33_wd"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "RG-33 M2": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_rg33_m2_wd"};
				case "woodland_acr": {_vehicleClass = "rhsusf_rg33_m2_wd"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_rg33_m2_d"};
				case "zargabad": {_vehicleClass = "rhsusf_rg33_m2_d"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_rg33_m2_d"};
				case "fata": {_vehicleClass = "rhsusf_rg33_m2_wd"};
				case "praa_av": {_vehicleClass = "rhsusf_rg33_m2_d"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_rg33_m2_d"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_rg33_m2_d"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_rg33_m2_wd"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_rg33_m2_wd"};
				case "bornholm": {_vehicleClass = "rhsusf_rg33_m2_wd"};
				case "isladuala3": {_vehicleClass = "rhsusf_rg33_m2_wd"};
				case "panthera3": {_vehicleClass = "rhsusf_rg33_m2_wd"};
				case "pja305": {_vehicleClass = "rhsusf_rg33_m2_wd"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_rg33_m2_wd"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "M1025A2 M2": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m1025_w_m2"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m1025_w_m2"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m1025_d_m2"};
				case "zargabad": {_vehicleClass = "rhsusf_m1025_d_m2"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m1025_d_m2"};
				case "fata": {_vehicleClass = "rhsusf_m1025_w_m2"};
				case "praa_av": {_vehicleClass = "rhsusf_m1025_d_m2"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m1025_d_m2"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m1025_d_m2"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m1025_w_m2"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m1025_w_m2"};
				case "bornholm": {_vehicleClass = "rhsusf_m1025_w_m2"};
				case "isladuala3": {_vehicleClass = "rhsusf_m1025_w_m2"};
				case "panthera3": {_vehicleClass = "rhsusf_m1025_w_m2"};
				case "pja305": {_vehicleClass = "rhsusf_m1025_w_m2"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m1025_w_m2"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "M1025A2 Unarmed": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m1025_w"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m1025_w"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m1025_d"};
				case "zargabad": {_vehicleClass = "rhsusf_m1025_d"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m1025_d"};
				case "fata": {_vehicleClass = "rhsusf_m1025_w"};
				case "praa_av": {_vehicleClass = "rhsusf_m1025_d"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m1025_d"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m1025_d"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m1025_w"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m1025_w"};
				case "bornholm": {_vehicleClass = "rhsusf_m1025_w"};
				case "isladuala3": {_vehicleClass = "rhsusf_m1025_w"};
				case "panthera3": {_vehicleClass = "rhsusf_m1025_w"};
				case "pja305": {_vehicleClass = "rhsusf_m1025_w"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m1025_w"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "M1097A2": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m998_w_2dr_fulltop"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m998_w_2dr_fulltop"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m998_d_2dr_fulltop"};
				case "zargabad": {_vehicleClass = "rhsusf_m998_d_2dr_fulltop"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m998_d_2dr_fulltop"};
				case "fata": {_vehicleClass = "rhsusf_m998_w_2dr_fulltop"};
				case "praa_av": {_vehicleClass = "rhsusf_m998_d_2dr_fulltop"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m998_d_2dr_fulltop"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m998_d_2dr_fulltop"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m998_w_2dr_fulltop"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m998_w_2dr_fulltop"};
				case "bornholm": {_vehicleClass = "rhsusf_m998_w_2dr_fulltop"};
				case "isladuala3": {_vehicleClass = "rhsusf_m998_w_2dr_fulltop"};
				case "panthera3": {_vehicleClass = "rhsusf_m998_w_2dr_fulltop"};
				case "pja305": {_vehicleClass = "rhsusf_m998_w_2dr_fulltop"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m998_w_2dr_fulltop"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "M1097A2 4D/Open": {
			switch (toLower(worldName)) do
			{

				case "chernarus_winter";
				case "chernarus_summer";
				case "eden";
				case "chernarus": {_vehicleClass = "rhsusf_m998_w_4dr"};
				case "woodland_acr": {_vehicleClass = "rhsusf_m998_w_4dr"};//Bystrica
				case "fallujah": {_vehicleClass = "rhsusf_m998_d_4dr"};
				case "zargabad": {_vehicleClass = "rhsusf_m998_d_4dr"};
				case "mcm_aliabad": {_vehicleClass = "rhsusf_m998_d_4dr"};
				case "fata": {_vehicleClass = "rhsusf_m998_w_4dr"};
				case "praa_av": {_vehicleClass = "rhsusf_m998_d_4dr"};//afghan village
				case "kunduz": {_vehicleClass = "rhsusf_m998_d_4dr"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "tem_anizay";
				case "takistan": {_vehicleClass = "rhsusf_m998_d_4dr"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "smd_sahrani_a2": {_vehicleClass = "rhsusf_m998_w_4dr"};
				case "tembelan";
				case "malden";
				case "altis": {_vehicleClass = "rhsusf_m998_w_4dr"};
				case "bornholm": {_vehicleClass = "rhsusf_m998_w_4dr"};
				case "isladuala3": {_vehicleClass = "rhsusf_m998_w_4dr"};
				case "panthera3": {_vehicleClass = "rhsusf_m998_w_4dr"};
				case "pja305": {_vehicleClass = "rhsusf_m998_w_4dr"};//Nziwasogo
				case default {_vehicleClass = "rhsusf_m998_w_4dr"};
				
			};
			_capacity = "SMALL";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "M1083A1P2-B": {
			_vehicleClass = "rhsusf_M1083A1P2_B_wd_fmtv_usarmy";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		case "M1083A1P2-B M2": {
			_vehicleClass = "rhsusf_M1083A1P2_B_M2_wd_fmtv_usarmy";
			_capacity = "MEDIUM";
			_crewType = SAC_TVU_CarsCrewClass;
			_behaviourMode = "CARELESS";
		};
		
	};

	private _returnedArray =  [];
	//["_position", "_direction", "_vehicleClasses", "_crewClasses", "_special", "_autoDeleteGroup"]
	_returnedArray = [_startPoint, _startPointDir, [_vehicleClass], [_crewType], "CAN_COLLIDE", false] call SAC_fnc_spawnVehicle;
	_vehicle = _returnedArray select 0;
	_crewGroup = _returnedArray select 1;
	
	_crewGroup setVariable ["Vcm_Disable", true];
	(group _vehicle) setVariable ["Vcm_Disable", true];
	
	_crewGroup setVariable ["lambs_danger_disableGroupAI", true];
	(group _vehicle) setVariable ["lambs_danger_disableGroupAI", true];
	
	{_x setVariable ["lambs_danger_disableAI", true]} forEach units _crewGroup;
	
	{_x setSkill 1} forEach units _crewGroup;

	_vehicle setCaptive SAC_TVU_VehicleCaptive;
	
	[_vehicle, _callsign, _protectedParts] spawn SAC_TVU_VehicleAI;
	
	_vehicle setVariable ["SAC_TVU_cargo_capacity", _capacity, true];
	_vehicle setVariable ["SAC_SPK_hasSpeakers", true, true];
	
	_vehicle lockDriver true;
	[_vehicle] call SAC_fnc_lockOccupiedTurrets;
	
	{_x disableAI "RADIOPROTOCOL"} forEach units _crewGroup;
	
	//[_vehicle] call SAC_fnc_initVehicle;
	
	if (_callsign == "A") then {
		SAC_TVU_VehicleA = _vehicle;
		SAC_TVU_VehicleReadyA = true;
		_crewGroup setGroupId ["Kilo-1"];
		SAC_TVU_BehaviourA = _behaviourMode;
	} else {
		SAC_TVU_VehicleB = _vehicle;
		SAC_TVU_VehicleReadyB = true;
		_crewGroup setGroupId ["Kilo-2"];
		SAC_TVU_BehaviourB = _behaviourMode;
	};
	
	_vehicle setBehaviourStrong _behaviourMode;

	if (SAC_trackerColor == "") then {
	
		SAC_trackerColor = SAC_markers_color_pool select 0;
		SAC_markers_color_pool = SAC_markers_color_pool - [SAC_trackerColor];
		publicVariable "SAC_markers_color_pool";
	
	};

	[_vehicle, _callsign] spawn SAC_TVU_fnc_tracker;
	
	//[_vehicle] call SAC_fnc_retextureVehicle;
	
	
};
