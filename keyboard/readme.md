// edit  /usr/share/X11/xkb/compat/ledcaps to use led indicator for overlay1 control mod
default partial xkb_compatibility "caps_lock" {
    indicator "Caps Lock" {
	!allowExplicit;
	whichModState= Locked;
	#modifiers= Lock;
	controls=Overlay1;
    };
};