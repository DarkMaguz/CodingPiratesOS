# CodingPiratesOS
This is a re-spin of the Debian Linux distribution suited for the needs of the Coding Pirates organization.

Latest builds can be found at: [darkmagus.dk/cpos](https://www.darkmagus.dk/cpos)

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

## Quick Start Guide

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
~~ [Quick overview](data/docs/The-live-build.pdf) ~~ <br>
