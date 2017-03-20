Android application for PCI Developments
========================

## Introduction
The following documentation is intended for developers or IT specialists wanting to install, run and make changes to the application.

### Technologies used
The platform was built on Mac OS and Windows. The following programs were used:
- Adobe Illustrator CC (2017)
- Adobe After Effects CC (2017)
- Processing `3.2.1` & `3.3`

## Requirements

- Tablet: [Samsung Tab S2 9.7"](http://www.samsung.com/ca/tablets/galaxy-tab-s2-9-7-t810/) Android 6.0 Marshmallow Tablet with Exynos 5433 8-Core Processor
- Tablet Operating System: Android 6.0.1

**NB: the app was designed and programmed specifically for the device and operating system mentioned above, it was not tested on any other device. Devices with lower specifications or a different OS might not be able to run the app or might have a lower frame rate.**

## Projection
- Mac or Windows PC with [Samsung SideSync](http://www.samsung.com/us/sidesync/) installed

## Getting started

1. download processing here: https://processing.org/download/

2. install the following packages

- [ControlP5](http://www.sojamo.de/libraries/controlP5/) from Andreas Schlegel
- [Path Finder](http://www.lagers.org.uk/pfind/index.html) from Peter Lager

**Mac & Windows**: packages can be installed in Processing's menu bar.
`Sketch > Import Library... > Add library... > Search > Install package`

3. open the project folder

4. open `|-Main/Main.pde`

5. run the project

### compiling and deploying to Android tablet

1. open the project in processing
2. click on "Add Mode..." in the top-right corner
3. // To Do

## Documentation

### folder structure
1. Application classes

```
|-Main/
    |- // contains all the classes
    |- Building.pde
    |- BuildingTooltip.pde
    |- BuildingUse.pde
    |- BuildingUseBox.pde
    |- BuildingUseIcon.pde
    |- FlowRoute.pde
    |- GNWInterface.pde
    |- GNWMap.pde
    |- GNWPathFinder.pde
    |- Main.pde
    |- Particle.pde
    |- Path.pde
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
    |- // contains all the assets
```

## How to:

### edit text

1. Find corresponding image in `|-Main/data/`
2. Edit text in the image without changing its size or proportion
3. Re-compile the application

### adjust the flow

- To adjust the **particle size**, go to the `Particle` class in `|-Main/Particle.pde`.
The size of the particles is defined in `int particleSize`.
- To adjust the **particle colour**, go to **[To Do]**

## Troubleshooting

**[To Do]**

#### The app crashes
- 1) open the app
- 2) go back to the home screen by pressing the device's home button
- 3) go back to the app

The application might crash on step 3. The user should in that case close the application by touching the left capacitive button and pressing "x" in the top-right corner of the app window.
