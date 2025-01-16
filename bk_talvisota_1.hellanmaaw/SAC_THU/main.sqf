/*

	19/5/2020
	
	1) El helicóptero inicia como toda unidad con un waypoint MOVE con index = 0, lo cual significa que fue completado. No hay
	ningún currentWaypoint. Mientras las condiciones sean esas, las órdenes doMove, hacen que el helicóptero vuelve hasta el punto
	indicado e intente quedar en hover sobre ese punto, lo cual hace que comience a desacelerar en tiempo y forma (a veces hasta 700
	mts antes de llegar). El script espera hasta que la distancia 2D sea de 200 mts y le da una órden de aterrizar. Después de lo cual
	el helicóptero maniobra (evitando obstáculos del terreno) hasta el helipuerto invisible que creó el script en el punto de aterrizaje.
	Esas son las ÚNICAS condiciones en las que se comporta correctamente y logra cumplir el viaje a salvo.
	
	2) Si se borran todos los waypoints de la unidad (inclusive y especialmente ese primer waypoint MOVE ya completado), la secuencia
	anterior no se da. El helicóptero vuelva a toda velocidad hacia el doMove hasta que alcanza el punto y el script le da la órden
	de aterrizar, lo cual hace que vuelve un semicírculo y comience el descenso (de manera segura todavía).
	
	3) Si se lo hace volar al punto creando un waypoint (ya sea MOVE o HOLD), el vehículo sí comienza a frenar como corresponde para
	llegar con velocidad cero al punto indicado, pero cuando el script le da la órden de aterrizar, vuelva en línea recta a muy
	baja altura, sin importarle los obstáculos, y aterriza casi como un avión. Sería bueno cuando la LZ está despejada, pero es
	impráctico porque con cualquier objeto en el área la maniobra termina en choque.
	
	4) "deleteWaypoint [group _vehicle, 1]" funciona para borrar el waypoint LOITER. La razón por la que muchas veces no obedece
	las órdenes siguientes, es porque entró en modo COMBAT, por haber volado en modo AWARE. En esos casos primero tiene que
	eliminar sus enemigos antes de obedecer otra órden. Volando en CARELESS se soluciona el problema.
	
	5) Por la razón que sea, volando en CARELESS el Apache no dispara misiles, lo cual hace que no ataque ningún tipo de blindado.
	La única solución es cambiar el perfil de vuelvo, en la interfaz "Change Parameters", a "Combat Profile". En ese momento el
	helicóptero deja de respetar el LOITER, y la altitud de vuelo, y dispara todos los misiles que puede hasta que detecta destruído
	el blanco, mientras se tira en picada hacia el mismo. Por ésta razón, lo mejor es volver al perfil de transporte lo antes posible.
	Se tiene que pensar en el perfil de combate como en una especie de "MASTER SWITCH ON" para el uso de misiles.


*/


if (!hasInterface) exitWith {};
waitUntil {!isNull player};

if !(getPlayerUID player in SAC_THU_PUIDs) exitWith {};

private ["_radioChannelA", "_radioChannelB", "_marker", "_trg"];

//Marcadores y variables requeridos por el script.
if (isnil "SAC_FNC") exitwith {hintC """SAC_FNC"" is not initialized in SAC_THU."};
if (isnil "SAC_GEAR") exitwith {hintC """SAC_GEAR"" is not initialized in SAC_THU."};

_radioChannelA = _this select 0;
_radioChannelB = _this select 1;
if (count _this > 3) then {SAC_THU_ReadyTimeAfterCrashed = _this select 3} else {SAC_THU_ReadyTimeAfterCrashed = 0};
if ("allowattack" in _this) then {SAC_THU_HeliCaptive = false} else {SAC_THU_HeliCaptive = true};

SAC_THU_ReadyTimeForProductionA = time;
SAC_THU_ReadyTimeForProductionB = time;

if (isNil "SAC_onMapSingleClick_Available") then {SAC_onMapSingleClick_Available = true};

SAC_THU_DestinationDesignationModeA = false;
SAC_THU_DestinationDesignationModeB = false;
SAC_THU_RouteDesignationModeA = false;
SAC_THU_RouteDesignationModeB = false;
SAC_THU_TerminateCurrentMissionA = false;
SAC_THU_TerminateCurrentMissionB = false;
SAC_THU_ReleaseControlA = false;
SAC_THU_ReleaseControlB = false;
SAC_THU_HelicopterReadyA = false;
SAC_THU_HelicopterReadyB = false;
SAC_THU_VehicleA = objNull;
SAC_THU_VehicleB = objNull;
SAC_THU_HelicopterHasSupplyA = false;
SAC_THU_HelicopterHasSupplyB = false;
SAC_THU_HelicopterHasMRZRA = false;
SAC_THU_HelicopterHasMRZRB = false;
SAC_THU_LandingModeA = "Auto";
SAC_THU_LandingModeB = "Auto";
SAC_THU_EngineOFFWhenOutOfBaseA = false;
SAC_THU_EngineOFFWhenOutOfBaseB = false;
SAC_THU_VehicleAName = "NONE";
SAC_THU_VehicleBName = "NONE";
SAC_THU_VehicleACallsign = "Angel 1";
SAC_THU_VehicleBCallsign = "Angel 2";

SAC_THU_TempHelipadA = createVehicle ["Land_HelipadEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"];
SAC_THU_TempHelipadB = createVehicle ["Land_HelipadEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"];

SAC_THU_RouteA = [];
SAC_THU_RouteB = [];
SAC_THU_NewWP = [];
SAC_THU_TerminateRouteDesignation = false;
SAC_THU_ExfilRouteA = [];
SAC_THU_ExfilRouteB = [];

SAC_THU_FlightAltitudeA = 60;
SAC_THU_FlightAltitudeB = 60;
SAC_THU_WaitFlightAltitudeA = 20;
SAC_THU_WaitFlightAltitudeB = 20;
SAC_THU_TurnDistanceA = 200;
SAC_THU_TurnDistanceB = 200;
SAC_THU_SpeedModeA = "NORMAL";
SAC_THU_SpeedModeB = "NORMAL";
SAC_THU_CombatModeA = "YELLOW";
SAC_THU_CombatModeB = "YELLOW";

SAC_THU_BehaviourA = "CARELESS";
SAC_THU_BehaviourB = "CARELESS";
//SAC_THU_BehaviourA = "AWARE"; //2/5/2020 se probó por casi año y no se noto que las unidades ataquen mas, y entran en combat (lo cual tampoco cambió la cosa que se note)
//SAC_THU_BehaviourB = "AWARE"; //los chopos de ataque pueden sufrir más esta reversión que los de transporte, verificar

SAC_THU_UseSmokeA = true;
SAC_THU_UseSmokeB = true;

SAC_THU_PilotClass = SAC_UDS_B_HeliPilot;
SAC_THU_HeliCrewClass = SAC_UDS_B_HeliPilot;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*KK_fnc_setPosAGLS = {
	params ["_obj", "_pos", "_offset"];
	_offset = _pos select 2;
	if (isNil "_offset") then {_offset = 0};
	_pos set [2, worldSize]; 
	_obj setPosASL _pos;
	_pos set [2, vectorMagnitude (_pos vectorDiff getPosVisual _obj) + _offset];
	_obj setPosASL _pos;
};*/
/*
//23/03/2018 Lo que hace "setVehiclePosition" es poner el objeto en la superficie más cercana, por eso con el z = 100 lo pone sobre la superficie de cualquier
//objeto (siempre que tenga menos de 100 mts.). Esto fue hecho para poder crear la base de los helicópteros en el portaviones.
private _tempHelipad = createVehicle ["Land_HelipadCircle_F", SAC_THU_HelipadAPos, [], 0, "CAN_COLLIDE"];
_tempHelipad setVehiclePosition [[SAC_THU_HelipadAPos select 0, SAC_THU_HelipadAPos select 1, 100], [], 0, "CAN_COLLIDE"];
//[player, [2437.18,5693.47,0]] call KK_fnc_setPosAGLS;
//[_tempHelipad, [(getPos _tempHelipad) select 0, (getPos _tempHelipad) select 1, 0]] call KK_fnc_setPosAGLS;
SAC_THU_HelipadAPos = [(getPos _tempHelipad) select 0, (getPos _tempHelipad) select 1, (getPosATL _tempHelipad) select 2];

_tempHelipad = createVehicle ["Land_HelipadCircle_F", SAC_THU_HelipadBPos, [], 0, "CAN_COLLIDE"];
_tempHelipad setVehiclePosition [[SAC_THU_HelipadBPos select 0, SAC_THU_HelipadBPos select 1, 100], [], 0, "CAN_COLLIDE"];
SAC_THU_HelipadBPos = [(getPos _tempHelipad) select 0, (getPos _tempHelipad) select 1, (getPosATL _tempHelipad) select 2];
*/
/*_trg = createTrigger ["EmptyDetector",[1,0,0]];
_trg setTriggerActivation [_radioChannelA, "PRESENT", true];
_trg setTriggerType "NONE";
_trg setTriggerStatements ["this","SAC_THU_selectedUnits = groupSelectedUnits player; [""A""] spawn SAC_THU_OpenRadioInterface",""];
_trg setTriggerText "Helicopter (A)";
*/


waitUntil {!isNull(findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["keyDown", {

	if (dialog) exitWith {false};

	private["_shift","_dik"];
	_dik = _this select 1;
	_shift = _this select 2;

	if (_dik in [79]) then {

		SAC_THU_selectedUnits = groupSelectedUnits player;
		["A"] spawn SAC_THU_OpenRadioInterface;

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

	if (_dik in [79]) then {

		SAC_THU_selectedUnits = groupSelectedUnits player;
		["A"] spawn SAC_THU_OpenRadioInterface;

		true

	} else {

		false

	};

}];

if (_radioChannelB != "NONE") then {
/*	_trg = createTrigger ["EmptyDetector",[1,0,0]];
	_trg setTriggerActivation [_radioChannelB, "PRESENT", true];
	_trg setTriggerType "NONE";
	_trg setTriggerStatements ["this","SAC_THU_selectedUnits = groupSelectedUnits player; [""B""] spawn SAC_THU_OpenRadioInterface",""];
	_trg setTriggerText "Helicopter (B)";
*/
	(findDisplay 46) displayAddEventHandler ["keyDown", {

		if (dialog) exitWith {false};

		private["_shift","_dik"];
		_dik = _this select 1;
		_shift = _this select 2;

		if (_dik in [80]) then {

			SAC_THU_selectedUnits = groupSelectedUnits player;
			["B"] spawn SAC_THU_OpenRadioInterface;

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

		if (_dik in [80]) then {

			SAC_THU_selectedUnits = groupSelectedUnits player;
			["B"] spawn SAC_THU_OpenRadioInterface;

			true

		} else {

			false

		};

	}];

};



systemChat "THU initialized.";

SAC_THU_processDestinationCoordinates = {

	private ["_p", "_callsign", "_vehicle", "_landingMode", "_marker", "_markerText", "_pFinal", "_vehicleSize", "_markerArea"];

	_p = _this select 0;
	_callsign = _this select 1;

	if (_callsign == "A") then {

		SAC_THU_DestinationDesignationModeA = false;
		_vehicle = SAC_THU_VehicleA;
		_landingMode = SAC_THU_LandingModeA;
		_marker = "SAC_THU_DestinationA";
		_markerText = "lz angel-1";
		_markerArea = "SAC_THU_DestinationA_Area";


	} else {

		SAC_THU_DestinationDesignationModeB = false;
		_vehicle = SAC_THU_VehicleB;
		_landingMode = SAC_THU_LandingModeB;
		_marker = "SAC_THU_DestinationB";
		_markerText = "lz angel-2";
		_markerArea = "SAC_THU_DestinationB_Area";

	};

	hint "";

	//_vehicle sideChat "Copy. Coordinates received.";
	//"radiochatter_us_15" call SAC_fnc_playSound;
	onMapSingleClick SAC_DefaultMapClick;
	SAC_onMapSingleClick_Available = true;

	_vehicleSize = (sizeOf typeOf _vehicle);

	private _safetyMargin = 0;

	if (_landingMode != "Manual") then {


		[_p, _vehicleSize, _safetyMargin] spawn {

			params ["_p", "_vehicleSize", "_safetyMargin"];

			private _markers = [[_p, "ColorBlue", "", "", [(_vehicleSize + _safetyMargin) / 2, (_vehicleSize + _safetyMargin) / 2], ["ELLIPSE", "Solid"]] call SAC_fnc_createMarkerLocal];
			//_markers pushBack ([_p, "ColorRed", "", "", [_vehicleSize / 2, _vehicleSize / 2], ["ELLIPSE", "Solid"]] call SAC_fnc_createMarkerLocal);
			//sleep 0.1;
			_markers pushBack ([_p, "ColorRed", "", "", [50, 50], ["ELLIPSE", "Border"]] call SAC_fnc_createMarkerLocal);
			
			{
			
				_markers pushBack ([_x, "ColorGreen"] call SAC_fnc_markBoundingSphere);
			
			} forEach (nearestTerrainObjects [_p, ["TREE", "SMALL TREE"], 50, false]);
			{
			
				_markers pushBack ([_x, "ColorRed"] call SAC_fnc_markBoundingSphere);
			
			} forEach (nearestTerrainObjects [_p, ["POWER LINES"], 150, false]);
			{
			
				_markers pushBack ([_x, "ColorBlue"] call SAC_fnc_markBoundingSphere);
			
			} forEach (nearestTerrainObjects [_p, ["BUILDING", "HOUSE"], 50, false]);
			/*
			
				Recordar que las marcadas en negro no se incluyen en la comprobación
				de las "sphere bounding boxes"
			
			*/
			{
			
				_markers pushBack ([_x, "ColorBlack"] call SAC_fnc_markBoundingSphere);
			
			} forEach (nearestTerrainObjects [_p, ["FENCE", "WALL", "STACK", "RUIN", "ROCK", "ROCKS"], 50, false]);

			sleep 7;

			{deleteMarkerLocal _x} forEach _markers;

		};

		_pFinal = [_p, _vehicleSize, _safetyMargin] call SAC_fnc_findLZ;

	} else {

		_pFinal = _p;

	};


	if (count _pFinal > 0) then {

		if (_marker in allMapMarkers) then {

			//systemChat "marker in allMapMarkers";
			_marker setMarkerPosLocal _pFinal;
			_markerArea setMarkerPosLocal _pFinal;
			_markerArea setMarkerSizeLocal [(_vehicleSize + _safetyMargin) / 2, (_vehicleSize + _safetyMargin) / 2];

		} else {

			//systemChat "creando marker";
			_marker = createMarkerLocal [_marker, _pFinal];
			_marker setMarkerColorLocal "ColorBlack";
			_marker setMarkerTypeLocal selectRandom ["Contact_dot1","Contact_dot2","Contact_dot3","Contact_dot4","Contact_dot5"];
			_marker setMarkerTextLocal _markerText;

			_markerArea = createMarkerLocal [_markerArea, _pFinal];
			_markerArea setMarkerColorLocal "ColorOrange";
			_markerArea setMarkerShapeLocal "ELLIPSE";
			_markerArea setMarkerSizeLocal [(_vehicleSize + _safetyMargin) / 2, (_vehicleSize + _safetyMargin) / 2];

		};

	} else {

		hint "No valid LZ could be put there.";

	};

};

SAC_THU_processWaitingCoordinates = {

	private ["_p", "_callsign", "_vehicle", "_marker", "_markerText"];

	_p = _this select 0;
	_callsign = _this select 1;

	if (_callsign == "A") then {

		SAC_THU_DestinationDesignationModeA = false;
		_vehicle = SAC_THU_VehicleA;
		_marker = "SAC_THU_WaitingPointA";
		_markerText = "wp angel-1";

	} else {

		SAC_THU_DestinationDesignationModeB = false;
		_vehicle = SAC_THU_VehicleB;
		_marker = "SAC_THU_WaitingPointB";
		_markerText = "wp angel-2";

	};

	hint "";

	//_vehicle sideChat "Copy. Coordinates received.";
	//"radiochatter_us_15" call SAC_fnc_playSound;
	onMapSingleClick SAC_DefaultMapClick;
	SAC_onMapSingleClick_Available = true;

	if (_marker in allMapMarkers) then {

		_marker setMarkerPosLocal _p;

	} else {

		_marker = createMarkerLocal [_marker, _p];
		_marker setMarkerColorLocal "ColorBlack";
		_marker setMarkerTypeLocal selectRandom ["Contact_circle1","Contact_circle2","Contact_circle3","Contact_circle4"];
		_marker setMarkerTextLocal _markerText;

	};

};

SAC_THU_processLoiterCoordinates = {

	private ["_p", "_callsign", "_vehicle", "_marker", "_markerText"];

	_p = _this select 0;
	_callsign = _this select 1;

	if (_callsign == "A") then {

		SAC_THU_DestinationDesignationModeA = false;
		_vehicle = SAC_THU_VehicleA;
		_marker = "SAC_THU_LoiterPointA";
		_markerText = "lp angel-1";

	} else {

		SAC_THU_DestinationDesignationModeB = false;
		_vehicle = SAC_THU_VehicleB;
		_marker = "SAC_THU_LoiterPointB";
		_markerText = "lp angel-2";

	};

	hint "";

	//_vehicle sideChat "Copy. Coordinates received.";
	//"radiochatter_us_15" call SAC_fnc_playSound;
	onMapSingleClick SAC_DefaultMapClick;
	SAC_onMapSingleClick_Available = true;

	if (_marker in allMapMarkers) then {

		_marker setMarkerPosLocal _p;

	} else {

		_marker = createMarkerLocal [_marker, _p];
		_marker setMarkerColorLocal "ColorBlack";
		_marker setMarkerTypeLocal selectRandom ["Contact_pencilTask1","Contact_pencilTask2","Contact_pencilTask3"];
		_marker setMarkerTextLocal _markerText;

	};

};

SAC_THU_processPickUpCoordinates = {

	private ["_p", "_callsign", "_vehicle", "_marker", "_markerText"];

	_p = _this select 0;
	_callsign = _this select 1;

	if (_callsign == "A") then {

		SAC_THU_DestinationDesignationModeA = false;
		_vehicle = SAC_THU_VehicleA;
		_marker = "SAC_THU_PickUpPointA";
		_markerText = "pick up angel-1";

	} else {

		SAC_THU_DestinationDesignationModeB = false;
		_vehicle = SAC_THU_VehicleB;
		_marker = "SAC_THU_PickUpPointB";
		_markerText = "pick up angel-2";

	};

	hint "";

	//_vehicle sideChat "Copy. Coordinates received.";
	//"radiochatter_us_15" call SAC_fnc_playSound;
	onMapSingleClick SAC_DefaultMapClick;
	SAC_onMapSingleClick_Available = true;

	if (_marker in allMapMarkers) then {

		_marker setMarkerPosLocal _p;

	} else {

		_marker = createMarkerLocal [_marker, _p];
		_marker setMarkerColorLocal "ColorBlack";
		_marker setMarkerTypeLocal "hd_dot_noShadow";
		_marker setMarkerTextLocal _markerText;

	};

};

SAC_THU_processReleaseCoordinates = {

	private ["_p", "_callsign", "_vehicle", "_marker", "_markerText"];

	_p = _this select 0;
	_callsign = _this select 1;

	if (_callsign == "A") then {

		SAC_THU_DestinationDesignationModeA = false;
		_vehicle = SAC_THU_VehicleA;
		_marker = "SAC_THU_ReleasePointA";
		_markerText = "release angel-1";

	} else {

		SAC_THU_DestinationDesignationModeB = false;
		_vehicle = SAC_THU_VehicleB;
		_marker = "SAC_THU_ReleasePointB";
		_markerText = "release angel-2";

	};

	hint "";

	//_vehicle sideChat "Copy. Coordinates received.";
	//"radiochatter_us_15" call SAC_fnc_playSound;
	onMapSingleClick SAC_DefaultMapClick;
	SAC_onMapSingleClick_Available = true;

	if (_marker in allMapMarkers) then {

		_marker setMarkerPosLocal _p;

	} else {

		_marker = createMarkerLocal [_marker, _p];
		_marker setMarkerColorLocal "ColorBlack";
		_marker setMarkerTypeLocal "hd_dot_noShadow";
		_marker setMarkerTextLocal _markerText;

	};

};

SAC_THU_deleteCargoNPCUnits = {

	params ["_vehicle", "_excludedUnits"];
	
	{
	
		if !(((_x select 0) in _excludedUnits) || ((_x select 0) in allPlayers)) then {_vehicle deleteVehicleCrew (_x select 0)};
	
	} forEach fullCrew _vehicle;


};

SAC_THU_OpenRadioInterface = {

	if (dialog) exitWith {false};

	private ["_callsign", "_helicopterReady", "_vehicle", "_useSmoke", "_destinationDesignationMode", "_routeDesignationMode", "_pos", "_ready",
	"_timeForReady", "_flyAltitude", "_waitAltitude", "_helipadSelected", "_ready", "_vehicleName", "_vehicleCallsign",
	"_destinationExist", "_waitingPointExist", "_loiterPointExist", "_entryRouteExist", "_exfilRouteExist", "_hasSupply",
	"_hasMRZR"];

	_callsign = _this select 0;
	if (_callsign == "A") then {
		_helipadSelected = if (isNil "SAC_THU_HelipadAPos") then {false} else {true};
		_helicopterReady = SAC_THU_HelicopterReadyA;
		_vehicle = SAC_THU_VehicleA;
		_useSmoke = SAC_THU_UseSmokeA;
		_destinationDesignationMode = SAC_THU_DestinationDesignationModeA;
		_routeDesignationMode = SAC_THU_RouteDesignationModeA;
		if (time >= SAC_THU_ReadyTimeForProductionA) then {_ready = true} else {_ready = false};
		_timeForReady = SAC_THU_ReadyTimeForProductionA - time;
		_flyAltitude = SAC_THU_FlightAltitudeA;
		_waitAltitude = SAC_THU_WaitFlightAltitudeA;
		_vehicleName = SAC_THU_VehicleAName;
		_vehicleCallsign = SAC_THU_VehicleACallsign;
		
		_destinationExist = if ("SAC_THU_DestinationA" in allMapMarkers) then {true} else {false};
		_waitingPointExist = if ("SAC_THU_WaitingPointA" in allMapMarkers) then {true} else {false};
		_loiterPointExist = if ("SAC_THU_LoiterPointA" in allMapMarkers) then {true} else {false};
		_entryRouteExist = if (count SAC_THU_RouteA > 0) then {true} else {false};
		_exfilRouteExist = if (count SAC_THU_ExfilRouteA > 0) then {true} else {false};
		_hasSupply = SAC_THU_HelicopterHasSupplyA;
		_hasMRZR = SAC_THU_HelicopterHasMRZRA;
		
	} else {
		_helipadSelected = if (isNil "SAC_THU_HelipadBPos") then {false} else {true};
		_helicopterReady = SAC_THU_HelicopterReadyB;
		_vehicle = SAC_THU_VehicleB;
		_useSmoke = SAC_THU_UseSmokeB;
		_destinationDesignationMode = SAC_THU_DestinationDesignationModeB;
		_routeDesignationMode = SAC_THU_RouteDesignationModeB;
		if (time >= SAC_THU_ReadyTimeForProductionB) then {_ready = true} else {_ready = false};
		_timeForReady = SAC_THU_ReadyTimeForProductionB - time;
		_flyAltitude = SAC_THU_FlightAltitudeB;
		_waitAltitude = SAC_THU_WaitFlightAltitudeB;
		_vehicleName = SAC_THU_VehicleBName;
		_vehicleCallsign = SAC_THU_VehicleBCallsign;
		
		_destinationExist = if ("SAC_THU_DestinationB" in allMapMarkers) then {true} else {false};
		_waitingPointExist = if ("SAC_THU_WaitingPointB" in allMapMarkers) then {true} else {false};
		_loiterPointExist = if ("SAC_THU_LoiterPointB" in allMapMarkers) then {true} else {false};
		_entryRouteExist = if (count SAC_THU_RouteB > 0) then {true} else {false};
		_exfilRouteExist = if (count SAC_THU_ExfilRouteB > 0) then {true} else {false};
		_hasSupply = SAC_THU_HelicopterHasSupplyB;
		_hasMRZR = SAC_THU_HelicopterHasMRZRB;
		
	};

	if (not _ready) exitWith {systemChat format["New crew will be ready in %1 min.", ceil (_timeForReady / 60)]};

	SAC_user_input = "";

	//if (_helipadSelected) then {
	
		if (_helicopterReady) then {
		
			if (_destinationDesignationMode || _routeDesignationMode) then {

				0 = createdialog "SAC_1x14_panel";
				//ctrlSetText [1800, " THU Interface (Setting Coordinates) "];
				ctrlSetText [1800, format[" THU Interface (Setting Coordinates) - %1 - %2 ", _vehicleName, _vehicleCallsign]];

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

				0 = createDialog "SAC_2x12_panel";
				/*if (_callsign == "A") then {

					((findDisplay 3000) displayCtrl 1800) ctrlSetTextColor [0, 0.7, 0, 1];
				
				} else {
				
					((findDisplay 3000) displayCtrl 1800) ctrlSetTextColor [0, 0, 0.7, 1];
				
				};*/
				
				ctrlSetText [1800, format[" THU Interface - %1 - %2 ", _vehicleName, _vehicleCallsign]];

				ctrlSetText [1601, "Destination, Land"]; if (!_destinationExist) then {ctrlEnable [1601, false]};
				ctrlSetText [1602, "Destination, Wait"]; if (!_destinationExist) then {ctrlEnable [1602, false]};
				ctrlSetText [1603, "Waiting Point, Wait"]; if (!_waitingPointExist) then {ctrlEnable [1603, false]};
				ctrlSetText [1604, "Entry Route, Land"]; if (!_entryRouteExist) then {ctrlEnable [1604, false]};
				ctrlSetText [1605, "Entry Route, Wait"]; if (!_entryRouteExist) then {ctrlEnable [1605, false]};
				ctrlSetText [1606, "Insert..."]; if (!_destinationExist) then {ctrlEnable [1606, false]};
				ctrlShow [1607, false];
				ctrlSetText [1608, "Destination, Loiter"]; if (!_destinationExist) then {ctrlEnable [1608, false]};
				ctrlSetText [1609, "Loiter Point, Loiter"]; if (!_loiterPointExist) then {ctrlEnable [1609, false]};
				
				((findDisplay 3000) displayCtrl 1610) ctrlSetTextColor [0.18,0.5,0.5,1];
				ctrlSetText [1610, "View From Pilot"];
				
				ctrlSetText [1611, "Exfil Route, RTB"]; if (!_exfilRouteExist) then {ctrlEnable [1611, false]};
				ctrlSetText [1612, "RTB"];

				ctrlSetText [1613, "Set Destination"];
				ctrlSetText [1614, "Set Waiting Point"];
				ctrlSetText [1615, "Set Entry Route"];
				ctrlSetText [1616, "Set Exfil Route"];
				ctrlSetText [1617, "Set Loiter Point"];
				ctrlSetText [1618, "Special Operations..."];
				ctrlSetText [1619, "Slingload..."];
				ctrlSetText [1620, "Load Supplies"]; if (_hasSupply) then {ctrlEnable [1620, false]};
				ctrlSetText [1621, "Unload Supplies"]; if !(_hasSupply) then {ctrlEnable [1621, false]};
				ctrlSetText [1622, "Report Status"];
				ctrlSetText [1623, "Change Parameters..."];
				ctrlSetText [1624, "Dismiss Helicopter"];

			};

		} else {
		
			if (!_helipadSelected) then {
			
					[_callsign] call SAC_THU_selectHelipad;
					
					if (SAC_user_input != "") then {_helipadSelected = true};
					
					SAC_user_input = "";
			
			};
			
			if (!_helipadSelected) exitWith {};

			0 = createdialog "SAC_1x14_panel";
			//ctrlSetText [1800, " THU Interface (MOD Selector) "];
			ctrlSetText [1800, format[" THU Interface (MOD Selector) - %1 ", _vehicleCallsign]];

			ctrlSetText [1601, "BIS"];
			ctrlSetText [1602, "RHS"]; if (!SAC_RHS) then {ctrlEnable [1602, false]};
			if (SAC_CAA) then {ctrlSetText [1603, "CAA"]} else {ctrlShow [1603, false]};
			if (SAC_unsung) then {ctrlSetText [1604, "UNSUNG"]} else {ctrlShow [1604, false]};
			if (SAC_LOP) then {ctrlSetText [1605, "LOP"]} else {ctrlShow [1605, false]};
			ctrlShow [1606, false];
			ctrlShow [1607, false];
			ctrlShow [1608, false];
			ctrlShow [1609, false];
			ctrlShow [1610, false];
			ctrlShow [1611, false];
			ctrlShow [1612, false];
			ctrlShow [1613, false];
			ctrlSetText [1614, "Change Helipad"];

			waitUntil { !dialog };

			switch (SAC_user_input) do {

				case "BIS": {

					SAC_user_input = "";

					0 = createdialog "SAC_2x12_panel";

					//ctrlSetText [1800, " THU Interface (Helicopter Selector) "];
					ctrlSetText [1800, format[" THU Interface (Helicopter Selector) - %1 ", _vehicleCallsign]];

					ctrlSetText [1601, "PO-30 Orca"];
					ctrlSetText [1602, "CH-49 Mohawk"];
					ctrlSetText [1603, "CH-67 Huron"];
					ctrlSetText [1604, "Mi-48 Kajman"];
					ctrlSetText [1605, "WY-55 Hellcat"];
					ctrlSetText [1606, "Mi-290 Skycrane"];
					ctrlSetText [1607, "Mi-290 Transport"];
					ctrlSetText [1608, "MH-9 Hummingbird"];
					ctrlSetText [1609, "AH-99 Blackfoot"];
					ctrlSetText [1610, "UH-80 GhostHawk"];
					ctrlSetText [1611, "V-44X"];
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

				case "RHS": {

					SAC_user_input = "";

					0 = createdialog "SAC_2x12_panel";

					//ctrlSetText [1800, " THU Interface (Helicopter Selector) "];
					ctrlSetText [1800, format[" THU Interface (Helicopter Selector) - %1 ", _vehicleCallsign]];

					ctrlSetText [1601, "CH-47F"];
					ctrlSetText [1602, "UH-60M"];
					ctrlSetText [1603, "UH-1Y"];
					ctrlSetText [1604, "UH-1Y (Unarmed)"];
					ctrlSetText [1605, "AH-64D (light)"];
					ctrlSetText [1606, "AH-64D (at)"];
					ctrlSetText [1607, "MH6M"];
					ctrlSetText [1608, "UH-1H"];
					ctrlSetText [1609, "MI8-MT"];
					ctrlSetText [1610, "MI8-MTV-3"];
					ctrlSetText [1611, "Mi-24V"];
					ctrlSetText [1612, "Ka-52"];
					ctrlSetText [1613, "Mi-28N"];
					ctrlSetText [1614, "AH-1Z"];
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
				
				case "CAA": {

					SAC_user_input = "";

					0 = createdialog "SAC_2x12_panel";

					//ctrlSetText [1800, " THU Interface (Helicopter Selector) "];
					ctrlSetText [1800, format[" THU Interface (Helicopter Selector) - %1 ", _vehicleCallsign]];

					ctrlSetText [1601, "UH-60L"];
					ctrlSetText [1602, "MH-60L"];
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
				case "LOP": {

					SAC_user_input = "";

					0 = createdialog "SAC_2x12_panel";

					//ctrlSetText [1800, " THU Interface (Helicopter Selector) "];
					ctrlSetText [1800, format[" THU Interface (Helicopter Selector) - %1 ", _vehicleCallsign]];

					ctrlSetText [1601, "Mi-8 Green (No Flag)"];
					ctrlShow [1602, false];
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
				case "UNSUNG": {

					SAC_user_input = "";

					0 = createdialog "SAC_2x12_panel";

					//ctrlSetText [1800, " THU Interface (Helicopter Selector) "];
					ctrlSetText [1800, format[" THU Interface (Helicopter Selector) - %1 ", _vehicleCallsign]];

					ctrlSetText [1601, "UH-1H 1st Cav Slick"];
					ctrlSetText [1602, "CH-47 1st Cav"];
					ctrlSetText [1603, "UH-1H Gunship"];
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

	/*			case "CUP": {

					SAC_user_input = "";

					0 = createdialog "SAC_2x12_panel";

					//ctrlSetText [1800, " THU Interface (Helicopter Selector) "];
					ctrlSetText [1800, format[" THU Interface (Helicopter Selector) - %1 ", _vehicleCallsign]];

					ctrlSetText [1601, "CH-47F CUP"];
					ctrlSetText [1602, "UH-60M CUP"];
					ctrlSetText [1603, "UH-60M (FFVCUP)"];
					ctrlSetText [1604, "AH-1Z CUP"];
					ctrlSetText [1605, "AH-64D CUP"];
					ctrlSetText [1606, "CH-53E"];
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

				};*/
				
				case "Change Helipad": {
				
					[_callsign] call SAC_THU_selectHelipad;
					
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
				//Discrimina entre cancelar el modo de selecci�n de destino y el modo de marcado de ruta.
				if (_destinationDesignationMode) then {
					_destinationDesignationMode = false;
				} else {
					SAC_THU_TerminateRouteDesignation = true;
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
						onMapSingleClick "[_pos, ""A""] spawn SAC_THU_processDestinationCoordinates; true";
					} else {
						onMapSingleClick "[_pos, ""B""] spawn SAC_THU_processDestinationCoordinates; true";
					};
				} else {hint "onMapSingleClick is not available."};
			};
			case "Set Waiting Point": {
				if (SAC_onMapSingleClick_Available) then {
					SAC_onMapSingleClick_Available = false;
					_destinationDesignationMode = true;
					hint "Click on the map to set the waiting point.";
					//"defaultNotification" call SAC_fnc_playSound;
					if (!visibleMap) then {openMap true};
					if (_callsign == "A") then {
						onMapSingleClick "[_pos, ""A""] spawn SAC_THU_processWaitingCoordinates; true";
					} else {
						onMapSingleClick "[_pos, ""B""] spawn SAC_THU_processWaitingCoordinates; true";
					};
				} else {hint "onMapSingleClick is not available."};
			};
			case "Set Entry Route": {
				if (SAC_onMapSingleClick_Available) then {
					SAC_onMapSingleClick_Available = false;
					_routeDesignationMode = true;
					[_callsign, "Entry"] spawn SAC_THU_CreateRoute;
				} else {hint "onMapSingleClick is not available."};
			};
			case "Set Exfil Route": {
				if (SAC_onMapSingleClick_Available) then {
					SAC_onMapSingleClick_Available = false;
					_routeDesignationMode = true;
					[_callsign, "Exfil"] spawn SAC_THU_CreateRoute;
				} else {hint "onMapSingleClick is not available."};
			};
			case "Set Loiter Point": {
				if (SAC_onMapSingleClick_Available) then {
					SAC_onMapSingleClick_Available = false;
					_destinationDesignationMode = true;
					hint "Click on the map to set the loiter point.";
					//"defaultNotification" call SAC_fnc_playSound;
					if (!visibleMap) then {openMap true};
					if (_callsign == "A") then {
						onMapSingleClick "[_pos, ""A""] spawn SAC_THU_processLoiterCoordinates; true";
					} else {
						onMapSingleClick "[_pos, ""B""] spawn SAC_THU_processLoiterCoordinates; true";
					};
				} else {hint "onMapSingleClick is not available."};
			};
			case "Destination, Land": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE"; //no funciona en A3
				driver _vehicle disableAI "TARGET";

				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (vehicle player != _vehicle) then {"sac_sounds_confirmed0" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_confirmed0", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Copy that, ETA two mikes, Golf Two Two out.";


				if (_callsign == "A") then {

					[_callsign, "SAC_THU_DestinationA", "DIRECTO", "LAND", ""] spawn SAC_THU_FlyToDestination;

				} else {

					[_callsign, "SAC_THU_DestinationB", "DIRECTO", "LAND", ""] spawn SAC_THU_FlyToDestination;

				};

			};
			case "Entry Route, Land": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
				driver _vehicle disableAI "TARGET";

				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
				
				if (vehicle player != _vehicle) then {"sac_sounds_confirmed0" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_confirmed0", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Copy that, ETA two mikes, Golf Two Two out.";

				if (_callsign == "A") then {

					[_callsign, "SAC_THU_DestinationA", "RUTA", "LAND", ""] spawn SAC_THU_FlyToDestination;

				} else {

					[_callsign, "SAC_THU_DestinationB", "RUTA", "LAND", ""] spawn SAC_THU_FlyToDestination;

				};

			};
			case "Entry Route, Wait": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
				driver _vehicle disableAI "TARGET";

				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (vehicle player != _vehicle) then {"sac_sounds_confirmed0" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_confirmed0", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Copy that, ETA two mikes, Golf Two Two out.";

				if (_callsign == "A") then {

					[_callsign, "SAC_THU_WaitingPointA", "RUTA", "WAIT", ""] spawn SAC_THU_FlyToDestination;

				} else {

					[_callsign, "SAC_THU_WaitingPointB", "RUTA", "WAIT", ""] spawn SAC_THU_FlyToDestination;

				};

			};
			case "Destination, Loiter": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};


				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (vehicle player != _vehicle) then {"sac_sounds_confirmed0" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_confirmed0", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Copy that, ETA two mikes, Golf Two Two out.";

				[_callsign, "DESTINATION"] spawn SAC_THU_FlyAndCircle;

			};
			case "Loiter Point, Loiter": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};


				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (vehicle player != _vehicle) then {"sac_sounds_confirmed0" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_confirmed0", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Copy that, ETA two mikes, Golf Two Two out.";

				[_callsign, "LOITERPOINT"] spawn SAC_THU_FlyAndCircle;

			};
			case "Destination, Wait": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
				driver _vehicle disableAI "TARGET";

				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (vehicle player != _vehicle) then {"sac_sounds_confirmed0" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_confirmed0", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Copy that, ETA two mikes, Golf Two Two out.";


				if (_callsign == "A") then {
					[_callsign, "SAC_THU_DestinationA", "DIRECTO", "WAIT", ""] spawn SAC_THU_FlyToDestination;
				} else {
					[_callsign, "SAC_THU_DestinationB", "DIRECTO", "WAIT", ""] spawn SAC_THU_FlyToDestination;
				};
			};
			case "Waiting Point, Wait": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
				driver _vehicle disableAI "TARGET";

				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (vehicle player != _vehicle) then {"sac_sounds_confirmed0" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_confirmed0", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Copy that, ETA two mikes, Golf Two Two out.";

				if (_callsign == "A") then {
					[_callsign, "SAC_THU_WaitingPointA", "DIRECTO", "WAIT", ""] spawn SAC_THU_FlyToDestination;
				} else {
					[_callsign, "SAC_THU_WaitingPointB", "DIRECTO", "WAIT", ""] spawn SAC_THU_FlyToDestination;
				};
			};
/*			case "Destination, Insert, RTB": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
				driver _vehicle disableAI "TARGET";

				[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (_callsign == "A") then {
					[_callsign, "SAC_THU_DestinationA", "DIRECTO", "INSERT", "DIRECTO"] spawn SAC_THU_FlyToDestination;
				} else {
					[_callsign, "SAC_THU_DestinationB", "DIRECTO", "INSERT", "DIRECTO"] spawn SAC_THU_FlyToDestination;
				};
			};
			case "Entry Route, Insert, Waiting Point": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
				driver _vehicle disableAI "TARGET";

				[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (_callsign == "A") then {
					[_callsign, "SAC_THU_DestinationA", "RUTA", "INSERT", "WAIT"] spawn SAC_THU_FlyToDestination;
				} else {
					[_callsign, "SAC_THU_DestinationB", "RUTA", "INSERT", "WAIT"] spawn SAC_THU_FlyToDestination;
				};
			};
			case "Entry Route, Insert, Exfil Route": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
				driver _vehicle disableAI "TARGET";

				[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (_callsign == "A") then {
					[_callsign, "SAC_THU_DestinationA", "RUTA", "INSERT", "RUTA"] spawn SAC_THU_FlyToDestination;
				} else {
					[_callsign, "SAC_THU_DestinationB", "RUTA", "INSERT", "RUTA"] spawn SAC_THU_FlyToDestination;
				};
			};
			case "Destination, Insert, Waiting Point": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
				driver _vehicle disableAI "TARGET";

				[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (_callsign == "A") then {
					[_callsign, "SAC_THU_DestinationA", "DIRECTO", "INSERT", "WAIT"] spawn SAC_THU_FlyToDestination;
				} else {
					[_callsign, "SAC_THU_DestinationB", "DIRECTO", "INSERT", "WAIT"] spawn SAC_THU_FlyToDestination;
				};
			};*/
			case "Exfil Route, RTB": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
				driver _vehicle disableAI "TARGET";

				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

				if (vehicle player != _vehicle) then {"sac_sounds_RTB0" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_RTB0", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Golf Four One, RTB, out.";

				if (_callsign == "A") then {
					[_callsign, SAC_THU_HelipadAMarkerName, "RUTA", "LAND", ""] spawn SAC_THU_FlyToDestination;
				} else {
					[_callsign, SAC_THU_HelipadBMarkerName, "RUTA", "LAND", ""] spawn SAC_THU_FlyToDestination;
				};
			};
			case "RTB": {
				hint "";
				if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

				//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
				driver _vehicle disableAI "TARGET";

				//[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;
				
				if (vehicle player != _vehicle) then {"sac_sounds_RTB0" spawn SAC_fnc_playSound};
				[driver _vehicle, "sac_sounds_RTB0", 100] spawn SAC_fnc_netSay3D;
				_vehicle sideChat "Golf Four One, RTB, out.";
				
				if (_callsign == "A") then {
					[_callsign, SAC_THU_HelipadAMarkerName, "DIRECTO", "LAND", ""] spawn SAC_THU_FlyToDestination;
				} else {
					[_callsign, SAC_THU_HelipadBMarkerName, "DIRECTO", "LAND", ""] spawn SAC_THU_FlyToDestination;
				};
			};
			case "View From Pilot": {

				if (cameraOn == SAC_THU_VehicleA || cameraOn == SAC_THU_VehicleB) then {
				
					player switchCamera "INTERNAL";
					
				} else {
				
					if (_callsign == "A") then {SAC_THU_VehicleA switchCamera "INTERNAL"} else {SAC_THU_VehicleB switchCamera "INTERNAL"};
				
				};

			};
			case "Report Status": {
				[_callsign] call SAC_THU_ReportStatus;
			};
			case "Unload Supplies": {
				[_callsign] call SAC_THU_UnloadSupply;
			};
			case "Load Supplies": {
				[_callsign] call SAC_THU_LoadSupply;
			};
			case "Change Parameters...": {
				[_callsign] call SAC_THU_ChangeParameters;
			};
			case "Special Operations...": {

				SAC_user_input = "";

				0 = createdialog "SAC_2x12_panel";
				//ctrlSetText [1800, " THU Interface (Special Operations) "];
				ctrlSetText [1800, format[" THU Interface (Special Operations) - %1 - %2 ", _vehicleName, _vehicleCallsign]];

				ctrlSetText [1601, "Fastrope Everyone Onboard"];
				ctrlSetText [1602, "Fastrope Everyone - Player"];
				ctrlSetText [1603, "Fastrope Selected Units"];
				ctrlSetText [1604, "Fastrope Selected + Player"];
				ctrlShow [1605, false ];
				ctrlShow [1606, false ];
				ctrlShow [1607, false ];
				ctrlShow [1608, false ];
				ctrlSetText [1609, "Turn Engine OFF"];
				ctrlSetText [1610, "Release Control"];
				ctrlShow [1611, false ];
				ctrlSetText [1612, "Delete NPC passengers"];
				ctrlSetText [1613, "Lower to 5 meters"];
				ctrlSetText [1614, "Lower to 2 meters"];
				ctrlSetText [1615, "Deploy Boat"];
				ctrlSetText [1616, "Return to normal altitude"];
				ctrlSetText [1617, "Recover boat"];
				ctrlShow [1618, false ];
				ctrlSetText [1619, "Load MRZR"]; if (_hasMRZR) then {ctrlEnable [1619, false]};
				ctrlSetText [1620, "Unload MRZR"]; if !(_hasMRZR) then {ctrlEnable [1620, false]};
				ctrlShow [1621, false ];
				ctrlShow [1622, false ];
				ctrlShow [1623, false ];
				ctrlShow [1624, false ];

				waitUntil { !dialog };

				switch (SAC_user_input) do
				{
					case "Fastrope Everyone Onboard": {
						[_vehicle, _vehicle call SAC_fnc_unitsInCargo, _useSmoke] spawn SAC_THU_FastRope;
					};
					case "Fastrope Everyone - Player": {
						[_vehicle, (_vehicle call SAC_fnc_unitsInCargo) - [player], _useSmoke] spawn SAC_THU_FastRope;
					};
					case "Fastrope Selected Units": {
						[_vehicle, SAC_THU_selectedUnits, _useSmoke] spawn SAC_THU_FastRope;
					};
					case "Fastrope Selected + Player": {
						[_vehicle, SAC_THU_selectedUnits + [player], _useSmoke] spawn SAC_THU_FastRope;
					};
					case "Delete NPC passengers": {
						[_vehicle, units group driver _vehicle] spawn SAC_THU_deleteCargoNPCUnits;
					};
					case "Turn Engine OFF": {
						if (_callsign == "A") then {
							driver SAC_THU_VehicleA action ["engineOff", SAC_THU_VehicleA];
						} else {
							driver SAC_THU_VehicleB action ["engineOff", SAC_THU_VehicleB];
						};
					};
					case "Release Control": {
						if (_callsign == "A") then {
							SAC_THU_ReleaseControlA = true;
						} else {
							SAC_THU_ReleaseControlB = true;
						};
					};
					case "Lower to 5 meters": {
						/*11/10/2019 La situación a la fecha es la siguiente:
							1-Dependiendo de la geografía del terreno, los chopos bajan a la altura que se les canta, desde 5 mts. menos, hasta 15 mts. más, cualquier cosa.
							2-La orden de bajar o subir la altura del hover, a veces la toman y a veces no, como si hubiera que pasar un umbral, el cual desconozco.
						
						*/
						_vehicle flyInHeight 8; //la altura del vuelo no tiene en cuenta el tamaño del helicóptero, por eso hay que estimar un valor mayor.
						_vehicle move getpos _vehicle; //si no se da una órden de movimiento no tiene efecto el comando flyInHeight, cuando es mayor que la altitud actual.
					};
					case "Lower to 2 meters": {
						_vehicle flyInHeight 5; //la altura del vuelo no tiene en cuenta el tamaño del helicóptero, por eso hay que estimar un valor mayor.
					};
					case "Deploy Boat": {
						//"B_Boat_Transport_01_F" createVehicle (_vehicle modelToWorld [0,-30, 0]);
						private _boat = createVehicle ["B_Boat_Transport_01_F", _vehicle modelToWorld [0,-20, 0], [], 0, "CAN_COLLIDE"];
						private _beacon = "NVG_TargetC" createVehicle [0,0,0];
						_beacon attachTo [_boat, [0,-2,-0.1]];//arriba del motor
						
						_boat setVariable ["SAC_targetObject", _beacon];
						//["_object", "_actionTitle", "_titleText", "_actionType", "_position", "_timer"]
						[_boat, "Apagar IR", "", 4, [], 0] call SAC_fnc_addPredefinedAction;
						
						{_x addCuratorEditableObjects [[_boat], true]} forEach allCurators;
						
					};
					case "Return to normal altitude": {
						_vehicle flyInHeight _waitAltitude;
						_vehicle move getpos _vehicle; //si no se da una órden de movimiento no tiene efecto el comando flyInHeight, cuando es mayor que la altitud actual.
					};
					case "Recover boat": {
					
						if ((getPos _vehicle) select 2 > 10) exitWith {systemChat "Negative. Helo altitude must be lower than 10 mts."};
						if (speed _vehicle > 5) exitWith {systemChat "Negative. Helicopter must be stationary"};

						private _boat = nearestObject [_vehicle,"B_Boat_Transport_01_F"];
						
						if ((isNull _boat) || {_boat distance _vehicle > 50}) exitWith {systemChat "No boat was found."};
						
						if (crew _boat findIf {alive _x} == -1) then {
						
							deleteVehicle nearestObject [_vehicle,"nvg_targetC"];
							deleteVehicle nearestObject [_vehicle,"B_IRStrobe"];
							deleteVehicle _boat;
							
						};
					
					};
					case "Load MRZR": {

						if ((getPos _vehicle) select 2 > 2) exitWith {systemChat "Negative. Helo must be landed."};
						if (speed _vehicle > 1) exitWith {systemChat "Negative. Helo must be landed."};

						private ["_hasMRZR"];

						if (_callsign == "A") then {
							_hasMRZR = SAC_THU_HelicopterHasMRZRA;
						} else {
							_hasMRZR = SAC_THU_HelicopterHasMRZRB;
						};
						
						if (_hasMRZR) exitWith {systemChat "Negative. Helo already has MRZR."};

						private _mrzr = nearestObject [_vehicle, "rhsusf_mrzr4_d"];
						
						if ((!isNull _mrzr) && {_mrzr distance _vehicle < 50}) then {
						
							deleteVehicle _mrzr;
							
						} else {
					
							_mrzr = nearestObject [_vehicle, "rhsusf_mrzr4_w"];
							
							if ((!isNull _mrzr) && {_mrzr distance _vehicle < 50}) then {deleteVehicle _mrzr;};
							
						};
					
						if (_callsign == "A") then {SAC_THU_HelicopterHasMRZRA = true} else {SAC_THU_HelicopterHasMRZRB = true};

						systemChat "MRZR succesfuly loaded.";

					};
					case "Unload MRZR": {
					
						if ((getPos _vehicle) select 2 > 3) exitWith {systemChat "Negative. Helo must be less than 2 mts high."};
						if (speed _vehicle > 1) exitWith {systemChat "Negative. Helo must be stationary."};
						
						private ["_hasMRZR"];

						if (_callsign == "A") then {
							_hasMRZR = SAC_THU_HelicopterHasMRZRA;
						} else {
							_hasMRZR = SAC_THU_HelicopterHasMRZRB;
						};
						
						if (!_hasMRZR) exitWith {systemChat "Negative. Helo doesn't have an MRZR loaded."};
						
						private _mrzr = objNull;
						
						if (SAC_UDS_weaponColor == "SAND") then {
						
							_mrzr = createVehicle ["rhsusf_mrzr4_d", getPos _vehicle, [], 0, "NONE"];
						
						} else {
						
							_mrzr = createVehicle ["rhsusf_mrzr4_w", getPos _vehicle, [], 0, "NONE"];
							[_mrzr, ["mud_olive", 1]] call BIS_fnc_initVehicle;
						
						};
						
						_mrzr setDir ((getDir _vehicle) - 180);
						
						_mrzr setPos (getPos _mrzr);
						
						{_x addCuratorEditableObjects [[_mrzr], true]} forEach allCurators;
						
						if (_callsign == "A") then {SAC_THU_HelicopterHasMRZRA = false} else {SAC_THU_HelicopterHasMRZRB = false};
						
					};
					
				};

			};
			case "Insert...": {

				SAC_user_input = "";

				0 = createdialog "SAC_2x12_panel";
				//ctrlSetText [1800, " THU Interface (Insert) "];
				ctrlSetText [1800, format[" THU Interface (Insert) - %1 - %2 ", _vehicleName, _vehicleCallsign]];

				ctrlSetText [1601, "Destination, Insert, RTB"]; if (!_destinationExist) then {ctrlEnable [1601, false]};
				ctrlSetText [1602, "Destination, Insert, Waiting Point"]; if (!_destinationExist || !_waitingPointExist) then {ctrlEnable [1602, false]};
				ctrlSetText [1603, "Entry Route, Insert, Waiting Point"]; if (!_destinationExist || !_waitingPointExist || !_entryRouteExist) then {ctrlEnable [1603, false]};
				ctrlSetText [1604, "Entry Route, Insert, Exfil Route"]; if (!_destinationExist || !_exfilRouteExist || !_entryRouteExist) then {ctrlEnable [1604, false]};
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
				ctrlShow [1615, false ];
				ctrlShow [1616, false ];
				ctrlShow [1617, false ];
				ctrlShow [1618, false ];
				ctrlShow [1619, false ];
				ctrlShow [1620, false ];
				ctrlShow [1621, false ];
				ctrlShow [1622, false ];
				ctrlShow [1623, false ];
				ctrlShow [1624, false ];

				waitUntil { !dialog };

				switch (SAC_user_input) do {
				
					case "Destination, Insert, RTB": {
						hint "";
						if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

						//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
						driver _vehicle disableAI "TARGET";

						[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

						if (_callsign == "A") then {
							[_callsign, "SAC_THU_DestinationA", "DIRECTO", "INSERT", "DIRECTO"] spawn SAC_THU_FlyToDestination;
						} else {
							[_callsign, "SAC_THU_DestinationB", "DIRECTO", "INSERT", "DIRECTO"] spawn SAC_THU_FlyToDestination;
						};
					};
					case "Entry Route, Insert, Waiting Point": {
						hint "";
						if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

						//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
						driver _vehicle disableAI "TARGET";

						[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

						if (_callsign == "A") then {
							[_callsign, "SAC_THU_DestinationA", "RUTA", "INSERT", "WAIT"] spawn SAC_THU_FlyToDestination;
						} else {
							[_callsign, "SAC_THU_DestinationB", "RUTA", "INSERT", "WAIT"] spawn SAC_THU_FlyToDestination;
						};
					};
					case "Entry Route, Insert, Exfil Route": {
						hint "";
						if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

						//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
						driver _vehicle disableAI "TARGET";

						[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

						if (_callsign == "A") then {
							[_callsign, "SAC_THU_DestinationA", "RUTA", "INSERT", "RUTA"] spawn SAC_THU_FlyToDestination;
						} else {
							[_callsign, "SAC_THU_DestinationB", "RUTA", "INSERT", "RUTA"] spawn SAC_THU_FlyToDestination;
						};
					};
					case "Destination, Insert, Waiting Point": {
						hint "";
						if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

						//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE";
						driver _vehicle disableAI "TARGET";

						[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

						if (_callsign == "A") then {
							[_callsign, "SAC_THU_DestinationA", "DIRECTO", "INSERT", "WAIT"] spawn SAC_THU_FlyToDestination;
						} else {
							[_callsign, "SAC_THU_DestinationB", "DIRECTO", "INSERT", "WAIT"] spawn SAC_THU_FlyToDestination;
						};
					};
					
				};

			};
			case "Slingload...": {

				SAC_user_input = "";

				0 = createdialog "SAC_1x14_panel";
				//ctrlSetText [1800, " THU Interface (Slingload) "];
				ctrlSetText [1800, format[" THU Interface (Slingload) - %1 - %2 ", _vehicleName, _vehicleCallsign]];

				ctrlSetText [1601, "Mark Pick Up Point"];
				ctrlSetText [1602, "Mark Release Point"];
				ctrlSetText [1603, "Check"];
				ctrlShow [1604, false ];
				ctrlSetText [1605, "Execute"];
				ctrlShow [1606, false ];
				ctrlShow [1607, false ];
				ctrlShow [1608, false ];
				ctrlShow [1609, false ];
				ctrlShow [1610, false ];
				ctrlShow [1611, false ];
				ctrlShow [1612, false ];
				ctrlShow [1613, false ];
				ctrlShow [1614, false ];

				waitUntil { !dialog };

				switch (SAC_user_input) do
				{
					case "Mark Pick Up Point": {

						if (SAC_onMapSingleClick_Available) then {
							SAC_onMapSingleClick_Available = false;
							_destinationDesignationMode = true;
							hint "Click on the map to set the pick up point.";
							//"defaultNotification" call SAC_fnc_playSound;
							if (!visibleMap) then {openMap true};
							if (_callsign == "A") then {
								onMapSingleClick "[_pos, ""A""] spawn SAC_THU_processPickUpCoordinates; true";
							} else {
								onMapSingleClick "[_pos, ""B""] spawn SAC_THU_processPickUpCoordinates; true";
							};
						} else {hint "onMapSingleClick is not available."};

					};
					case "Mark Release Point": {

						if (SAC_onMapSingleClick_Available) then {
							SAC_onMapSingleClick_Available = false;
							_destinationDesignationMode = true;
							hint "Click on the map to set the release point.";
							//"defaultNotification" call SAC_fnc_playSound;
							if (!visibleMap) then {openMap true};
							if (_callsign == "A") then {
								onMapSingleClick "[_pos, ""A""] spawn SAC_THU_processReleaseCoordinates; true";
							} else {
								onMapSingleClick "[_pos, ""B""] spawn SAC_THU_processReleaseCoordinates; true";
							};
						} else {hint "onMapSingleClick is not available."};

					};
					case "Check": {

						if (_vehicle canSlingLoad cursorObject) then {

							[_vehicle, "The cargo " + typeOf cursorObject + " could be transported. Over."] spawn SAC_fnc_messageFromUnit;

						} else {

							[_vehicle, "The cargo " + typeOf cursorObject + " could not be transported. Over."] spawn SAC_fnc_messageFromUnit;

						};

					};
					case "Execute": {

						hint "";
						if (_callsign == "A") then {SAC_THU_TerminateCurrentMissionA = true; deleteVehicle SAC_THU_TempHelipadA} else {SAC_THU_TerminateCurrentMissionB = true; deleteVehicle SAC_THU_TempHelipadB};

						//driver _vehicle disableAI "AUTOTARGET"; driver _vehicle disableAI "TARGET"; driver _vehicle disableAI "MOVE"; //no funciona en A3
						driver _vehicle disableAI "TARGET";

						[_vehicle, format ["Solid copy %1, over.", groupID (group player)]] spawn SAC_fnc_messageFromUnit;

						[_callsign] spawn SAC_THU_ExecuteSlingload;

					};
				};

			};
			case "Dismiss Helicopter": {
				[_callsign] call SAC_THU_DismissHelicopter;
			};
			default {

				if (SAC_user_input != "") then {

					[_callsign, SAC_user_input] call SAC_THU_CreateHelicopter;

				};

			};
		};

	/*} else {
	
		[_callsign] call SAC_THU_selectHelipad;
	
	};*/
	
	if (_callsign == "A") then {
		SAC_THU_DestinationDesignationModeA = _destinationDesignationMode;
		SAC_THU_RouteDesignationModeA = _routeDesignationMode;
	} else {
		SAC_THU_DestinationDesignationModeB = _destinationDesignationMode;
		SAC_THU_RouteDesignationModeB = _routeDesignationMode;
	};

};

SAC_THU_selectHelipad = {

	params ["_callsign"];
	
	SAC_user_input = "";

	0 = createdialog "SAC_1x14_panel";
	//ctrlSetText [1800, " THU Interface (Helipad Selection) "];
	ctrlSetText [1800, format[" THU Interface (Helipad Selector) - %1 ", _vehicleCallsign]];

	for [{_c=1},{_c<=14},{_c=_c+1}] do {
	
		if (getMarkerColor format ["SAC_TH_Helipad_%1", _c] != "") then {
		
			ctrlSetText [1600 + _c, format ["SAC_TH_Helipad_%1", _c]];
		
		} else {
		
			ctrlShow [1600 + _c, false ];
		
		};
	
	};

	waitUntil { !dialog };
	
	if (SAC_user_input == "") exitWith {};
	
	if (_callsign == "A") then {
	
		SAC_THU_HelipadAPos = getMarkerPos SAC_user_input;
		SAC_THU_HelipadAMarkerName = SAC_user_input;
		SAC_THU_HelipadADir = markerDir SAC_user_input;
		
		
		//Crear el helipad visible en la base.
		
		//borrar el actual si fuera una reselección de helipad
		if (!isNil "SAC_THU_HelipadAObj") then {deleteVehicle  SAC_THU_HelipadAObj};
		
		/*KK_fnc_setPosAGLS = {
			params ["_obj", "_pos", "_offset"];
			_offset = _pos select 2;
			if (isNil "_offset") then {_offset = 0};
			_pos set [2, worldSize]; 
			_obj setPosASL _pos;
			_pos set [2, vectorMagnitude (_pos vectorDiff getPosVisual _obj) + _offset];
			_obj setPosASL _pos;
		};*/

		//23/03/2018 Lo que hace "setVehiclePosition" es poner el objeto en la superficie más cercana, por eso con el z = 100 lo pone sobre la superficie de cualquier
		//objeto (siempre que tenga menos de 100 mts.). Esto fue hecho para poder crear la base de los helicópteros en el portaviones.
		SAC_THU_HelipadAObj = createVehicle ["Land_HelipadCircle_F", SAC_THU_HelipadAPos, [], 0, "CAN_COLLIDE"];
		SAC_THU_HelipadAObj setVehiclePosition [[SAC_THU_HelipadAPos select 0, SAC_THU_HelipadAPos select 1, 100], [], 0, "CAN_COLLIDE"];
		//[player, [2437.18,5693.47,0]] call KK_fnc_setPosAGLS;
		//[SAC_THU_HelipadAObj, [(getPos SAC_THU_HelipadAObj) select 0, (getPos SAC_THU_HelipadAObj) select 1, 0]] call KK_fnc_setPosAGLS;
		SAC_THU_HelipadAPos = [(getPos SAC_THU_HelipadAObj) select 0, (getPos SAC_THU_HelipadAObj) select 1, (getPosATL SAC_THU_HelipadAObj) select 2];
	
	} else {

		SAC_THU_HelipadBPos = getMarkerPos SAC_user_input;
		SAC_THU_HelipadBMarkerName = SAC_user_input;
		SAC_THU_HelipadBDir = markerDir SAC_user_input;
		
		if (!isNil "SAC_THU_HelipadBObj") then {deleteVehicle  SAC_THU_HelipadBObj};
		
		SAC_THU_HelipadBObj = createVehicle ["Land_HelipadCircle_F", SAC_THU_HelipadBPos, [], 0, "CAN_COLLIDE"];
		SAC_THU_HelipadBObj setVehiclePosition [[SAC_THU_HelipadBPos select 0, SAC_THU_HelipadBPos select 1, 100], [], 0, "CAN_COLLIDE"];
		SAC_THU_HelipadBPos = [(getPos SAC_THU_HelipadBObj) select 0, (getPos SAC_THU_HelipadBObj) select 1, (getPosATL SAC_THU_HelipadBObj) select 2];
	
	};

	//devuelve el valor en SAC_user_input


};

SAC_THU_ChangeParameters = {

	private ["_callsign", "_vehicle", "_status",
	"_flyAltitude", "_landingMode", "_combatMode", "_engineOFFwhenOutOfBase",
	"_useSmoke", "_behaviourMode"];

	_callsign = _this select 0;

	SAC_user_input = "not yet initialized";
	while {SAC_user_input != ""} do {
	
		if (_callsign == "A") then {
			_vehicle = SAC_THU_VehicleA;
			
			_flyAltitude = SAC_THU_FlightAltitudeA;
			_landingMode = SAC_THU_LandingModeA;
			_combatMode = SAC_THU_CombatModeA;
			_engineOFFwhenOutOfBase = SAC_THU_EngineOFFWhenOutOfBaseA;
			_useSmoke = SAC_THU_UseSmokeA;
			_behaviourMode = SAC_THU_BehaviourA;
			
		} else {
			_vehicle = SAC_THU_VehicleB;
			
			_flyAltitude = SAC_THU_FlightAltitudeB;
			_landingMode = SAC_THU_LandingModeB;
			_combatMode = SAC_THU_CombatModeB;
			_engineOFFwhenOutOfBase = SAC_THU_EngineOFFWhenOutOfBaseB;
			_useSmoke = SAC_THU_UseSmokeB;
			_behaviourMode = SAC_THU_BehaviourB;
			
		};

		SAC_user_input = "";

		0 = createdialog "SAC_2x12_panel";
		//ctrlSetText [1800, " THU Interface (Parameters) "];
		ctrlSetText [1800, format[" THU Interface (Parameters) - %1 - %2 ", _vehicleName, _vehicleCallsign]];

		ctrlSetText [1601, "Fly at 60 mts."]; if (_flyAltitude == 60) then {((findDisplay 3000) displayCtrl 1601) ctrlSetBackgroundColor [0,0,0.7,1]};
		ctrlSetText [1602, "Fly at 100 mts."]; if (_flyAltitude == 100) then {((findDisplay 3000) displayCtrl 1602) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1603, "Fly at 150 mts."]; if (_flyAltitude == 150) then {((findDisplay 3000) displayCtrl 1603) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1604, "Fly at 200 mts."]; if (_flyAltitude == 200) then {((findDisplay 3000) displayCtrl 1604) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1605, "Precision Landing"]; if (_landingMode == "Manual") then {((findDisplay 3000) displayCtrl 1605) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1606, "Safe Landing"]; if (_landingMode == "Auto") then {((findDisplay 3000) displayCtrl 1606) ctrlSetBackgroundColor [0,0,0.7,1]};
		ctrlSetText [1607, "Open Fire"]; if (_combatMode == "YELLOW") then {((findDisplay 3000) displayCtrl 1607) ctrlSetBackgroundColor [0,0,0.7,1]};
		ctrlSetText [1608, "Do Not Fire"]; if (_combatMode == "BLUE") then {((findDisplay 3000) displayCtrl 1608) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1609, "Request Current"];
		ctrlSetText [1610, "Engine Off Outside Base ON"]; if (_engineOFFwhenOutOfBase) then {((findDisplay 3000) displayCtrl 1610) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1611, "Engine Off Outside Base OFF"]; if !(_engineOFFwhenOutOfBase) then {((findDisplay 3000) displayCtrl 1611) ctrlSetBackgroundColor [0,0,0.7,1]};
		ctrlSetText [1612, "Use Smoke Shells"]; if (_useSmoke) then {((findDisplay 3000) displayCtrl 1612) ctrlSetBackgroundColor [0,0,0.7,1]};
		
		ctrlSetText [1613, "Do Not Use Smoke Shells"]; if !(_useSmoke) then {((findDisplay 3000) displayCtrl 1613) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1614, "Transport Profile"]; if (_behaviourMode == "CARELESS") then {((findDisplay 3000) displayCtrl 1614) ctrlSetBackgroundColor [0,0,0.7,1]};
		ctrlSetText [1615, "Combat Profile"]; if (_behaviourMode == "AWARE") then {((findDisplay 3000) displayCtrl 1615) ctrlSetBackgroundColor [0.7,0,0,1]};
		ctrlSetText [1616, "Change Helipad"];
		ctrlShow [1617, false];
		ctrlShow [1618, false];
		ctrlShow [1619, false];
		ctrlShow [1620, false];
		ctrlShow [1621, false];
		ctrlShow [1622, false];
		ctrlShow [1623, false];
		ctrlSetText [1624, ""];
		ctrlSetFocus ((findDisplay 3000) displayCtrl 1624);

		waitUntil { !dialog };
		switch (SAC_user_input) do
		{
			case "Fly at 60 mts.": {
				if (_callsign == "A") then {
					SAC_THU_FlightAltitudeA = 60;

				} else {
					SAC_THU_FlightAltitudeB = 60;

				};

				//[_vehicle, "60 mts. fly altitude."] spawn SAC_fnc_messageFromUnit;

				//if (getPosATL _vehicle select 2 > 10) then {_vehicle flyInHeight 60};
				_vehicle flyInHeight 60;
				
			};
			case "Fly at 100 mts.": {
				if (_callsign == "A") then {
					SAC_THU_FlightAltitudeA = 100;

				} else {
					SAC_THU_FlightAltitudeB = 100;

				};

				//[_vehicle, "100 mts. fly altitude."] spawn SAC_fnc_messageFromUnit;

				//if (getPosATL _vehicle select 2 > 10) then {_vehicle flyInHeight 100};
				_vehicle flyInHeight 100;
				
			};
			case "Fly at 150 mts.": {
				if (_callsign == "A") then {
					SAC_THU_FlightAltitudeA = 150;

				} else {
					SAC_THU_FlightAltitudeB = 150;

				};

				//[_vehicle, "150 mts. fly altitude."] spawn SAC_fnc_messageFromUnit;

				//if (getPosATL _vehicle select 2 > 10) then {_vehicle flyInHeight 150};
				_vehicle flyInHeight 150;
				
			};
			case "Fly at 200 mts.": {
				if (_callsign == "A") then {
					SAC_THU_FlightAltitudeA = 200;

				} else {
					SAC_THU_FlightAltitudeB = 200;

				};

				//[_vehicle, "200 mts. fly altitude."] spawn SAC_fnc_messageFromUnit;

				//if (getPosATL _vehicle select 2 > 10) then {_vehicle flyInHeight 200};
				_vehicle flyInHeight 200;
				
			};
			case "Precision Landing": {
				if (_callsign == "A") then {SAC_THU_LandingModeA = "Manual"} else {SAC_THU_LandingModeB = "Manual"};

				//[_vehicle, "Manual landing system."] spawn SAC_fnc_messageFromUnit;

			};
			case "Safe Landing": {
				if (_callsign == "A") then {SAC_THU_LandingModeA = "Auto"} else {SAC_THU_LandingModeB = "Auto"};

				//[_vehicle, "Safe landing system."] spawn SAC_fnc_messageFromUnit;
			};
			case "Open Fire": {
				if (_callsign == "A") then {SAC_THU_CombatModeA = "YELLOW"} else {SAC_THU_CombatModeB = "YELLOW"};
				_vehicle setCombatMode "YELLOW";

				//[_vehicle, "Engage hostiles."] spawn SAC_fnc_messageFromUnit;

			};
			case "Do Not Fire": {
				if (_callsign == "A") then {SAC_THU_CombatModeA = "BLUE"} else {SAC_THU_CombatModeB = "BLUE"};
				_vehicle setCombatMode "BLUE";

				//[_vehicle, "Hold fire."] spawn SAC_fnc_messageFromUnit;

			};
			case "Request Current": {

				if (_callsign == "A") then {

					private _currentHelipad = if (isNil "SAC_THU_HelipadAMarkerName") then {"NONE"} else {SAC_THU_HelipadAMarkerName};
					hint (str SAC_THU_FlightAltitudeA + " " + SAC_THU_CombatModeA + " " + str SAC_THU_WaitFlightAltitudeA + " " + _currentHelipad);

				} else {

					private _currentHelipad = if (isNil "SAC_THU_HelipadBMarkerName") then {"NONE"} else {SAC_THU_HelipadBMarkerName};
					hint (str SAC_THU_FlightAltitudeB + " " + SAC_THU_CombatModeB + " " + str SAC_THU_WaitFlightAltitudeB + " " + _currentHelipad);

				};

			};
			case "Engine Off Outside Base ON": {

				if (_callsign == "A") then {

					SAC_THU_EngineOFFWhenOutOfBaseA = true;

				} else {

					SAC_THU_EngineOFFWhenOutOfBaseB = true;

				};

			};
			case "Engine Off Outside Base OFF": {

				if (_callsign == "A") then {

					SAC_THU_EngineOFFWhenOutOfBaseA = false;

				} else {

					SAC_THU_EngineOFFWhenOutOfBaseB = false;

				};

			};
			case "Use Smoke Shells": {
				if (_callsign == "A") then {SAC_THU_UseSmokeA = true} else {SAC_THU_UseSmokeB = true};

				//[_vehicle, "Deploy smoke."] spawn SAC_fnc_messageFromUnit;

			};
			case "Do Not Use Smoke Shells": {
				if (_callsign == "A") then {SAC_THU_UseSmokeA = false} else {SAC_THU_UseSmokeB = false};

				//[_vehicle, "Do not deploy smoke."] spawn SAC_fnc_messageFromUnit;

			};
			case "Transport Profile": {
				if (_callsign == "A") then {
					SAC_THU_BehaviourA = "CARELESS";
					SAC_THU_VehicleA setBehaviour SAC_THU_BehaviourA;

				} else {
					SAC_THU_BehaviourB = "CARELESS";
					SAC_THU_VehicleB setBehaviour SAC_THU_BehaviourB;
				};
				
			};
			case "Combat Profile": {
				if (_callsign == "A") then {
					SAC_THU_BehaviourA = "AWARE";
					SAC_THU_VehicleA setBehaviour SAC_THU_BehaviourA;

				} else {
					SAC_THU_BehaviourB = "AWARE";
					SAC_THU_VehicleB setBehaviour SAC_THU_BehaviourB;
				};
				
			};
			case "Change Helipad": {
			
				[_callsign] call SAC_THU_selectHelipad;

			};
			default {SAC_user_input = ""};
		};
	};
};
/*
SAC_THU_climbProtection = {

	private ["_vehicle", "_callsign", "_continue", "_designatedAltitude"];

	_vehicle = _this select 0;
	_callsign = _this select 1;

	if (_callsign == "A") then {_designatedAltitude = SAC_THU_FlightAltitudeA} else {_designatedAltitude = SAC_THU_FlightAltitudeB};

	while {true} do {

		waitUntil {sleep 1; ((!alive driver _vehicle) || {(getPos _vehicle) select 2 > _designatedAltitude + 20})};

		if (!alive driver _vehicle) exitWith {};

		_vehicle setCaptive true;

		waitUntil {sleep 1; ((!alive driver _vehicle) || {(getPos _vehicle) select 2 < _designatedAltitude + 20})};

		if (!alive driver _vehicle) exitWith {};

		_vehicle setCaptive SAC_THU_HeliCaptive;

	};

	systemChat "Se termino una instancia de climbProtection.";

};
*/

SAC_THU_HeliAI = {

	private ["_vehicle", "_callsign", "_crewGroup", "_vehicleCrew", "_driver", "_periodsLandedWithEngineOn", "_continue", "_helicopterReady",
	"_helipad", "_releaseControl"];


	_vehicle = _this select 0;
	_callsign = _this select 1;
	_engineOFFwhenOutOfBase = _this select 3;

	_crewGroup = group driver _vehicle;
	_vehicleCrew = units group driver _vehicle;
	_driver = driver _vehicle;

	if (_callsign == "A") then {_helicopterReady = SAC_THU_HelicopterReadyA; _releaseControl = SAC_THU_ReleaseControlA} else {_helicopterReady = SAC_THU_HelicopterReadyB; _releaseControl = SAC_THU_ReleaseControlB};
	_periodsLandedWithEngineOn = 0;
	
	"sac_sounds_support_available1" spawn SAC_fnc_playSound;
	_vehicle sideChat "Be advise, support units are now on stand-by.";
	
	_continue = true;
	while {_continue && _helicopterReady && !_releaseControl} do {

		sleep 10; //30

		if ((alive _vehicle) && (canMove _vehicle)) then {
			if (fuel _vehicle < 0.25) then {

				hint format ["Helicopter %1 needs refueling.", _callsign];
				"defaultNotification" call SAC_fnc_playSound;

			};
		};

		if ((position _vehicle select 2 < 1) && (isEngineOn _vehicle)) then {
			_periodsLandedWithEngineOn = _periodsLandedWithEngineOn + 1;
		} else {
			_periodsLandedWithEngineOn = 0;
		};

		//systemChat str _periodsLandedWithEngineOn;

		if (_periodsLandedWithEngineOn == 18) then {
		
			//systemChat "_periodsLandedWithEngineOn == 18";

			if (isEngineOn _vehicle) then {

				if (_callsign == "A") then {
					_helipad = SAC_THU_HelipadAPos;
				} else {
					_helipad = SAC_THU_HelipadBPos;
				};
				
				if ((_vehicle distance _helipad) < 200) then {
				
					//systemChat "apagando";

					driver _vehicle action ["engineOff", _vehicle];
					_vehicle setFuel 1;
					_vehicle setVehicleAmmo 1;

				} else {
				
					//systemChat "not in base";

					if (((_callsign == "A") && {SAC_THU_EngineOFFWhenOutOfBaseA}) || ((_callsign == "B") && {SAC_THU_EngineOFFWhenOutOfBaseB})) then {driver _vehicle action ["engineOff", _vehicle]};

				};

			};

			_periodsLandedWithEngineOn = 0;

		};

		if (_callsign == "A") then {_helicopterReady = SAC_THU_HelicopterReadyA; _releaseControl = SAC_THU_ReleaseControlA} else {_helicopterReady = SAC_THU_HelicopterReadyB; _releaseControl = SAC_THU_ReleaseControlB};
		
		if (_helicopterReady) then {
			//if ((!alive _vehicle) || (!canMove _vehicle) || (!alive driver _vehicle)  || (units _crewGroup findIf {alive _x} == -1) then {
			if (_releaseControl || (!alive _vehicle) || (!canMove _vehicle) || (units _crewGroup findIf {alive _x} == -1) || (isPlayer driver _vehicle)) then {

				switch (true) do {
				
					case (_releaseControl): {
					
						driver _vehicle action ["engineOff", _vehicle];
						
						{
						
							_vehicle deleteVehicleCrew _x;
						
						} forEach units _crewGroup;
					
					};
					
					case (!alive _vehicle): {
					
						if (_callsign == "A") then {
						
							hint "Angel 1 has been destroyed.";
						
						} else {
						
							hint "Angel 2 has been destroyed.";
						
						};
						"sac_sounds_support_KIA" spawn SAC_fnc_playSound;
						systemChat "All units be advice, we've lost comms with Delta Three One, presumed KIA, out.";
					
					};
					
					case (!canMove _vehicle): {
					
						//hint "Helicopter can't fly due to severe dammage!";
						//"defaultNotification" call SAC_fnc_playSound;
						
						if (vehicle player != _vehicle) then {"sac_sounds_mayday1" spawn SAC_fnc_playSound};
						[driver _vehicle, "sac_sounds_mayday1", 100] spawn SAC_fnc_netSay3D;
						_vehicle sideChat "Mayday, Mayday, Golf Four One going down!";

					
					};
					
					case (units _crewGroup findIf {alive _x} == -1): {
					
						if (_callsign == "A") then {
						
							hint "Angel 1's crew is dead!";
						
						} else {
						
							hint "Angel 2's crew is dead!";
						
						};
						"defaultNotification" call SAC_fnc_playSound;
						[] spawn {
						
							sleep 5;
						"sac_sounds_support_KIA" spawn SAC_fnc_playSound;
						systemChat "All units be advice, we've lost comms with Delta Three One, presumed KIA, out.";
							
						};
					
					};
					
					case (isPlayer driver _vehicle): {
					
						hint "A player took control of the helicopter!";
						"defaultNotification" call SAC_fnc_playSound;
					
					};
				
				};
			
			
				if (!_releaseControl) then {
				
					_vehicle allowDammage false;

					[_vehicle] spawn {

						private ["_v"];

						_v = _this select 0;

						waitUntil {getPos _v select 2 < 2};

						sleep 30;

						_v allowDammage true;

					};
					
				};

				if (_callsign == "A") then {
					SAC_THU_HelicopterReadyA = false;
					SAC_THU_TerminateCurrentMissionA = true;
					SAC_THU_ReadyTimeForProductionA = time + (SAC_THU_ReadyTimeAfterCrashed * 60);
				} else {
					SAC_THU_HelicopterReadyB = false;
					SAC_THU_TerminateCurrentMissionB = true;
					SAC_THU_ReadyTimeForProductionB = time + (SAC_THU_ReadyTimeAfterCrashed * 60);
				};

				if (_vehicleCrew findIf {alive _x} != -1) then {
					//_vehicleCrew join group player;
					{
						[_x] spawn {
							private ["_unit"];
							_unit = _this select 0;
							waitUntil{((getPosATL vehicle _unit) select 2 < 1) || (!alive _unit)};
							if (alive _unit) then {
								_unit enableAI "TARGET";
								_unit setCaptive false;
								[_unit] join group player;
								_unit assignTeam "BLUE";
								//removeHeadgear _unit;
								//_unit unlinkItem "NVGoggles";
							};
						};
					} forEach _vehicleCrew;
/*
					hint "Helicopter is destroyed. Some crew members survived!";
					"defaultNotification" call SAC_fnc_playSound;*/

				} else {
					//taskHint ["Helicopter lost.\nNo crew members survived.",[1,1,1,1],"taskNew"];
				};
				
				_continue = false;
				
			} else {
			
				if (!alive driver _vehicle) then {
				
					_vehicle lockDriver false;
					[_vehicle] call SAC_fnc_unlockLockedTurrets;
				
					if (vehicle player == _vehicle) then {
					
						hint "Helicopter pilot's dead. Take his place ASAP!";
						//"defaultNotification" call SAC_fnc_playSound;

					} else {
					
						//hint "Helicopter pilot's dead. It's going down!";
						//"defaultNotification" call SAC_fnc_playSound;
						
						"sac_sounds_mayday0" spawn SAC_fnc_playSound;
					
					};
					
					[commander _vehicle, "sac_sounds_mayday0", 100] spawn SAC_fnc_netSay3D;
					_vehicle sideChat "Golf Two Two to Crossroads, we're under fire, sustaining heavy fire from...";
					
					//private _copilot = (_vehicle call SAC_fnc_getCoPilots) select 0;
					/*unassignVehicle player; player action ["Eject", vehicle player];
					waitUntil{isNull objectParent player};
					player moveInDriver _vehicle;*/
					
					if !(_vehicle getVariable ["SAC_THU_hasTAKECONTROLaction", false]) then {
					
						[_vehicle, "<t color='#00FFFF'>*** TOMAR CONTROL ***</t>", "", 6, [], 0, ""] call SAC_fnc_addPredefinedAction;
						
						_vehicle setVariable ["SAC_THU_hasTAKECONTROLaction", true, true];
						
					};
				
				
				};
			
			};
		};

		//player sideChat "alive vehicle:" + str (alive _vehicle);
		//player sideChat "canmove vehicle:" + str (canMove _vehicle);
		//player sideChat "alive driver:" + str (alive _driver);

	};
	
	_vehicle lockDriver false;
	[_vehicle] call SAC_fnc_unlockLockedTurrets;

	systemChat "Se termino una instancia de heliAI.";

};

SAC_THU_fnc_tracker = {

	private ["_vehicle", "_callsign", "_marker", "_vehicleReady"];

	_vehicle = _this select 0;
	_callsign = _this select 1;

	if (_callsign == "A") then {

		_vehicleReady = SAC_THU_HelicopterReadyA;

	} else {

		_vehicleReady = SAC_THU_HelicopterReadyB;

	};

	_marker = [getPos _vehicle, SAC_trackerColor, format ["%1", groupID (group _vehicle)], "b_air", [1, 1]] call SAC_fnc_createMarker;

	while {_vehicleReady && {alive _vehicle}} do {

		_marker setMarkerPos getPos _vehicle;

		sleep 1; //30

		if (_callsign == "A") then {_vehicleReady = SAC_THU_HelicopterReadyA} else {_vehicleReady = SAC_THU_HelicopterReadyB};

	};

	deleteMarker _marker;

};

SAC_THU_ReportStatus = {
	private ["_callsign", "_vehicle", "_positionInMap", "_alt", "_speed", "_dir", "_altStr", "_statusLine"];

	_callsign = _this select 0;

	if (_callsign == "A") then {
		_vehicle = SAC_THU_VehicleA;
	} else {
		_vehicle = SAC_THU_VehicleB;
	};

	_positionInMap = mapGridPosition _vehicle;
	_alt = (position _vehicle) select 2;
	_speed = str speed _vehicle;
	_dir = str  getDir _vehicle;

	if (_alt > 1) then {
		_altStr = str _alt;
		_statusLine = "Flying at grid " + _positionInMap + " Speed " + _speed + " Altitude " + _altStr + " Bearing " + _dir;

	} else {

		_statusLine = "Landed at grid " + _positionInMap;

	};

	hint _statusLine;

};

SAC_THU_DismissHelicopter = {
	private ["_callsign", "_vehicle", "_base", "_distanceToBase", "_alt", "_unitsInVehicle", "_crewGroup"];


	_callsign = _this select 0;

	if (_callsign == "A") then {
		_vehicle = SAC_THU_VehicleA;
		_base = SAC_THU_HelipadAPos;
	} else {
		_vehicle = SAC_THU_VehicleB;
		_base = SAC_THU_HelipadBPos;
	};

	_distanceToBase = _vehicle distance _base;
	_alt = getPos _vehicle select 2;
	_unitsInVehicle = {alive _x} count crew _vehicle;
	_crewGroup = group driver _vehicle;

	if ((_distanceToBase > 100) || (_alt > 1)) exitWith {hint "The helicopter must be landed at base."};

	if (_unitsInVehicle > ({alive _x} count units _crewGroup)) exitWith {hint "The helicopter has passengers."};

	//"_items", "_positions", "_proximityMode", "_distances", "_checkInterval", "_side", "_aliveCheck", "_TTLCheck"
	[[_vehicle] + units _crewGroup + [_crewGroup], [], 0, [0, 0], 120, civilian, false, false] spawn SAC_fnc_garbageCollector;

	if (_callsign == "A") then {SAC_THU_HelicopterReadyA = false} else {SAC_THU_HelicopterReadyB = false};

};

SAC_THU_CreateRoute = {
	private ["_callsign", "_routeType", "_route", "_vehicle", "_wpColor", "_count", "_lastPos", "_pos", "_temp2DPos", "_lastPos2D",
	 "_wpNumber", "_marker", "_distanceFromLastPos", "_heliH", "_dir", "_midWayToNewPos"];

	_callsign = _this select 0;
	_routeType = _this select 1;

	if (_routeType == "Entry") then {
		if (_callsign == "A") then {
			_route = SAC_THU_RouteA;
			_vehicle = SAC_THU_VehicleA;
			_wpColor = "ColorBlack";
		} else {
			_route = SAC_THU_RouteB;
			_vehicle = SAC_THU_VehicleB;
			_wpColor = "ColorBlack";
		};
	} else { //Exfil route type
		if (_callsign == "A") then {
			_route = SAC_THU_ExfilRouteA;
			_vehicle = SAC_THU_VehicleA;
			_wpColor = "ColorBlack";
		} else {
			_route = SAC_THU_ExfilRouteB;
			_vehicle = SAC_THU_VehicleB;
			_wpColor = "ColorBlack";
		};
	};

	//hint "Click on the map to set route points.";
	hint parseText "Click on the map to set route points. <t color='#FF0000' size='1.2'><br/>Exfil last point is NOT the landing point.<br/></t>";
	//"defaultNotification" call SAC_fnc_playSound;

	if (!visibleMap) then {openMap true};

	if ((count _route) > 0) then {
		for "_count" from 1 to (count _route) do {
			deleteMarkerLocal format ["SAC_THU_wp%1%2%3", _callsign, _count, _routeType];
			deleteMarkerLocal format ["SAC_THU_wp%1%2%3line", _callsign, _count, _routeType];
		};
	};

	_route = [];
	SAC_THU_NewWP = [0,0,0];
	SAC_THU_TerminateRouteDesignation = false;

	while {!SAC_THU_TerminateRouteDesignation} do {
		_lastPos = SAC_THU_NewWP;
		onMapSingleClick "SAC_THU_NewWP = _pos";
		waitUntil {(str _lastPos != str SAC_THU_NewWP) || (SAC_THU_TerminateRouteDesignation)};

		if (SAC_THU_TerminateRouteDesignation) exitWith {};

		_temp2DPos = [SAC_THU_NewWP select 0, SAC_THU_NewWP select 1];
		_lastPos2D = [_lastPos select 0, _lastPos select 1];

		_route pushBack _temp2DPos;

		_wpNumber = count _route;

		_marker = createMarkerLocal [format["SAC_THU_wp%1%2%3", _callsign, _wpNumber, _routeType], SAC_THU_NewWP];
		_marker setMarkerTypeLocal selectRandom ["Contact_pencilTask1","Contact_pencilTask2","Contact_pencilTask3"];
		_marker setMarkerSizeLocal [0.5, 0.5];
		_marker setMarkerColorLocal _wpColor;
		_marker setMarkerTextLocal format["%1%2 %3", _wpNumber, groupID group _vehicle, _routeType];
		//_marker setMarkerTextLocal str _wpNumber;

		if (_wpNumber > 1) then {
			_distanceFromLastPos = _lastPos2D distance _temp2DPos;
			_heliH = createVehicle ["Land_HelipadEmpty_F", _lastPos2D, [], 0, "CAN_COLLIDE"];
			_dir = ((_temp2DPos select 0) - (_lastPos2D select 0)) atan2 ((_temp2DPos select 1) - (_lastPos2D select 1));
			_heliH setDir _dir;
			_midWayToNewPos = _heliH modelToWorld [0, _distanceFromLastPos / 2, 0];
			deleteVehicle _heliH;

			_marker = createMarkerLocal [format["SAC_THU_wp%1%2%3line", _callsign, _wpNumber, _routeType], _midWayToNewPos];
			_marker setMarkerShapeLocal "RECTANGLE";
			_marker setMarkerColorLocal "ColorBlack";
			_marker setMarkerSizeLocal [2, _distanceFromLastPos / 2];
			_marker setMarkerDirLocal _dir;
		};

	};

	if (_routeType == "Entry") then {
		if (_callsign == "A") then {
			 SAC_THU_RouteA = _route;
		} else {
			 SAC_THU_RouteB = _route;
		};
	} else { //Exfil route type
		if (_callsign == "A") then {
			 SAC_THU_ExfilRouteA = _route;
		} else {
			 SAC_THU_ExfilRouteB = _route;
		};
	};

};

SAC_THU_UnloadSupply = {

	private ["_callsign", "_vehicle", "_hasSupply", "_alt", "_supply", "_boxPos"];

	_callsign = _this select 0;

	if (_callsign == "A") then {
		_vehicle = SAC_THU_VehicleA;
		_hasSupply = SAC_THU_HelicopterHasSupplyA;
	} else {
		_vehicle = SAC_THU_VehicleB;
		_hasSupply = SAC_THU_HelicopterHasSupplyB;
	};

	_alt = getPos _vehicle select 2;

	if (!_hasSupply) exitWith {hint "No supplies onboard."};
	if (_alt > 1) exitWith {hint "The helicopter must be landed."};


	//Generar ammo box
	//_boxPos = _vehicle modelToWorld [15,0,0];
	// _boxPos = getPos _vehicle;
	// _boxPos = [_boxPos select 0, _boxPos select 1, 0.1];
	if (!isNil "SAC_GEAR") then {
	
		if (SAC_GEAR) then {
		
			switch (_vehicle getVariable "SAC_THU_cargo_capacity") do {
			
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
						if (_callsign == "A") then {SAC_THU_HelicopterHasSupplyA = false} else {SAC_THU_HelicopterHasSupplyB = false};

						hint "Supplies unloaded.";

					} else {hint "There's no room."};
					
				};
				
				case "MEDIUM": {
				
					_boxPos = (getPosATL _vehicle) findEmptyPosition [0, 50, "B_supplyCrate_F"];
					if (count _boxPos == 3) then {
						_supply = createVehicle ["B_supplyCrate_F", _boxPos, [], 0, "NONE"];
						//workaround porque por alg�n motivo cuando creo las cajas empiezan a tomar da�o y no paran hasta que explotan.
						_supply allowDammage false;
						_supply setDammage 0;
						_supply setPosATL _boxPos;
						//[_supply, "SQUAD", "PLAYER_SQUAD_AMMO", "MEDIUM"] spawn SAC_GEAR_fnc_addContainer;
						[_supply] spawn SAC_GEAR_fnc_activateSupplies;
						if (_callsign == "A") then {SAC_THU_HelicopterHasSupplyA = false} else {SAC_THU_HelicopterHasSupplyB = false};

						hint "Supplies unloaded."

					} else {hint "There's no room."};
					
				};
				
				case "HEAVY": {
				
					_boxPos = (getPosATL _vehicle) findEmptyPosition [0, 50, "B_supplyCrate_F"];
					if (count _boxPos == 3) then {
						_supply = createVehicle ["B_supplyCrate_F", _boxPos, [], 0, "NONE"];
						//workaround porque por alg�n motivo cuando creo las cajas empiezan a tomar da�o y no paran hasta que explotan.
						_supply allowDammage false;
						_supply setDammage 0;
						_supply setPosATL _boxPos;
						//[_supply, "SQUAD", "PLAYER_SQUAD_AMMO", "LARGE"] spawn SAC_GEAR_fnc_addContainer;
						[_supply] spawn SAC_GEAR_fnc_activateSupplies;
						if (_callsign == "A") then {SAC_THU_HelicopterHasSupplyA = false} else {SAC_THU_HelicopterHasSupplyB = false};

						hint "Supplies unloaded."

					} else {hint "There's no room."};
					
				};
				
			}
		};
		
	} else { 
	
		//En A3, esta opción no está realmente contemplada. THU tiene que correr siempre con GEAR, y después de GEAR. El resultado de este bloque de código no está realmente soportado.
		_supply = createVehicle ["Box_NATO_Ammo_F", _vehicle modelToWorld [2,0,0], [], 0, "CAN_COLLIDE"];
		clearMagazineCargo _supply;
		clearWeaponCargo _supply;
		if (_callsign == "A") then {SAC_THU_HelicopterHasSupplyA = false} else {SAC_THU_HelicopterHasSupplyB = false};
		
	};

};

SAC_THU_LoadSupply = {

	private ["_callsign", "_vehicle", "_hasSupply", "_base", "_distanceToBase", "_alt"];

	_callsign = _this select 0;

	if (_callsign == "A") then {
		_vehicle = SAC_THU_VehicleA;
		_hasSupply = SAC_THU_HelicopterHasSupplyA;
		_base = SAC_THU_HelipadAPos;
	} else {
		_vehicle = SAC_THU_VehicleB;
		_hasSupply = SAC_THU_HelicopterHasSupplyB;
		_base = SAC_THU_HelipadBPos;
	};

	_distanceToBase = _vehicle distance _base;
	_alt = getPos _vehicle select 2;

	if ((_distanceToBase > 100) || (_alt > 1)) exitWith {hint "The helicopter must be landed at base."};

	if (_callsign == "A") then {SAC_THU_HelicopterHasSupplyA = true} else {SAC_THU_HelicopterHasSupplyB = true};

	hint "Supplies loaded.";

};

SAC_THU_FlyAndCircle = {

	params ["_callsign", "_centerPoint"];
	
	private ["_destinationMarker", "_vehicle", "_flyAltitude", "_behaviourMode", "_destination", "_loiterMarker"];

	if (_callsign == "A") then {
		_destinationMarker = "SAC_THU_DestinationA";
		_loiterMarker = "SAC_THU_LoiterPointA";
		_vehicle = SAC_THU_VehicleA;
		_flyAltitude = SAC_THU_FlightAltitudeA;
		_behaviourMode = SAC_THU_BehaviourA;
		SAC_THU_TerminateCurrentMissionA = false;
		SAC_THU_StatusA = if (_centerPoint == "DESTINATION") then {"Orbiting destination"} else {"Orbiting loiter point"};
	} else {
		_destinationMarker = "SAC_THU_DestinationB";
		_loiterMarker = "SAC_THU_LoiterPointB";
		_vehicle = SAC_THU_VehicleB;
		_flyAltitude = SAC_THU_FlightAltitudeB;
		_behaviourMode = SAC_THU_BehaviourB;
		SAC_THU_TerminateCurrentMissionB = false;
		SAC_THU_StatusB = if (_centerPoint == "DESTINATION") then {"Orbiting destination"} else {"Orbiting loiter point"};;
	};

	private _abort = false;
	switch (_centerPoint) do {
	
		case "DESTINATION": {
		
			if !(_destinationMarker in allMapMarkers) then {hint "Destination is not defined."; _abort = true} else {_destination = getMarkerPos _destinationMarker};
		
		};
		case "LOITERPOINT": {
		
			if !(_loiterMarker in allMapMarkers) then {hint "Loiter point is not defined."; _abort = true} else {_destination = getMarkerPos _loiterMarker};
		
		};
	
	};
	
	if (_abort) exitWith {};

	sleep 1;

	// _vehicle sideChat "Copy, on the way, over...";
	// "radiochatter_us_18" call SAC_fnc_playSound;
	////////////////////////////////////////////////////////////////////////

	if (!isEngineOn _vehicle) then {
		driver _vehicle action ["engineOn", _vehicle];
	};

	
	deleteWaypoint [group _vehicle, 1];
	
	//desde el 1/5/2020
/*	[group _vehicle, (currentWaypoint group _vehicle)] setWaypointPosition [getPosASL _vehicle, -1];
	sleep 0.1;
	for "_i" from count waypoints _vehicle - 1 to 0 step -1 do 
	{
		deleteWaypoint [group _vehicle, _i];
	};
*/	
	_vehicle setCaptive SAC_THU_HeliCaptive;
	_vehicle land "NONE";
	sleep 1;

	switch (typeOf _vehicle) do {

		case "Cha_UH60M_US";
		case "Cha_UH60L_US": {

			{_vehicle animate [_x, 0]} forEach (_vehicle call SAC_fnc_openableDoors);

		};

		case "RHS_CH_47F_light";
		case "RHS_CH_47F_10";
		case "RHS_CH_47F": {

			_vehicle animateSource ["ramp_anim", 0];

		};

		default {

			{_vehicle animateDoor [_x, 0]} forEach (_vehicle call SAC_fnc_openableDoors);

		};

	};

	_vehicle flyInHeight _flyAltitude;

	private ["_wp"];

	_wp = group _vehicle addWaypoint [_destination, 0];
	_wp setWaypointType "LOITER";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointBehaviour "CARELESS"; //en careless los ah-64 no atacan con los misiles a los tanques
	//por el contrario, en aware/combat no respetan volvar en circulos ni la altitud, y erran los misiles mucho
	//conclusión: no usar chopos contra tanques usando THU
	_wp setWaypointCombatMode "YELLOW";
	_wp setWaypointLoiterRadius 800; //volando a 200 mts, con un loiter de 800 mts, el apache tiene una killzone
	//muy amplia, con un punto ciego para el cañón de unos 200 mts max en el centro del loiter, lo cual no solo
	//es aceptable, sino que también se puede considerar una zona de seguridad contra el fuego amigo.
	_wp setWaypointLoiterType "CIRCLE_L"; //podría ser "CIRCLE_L" para orbitar en sentido antihorario
	_vehicle setBehaviourStrong _behaviourMode;

	//la manera de cancelar la órden -------->  deleteWaypoint [group _vehicle, 1];

};

SAC_THU_FastRope = {

	private ["_heli", "_indicatedUnits", "_useSmoke", "_altHeli", "_units", "_smoke", "_unit",
	"_heli_position", "_disembark_position", "_disembark_unit_direction", "_dir_step"];

	_heli = _this select 0;
	_indicatedUnits = _this select 1;
	_useSmoke = _this select 2;

	// el heli tiene que estar estacionario a menos de 75 mts.
	if (speed _heli > 0.1) exitwith {hint "The helicopter must be stationary."};
	//_altHeli = (getPos _heli) select 2;
	//if (_altHeli  < 2) exitWith {hint "Below minimun safe altitude of 2 mts."};
	//if (_altHeli  > 75) exitWith {hint "Above maximun safe altitude of 75 mts."}; //11/10/2019 se subió a 75 porque en la zonas montañosas de Tanoa los chopos hacen hover a mucha altura

	//La lista de unidades no puede estar vacía.
	if (count _indicatedUnits == 0) exitWith {hint "Select some units first."};

	//Alguna unidad debe estar a bordo del helicóptero.
	_units = [];
	{
		if (vehicle _x == _heli) then {_units pushBack _x};
	} forEach _indicatedUnits;
	if (count _units == 0) exitWith {hint "None of the selected units are in the chopper."};

	if (_useSmoke) then {
		_smoke = "SmokeShellBlue" createVehicle getPos _heli;
		_smoke setVelocity [1 + random 1, 1 + random 1, 0];

		_smoke = "SmokeShellBlue" createVehicle getPos _heli;
		_smoke setVelocity [-1 - random 1, -1 - random 1, 0];

	};

	sleep 3;

	_heli_position =  getPosATL _heli;
	_disembark_position = [_heli_position select 0, _heli_position select 1, 0];

	_disembark_unit_direction = 0;
	_dir_step = 360 / count _units;

	{

		if (speed _heli > 0.1) exitwith {hint "Fastrope operation aborted."; "defaultNotification" call SAC_fnc_playSound;};

		_unit = _x;

		_unit setUnitPos "Up";
		_unit action ["GetOut", _heli];
		while {isNull objectParent _unit} do {sleep 0.01};
		if (isplayer _unit) then {sleep 0.5} else {sleep 0.2};

		_unit setPosATL ([getPos _unit select 0, getPos _unit select 1, 0]);

		[_unit] allowGetIn false;

		[_unit, _disembark_position getPos [15, _disembark_unit_direction]] remoteExec ["doMove", _unit]; 
		//_unit doMove (_disembark_position getPos [15, _disembark_unit_direction]);
		[_unit, "Middle"] remoteExec ["setUnitPos", _unit]; 
		//_unit setUnitPos "Middle";
		

		[_unit, _disembark_position getPos [40, _disembark_unit_direction]] remoteExec ["lookAt", _unit]; 
		//_unit lookAt (_disembark_position getPos [40, _disembark_unit_direction]);
	
		sleep (3 + random 3);

		_disembark_unit_direction = _disembark_unit_direction + _dir_step;

	} forEach _units;

	//sleep 5;

	[_heli, "Fastrope complete."] spawn SAC_fnc_messageFromUnit;
	hint "Fastrope complete.";

};

SAC_THU_ExecuteSlingload = {

	private ["_callsign", "_vehicle", "_speedMode", "_flyAltitude", "_combatMode", "_behaviourMode", "_pickupPointMarker", "_releasePointMarker", "_wp"];

	_callsign = _this select 0;

	if (_callsign == "A") then {

		_vehicle = SAC_THU_VehicleA;
		_speedMode = SAC_THU_SpeedModeA;
		_flyAltitude = SAC_THU_FlightAltitudeA;
		_combatMode = SAC_THU_CombatModeA;
		_behaviourMode = SAC_THU_BehaviourA;
		_pickupPointMarker = "SAC_THU_PickUpPointA";
		_releasePointMarker = "SAC_THU_ReleasePointA";

	} else {

		_vehicle = SAC_THU_VehicleB;
		_speedMode = SAC_THU_SpeedModeB;
		_flyAltitude = SAC_THU_FlightAltitudeB;
		_combatMode = SAC_THU_CombatModeB;
		_behaviourMode = SAC_THU_BehaviourB;
		_pickupPointMarker = "SAC_THU_PickUpPointB";
		_releasePointMarker = "SAC_THU_ReleasePointB";

	};

	if !(_pickupPointMarker in allMapMarkers) exitWith {hint "Pick up point is not defined."};
	if !(_releasePointMarker in allMapMarkers) exitWith {hint "Release point is not defined."};

	//hasta el 1/5/2020
	deleteWaypoint [group _vehicle, 1];
	//desde el 1/5/2020
/*	[group _vehicle, (currentWaypoint group _vehicle)] setWaypointPosition [getPosASL _vehicle, -1];
	sleep 0.1;
	for "_i" from count waypoints _vehicle - 1 to 0 step -1 do 
	{
		deleteWaypoint [group _vehicle, _i];
	};
*/
	_vehicle setCaptive SAC_THU_HeliCaptive;
	_vehicle land "NONE"; //Cancela una orden de aterrizaje

	switch (typeOf _vehicle) do {

		case "Cha_UH60M_US";
		case "Cha_UH60L_US": {

			{_vehicle animate [_x, 0]} forEach (_vehicle call SAC_fnc_openableDoors);

		};

		case "RHS_CH_47F_light";
		case "RHS_CH_47F_10";
		case "RHS_CH_47F": {

			_vehicle animateSource ["ramp_anim", 0];

		};

		default {

			//{_vehicle animateDoor [_x, 0];} forEach (_vehicle getVariable "SAC_THU_DOORS");
			{_vehicle animateDoor [_x, 0]} forEach (_vehicle call SAC_fnc_openableDoors);

		};

	};

	_wp = (group _vehicle) addWaypoint [getMarkerPos _pickupPointMarker, 0]; _wp setWaypointType "HOOK";
	if (getMarkerPos _pickupPointMarker distance getMarkerPos _releasePointMarker > 300) then {_wp setWaypointSpeed _speedMode} else {_wp setWaypointSpeed "LIMITED"};
	_wp setWaypointCombatMode _combatMode;
	_wp setWaypointBehaviour _behaviourMode;
	_vehicle setBehaviourStrong _behaviourMode;
	if (_callsign == "A") then {
		_wp setWaypointStatements ["true", "[SAC_THU_VehicleA, 'Cargo picked up. Over.'] spawn SAC_fnc_messageFromUnit;"];
	} else {
		_wp setWaypointStatements ["true", "[SAC_THU_VehicleB, 'Cargo picked up. Over.'] spawn SAC_fnc_messageFromUnit;"];
	};

	_wp = (group _vehicle) addWaypoint [getMarkerPos _releasePointMarker, 0]; _wp setWaypointType "UNHOOK";
	if (getMarkerPos _pickupPointMarker distance getMarkerPos _releasePointMarker > 300) then {_wp setWaypointSpeed _speedMode} else {_wp setWaypointSpeed "LIMITED"};
	_wp setWaypointCombatMode _combatMode;
	_wp setWaypointBehaviour _behaviourMode;
	_vehicle setBehaviourStrong _behaviourMode;
	if (_callsign == "A") then {
		_wp setWaypointStatements ["true", "[SAC_THU_VehicleA, 'Cargo released at destination. Over.'] spawn SAC_fnc_messageFromUnit;"];
	} else {
		_wp setWaypointStatements ["true", "[SAC_THU_VehicleB, 'Cargo released at destination. Over.'] spawn SAC_fnc_messageFromUnit;"];
	};

	_vehicle flyInHeight _flyAltitude;

};

SAC_THU_FlyToDestination = {

	private ["_callsign", "_destinationMarker", "_ingressType", "_action", "_egressType", "_route", "_vehicle", "_speedMode", "_flyAltitude", "_combatMode",
	"_behaviourMode", "_waitFlyAltitude", "_crewUnits", "_abortMission", "_initialPos", "_count", "_destination", "_heliH", "_dir", "_marker", "_posHelipad",
	"_distance", "_altitude", "_smoked", "_useSmoke", "_smoke1", "_smoke2", "_correctionVel", "_correctionVelZ", "_currentPos", "_xVelAdjust", "_yVelAdjust",
	"_zVel", "_zVelAdjust", "_pointAhead", "_distanceToNextWP", "_baseMarker", "_turnDistance"];


	_callsign = _this select 0;
	_destinationMarker = _this select 1;
	_ingressType = _this select 2;
	_action = _this select 3;
	_egressType = _this select 4;

	if !(_destinationMarker in allMapMarkers) exitWith {hint "Destination is not defined."};

	if (_callsign == "A") then {
		_vehicle = SAC_THU_VehicleA;
		_speedMode = SAC_THU_SpeedModeA;
		_flyAltitude = SAC_THU_FlightAltitudeA;
		_combatMode = SAC_THU_CombatModeA;
		_behaviourMode = SAC_THU_BehaviourA;
		SAC_THU_TerminateCurrentMissionA = false;
		_waitFlyAltitude = SAC_THU_WaitFlightAltitudeA;
		_baseMarker = SAC_THU_HelipadAMarkerName;
		_turnDistance = SAC_THU_TurnDistanceA;
	} else {
		_vehicle = SAC_THU_VehicleB;
		_speedMode = SAC_THU_SpeedModeB;
		_flyAltitude = SAC_THU_FlightAltitudeB;
		_combatMode = SAC_THU_CombatModeB;
		_behaviourMode = SAC_THU_BehaviourB;
		SAC_THU_TerminateCurrentMissionB = false;
		_waitFlyAltitude = SAC_THU_WaitFlightAltitudeB;
		_baseMarker = SAC_THU_HelipadBMarkerName;
		_turnDistance = SAC_THU_TurnDistanceB;
	};
	
	

	// _vehicle sideChat "Copy, on the way, over...";
	// "radiochatter_us_18" call SAC_fnc_playSound;


	//hasta el 1/5/2020
	deleteWaypoint [group _vehicle, 1];
	//desde el 1/5/2020
/*	[group _vehicle, (currentWaypoint group _vehicle)] setWaypointPosition [getPosASL _vehicle, -1];
	sleep 0.1;
	for "_i" from count waypoints _vehicle - 1 to 0 step -1 do 
	{
		deleteWaypoint [group _vehicle, _i];
	};*/

	_crewUnits = units group driver _vehicle;
/*
	if (!isEngineOn _vehicle) then {
		driver _vehicle action ["engineOn", _vehicle];
	};
*/
	_vehicle setCaptive SAC_THU_HeliCaptive;
	_vehicle land "NONE"; //Cancela una orden de aterrizaje

	switch (typeOf _vehicle) do {

		case "Cha_UH60M_US";
		case "Cha_UH60L_US": {

			{_vehicle animate [_x, 0]} forEach (_vehicle call SAC_fnc_openableDoors);

		};

		case "RHS_CH_47F_light";
		case "RHS_CH_47F_10";
		case "RHS_CH_47F": {

			_vehicle animateSource ["ramp_anim", 0];

		};

		default {

			//{_vehicle animateDoor [_x, 0];} forEach (_vehicle getVariable "SAC_THU_DOORS");
			{_vehicle animateDoor [_x, 0]} forEach (_vehicle call SAC_fnc_openableDoors);

		};

	};

	_abortMission = false;
	if (_ingressType == "RUTA") then {
	
		if (_callsign == "A") then {
		
			switch (_destinationMarker) do
			{
				case SAC_THU_HelipadAMarkerName: {
					_route = SAC_THU_ExfilRouteA;
				};
				default {
					_route = SAC_THU_RouteA;
				};
			};
			
		} else {
		
			switch (_destinationMarker) do
			{
				case SAC_THU_HelipadBMarkerName: {
					_route = SAC_THU_ExfilRouteB;
				};
				default {
					_route = SAC_THU_RouteB;
				};
			};
		
		};

		if ((count _route) == 0) exitWith {
			hint "There is no route.";
			_abortMission = true;
		};

		//Este bucle lleva al helic�ptero hasta el �ltimo waypoint, inclu�do desde la �ltima revisi�n.
		for "_count" from 0 to ((count _route) - 1) do {

			_initialPos = getPos _vehicle;

			_destination = _route select _count;

			_distanceToNextWP = _initialPos distance _destination;

			//Calcula un waypoint 600 mts. pasando el verdadero waypoint, en la direccion de vuelo desde el ultimo waypoint y el actual.

			_pointAhead = _initialPos getPos [_distanceToNextWP + 750, _initialPos getDir _destination];

			//[_pointAhead, "ColorBlue", ""] call SAC_fnc_createMarker;



			/*
			_heliH = createVehicle ["Land_HelipadEmpty_F", _destination, [], 0, "CAN_COLLIDE"];
			_dir = ((_destination select 0) - (_initialPos select 0)) atan2 ((_destination select 1) - (_initialPos select 1));
			_heliH setDir _dir;
			_destination = _heliH modelToWorld [0,600,0];
			*/

			_vehicle doMove _pointAhead;
			_vehicle flyInHeight _flyAltitude;
			_vehicle setSpeedMode _speedMode;
			_vehicle setCombatMode _combatMode;
			_vehicle setBehaviourStrong _behaviourMode;
			sleep 1;
			////////////////////////////////////////////////////////////////////////
			/*
			_posHelipad = [position _heliH select 0, position _heliH select 1, 0];
			*/

			if (_callsign == "A") then {
				
				//waitUntil {((_vehicle distance _destination < SAC_THU_TurnDistanceA) || {_vehicle distance _initialPos > _distanceToNextWP - SAC_THU_TurnDistanceA} || {unitReady _vehicle}) || (!canMove _vehicle) || (SAC_THU_TerminateCurrentMissionA)};
				
				
				waitUntil {(_vehicle distance _destination < _turnDistance) || {_vehicle distance _initialPos > _distanceToNextWP - _turnDistance} || {unitReady _vehicle} || {!canMove _vehicle} || {SAC_THU_TerminateCurrentMissionA}};
				
				_abortMission = SAC_THU_TerminateCurrentMissionA;
				
			} else {
			
				waitUntil {(_vehicle distance _destination < _turnDistance) || {_vehicle distance _initialPos > _distanceToNextWP - _turnDistance} || {unitReady _vehicle} || {!canMove _vehicle} || {SAC_THU_TerminateCurrentMissionB}};
				
				_abortMission = SAC_THU_TerminateCurrentMissionB;
				
			};

			if (_abortMission || {!canMove _vehicle}) exitWith {};

			[_vehicle, format ["Waypoint %1 reached.", _count + 1]] spawn SAC_fnc_messageFromUnit;
			hint format ["Waypoint %1 reached.", _count + 1];

		}; //Termina el for

	};

	_destination = getmarkerpos _destinationMarker;

	if (_abortMission || (!canMove _vehicle)) exitWith {};

	_distance = _destination distance position _vehicle;
	_vehicle doMove _destination;
	
	
	
	
/*	
	private ["_wp"];

	_wp = group _vehicle addWaypoint [[_destination select 0, _destination select 1, _flyAltitude], 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed _speedMode;
	_wp setWaypointBehaviour _behaviourMode; //en careless los ah-64 no atacan con los misiles a los tanques
	//por el contrario, en aware/combat no respetan volvar en circulos ni la altitud, y erran los misiles mucho
	//conclusión: no usar chopos contra tanques usando THU
	_wp setWaypointCombatMode _combatMode;
*/	
	
	
	
	
	if (_distance < 300) then {  //**********EXPERIMENTAL************
		_vehicle setSpeedMode "LIMITED";
		_altitude = (getPos _vehicle) select 2;
		if (_altitude < 20) then {_vehicle flyInHeight _flyAltitude};
	} else {
		_vehicle setSpeedMode _speedMode;
		_vehicle flyInHeight _flyAltitude;
	};
	_vehicle setCombatMode _combatMode;
	_vehicle setBehaviourStrong _behaviourMode;
	sleep 1;
	////////////////////////////////////////////////////////////////////////

	//La subida abrupta del helic�ptero no se produce a los 200 mts. del destino cuando se le ordena aterrizar, sino a aprox. +700 mts (dependiendo de la vel.),
	//cuando el piloto determina que tiene que bajar la velocidad para llegar al punto del objetivo con vel. cero.

	//SAC_THU_VehicleA setSpeedMode "LIMITED";

	switch (true) do
	{

		case (_action == "LAND" || _action == "INSERT"): {
			if (_callsign == "A") then {
				SAC_THU_TempHelipadA = createVehicle ["Land_HelipadEmpty_F", _destination, [], 0, "CAN_COLLIDE"];
				SAC_THU_TempHelipadA setVehiclePosition [[_destination select 0, _destination select 1, 100], [], 0, "CAN_COLLIDE"];//23/03/2018 land on carrier fix
				//waitUntil {(_vehicle distance [_destination select 0, _destination select 1, _flyAltitude] < 200) || (!canMove _vehicle) || (SAC_THU_TerminateCurrentMissionA)};
				waitUntil {(_vehicle distance2D _destination < 200) || {!canMove _vehicle} || {SAC_THU_TerminateCurrentMissionA}};
				_abortMission = SAC_THU_TerminateCurrentMissionA;
			} else {
			
				SAC_THU_TempHelipadB = createVehicle ["Land_HelipadEmpty_F", _destination, [], 0, "CAN_COLLIDE"];
				SAC_THU_TempHelipadB setVehiclePosition [[_destination select 0, _destination select 1, 100], [], 0, "CAN_COLLIDE"];//23/03/2018 land on carrier fix
				waitUntil {(_vehicle distance2D _destination < 200) || {!canMove _vehicle} || {SAC_THU_TerminateCurrentMissionB}};
				_abortMission = SAC_THU_TerminateCurrentMissionB;
				
			};
		};

		case (_action == "WAIT"): {
			if (_callsign == "A") then {
				
				//waitUntil {(unitReady _vehicle) || (!canMove _vehicle) || (SAC_THU_TerminateCurrentMissionA)};
				waitUntil {(unitReady _vehicle) || {!canMove _vehicle} || {SAC_THU_TerminateCurrentMissionA}};
				waitUntil {((speed _vehicle < 5) && {getPos _vehicle select 2 >= 20}) || (!canMove _vehicle) || (SAC_THU_TerminateCurrentMissionA)};
				_abortMission = SAC_THU_TerminateCurrentMissionA;
				
			} else {
				
				waitUntil {(unitReady _vehicle) || {!canMove _vehicle} || {SAC_THU_TerminateCurrentMissionB}};
				waitUntil {((speed _vehicle < 5) && {getPos _vehicle select 2 >= 20}) || (!canMove _vehicle) || (SAC_THU_TerminateCurrentMissionB)};
				_abortMission = SAC_THU_TerminateCurrentMissionB;
				
			};
		};
	};

	if (_abortMission || (!canMove _vehicle)) exitWith {};

	switch (true) do
	{
		case (_action == "LAND" || _action == "INSERT"): {
		
			if (vehicle player != _vehicle) then {"sac_sounds_cas_engaging1" spawn SAC_fnc_playSound};
			[driver _vehicle, "sac_sounds_cas_engaging1", 100] spawn SAC_fnc_netSay3D;
			_vehicle sideChat "Papa Bear, Golf Two, aproaching objective, over.";
			
			_vehicle land "GET IN";
			//_vehicle land "LAND";
			_smoked = false;
			waitUntil {
				if (_callsign == "A") then {_useSmoke = SAC_THU_UseSmokeA} else {_useSmoke = SAC_THU_UseSmokeB};
				if ((!_smoked) && (_useSmoke)) then {
					if (getPos _vehicle select 2 < 15) then {
						if (_destinationMarker != _baseMarker) then {
							//_smoke1 = "G_40mm_SmokeBlue" createVehicle getPos _vehicle;
							_smoke1 = "SmokeShellBlue" createVehicle getPos _vehicle;
							//"SmokeShellBlue"
							//"SmokeLauncherAmmo"
							//"Smoke_82mm_AMOS_White"
							_smoke1 setVelocity [3 + random 2, 3 + random 2, 0];

							_smoke2 = "SmokeShellBlue" createVehicle getPos _vehicle;
							_smoke2 setVelocity [-3 - random 2, -3 - random 2, 0];
						};
					_smoked = true;
					};
				};
				if (_callsign == "A") then {_abortMission = SAC_THU_TerminateCurrentMissionA} else {_abortMission = SAC_THU_TerminateCurrentMissionB};
				(unitReady _vehicle) || {!canMove _vehicle} || {_abortMission}
			};
			if ((canMove _vehicle) && {!_abortMission}) then {_vehicle setCombatMode "BLUE"};
		};

	};

	if (_abortMission || (!canMove _vehicle)) exitWith {};

	switch (true) do
	{
		case (_action == "LAND"): {
			_vehicle flyInHeight 0;
			_vehicle setCaptive false;

			if (_callsign == "A") then {
				waitUntil {((getPos _vehicle) select 2 <= 1) || {SAC_THU_TerminateCurrentMissionA}}; //Muchas veces el helic�ptero da por completada la �rden antes de tocar el suelo, con esto
				//trato de que las unidades no sean expulsadas antes de tiempo. EXPERIMENTAL.
				if (!SAC_THU_TerminateCurrentMissionA) then {

					switch (typeOf _vehicle) do {

						case "Cha_UH60M_US";
						case "Cha_UH60L_US": {

							{_vehicle animate [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

						};

						case "RHS_CH_47F_light";
						case "RHS_CH_47F_10";
						case "RHS_CH_47F": {

							_vehicle animateSource ["ramp_anim", 1];

						};

						default {

							{_vehicle animateDoor [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

						};

					};

					[_vehicle, "Landed at destination. Over."] spawn SAC_fnc_messageFromUnit;
					hint "The helicopter has landed at the designated LZ.";
					if (count (_vehicle call SAC_fnc_unitsInCargo) > 0) then {
					
						[driver _vehicle, "sac_sounds_getout0", 100] spawn SAC_fnc_netSay3D;
						
					};


				};
			} else {
				waitUntil {((getPos _vehicle) select 2 <= 1) || {SAC_THU_TerminateCurrentMissionB}}; //Muchas veces el helic�ptero da por completada la �rden antes de tocar el suelo, con esto
				//trato de que las unidades no sean expulsadas antes de tiempo. EXPERIMENTAL.
				if (!SAC_THU_TerminateCurrentMissionB) then {

					switch (typeOf _vehicle) do {

						case "Cha_UH60M_US";
						case "Cha_UH60L_US": {

							{_vehicle animate [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

						};

						case "RHS_CH_47F_light";
						case "RHS_CH_47F_10";
						case "RHS_CH_47F": {

							_vehicle animateSource ["ramp_anim", 1];

						};

						default {

							{_vehicle animateDoor [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

						};

					};

					[_vehicle, "Landed at destination. Over."] spawn SAC_fnc_messageFromUnit;
					hint "The helicopter has landed at the designated LZ.";
					if (count (_vehicle call SAC_fnc_unitsInCargo) > 0) then {
					
						[driver _vehicle, "sac_sounds_getout0", 100] spawn SAC_fnc_netSay3D;
						
					};
				};
			};

			_abortMission = true;
		};
		case (_action == "INSERT"): {
			_vehicle flyInHeight 0;
			_vehicle setCaptive false;

			if (_callsign == "A") then {
				//Muchas veces el helicóptero da por completada la órden antes de tocar el suelo, con esto
				//trato de que las unidades no sean expulsadas antes de tiempo. EXPERIMENTAL.
				waitUntil {((getPos _vehicle) select 2 <= 1) || {SAC_THU_TerminateCurrentMissionA}};
				
				//5/10/2019 Creo que hay otra forma de hacerlo y es más rápida. Dejo el código este porque es el que funcionó durante años.
				/*
				private ["_clearedUnits"];
				_clearedUnits = [];
				{

					if !(_x in _crewUnits) then {_clearedUnits pushBack _x};

				} forEach crew _vehicle;
				*/
				private _clearedUnits = (crew _vehicle) - _crewUnits;
				
				
				if (!SAC_THU_TerminateCurrentMissionA) then {

					switch (typeOf _vehicle) do {

						case "Cha_UH60M_US";
						case "Cha_UH60L_US": {

							{_vehicle animate [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

						};

						case "RHS_CH_47F_light";
						case "RHS_CH_47F_10";
						case "RHS_CH_47F": {

							_vehicle animateSource ["ramp_anim", 1];

						};

						default {

							{_vehicle animateDoor [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

						};

					};

					[_vehicle, "Landed at destination. Over."] spawn SAC_fnc_messageFromUnit;
					hint "The helicopter has landed at the designated LZ.";
					if (count (_vehicle call SAC_fnc_unitsInCargo) > 0) then {
					
						[driver _vehicle, "sac_sounds_getout0", 100] spawn SAC_fnc_netSay3D;
						
					};
				};
				sleep 2;

				if (count _clearedUnits > 0) then {

					[_clearedUnits, _vehicle] call SAC_fnc_tacticalDisembark;

					waitUntil {(_clearedUnits findIf {!isNull objectParent _x} == -1) || {SAC_THU_TerminateCurrentMissionA}};

					sleep 2;
				};

				_abortMission = SAC_THU_TerminateCurrentMissionA;
			} else {
				waitUntil {((getPos _vehicle) select 2 <= 1) || {SAC_THU_TerminateCurrentMissionB}}; //Muchas veces el helic�ptero da por completada la �rden antes de tocar el suelo, con esto
				//trato de que las unidades no sean expulsadas antes de tiempo. EXPERIMENTAL.
				if (!SAC_THU_TerminateCurrentMissionB) then {

					switch (typeOf _vehicle) do {

						case "Cha_UH60M_US";
						case "Cha_UH60L_US": {

							{_vehicle animate [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

						};

						case "RHS_CH_47F_light";
						case "RHS_CH_47F_10";
						case "RHS_CH_47F": {

							_vehicle animateSource ["ramp_anim", 1];

						};

						default {

							{_vehicle animateDoor [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

						};

					};

					[_vehicle, "Landed at destination. Over."] spawn SAC_fnc_messageFromUnit;
					hint "The helicopter has landed at the designated LZ.";
					if (count (_vehicle call SAC_fnc_unitsInCargo) > 0) then {
					
						[driver _vehicle, "sac_sounds_getout0", 100] spawn SAC_fnc_netSay3D;
						
					};
				};
				sleep 2;
				private ["_clearedUnits"];
				_clearedUnits = [];
				{

					if !(_x in _crewUnits) then {_clearedUnits pushBack _x};

				} forEach crew _vehicle;

				if (count _clearedUnits > 0) then {

					[_clearedUnits, _vehicle] call SAC_fnc_tacticalDisembark;

					waitUntil {(_clearedUnits findIf {!isNull objectParent _x} == -1) || {SAC_THU_TerminateCurrentMissionB}};

					sleep 2;
				};

				_abortMission = SAC_THU_TerminateCurrentMissionB;
			};
		};
		case (_action == "WAIT"): {

			if (getPosATL _vehicle select 2 >= 20) then {

				_vehicle setPos [_destination select 0, _destination select 1, getPos _vehicle select 2];
				//_vehicle setPos [_destination select 0, _destination select 1];
				
				_vehicle flyInHeight _waitFlyAltitude;
				_vehicle move getPos _vehicle;

			};

			//[_vehicle, "Waiting at destination. Over."] spawn SAC_fnc_messageFromUnit;
			//hint "The helicopter has reached the designated waiting point.";
			
			if (vehicle player != _vehicle) then {"sac_sounds_waiting" spawn SAC_fnc_playSound};
			[driver _vehicle, "sac_sounds_waiting", 100] spawn SAC_fnc_netSay3D;
			_vehicle sideChat "Echo One to Crossroads, we're in position, over.";


			_abortMission = true;
		};
	};

	if (_abortMission || (!canMove _vehicle)) exitWith {};

	switch (true) do
	{
		case (_egressType == "DIRECTO"): {
			if (_callsign == "A") then {
				SAC_THU_TerminateCurrentMissionA = true;
				deleteVehicle SAC_THU_TempHelipadA;
				[_callsign, SAC_THU_HelipadAMarkerName, "DIRECTO", "LAND", ""] spawn SAC_THU_FlyToDestination;
			} else {
				SAC_THU_TerminateCurrentMissionB = true;
				deleteVehicle SAC_THU_TempHelipadB;
				[_callsign, SAC_THU_HelipadAMarkerName, "DIRECTO", "LAND", ""] spawn SAC_THU_FlyToDestination;
			};
		};
		case (_egressType == "WAIT"): {
			if (_callsign == "A") then {
				SAC_THU_TerminateCurrentMissionA = true;
				deleteVehicle SAC_THU_TempHelipadA;
				[_callsign, "SAC_THU_WaitingPointA", "DIRECTO", "WAIT", ""] spawn SAC_THU_FlyToDestination;
			} else {
				SAC_THU_TerminateCurrentMissionB = true;
				deleteVehicle SAC_THU_TempHelipadB;
				[_callsign, "SAC_THU_WaitingPointB", "DIRECTO", "WAIT", ""] spawn SAC_THU_FlyToDestination;
			};
		};
		case (_egressType == "RUTA"): {
			if (_callsign == "A") then {
				SAC_THU_TerminateCurrentMissionA = true;
				deleteVehicle SAC_THU_TempHelipadA;
				[_callsign, SAC_THU_HelipadAMarkerName, "RUTA", "LAND", ""] spawn SAC_THU_FlyToDestination;
			} else {
				SAC_THU_TerminateCurrentMissionB = true;
				deleteVehicle SAC_THU_TempHelipadB;
				[_callsign, SAC_THU_HelipadAMarkerName, "RUTA", "LAND", ""] spawn SAC_THU_FlyToDestination;
			};
		};
	};

};

SAC_THU_CreateHelicopter = {

	private ["_callsign", "_helicopterType", "_side", "_helipad", "_helipadDir", "_ready", "_crewGroup", "_mapName",
	"_heliClass", "_gunnerCount", "_combatMode", "_turnDistance", "_vehicle", "_pilot", "_count", "_gunner", "_capacity",
	"_script", "_engineOFFwhenOutOfBase"];

	_callsign = _this select 0;
	_helicopterType = _this select 1;

	if (_callsign == "A") then {
		_helipad = SAC_THU_HelipadAPos;
		_helipadDir = SAC_THU_HelipadADir;
		_engineOFFwhenOutOfBase = SAC_THU_EngineOFFWhenOutOfBaseA;
	} else {
		_helipad = SAC_THU_HelipadBPos;
		_helipadDir = SAC_THU_HelipadBDir;
		_engineOFFwhenOutOfBase = SAC_THU_EngineOFFWhenOutOfBaseB;
	};

	//_mapName = getText (configFile >> "CfgWorlds" >> worldName >> "description");

	_script = "";

	switch (_helicopterType) do {

		case "WY-55 Hellcat": {

			switch (faction player) do {

				case "OPF_F": {_heliClass = "I_Heli_light_03_F"};
				case "OPF_G_F": {_heliClass = "I_Heli_light_03_unarmed_F"};
				case "BLU_F": {_heliClass = "I_Heli_light_03_F"};
				case "BLU_G_F": {_heliClass = "I_Heli_light_03_unarmed_F"};
				case "IND_F": {_heliClass = "I_Heli_light_03_F"};
				case "IND_G_F": {_heliClass = "I_Heli_light_03_unarmed_F"};
				case "CIV_F": {_heliClass = "I_Heli_light_03_unarmed_F"};
				case "rhsgref_faction_cdf_ground": {_heliClass = "I_Heli_light_03_F"};
				default {_heliClass = "I_Heli_light_03_F"};
			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};

		case "CH-49 Mohawk": {
			_heliClass = "I_Heli_Transport_02_F";
			_combatMode = "BLUE";
			_turnDistance = 270;
			_capacity = "HEAVY";
		};

		case "MH-9 Hummingbird": {

			switch (faction player) do {

				case "OPF_F": {_heliClass = "B_Heli_Light_01_F"};
				case "OPF_G_F": {_heliClass = "C_Heli_light_01_blue_F"};
				case "BLU_F": {_heliClass = "B_Heli_Light_01_F"};
				case "BLU_G_F": {_heliClass = "C_Heli_light_01_blue_F"};
				case "IND_F": {_heliClass = "B_Heli_Light_01_F"};
				case "IND_G_F": {_heliClass = "C_Heli_light_01_blue_F"};
				case "CIV_F": {_heliClass = "C_Heli_light_01_blue_F"};
				case "rhsgref_faction_cdf_ground": {_heliClass = "B_Heli_Light_01_F"};
				default {_heliClass = "B_Heli_Light_01_F"};
			};

			_combatMode = "BLUE";
			_turnDistance = 150;
			_capacity = "LIGHT";
		};

		case "UH-80 GhostHawk": {

			switch (faction player) do {

				case "OPF_F": {_heliClass = "B_Heli_Transport_01_F"};
				case "OPF_G_F": {_heliClass = "B_Heli_Transport_01_F"};
				case "BLU_F": {_heliClass = "B_Heli_Transport_01_camo_F"};
				case "BLU_G_F": {_heliClass = "B_Heli_Transport_01_F"};
				case "IND_F": {_heliClass = "B_Heli_Transport_01_F"};
				case "IND_G_F": {_heliClass = "B_Heli_Transport_01_F"};
				case "CIV_F": {_heliClass = "B_Heli_Transport_01_F"};
				case "rhsgref_faction_cdf_ground": {_heliClass = "B_Heli_Transport_01_F"};
				default {_heliClass = "B_Heli_Transport_01_camo_F"};
			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";

		};

		case "CH-67 Huron": {

			switch (faction player) do {

				case "OPF_F": {_heliClass = "B_Heli_Transport_03_black_F"};
				case "OPF_G_F": {_heliClass = "B_Heli_Transport_03_unarmed_F"};
				case "BLU_F": {_heliClass = "B_Heli_Transport_03_F"};
				case "BLU_G_F": {_heliClass = "B_Heli_Transport_03_unarmed_green_F"};
				case "IND_F": {_heliClass = "B_Heli_Transport_03_unarmed_green_F"};
				case "IND_G_F": {_heliClass = "B_Heli_Transport_03_unarmed_F"};
				case "CIV_F": {_heliClass = "B_Heli_Transport_03_unarmed_F"};
				case "rhsgref_faction_cdf_ground": {_heliClass = "B_Heli_Transport_03_F"};
				default {_heliClass = "B_Heli_Transport_03_F"};
			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "HEAVY";
		};

		case "Mi-290 Skycrane": {

			switch (faction player) do {

				case "OPF_F": {_heliClass = "O_Heli_Transport_04_F"};
				case "OPF_G_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_basic_black.sqf"; _heliClass = "O_Heli_Transport_04_black_F"};
				case "BLU_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_basic_black.sqf"; _heliClass = "O_Heli_Transport_04_black_F"};
				case "BLU_G_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_basic_black.sqf"; _heliClass = "O_Heli_Transport_04_black_F"};
				case "IND_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_basic_black.sqf"; _heliClass = "O_Heli_Transport_04_black_F"};
				case "IND_G_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_basic_black.sqf"; _heliClass = "O_Heli_Transport_04_black_F"};
				case "CIV_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_basic_black.sqf"; _heliClass = "O_Heli_Transport_04_black_F"};
				case "rhsgref_faction_cdf_ground": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_basic_black.sqf"; _heliClass = "O_Heli_Transport_04_black_F"};
				default {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_basic_black.sqf"; _heliClass = "O_Heli_Transport_04_black_F"};
			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "HEAVY";

		};

		case "Mi-290 Transport": {

			switch (faction player) do {

				case "OPF_F": {_heliClass = "O_Heli_Transport_04_covered_F"};
				case "OPF_G_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_pods_black.sqf"; _heliClass = "O_Heli_Transport_04_covered_black_F"};
				case "BLU_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_pods_black.sqf"; _heliClass = "O_Heli_Transport_04_covered_black_F"};
				case "BLU_G_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_pods_black.sqf"; _heliClass = "O_Heli_Transport_04_covered_black_F"};
				case "IND_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_pods_black.sqf"; _heliClass = "O_Heli_Transport_04_covered_black_F"};
				case "IND_G_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_pods_black.sqf"; _heliClass = "O_Heli_Transport_04_covered_black_F"};
				case "CIV_F": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_pods_black.sqf"; _heliClass = "O_Heli_Transport_04_covered_black_F"};
				case "rhsgref_faction_cdf_ground": {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_pods_black.sqf"; _heliClass = "O_Heli_Transport_04_covered_black_F"};
				default {_script = "\a3\Air_F_Heli\Heli_Transport_04\Scripts\Heli_Transport_04_pods_black.sqf"; _heliClass = "O_Heli_Transport_04_covered_black_F"};
			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "HEAVY";

		};

		case "PO-30 Orca": {

			switch (faction player) do {

				case "OPF_F": {_heliClass = "O_Heli_Light_02_F"};
				case "OPF_G_F": {_heliClass = "O_Heli_Light_02_unarmed_F"};
				case "BLU_F": {_heliClass = "O_Heli_Light_02_unarmed_F"};
				case "BLU_G_F": {_heliClass = "O_Heli_Light_02_unarmed_F"};
				case "IND_F": {_heliClass = "O_Heli_Light_02_unarmed_F"};
				case "IND_G_F": {_heliClass = "O_Heli_Light_02_unarmed_F"};
				case "CIV_F": {_heliClass = "O_Heli_Light_02_unarmed_F"};
				case "rhsgref_faction_cdf_ground": {_heliClass = "O_Heli_Light_02_unarmed_F"};
				default {_heliClass = "O_Heli_Light_02_unarmed_F"};
			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};

		case "Mi-48 Kajman": {

			switch (faction player) do {

				case "OPF_F": {_heliClass = "O_Heli_Attack_02_F"};
				case "OPF_G_F": {_heliClass = "O_Heli_Attack_02_F"};
				case "BLU_F": {_heliClass = "O_Heli_Attack_02_F"};
				case "BLU_G_F": {_heliClass = "O_Heli_Attack_02_F"};
				case "IND_F": {_heliClass = "O_Heli_Attack_02_F"};
				case "IND_G_F": {_heliClass = "O_Heli_Attack_02_F"};
				case "CIV_F": {_heliClass = "O_Heli_Attack_02_F"};
				case "rhsgref_faction_cdf_ground": {_heliClass = "O_Heli_Attack_02_F"};
				default {_heliClass = "O_Heli_Attack_02_F"};
			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};

		case "AH-99 Blackfoot": {

			_heliClass = "B_Heli_Attack_01_F";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "LIGHT";
		};

		case "CH-47F": {

			_heliClass = "RHS_CH_47F";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "HEAVY";

		};
/*
		case "CH-47F CUP": {

			_heliClass = "CUP_B_CH47F_USA";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "HEAVY";

		};*/
/*
		case "CH-53E": {

			_heliClass = "CUP_B_CH53E_USMC";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "HEAVY";

		};
*/
		case "MI8-MT": {

			switch (toLower(worldName)) do
			{

				case "beketov";
				case "eden";
				case "chernarus_winter": {_heliClass = "RHS_Mi8mt_vvs"};
				case "chernarus_summer";
				case "ruha";
				case "chernarus": {_heliClass = "RHS_Mi8mt_vdv"};
				case "woodland_acr": {_heliClass = "RHS_Mi8mt_vdv"};//Bystrica
				case "fallujah": {_heliClass = "RHS_Mi8mt_vvsc"};
				case "zargabad": {_heliClass = "RHS_Mi8mt_vvsc"};
				case "mcm_aliabad": {_heliClass = "RHS_Mi8mt_vvsc"};
				case "fata": {_heliClass = "RHS_Mi8mt_vdv"};
				case "praa_av": {_heliClass = "RHS_Mi8mt_vvsc"};//afghan village
				case "kunduz": {_heliClass = "RHS_Mi8mt_vvsc"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "kidal";
				case "tem_anizay";
				case "takistan": {_heliClass = "RHS_Mi8mt_vvsc"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_heliClass = "RHS_Mi8mt_vdv"};
				case "tembelan";
				case "malden";
				case "altis": {_heliClass = "RHS_Mi8mt_vvs"};
				case "bornholm": {_heliClass = "RHS_Mi8mt_vdv"};
				case "isladuala3": {_heliClass = "RHS_Mi8mt_vv"};
				case "panthera3": {_heliClass = "RHS_Mi8mt_vdv"};
				case "pja305": {_heliClass = "RHS_Mi8mt_vv"};//Nziwasogo
				case default {_heliClass = "RHS_Mi8mt_vv"};

			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "HEAVY";

		};
		
		case "MI8-MTV-3": { //rockets

			switch (toLower(worldName)) do
			{

				case "beketov";
				case "eden";
				case "chernarus_winter": {_heliClass = "RHS_Mi8MTV3_vvs"};
				case "chernarus_summer";
				case "chernarus": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "woodland_acr": {_heliClass = "RHS_Mi8MTV3_vvsc"};//Bystrica
				case "fallujah": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "zargabad": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "mcm_aliabad": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "fata": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "praa_av": {_heliClass = "RHS_Mi8MTV3_vvsc"};//afghan village
				case "kunduz": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "kidal";
				case "tem_anizay";
				case "takistan": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "tembelan";
				case "malden";
				case "altis": {_heliClass = "RHS_Mi8MTV3_vvs"};
				case "bornholm": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "isladuala3": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "panthera3": {_heliClass = "RHS_Mi8MTV3_vvsc"};
				case "pja305": {_heliClass = "RHS_Mi8MTV3_vvsc"};//Nziwasogo
				case default {_heliClass = "RHS_Mi8MTV3_vvsc"};

			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "HEAVY";

		};
		
		case "Mi-24V": {

			switch (toLower(worldName)) do
			{

				case "beketov";
				case "eden";
				case "chernarus_winter": {_heliClass = "RHS_Mi24V_vvs"};
				case "chernarus_summer";
				case "chernarus": {_heliClass = "RHS_Mi24V_vvsc"};
				case "woodland_acr": {_heliClass = "RHS_Mi24V_vvsc"};//Bystrica
				case "fallujah": {_heliClass = "RHS_Mi24V_vvsc"};
				case "zargabad": {_heliClass = "RHS_Mi24V_vvsc"};
				case "mcm_aliabad": {_heliClass = "RHS_Mi24V_vvsc"};
				case "fata": {_heliClass = "RHS_Mi24V_vvsc"};
				case "praa_av": {_heliClass = "RHS_Mi24V_vvsc"};//afghan village
				case "kunduz": {_heliClass = "RHS_Mi24V_vvsc"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "kidal";
				case "tem_anizay";
				case "takistan": {_heliClass = "RHS_Mi24V_vvsc"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_heliClass = "RHS_Mi24V_vvsc"};
				case "tembelan";
				case "malden";
				case "altis": {_heliClass = "RHS_Mi24V_vvs"};
				case "bornholm": {_heliClass = "RHS_Mi24V_vvsc"};
				case "isladuala3": {_heliClass = "RHS_Mi24V_vvsc"};
				case "panthera3": {_heliClass = "RHS_Mi24V_vvsc"};
				case "pja305": {_heliClass = "RHS_Mi24V_vvsc"};//Nziwasogo
				case default {_heliClass = "RHS_Mi24V_vvsc"};

			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";

		};
		
		case "Ka-52": {

			switch (toLower(worldName)) do
			{

				case "beketov";
				case "eden";
				case "chernarus_winter": {_heliClass = "RHS_Ka52_vvs"};
				case "chernarus_summer";
				case "chernarus": {_heliClass = "RHS_Ka52_vvsc"};
				case "woodland_acr": {_heliClass = "RHS_Ka52_vvsc"};//Bystrica
				case "fallujah": {_heliClass = "RHS_Ka52_vvsc"};
				case "zargabad": {_heliClass = "RHS_Ka52_vvsc"};
				case "mcm_aliabad": {_heliClass = "RHS_Ka52_vvsc"};
				case "fata": {_heliClass = "RHS_Ka52_vvsc"};
				case "praa_av": {_heliClass = "RHS_Ka52_vvsc"};//afghan village
				case "kunduz": {_heliClass = "RHS_Ka52_vvsc"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "kidal";
				case "tem_anizay";
				case "takistan": {_heliClass = "RHS_Ka52_vvsc"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_heliClass = "RHS_Ka52_vvsc"};
				case "tembelan";
				case "malden";
				case "altis": {_heliClass = "RHS_Ka52_vvs"};
				case "bornholm": {_heliClass = "RHS_Ka52_vvsc"};
				case "isladuala3": {_heliClass = "RHS_Ka52_vvsc"};
				case "panthera3": {_heliClass = "RHS_Ka52_vvsc"};
				case "pja305": {_heliClass = "RHS_Ka52_vvsc"};//Nziwasogo
				case default {_heliClass = "RHS_Ka52_vvsc"};

			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "LIGHT";

		};
		
		case "Mi-28N": {

			switch (toLower(worldName)) do
			{

				case "beketov";
				case "eden";
				case "chernarus_winter": {_heliClass = "rhs_mi28n_vvs"};
				case "chernarus_summer";
				case "chernarus": {_heliClass = "rhs_mi28n_vvsc"};
				case "woodland_acr": {_heliClass = "rhs_mi28n_vvsc"};//Bystrica
				case "fallujah": {_heliClass = "rhs_mi28n_vvsc"};
				case "zargabad": {_heliClass = "rhs_mi28n_vvsc"};
				case "mcm_aliabad": {_heliClass = "rhs_mi28n_vvsc"};
				case "fata": {_heliClass = "rhs_mi28n_vvsc"};
				case "praa_av": {_heliClass = "rhs_mi28n_vvsc"};//afghan village
				case "kunduz": {_heliClass = "rhs_mi28n_vvsc"};
				case "dya"; //Diyala
				case "lythium";
				case "uzbin";
				case "kidal";
				case "tem_anizay";
				case "takistan": {_heliClass = "rhs_mi28n_vvsc"};
				case "smd_sahrani_a3";
				case "sahrani";
				case "sara";
				case "sara_dbe1";
				case "sehreno";
				case "smd_sahrani_a2": {_heliClass = "rhs_mi28n_vvsc"};
				case "tembelan";
				case "malden";
				case "altis": {_heliClass = "rhs_mi28n_vvs"};
				case "bornholm": {_heliClass = "rhs_mi28n_vvsc"};
				case "isladuala3": {_heliClass = "rhs_mi28n_vvsc"};
				case "panthera3": {_heliClass = "rhs_mi28n_vvsc"};
				case "pja305": {_heliClass = "rhs_mi28n_vvsc"};//Nziwasogo
				case default {_heliClass = "rhs_mi28n_vvsc"};

			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "LIGHT";

		};
		
		case "MH6M": {

			_heliClass = "RHS_MELB_MH6M";

			_combatMode = "BLUE";
			_turnDistance = 150;
			_capacity = "LIGHT";
		};

		case "UH-60M": {

			_heliClass = "RHS_UH60M";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};
		
		case "UH-60L": {

			_heliClass = "B_UH60L_F";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};
		
		case "MH-60L": {

			_heliClass = "B_MH60L_noprobe_F";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};
		case "Mi-8 Green (No Flag)": {

			_heliClass = "LOP_SLA_Mi8MT_Cargo";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "HEAVY";
		};
/*
		case "UH-60M CUP": {

			_heliClass = "CUP_B_UH60M_US";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};

		case "UH-60M (FFVCUP)": {

			_heliClass = "CUP_B_UH60M_FFV_US";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};
*/
		case "UH-1Y": {

			_heliClass = "RHS_UH1Y";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};
/*
		case "AH-1Z CUP": {

			_heliClass = "CUP_B_AH1Z";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};
*/
		case "UH-1Y (Unarmed)": {

			_heliClass = "RHS_UH1Y_UNARMED";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};
		
		case "UH-1H": {

			if (isClass(configFile >> "CfgVehicles" >> "UK3CB_CW_US_B_EARLY_UH1H_M240")) then {
			
				_heliClass = "UK3CB_CW_US_B_EARLY_UH1H_M240";
			
			} else {

				_heliClass = "rhs_uh1h_hidf_gunship";
				
			};

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};
		
		case "UH-1H 1st Cav Slick": {

			//_heliClass = "VW_CAV_UH1H_slick_SAS";
			_heliClass = "uns_UH1H_m60";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};

		case "CH-47 1st Cav": {

			_heliClass = "VW_CH47_AC_SAS";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};

		case "UH-1H Gunship": {

			_heliClass = "WV_UH1H_gunship_SAS";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "MEDIUM";
		};

		case "AH-64D (light)": {

			_heliClass = "RHS_AH64D_wd"; //"RHS_AH64D_CS"

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "LIGHT";
		};
		
		case "AH-64D (at)": {

			_heliClass = "RHS_AH64D_CS";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "LIGHT";
		};
		
/*
		case "AH-64D CUP": {

			_heliClass = "CUP_B_AH64D_USA";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "LIGHT";
		};
*/
		case "AH-1Z": {

			_heliClass = "RHS_AH1Z_wd";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "LIGHT";
		};
		
		case "V-44X": {

			_heliClass = "B_T_VTOL_01_armed_F";

			_combatMode = "YELLOW";
			_turnDistance = 270;
			_capacity = "HEAVY";
		};

	};

	private _returnedArray =  [];
	//["_position", "_direction", "_vehicleClasses", "_crewClasses", "_special", "_autoDeleteGroup"]
	_returnedArray = [_helipad, _helipadDir, [_heliClass], [SAC_THU_PilotClass], "CAN_COLLIDE", false] call SAC_fnc_spawnVehicle;
	_vehicle = _returnedArray select 0;
	_crewGroup = _returnedArray select 1;
	
	//intento que el mod VcomAI no afecte a estas unidades
	_crewGroup setVariable ["Vcm_Disable", true];
	(group _vehicle) setVariable ["Vcm_Disable", true];
/*
	_crewGroup setVariable ["lambs_danger_disableGroupAI", true];
	(group _vehicle) setVariable ["lambs_danger_disableGroupAI", true];
	
	{_x setVariable ["lambs_danger_disableAI", true]} forEach units _crewGroup;
*/

	{_x setSkill 1} forEach units _crewGroup;

	driver _vehicle setUnitTrait ["Medic", true];	
	
	_vehicle setCaptive SAC_THU_HeliCaptive;
	[_vehicle, _callsign, _engineOFFwhenOutOfBase] spawn SAC_THU_HeliAI;
	//[_vehicle, _callsign] spawn SAC_THU_climbProtection;

	_vehicle setVariable ["SAC_THU_cargo_capacity", _capacity, true];
	_vehicle setVariable ["SAC_SPK_hasSpeakers", true, true];
	
	_vehicle lockDriver true;
	[_vehicle] call SAC_fnc_lockOccupiedTurrets;
	
	{_x disableAI "RADIOPROTOCOL"} forEach units _crewGroup;

	if (_callsign == "A") then {
		SAC_THU_VehicleA = _vehicle;
		SAC_THU_HelicopterReadyA = true;
		SAC_THU_CombatModeA = _combatMode;
		SAC_THU_TurnDistanceA = _turnDistance;
		SAC_THU_VehicleAName = _helicopterType;
		_crewGroup setGroupId [SAC_THU_VehicleACallsign];
	} else {
		SAC_THU_VehicleB = _vehicle;
		SAC_THU_HelicopterReadyB = true;
		SAC_THU_CombatModeB = _combatMode;
		SAC_THU_TurnDistanceB = _turnDistance;
		SAC_THU_VehicleBName = _helicopterType;
		_crewGroup setGroupId [SAC_THU_VehicleBCallsign];
	};

	//{_x disableAI "AUTOCOMBAT"} forEach units _crewGroup;

	if (SAC_trackerColor == "") then {
	
		SAC_trackerColor = SAC_markers_color_pool select 0;
		SAC_markers_color_pool = SAC_markers_color_pool - [SAC_trackerColor];
		publicVariable "SAC_markers_color_pool";
	
	};


	[_vehicle, _callsign] spawn SAC_THU_fnc_tracker;

	//no hace falta más el script que los retexturiza porque lo hago yo
	//if (_script != "") then {[_vehicle] execVM _script};

	switch (typeOf _vehicle) do {

		case "Cha_UH60M_US";
		case "Cha_UH60L_US": {

			{_vehicle animate [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

		};

		case "RHS_CH_47F_light";
		case "RHS_CH_47F_10";
		case "RHS_CH_47F": {

			_vehicle animateSource ["ramp_anim", 1];

		};

		default {

			{_vehicle animateDoor [_x, 1]} forEach (_vehicle call SAC_fnc_openableDoors);

		};

	};
	
	//[_vehicle] call SAC_fnc_retextureVehicle;

};
