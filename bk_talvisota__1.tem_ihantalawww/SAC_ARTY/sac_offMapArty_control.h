// SAC_ARTY\sac_offMapArty_control.h
class CfgFunctions {
    class SAC {
        class Artillery {
            file = "SAC_ARTY";
            class monitorKeyPress {
                postInit = 1;
            };
        };
    };
};

class CfgUserActions {
    class ArtilleryRequest {
        displayName = "Abrir solicitud de artillería";
        onActivate = "";
        onDeactivate = "";
        tooltip = "Abre el panel para solicitar un ataque de artillería";
        userActionID = 7;
    };
};

class CfgDefaultKeysMapping {
    class ArtilleryRequest {
        key = 55;  // Código de la tecla * en el pad numérico
        shift = 0;
        ctrl = 0;
        alt = 0;
    };
};


class ArtilleryRequestDialog {
    idd = -1;
    movingenable = false;

    class controlsBackground {
        class Background: RscText {
            idc = -1;
            x = 0.2; y = 0.15;
            w = 0.6; h = 0.6;
            colorBackground[] = {0.2, 0.2, 0.2, 0.8};  // Color gris con opacidad del 80%
        };
    };

    class controls {
        class ArtilleryTitle: RscText {
            idc = -1;
            text = "Solicitud de Artillería";
            x = 0.3; y = 0.2;
            w = 0.4; h = 0.05;
        };

        // Coordenadas
        class CoordenadasText: RscText {
            idc = -1;
            text = "Coordenadas:";
            x = 0.3; y = 0.27;
            w = 0.2; h = 0.05;
        };
        
        // Input para coordenadas
        class CoordenadasXEdit: RscEdit {
            idc = 1000; // IDC de las coordenadas
            text = ""; 
            x = 0.45; y = 0.27;  
            w = 0.2; h = 0.05;
        };

        // Dispersión
        class DispersionText: RscText {
            idc = -1;
            text = "Dispersión (m):";
            x = 0.3; y = 0.34;
            w = 0.2; h = 0.05;
        };
        class DispersionEdit: RscEdit {
            idc = 1001; // IDC de la dispersión
            x = 0.45; y = 0.34;
            w = 0.2; h = 0.05;
        };

        // Unidades
        class UnidadesText: RscText {
            idc = -1;
            text = "Unidades:";
            x = 0.3; y = 0.41;
            w = 0.2; h = 0.05;
        };
        class UnidadesEdit: RscEdit {
            idc = 1002; // IDC de las unidades
            x = 0.45; y = 0.41;
            w = 0.2; h = 0.05;
        };

        // Rondas
        class RondasText: RscText {
            idc = -1;
            text = "Rondas:";
            x = 0.3; y = 0.48;
            w = 0.2; h = 0.05;
        };
        class RondasEdit: RscEdit {
            idc = 1003; // IDC de las rondas
            x = 0.45; y = 0.48;
            w = 0.2; h = 0.05;
        };

        // Tipo de munición
        class MunicionText: RscText {
            idc = -1;
            text = "Munición:";
            x = 0.3; y = 0.55;
            w = 0.2; h = 0.05;
        };
        class MunicionCombo: RscCombo {
            idc = 1004; // IDC de la munición
            x = 0.45; y = 0.55;
            w = 0.2; h = 0.05;
        };

        // Botón Aceptar
        class AcceptButton: RscButton {
            idc = -1;
            text = "Aceptar";
            x = 0.35; y = 0.65;
            w = 0.1; h = 0.05;
            action = "[] spawn executeArtilleryRequest;";
        };

        // Botón Cancelar
        class CancelButton: RscButton {
            idc = -1;
            text = "Cancelar";
            x = 0.55; y = 0.65;
            w = 0.1; h = 0.05;
            action = "closeDialog 0;";
        };
    };
};
