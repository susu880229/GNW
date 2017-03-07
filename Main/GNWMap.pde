import java.util.Map;

class GNWMap
{
  HashMap<String, Building> buildings; //String is building id
  PImage mapImage;
  ArrayList<Building> LIndustryBuildings;
  ArrayList<Building> businessBuildings;
  ArrayList<Building> ACbuildings;
  ArrayList<Building> residentBuildings;
  ArrayList<Building> retailBuildings;
 
  

  GNWMap() 
  {
    mapImage = loadImage("map.png");
    buildings = new HashMap<String, Building>();
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
  
  /*
  void UpdateFlow() {
    for (Map.Entry buildingEntry : buildings.entrySet()) {
      Building building = (Building) buildingEntry.getValue();
      building.generatePerson();
    }
    //UpdatePerson = false;
  }
  */
  
  void assignBuildingUse(BuildingUse selectedBuildingUse) throws Exception {
    try {
      Building building = findBuilding();
      building.addBuildingUse(selectedBuildingUse);
      add_useBuildings(selectedBuildingUse, building);
      //UpdatePerson = true;
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
    addBuilding("Lot5", true, 64, 272, 147, 354, 153, 347, 247, 268, 248);
    addBuilding("Park", false, 5, 267, 302, 350, 298, 341, 464, 271, 465);
    addBuilding("Lot7", true, 7, 265, 519, 342, 520, 360, 620, 276, 641);

    addBuilding("Lot4", true, 17, 394, 159, 586, 162, 584, 212, 400, 213);
    addBuilding("521", true, 14, 379, 364, 476, 367, 473, 463, 382, 466);  
    addBuilding("515", true, 12, 376, 533, 489, 522, 513, 580, 382, 603);

    addBuilding("EmilyCarr", false, 28, 535, 352, 924, 255, 951, 344, 565, 443); 
    addBuilding("Plaza", false, 22, 531, 517, 643, 491, 658, 546, 551, 573);
    addBuilding("569", false, 26, 678, 485, 1075, 386, 1091, 434, 700, 539);

    addBuilding("CDM1", false, 34, 1115, 177, 1235, 146, 1283, 336, 1167, 371);
    addBuilding("1933", true, 38, 1273, 147, 1406, 136, 1428, 225, 1297, 258);
    addBuilding("CDM2", false, 41, 1304, 312, 1444, 284, 1463, 352, 1314, 366); 

    addBuilding("701", true, 44, 1541, 210, 2000, 210, 2023, 357, 1575, 355); 
    addBuilding("1980", true, 46, 2117, 155, 2275, 150, 2412, 380, 2161, 368);
    addBuilding("887", true, 48, 2438, 157, 2655, 178, 2656, 381, 2578, 385);
    addBuilding("901", true, 50, 2701, 184, 2937, 210, 2924, 395, 2704, 386);
    addBuilding("Mec", false, 52, 2983, 217, 3163, 225, 3211, 404, 2977, 401);

    addBuilding("Shaw", true, 55, 3299, 225, 3595, 224, 3623, 326, 3346, 398);
    addBuilding("NaturesPath", true, 59, 3729, 218, 4022, 200, 4033, 237, 3754, 300);
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