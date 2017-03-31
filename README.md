GNW Creative Community
========================

## Table of contents
* [Introduction](#introduction)
* [Requirements](#requirements)
* [Getting started](#getting-started)
  * [Compiling and deploying on Mac or Windows](#compiling-and-deploying-on-mac-or-windows)
  * [Compiling and deploying on Android tablet](#compiling-and-deploying-on-android-tablet)
* [Documentation](#documentation)
* [How to](#how-to)
  * [Edit text and images](#edit-text-and-images)
  * [Adjust the flow](#adjust-the-flow)
  * [Adjust the default building uses and PCI vision](#adjust-the-default-building-uses-and-pci-vision)
  * [Edit or add new lots](#edit-or-add-new-lots)
* [FAQ and troubleshooting](#faq-and-troubleshooting)
  * [What happens if the app crashes?](#what-happens-if-the-app-crashes)
  * [How do I display the app on an external computer?](#how-do-i-display-the-app-on-an-external-computer)
  * [Are there other options to mirror the screen of the tablet to a computer?](#are-there-other-options-to-mirror-the-screen-of-the-tablet-to-a-computer)
  * [How do I ensure that the screen stays on all the time?](#how-do-i-ensure-that-the-screen-stays-on-all-the-time)
  * [What if running on the tablet using the USB debugging mode does not work?](#what-if-running-on-the-tablet-using-the-usb-debugging-mode-does-not-work)
* [Releases](#releases)

## Introduction
The following documentation is intended for developers or IT specialists wanting to install, run and make changes to the application.

### Technologies used
The platform was built on Mac OS and Windows. The following programs were used:
- Adobe Illustrator CC (2017)
- Adobe After Effects CC (2017)
- Processing `3.2.1` & `3.3`

## Requirements

- Tablet: [Samsung Tab S2 9.7"](http://www.samsung.com/ca/tablets/galaxy-tab-s2-9-7-t810/) with Exynos 5433 8-Core Processor
- Tablet Operating System: Android 6.0.1
- For projection: Mac or Windows PC with [Samsung SideSync](http://www.samsung.com/us/sidesync/) installed

NB: the app was designed and programmed specifically for the device and operating system mentioned above, it was not tested on any other device. Devices with lower specifications or a different OS version might not be able to run the app or might have a lower frame rate.

**Do not update the tablet's operating system without having tested the application on another device first. New Android operating systems might not be compatible with the app.**

## Getting started

1. Download processing here: https://processing.org/download/ on PC or Mac

2. install the following packages

	1. Mac & Windows: the below packages can be installed in Processing's menu bar. Sketch > Import Library... > Add library... > Search > Install package
		1. ControlP5 from Andreas Schlegel: http://www.sojamo.de/libraries/controlP5/
		2. Path Finder from Peter Lager: http://www.lagers.org.uk/pfind/index.html
		3. Video (Desktop) from The Processing Foundation: https://github.com/processing/processing-video

	2. Mac & Windows: the below package need to be manually installed. A copy can be found on the repo
		1. Video (Android) from Umair Khan:  https://github.com/omerjerk/processing-video-android
			-To manually install the Android video package:

			   1. From the project folder, go to GNW > Lib > video_android
			   2. Copy the entire video_android folder into the Processing Library (should be in Documents/Processing/libraries)
			   3. Restart Processing
			   4. Check if video_android is listed as an available library to use under Sketch > Import Library... > `Video Library for Processing Android` should appear under Contributed library . If not, restart computer.

3. Open the project folder

4. Open `|-Main/Main.pde`

5. On the top right hand corner, switch to Java mode if the application has to run on desktop **OR** switch to Android mode if it has to run on tablet.

    -To install Android mode:

       1. Click on the dropdown menu in the top-right corner
       2. Click on Add Mode...
       3. Select Android Mode
       4. Click Install
       5. For Android mode: install the android SDK if pop up window occurs

6. To setup the debug mode on Android: On the tablet, go to `Settings` > `About device` > `Software info` > press on `Build number` 7 times then the `Developer options` will appear in the left menu. Tap on `Developer options` and enable `USB debugging`.

7. Run the project by pressing the play icon in Processing.

### Compiling and deploying on Mac or Windows

- **[To Do - changing the libraries for playing of Onboarding video]**
- **Be sure to make a backup of the original source code before making changes.**

1. Ensure that Processing is in Java mode by clicking on the dropdown menu at the top-right corner and selecting "Java"
2. Ensure that the correct video library is selected. The library `processing.video.*` should be imported and `in.omerjerk.processing.video.android.*` should be commented out
3. Go to the Onboarding class and uncomment line 42 for `onBoardingVideo.stop();`. The video library for desktop, `processing.video.*`, requires the video to stop before replaying it
4. Run the project by clicking the play button at the top-left corner

### Compiling and deploying on Android tablet
- **Be sure to make a backup of the original source code before making changes.**
- **Uninstall any old versions of the app on the tablet before installing an updated version.**

1. Ensure that Processing is in Android mode by clicking the top-right corner and selecting "Android" (refer to [Getting Started](#getting-started) section on how to install Android mode)
2. Ensure that the correct video library is selected. The library `in.omerjerk.processing.video.android.*` should be imported and uncommented, and `processing.video.*` should be commented out
3. Go to the Onboarding class and comment out line 42 for `onBoardingVideo.stop();`. This is not compatible with the Android video library and it is not needed here.
4. Go to `File > Export Signed Package`
5. Type in a password of your choice and press ok (if password is invalid, press "Reset Password" and set a new one)
6. Transfer the file `|-Main/android/bin/Main-release-signed.apk` into the tablet
7. Using the tablet, open the file and click install
8. If a pop-up appears showing that the installation is blocked, enable `Settings > Lock screen and security > Unknown sources`

## Documentation

### Folder structure
1. Application classes

```
|-Main/
    |- // contains all the classes
      |- Building.pde
      |- BuildingTooltip.pde
      |- BuildingUse.pde
      |- FlowRoute.pde
      |- GNWInterface.pde
      |- GNWMap.pde
      |- GNWPathFinder.pde
      |- HotspotCoords.pde
      |- Main.pde
      |- Particle.pde
      |- Path.pde
      |- TimeBar.pde
      |- UseFlow.pde

    |- // contains app icon
      |- icon-36.png
      |- icon-48.png
      |- icon-72.png
```

2. Sketch properties **[DO NOT EDIT]**

Processing will automatically adjust it according to SDK used for development.

```
|-Main/code/
    |- sketch.properties
```

3. Assets

```
|-Main/data/
    |- icon images
      |- artCulture.png
      |- lightIndustrial.png
      |- offices.png
      |- residential.png
      |- retail.png

    |- pull up images
      |- sub_artCulture.png
      |- sub_lightIndustrial.png
      |- sub_offices.png
      |- sub_residential.png
      |- sub_retail.png

    |- tooltip images
      |- tooltip_left_1.png
      |- tooltip_left_2.png
      |- tooltip_left_3.png
      |- tooltip_right_1.png
      |- tooltip_right_2.png
      |- tooltip_right_3.png
      |- cross_sign.png

    |- map image
      |- map.png
      |- map-paths.png

    |- interface image
      |- interface.png

    |- drop feedback images
      |- hightlight_515.png
      |- hightlight_521.png
      |- hightlight_701.png
      |- hightlight_887.png
      |- hightlight_901.png
      |- hightlight_1933.png
      |- hightlight_1980.png
      |- hightlight_lot4.png
      |- hightlight_lot5.png
      |- hightlight_lot7.png
      |- hightlight_shaw.png
      |- hightlight_naturesPath.png

    |- placeholder image
      |- place_holder.png

    |- data files
      |- flow_matrix.txt // flows according for each time option
      |- graph.txt // map nodes
      |- customize_use.txt // default and pci vision presets

```

4. Android Video Library  **[DO NOT EDIT]**
```
|-Lib/video_android/
    |- this folder holds the basic example of how to use the video_android library
	   | - examples/Movie/GettngStartedMovie

	|- this file is a package that contains all the library java files
		|- library/video_android.jar

	|- this folder holds all the java files for to create the jar file
		|- src/in/omerjerk/processing/video/android

	|- this file holds the meta data for the package
		|- library.properties		
```

## How to

### Edit text and images

1. Find corresponding Adobe Illustrator file in `Delivery/Assets` **[To Do]**
2. Using Adobe Illustrator, edit text and/or the image without changing its size or proportion
3. Export the image in the same size and file name as the image found in `|- Main/data/`, and replace the image with the updated one
4. Re-compile and re-install the app

### Adjust the flow

1. To adjust **particle properties**, go to the `Particle` class in `|-Main/Particle.pde`.
    - `particleSize`: adjust size of particles. (default 15)
    - `minRandomVelocity` and `maxRandomVelocity`: adjust particle speed (default 7.0 and 9.0)
    - `maxPathDeviation`: adjust how far particles can stray from their path (default 5)
    - `devChance`: adjust how likely particles are to stray from their path (default 10)
    - `devScale`: adjust each 'step size' for particles straying from their path (default 3)
    - `selectFill()` To toggle between single-coloured and multi-coloured particles, go to line 57: selectFill(). If selectFill() is commented out (i.e. `//selectFill()`), the particles will be single-coloured


2. To adjust **general flow volume**, go to the `Building` class in `|-Main/Building.pde`.
    - `FLOW_DELAY_MULTIPLIER`: a larger value means that particles will appear at a slower rate, so flow volume is lesser in general
    - `MIN_DELAY_(TYPE)`: Sets the shortest amount of delay allowed for each type of building use. A higher value means that less particles will be allowed to enter or exit the building use per second


3. To adjust **flow matrix**, go to `|-Main/data/flow_matrix.txt`.
    - Change the last number on each line to adjust the delay for each flow. A higher number means a slower rate, i.e. less density. The rows are organised in the order of `TimeID, Flow Origin, Flow Destination, Delay Level`. For `TimeID`, `0=Morning, 1=Noon, 2=Afternoon, 3=Evening, 4=Late Evening`.

4. After making the necessary adjustments, re-compile and re-install the app.

### Adjust the default building uses and PCI Vision

1. To adjust **default building uses**, go to `|-Main/data/customize_use.txt`.

	1. Locate the lines that says `<default>` and `</default>`. Each line in between represents an assignment of a building use to a lot for the default view.
	2. Change the first word of a line to change the lot (Refer to list of all the possible customizable buildings/lots that is near the top of file under the line `# List of all customizable buildings/lots:`)
	3. Change the last word of the line to change the building use (Refer to list of all the possible building uses that is at the top of file under the line `# List of possible uses to add:`)
	4. If you want to assign more than one building use to a building/lot, you will need a new line for each.
	5. The format of each line is `building_name = building_use`

2. To adjust **PCI Vision**, go to `|-Main/data/customize_use.txt`.

	1. Locate the lines that says`<PCIMode>` and `</PCIMode>`. Each line in between represents an assignment of a building use to a lot for the PCI Vision.
	2. Changing the building use assignments for the PCI Vision is the same as for default. Refer to above from the second step.

### Edit or add new lots
1. Locate the Adobe Illustrator file of the map in `Delivery/Assets`**[To do]** and edit it. Export the map in .png format with a white background. Name it as map.png.

2. Locate the Adobe Illustrator file of the map paths in `Delivery/Assets` **[To do]**. Using the new map as a guide, edit the paths so that there is a path leading into the new/edited lot. Give each new path intersection and end point (i.e. the start and end of any new straight lines created) a number. Each intersection and end point is a "node", and the number of the node will be used in the code. Export the image in .png format.

![image of map paths](http://i288.photobucket.com/albums/ll174/twin_friends/map-paths_zpsnovhra7m.png)

3. Go to `|-Main/data`. Locate the map.png in the folder. Delete the image from the `data` folder, then place the file you exported in Step 2 into this folder, naming it map.png. This will be used temporarily to determine the x and y coordinates of the new nodes.

4. Open `|-Main/Main.pde`. At the end of the file, you will see these lines:

  ![Lines to output X and Y coordinates of mouse click](http://i288.photobucket.com/albums/ll174/twin_friends/Screen%20Shot%202017-03-30%20at%204.30.51%20PM_zpschzar4lg.png)

Uncomment the last three lines by removing the double slashes "//". This allows the program to print the x and y coordinates of mouse clicks.

5. Switch to Java mode and run the app on the computer. (Remember to change the video libraries! Refer to [Compiling and deploying on Mac or Windows](#compiling-and-deploying-on-mac-or-windows).) Hover the mouse cursor over the new path intersections and end points ("nodes") created in Step 2, and click. Upon exiting the app by pressing "Esc", the x and y coordinates of the mouse clicks are printed in the console of Processing. Note that the mouse click to close the tutorial video is also recorded, so remember to ignore the first of the recorded clicks.

  ![Example of x and y coordinates on console](http://i288.photobucket.com/albums/ll174/twin_friends/Screen%20Shot%202017-03-30%20at%204.50.21%20PM_zpsz2pehfjf.png)

6. Go to `|-Main/data/graph.txt`. All the nodes in the map are specified between `<nodes>` and `</nodes>` in three columns: Number, x coordinate, y coordinate. Add the new nodes into the file using the number given in Step 2 and the x/y coordinates obtained in step 5.

7. In the same `graph.txt` file, all the edges in the map are specified between `<edges>` and `</edges>`. They represent all the paths, or lines, on the map. Add the new edges in by appending `Node1 Node2 0 0` in the last line of <edges>. For example. for the below, the edges are:

  ```
  2 3 0 0
  3 4 0 0
  4 5 0 0
  ```
  Keep in mind that some of the new nodes might have split some existing edges into two, and you will need to update those edges.

  ![Example of edges](http://i288.photobucket.com/albums/ll174/twin_friends/Screen%20Shot%202017-03-30%20at%205.04.09%20PM_zpsj2m6pxdb.png)

8. Replace the map.png in `|-Main/data` with the new one that you have created in Step 1.

9. Next, for the new/edited lots, find out the x-y coordinates by running the app again and clicking on the corners of the new/edited lots in this order:

  ![Order of finding x-y coordinates](http://i288.photobucket.com/albums/ll174/twin_friends/Artboard%201_zpsp1gbcjlm.png)

  Don't worry about being too accurate, the vertices are used for hotspots and will be invisible. If the lots have rounded corners, it is ok to just get an approximate rectangle that covers the whole lot. Save the values down somewhere for later reference.

10. Run the app again and get the x-y coordinates of the dot positions of the lot where you want them to be (also by mouse clicks). Save the values down somewhere for later reference.

11. In the Processing file `GNWMap.pde`, go to the function `void createGNWMap`. If you have a new lot, give it a name (let's call it "newLot in this instance".) Under the `PVector[]` initializations, initialize the new dot coordinates by typing `PVector[] dotCoords_newLot = {new PVector(x-coord of dot 1, y-coord of dot 1), new PVector(x-coord of dot 2, y-coord of dot 2), new PVector(x-coord of dot 3, y-coord of dot 3)};`, replacing the "newLot" by the name you have given to the lot and "x/y-coord of dot 1/2/3" by the values obtained in step 10.

12. In the same function, initialize the new lot(s) by typing `addBuilding("newLot", true/false, number of the node that leads into the lot, x1, y1, x2, y2, x3, y3, x4, y4, dotCoords_newLot);`, where newLot is the name of the lot, "true" if the lot's dots should be small-sized and "false" if its dots should be large-sized, the node number is from step 2, and x1, y1 etc are the vertices of the lot from step 9.

13. Comment out the code in `|-Main/Main.pde` that prints the x and y coordinates of the mouse click.

  ![Lines to output X and Y coordinates of mouse click](http://i288.photobucket.com/albums/ll174/twin_friends/Screen%20Shot%202017-03-30%20at%204.30.51%20PM_zpschzar4lg.png)

14. Build and run the app on the computer or on the tablet by following the instructions in [Compiling and deploying on Mac or Windows](#compiling-and-deploying-on-mac-or-windows) or [Compiling and deploying on Android tablet](#compiling-and-deploying-on-android-tablet).

### Edit the app icon

1. Design the app icon
2. Export the icon in 5 sizes: 36x36, 48x48, 72x72, 144x144, 192x192
3. Name the icons as such: icon-36.png, icon-48.png, icon-72.png, icon-144.png, icon-192.png
4. Replace the existing icon images in the project folder `Main` with the new icons.
5. Re-compile and re-install the app

### Edit the app name

1. Open `Main/AndroidManifest.xml` with a text editor
2. Under `<application android:debuggable="true" android:icon="@drawable/icon" android:label="GNW Creative Community">`, rename `GNW Creative Community`
3. Re-compile and re-install the app


## FAQ and troubleshooting

### What happens if the app crashes?
1. Close the application by touching the left capacitive button and pressing "x" in the top-right corner of the app window.
2. Reopen the application

### How do I display the app on an external computer?
1. Install [Samsung SideSync](http://www.samsung.com/us/sidesync/) on both the tablet and the computer
2. Open SideSync on both the tablet and the computer
  - Either connect the tablet to the computer with a USB cable; or
  - Pair both devices through the same WIFI network (this may or may not work depending on the network's firewall configuration)
3. If desired, connect the computer to a projector or large screen

### Are there other options to mirror the screen of the tablet to a computer?
1. On Windows 10 PCs, search for "Connect". On the Samsung Tab S2 tablet, pull down the notification bar, and tap on "Quick Connect", then "Scan for nearby devices". Select the PC, and the tablet screen will show on the PC. For other tablets, the setting may be found in `Settings > Display > Screen Mirroring`.
2. Download "AirDroid" on the tablet from the Google Play store and follow the instructions. The app allows for screen mirroring through a desktop client or through the Google Chrome browser on the PC.

### How do I ensure that the screen stays on all the time?
1. In `Settings > Display > Screen timeout`, the screen can be set to stay active for a maximum of 10 minutes
2. For the tablet screen to be active all the time, install related apps on the tablet from the Google Play store such as "Stay Alive!"

*Note that keeping the screen active will cause the tablet's battery to drain faster.*

### What if running on the tablet using the USB debugging mode does not work?
1. Try exporting the app to a .apk instead, then transfer and install the .apk to the tablet. See [Compiling and deploying on Android tablet](#compiling-and-deploying-on-android-tablet) for more details.

## Releases
- Delivery
- Future plans
