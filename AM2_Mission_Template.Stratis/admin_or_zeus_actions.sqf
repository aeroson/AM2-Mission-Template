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
		["_actionParam_2", nil]
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

	if(_actionName == "friend") then {
		[
			[
				[_actionParam_1, _actionParam_2],
				{
					params [
						["_actionParam_1", nil],
						["_actionParam_2", nil]
					];
					_actionParam_1 setFriend[_actionParam_2, 1];
				}
			]
		, "BIS_fnc_spawn", false] call BIS_fnc_MP;
	};

	if(_actionName == "enemy") then {
		[
			[
				[_actionParam_1, _actionParam_2],
				{
					params [
						["_actionParam_1", nil],
						["_actionParam_2", nil]
					];
					_actionParam_1 setFriend[_actionParam_2, 0];
				}
			]
		, "BIS_fnc_spawn", false] call BIS_fnc_MP;
	};

};


GVAR(handle) = [] spawn {
	private _diaryEntry = nil;
	waitUntil {!isNull(player)};
	waitUntil {!isNull findDisplay 46};
	while{true} do {
		if(call GVAR(isAllowed)) then {			
			if(isNil{_diaryEntry}) then {
				terminate GVAR(handle);
				_diaryEntry = player createDiaryRecord ["Diary", ["TAW AM2 Mission Zeus & Admin actions", 
					format[
						"You see this because you are or were either zeus or admin.<br />"+
						"If you don't know what these do, don't click it.<br />"+
						"<br />"+
						"<execute expression='[""respawn""] call %1'>respawn</execute><br />"+
						"<br />"+
						"cleanup<br />"+
						"<execute expression='[""cleanup"", 10] call %1'>10m</execute><br />"+
						"<execute expression='[""cleanup"", 100] call %1'>100m</execute><br />"+
						"<execute expression='[""cleanup"", 1000] call %1'>1000m</execute><br />"+
						"<br />"+
						"set tfar radio transmiting distance multiplier<br />"+
						"<execute expression='[""tfar_distance"", 0.001] call %1'>0.001</execute><br />"+
						"<execute expression='[""tfar_distance"", 0.01] call %1'>0.01</execute><br />"+
						"<execute expression='[""tfar_distance"", 0.1] call %1'>0.1</execute><br />"+
						"<execute expression='[""tfar_distance"", 1] call %1'>1 (default)</execute><br />"+
						"<execute expression='[""tfar_distance"", 10] call %1'>10</execute><br />"+
						"<execute expression='[""tfar_distance"", 100] call %1'>100</execute><br />"+
						"<execute expression='[""tfar_distance"", 1000] call %1'>1000</execute><br />"+
						"<br />"+
						"west<br />"+
						"<execute expression='[""friend"", west, west] call %1'>friend to west</execute><br />"+
						"<execute expression='[""friend"", west, east] call %1'>friend to east</execute><br />"+
						"<execute expression='[""friend"", west, independent] call %1'>friend to independent</execute><br />"+
						"<execute expression='[""friend"", west, civilian] call %1'>friend to civilian</execute><br />"+
						"<execute expression='[""enemy"", west, west] call %1'>enemy to west</execute><br />"+
						"<execute expression='[""enemy"", west, east] call %1'>enemy to east</execute><br />"+
						"<execute expression='[""enemy"", west, independent] call %1'>enemy to independent</execute><br />"+
						"<execute expression='[""enemy"", west, civilian] call %1'>enemy to civilian</execute><br />"+
						"<br />"+
						"east<br />"+
						"<execute expression='[""friend"", east, west] call %1'>friend to west</execute><br />"+
						"<execute expression='[""friend"", east, east] call %1'>friend to east</execute><br />"+
						"<execute expression='[""friend"", east, independent] call %1'>friend to independent</execute><br />"+
						"<execute expression='[""friend"", east, civilian] call %1'>friend to civilian</execute><br />"+
						"<execute expression='[""enemy"", east, west] call %1'>enemy to west</execute><br />"+
						"<execute expression='[""enemy"", east, east] call %1'>enemy to east</execute><br />"+
						"<execute expression='[""enemy"", east, independent] call %1'>enemy to independent</execute><br />"+
						"<execute expression='[""enemy"", east, civilian] call %1'>enemy to civilian</execute><br />"+
						"<br />"+
						"independent<br />"+
						"<execute expression='[""friend"", independent, west] call %1'>friend to west</execute><br />"+
						"<execute expression='[""friend"", independent, east] call %1'>friend to east</execute><br />"+
						"<execute expression='[""friend"", independent, independent] call %1'>friend to independent</execute><br />"+
						"<execute expression='[""friend"", independent, civilian] call %1'>friend to civilian</execute><br />"+
						"<execute expression='[""enemy"", independent, west] call %1'>enemy to west</execute><br />"+
						"<execute expression='[""enemy"", independent, east] call %1'>enemy to east</execute><br />"+
						"<execute expression='[""enemy"", independent, independent] call %1'>enemy to independent</execute><br />"+
						"<execute expression='[""enemy"", independent, civilian] call %1'>enemy to civilian</execute><br />"+
						"<br />"+
						"civilian<br />"+
						"<execute expression='[""friend"", civilian, west] call %1'>friend to west</execute><br />"+
						"<execute expression='[""friend"", civilian, east] call %1'>friend to east</execute><br />"+
						"<execute expression='[""friend"", civilian, independent] call %1'>friend to independent</execute><br />"+
						"<execute expression='[""friend"", civilian, civilian] call %1'>friend to civilian</execute><br />"+
						"<execute expression='[""enemy"", civilian, west] call %1'>enemy to west</execute><br />"+
						"<execute expression='[""enemy"", civilian, east] call %1'>enemy to east</execute><br />"+
						"<execute expression='[""enemy"", civilian, independent] call %1'>enemy to independent</execute><br />"+
						"<execute expression='[""enemy"", civilian, civilian] call %1'>enemy to civilian</execute><br />"+
						"<br />"+
						"<br />"+
						"",
						QGVAR(action)
					]
				]];
			};
		};		
		sleep 1;
	};	
};



















