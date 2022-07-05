## link custom file to xkb folder

```
# link xy to system location
sudo ln -sr ./xy /usr/share/X11/xkb/symbols/xy

# set alredy layout
setxkbmap xy -variant xy5levels
```

## Modify /usr/share/X11/xkb/rules/evdev.xml

Include the following lines in the evdev.xml file in order to be able to pick this layout 
from the keyboard settings in the settings manager 


```
    <!-- Keyboard indicator for Custom German Layouts -->
    <layout>
      <configItem>
        <name>xy</name>
        <shortDescription>xy</shortDescription>
        <description>XY (German - base)</description>
        <languageList>
          <iso639Id>ger</iso639Id>
        </languageList>
      </configItem>
      <variantList>
        <variant>
          <configItem>
            <name>xy5levels</name>
           <description>XY (German - xy5levels)</description>
          </configItem>
        </variant>
        <variant>
          <configItem>
            <name>xy3levels</name>
           <description>XY (German - xy3levels)</description>
          </configItem>
        </variant>
        <variant>
          <configItem>
            <name>caps_overlay</name>
           <description>XY (German - Caps Overlay)</description>
          </configItem>
        </variant>
      </variantList>
    </layout>
    <!-- End of Custom German Layouts -->```
```

It might be neeeded to run `sudo dpkg-reconfigure xkb-data` (or restart) in order to show the custom layout

##  XKB in Wayland 

### Custom keyboard layout in Wayland like Xmodmap in X11

link: https://blog.stigok.com/2020/10/27/from-x11-xmodmap-to-wayland-xkb-custom-keyboard-layout.html


## Optional 


```
// edit  /usr/share/X11/xkb/compat/ledcaps to use led indicator for overlay1 control mod

default partial xkb_compatibility "caps_lock" {
    indicator "Caps Lock" {
	!allowExplicit;
	whichModState= Locked;
	#modifiers= Lock;
	controls=Overlay1;
    };
};

```
