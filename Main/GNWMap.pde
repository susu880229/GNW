class GNWMap
{
  HashMap<String, Building> buildings; //String is building id
  PImage mapImage;

  //define the five time use_flow matrix
  ArrayList<UseFlow> morningFlow;
  ArrayList<UseFlow> noonFlow;
  ArrayList<UseFlow> afternoonFlow;
  ArrayList<UseFlow> eveningFlow;
  ArrayList<UseFlow> lateEveningFlow;

  ArrayList<FlowRoute> flowRoutes;
  ArrayList<Particle> particles;

  boolean isBuildingUseChanged;
  Building selectedBuilding;
  //Boolean PCIMode = false;
  Boolean show = true;

  int newAssignedBuildingID = -1;

  GNWMap() 
  {
    mapImage = loadImage("map.png");
    buildings = new HashMap<String, Building>();
    isBuildingUseChanged = false;
    flowRoutes = new ArrayList<FlowRoute>();
    particles = new ArrayList<Particle>();
    //selectedBuilding = null;
    createGNWMap();
    selectedBuilding = buildings.get("Lot7");
    //initialize the five time flows
    morningFlow = new ArrayList<UseFlow>();
    noonFlow = new ArrayList<UseFlow>();
    afternoonFlow = new ArrayList<UseFlow>();
    eveningFlow = new ArrayList<UseFlow>();
    lateEveningFlow = new ArrayList<UseFlow>();

    //initialize the hashmap use_flows
    use_flows();
    createUseFlowFromFile();
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

  void showSelectedBuilding() 
  {
    if (selectedBuilding != null) {
      selectedBuilding.drawTooltip();
      if (show)
      {
        selectedBuilding.draw_placeHolder(); //draw the place holder only once
      }
    }
  }

  /**
   * Check if a tooltip is selected; if it is, delete the building use selected 
   */
  void selectTooltip() throws Exception
  {
    if (selectedBuilding != null) 
    {   
      selectedBuilding.deleteBuildingUse(particles, flowRoutes);

      for (int i = 0; i < flowRoutes.size(); i++)
      {
        flowRoutes.get(i).delay = flowRoutes.get(i).numDelayUnit * 100;
      }

      checkFlowDelayLimit(); 

      GNWInterface.isDefaultSelected = false;          //clear the UI button border
      GNWInterface.isPCIVisionSelected = false;        //clear the UI button border

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
      if (building.buildingCoords.contains()) {
        selectedBuilding = (selectedBuilding == building) ? null : building; 
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
    //if there is a change of time, rebuild all flow routes and particles
    if (timeIsChanged)
    {
      flowRoutes = new ArrayList<FlowRoute>();
      particles = new ArrayList<Particle>();
    }
    for (Map.Entry buildingEntry : buildings.entrySet()) 
    {
      Building building = (Building) buildingEntry.getValue();
      flowRoutes = building.findParticleGenRate(flowRoutes);
    }

    checkFlowDelayLimit();

    if (!timeIsChanged && newAssignedBuildingID != -1)
    {
      drawFirstParticle();
    }
  }

  void drawFirstParticle()
  {
    boolean hasNewOutFlow = false;

    for (int i = 0; i < flowRoutes.size(); i++) 
    {
      FlowRoute curFlowRoute = flowRoutes.get(i);
      if (curFlowRoute.initial_nodeID == newAssignedBuildingID)
      {
        particles.add(curFlowRoute.getNewParticle());
        hasNewOutFlow = true;
        break;
      }
    }

    if (!hasNewOutFlow)
    {
      for (int j = 0; j < flowRoutes.size(); j++)
      {
        FlowRoute curFlowRoute = flowRoutes.get(j);
        if (curFlowRoute.isStartOfFlow && curFlowRoute.dest_nodeID == newAssignedBuildingID)
        {
          particles.add(curFlowRoute.getNewParticle());
          break;
        }
      }
    }

    newAssignedBuildingID = -1;
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
        particles.add(flowRoutes.get(i).getNewParticle());
        if (flowRoutes.get(i).isStartOfFlow == true)
        {
          flowRoutes.get(i).timeToNextParticleGen = (int)random(0, flowRoutes.get(i).delay); //set time for second particle
          flowRoutes.get(i).isStartOfFlow = false;
        } else
        {
          flowRoutes.get(i).timeToNextParticleGen = flowRoutes.get(i).delay;
        }
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

  //For each building and use, check if the level of flow going in and out of it is more than the limit set. If it is, limit the flow level.
  void checkFlowDelayLimit()
  {
    for (Map.Entry buildingEntry : buildings.entrySet()) 
    {
      Building building = (Building) buildingEntry.getValue();
      flowRoutes = building.checkDelayLimit(flowRoutes, false, true); //boolean arguments: isIn, isOut
      flowRoutes = building.checkDelayLimit(flowRoutes, true, false); //boolean arguments: isIn, isOut
    }
  }

  void assignBuildingUse(BuildingUse selectedBuildingUse) 
  {
    try 
    {
      Building building = findBuilding();
      //add the use to the building as well as add building to the use 
      building.addBuildingUse(selectedBuildingUse);
      isBuildingUseChanged = true;

      ArrayList<BuildingUse> buildingUses = new ArrayList<BuildingUse>();
      buildingUses.add(selectedBuildingUse);     
      selectedBuilding = building;

      newAssignedBuildingID = building.doorNodeId;
    } 
    catch (Exception e) {
      //if no building found, don't do anything
    }
  }

  Building findBuilding() throws Exception 
  {
    for (Map.Entry buildingEntry : buildings.entrySet()) 
    {
      Building building = (Building) buildingEntry.getValue();
      if (building.buildingCoords.contains())
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
    PVector[] dotCoords_lot5 = {new PVector(340, 182), new PVector(304, 234), new PVector(332, 280)}; 
    PVector[] dotCoords_lot7 = {new PVector(356, 600), new PVector(300, 645), new PVector(324, 692)};
    PVector[] dotCoords_lot4 = {new PVector(476, 215), new PVector(594, 215)};
    PVector[] dotCoords_521 = {new PVector(464, 417), new PVector(428, 468), new PVector(460, 512)};
    PVector[] dotCoords_515 = {new PVector(429, 637), new PVector(481, 640), new PVector(531, 620)};
    PVector[] dotCoords_1933 = {new PVector(1436, 270), new PVector(1519, 255)};
    PVector[] dotCoords_701 = {new PVector(1780, 336), new PVector(1960, 350), new PVector(2133, 347)};
    PVector[] dotCoords_1980 = {new PVector(2430, 228), new PVector(2485, 376)};
    PVector[] dotCoords_887 = {new PVector(2820, 380)};
    PVector[] dotCoords_901 = {new PVector(2972, 399), new PVector(3065, 407), new PVector(3157, 417)};
    PVector[] dotCoords_Shaw = {new PVector(3666, 395), new PVector(3783, 376), new PVector(3901, 350)};
    PVector[] dotCoords_NaturesPath = {new PVector(4115, 305), new PVector(4353, 255)};
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
    HotspotCoords buildingCoords = new HotspotCoords(x1, y1, x2, y2, x3, y3, x4, y4);
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
    BuildingUse office = buildingUses.get("Office");
    BuildingUse resident = buildingUses.get("Resident");
    BuildingUse student_resident = buildingUses.get("Student Resident");

    buildings.get("Park").addPermanentUse(park);
    buildings.get("Plaza").addPermanentUse(park);
    buildings.get("Lot7").addPermanentUse(transit);
    buildings.get("EmilyCarr").addPermanentUse(school);
    buildings.get("569").addPermanentUse(retail);
    buildings.get("569").addPermanentUse(office);
    buildings.get("CDM1").addPermanentUse(school);
    buildings.get("CDM2").addPermanentUse(school);
    buildings.get("CDM2").addPermanentUse(student_resident);
    buildings.get("887").addPermanentUse(office);
    buildings.get("Mec").addPermanentUse(office);
    buildings.get("Transit").addPermanentUse(transit);
    buildings.get("Neighbourhood1").addPermanentUse(neighbour);
    buildings.get("Neighbourhood2").addPermanentUse(neighbour);
    buildings.get("Neighbourhood3").addPermanentUse(neighbour);

    makeDefaultUseFromFile();
  }

  /**
   * Creates graph from text file 
   * @param g Initial graph
   * @param fname Filenamet
   */
  void makeDefaultUseFromFile() 
  {
    String tagString = (PCIMode) ? "PCIMode" : "default";
    String lines[];
    lines = loadStrings("customize_use.txt");
    int mode = 0;
    int count = 0;
    while (count < lines.length) {
      lines[count].trim();
      if (!lines[count].startsWith("#") && lines[count].length() > 1) {
        switch(mode) {
        case 0:
          if (lines[count].equalsIgnoreCase("<" + tagString +">")) {
            mode = 1;
          }
          break;
        case 1:
          if (lines[count].equalsIgnoreCase("</" + tagString +">")) {
            mode = 0;
          } else {
            makeDefaultBuildingUse(lines[count]);
          }
          break;
        } // end switch
      } // end if
      count++;
    } // end while
  }

  void makeDefaultBuildingUse(String s) 
  {
    String part[] = split(s, " = ");
    if (part.length == 2) {
      String buildingName = part[0];
      BuildingUse buildingUse = buildingUses.get(part[1]);

      try {
        buildings.get(buildingName).addBuildingUse(buildingUse);
      } 
      catch (Exception e) {
        println("Issue with making building uses from file: " + e);
      }
    }
  }

  void addUseFlow(int timeID, String from, String to, int number)
  {

    UseFlow use_flow = new UseFlow(timeID, from, to, number);
    if (timeID == 0)
    {
      morningFlow.add(use_flow);
    } else if (timeID == 1)
    {
      noonFlow.add(use_flow);
    } else if (timeID == 2)
    {
      afternoonFlow.add(use_flow);
    } else if (timeID == 3)
    {
      eveningFlow.add(use_flow);
    } else if (timeID == 4)
    {
      lateEveningFlow.add(use_flow);
    }
  }

  //read flow matrix from flow_matrix.txt and put them into the respective use_flow arrays.
  void createUseFlowFromFile()
  { 
    String lines[];
    lines = loadStrings("flow_matrix.txt");
    int count = 0;
    while (count < lines.length) {
      lines[count].trim();
      if (!lines[count].startsWith("#") && lines[count].length() > 1) {
        makeUseFlow(lines[count]);
      }
      count++;
    }
  }

  void makeUseFlow(String s)
  {
    String part[] = split(s, ";");  //parts: 0 = time ID, 1 = out building use, 2 = in building use, 3 = delay level
    if (part.length == 4)
    {
      int timeID = int(part[0]);
      String out_buildingUse = "" + part[1];
      String in_buildingUse = "" + part[2];
      int delayLevel = int(part[3]);

      try 
      {
        addUseFlow(timeID, out_buildingUse, in_buildingUse, delayLevel);
      } 
      catch (Exception e) 
      {
        println("Issue with making use flows from file: " + e);
      }
    }
  }


  //initialize the time key and the matrix respond for the use_flows hashmap 
  void use_flows()
  {
    use_flows.put(0, morningFlow);
    use_flows.put(1, noonFlow);
    use_flows.put(2, afternoonFlow);
    use_flows.put(3, eveningFlow);
    use_flows.put(4, lateEveningFlow);
  }

  int getNumParticles()
  {
    return particles.size();
  }
}