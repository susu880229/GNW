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
    interfaceImage.resize(2148, 1536);
    buildingUseBoxes = new ArrayList<BuildingUseBox>();

    selectedBUIcon = null;

    yBuildingBox = 950;
    xBuildingBox = 42;
  }

  void createBuildingUseBoxes() 
  {
<<<<<<< HEAD
    int space = 300;
=======
    int space = 420;
>>>>>>> master

      for (int i = 0; i < buildingUses.size(); i++) {
      BuildingUse buildingUse = buildingUses.get(i);
      //only add the customizable buildinguses into buildingUseBoxes for rendering
      if(buildingUse.cust == true)
      {
        BuildingUseBox buildingUseBox = new BuildingUseBox(buildingUse, xBuildingBox, yBuildingBox);
        buildingUseBoxes.add(buildingUseBox);
        xBuildingBox += space;
      }
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