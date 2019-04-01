# CodingPiratesOS
This is a re-spin of the Debian Linux distribution suited for the needs of the Coding Pirates organization.

Latest builds can be found at: [darkmagus.dk/cpos](https://www.darkmagus.dk/cpos)

**TODO**
1. - [x] Create a script for setting up our in house laptops
2. - [x] Create a basic live boot iso
3. - [x] Customize boot splash screen
4. - [x] Set up CI server
5. - [x] Adapt versioning system
6. - [ ] Customize desktop
7. - [x] Add boot menu option for persistence
8. - [ ] Create a script/program that automates the making of a persistent USB flash drive
9. - [ ] Implement install/update scripts for
    * - [ ] Unity
    * - [ ] Scratch3
    * - [ ] Arduino
    * - [ ] Firefox
    * - [ ] Oracle Java JRE
    * - [ ] Atom
10. - [ ] Make documentation
11. - [ ] Create multiple builds
    * - [x] 64 bit Cinnamon Heavy
    * - [ ] ~32 bit Cinnamon Heavy~
    * - [ ] 64 bit Cinnamon Light
    * - [ ] 32 bit Cinnamon Light

---

Update: 31st March 2019 <br>
>It's now possible to use a persistence partition on the USB flash drive.
In order to use this feature it's necessary to have a file named "persistence.conf"
in the root of the file-system that has a volume label named "persistence".
A directory and it's sub dirs can be made persistent by adding a
path to that directory in the "persistence.conf" file i.e. '/home'.

---

Update: 21st March 2019 <br>
>A suggestion has been proposed regarding a short name for this project: CPOS. <br>
Sounds official, I like it! <br>

---

Initial commit: 13th December 2018<br>
>Priority is to get things up and running.<br>
Afterwards we can make things look awesome!<br>
