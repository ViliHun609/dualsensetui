# dualsensetui
 A REALLY simple Linux TUI for dualsensectl with Hyprland implementations.

(it's kinda vibe coded but i think it still can be useful for other so i publish it.)

## Things that dualsensetui can do at the moment:

- Turn off controller ✅
- Display battery level of your controller ❌
- Display other information of the controller ✅

## Supported Distros

| Distro     | Supported                                     |
| ---------- | --------------------------------------------- |
| Arch Linux | ✅/❌ (maybe ATM, it works on omarchy for sure) |
| Ubuntu     | ❌                                             |
| Fedora     | ❌                                             |
| Debian     | ❌                                             |

*This list will be greatly improved in the near future. I will use visualization tools for the tests*

## Roadmap

| Milestone            | Description                                                  | Status      |
| :------------------- | :----------------------------------------------------------- | :---------- |
| Waybar module        | A simple waybar module to open the TUI                       | Planned     |
| Installer file       | An Executable file that could install dualsensetui with all required packages. | In progress |
| Updater              | Built in UI option that can scan for newer versions of dualsenseTUI | Planned     |
| Other Distro support | Fully support other distributions like Ubuntu or Fedora.     | Planned     |
| On screen pop-up     | A keybind that will open the TUI in a window in the right upper corner of the screen, something like this ![](https://github.com/Seyloria/sinkswitch/raw/main/example.jpg) | Planned     |



## Installation

### Arch (Work in Progress)

Run this command to install the latest version of dualsenseTUI.

At the current state it does not install any dependencies, which means how need them before the install.

`curl -s https://raw.githubusercontent.com/ViliHun609/dualsensetui/master/test.sh | sudo tee /usr/local/bin/dualsensetui > /dev/null && sudo chmod +x /usr/local/bin/dualsensetui`



## Dependencies

- dualsensectl
  - dbus
  - hidapi
  - system-libs

- fzf



## The program relies on [@nowrep](https://github.com/nowrep) 's dualsensectl which is the core of this program. 

## Dualsensectl repository: https://github.com/nowrep/dualsensectl

