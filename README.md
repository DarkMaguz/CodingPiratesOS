# CodingPiratesOS
This is a re-spin of the Debian Linux distribution suited for the needs of the Coding Pirates organization.

Latest builds can be found at: [darkmagus.dk/cpos](https://www.darkmagus.dk/cpos)

## Getting started guide

Curreently their is only one ISO to choose from. The future plan is to provide a 
better selection with focus on specific workshops. Workshops like Unity, Python, Arduino, etc.
For now the ISO is one big hunk of the very best development tools and programs available.

Pleace don't hesistate to contact me if you have any questions, comments or suggestions.

Start by downloading an ISO file from [https://www.darkmagus.dk/cpos/images/master/](https://www.darkmagus.dk/cpos/images/master/).

<details>
<summary>List of current tools and programs.</summary>

| Program | Description | Version |
| --- | --- | --- |
| Arduino IDE | Arduino IDE |  |
| Atom | Text editor |  |
| Brave | The web browser | 
| Codium | Text editor |  |
| Discord | The chat client |  |
| Docker | VM Containerization |  |
| Firefox | A web browser by Mozilla |  |
| GHex | GUI hex editor |  |
| Gimp | Image editor suit |  |
| Git | Version control |  |
| gitg | Gnome GUI client for git | |
| Chrome | The web browser from Google |  |
| KiCAD | Electronic schematic and PCB design software |  |
| Microsoft .NET SDK | .NET Framework |  |
| MonoDevelop | Text editor |  |
| NodeJS | JavaScript runtime |  |
| Python3 | Python runtime |  |
| Ruby | Ruby runtime |  |
| Signal | The messaging app |  |
| Slack | The chat client |  |
| Spotify | Music streaming app |  |
| Steam | The gaming store |  |
| Sublime | Text editor |  |
| Unity | Game engine | lates LTS |
| UnityHub | | |
| VirtualBox | Virtual machine manager |  |
| WineHQ | Wine is a free software package that allows you to run Windows applications on Linux. |  |
| Wireshark | The packet analyzer |  |

</details>

<br>

There are genneraly two ways to use ISO:
1. Use a flash drive
2. Use a virtual machine

## Creating USB flash drive

*TODO*

## Creating a VM

*TODO*

## TODO
1. - [x] Create a basic live boot iso
2. - [x] Customize boot splash screen
3. - [x] Set up CI server
4. - [x] Customize desktop
5. - [x] Add boot menu option for persistence
6. - [ ] Create a script/program that automates the making of a persistent USB flash drive
7. - [x] Comprihensive list of programs
8. - [ ] Harware support for devices
        * [x] Oculus Quest 2
9. - [ ] Make documentation
      * [ ] User guides
        - [x] Getting started guide
        - [ ] Creating USB flash drive
        - [ ] Creating a VM
      * [x] Developer guides
        - [x] Quick start guide for developers
        - [x] External resources documentation
      * [ ] FAQ
10. - [ ] Find cloud data storage solution for members
11. - [ ] Create multiple builds
      * [x] 64 bit Cinnamon Heavy
      * [ ] ~32 bit Cinnamon Heavy~
      * [ ] 64 bit Cinnamon Light
      * [ ] 32 bit Cinnamon
12. - [x] Create test framework for APT
      * [x] Archives lists
      * [x] Packages lists
13. - [x] Create a E2E framework
14. - [ ] Create E2E tests for frequently used programs
      * [ ] Unity
      * [ ] Arduino IDE
      * [ ] Visual Studio Codium
      * [ ] Brave
      * [ ] Firefox
15. - [ ] Smoke tests for everything
      * [ ] More tests for things that clearly does not need smoke tests
      * [ ] Some more smoke tests

## Quick start guide for developers

### Get build system:
``` shell
git clone https://github.com/DarkMaguz/CodingPiratesOS.git
```

### Configuration:
Packages marked for installation are listed inside files in the `basics/config/package-list/` directory. <br>
You can edit/remove them to your liking. <br>

### Optional proxy server:
This is only for those expect to build the OS repetively.
``` shell
cd proxy
./setup-proxy.sh
```

### Optional RAM file system:
Highly recommended if you have the memory to spare.
``` shell
sudo ./scripts/mount-ramfs.sh
```

### Build the OS:
``` shell
./start-build.sh
```
ISO image will be generated in `images/` directory. <br>
They follow the naming convention `cpos-live-ARCH-MAJOR.MINOR.EPOCH.iso`. <br>
Where `ARCH` is the architecture of the machine ie. `amd64`, `MAJOR` is the major version of the OS, `MINOR` is the minor version of the OS, and `EPOCH` is the unix epoch time of the build.


## Indepth documentation

[Live Manual](data/docs/live-manual.landscape.en.letter.pdf) <br>
[Read The Docs](https://debian-live-config.readthedocs.io/en/latest/) <br>
[~Quick overvie~](data/docs/The-live-build.pdf) <br>
