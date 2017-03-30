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
* [FAQ and troubleshooting](#faq-and-troubleshooting)
  * [What happens if the app crashes?](#what-happens-if-the-app-crashes)
  * [How do I display the app on an external computer?](#how-do-i-display-the-app-on-an-external-computer)
  * [How do I ensure that the screen stays on all the time?](#how-do-i-ensure-that-the-screen-stays-on-all-the-time)
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

1. Ensure that Processing is in Android mode by clicking the top-right corner and selecting "Android" (refer to "Getting Started" section on how to install Android mode)
2. Ensure that the correct video library is selected. The library `in.omerjerk.processing.video.android.*` should be uncommented for import and `processing.video.*` should be commented out
3. Go to the Onboarding class and comment out line 42 for `onBoardingVideo.stop();`. This is not compatible with the Android video library and it is not needed here. 
4. Go to `File > Export Signed Package`
5. Type in a password of your choice and press ok (if password is invalid, press "Reset Password")
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

### Edit the app icon

1. Design the app icon
2. Export the icon in 3 sizes: 36x36, 48x48, 72x72
3. Name the icons as such: icon-36.png, icon-48.png, icon-72.png
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

### How do I ensure that the screen stays on all the time?
1. In `Settings > Display > Screen timeout`, the screen can be set to stay active for a maximum of 10 minutes
2. For the tablet screen to be active all the time, install related apps on the tablet from the Google Play store such as "Stay Alive!"

*Note that keeping the screen active will cause the tablet's battery to drain faster.*

## Releases
- Delivery
- Future plans
