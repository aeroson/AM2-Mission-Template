enableSaving[false,false];
enableEnvironment false;

// load config values
call compile preprocessFileLineNumbers "config_defaults.sqf";
call compile preprocessFileLineNumbers "config.sqf";

// set tfar settings, default frequencies and so on
call compile preprocessFileLineNumbers "tfar_settings.sqf";


// starts script to show all units on map for zeuses, because zeuses need to know what is going on
handle_unit_markers_for_zeus = execVM 'unit_markers_for_zeus.sqf';

// helicopter fastrope
handle_zlt_fastrope = execVM "zlt_fastrope.sqf";

// passes AI groups simulation to headless clients (HC for short), does noothing if HCs are not available, can use up to 3 HCs named HC, HC2, HC3
handle_passToHCs = execVM "passToHCs.sqf";

// adds briefing page with useful actions, the page is only visible to admin or zeuses
handle_admin_or_zeus_actions = execVM "admin_or_zeus_actions.sqf";

// cleansup stuff that is far away from players
handle_repetitive_cleanup = execVM "repetitive_cleanup.sqf";


if(tag_based_loadouts) then {
	handle_tag_based_loadouts = execVM "tag_based_loadouts.sqf";
};

	






handle_empty_group_removal = [] spawn {
	
	while{true} do {
		sleep 60;
		// if there is over certain number of groups (162?) you can not create new groups anymore
		// lets delete empty groups then
		{
			if(local _x && count units _x == 0) then {
				deleteGroup _x;
				sleep 1;
			};
		} forEach allGroups;		
	};

};


// player only
if(hasInterface) then {

	[] spawn {	

		waitUntil {!isNull(player)};
		private _target = player;

		if(tfar_radios_distance_multiplicator != 1) then {
			player setVariable ["tf_receivingDistanceMultiplicator", tfar_radios_distance_multiplicator]; 
		};

		if(strip_players_on_server_join) then {			
			removeAllWeapons _target;
			removeUniform _target;
			removeVest _target;
			removeBackpack _target;
			removeGoggles _target;
			removeHeadGear _target;
			removeAllAssignedItems _target;
		};

		if(prevent_negative_rating || automatically_reveal_all_players) then {
			handle_taw_1 = [] spawn {
				while{true} do {
					waitUntil {
						sleep 10;
						!isNUll(player)
					};
					if(prevent_negative_rating && rating player < 0) then {
						player addRating (-(rating player));
					};
					if(automatically_reveal_all_players) then {
						{
							private _y = _x;
							private _g = group _x;
							{
								if(_y knowsAbout _x < 4) then {
									_y reveal [_x, 4];
								};
								if(_g knowsAbout _x < 4) then {
									_g reveal [_x, 4];
								};
							} forEach allPlayers;
						} forEach allPlayers;
					};
				};
			};
		};

		if(automatically_remove_post_vietnam_technology) then {
			{
				automatically_remove_classnames pushBackUnique _x;
			} forEach ["ACE_Cellphone","ACE_HuntIR_monitor","ACE_Kestrel4500","ItemAndroid","ACE_Altimeter"];
			automatically_remove_gps = true;
			automatically_remove_short_range_radio = true;
			automatically_remove_night_vision = true;
		};

		if(automatically_remove_gps) then {
			{
				automatically_remove_classnames pushBackUnique _x;
			} forEach ["ALIVE_Tablet","ACE_DAGR","ACE_microDAGR","B_UavTerminal","O_UavTerminal","I_UavTerminal","ItemcTab","ItemMicroDAGR","ItemGPS"];
		};

		if(automatically_remove_short_range_radio) then {
			// from https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki/API%3A-Classes
			{
				automatically_remove_classnames pushBackUnique _x;
			} forEach ["tf_anprc152","tf_anprc148jem","tf_fadak","tf_rf7800str","tf_anprc154","tf_pnr1000a","tf_microdagr"];
		};		

		if(automatically_remove_silencers || automatically_remove_night_vision || count automatically_remove_classnames > 0 || set_no_voice_to_all_units) then {
			handle_taw_2 = [] spawn {
				private _silencer = "";
				private _nightVision = "";
				while{true} do {
					waitUntil {!isNull(player)};					
					private _target = player;

					if(automatically_remove_silencers) then {
						_silencer = (primaryWeaponItems _target) select 0;
						if(_silencer != "") then { _target removePrimaryWeaponItem _silencer; };
						_silencer = (handgunItems _target) select 0;
						if(_silencer != "") then { _target removeHandgunItem _silencer; };
					};
					if(automatically_remove_night_vision) then {
						_nightVision = hmd _target;
						if(_nightVision != "") then {
							_target unassignItem _nightVision;
							_target removeItem _nightVision;
						};
					};
					if(count automatically_remove_classnames > 0) then {
						{
							private _classname = _x;
							private _isClassnameRadio = false;
							if(!isNil{TFAR_fnc_isPrototypeRadio}) then {
								_isClassnameRadio = _classname call TFAR_fnc_isPrototypeRadio;
							};

							{
								if(_x == _classname || {(_isClassnameRadio && {[_x, _classname] call TFAR_fnc_isSameRadio})}) then {
									_target unassignItem _x;
									_target removeItem _x;
								}							
							} forEach assignedItems _target;

							{
								if(_x == _classname || {(_isClassnameRadio && {[_x, _classname] call TFAR_fnc_isSameRadio})}) then {
									_target removeItem _x;
								}							
							} forEach (uniformItems _target) + (vestItems _target) + (backpackItems _target);

						} forEach automatically_remove_classnames;
					};

					if(set_no_voice_to_all_units) then {						
						{
							if(local _x) then {
								if(speaker _x != "ACE_NoVoice") then {
									_x setSpeaker "ACE_NoVoice";
								};
								_x disableConversation true;
							};
						} forEach allUnits;
					};

					sleep 1;
				};
			};
		};

		if(force_first_person_camera_in_soldier || force_first_person_camera_in_ground_vehicles || force_first_person_camera_in_air_vehicles) then {
			handle_taw_3 = [] spawn {
				private _unit = player;
				private _vehicle = vehicle _unit;
				while{true} do {
					waitUntil {
						sleep 0.0;
						!isNUll(player) && cameraView == "External"
					};
					_unit = player;
					_vehicle = vehicle _unit;
					if(_vehicle != _unit && !(_vehicle isKindOf "ParachuteBase")) then {
						if(_vehicle isKindOf "Air") then {
							if(force_first_person_camera_in_air_vehicles) then {
								player switchCamera "Internal";
							};
						} else {
							if(force_first_person_camera_in_ground_vehicles) then {
								player switchCamera "Internal";
							};
						};
					} else {
						if(force_first_person_camera_in_soldier) then {
							player switchCamera "Internal";
						};
					};
				};
			};
		};




	};

};






