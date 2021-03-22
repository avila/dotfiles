

## workaround so far

```csharp
setxkbmap -print -verbose 10

xkb_keymap {
	xkb_keycodes  { include "evdev+aliases(qwertz)"	};
	xkb_types     { include "complete"	};
	xkb_compat    { include "complete+caps(caps_lock)+misc(assign_shift_left_action)+level5(level5_lock)"	};
	xkb_symbols   { include "pc+de(neo_qwertz)+inet(evdev)"	};
	xkb_geometry  { include "pc(pc105)"	};
};
```

## using LED

```csharp
default partial xkb_compatibility "caps_lock" {
    indicator "Num Lock" {
	!allowExplicit;
	whichModState= Locked;
	controls= Overlay1;
    };
};
```

## ressources

[Gnome Extension lock keys](https://extensions.gnome.org/extension/36/lock-keys/) recommended for visual
on lock layer currently active.

### further

Updating iomartin's answer from 2012-04-27: The documentation now lives at: https://www.charvolant.org/doug/xkb/html/node5.html

It is part of the "An Unreliable Guide to XKB Configuration" by Doug Palmer: https://www.charvolant.org/doug/xkb/html/xkb.html

Another introduction is "Changing Keyboard Layouts with XKB" by Michael Cardell Widerkrantz: https://hack.org/mc/writings/xkb.html

Or "A simple, humble but comprehensive guide to XKB for linux" by Damiano Venturin: https://medium.com/@damko/a-simple-humble-but-comprehensive-guide-to-xkb-for-linux-6f1ad5e13450

Other sources of information:

    Arch Linux Wiki: https://wiki.archlinux.org/index.php/X_keyboard_extension
    The XKB specification itself: https://www.x.org/releases/current/doc/kbproto/xkbproto.html

There are also tools to assist with generating a layout configuration, like kbdgen: https://divvun.github.io/kbdgen/


### Stack overflow

https://superuser.com/questions/801611/how-to-make-all-applications-respect-my-modified-xkb-layout
