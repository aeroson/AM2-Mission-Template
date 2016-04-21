enableSaving[false,false];
enableEnvironment false;

// starts script to show all units on map for zeuses, because zeuses need to know what is going on
execVM 'unit_markers_for_zeus.sqf';

// prevent automatic tfar LR backpack on squad leaders
tf_no_auto_long_range_radio = true; 

//helicopter fastrope
execVM "zlt_fastrope.sqf";

// passes AI groups simulation to headless clients (HC for short), does noothing if HCs are not available, can use up to 3 HCs named HC, HC2, HC3
execVM "passToHCs.sqf";

// adds briefing page with useful actions, the page is only visible to admin or zeuses
execVM "admin_or_zeus_actions.sqf";


// load config values
call compile preprocessFileLineNumbers "config.sqf";


if(hasInterface) then {

	[] spawn {

		waitUntil {!isNull(player)};

		if(tfar_radios_sending_distance_multiplicator != 1) then {
			player setVariable ["tf_sendingDistanceMultiplicator", tfar_radios_sending_distance_multiplicator]; 
		};


		if(automatically_remove_silencers || automaticaly_remove_night_vision) then {

			[] spawn {

				private _silencer = "";
				private _nightVision = "";

				while{true} do {

					waitUntil {!isNull(player)};					

					if(automatically_remove_silencers) then {
						_silencer = (primaryWeaponItems player) select 0;
						if(_silencer != "") then { player removePrimaryWeaponItem _silencer; };
						_silencer = (handgunItems player) select 0;
						if(_silencer != "") then { player removeHandgunItem _silencer; };
					};

					if(automaticaly_remove_night_vision) then {
						_nightVision = hmd player;
						if(_nightVision != "") then {
							player unassignItem _nightVision;
							player removeItem _nightVision;
						};
					};

					sleep 1;
				};

			};

		};





		if(force_first_person_camera_in_soldier || force_first_person_camera_in_ground_vehicles || force_first_person_camera_in_air_vehicles) then {
			[] spawn {

				while{true} do {

					waitUntil {!isNull(player)};									

					if (cameraView == "External") then {
						private _unit = player;
						private _vehicle = vehicle _unit;
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

					sleep 0.1;
				};

			};

		};




	};

};
