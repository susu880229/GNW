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
- Desktop computer: Mac or Windows with [Samsung SideSync](http://www.samsung.com/us/sidesync/) installed for projection

## Getting started

1. download processing
Go to: https://processing.org/download/

2. install processing packages

- `ControlP5` from Andreas Schlegel: http://www.sojamo.de/libraries/controlP5/
- `Path Finder` from Peter Lager: http://www.lagers.org.uk/pfind/index.html

Packages can be installed in Processing's menu bar.
- Mac & Windows: Sketch > Import Library... > Add library... > Search > Install package

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

1. Find corresponding image in
```
|-Main/data/
```

2. Edit text in the image without changing its size or proportion
3. Re-compile the application

### adjust the flow

The flow can be adjusted in the `Particle` class in `|-Main/Particle.pde`.

1. Particle size
The size of the particles is defined in `int particleSize`.

2. Particle colour
// To Do

## Troubleshooting

### known issues
// To do

### basic steps to troubleshoot
