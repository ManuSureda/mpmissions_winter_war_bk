SAC_fnc_artilleryAttack =
{
  params ["_markersNamesArray",["_ammo", "Sh_82mm_AMOS"],["_minSleep", 2],["_maxSleep", 2],["_flag", nil]];
                                        //Sh_155mm_AMOS
  if (isNil "_ammo") then {
    _ammo = "Sh_82mm_AMOS";
  };

  if (isNil "_flag") then {
  hint "-----";
  };

  _f = true;

  while { _f == true } do {

    private _positionArray = [];
    {
     if !(getmarkerpos _x isEqualto [0,0,0]) then {
        _positionArray pushback getmarkerpos _x
     }
    } foreach _markersNamesArray;

    {
      _x set [2, 250];
      [_ammo, _x, 999, 999, 999, 999, 70] spawn SAC_fnc_impact;

      //sleep ([_minSleep, _maxSleep] call SAC_fnc_numberBetween);
      uiSleep ([_minSleep, _maxSleep] call SAC_fnc_numberBetween);
    } foreach _positionArray;

    if (!isNil "_flag") then {
      _f = alive _flag;
    } else {
      _f = false;
    };
  };
};

SAC_fnc_trenchPos =
{
  params ["_group1","_group2",["_minSleep", 10],["_maxSleep", 15]];

  private _i = 1;

  while { {alive _x} count (units _group1) + (units _group2) > 0 } do
  {
    if (_i % 2 == 0) then {
      {
        _x setUnitPos "MIDDLE";
      } forEach units _group1;
      {
        _x setUnitPos "UP";
      } forEach units _group2;
    } else {
      {
        _x setUnitPos "MIDDLE";
      } forEach units _group2;
      {
        _x setUnitPos "UP";
      } forEach units _group1;
    };
    _i = _i + 1;

    //sleep ([_minSleep, _maxSleep] call SAC_fnc_numberBetween);
    uiSleep ([_minSleep, _maxSleep] call SAC_fnc_numberBetween);
  };

};

SAC_fnc_changePosture =
{
  params ["_group",["_minSleep", 10],["_maxSleep", 15],["_postures", ["DOWN","MIDDLE","UP"]]];

  while { {alive _x} count (units _group) > 0 } do
  {
    {
      _x setUnitPos selectRandom _postures;
    } forEach units _group;
    uiSleep ([_minSleep, _maxSleep] call SAC_fnc_numberBetween);
  };
};

SAC_fnc_paraJump =
{
  params["_markers",["_height",300]];

  _pos = [];
  _i = 0;

  _positionArray = [];
  {
    if !(getmarkerpos _x isEqualto [0,0,0]) then {
       _pos = getmarkerpos _x;
       _pos set [2,_height];
       _positionArray pushback _pos;
    }
  } foreach _markers;

  {
    _x setPos (_positionArray select _i);
    _i = _i + 1;
    //sleep 3;
    uiSleep 3;
  } foreach allPlayers;

};

SAC_fnc_planeJump =
{
  params["_plane"];

  _flag = 0;
  _gun = 0;
  {
     _gun = floor(random(10 - 1 + 1)) + 1;
     if(_flag > 0) then {
        if(_gun < 6) then { _x removeWeaponGlobal primaryWeapon _x };
        //sleep 2;
        uiSleep 2;
        _x action ["eject", _plane];
     } else {
        _flag = 1;
     }
  } forEach crew _plane;

  _gun = floor(random(10 - 1 + 1)) + 1;
  if(_gun < 6) then { (driver _plane) removeWeaponGlobal primaryWeapon (driver _plane) };
  //sleep 2;
  uiSleep 2;
  (driver _plane) action ["eject", _plane];

  deleteVehicle _plane;

};

SAC_fnc_waveAttack = 
{
  params["_spawnMarkersNameArray", "_destinyMarkersNameArray", "_side", 
  "_endFlag", ["_minUnits", 6], ["_maxUnits", 10], ["_enemyArray", SAC_UDS_O_G_Soldiers],
  ["_wpTimeout",[0,0,0]], 
  ["_wavesDelay", 300], 
  ["_deathTimeOut", 0], 
  ["_maxWaves", 0]];

  //_deathTimeOut: al morir toda una wave, espera esa cantidad de tiempo para espawnear la siguiente

  if (!isServer) exitWith {};

  _wavesCount = 0; 

  while { !isNil "_endFlag" && alive _endFlag } do {
    
    _wavesCount = _wavesCount + 1;

    if (_maxWaves > 0 && _wavesCount > _maxWaves) then {
        deleteVehicle _endFlag;
    } else {
        _unitsQuantity = [_minUnits, _maxUnits] call BIS_fnc_randomInt;
        _spawnMarker = selectRandom _spawnMarkersNameArray;

        _group = createGroup [_side, true];

        for "_i" from 0 to _unitsQuantity do {
            _soldier = selectRandom _enemyArray;
            _pos = getMarkerPos _spawnMarker;
            _unit = _group createUnit [_soldier, _pos, [], 1, "NONE"];
            sleep 0.3;
            [_unit] call SAC_GEAR_applyLoadoutByClass;
        };

        [_group] call SAC_fnc_setSkills;

        _group setBehaviourStrong "AWARE";
        _group setCombatMode "GREEN";
        _group setFormation "LINE";

        {
          sleep 0.2;
          _destinyPos = getMarkerPos _x;
          _wp = _group addWaypoint [_destinyPos, 1];
          _wp setWaypointTimeout _wpTimeout;
        } forEach _destinyMarkersNameArray;

        _actualDelay = 0;

        while { _actualDelay < _wavesDelay } do {
          sleep 10;

          if ({(alive _x) && !(_x getVariable ["ACE_isUnconscious", false])} count units _group <= 1) then {
            if ((_actualDelay + _deathTimeOut) < _wavesDelay) then {
              sleep _deathTimeOut;
            };
            _actualDelay = _wavesDelay;
          } else {
            _actualDelay = _actualDelay + 10;
          };
        };
    };
  };
};

// SAC_fnc_spawnVehicle = 
SAC_fnc_waveAttack_v2 = 
{
  // ahora _markersNameArray toma el select 0 como spawn y el resto como waypoints 
  params[
    "_arrayMarkersNameArray",   
    "_endFlag", 
    ["_minUnits", 6], 
    ["_maxUnits", 10], 
    ["_enemyArray", SAC_UDS_O_G_Soldiers],
    ["_wpTimeout",[0,0,0]], 
    ["_wavesDelay", 300], 
    ["_deathTimeOut", 0], 
    ["_maxWaves", 0]
  ];

  //_deathTimeOut: al morir toda una wave, espera esa cantidad de tiempo para espawnear la siguiente

  if (!isServer) exitWith {};

  private _side = [_enemyArray select 0] call SAC_fnc_getSideFromCfg;
  private _wavesCount = 0; 
  
  while {!isNil "_endFlag" && alive _endFlag } do {
  
    _markersNameArray = selectRandom _arrayMarkersNameArray;

    if (typeName _markersNameArray isEqualTo "STRING") then {
      _markersNameArray = _arrayMarkersNameArray;
      // si manda un solo array, usa solo ese array, sino uno random
    };
    
    _wavesCount = _wavesCount + 1;

    if (_maxWaves > 0 && _wavesCount > _maxWaves) then {
        deleteVehicle _endFlag;
    } else {
        _unitsQuantity = [_minUnits, _maxUnits] call BIS_fnc_randomInt;
        _spawnMarker = _markersNameArray select 0;

        _group = createGroup [_side, true];

        // incluye el 'to' 
        for "_i" from 1 to _unitsQuantity do {
            _soldier = selectRandom _enemyArray;
            _pos = getMarkerPos _spawnMarker;
            _unit = _group createUnit [_soldier, _pos, [], 1, "NONE"];
            sleep 0.3;
            [_unit] call SAC_GEAR_applyLoadoutByClass;
        };

        [_group] call SAC_fnc_setSkills;

        _group setBehaviourStrong "AWARE";
        _group setCombatMode "GREEN";
        _group setFormation "LINE";

        for "_j" from 1 to (count _markersNameArray -1) do {
          sleep 0.2;
          _destinyPos = getMarkerPos (_markersNameArray select _j);
          _wp = _group addWaypoint [_destinyPos, 1];
          _wp setWaypointTimeout _wpTimeout;
        };

        _actualDelay = 0;

        while { _actualDelay < _wavesDelay } do {
          sleep 10;
          _actualDelay = _actualDelay + 10;

          if ({(alive _x) && !(_x getVariable ["ACE_isUnconscious", false])} count units _group <= 1) then {
            if ((_actualDelay + _deathTimeOut) < _wavesDelay) then {
              sleep _deathTimeOut;
              _actualDelay = _wavesDelay;
            };
          };
        };
    };
  };
};

SAC_fnc_blowBridge = 
{
  params ["_bridge", "_evaluationTime", "_probabilityToBlow", "_explosivesArray"];

  if (!isServer) exitWith {};

  private _flag = true;

  while {_flag == true} do {
    sleep _evaluationTime;
    // hint "entro al while";
    _expAlives = 0;
    {
      if (alive _x) then {
        _expAlives = 1;
      };
    } forEach _explosivesArray;

    if (_expAlives == 0) then {
      _flag = false;
    } else {
      if (random 1 < _probabilityToBlow) then {
        // hint "entro al if";
        {
          _x setDamage 1;
          sleep 0.3;          
        } forEach _explosivesArray;
        sleep 0.3;
      };
      {
        deleteVehicle _x;
      } forEach _bridge;
    };
  };
};

blowSomething =
{
  params ["_explosivesArray", "_objectsToDelete", "_secondsToBlow", "_secondsPerBlow"];

  for "_o" from 0 to (count _explosivesArray) do {
    (_explosivesArray select _o) hideObjectGlobal false;
  };

  ["Explosivo colocado"] spawn SAC_fnc_MPhint;

  sleep _secondsToBlow;

  /*for "_i" from _secondsToBlow to 0 step -1 do {
    [str _i] spawn SAC_fnc_MPhint;
    sleep 1;
  };*/

  for "_j" from 0 to (count _explosivesArray) do {
    (_explosivesArray select _j) setDamage 1;
    sleep _secondsPerBlow;
    deleteVehicle (_explosivesArray select _j); 
  };

  for "_k" from 0 to (count _objectsToDelete) do {
    deleteVehicle (_objectsToDelete select _k);
  };

};

SAC_fnc_vehicleWaveAttack_3 = 
{
  params[
    "_spawnMarkersNameArray", "_destinyMarkersNameArray", "_side", "_endFlag", 
    ["_enemyVehicleArray", SAC_UDS_O_G_Tanks], ["_enemyCrewArray", SAC_UDS_O_G_TankCrews],
    ["_wpTimeout",[0,0,0]], ["_wavesDelay", 300], ["_deathTimeOut", 0], ["_maxWaves", 0],
    ["_groupBehaviour", "AWARE"]
  ];

  //_deathTimeOut: al morir toda una wave, espera esa cantidad de tiempo para espawnear la siguiente

  if (!isServer) exitWith {};

  _wavesCount = 0; 

  while {!isNil "_endFlag" && alive _endFlag } do {
    
    _wavesCount = _wavesCount + 1;

    if (_maxWaves > 0 && _wavesCount > _maxWaves) then {
        deleteVehicle _endFlag;
    } else {
        _spawnMarker = selectRandom _spawnMarkersNameArray;
        _markerDir = markerDir _spawnMarker;
        _vehicleClass = selectRandom _enemyVehicleArray;
        _vehicle = createVehicle[_vehicleClass, (getMarkerPos _spawnMarker), [], 1, "NONE"];
        sleep 0.3;
        _vehicleSeats = _vehicle call BIS_fnc_vehicleCrewTurrets;
        
        _crewCount = (count _vehicleSeats);

        _group = createGroup [_side, true];
        // hace hasta _crewCount incluido, con lo cual se saldria del array
        for "_i" from 0 to _crewCount do {
            _soldier = selectRandom _enemyCrewArray;
            _pos = getMarkerPos _spawnMarker;
            _unit = _group createUnit [_soldier, _pos, [], 1, "NONE"];
            sleep 0.3;
            [_unit] call SAC_GEAR_applyLoadoutByClass;

            _unit disableAI "PATH";
        };
        [_group] call SAC_fnc_setSkills;
        _group setBehaviourStrong _groupBehaviour;
        _group setCombatMode "GREEN";

        _group addVehicle _vehicle;

        {
          sleep 0.3;
          _destinyPos = getMarkerPos _x;
          _wp = _group addWaypoint [_destinyPos, 1];
          _wp setWaypointType "MOVE";
          _wp setWaypointTimeout _wpTimeout;
        } forEach _destinyMarkersNameArray;

        for "_i" from 0 to _crewCount-1 do {
          _s = _vehicleSeats select _i;
          _u = (units _group) select _i;
          if (_s isEqualTo [-1]) then {
            _u setUnitRank "LIEUTENANT";
            _u moveInDriver _vehicle
          } else {
            _u setUnitRank "SERGEANT";
            _u moveInTurret [_vehicle, _s];
          };
        };

        sleep 1;

        {
          _x enableAI "PATH";
        } forEach units _group;

        _actualDelay = 0;

        while { _actualDelay < _wavesDelay } do {
          sleep 10;

          if ({(alive _x) && !(_x getVariable ["ACE_isUnconscious", false])} count units _group <= 1) then {
            if ((_actualDelay + _deathTimeOut) < _wavesDelay) then {
                    sleep _deathTimeOut;
            };
            _actualDelay = _wavesDelay;
          } else {
            _actualDelay = _actualDelay + 10;
          };
        };
    };
  };
};

SAC_fnc_vehicleWaveAttack_2 = 
{
  params[
    "_spawnMarkersNameArray", "_destinyMarkersNameArray", "_side", "_endFlag", 
    ["_enemyVehicleArray", SAC_UDS_O_G_Tanks], ["_enemyCrewArray", SAC_UDS_O_G_TankCrews],
    ["_wpTimeout",[0,0,0]], ["_wavesDelay", 300], ["_deathTimeOut", 0], ["_maxWaves", 0],
    ["_groupBehaviour", "AWARE"]
  ];

  //_deathTimeOut: al morir toda una wave, espera esa cantidad de tiempo para espawnear la siguiente

  if (!isServer) exitWith {};

  _wavesCount = 0; 

  while {!isNil "_endFlag" && alive _endFlag } do {
    
    _wavesCount = _wavesCount + 1;

    if (_maxWaves > 0 && _wavesCount > _maxWaves) then {
        deleteVehicle _endFlag;
    } else {
        _spawnMarker = selectRandom _spawnMarkersNameArray;

        _vehicleClass = selectRandom _enemyVehicleArray;
        
        _crewCount = count (_vehicleClass call BIS_fnc_vehicleCrewTurrets);
        
        _group = createGroup [_side, true];

        for "_i" from 1 to _crewCount do {
            _soldier = selectRandom _enemyCrewArray;
            _pos = getMarkerPos _spawnMarker;
            _unit = _group createUnit [_soldier, _pos, [], 1, "NONE"];
            sleep 0.3;
            [_unit] call SAC_GEAR_applyLoadoutByClass;
        };
        
        [_group] call SAC_fnc_setSkills;

        _group setBehaviourStrong _groupBehaviour;
        _group setCombatMode "GREEN";

        sleep 0.5;

        _a = [(getMarkerPos _spawnMarker), (markerDir _spawnMarker), _vehicleClass, _group] call BIS_fnc_spawnVehicle;
        hint str _a;

        sleep 0.3;
        {
          sleep 0.3;
          _destinyPos = getMarkerPos _x;
          _wp = _group addWaypoint [_destinyPos, 1];
          _wp setWaypointType "MOVE";
          _wp setWaypointTimeout _wpTimeout;
        } forEach _destinyMarkersNameArray;

        _actualDelay = 0;

        while { _actualDelay < _wavesDelay } do {
          sleep 10;

          if ({(alive _x) && !(_x getVariable ["ACE_isUnconscious", false])} count units _group <= 1) then {
            if ((_actualDelay + _deathTimeOut) < _wavesDelay) then {
                    sleep _deathTimeOut;
            };
            _actualDelay = _wavesDelay;
          } else {
            _actualDelay = _actualDelay + 10;
          };
        };
    };
  };
};

SAC_fnc_vehicleWaveAttack = 
{
  params[
    "_spawnMarkersNameArray", "_destinyMarkersNameArray", "_side", "_endFlag", 
    ["_enemyVehicleArray", SAC_UDS_O_G_Tanks], ["_enemyCrewArray", SAC_UDS_O_G_TankCrews],
    ["_wpTimeout",[0,0,0]], ["_wavesDelay", 300], ["_deathTimeOut", 0], ["_maxWaves", 0],
    ["_groupBehaviour", "AWARE"]
  ];

  //_deathTimeOut: al morir toda una wave, espera esa cantidad de tiempo para espawnear la siguiente

  if (!isServer) exitWith {};

  _wavesCount = 0; 

  while {!isNil "_endFlag" && alive _endFlag } do {
    
    _wavesCount = _wavesCount + 1;

    if (_maxWaves > 0 && _wavesCount > _maxWaves) then {
        deleteVehicle _endFlag;
    } else {
        _spawnMarker = selectRandom _spawnMarkersNameArray;
        _vehicle = createVehicle[(selectRandom _enemyVehicleArray), (getMarkerPos _spawnMarker), [], 1, "NONE"];

        sleep 0.3;

        _vehicleSeats = [[-1]] + allTurrets _vehicle;
        _crewCount = (count _vehicleSeats);

        _group = createGroup [_side, true];
        // hace hasta _crewCount incluido, con lo cual se saldria del array
        for "_i" from 0 to (_crewCount-1) do {
            _soldier = selectRandom _enemyCrewArray;
            _pos = getMarkerPos _spawnMarker;
            _unit = _group createUnit [_soldier, _pos, [], 1, "NONE"];
            sleep 0.3;
            [_unit] call SAC_GEAR_applyLoadoutByClass;

            _str = format[
              "_vehicleSeats: %1 \n
              _crewCount: %2 \n
              _i: %3 \n 
              _seat: %4",
              _vehicleSeats,
              _crewCount,
              _i,
              _vehicleSeats select _i
            ];
            //hintC _str;

            // subir a unidad a driver y torretas
            if (_i == 0) then {
              _unit moveInDriver _vehicle;
              _unit setUnitRank "LIEUTENANT";
              sleep 0.3;
            } else {
              if (_i == 1) then {
                _unit moveInCommander _vehicle;
                _unit setUnitRank "SERGEANT";
                sleep 0.3;
              } else {
                //_unit moveInTurret [_vehicle, (_vehicleSeats select _i)];
                _unit moveInAny _vehicle;
                _unit setUnitRank "SERGEANT";
                sleep 0.3;
              };
            };            
            sleep 0.3;
        };
        sleep 5;
        hint format["_group: %1 \n _vehicleSeats: %2 \n _crewCount: %3", _group, _vehicleSeats, _crewCount];
        _group addVehicle _vehicle;


        [_group] call SAC_fnc_setSkills;

        _group setBehaviourStrong _groupBehaviour;
        _group setCombatMode "GREEN";

        {
          sleep 0.3;
          _destinyPos = getMarkerPos _x;
          _wp = _group addWaypoint [_destinyPos, 1];
          _wp setWaypointType "MOVE";
          _wp setWaypointTimeout _wpTimeout;
        } forEach _destinyMarkersNameArray;

        _actualDelay = 0;

        while { _actualDelay < _wavesDelay } do {
          sleep 10;

          if ({(alive _x) && !(_x getVariable ["ACE_isUnconscious", false])} count units _group <= 1) then {
            if ((_actualDelay + _deathTimeOut) < _wavesDelay) then {
                    sleep _deathTimeOut;
            };
            _actualDelay = _wavesDelay;
          } else {
            _actualDelay = _actualDelay + 10;
          };
        };
    };
  };
};