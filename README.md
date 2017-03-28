GNW Creative Community
========================

## Table of contents
* [Introduction](#introduction)
* [Requirements](#requirements)
* [Getting started](#getting-started)
  * [compiling and deploying](#compiling-and-deploying)
* [Documentation](#documentation)
* [How to](#how-to)
  * [edit text and images](#edit-text-and-images)
  * [adjust the flow](#adjust-the-flow)
* [FAQ and troubleshooting](#faq-and-troubleshooting)

## Introduction
The following documentation is intended for developers or IT specialists wanting to install, run and make changes to the application.

### technologies used
The platform was built on Mac OS and Windows. The following programs were used:
- Adobe Illustrator CC (2017)
- Adobe After Effects CC (2017)
- Processing `3.2.1` & `3.3`

## Requirements

- Tablet: [Samsung Tab S2 9.7"](http://www.samsung.com/ca/tablets/galaxy-tab-s2-9-7-t810/) with Exynos 5433 8-Core Processor
- Tablet Operating System: Android 6.0.1
- For projection: Mac or Windows PC with [Samsung SideSync](http://www.samsung.com/us/sidesync/) installed

NB: the app was designed and programmed specifically for the device and operating system mentioned above, it was not tested on any other device. Devices with lower specifications or a different OS version might not be able to run the app or might have a lower frame rate.

**> Do not update the tablet's operating system without having tested the application on another device first. New Android operating systems might not be compatible with the app.**

## Getting started

1. download processing here: https://processing.org/download/ on PC or Mac

2. open the project folder `|-Main/Main.pde`

3. switch from java (PC or Mac) to android mode (tablet)

  - click the top right corner drop down list to `Add Mode`

  - **install the android SDK if pop up window occurs**

4. install the following packages

  - [Path Finder](http://www.lagers.org.uk/pfind/index.html) from Peter Lager

  **Mac & Windows**: packages can be installed in Processing's menu bar.
  `Sketch > Import Library... > Add library... > Search > Install package`

5. set tablet (debug mode) and connect with PC or Mac

6. run the project

### compiling and deploying

## Documentation

### folder structure
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

    |- drop feed back images
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

    |- place holder image
      |- place_holder.png

    |- data files

      |- flow_matrix.txt (store the flows of times)
      |- graph.txt (store the nodes of the map)
      |- customize_use.txt (store the reset and pci vision default uses)

```

## How to

### edit text and images

1. Find corresponding image in `|-Main/data/`
2. Edit text in the image without changing its size or proportion
3. Re-compile the application

### adjust the flow

- To adjust the **particle size**, go to the `Particle` class in `|-Main/Particle.pde`.
The size of the particles is defined in `int particleSize`.
- To adjust the **particle colour**, go to **[To Do]**

## FAQ and troubleshooting

### What happens if the app crashes?
1. Close the application by touching the left capacitive button and pressing "x" in the top-right corner of the app window.
2. Reopen the application

### How do I display the app on an external monitor?
1. Install [Samsung SideSync](http://www.samsung.com/us/sidesync/) on both the tablet and the computer
2. Open SideSync on both the tablet and the computer
  - either connect the tablet to the computer with and HDMI cable
  - or pair both devices through the WIFI network (this may or may not work depending on the network's firewall configuration)

## Releases
- Delivery
- Future plans
