



/*
if set to true, 
it will try to remove anything in primary or handgun weapon silencer attachment slot
it does so every second
*/
automatically_remove_silencers = false; 
// default: false
// possible values: false, true







/*
modifies the distance radios think they are at,

if two players are 100 meters apart
value of 1000 will make radios think players are 1000 * 100 meters = 100 000 meters apart
value of 0.001 will make radios think players are 0.001 * 100 meters = 0.1 meters apart

you can use it to increase radio range, so value of 0.001 = 1 / 1000 will increase the rando of radios 1000 times
it's good idea to do so on large terrains such as takistan

or you can use it so simulate radio jamming, 
so value of 1000 will make it seem like the radios are jammed since you would only be able to hear radios really close to you
*/
tfar_radios_sending_distance_multiplicator = 1;
// default: 1


