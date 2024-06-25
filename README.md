# configs
Dialga's config files. Feel free to download them lul
These are based of Luke Smith's and Brodie Robertsons dotfiles. Go check them out they cool.
# Installation
To install these you need to clone this repo, and copy .config and .local to your home directory.
# Installation with LARBS
If you're using an Arch-based GNU/Linux distro, you can also install these via Luke Smith's LARBS script. However I'm just trying it out.
You install it by running the following commands as root:
```
sh larbs.sh -r https://github.com/Kho-Dialga/configs.git -p https://raw.githubusercontent.com/Kho-Dialga/configs/master/progs.csv

```
If you're going to run this inside of a virtual machine, remove the following lines from .config/qtile/config.py
```
              widget.TextBox(
                       text = "🌡",
                       padding = 2,
                       foreground = colors[2],
                       background = colors[5],
                       fontsize = 11
                       ),
              widget.ThermalSensor(
                       foreground = colors[2],
                       background = colors[5],
                       threshold = 90,
                       padding = 5,
                       fontsize = 12
                       ),
```
