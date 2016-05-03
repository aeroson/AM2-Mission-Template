// set tfar settings, default frequencies and so on

tf_no_auto_long_range_radio = true; // Disables automatic distribution of backpack radios to group leaders
TF_give_personal_radio_to_regular_soldier = false; // Enables distribution of commander radios to squadmates.
tf_same_sw_frequencies_for_side = true; // Generates identical short range radio settings for the entire faction.
tf_same_lr_frequencies_for_side = true; // Generates identical long range radio settings for the entire faction.


// frequencies set according to http://puu.sh/olQI5/cf61fcb740.jpg


/*
0: NUMBER - Active channel
1: NUMBER - Volume
2: ARRAY - Frequencies for channels
3: NUMBER - Stereo setting
4: STRING - Encryption code
5: NUMBER - Additional active channel
6: NUMBER - Additional active channel stereo mode
7: OBJECT - Owner
8: NUMBER - Speaker mode
*/
// preset SW radio settings
tf_freq_west = [0,7,["50","40","41","42","43","44","45","69"],0,nil,-1,0,getPlayerUID player,false];
tf_freq_east = tf_freq_west;
tf_freq_guer = tf_freq_west;



/*
0: NUMBER - Active channel
1: NUMBER - Volume
2: ARRAY - Frequencies for channels
3: NUMBER - Stereo setting
4: STRING - Encryption code
5: NUMBER - Additional active channel
6: NUMBER - Additional active channel stereo mode
7: NUMBER - Speaker mode
*/
// preset LR radio settings
tf_freq_west_lr = [0,7,["50","80","80","71","72","73","69","44","45"],0,nil,-1,0,false];
tf_freq_east_lr = tf_freq_west_lr;
tf_freq_guer_lr = tf_freq_west_lr;