// adds briefing page with useful actions, the page is only visible to admin or zeuses

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

	if(_actionName == "heal_player") then {
		private _target = call GVAR(getPlayer);
		_target setVehicleAmmo 1;
		_target setDamage 0;
		if(!isNil{ACE_player}) then {
			[ACE_player, ACE_player] call ace_medical_fnc_treatmentAdvanced_fullHeal;
			["playerChanged", [ACE_player, ACE_player]] call ace_common_fnc_localEvent;
		};
		hint "Fully healed yourself.";
	};

	if(_actionName == "repair_vehicle") then {
		private _target = call GVAR(getPlayer);
		private _vehicle = vehicle _target;
		if(_target != _vehicle) then {
			_vehicle setVehicleAmmo 1;
			_vehicle setDamage 0;
			_vehicle setFuel 1;
			hint "Fully repaired, rearmed and refueled your vehicle.";
		} else {
			hint "Unable to repair, rearm and refuel your vehicle, you are not in vehicle.";
		};
	};

	if(_actionName == "spawn_vehicle") then {
		private _target = call GVAR(getPlayer);
		private _pos = getPos _target;
		_pos = _pos vectorAdd (vectorDir _target);
		_actionParam_1 createVehicle _pos;
		hint format["%1 spawned in front of or around you.", _actionParam_1];
	};

	if(_actionName == "teleport_player") then {
		GVAR(TP_handle) = [] spawn {
			onMapSingleClick format['
				terminate %1;
				private _target = call %2;
				private _currentPos = getPos _target;
				_target setPos [_pos select 0, _pos select 1, _currentPos select 2];
				onMapSingleClick ''false;'';
				true;
			', QGVAR(TP_handle), QGVAR(getPlayer)];
			openMap true;
			hint 'Click on map to teleport.';
			sleep 20;
			onMapSingleClick 'false;';
			hint 'Teleport timed out';
		};
	};

	if(_actionName == "teleport_vehicle") then {
		GVAR(TP_handle) = [] spawn {
			onMapSingleClick format['
				terminate %1;
				private _target = call %2;
				private _vehicle = vehicle _target;
				private _currentPos = getPos _vehicle;
				if(_target != _vehicle) then {
					_currentPos = getPos _vehicle;
					_vehicle setPos [_pos select 0, _pos select 1, _currentPos select 2];
				} else {
					hint ''Unable to teleport, you are not in vehicle.'';
				};
				onMapSingleClick ''false;'';
				true;					
			', QGVAR(TP_handle), QGVAR(getPlayer)];
			openMap true;
			hint 'Click on map to teleport.';
			sleep 20;
			onMapSingleClick 'false;';
			hint 'Teleport timed out';
		};
	};

	if(_actionName == "move_marker") then {
		private _toPos = getPos (call GVAR(getPlayer));
		private _counter = 0;
		{
			//BIS_fnc_inString
			//_this select 0: <string> string to be found
			//_this select 1: <string> string to search from
			//_this select 2 (Optional): <boolean> search is case sensitive (default: false)
			if([_actionParam_1, _x, false] call BIS_fnc_inString) then {
				_x setMarkerPos _toPos;
				_counter = _counter + 1;
			};
		} forEach allMapMarkers;
		hint format["Moved %1 marker(s) with name pattern *%2* to your position.", _counter, _actionParam_1];
	};

	if(_actionName == "cleanup") then {
		[_actionParam_1] execVM "onetime_cleanup.sqf";
	};

	if(_actionName == "tfar_distance") then {
		{
			if(isPlayer _x) then {
				_x setVariable ["tf_receivingDistanceMultiplicator", _actionParam_1, true];
			};
		} forEach allUnits;
		hint format["tf_receivingDistanceMultiplicator set to %1 for all players.", _actionParam_1];
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
		hint format["%1 is now friendly to %2.", str(_actionParam_1), str(_actionParam_2)];
	};

	if(_actionName == "hostile") then {
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
		hint format["%1 is now hostile to %2.", str(_actionParam_1), str(_actionParam_2)];
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
						"<execute expression='[""respawn""] call %1'>force respawn yourself</execute><br />"+
						"<br />"+
						"<execute expression='[""teleport_player""] call %1'>teleport yourself</execute><br />"+
						"<execute expression='[""teleport_vehicle""] call %1'>teleport your vehicle (if you are in vehicle)</execute><br />"+
						"<br />"+
						"<execute expression='[""heal_player""] call %1'>fully heal yourself</execute><br />"+
						"<execute expression='[""repair_vehicle""] call %1'>fully repair, reammo and refuel your vehicle (if you are in vehicle)</execute><br />"+
						"<br />"+
						"cleanup around you in radius<br />"+
						"<execute expression='[""cleanup"", 10] call %1'>10m</execute><br />"+
						"<execute expression='[""cleanup"", 100] call %1'>100m</execute><br />"+
						"<execute expression='[""cleanup"", 1000] call %1'>1000m</execute><br />"+
						"<br />"+
						"spawn in front of you<br />"+
						"<execute expression='[""spawn_vehicle"", ""ACE_Track""] call %1'>ACE_Track</execute><br />"+
						"<execute expression='[""spawn_vehicle"", ""ACE_Wheel""] call %1'>ACE_Wheel</execute><br />"+
						"<br />"+
						"move marker to my position<br />"+
						"<execute expression='[""move_marker"", ""respawn""] call %1'>*respawn*</execute><br />"+
						"<execute expression='[""move_marker"", ""respawn_west""] call %1'>*respawn_west*</execute><br />"+
						"<execute expression='[""move_marker"", ""respawn_east""] call %1'>*respawn_east*</execute><br />"+
						"<execute expression='[""move_marker"", ""respawn_guerrila""] call %1'>*respawn_guerrila*</execute><br />"+
						"<execute expression='[""move_marker"", ""respawn_civilian""] call %1'>*respawn_civilian*</execute><br />"+
						"<br />"+
						"set tfar radio receiving distance multiplicator<br />"+
						"<execute expression='[""tfar_distance"", 0.001] call %1'>0.001 (increases radio range)</execute><br />"+
						"<execute expression='[""tfar_distance"", 0.01] call %1'>0.01</execute><br />"+
						"<execute expression='[""tfar_distance"", 0.1] call %1'>0.1</execute><br />"+
						"<execute expression='[""tfar_distance"", 1] call %1'>1 (default)</execute><br />"+
						"<execute expression='[""tfar_distance"", 10] call %1'>10</execute><br />"+
						"<execute expression='[""tfar_distance"", 100] call %1'>100</execute><br />"+
						"<execute expression='[""tfar_distance"", 1000] call %1'>1000 (decreases radio range)</execute><br />"+
						"<br />"+
						"west<br />"+
						"<execute expression='[""friend"", west, west] call %1'>friend to west</execute><br />"+
						"<execute expression='[""friend"", west, east] call %1'>friend to east</execute><br />"+
						"<execute expression='[""friend"", west, independent] call %1'>friend to independent</execute><br />"+
						"<execute expression='[""friend"", west, civilian] call %1'>friend to civilian</execute><br />"+
						"<execute expression='[""hostile"", west, west] call %1'>hostile to west</execute><br />"+
						"<execute expression='[""hostile"", west, east] call %1'>hostile to east</execute><br />"+
						"<execute expression='[""hostile"", west, independent] call %1'>hostile to independent</execute><br />"+
						"<execute expression='[""hostile"", west, civilian] call %1'>hostile to civilian</execute><br />"+
						"<br />"+
						"east<br />"+
						"<execute expression='[""friend"", east, west] call %1'>friend to west</execute><br />"+
						"<execute expression='[""friend"", east, east] call %1'>friend to east</execute><br />"+
						"<execute expression='[""friend"", east, independent] call %1'>friend to independent</execute><br />"+
						"<execute expression='[""friend"", east, civilian] call %1'>friend to civilian</execute><br />"+
						"<execute expression='[""hostile"", east, west] call %1'>hostile to west</execute><br />"+
						"<execute expression='[""hostile"", east, east] call %1'>hostile to east</execute><br />"+
						"<execute expression='[""hostile"", east, independent] call %1'>hostile to independent</execute><br />"+
						"<execute expression='[""hostile"", east, civilian] call %1'>hostile to civilian</execute><br />"+
						"<br />"+
						"independent<br />"+
						"<execute expression='[""friend"", independent, west] call %1'>friend to west</execute><br />"+
						"<execute expression='[""friend"", independent, east] call %1'>friend to east</execute><br />"+
						"<execute expression='[""friend"", independent, independent] call %1'>friend to independent</execute><br />"+
						"<execute expression='[""friend"", independent, civilian] call %1'>friend to civilian</execute><br />"+
						"<execute expression='[""hostile"", independent, west] call %1'>hostile to west</execute><br />"+
						"<execute expression='[""hostile"", independent, east] call %1'>hostile to east</execute><br />"+
						"<execute expression='[""hostile"", independent, independent] call %1'>hostile to independent</execute><br />"+
						"<execute expression='[""hostile"", independent, civilian] call %1'>hostile to civilian</execute><br />"+
						"<br />"+
						"civilian<br />"+
						"<execute expression='[""friend"", civilian, west] call %1'>friend to west</execute><br />"+
						"<execute expression='[""friend"", civilian, east] call %1'>friend to east</execute><br />"+
						"<execute expression='[""friend"", civilian, independent] call %1'>friend to independent</execute><br />"+
						"<execute expression='[""friend"", civilian, civilian] call %1'>friend to civilian</execute><br />"+
						"<execute expression='[""hostile"", civilian, west] call %1'>hostile to west</execute><br />"+
						"<execute expression='[""hostile"", civilian, east] call %1'>hostile to east</execute><br />"+
						"<execute expression='[""hostile"", civilian, independent] call %1'>hostile to independent</execute><br />"+
						"<execute expression='[""hostile"", civilian, civilian] call %1'>hostile to civilian</execute><br />"+
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