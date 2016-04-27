// set tfar settings, default frequencies and so on

tf_no_auto_long_range_radio = true; // Disables automatic distribution of backpack radios to group leaders
TF_give_personal_radio_to_regular_soldier = false; // Enables distribution of commander radios to squadmates.
tf_same_sw_frequencies_for_side = true; // Generates identical short range radio settings for the entire faction.
tf_same_lr_frequencies_for_side = true; // Generates identical long range radio settings for the entire faction.


// frequencies set according to http://puu.sh/olQI5/cf61fcb740.jpg


// preset SW radio settings
tf_freq_west = [0,7,["40","41","42","43","44","45","98","73"],0,nil,-1,0,"76561197995822692",false];
tf_freq_east = tf_freq_west;
tf_freq_guer = tf_freq_west;

// preset LR radio settings
tf_freq_west_lr = [0,7,["80","80","80","71","72","73","98","44","45"],0,nil,-1,0,false];
tf_freq_east_lr = tf_freq_west_lr;
tf_freq_guer_lr = tf_freq_west_lr;