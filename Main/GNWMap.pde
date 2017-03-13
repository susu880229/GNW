class GNWMap
{
  HashMap<String, Building> buildings; //String is building id
  PImage mapImage;
  PImage mapDoorsImage;

  //define the five use categories ArrayList
  ArrayList<Building> artCultureBuildings;
  ArrayList<Building> lightIndustrialBuildings;
  ArrayList<Building> officesBuildings;
  ArrayList<Building> residentalBuildings;
  ArrayList<Building> retailBuildings;
  //define the two time use_flow matrix
  ArrayList<UseFlow> noonFlow;
  ArrayList<UseFlow> midNightFlow;
  ArrayList<Path> flowPaths;

  boolean isBuildingUseChanged;
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
    //initialize the five use ArrayList
    artCultureBuildings = new ArrayList<Building>();
    lightIndustrialBuildings = new ArrayList<Building>();
    officesBuildings = new ArrayList<Building>();
    residentalBuildings = new ArrayList<Building>();
    retailBuildings = new ArrayList<Building>();
    //initialize the two time flows
    noonFlow = new ArrayList<UseFlow>();
    midNightFlow = new ArrayList<UseFlow>();
    //initialize the hashmap use_buildings
    use_buildings();
    //initialize the hashmap use_flows
    use_flows();
    createUseFlow();
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
      selectedBuilding.drawTooltip();
    }
  }

  /**
   * Check if a tooltip is selected; if it is, delete the building use selected 
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
      if (building.contains(mouseX - shiftX, mouseY)) {
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

  void assignBuildingUse(BuildingUse selectedBuildingUse) {

    try {
      Building building = findBuilding();
      building.addBuildingUse(selectedBuildingUse);
      add_useBuildings(selectedBuildingUse, building);
      isBuildingUseChanged = true;
      selectedBuilding = building;
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
    PVector[] dotCoords_lot5 = {new PVector(367, 190), new PVector(306, 230), new PVector(351, 281)};
    PVector[] dotCoords_lot7 = {new PVector(363, 619), new PVector(305, 642), new PVector(319, 690)};
    PVector[] dotCoords_lot4 = {new PVector(461, 217), new PVector(609, 215)};
    PVector[] dotCoords_521 = {new PVector(483, 428), new PVector(425, 476), new PVector(464, 508)};
    PVector[] dotCoords_515 = {new PVector(428, 637), new PVector(486, 644), new PVector(534, 606)};
    PVector[] dotCoords_1933 = {new PVector(1438, 284), new PVector(1526, 266)};
    PVector[] dotCoords_701 = {new PVector(1746, 350), new PVector(1963, 373), new PVector(2154, 352)};
    PVector[] dotCoords_1980 = {new PVector(2424, 220), new PVector(2456, 373)};
    PVector[] dotCoords_887 = {new PVector(2826, 385)};
    PVector[] dotCoords_901 = {new PVector(2967, 402), new PVector(3047, 408), new PVector(3142, 416)};
    PVector[] dotCoords_Shaw = {new PVector(3653, 384), new PVector(3773, 376), new PVector(3901, 336)};
    PVector[] dotCoords_NaturesPath = {new PVector(4102, 302), new PVector(4338, 250)};

    addBuilding("Lot5", true, 64, 285, 155, 390, 164, 387, 300, 277, 305, dotCoords_lot5);
    addBuilding("Lot7", true, 7, 272, 571, 379, 580, 392, 698, 280, 720, dotCoords_lot7);
    addBuilding("Lot4", true, 17, 417, 167, 645, 175, 648, 260, 417, 260, dotCoords_lot4);

    addBuilding("521", true, 14, 401, 390, 524, 398, 521, 532, 402, 532, dotCoords_521);
    addBuilding("515", true, 12, 401, 579, 543, 571, 564, 660, 410, 695, dotCoords_515);

    addBuilding("1933", true, 38, 1376, 152, 1539, 153, 1566, 283, 1408, 309, dotCoords_1933);

    addBuilding("701", false, 44, 1662, 217, 2185, 224, 2221, 418, 1690, 401, dotCoords_701);
    addBuilding("1980", false, 46, 2296, 166, 2528, 164, 2699, 432, 2353, 424, dotCoords_1980);
    addBuilding("887", false, 48, 2578, 173, 2904, 198, 2899, 448, 2765, 444, dotCoords_887);
    addBuilding("901", false, 50, 2932, 203, 3211, 231, 3197, 459, 2923, 444, dotCoords_901);

    addBuilding("Shaw", false, 55, 3569, 251, 3935, 247, 3965, 385, 3627, 457, dotCoords_Shaw);
    addBuilding("NaturesPath", false, 59, 4043, 241, 4392, 214, 4407, 284, 4081, 354, dotCoords_NaturesPath);
  }

  /**
   * Helper funtion to add building and name to hashmap buildings
   */
  void addBuilding(String name, Boolean c, int doorNodeId, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, PVector[] bUDotCoords) 
  {
    BuildingCoords buildingCoords = new BuildingCoords(x1, y1, x2, y2, x3, y3, x4, y4);
    Building newBuilding = new Building(name, c, doorNodeId, buildingCoords, bUDotCoords);
    buildings.put(name, newBuilding);
  }


  void addUseFlow(int time, String from, String to, int number)
  {

    UseFlow use_flow = new UseFlow(time, from, to, number);
    if (time == 12)
    {
      noonFlow.add(use_flow);
    } else if (time == 23)
    {
      midNightFlow.add(use_flow);
    }
  }

  void createUseFlow()
  { 
    //business out
    addUseFlow(12, "Business", "Art and Culture", 20 );
    addUseFlow(12, "Business", "Park and Public", 20  );
    addUseFlow(12, "Business", "Transit", 30 );
    addUseFlow(12, "Business", "Neighborhood", 20 );
    addUseFlow(12, "Business", "Retail", 50);

    //education out
    addUseFlow(12, "Education", "Art and Culture", 30);
    addUseFlow(12, "Education", "Park and Public", 20);
    addUseFlow(12, "Education", "Transit", 30);
    addUseFlow(12, "Education", "Neighborhood", 20);
    addUseFlow(12, "Education", "Retail", 50);

    //resident out
    addUseFlow(12, "Resident", "Art and Culture", 5);
    addUseFlow(12, "Resident", "Park and Public", 5);
    addUseFlow(12, "Resident", "Transit", 10);
    addUseFlow(12, "Resident", "Neighborhood", 5);
    addUseFlow(12, "Resident", "Retail", 20);

    //transit out
    addUseFlow(12, "Transit", "Art and Culture", 10);
    addUseFlow(12, "Transit", "Park and Public", 10);
    addUseFlow(12, "Transit", "Neighborhood", 10);
    addUseFlow(12, "Transit", "Retail", 30);

    //neighborhood out
    addUseFlow(12, "Neighborhood", "Art and Culture", 10);
    addUseFlow(12, "Neighborhood", "Park and Public", 10);
    addUseFlow(12, "Neighborhood", "Transit", 30);
    addUseFlow(12, "Neighborhood", "Retail", 30);

    //light induestry out
    addUseFlow(12, "Light Industry", "Art and Culture", 10);
    addUseFlow(12, "Light Industry", "Park and Public", 20);
    addUseFlow(12, "Light Industry", "Transit", 30);
    addUseFlow(12, "Light Industry", "Neighborhood", 20);
    addUseFlow(12, "Light Industry", "Retail", 50);

    //Park and public realms out
    addUseFlow(23, "Park and Public", "Transit", 5);
    addUseFlow(23, "Park and Public", "Neighborhood", 5);
    addUseFlow(23, "Park and Public", "Resident", 5);

    //Transit out
    addUseFlow(23, "Transit", "Neighborhood", 10);
    addUseFlow(23, "Transit", "Resident", 10);
    addUseFlow(23, "Transit", "Retail", 5);

    //Neighbourhood out
    addUseFlow(23, "Neighborhood", "Park and Public", 5);
    addUseFlow(23, "Neighborhood", "Retail", 5);

    //Resident out
    addUseFlow(23, "Resident", "Park and Public", 5);
    addUseFlow(23, "Resident", "Retail", 5);

    //retail out
    addUseFlow(23, "Retail", "Transit", 20);
    addUseFlow(23, "Retail", "Neighborhood", 10);
    addUseFlow(23, "Retail", "Resident", 10);
  }

  //initialize the five key and value paires for the use_buldings hashmap
  void use_buildings()
  {
    use_buildings.put("Resident", residentalBuildings);
    use_buildings.put("Business", officesBuildings);
    use_buildings.put("Art and Culture", artCultureBuildings);
    use_buildings.put("Light Industry", lightIndustrialBuildings);
    use_buildings.put("Retail", retailBuildings);
  }

  //initialize the time key and the matrix respond for the use_flows hashmap 
  void use_flows()
  {
    use_flows.put(12, noonFlow);
    use_flows.put(23, midNightFlow);
  }

  //add building to the use_buildings specific arraylist 
  void add_useBuildings(BuildingUse selectedBuildingUse, Building building)
  {
    if (selectedBuildingUse.name == "Resident") {
      residentalBuildings.add(building);
    } else if (selectedBuildingUse.name == "Business") {
      officesBuildings.add(building);
    } else if (selectedBuildingUse.name == "Art and Culture") {
      artCultureBuildings.add(building);
    } else if (selectedBuildingUse.name =="Light Industry") {
      lightIndustrialBuildings.add(building);
    } else if (selectedBuildingUse.name =="Retail") {
      retailBuildings.add(building);
    }
  }
}