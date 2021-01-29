# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

####  IMPORTANT IMPORTS ####
import os
import re
import socket
import subprocess
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget
from typing import List  # noqa: F401

#### DEFINING VARIABLES ##

mod = "mod4"
myTerm = "st"

#### KEYBINDINGS ####

keys = [
    # Switch between windows in current stack pane
    Key([mod], "k",
        lazy.layout.down(),
        desc='Move focus down in the current stack pane'
        ),
    Key([mod], "j",
        lazy.layout.up(),
        desc='Move focus up in the current stack pane'),

    # Move windows up or down in current stack
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_down(),
        desc='Move wiondows down in the current stack'
        ),
    Key([mod, "shift"], "j",
        lazy.layout.shuffle_up(),
        desc='Move windows up in the current stack'
        ),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space",
        lazy.layout.next()
        ),

    # Swap panes of split stack
    Key([mod, "shift"], "space",
        lazy.layout.rotate(),
        lazy.layout.flip(),
        desc='Switch which side main pane occupies (XmonadTall)'
        ),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], "Return", lazy.spawn(myTerm)),

    # Toggle between different layouts as defined below
    Key([mod], "Tab",
        lazy.next_layout(),
        desc='Toggle through layouts'
        ),
    Key([mod], "q",
        lazy.window.kill(),
        desc='Kill active window'
        ),

    Key([mod, "shift"], "r",
        lazy.restart(),
        desc='Restart Qtile'
        ),
    Key([mod, "shift"], "Return",
            lazy.spawn("dmenu_run -p 'Run: '"),
            desc='Backup dmenu in case Mod+d doesn`t work'
            ),
    Key([mod], "o",
            lazy.spawncmd()
            ),
    # Exit Qtile
         Key([mod, "shift"], "q",
             lazy.shutdown(),
             desc='Shutdown Qtile'
             ),
]

#### GROUPS ####
group_names = [("1", {'layout': 'monadtall'}),
               ("2", {'layout': 'monadtall'}),
               ("3", {'layout': 'monadtall'}),
               ("4", {'layout': 'monadtall'}),
               ("5", {'layout': 'monadtall'}),
               ("6", {'layout': 'monadtall'}),
               ("7", {'layout': 'monadtall'}),
               ("8", {'layout': 'monadtall'}),
               ("9", {'layout': 'monadtall'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        # Switch to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group

#### DEFAULT LAYOUTS SETTINGS #####
layout_theme = {"border_width": 2,
                "margin": 17,
                "border_focus": "#123a75",
                "border_normal": "#ffffff"
                }

#### LAYOUTS ####
layouts = [
    #layout.Bsp(**layout_theme),
    #layout.Stack(stacks=2, **layout_theme),
    #layout.Columns(**layout_theme),
    #layout.RatioTile(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Matrix(**layout_theme),
    #layout.Zoomy(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Max(**layout_theme),
    layout.Tile(shift_windows=True, **layout_theme),
    layout.Stack(num_stacks=2),
    layout.TreeTab(
         font = "Fantasque Sans Mono",
         fontsize = 10,
         sections = ["FIRST", "SECOND"],
         section_fontsize = 11,
         bg_color = "141414",
         active_bg = "90C435",
         active_fg = "000000",
         inactive_bg = "384323",
         inactive_fg = "a0a0a0",
         padding_y = 5,
         section_top = 10,
         panel_width = 320
         ),
    layout.Floating(**layout_theme)
]

#### COLORS ####
colors = [["#000000", "#000000"], # panel background
          ["#123a75", "#123a75"], # background for current screen tab
          ["#ffffff", "#ffffff"], # font color for group names
          ["#cce6ff", "#cce6ff"], # border line color for current tab
          ["#68b6ff", "#68b6ff"], # border line color for other tab and odd widgets
          ["#123a75", "#123a75"], # color for the even widgets
          ["#ffffff", "#ffffff"]] # window name

#### PROMPT ####
prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())


#### WIDGETS DEFAULT SETTINGS ####
widget_defaults = dict(
    font="Fantasque Sans Mono",
    fontsize = 15,
    padding = 2,
    background=colors[2]
)
extension_defaults = widget_defaults.copy()

#### MOUSE CALLBACKS ####

def cpu_hogs(qtile):
    qtile.cmd_spawn('notify-send "🖥 CPU hogs" "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head)\\n(100% per core)"')

#### BAR AND WIDGETS ####

screens = [
    Screen(
        top=bar.Bar(
            [
                          widget.Sep(
                       linewidth = 0,
                       padding = 6,
                       foreground = colors[2],
                       background = colors[0]
                       ),
              widget.Image(
                       filename = "~/.config/qtile/icons/python.png",
                       mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn('dmenu_run')}
                       ),
              widget.GroupBox(
                       font = "Fantasque Sans Mono",
                       fontsize = 15,
                       margin_y = 3,
                       margin_x = 0,
                       padding_y = 5,
                       padding_x = 3,
                       borderwidth = 3,
                       active = colors[2],
                       inactive = colors[2],
                       rounded = False,
                       highlight_color = colors[1],
                       highlight_method = "line",
                       this_current_screen_border = colors[3],
                       this_screen_border = colors [4],
                       other_current_screen_border = colors[0],
                       other_screen_border = colors[0],
                       foreground = colors[2],
                       background = colors[0],
                       hide_unused = True
                       ),
              widget.Sep(
                       linewidth = 0,
                       padding = 5,
                       foreground = colors[2],
                       background = colors[0]
                       ),
              widget.WindowName(
                       foreground = colors[6],
                       background = colors[0],
                       padding = 0,
                       fontsize = 15
                       ),
            widget.TextBox(
                       text = '',
                       background = colors[0],
                       foreground = colors[5],
                       padding = 0,
                       fontsize = 49
                       ),
            widget.TextBox(
                    text = '🖥',
                    background = colors[5],
                    foreground = colors[2],
                    fontsize = 12
                    ),
            widget.CPU(
                    fontsize = 12,
                    background = colors[5],
                    foreground = colors[2],
                    format = '{load_percent}%',
                    ),
              widget.TextBox(
                       text = '',
                       background = colors[5],
                       foreground = colors[4],
                       padding = 0,
                       fontsize = 49
                       ),
              widget.TextBox(
                       text = '🧠',
                       background = colors[4],
                       foreground = colors[5],
                       fontsize = 12
                       ),
              widget.Memory(
                      fontsize = 12,
                      background = colors[4],
                      foreground = colors[6],
                      format = '{MemUsed}M'
                      ),
              widget.TextBox(
                       text = '',
                       background = colors[4],
                       foreground = colors[5],
                       padding = 0,
                       fontsize = 49
                       ),
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
              widget.TextBox(
                       text='',
                       background = colors[5],
                       foreground = colors[4],
                       padding = 0,
                       fontsize = 49
                       ),
              widget.TextBox(
                       text = "📦",
                       padding = 2,
                       foreground = colors[2],
                       background = colors[4],
                       fontsize = 14
                       ),
              widget.TextBox(
                       text = '',
                       background = colors[4],
                       foreground = colors[5],
                       padding = 0,
                       fontsize = 49
                       ),
              widget.TextBox(
                      text = "🔊",
                       foreground = colors[2],
                       background = colors[5],
                       padding = 0
                       ),
              widget.PulseVolume(
                       foreground = colors[2],
                       background = colors[5],
                       padding = 5,
                       fontsize = 12
                       ),
              widget.TextBox(
                       text = '',
                       background = colors[5],
                       foreground = colors[4],
                       padding = 0,
                       fontsize = 49
                       ),
              widget.CurrentLayoutIcon(
                       custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
                       foreground = colors[0],
                       background = colors[4],
                       padding = 0,
                       scale = 0.7
                       ),
              widget.CurrentLayout(
                       foreground = colors[2],
                       background = colors[4],
                       padding = 5,
                       fontsize = 12
                       ),
              widget.TextBox(
                       text = '',
                       background = colors[4],
                       foreground = colors[5],
                       padding = 0,
                       fontsize = 49
                       ),
              widget.Clock(
                       foreground = colors[2],
                       background = colors[5],
                       fontsize = 12,
                       format = "%Y/%m/%d %H:%M:%S"
                       ),
              widget.Sep(
                       linewidth = 0,
                       padding = 10,
                       foreground = colors[0],
                       background = colors[5]
                       ),
              widget.Systray(
                       background = colors[0],
                       padding = 5
                       ),
                ],
            24,
        ),
    ),
]

#### DRAG FLOATING WINDOWS ####
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

#### FLOATING WINDOWS ####
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
    {'wmclass': 'Pinentry-gtk-2'},
    {'wmclass':'Wine'},
    {'wmclass':'Steam'},
    {'wmclass':'Galculator'},
    {'wmclass':'Dragon-drag-and-drop'}
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
