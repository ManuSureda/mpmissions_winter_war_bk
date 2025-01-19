//
//******* ES SOLO PARA CORRER DESDE EL INIT DE CAJAS PUESTAS EN EL EDITOR ***********************
//

if (isServer) then {

	waitUntil{!isNil "SAC_GEAR"};
	waitUntil{SAC_GEAR};

	_this spawn SAC_GEAR_fnc_addContainer;

};
