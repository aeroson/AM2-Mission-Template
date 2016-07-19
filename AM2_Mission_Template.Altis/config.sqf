// the config file, everything a mission maker could ever need should be configurable here.


/*
defines the fauna (biome) of the map or mission
is used for automatic loadout selection
*/
mission_biome = "woodland";
// default value: "woodland"
// possible values: "woodland", "desert"



/*
if set to true:
it will try to remove said items
it does so every second
*/
automatically_remove_night_vision = false; // nightvision in nightvision slot
automatically_remove_gps = false; // all items that provide gps functionality (gps, dagr, tablet) in one from on another
automatically_remove_short_range_radio = false; // short range hand held radios
automatically_remove_post_vietnam_technology = false; // removes all above and some additional items, useful for vietnam (or pre vietnam) missions
automatically_remove_silencers = false; // silencers on primary weapon and handgun
// default value: false
// possible values: false, true



/*
classnames of items to automatically remove from player's inventory and slots
*/
automatically_remove_classnames = [];
// default value: []
// possible values: array of strings



/*
units speaking can be annoying to both zeuses and players,
if set to true all units will repeatedly be set to use the ACE_NoVoice vocie
*/
set_no_voice_to_all_units = true;
// default value: false
// possible values: false, true



/*
if set to true:
will strip players once they join server,
to ensure they don't spawn with some items you don't want them to use
*/
strip_players_on_server_join = false;
// default value: false
// possible values: false, true



/*
modifies the distance radios think they are at,

if two players are 100 meters apart
value of 1000 will make radios think those two players are 1000 * 100 meters = 100 000 meters apart
value of 0.001 will make radios think those two players are 0.001 * 100 meters = 0.1 meters apart

you can use it to increase radio range, so value of 0.001 = 1 / 1000 will increase the range of radios 1000 times
it's good idea to do so on large terrains such as takistan

or you can use it so simulate radio jamming, 
so value of 1000 will make it seem like the radios are jammed since you would only be able to hear radios really close to you
*/
tfar_radios_distance_multiplicator = 1;
// default value: 1
// possible values: floating point number https://community.bistudio.com/wiki/Floating_Point_Number



/*
selective forcing of first person camera
in_soldier = when player is playing as solder, not in any vehicle
in_air_vehicles = jet, helicopters, uavs?
in_ground_vehicle = the rest
*/
force_first_person_camera_in_soldier = false;
force_first_person_camera_in_ground_vehicles = false;
force_first_person_camera_in_air_vehicles = false;
// default value: false
// possible values: false, true



/*
Someone in the vehicle might have somehow team killed and his rating is below 0,
He is now considered a team killer and hostile to AI on his side.
Thus you can not get into same vehicle with him. 
For example driver or commander of vehicle technically team kills his crew when it gets blown up by enemy
and he is then considered a teamkiller (his rating is decreased) and AI will attack him.
You can Pardon the team killer with ACE interaction.
Or set this to true to reset his rating back to 0 if it's under 0.
The check is performed every 10 seconds.
*/
prevent_negative_rating = true;
// default value: true
// possible values: false, true



/*
Automatically constantly reveals all players to local player.
See: https://github.com/michail-nikolaev/task-force-arma-3-radio/issues/1078
Used to fix TFAR bug.
*/
automatically_reveal_all_players = true;
// default value: false
// possible values: false, true



/*
Load arsenal loadouts on respawn and join.
Loadouts are chosen based on tags.
Tags are role selection (and loadout) names split by the following characters: -.,=/() and space
Script loads the loadout that matches the greatest number of tags.
*/
tag_based_loadouts = true;
tag_based_loadouts_reload_on_respawn = false;
// default value: false
// possible values: false, true



/*
Restores last player's loadout on respawn.
Workaround until ACE3 fixes theirs.
*/
restore_player_loadout_on_respawn = true;
// default value: false
// possible values: false, true




/*
MAYBE TODO:
more tfar settings
ttfar different or same encryption key
enable/disable to pickup enemy radios
automatic switching to side based on your uniform
*/