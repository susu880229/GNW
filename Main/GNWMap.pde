class GNWMap
{
  HashMap<String, Building> buildings; //String is building id
  PImage mapImage;
  PImage mapDoorsImage;
  boolean isBuildingUseChanged;
  ArrayList<Path> flowPaths;
  Building selectedBuilding;

  GNWMap() 
  {
    mapImage = loadImage("map.png");
    mapDoorsImage = loadImage("mapDoors.png");
    buildings = new HashMap<String, Building>();
    isBuildingUseChanged = false;
    flowPaths = new ArrayList<Path>();
    selectedBuilding = null;

    createGNWMap();
  }

  void render()
  {
    image(mapImage, 0, 0);
    image(mapDoorsImage, 0, 0);

    //walk through the GNWmap to render building
    for (Map.Entry buildingEntry : buildings.entrySet()) {
      Building building = (Building) buildingEntry.getValue();
      building.render();
    }
  }

  void showSelectedBuilding() 
  {
    if (selectedBuilding != null) {
      selectedBuilding.showTooltip();
    }
  }

  /**
   * check 
   */
  void selectTooltip() throws Exception
  {
    if (selectedBuilding != null) {
      selectedBuilding.deleteBuildingUse();
      isBuildingUseChanged = true;
      return;
    } else {
      throw new Exception ("No tooltip selected");
    }
  }

  /**
   * Select building to show tooltip for if mouse clicked on a building; otherwise clear selected building
   */
  void selectBuilding()
  {
    for (Map.Entry buildingEntry : buildings.entrySet()) {
      Building building = (Building) buildingEntry.getValue();
      //Handle any horizontal scroll before checking contains
      if (building.contains(mouseX - shiftX, mouseY) && building.isCustomizable) {
        selectedBuilding = building; 
        return;
      }
    }
    clearSelectedBuilding ();
  }

  void clearSelectedBuilding() 
  {
    selectedBuilding = null;
  }

  void flowInit()
  {
    flowPaths = new ArrayList<Path>();
    for (Map.Entry buildingEntry : buildings.entrySet()) {
      Building building = (Building) buildingEntry.getValue();
      flowPaths = building.buildPaths(flowPaths);
    }

    for (int i = 0; i < flowPaths.size(); i++)
    {
      flowPaths.get(i).particleInit();
    }
  }

  void drawFlow()
  {
    for (int i = 0; i < flowPaths.size(); i++) 
    {
      flowPaths.get(i).run();
    }
  }

  void assignBuildingUse(BuildingUse selectedBuildingUse) 
  {
    try {
      Building building = findBuilding();

      if (building.isCustomizable) {
        building.addBuildingUse(selectedBuildingUse);
        isBuildingUseChanged = true;
        selectedBuilding = building;
      }
    } 
    catch (Exception e) {
      //if no building found, don't do anything
    }
  }

  //Note: shiftX is referring to global public variable from Main. It tracks the change in x via horizontal scroll.
  Building findBuilding() throws Exception 
  {
    for (Map.Entry buildingEntry : buildings.entrySet()) 
    {
      Building building = (Building) buildingEntry.getValue();
      if (building.contains(mouseX - shiftX, mouseY))
      {
        return building;
      }
    }
    throw new Exception("No Building Found");
  }

  /** 
   * Creates GNWMap with all the buildings and lots
   * Buildings/lots are added to from left to right and top to bottom
   */
  void createGNWMap() 
  {  
    addBuilding("Lot5", true, 64, 285, 155, 390, 164, 387, 300, 277, 305);
    addBuilding("Park", false, 5, 274, 333, 383, 330, 376, 525, 279, 520);
    addBuilding("Lot7", true, 7, 272, 571, 379, 580, 392, 698, 280, 720);

    addBuilding("Lot4", true, 17, 417, 167, 645, 175, 648, 260, 417, 260);
    addBuilding("521", true, 14, 401, 390, 524, 398, 521, 532, 402, 532);
    addBuilding("515", true, 12, 401, 579, 543, 571, 564, 660, 410, 695);

    addBuilding("EmilyCarr", false, 28, 570, 378, 1128, 251, 1155, 378, 604, 507);
    addBuilding("Plaza", false, 22, 568, 567, 702, 538, 721, 616, 593, 650);
    addBuilding("569", false, 26, 728, 528, 1182, 420, 1201, 500, 750, 612);

    addBuilding("CDM1", false, 34, 1207, 188, 1353, 156, 1400, 394, 1260, 425);
    addBuilding("1933", true, 38, 1376, 152, 1539, 153, 1566, 283, 1408, 309);
    addBuilding("CDM2", false, 41, 1415, 344, 1577, 313, 1600, 411, 1425, 422);

    addBuilding("701", true, 44, 1662, 217, 2185, 224, 2221, 418, 1690, 401);
    addBuilding("1980", true, 46, 2296, 166, 2528, 164, 2699, 432, 2353, 424);
    addBuilding("887", true, 48, 2578, 173, 2904, 198, 2899, 448, 2765, 444);
    addBuilding("901", true, 50, 2932, 203, 3211, 231, 3197, 459, 2923, 444);
    addBuilding("Mec", false, 52, 3241, 240, 3460, 248, 3518, 473, 3221, 457);

    addBuilding("Shaw", true, 55, 3569, 251, 3935, 247, 3965, 385, 3627, 457);
    addBuilding("NaturesPath", true, 59, 4043, 241, 4392, 214, 4407, 284, 4081, 354);
  }

  /**
   * Helper funtion to add building and name to hashmap buildings
   */
  void addBuilding(String name, Boolean c, int doorNodeId, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) 
  {
    Building newBuilding = new Building(name, c, doorNodeId, x1, y1, x2, y2, x3, y3, x4, y4);
    buildings.put(name, newBuilding);
  }
}