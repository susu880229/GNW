Android application for PCI Developments
========================

## Introduction
The following documentation is intended for developers or IT specialists wanting to install, run and make changes to the application.

## Getting started

### download processing
Go to: https://processing.org/download/

### install processing packages

- "ControlP5" from Andreas Schlegel: http://www.sojamo.de/libraries/controlP5/
- "Path Finder" from Peter Lager: http://www.lagers.org.uk/pfind/index.html

Packages can be installed in Processing's menu bar.
- Mac & Windows: Sketch > Import Library... > Add library... > Search > Install package

### requirements

- Device: Samsung Tab S2 9.7" Android 6.0 Marshmallow Tablet with Exynos 5433 8-Core Processor
- Mac or Windows desktop with Samsung SideSync installed for projection

### compiling and deploying to Android tablet


## Documentation

### folder structure
1. Application classes

```
|-Main/
    |- // add new classes here
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
    |- // add assets here
    |- all application assets
```

### editing text

1. Find corresponding image in
```
|-Main/data/
```

2. Edit text in the image without changing its size or proportion
3. Re-compile the application
