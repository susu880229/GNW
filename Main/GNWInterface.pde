class GNWInterface //<>// //<>//
{
  PImage interfaceImage; 
  ArrayList<BuildingUseBox> buildingUseBoxes;
  int yBuildingBox;
  int xBuildingBox;

  BuildingUseIcon selectedBUIcon;

  GNWInterface() 
  {
    interfaceImage = loadImage("interface.png");
    interfaceImage.resize(2048, 1536);
    buildingUseBoxes = new ArrayList<BuildingUseBox>();

    selectedBUIcon = null;

    yBuildingBox = 950;
    xBuildingBox = 42;
  }

  void createBuildingUseBoxes() 
  {
    int space = 400;

    for (int i = 0; i < buildingUses.size(); i++) {
      BuildingUse buildingUse = buildingUses.get(i);
      BuildingUseBox buildingUseBox = new BuildingUseBox(buildingUse, xBuildingBox, yBuildingBox);
      buildingUseBoxes.add(buildingUseBox);

      xBuildingBox += space;
    }
    
  }

  void render() 
  {
    for (int i = 0; i < buildingUseBoxes.size(); i++) {
      BuildingUseBox buildingUseBox = buildingUseBoxes.get(i);
      buildingUseBox.render();
    }

    image(interfaceImage, 0, 0);

    if (selectedBUIcon != null) {
      selectedBUIcon.render();
    }

    fill(0);        
    rect(interfaceImage.width, 0, width, interfaceImage.height);
  }

  void selectBuildingUse()
  {
    selectedBUIcon = null;

    for (int i = 0; i < buildingUseBoxes.size(); i++) {
      BuildingUseBox buildingUseBox = buildingUseBoxes.get(i);

      if (buildingUseBox.detect()) {
        selectedBUIcon = new BuildingUseIcon(buildingUseBox.buildingUse, mouseX, mouseY);
        break;
      }
    }
  }

  void update() 
  {
    if (selectedBUIcon != null) {
      selectedBUIcon.mouseDragged();
    }
  }

  void clearSelected ()
  {
    selectedBUIcon = null;
    
  }
}