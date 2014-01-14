dotfiles
========

Arch Linux with i3 WM config
running on a Thinkpad X1 Carbon
Optimized to my personal use, feel free to edit to
suit your needs

# i3 Configuration

## Requirements
### general
* arch linux - basic system
* i3 - window manager
* i3status - status bar
* dunst - notifications
* dmenu - Super-P launcher
* feh - setting background
* alsamixer - sound

### recommended
* sublime-text - text editor
* google-chrome - browser
* gnome-terminal - terminal emulator

##Basic Bindings
* Super - Standard modifier
* Super+Enter - open terminal
* Super+Shift+Enter - open nautilus
* Super+Backslash - open terminal interactively
* Super+Shift+Backslash - open nautilus interactively
* Alt+F4 - kill focused window
* Super+d - program launcher (dmenu)
* Super+{h,j,k,l} - focus left, down, up, right (vim based)
* Super+{v,g} - split vertical, horizontal 
* Super+f - fullscreen
* Super+s - stacking layout
* Super+w - tabbed layout
* Super+e - toggle splitted layout
* Super+Shift+Space - toggle floating mode
* Super+Space - toggle focus floating
* Super+a - focus parent container
* Super+F2 - Rename workspace (not recommended)
* Super+{1,2,3,4,5,6,7,8,9,0} - switch workspaces
* Super+Shift+{1,2,3,4,5,6,7,8,9,0} - move container to ws
* Super+o - move workspace to next output (e.g. displayport)
* Super+p - move window to displayport (for presentations)
* Super+Shift+c - reload i3 configuration
* Super+Shift+r - restart i3, used for upgrading
* Super+Shift+e - logs out of i3
* Super+r - switch to window resize mode
* Alt+Tab - focus right window
* Alt+Shift+Tab - focus left window
* Super+Tab - workspace "back-and-forth"
* Super+PageDown - focus next workspace 
* Super+PageUp - focus previous workspace
* Super+b - start google chrome
* Super+c - start sublime-text
* Print - make screenshots, see config for modifiers
* Super+Shift+Minus - move focused window to scratchpad
* Super+Minux - show scratchpad
* Super+Escape - shutdown, reboot, lock interactively

Check out the .i3/config for more details.

##Workspace Layout
* 1: term: terminal (terminal: Super+Enter)
* 2: www: browser (chrome: Super+b)
* 3: three: coding (sublime: Super+c)
* 4: four: free
* 5: five: free
* 6: six: free
* 7: seven: steam
* 8: eight: free
* 9: DP: displayport (Super+p to move window here)
* 10: com: communication (pidgin, weechat, teamspeak)

##Screenshots
![i3 alsi](https://raw.github.com/mohlerm/dotfiles/master/img/i3_alsi.jpg)
![i3 terminal](https://raw.github.com/mohlerm/dotfiles/master/img/i3_terminal.jpg)
![i3 nautilus](https://raw.github.com/mohlerm/dotfiles/master/img/i3_nautilus.jpg)
![i3 chrome](https://raw.github.com/mohlerm/dotfiles/master/img/i3_chrome.jpg)
![i3 sublime](https://raw.github.com/mohlerm/dotfiles/master/img/i3_sublime.jpg)

# slim Configuration

Arch Theme - download at http://slim.berlios.de/themes01.php

# Sublime Color Theme

See https://github.com/mohlerm/sublime-color-scheme-numix-thinkpad
