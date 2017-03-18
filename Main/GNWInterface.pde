class GNWInterface //<>//
{
  PImage interfaceImage; 
  ArrayList<BuildingUseBox> buildingUseBoxes;
  HashMap<String, HotspotCoords> buttonPanel;
  int yBuildingBox;
  int xBuildingBox;

  BuildingUseIcon selectedBUIcon;

  GNWInterface() 
  {
    interfaceImage = loadImage("interface.png");
    buildingUseBoxes = new ArrayList<BuildingUseBox>();
    buttonPanel = new HashMap<String, HotspotCoords>();

    selectedBUIcon = null;

    yBuildingBox = 950;
    xBuildingBox = 42;
  }

  void render() 
  {
    createButtonsPanel();
    createBuildingUseBoxes();

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

  void createButtonsPanel()
  {
    int topY = 1450;
    int bottomY = 1530;

    HotspotCoords resetButton = new HotspotCoords(1206, topY, 1546, topY, 1540, bottomY, 1206, bottomY);
    buttonPanel.put("reset", resetButton);
  }

  void createBuildingUseBoxes() 
  {
    int space = 400;

    BuildingUseBox buildingUseBox =  new BuildingUseBox(buildingUses.get("Retail"), xBuildingBox, yBuildingBox);
    buildingUseBoxes.add(buildingUseBox);
    xBuildingBox += space;

    buildingUseBox =  new BuildingUseBox(buildingUses.get("Art and Culture"), xBuildingBox, yBuildingBox);
    buildingUseBoxes.add(buildingUseBox);
    xBuildingBox += space;

    buildingUseBox =  new BuildingUseBox(buildingUses.get("Light Industry"), xBuildingBox, yBuildingBox);
    buildingUseBoxes.add(buildingUseBox);
    xBuildingBox += space;

    buildingUseBox =  new BuildingUseBox(buildingUses.get("Business"), xBuildingBox, yBuildingBox);
    buildingUseBoxes.add(buildingUseBox);
    xBuildingBox += space;

    buildingUseBox =  new BuildingUseBox(buildingUses.get("Resident"), xBuildingBox, yBuildingBox);
    buildingUseBoxes.add(buildingUseBox);
  }

  void selectInterface()
  {
    float buttonsY = 1450;
    float timeY = 1280;
    if (mouseY > buttonsY) {
      selectButtonPanel();
    } else if (mouseY > timeY) {
      //TODO?
    } else {
      selectBuildingUse();
    }
  }

  void selectButtonPanel()
  {
    if (buttonPanel.get("reset").contains()) {
      setup();
      GNWMap.isBuildingUseChanged = true;
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

  void dropFeedback(boolean isOnMap)
  {
    if (selectedBUIcon != null && mousePressed == true && isOnMap)
    {
      try {
        Building building = GNWMap.findBuilding();
        if (building.isCustomizable) {
          building.highlight();
        }
      } 
      catch (Exception e) {
        //println(e);
      }
    }
  }


  void clearSelected ()
  {
    selectedBUIcon = null;
  }
}