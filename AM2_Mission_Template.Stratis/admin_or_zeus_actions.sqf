#define COMPONENT taw_am2_mission_template

#define QUOTE(A) #A
#define CONCAT(A,B) A####B
#define GVAR(VAR_NAME) COMPONENT##_##VAR_NAME
#define QGVAR(VAR_NAME) QUOTE(GVAR(VAR_NAME))
#define FNC(FNC_NAME) COMPONENT##_fnc_##FNC_NAME
#define QFNC(FNC_NAME) QUOTE(FNC(FNC_NAME))


GVAR(isAllowed) = {
	if (isServer) exitWith { true; };
	if (({getAssignedCuratorUnit _x == player} count allCurators)>0) exitWith { true; };
	if (serverCommandAvailable "#logout") exitWith { true; };
	false;
};


GVAR(getPlayer) = {
	if(isNil{ACE_player}) exitWith { player; };
	ACE_player;	
};

GVAR(action) = {

	params [
		["_actionName", ""],
		["_actionParam_1", nil],
	];

	if(!(call GVAR(isAllowed))) exitWith {
		systemChat "You are no longer zeus nor admin.";
	};

	if(_actionName == "respawn") then {
		player setDamage 1;
	};
	
	if(_actionName == "cleanup") then {
		[_actionParam_1] execVM "onetime_cleanup.sqf";
	};

	if(_actionName == "tfar_distance") then {
		{
			_x setVariable ["tf_sendingDistanceMultiplicator", _actionParam_1, true];
		} forEach allUnits;
	};

};



[] spawn {

	private _diaryEntry = nil;

	while{true} do {

		if(call GVAR(isAllowed)) then {			
			if(isNil{_diaryEntry}) then {
				_diaryEntry = player createDiaryRecord ["Diary", ["TAW AM2 Mission Zeus & Admin actions", 
					"You see this because you are or were either zeus or admin.<br />"+
					"If you don't know what these do, don't click it.<br />"+
					"<br />"+
					"<execute expression='[''respawn''] call "+QGVAR(action)+"'>respawn</execute><br />"+
					"<br />"+
					"cleanup<br />"+
					"<execute expression='[''cleanup'', 10] call "+QGVAR(action)+"'>10m</execute><br />"+
					"<execute expression='[''cleanup'', 100] call "+QGVAR(action)+"'>100m</execute><br />"+
					"<execute expression='[''cleanup'', 1000] call "+QGVAR(action)+"'>1000m</execute><br />"+
					"<br />"+
					"set tfar radio transmiting distance multiplier<br />"+
					"<execute expression='[''tfar_distance'', 0.001] call "+QGVAR(action)+"'>0.001</execute><br />"+
					"<execute expression='[''tfar_distance'', 0.01] call "+QGVAR(action)+"'>0.01</execute><br />"+
					"<execute expression='[''tfar_distance'', 0.1] call "+QGVAR(action)+"'>0.1</execute><br />"+
					"<execute expression='[''tfar_distance'', 1] call "+QGVAR(action)+"'>1 (default)</execute><br />"+
					"<execute expression='[''tfar_distance'', 10] call "+QGVAR(action)+"'>10</execute><br />"+
					"<execute expression='[''tfar_distance'', 100] call "+QGVAR(action)+"'>100</execute><br />"+
					"<execute expression='[''tfar_distance'', 1000] call "+QGVAR(action)+"'>1000</execute><br />"+
				]];
			};
		};		
		sleep 1;

	};	

};



















