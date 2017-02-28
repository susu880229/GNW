class GNWInterface //<>//
{
  PImage interfaceImage; 
  ArrayList<BuildingUseBox> buildingUseBoxes;
  int yBuildingBox;
  int xBuildingBox;

  BuildingUseIcon selectedBUIcon;
  
  GNWInterface() 
  {
    interfaceImage = loadImage("interface.png");
    buildingUseBoxes = new ArrayList<BuildingUseBox>();

    selectedBUIcon = null;

    yBuildingBox = 991;
    xBuildingBox = 42;
  }

  void createBuildingUseBoxes() 
  {
    int space = 418;

    for (int i = 0; i < buildingUses.size(); i++) {
      BuildingUse buildingUse = buildingUses.get(i);
      BuildingUseBox buildingUseBox = new BuildingUseBox(buildingUse, xBuildingBox, yBuildingBox);
      buildingUseBoxes.add(buildingUseBox);

      xBuildingBox += space;
    }
  }

  void render() 
  {
    image(interfaceImage, 0, 0);

    for (int i = 0; i < buildingUseBoxes.size(); i++) {
      BuildingUseBox buildingUseBox = buildingUseBoxes.get(i);
      buildingUseBox.render();
    }
    
    if (selectedBUIcon != null) {
        selectedBUIcon.render();
    }
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