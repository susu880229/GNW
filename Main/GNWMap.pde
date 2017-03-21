class GNWMap
{
  HashMap<String, Building> buildings; //String is building id
  PImage mapImage;
  PImage mapDoorsImage;

  //define the five time use_flow matrix
  ArrayList<UseFlow> morningFlow;
  ArrayList<UseFlow> noonFlow;
  ArrayList<UseFlow> afternoonFlow;
  ArrayList<UseFlow> eveningFlow;
  ArrayList<UseFlow> midNightFlow;

  ArrayList<FlowRoute> flowRoutes;
  ArrayList<Particle> particles;

  boolean isBuildingUseChanged;
  Building selectedBuilding;

  GNWMap() 
  {
    mapImage = loadImage("map.png");
    mapDoorsImage = loadImage("mapDoors.png");
    buildings = new HashMap<String, Building>();
    isBuildingUseChanged = false;
    flowRoutes = new ArrayList<FlowRoute>();
    particles = new ArrayList<Particle>();
    selectedBuilding = null;

    createGNWMap();

    //initialize the five time flows
    morningFlow = new ArrayList<UseFlow>();
    noonFlow = new ArrayList<UseFlow>();
    afternoonFlow = new ArrayList<UseFlow>();
    eveningFlow = new ArrayList<UseFlow>();
    midNightFlow = new ArrayList<UseFlow>();

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
      particles = selectedBuilding.deleteBuildingUse(particles);
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

  //build all the FlowRoutes on the map and set their particle generation rate
  void flowInit(boolean timeIsChanged)
  {
    flowRoutes = new ArrayList<FlowRoute>();
    if (timeIsChanged)
    {
      particles = new ArrayList<Particle>();
    }
    for (Map.Entry buildingEntry : buildings.entrySet()) {
      Building building = (Building) buildingEntry.getValue();
      flowRoutes = building.findParticleGenRate(flowRoutes);
    }
  }

  /*Check if new particles should be generated. 
   *Draw each particle on the map and calculate its next position.
   *If the particle has reached the end of the route, remove the particle.
   */
  void drawFlow()
  {
    for (int i = 0; i < flowRoutes.size(); i++) 
    {
      if (flowRoutes.get(i).timeToNextParticleGen == 0)
      {
        flowRoutes.get(i).addNewParticle(particles);
        flowRoutes.get(i).timeToNextParticleGen = flowRoutes.get(i).delay;
      } else
      {
        flowRoutes.get(i).timeToNextParticleGen -= 1;
      }
    }

    for (int j = particles.size() - 1; j >= 0; j--)      //loop backwards as we may remove some particles
    {
      particles.get(j).run();

      if (particles.get(j).isEndOfRoute == true)
      {
        particles.remove(j);
      }
    }
  }

  void assignBuildingUse(BuildingUse selectedBuildingUse) {

    try {
      Building building = findBuilding();
      //add the use to the building as well as add building to the use 
      building.addBuildingUse(selectedBuildingUse);
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
    PVector[] dotCoords_lot7 = {new PVector(356, 594), new PVector(305, 640), new PVector(315, 682)};
    PVector[] dotCoords_lot4 = {new PVector(476, 208), new PVector(594, 202)};
    PVector[] dotCoords_521 = {new PVector(464, 410), new PVector(428, 466), new PVector(464, 508)};
    PVector[] dotCoords_515 = {new PVector(428, 637), new PVector(486, 644), new PVector(534, 606)};
    PVector[] dotCoords_1933 = {new PVector(1433, 260), new PVector(1519, 242)};
    PVector[] dotCoords_701 = {new PVector(1757, 306), new PVector(1950, 336), new PVector(2129, 312)};
    PVector[] dotCoords_1980 = {new PVector(2424, 220), new PVector(2456, 373)};
    PVector[] dotCoords_887 = {new PVector(2826, 385)};
    PVector[] dotCoords_901 = {new PVector(2967, 402), new PVector(3047, 408), new PVector(3142, 416)};
    PVector[] dotCoords_Shaw = {new PVector(3653, 384), new PVector(3773, 376), new PVector(3901, 336)};
    PVector[] dotCoords_NaturesPath = {new PVector(4102, 302), new PVector(4338, 250)};
    PVector[] dotCoords_null = null;

    addBuilding("Lot5", true, 64, 285, 155, 390, 164, 387, 300, 277, 305, dotCoords_lot5);
    addBuilding("Park", false, 5, 274, 333, 383, 330, 376, 525, 279, 520, dotCoords_null);
    addBuilding("Lot7", true, 7, 272, 571, 379, 580, 392, 698, 280, 720, dotCoords_lot7);

    addBuilding("Lot4", true, 17, 417, 167, 645, 175, 648, 260, 417, 260, dotCoords_lot4);
    addBuilding("521", true, 14, 401, 390, 524, 398, 521, 532, 402, 532, dotCoords_521);
    addBuilding("515", true, 12, 401, 579, 543, 571, 564, 660, 410, 695, dotCoords_515);

    addBuilding("EmilyCarr", false, 28, 570, 378, 1128, 251, 1155, 378, 604, 507, dotCoords_null);
    addBuilding("Plaza", false, 22, 568, 567, 702, 538, 721, 616, 593, 650, dotCoords_null);
    addBuilding("569", false, 26, 728, 528, 1182, 420, 1201, 500, 750, 612, dotCoords_null);

    addBuilding("CDM1", false, 34, 1207, 188, 1353, 156, 1400, 394, 1260, 425, dotCoords_null);
    addBuilding("1933", true, 38, 1376, 152, 1539, 153, 1566, 283, 1408, 309, dotCoords_1933);
    addBuilding("CDM2", false, 41, 1415, 344, 1577, 313, 1600, 411, 1425, 422, dotCoords_null);

    addBuilding("701", false, 44, 1662, 217, 2185, 224, 2221, 418, 1690, 401, dotCoords_701);
    addBuilding("1980", false, 46, 2296, 166, 2528, 164, 2699, 432, 2353, 424, dotCoords_1980);
    addBuilding("887", false, 48, 2578, 173, 2904, 198, 2899, 448, 2765, 444, dotCoords_887);
    addBuilding("901", false, 50, 2932, 203, 3211, 231, 3197, 459, 2923, 444, dotCoords_901);
    addBuilding("Mec", false, 52, 3241, 240, 3460, 248, 3518, 473, 3221, 457, dotCoords_null);

    addBuilding("Shaw", false, 55, 3569, 251, 3935, 247, 3965, 385, 3627, 457, dotCoords_Shaw);
    addBuilding("NaturesPath", false, 59, 4043, 241, 4392, 214, 4407, 284, 4081, 354, dotCoords_NaturesPath);
    addBuilding("Transit", false, 57, 4030, 241, 4050, 214, 4030, 220, 4050, 220, dotCoords_null);

    addBuilding("Neighbourhood1", false, 1, 5, 820, 10, 820, 10, 830, 5, 830, dotCoords_null);
    addBuilding("Neighbourhood2", false, 62, 260, 170, 270, 170, 270, 180, 260, 180, dotCoords_null);
    addBuilding("Neighbourhood3", false, 60, 4485, 295, 4495, 295, 4495, 305, 4485, 305, dotCoords_null);
  }

  /**
   * Helper funtion to add building and name to hashmap buildings
   */
  void addBuilding(String name, Boolean isSmallDot, int doorNodeId, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, PVector[] bUDotCoords) 
  {
    BuildingCoords buildingCoords = new BuildingCoords(x1, y1, x2, y2, x3, y3, x4, y4);
    Building newBuilding = new Building(name, isSmallDot, doorNodeId, buildingCoords, bUDotCoords);
    buildings.put(name, newBuilding);
  }

  void addDefaultBuildingUses() 
  {
    BuildingUse park = buildingUses.get("Park and Public");
    BuildingUse school = buildingUses.get("Education");
    BuildingUse transit = buildingUses.get("Transit");
    BuildingUse neighbour = buildingUses.get("Neighborhood");
    BuildingUse retail = buildingUses.get("Retail");
    BuildingUse art = buildingUses.get("Art and Culture");
    BuildingUse office = buildingUses.get("Business");
    BuildingUse resident = buildingUses.get("Resident");

    buildings.get("Park").addPermanentUse(park);
    buildings.get("Plaza").addPermanentUse(park);
    buildings.get("Lot7").addPermanentUse(transit);
    buildings.get("EmilyCarr").addPermanentUse(school);
    buildings.get("EmilyCarr").addPermanentUse(art);
    buildings.get("569").addPermanentUse(retail);
    buildings.get("569").addPermanentUse(office);
    buildings.get("CDM1").addPermanentUse(school);
    buildings.get("CDM2").addPermanentUse(school);
    buildings.get("CDM2").addPermanentUse(resident);
    buildings.get("887").addPermanentUse(office);
    buildings.get("Mec").addPermanentUse(office);
    buildings.get("Transit").addPermanentUse(transit);
    buildings.get("Neighbourhood1").addPermanentUse(neighbour);
    buildings.get("Neighbourhood2").addPermanentUse(neighbour);
    buildings.get("Neighbourhood3").addPermanentUse(neighbour);

    try {
      buildings.get("901").addBuildingUse(office);
      buildings.get("Shaw").addBuildingUse(office);
    } 
    catch (Exception e) {
      println("Initial setup error: " + e);
    }
  }

  void addUseFlow(String time, String from, String to, int number)
  {

    UseFlow use_flow = new UseFlow(time, from, to, number);
    if (time == "Morning")
    {
      morningFlow.add(use_flow);
    } else if (time == "Noon")
    {
      noonFlow.add(use_flow);
    } else if (time == "Afternoon")
    {
      afternoonFlow.add(use_flow);
    } else if (time == "Evening")
    {
      eveningFlow.add(use_flow);
    } else if (time == "Late_Evening")
    {
      midNightFlow.add(use_flow);
    }
  }

  void createUseFlow()
  { 
    /*MORNING
     *********/

    //business out
    addUseFlow("Morning", "Business", "Park and Public", 5);
    addUseFlow("Morning", "Business", "Retail", 4);

    //education out
    addUseFlow("Morning", "Education", "Park and Public", 5);
    addUseFlow("Morning", "Education", "Retail", 5);

    //resident out
    addUseFlow("Morning", "Resident", "Business", 2);
    addUseFlow("Morning", "Resident", "Art and Culture", 5);
    addUseFlow("Morning", "Resident", "Education", 2);
    addUseFlow("Morning", "Resident", "Park and Public", 4);
    addUseFlow("Morning", "Resident", "Transit", 2);
    addUseFlow("Morning", "Resident", "Neighborhood", 4);
    addUseFlow("Morning", "Resident", "Retail", 4);
    addUseFlow("Morning", "Resident", "Light Industry", 2);

    //transit out
    addUseFlow("Morning", "Transit", "Business", 1);
    addUseFlow("Morning", "Transit", "Art and Culture", 4);
    addUseFlow("Morning", "Transit", "Education", 1);
    addUseFlow("Morning", "Transit", "Park and Public", 4);
    addUseFlow("Morning", "Transit", "Neighborhood", 3);
    addUseFlow("Morning", "Transit", "Retail", 4);
    addUseFlow("Morning", "Transit", "Light Industry", 1);

    //neighborhood out
    addUseFlow("Morning", "Neighborhood", "Business", 3);
    addUseFlow("Morning", "Neighborhood", "Art and Culture", 5);
    addUseFlow("Morning", "Neighborhood", "Education", 3);
    addUseFlow("Morning", "Neighborhood", "Park and Public", 4);
    addUseFlow("Morning", "Neighborhood", "Transit", 2);
    addUseFlow("Morning", "Neighborhood", "Retail", 4);
    addUseFlow("Morning", "Neighborhood", "Light Industry", 3);

    //retail out
    addUseFlow("Morning", "Retail", "Transit", 5);
    addUseFlow("Morning", "Retail", "Light Industry", 4);

    //light industry out
    addUseFlow("Morning", "Light Industry", "Art and Culture", 4);
    addUseFlow("Morning", "Light Industry", "Park and Public", 3);
    addUseFlow("Morning", "Light Industry", "Transit", 2);
    addUseFlow("Morning", "Light Industry", "Neighborhood", 3);
    addUseFlow("Morning", "Light Industry", "Retail", 1);

    /*NOON
     ********/
    //business out
    addUseFlow("Noon", "Business", "Art and Culture", 3);
    addUseFlow("Noon", "Business", "Park and Public", 3);
    addUseFlow("Noon", "Business", "Transit", 2);
    addUseFlow("Noon", "Business", "Neighborhood", 3);
    addUseFlow("Noon", "Business", "Retail", 1);

    //education out
    addUseFlow("Noon", "Education", "Art and Culture", 2);
    addUseFlow("Noon", "Education", "Park and Public", 3);
    addUseFlow("Noon", "Education", "Transit", 2);
    addUseFlow("Noon", "Education", "Neighborhood", 3);
    addUseFlow("Noon", "Education", "Retail", 1);

    //resident out
    addUseFlow("Noon", "Resident", "Art and Culture", 4);
    addUseFlow("Noon", "Resident", "Park and Public", 4);
    addUseFlow("Noon", "Resident", "Transit", 4);
    addUseFlow("Noon", "Resident", "Neighborhood", 4);
    addUseFlow("Noon", "Resident", "Retail", 3);

    //transit out
    addUseFlow("Noon", "Transit", "Art and Culture", 3);
    addUseFlow("Noon", "Transit", "Park and Public", 4);
    addUseFlow("Noon", "Transit", "Neighborhood", 3);
    addUseFlow("Noon", "Transit", "Retail", 2);

    //neighborhood out
    addUseFlow("Noon", "Neighborhood", "Art and Culture", 4);
    addUseFlow("Noon", "Neighborhood", "Park and Public", 4);
    addUseFlow("Noon", "Neighborhood", "Transit", 3);
    addUseFlow("Noon", "Neighborhood", "Retail", 2);

    //light industry out
    addUseFlow("Noon", "Light Industry", "Art and Culture", 4);
    addUseFlow("Noon", "Light Industry", "Park and Public", 3);
    addUseFlow("Noon", "Light Industry", "Transit", 2);
    addUseFlow("Noon", "Light Industry", "Neighborhood", 3);
    addUseFlow("Noon", "Light Industry", "Retail", 1);

    /*AFTERNOON
     *********/

    //business out
    addUseFlow("Afternoon", "Business", "Transit", 6);
    addUseFlow("Afternoon", "Business", "Retail", 5);

    //education out
    addUseFlow("Afternoon", "Education", "Art and Culture", 4);
    addUseFlow("Afternoon", "Education", "Park and Public", 5);
    addUseFlow("Afternoon", "Education", "Transit", 2);
    addUseFlow("Afternoon", "Education", "Neighborhood", 4);
    addUseFlow("Afternoon", "Education", "Resident", 3);
    addUseFlow("Afternoon", "Education", "Retail", 3);

    //resident out
    addUseFlow("Afternoon", "Resident", "Art and Culture", 4);
    addUseFlow("Afternoon", "Resident", "Park and Public", 5);
    addUseFlow("Afternoon", "Resident", "Transit", 5);
    addUseFlow("Afternoon", "Resident", "Retail", 4);

    //transit out
    addUseFlow("Afternoon", "Transit", "Art and Culture", 4);
    addUseFlow("Afternoon", "Transit", "Park and Public", 5);
    addUseFlow("Afternoon", "Transit", "Retail", 4);

    //neighborhood out
    addUseFlow("Afternoon", "Neighborhood", "Art and Culture", 4);
    addUseFlow("Afternoon", "Neighborhood", "Park and Public", 5);
    addUseFlow("Afternoon", "Neighborhood", "Transit", 5);
    addUseFlow("Afternoon", "Neighborhood", "Retail", 4);

    //light industry out
    addUseFlow("Afternoon", "Light Industry", "Art and Culture", 5);
    addUseFlow("Afternoon", "Light Industry", "Park and Public", 6);
    addUseFlow("Afternoon", "Light Industry", "Transit", 4);
    addUseFlow("Afternoon", "Light Industry", "Neighborhood", 5);
    addUseFlow("Afternoon", "Light Industry", "Resident", 5);
    addUseFlow("Afternoon", "Light Industry", "Retail", 5);


    /*EVENING
     ********/
    //business out
    addUseFlow("Evening", "Business", "Art and Culture", 5);
    addUseFlow("Evening", "Business", "Park and Public", 5);
    addUseFlow("Evening", "Business", "Transit", 3);
    addUseFlow("Evening", "Business", "Neighborhood", 4);
    addUseFlow("Evening", "Business", "Resident", 4);
    addUseFlow("Evening", "Business", "Retail", 3);

    //resident out
    addUseFlow("Evening", "Resident", "Art and Culture", 5);
    addUseFlow("Evening", "Resident", "Park and Public", 4);
    addUseFlow("Evening", "Resident", "Transit", 5);
    addUseFlow("Evening", "Resident", "Neighborhood", 5);
    addUseFlow("Evening", "Resident", "Retail", 4);

    //transit out
    addUseFlow("Evening", "Transit", "Art and Culture", 4);
    addUseFlow("Evening", "Transit", "Park and Public", 5);
    addUseFlow("Evening", "Transit", "Neighborhood", 3);
    addUseFlow("Evening", "Transit", "Resident", 3);
    addUseFlow("Evening", "Transit", "Retail", 2);

    //neighborhood out
    addUseFlow("Evening", "Neighborhood", "Art and Culture", 5);
    addUseFlow("Evening", "Neighborhood", "Park and Public", 4);
    addUseFlow("Evening", "Neighborhood", "Transit", 4);
    addUseFlow("Evening", "Neighborhood", "Resident", 5);
    addUseFlow("Evening", "Neighborhood", "Retail", 3);

    //retail out
    addUseFlow("Evening", "Retail", "Transit", 4);
    addUseFlow("Evening", "Retail", "Neighborhood", 5);
    addUseFlow("Evening", "Retail", "Resident", 5);

    //light industry out
    addUseFlow("Evening", "Light Industry", "Art and Culture", 6);
    addUseFlow("Evening", "Light Industry", "Park and Public", 6);
    addUseFlow("Evening", "Light Industry", "Transit", 6);
    addUseFlow("Evening", "Light Industry", "Neighborhood", 6);
    addUseFlow("Evening", "Light Industry", "Resident", 6);
    addUseFlow("Evening", "Light Industry", "Retail", 6);


    /*LATE NIGHT
     ********/
    //Park and public realms out
    addUseFlow("Late_Evening", "Park and Public", "Neighborhood", 6);
    addUseFlow("Late_Evening", "Park and Public", "Resident", 6);

    //Transit out
    addUseFlow("Late_Evening", "Transit", "Neighborhood", 5);
    addUseFlow("Late_Evening", "Transit", "Resident", 5);
    addUseFlow("Late_Evening", "Transit", "Retail", 6);

    //Neighbourhood out
    addUseFlow("Late_Evening", "Neighborhood", "Park and Public", 6);
    addUseFlow("Late_Evening", "Neighborhood", "Retail", 6);

    //Resident out
    addUseFlow("Late_Evening", "Resident", "Park and Public", 6);
    addUseFlow("Late_Evening", "Resident", "Retail", 6);

    //retail out
    addUseFlow("Late_Evening", "Retail", "Transit", 4);
    addUseFlow("Late_Evening", "Retail", "Neighborhood", 5);
    addUseFlow("Late_Evening", "Retail", "Resident", 5);
  }

  //initialize the time key and the matrix respond for the use_flows hashmap 
  void use_flows()
  {
    use_flows.put("Morning", morningFlow);
    use_flows.put("Noon", noonFlow);
    use_flows.put("Afternoon", afternoonFlow);
    use_flows.put("Evening", eveningFlow);
    use_flows.put("Late_Evening", midNightFlow);
  }
}