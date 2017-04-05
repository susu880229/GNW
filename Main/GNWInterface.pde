/** //<>//
 * GNWInterface is the dashboard of the application
 */
class GNWInterface 
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
  HotspotCoords close_instruButton;

  GNWInterface() 
  {
    interfaceImage = loadImage("interface.png");
    buildingUseBoxes = new ArrayList<BuildingUseBox>();
    buttonPanel = new HashMap<String, HotspotCoords>();

    selectedBUIcon = null;
    xBuildingBox = 50;
    yBuildingBox = 950;
    selectedBUBox = null;
    time_bar = new TimeBar(157, 1370, 42, 42);

    createBuildingUseBoxes();
    createButtonsPanel();
    close_instruButton = new HotspotCoords(1855, 35, 2015, 35, 2015, 195, 1855, 195);
  }

  /**
   * Draws the dashboard onto the screen 
   */
  void render() 
  {
    image(interfaceImage, 0, 0);

    if (selectedBUIcon != null) {
      selectedBUIcon.render();
    }

    if (selectedBUBox != null && selectedBUBox.lock == true) {
      selectedBUBox.renderPullUp();
    }

    time_bar.render(); //render the time bar
    drawButtonPanelBorder();  //render the border around the buttons at the bottom
  }

  /**
   * Creates the three buttons at the bottom of the screen
   */
  void createButtonsPanel()
  {
    int topY = 1450;
    int bottomY = 1530;

    //define the reset button
    HotspotCoords resetButton = new HotspotCoords(1206, topY, 1526, topY, 1526, bottomY, 1206, bottomY);
    buttonPanel.put("reset", resetButton);

    //define the PCI vision button
    HotspotCoords pciButton = new HotspotCoords(1526, topY, 1766, topY, 1766, bottomY, 1526, bottomY);
    buttonPanel.put("pci", pciButton);

    //define the instruction button
    HotspotCoords instruButton = new HotspotCoords(1766, topY, 2086, topY, 2086, bottomY, 1766, bottomY);
    buttonPanel.put("instruction", instruButton);
  }

  /**
   * Creates the five category boxes on the dashboard
   */
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

    buildingUseBox =  new BuildingUseBox(buildingUses.get("Office"), xBuildingBox, yBuildingBox, "sub_offices.png");
    buildingUseBoxes.add(buildingUseBox);
    xBuildingBox += space;

    buildingUseBox =  new BuildingUseBox(buildingUses.get("Resident"), xBuildingBox, yBuildingBox, "sub_residential.png");
    buildingUseBoxes.add(buildingUseBox);
  }

  /**
   * Handles mouse clicks on the dashboard
   */
  void selectInterface()
  {
    float buttonsY = 1450;
    float bUBoxYBottom = 1280;

    if (mouseY < bUBoxYBottom) {
      update_buildingBox();  
      function_buildingBox();
    } else if (mouseY > buttonsY) {
      selectButtonPanel();
    }

    if (mouseY > bUBoxYBottom) {
      clearSelectedBox();
    }
  }

  /**
   * Handles mouse clicks on the button panel of the dashboard
   */
  void selectButtonPanel()
  {
    if (buttonPanel.get("reset").contains()) {
      isDefaultSelected = true;
      isPCIVisionSelected = false;
      reset(); //<>//
      GNWMap.isBuildingUseChanged = false;
    } else if (buttonPanel.get("pci").contains())
    {
      isDefaultSelected = false;
      isPCIVisionSelected = true;
      reset();
      GNWMap.isBuildingUseChanged = false;
    } else if (buttonPanel.get("instruction").contains())
    {
      start = false;
      isInstructionSelected = true;
    }
  }

  /**
   * Closes the instruction page/overlay
   */
  void close_instruction()
  {
    if (close_instruButton.contains())
    {
      start = true;
      isInstructionSelected = false;
    }
  }

  /**
   * Draws the outline of the button for the currently displayed vision 
   */
  void drawButtonPanelBorder()
  {
    noFill();
    strokeWeight(2);
    stroke(255);
    if (isDefaultSelected)
    {
      rect(1238, 1460, 286, 66);
    } else if (isPCIVisionSelected)
    {
      rect(1524, 1460, 235, 66);
    }

    if (isInstructionSelected)
    {
      rect(1770, 1460, 260, 66);
    }
  }

  /**
   * Remove selected button border if any of the building uses have changed
   */
  void updateButtonBorder()
  {
    if (GNWMap.isBuildingUseChanged)
    {
      isDefaultSelected = false;
      isPCIVisionSelected = false;
    }
  }

  /**
   * Selects new building use box based on user input
   */
  void update_buildingBox()
  {
    clearSelectedBUse(); //clear existing selected building use

    for (int i = 0; i < buildingUseBoxes.size(); i++) {
      BuildingUseBox buildingUseBox = buildingUseBoxes.get(i);

      Boolean changeDetected = buildingUseBox.drag_detect() || buildingUseBox.pull_detect();
      Boolean validBUBox = selectedBUBox == null || buildingUseBox.buildingUse.name != selectedBUBox.buildingUse.name;

      if (changeDetected && validBUBox)
      {
        buildingUseBox.lock = false; 
        selectedBUBox = buildingUseBox; 
        return;
      }
    }
  }

  /**
   * When building use box is selected, create building use icon or pull up the image depending on current states of interface
   * Case 1: If drag is detected and that building use box is not locked, then create a new building use icon
   * Case 2: If pull is detected on a building use but there is a lock on the building use box, then release the lock
   * Case 3: If pull is detected and there's no lock on the building use box, then activate the lock.
   */
  void function_buildingBox()
  {
    if (selectedBUBox != null) {
      if (selectedBUBox.drag_detect() && !selectedBUBox.lock)
      {
        selectedBUIcon = new BuildingUseIcon(selectedBUBox.buildingUse, mouseX, mouseY);
      } else if (selectedBUBox.pull_detect() && selectedBUBox.lock)
      {
        clearSelectedBox();
      } else if (selectedBUBox.pull_detect() && !selectedBUBox.lock)
      {
        selectedBUBox.lock = true;
      }
    }
  }

  /**
   * Deselects currently selected building use box
   */
  void clearSelectedBox()
  {
    selectedBUBox = null;
  }

  /**
   * Deselects currently selected building use
   */
  void clearSelectedBUse()
  {
    selectedBUIcon = null;
  }

  /**
   * Updates location of building use icon when user drags it
   */
  void update() 
  {
    if (selectedBUIcon != null) {
      selectedBUIcon.mouseDragged();
    }
  }

  /**
   * Highlight building that has the building use icon hovering over it 
   */
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
}