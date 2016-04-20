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



// load config values
call compile preprocessFileLineNumbers "config.sqf";


if(hasInterface) then {

	0 = [] spawn {

		waitUntil {!isNull(player)};

		if(tfar_radios_sending_distance_multiplicator != 1) then {
			player setVariable ["tf_sendingDistanceMultiplicator", tfar_radios_sending_distance_multiplicator]; 
		};


		if(automatically_remove_silencers) then {
			spawn {
				while{true} do {
					waitUntil {!isNull(player)};
					_silencer = (primaryWeaponItems player) select 0;
					if(_silencer != "") then { player removePrimaryWeaponItem _silencer; };
					_silencer = (handgunItems player) select 0;
					if(_silencer != "") then { player removeHandgunItem _silencer; };
					sleep 1;
				};
			};
		};

	};

};
