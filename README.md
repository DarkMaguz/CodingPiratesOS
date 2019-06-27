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
11. - [ ] Find cloud data storage solution for members
12. - [ ] Create multiple builds
    * - [x] 64 bit Cinnamon Heavy
    * - [ ] ~32 bit Cinnamon Heavy~
    * - [ ] 64 bit Cinnamon Light
    * - [ ] 32 bit Cinnamon
13. - [x] Construct automated test system for CI
    * - [x] Create a simple smoke test
    * - [ ] Create smoke tests for frequently used programs
    * - [ ] Smoke tests for everything
    * - [ ] Smoke tests for things that clearly does not need smoke tests
    * - [ ] Some more smoke tests

---

Update: June 27th 2019 <br>
>Added the basics of an automated test system. This is still very much a work in progress. <br>
In order to get started first create a symlink named 'image-to-be-tested.iso' in the <br>
'images' folder pointing to the desired iso file that is to be tested. <br>
Now go to the 'test' folder and run the commands: `docker-compose build` and `docker-compose up --exit-code-from test`.

---

Update: 31st March 2019 <br>
>It's now possible to use a persistence partition on the USB flash drive. <br>
In order to use this feature it's necessary to have a file named "persistence.conf"
in the root of the file-system that has a volume label named "persistence". <br>
A directory and it's sub dirs can be made persistent by adding a
path to that directory in the "persistence.conf" file i.e. '/home'. <br>
See Manual page persistence.conf(5) for more information.

---

Update: 21st March 2019 <br>
>A suggestion has been proposed regarding a short name for this project: CPOS. <br>
Sounds official, I like it! <br>

---

Initial commit: 13th December 2018<br>
>Priority is to get things up and running.<br>
Afterwards we can make things look awesome!<br>
