// SAC_ARTY\sac_dynamic_artillerie.sqf
RADIO_CALL_SOUND_EFECT = "radiochatter_us_18";

MIN_INITIAL_SLEEP = 30;
MAX_INITIAL_SLEEP = 40;
SLEEP_BETWEEN_IMPACTS = 0.7;
SLEEP_BETWEEN_ROUNDS = 10;
MAX_SPREAD = 100;
MAX_UNITS  = 15;
MAX_ROUNDS = 5;

AMMO_TYPE = [
    "Sh_155mm_AMOS",
    "Cluster_155mm_AMOS",
    "Smoke_120mm_AMOS_White",
    "Sh_82mm_AMOS",
    "Flare_82mm_AMOS_White",
    "Smoke_82mm_AMOS_White"
];


/* VANILA 
AMMO_TYPE = [
    "Sh_155mm_AMOS",
    "Cluster_155mm_AMOS",
    "Smoke_120mm_AMOS_White",
    "Sh_82mm_AMOS",
    "Smoke_82mm_AMOS_White"
];*/

/** DESCUBRIR EL className DE ALGUNA RONDA ESPECIFICA
_vehicleClassname = "B_Mortar_01_F";  
 
_vehicleConfig = configFile >> "CfgVehicles" >> _vehicleClassname >> "Turrets" >> "MainTurret"; 
 
// Obtén los magazines (cargadores) que tiene el vehículo 
_magazines = getArray (_vehicleConfig >> "magazines"); 
 
// Variable para almacenar los nombres de las municiones 
_ammoClassnames = []; 
 
// Itera sobre los magazines para obtener sus municiones 
{ 
    // Para cada magazine, obtenemos su configuración 
    _magazineConfig = configFile >> "CfgMagazines" >> _x; 
     
    // Ahora obtenemos la munición asociada al magazine 
    _ammoClassname = getText (_magazineConfig >> "ammo"); 
     
    // Añadimos el classname de la munición a la lista 
    if !(_ammoClassname in _ammoClassnames) then {
        _ammoClassnames pushBack _ammoClassname;     
    };     
} forEach _magazines; 
 
// Copiamos la lista de municiones al portapapeles para que sea visible 
copyToClipboard str _ammoClassnames; 
 */

openArtilleryRequestDialog = {
    createDialog "ArtilleryRequestDialog";
    
    // Agregar opciones al combo de munición
    private _combo = (findDisplay -1) displayCtrl 1004;
    {
        _combo lbAdd _x;   
    } forEach AMMO_TYPE;
};

executeArtilleryRequest = {

    // Obtener los valores ingresados, agregando chequeos para asegurar que no estén vacíos o inválidos
    private _grid      = ctrlText 1000;  // Coordenada x-y referencia de mapa, ej: 032046 (deben ser 6 digitos)
    private _spread    = parseNumber ctrlText 1001;  // Dispersión = en metros.
    private _units     = parseNumber ctrlText 1002;  // Unidades = cantidad de piesas de artilleria que disparan por ronda.
    private _rounds    = parseNumber ctrlText 1003;  // Rondas = cantidad de veces que dispara cada piesa.
    private _ammoType  = AMMO_TYPE select lbCurSel 1004;
    // private _ammoIndex = lbCurSel 1005;  // Índice de munición seleccionada

    // CONTROL AREA
    if (count _grid != 6) then { hint "Formato incorrecto de coordenadas"; closeDialog 0; };
    if (_spread > MAX_SPREAD) then { _spread = MAX_SPREAD; }; // es para que no nos vayamos a la mierda
    if (_units  > MAX_UNITS)  then { _units  = MAX_UNITS; };  // si se nos escapa un 10000 
    if (_rounds > MAX_ROUNDS) then { _rounds = MAX_ROUNDS; };
    
    private _realPos = _grid call BIS_fnc_gridToPos;
    private _gridX = _realPos select 0 select 0;
    private _gridY = _realPos select 0 select 1;

    // private _eta = round (MIN_INITIAL_SLEEP + (random (MAX_INITIAL_SLEEP + 1 - MIN_INITIAL_SLEEP)));
    private _eta = 5;

    hint format[
        "- Orden de fuego -\n
        Coordenadas: %1 \n
        Dispersión: %2  \n 
        Unidades: %3    \n 
        Rondas: %4      \n
        Munición: %5    \n
        ETA: %6         \n",
        _grid, _spread, _units, _rounds, _ammoType, _eta
    ];

    private _soundCheck = str (configFile >> "CfgSounds" >> RADIO_CALL_SOUND_EFECT);

    if (_soundCheck != "<NULL-config>") then {
        [player, RADIO_CALL_SOUND_EFECT, 100] call SAC_fnc_netSay3D;    
    };

    uiSleep _eta;

    // Lógica para disparar artillería
    for "_round" from 1 to _rounds do {
        for "_unit" from 1 to _units do {
            // Generar una posición aleatoria con dispersión
            // + 50 para que sea el centro de la coordenada
            private _impactPos = [
                _gridX + 50 + (random _spread) - (random _spread),
                _gridY + 50 + (random _spread) - (random _spread),
                250
            ];

            // Disparar el impacto de artillería
            [_ammoType, _impactPos, 999, 999, 999, 999, 70] spawn SAC_fnc_impact;

            // Pausar entre disparos
            uiSleep (0.3 + (random SLEEP_BETWEEN_IMPACTS));
        };

        // Pausa entre rondas
        uiSleep SLEEP_BETWEEN_ROUNDS;
    };
};