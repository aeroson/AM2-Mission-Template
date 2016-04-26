enableSaving[false,false];
enableEnvironment false;

// starts script to show all units on map for zeuses, because zeuses need to know what is going on
[] execVM 'unit_markers_for_zeus.sqf';



tf_no_auto_long_range_radio = true; // Disables automatic distribution of backpack radios to group leaders
TF_give_personal_radio_to_regular_soldier = false; // Enables distribution of commander radios to squadmates.
tf_same_sw_frequencies_for_side = true; // Generates identical short range radio settings for the entire faction.
tf_same_lr_frequencies_for_side = true; // Generates identical long range radio settings for the entire faction.


// preset SW radio settings
tf_freq_west = [0,7,["40","41","42","43","44","45","71","72","73"],0,-11,-1,0,"76561197995822692",false];
tf_freq_east = tf_freq_west;
tf_freq_guer = tf_freq_west;

// preset LR radio settings
tf_freq_west_lr = [0,7,["40","41","42","43","44","45","71","72","73","801"],0,-11,-1,0,false];
tf_freq_east_lr = tf_freq_west_lr;
tf_freq_guer_lr = tf_freq_west_lr;


//helicopter fastrope
[] execVM "zlt_fastrope.sqf";

// passes AI groups simulation to headless clients (HC for short), does noothing if HCs are not available, can use up to 3 HCs named HC, HC2, HC3
[] execVM "passToHCs.sqf";

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


		if(prevent_negative_rating) then {
			[] spawn {
				while{true} do {
					waitUntil {
						sleep 10;
						!isNUll(player) && rating player < 0
					};
					player addRating (-(rating player));
				};
			};
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
				private _unit;
				private _vehicle;
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
