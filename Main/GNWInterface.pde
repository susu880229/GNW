class GNWInterface //<>// //<>//
{
  PImage interfaceImage; 
  PImage hand;
  PImage mapLegendImage;
  ArrayList<BuildingUseBox> buildingUseBoxes;
  HashMap<String, HotspotCoords> buttonPanel;
  int yBuildingBox;
  int xBuildingBox;
  BuildingUseBox selectedBUBox; 
  BuildingUseIcon selectedBUIcon;
  TimeBar time_bar;

  GNWInterface() 
  {
    interfaceImage = loadImage("interface.png");
    hand = loadImage("hand.png");
    mapLegendImage = loadImage("mapLegend.png");
    buildingUseBoxes = new ArrayList<BuildingUseBox>();
    buttonPanel = new HashMap<String, HotspotCoords>();

    selectedBUIcon = null;
    xBuildingBox = 50;
    yBuildingBox = 950;
    selectedBUBox = null;
    time_bar = new TimeBar(155, 1370, 40, 40);

    createBuildingUseBoxes();
    createButtonsPanel();
  }

  void render() 
  {
    if (buildingUseBoxes.size() > 0) {
      for (int i = 0; i < buildingUseBoxes.size(); i++) {
        BuildingUseBox buildingUseBox = buildingUseBoxes.get(i);
        buildingUseBox.render();
      }
    }

    image(interfaceImage, 0, 0);
    image(mapLegendImage, 0, 0);
    image(hand, width/2, GNWMap.mapImage.height - 80);

    if (selectedBUIcon != null) {
      selectedBUIcon.render();
    }

    fill(0);        
    rect(interfaceImage.width, 0, width, interfaceImage.height);

    //render the pullup
    if (selectedBUBox != null && selectedBUBox.lock == true)
    {
      image(selectedBUBox.pull_img, selectedBUBox.box_x, selectedBUBox.box_y, selectedBUBox.box_width, selectedBUBox.box_height);
    }

    time_bar.render(); //render the time bar
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
    BuildingUseBox buildingUseBox =  new BuildingUseBox(buildingUses.get("Retail"), xBuildingBox, yBuildingBox, "sub_retail.png");
    buildingUseBoxes.add(buildingUseBox);

    int space = buildingUseBox.box_width + 37;
    xBuildingBox += space;

    buildingUseBox =  new BuildingUseBox(buildingUses.get("Art and Culture"), xBuildingBox, yBuildingBox, "sub_artCulture.png");
    buildingUseBoxes.add(buildingUseBox);
    xBuildingBox += space;

    buildingUseBox =  new BuildingUseBox(buildingUses.get("Light Industry"), xBuildingBox, yBuildingBox, "sub_lightIndustrial.png");
    buildingUseBoxes.add(buildingUseBox);
    xBuildingBox += space;

    buildingUseBox =  new BuildingUseBox(buildingUses.get("Business"), xBuildingBox, yBuildingBox, "sub_offices.png");
    buildingUseBoxes.add(buildingUseBox);
    xBuildingBox += space;

    buildingUseBox =  new BuildingUseBox(buildingUses.get("Resident"), xBuildingBox, yBuildingBox, "sub_residential.png");
    buildingUseBoxes.add(buildingUseBox);
  }

  void selectInterface()
  { //<>// //<>//
    float buttonsY = 1450;
    float bUBoxYBottom = 1280;
    //<>// //<>//
    if (mouseY < bUBoxYBottom) {
      update_buildingBox(); //<>// //<>//
      function_buildingBox(); //<>// //<>//
    } else if (mouseY > buttonsY) {
      selectButtonPanel(); //<>// //<>//
    }

    if (mouseY > bUBoxYBottom) {
      clearSelectedBox();
    }
  }

  void selectButtonPanel()
  {
    if (buttonPanel.get("reset").contains()) {
      GNWMap.PCIMode = false;
      setup();
      GNWMap.isBuildingUseChanged = true;
    }
  }


  //detect buildingUseBox
  void update_buildingBox()
  {
    selectedBUIcon = null;
    boolean found = false;
    for (int i = 0; i < buildingUseBoxes.size(); i++) {
      BuildingUseBox buildingUseBox = buildingUseBoxes.get(i);
      if (buildingUseBox.drag_detect() || buildingUseBox.pull_detect())
      {
        found = true;
        //tap to different buildingBox to set the lock default setting
        if (selectedBUBox == null || buildingUseBox.buildingUse.name != selectedBUBox.buildingUse.name)
        {
          buildingUseBox.lock = false; 
          selectedBUBox = buildingUseBox; //create a new cur_selectedBUBox
        }
        break;
      }
    }

    if (!found)
    {
      clearSelectedBox();
    }
  }

  //add use_icon or pull up the image
  void function_buildingBox()
  {
    if (selectedBUBox != null)
    {
      if (selectedBUBox.drag_detect())
      {
        if (selectedBUBox.lock == false)
        {
          selectedBUIcon = new BuildingUseIcon(selectedBUBox.buildingUse, mouseX, mouseY);
        }
      } else if (selectedBUBox.pull_detect())
      {
        //selectedBUBox.lock = true;
        if (selectedBUBox.lock == true)
        {
          clearSelectedBox();
        } else
        {
          selectedBUBox.lock = true;
        }
      }
    }
  }

  void clearSelectedBox()
  {

    selectedBUBox = null;
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