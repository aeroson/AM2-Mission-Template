params [
	"_target",
	"_biome"
];




if(_biome == "woodland") then {


	//Rifleman Woodland
	comment "Exported from Arsenal by PHI [AM 2FS]";

	comment "Remove existing items";
	removeAllWeapons _target;
	removeAllItems _target;
	removeAllAssignedItems _target;
	removeUniform _target;
	removeVest _target;
	removeBackpack _target;
	removeHeadgear _target;
	removeGoggles _target;

	comment "Add containers";
	_target forceAddUniform "AOR2_Camo";
	_target addVest "AOR2_Vest_1";
	_target addItemToVest "ItemcTabHCam";
	_target addItemToVest "ACE_Flashlight_XL50";
	for "_i" from 1 to 5 do {_target addItemToVest "SmokeShell";};
	for "_i" from 1 to 2 do {_target addItemToVest "SmokeShellBlue";};
	for "_i" from 1 to 2 do {_target addItemToVest "rhsusf_mag_15Rnd_9x19_JHP";};
	for "_i" from 1 to 7 do {_target addItemToVest "SMA_30Rnd_556x45_M855A1";};
	_target addItemToVest "HandGrenade";
	for "_i" from 1 to 2 do {_target addItemToVest "rhs_mag_m67";};
	_target addBackpack "B_AssaultPack_dgtl";
	for "_i" from 1 to 30 do {_target addItemToBackpack "ACE_quikclot";};
	for "_i" from 1 to 2 do {_target addItemToBackpack "ACE_EarPlugs";};
	for "_i" from 1 to 30 do {_target addItemToBackpack "ACE_packingBandage";};
	for "_i" from 1 to 4 do {_target addItemToBackpack "ACE_tourniquet";};
	_target addItemToBackpack "ACE_EntrenchingTool";
	_target addHeadgear "AOR2_Helmet2";
	_target addGoggles "rhs_googles_black";

	comment "Add weapons";
	_target addWeapon "SMA_M4MOE_OD_SM";
	_target addPrimaryWeaponItem "rhsusf_acc_anpeq15A";
	_target addPrimaryWeaponItem "optic_Hamr";
	_target addPrimaryWeaponItem "SMA_Gripod_01";
	_target addWeapon "rhsusf_weap_m9";
	_target addWeapon "Laserdesignator";

	comment "Add items";
	_target linkItem "ItemMap";
	_target linkItem "ItemCompass";
	_target linkItem "ItemWatch";
	_target linkItem "tf_anprc152_2";
	_target linkItem "ItemcTab";
	_target linkItem "NVGoggles_INDEP";

	comment "Set identity";
	_target setFace "GreekHead_A3_05";
	_target setSpeaker "ACE_NoVoice";


} else {	


	//Rifleman Desert
	comment "Exported from Arsenal by PHI [AM 2FS]";

	comment "Remove existing items";
	removeAllWeapons _target;
	removeAllItems _target;
	removeAllAssignedItems _target;
	removeUniform _target;
	removeVest _target;
	removeBackpack _target;
	removeHeadgear _target;
	removeGoggles _target;

	comment "Add containers";
	_target forceAddUniform "AOR1_Camo_SS";
	_target addVest "AOR1_Vest_1";
	_target addItemToVest "ItemcTabHCam";
	_target addItemToVest "ACE_Flashlight_XL50";
	for "_i" from 1 to 5 do {_target addItemToVest "SmokeShell";};
	for "_i" from 1 to 2 do {_target addItemToVest "SmokeShellBlue";};
	for "_i" from 1 to 2 do {_target addItemToVest "rhsusf_mag_15Rnd_9x19_JHP";};
	for "_i" from 1 to 7 do {_target addItemToVest "SMA_30Rnd_556x45_M855A1";};
	_target addItemToVest "HandGrenade";
	for "_i" from 1 to 2 do {_target addItemToVest "rhs_mag_m67";};
	_target addBackpack "B_AssaultPack_cbr";
	for "_i" from 1 to 30 do {_target addItemToBackpack "ACE_quikclot";};
	for "_i" from 1 to 2 do {_target addItemToBackpack "ACE_EarPlugs";};
	for "_i" from 1 to 30 do {_target addItemToBackpack "ACE_packingBandage";};
	for "_i" from 1 to 4 do {_target addItemToBackpack "ACE_tourniquet";};
	_target addItemToBackpack "ACE_EntrenchingTool";
	_target addHeadgear "AOR1_Helmet2";
	_target addGoggles "rhs_googles_black";

	comment "Add weapons";
	_target addWeapon "SMA_M4MOE_Tan_SM";
	_target addPrimaryWeaponItem "rhsusf_acc_anpeq15A";
	_target addPrimaryWeaponItem "optic_Hamr";
	_target addPrimaryWeaponItem "SMA_Gripod_01";
	_target addWeapon "rhsusf_weap_m9";
	_target addWeapon "Laserdesignator";

	comment "Add items";
	_target linkItem "ItemCompass";
	_target linkItem "ItemWatch";
	_target linkItem "tf_anprc152_1";
	_target linkItem "ItemcTab";
	_target linkItem "NVGoggles";

	comment "Set identity";
	_target setFace "GreekHead_A3_05";
	_target setSpeaker "ACE_NoVoice";


};