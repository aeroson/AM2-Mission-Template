
if(!hasInterface) exitWith { };
waitUntil {!isNull(player)};
waitUntil{!isNull findDisplay 46};



tagBasedFindVirtualArsenalLoadout = {

	params [
		["_target", player, [player]],
		["_defaultTags", ["taw","woodland"], [[]]]
	];

	private _virtualArsenalLoadouts = profilenamespace getvariable ["bis_fnc_saveInventory_data", nil];

	if (!isNil {_virtualArsenalLoadouts}) then {

		private _targetRole = toLower roleDescription _target;
		if(_targetRole == "") then {
			_targetRole = toLower getText(configfile >> "cfgVehicles" >> typeof _target >> "DisplayName");
		};

		private _possibleTags = [];
		_possibleTags append _defaultTags;
		_possibleTags append (_targetRole splitString "-.,=/() ");

		if(_targetRole == "combat life saver") then {
			_possibleTags append ["med", "medic"];
		};

		if("platoon" in _possibleTags) then {
			_possibleTags append ["platon"];
		} else {
			if("platon" in _possibleTags) then {
				_possibleTags append ["platoon"];
			};
		};
		if("specialist" in _possibleTags) then {
			if("field" in _possibleTags) then {
				_possibleTags append ["fs"];
			};
			if("game" in _possibleTags) then {
				_possibleTags append ["zeus"];
			};
		};		
		if("leader" in _possibleTags || "lead" in _possibleTags) then {
			if("platoon" in _possibleTags) then {
				_possibleTags append ["pl"];
			};
			if("squad" in _possibleTags) then {
				_possibleTags append ["sl"];
			};
			if("fire" in _possibleTags || "fireteam" in _possibleTags) then {
				_possibleTags append ["fl"];
			};			
		};
		if("engineer" in _possibleTags) then {
			_possibleTags append ["eng", "enginer", "repair"];
		};

		private _targetTags = [];
		{
			if(!(_x in _targetTags) && count _x > 1) then {
				_targetTags pushBack _x;
			};
		} forEach _possibleTags;

		systemChat format["Looking for loadout with tags: %1", _targetTags];
		diag_log format["Looking for loadout with tags: %1", _targetTags];

		private _foundLoadoutName = "";
		private _foundLoadoutTagsMatched = 0;

		for "_i" from 0 to (count _virtualArsenalLoadouts) - 1 step 2 do {

			private _loadoutName = _virtualArsenalLoadouts select _i;
			private _loadoutNameParts = _loadoutName splitString "-.,=/() ";
			private _tagsMatched = 0;
			
			{
				if((toLower _x) in _targetTags) then  {
					_tagsMatched = _tagsMatched + 1;
				};
			} forEach _loadoutNameParts;

			if(_tagsMatched > _foundLoadoutTagsMatched) then {
				_foundLoadoutTagsMatched = _tagsMatched;
				_foundLoadoutName = _loadoutName;
			};

			diag_log format["loadout '%1' matches %2 tags", _loadoutName, _tagsMatched];

		};

		if(_foundLoadoutName != "") then {
			systemChat format["Found loadout '%1' matches %2 tags", _foundLoadoutName, _foundLoadoutTagsMatched];
		} else {
			systemChat "No loadout found";
		};

		_foundLoadoutName;

	};

};





tawPlayerLoadoutName = [player, ["taw", mission_biome]] call tagBasedFindVirtualArsenalLoadout;	

playerLoadTawLoadout = {
	if(tawPlayerLoadoutName != "") then {
		[player, [profilenamespace, tawPlayerLoadoutName]] call BIS_fnc_loadInventory;	
	} else {
		[player, mission_biome] execVM "tag_based_loadouts_default.sqf";
	};
};

call playerLoadTawLoadout;

if(tag_based_loadouts_reload_on_respawn) then {
	player addEventHandler ["respawn", { call playerLoadTawLoadout; }];
};


