import java.util.Map;

class GNWMap
{
  HashMap<String, Building> buildings; //String is building id
  PImage mapImage;
<<<<<<< HEAD
  ArrayList<Building> LIndustryBuildings;
  ArrayList<Building> businessBuildings;
  ArrayList<Building> ACbuildings;
  ArrayList<Building> residentBuildings;
  ArrayList<Building> retailBuildings;
 
  
=======
  boolean isBuildingUseAdded;
  ArrayList<Path> flowPaths;
>>>>>>> master

  GNWMap() 
  {
    mapImage = loadImage("map.png");
    buildings = new HashMap<String, Building>();
<<<<<<< HEAD
=======
    isBuildingUseAdded = false;
    flowPaths = new ArrayList<Path>();

>>>>>>> master
    createGNWMap();
    LIndustryBuildings = new ArrayList<Building>();
    businessBuildings = new ArrayList<Building>();
    ACbuildings = new ArrayList<Building>();
    residentBuildings = new ArrayList<Building>();
    retailBuildings = new ArrayList<Building>();
    use_buildings(); //initialize the use_buildings hash
    createUseFlow(); //load the all types of flow path 
    //UpdatePerson = false;
  }

  void render()
  {
    image(mapImage, 0, 0);

    //walk through the GNWmap to render building
    for (Map.Entry buildingEntry : buildings.entrySet()) {
      Building building = (Building) buildingEntry.getValue();
      building.render();
    }
  }
<<<<<<< HEAD
  
  /*
  void UpdateFlow() {
    for (Map.Entry buildingEntry : buildings.entrySet()) {
      Building building = (Building) buildingEntry.getValue();
      building.generatePerson();
=======

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
>>>>>>> master
    }
    //UpdatePerson = false;
  }
  */
  
  void assignBuildingUse(BuildingUse selectedBuildingUse) throws Exception {
    try {
      Building building = findBuilding();
<<<<<<< HEAD
      building.addBuildingUse(selectedBuildingUse);
      add_useBuildings(selectedBuildingUse, building);
      //UpdatePerson = true;
=======

      if (building.isCustomizable) {
        building.addBuildingUse(selectedBuildingUse);
        isBuildingUseAdded = true;
      }
>>>>>>> master
    } 
    catch (Exception e) {
      //if no building found, don't do anything
    }
  }

  //Note: shiftX is referring to global public variable from Main. It tracks the change in x via horizontal scroll.
  Building findBuilding() throws Exception {
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
  
  
  void addUseFlow(int time, String from, String to, int number)
  {
    UseFlow use_flow = new UseFlow(time, from, to, number);
    use_flows.add(use_flow);
    
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
  }
  
  //initialize the five key and value paires for the use_buldings hashmap
  void use_buildings()
  {
  
    use_buildings.put("Resident", residentBuildings);
    use_buildings.put("Business", businessBuildings);
    use_buildings.put("Art and Culture", ACbuildings);
    use_buildings.put("Light Industry", LIndustryBuildings);
    use_buildings.put("Retail", retailBuildings);
  
  }
  //add building to the use_buildings specific arraylist 
  void add_useBuildings(BuildingUse selectedBuildingUse, Building building)
  {
    if (selectedBuildingUse.name == "Resident") {
        residentBuildings.add(building);
    } else if (selectedBuildingUse.name == "Business") {
        businessBuildings.add(building);
    } else if (selectedBuildingUse.name == "Art and Culture") {
        ACbuildings.add(building);
    } else if (selectedBuildingUse.name =="Light Industry") {
        LIndustryBuildings.add(building);
    } else if (selectedBuildingUse.name =="Retail") {
        retailBuildings.add(building);
    }
    
  }
  
  
  
  
}