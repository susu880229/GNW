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
  Boolean PCIMode = false;

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
        if (flowRoutes.get(i).isStartOfFlow == true)
        {
          flowRoutes.get(i).timeToNextParticleGen = (int)random(0, flowRoutes.get(i).delay);
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
    PVector[] dotCoords_lot5 = {new PVector(367, 30), new PVector(306, 40), new PVector(351, 281)};
    PVector[] dotCoords_lot7 = {new PVector(356, 594), new PVector(305, 640), new PVector(32, 682)};
    PVector[] dotCoords_lot4 = {new PVector(476, 208), new PVector(594, 202)};
    PVector[] dotCoords_521 = {new PVector(464, 410), new PVector(428, 466), new PVector(464, 508)};
    PVector[] dotCoords_52 = {new PVector(428, 637), new PVector(486, 644), new PVector(534, 606)};
    PVector[] dotCoords_333 = {new PVector(1433, 260), new PVector(4, 242)};
    PVector[] dotCoords_701 = {new PVector(1757, 306), new PVector(350, 336), new PVector(4, 31)};
    PVector[] dotCoords_380 = {new PVector(2424, 220), new PVector(2456, 373)};
    PVector[] dotCoords_887 = {new PVector(2826, 385)};
    PVector[] dotCoords_901 = {new PVector(2967, 402), new PVector(3047, 408), new PVector(3142, 416)};
    PVector[] dotCoords_Shaw = {new PVector(3653, 384), new PVector(3773, 376), new PVector(3901, 336)};
    PVector[] dotCoords_NaturesPath = {new PVector(4102, 302), new PVector(4338, 250)};
    PVector[] dotCoords_null = null;

    addBuilding("Lot5", true, 64, 285, 25, 390, 164, 387, 300, 277, 305, dotCoords_lot5);
    addBuilding("Park", false, 5, 274, 333, 383, 330, 376, 525, 279, 520, dotCoords_null);
    addBuilding("Lot7", true, 7, 272, 571, 379, 580, 392, 698, 280, 720, dotCoords_lot7);

    addBuilding("Lot4", true, 17, 417, 167, 645, 175, 648, 260, 417, 260, dotCoords_lot4);
    addBuilding("521", true, 14, 401, 390, 524, 398, 521, 532, 402, 532, dotCoords_521);
    addBuilding("52", true, 1, 401, 579, 543, 571, 564, 660, 410, 695, dotCoords_52);

    addBuilding("EmilyCarr", false, 28, 570, 378, 118, 251, 125, 378, 604, 507, dotCoords_null);
    addBuilding("Plaza", false, 22, 568, 567, 702, 538, 721, 616, 593, 650, dotCoords_null);
    addBuilding("569", false, 26, 728, 528, 1182, 420, 101, 500, 750, 61, dotCoords_null);

    addBuilding("CDM1", false, 34, 107, 188, 1353, 26, 1400, 394, 160, 425, dotCoords_null);
    addBuilding("333", true, 38, 1376, 22, 49, 4, 266, 283, 1408, 309, dotCoords_333);
    addBuilding("CDM2", false, 41, 142, 344, 277, 313, 1600, 411, 1425, 422, dotCoords_null);

    addBuilding("701", false, 44, 1662, 217, 2185, 224, 2221, 418, 1690, 401, dotCoords_701);
    addBuilding("380", false, 46, 2296, 166, 2528, 164, 2699, 432, 453, 424, dotCoords_380);
    addBuilding("887", false, 48, 2578, 173, 2904, 38, 2899, 448, 2765, 444, dotCoords_887);
    addBuilding("901", false, 50, 2932, 203, 3211, 41, 337, 459, 294, 444, dotCoords_901);
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
    BuildingUse office = buildingUses.get("Business");
    BuildingUse resident = buildingUses.get("Resident");
    BuildingUse student_resident = buildingUses.get("Student Resident");

    buildings.get("Park").addPermanentUse(park);
    buildings.get("Plaza").addPermanentUse(park);
    buildings.get("Lot7").addPermanentUse(transit);
    buildings.get("EmilyCarr").addPermanentUse(school);
    buildings.get("EmilyCarr").addPermanentUse(art);
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
      midNightFlow.add(use_flow);
    }
  }

  void createUseFlow()
  { 
    /*MORNING (id 0)
     *********/
    //business out
    addUseFlow(0, "Business", "Retail", 2);

    //education out
    addUseFlow(0, "Education", "Retail", 2);
    
    //student resident out
    addUseFlow(0, "Student Resident", "Retail", 3);

    //transit out
    addUseFlow(0, "Transit", "Business", 4);
    addUseFlow(0, "Transit", "Education", 2);
    addUseFlow(0, "Transit", "Neighborhood", 6);
    addUseFlow(0, "Transit", "Retail", 2);
    addUseFlow(0, "Transit", "Light Industry", 2);

    //neighborhood out
    addUseFlow(0, "Neighborhood", "Business", 4);
    addUseFlow(0, "Neighborhood", "Transit", 4);
    addUseFlow(0, "Neighborhood", "Retail", 4);
    
    //resident out
    addUseFlow(0, "Resident", "Business", 2);
    addUseFlow(0, "Resident", "Education", 1);
    addUseFlow(0, "Resident", "Transit", 4);
    addUseFlow(0, "Resident", "Retail", 1);
    addUseFlow(0, "Resident", "Light Industry", 2);
    
    //retail out
    addUseFlow(0, "Retail", "Business", 2);
    addUseFlow(0, "Retail", "Education", 2);
    addUseFlow(0, "Retail", "Transit", 4);
    addUseFlow(0, "Retail", "Light Industry", 2);
    
    //light industry out
    addUseFlow(0, "Light Industry", "Retail", 4);

    /*NOON (id 1)
     ********/
    //business out
    addUseFlow(1, "Business", "Retail", 1);

    //education out
    addUseFlow(1, "Education", "Art and Culture", 6);
    addUseFlow(1, "Education", "Retail", 1);
    
    //student resident out
    addUseFlow(1, "Student Resident", "Retail", 2);

    //transit out
    addUseFlow(1, "Transit", "Art and Culture", 6);
    addUseFlow(1, "Transit", "Education", 4);
    addUseFlow(1, "Transit", "Neighborhood", 6);
    
    //neighborhood out
    addUseFlow(1, "Neighborhood", "Retail", 4);
    
    //resident out
    addUseFlow(1, "Resident", "Art and Culture", 6);
    addUseFlow(1, "Resident", "Transit", 6);
    addUseFlow(1, "Resident", "Retail", 2);
    
    //retail out
    addUseFlow(1, "Retail", "Business", 1);
    addUseFlow(1, "Retail", "Art and Culture", 4);
    addUseFlow(1, "Retail", "Education", 1);
    addUseFlow(1, "Retail", "Light Industry", 1);
    
    //light industry out
    addUseFlow(1, "Light Industry", "Retail", 1);

    /*AFTERNOON (id 2)
     *********/
    //business out
    addUseFlow(2, "Business", "Art and Culture", 6);
    addUseFlow(2, "Business", "Transit", 4);
    addUseFlow(2, "Business", "Retail", 2);

    //education out
    addUseFlow(2, "Education", "Art and Culture", 6);
    addUseFlow(2, "Education", "Transit", 4);
    addUseFlow(2, "Education", "Resident", 3);
    addUseFlow(2, "Education", "Retail", 2);
    
    //student resident out
    addUseFlow(2, "Student Resident", "Retail", 4);

    //transit out
    addUseFlow(2, "Transit", "Art and Culture", 4);
    addUseFlow(2, "Transit", "Education", 4);
    addUseFlow(2, "Transit", "Neighbourhood", 6);
    addUseFlow(2, "Transit", "Retail", 4);
    
    //resident out
    addUseFlow(2, "Resident", "Transit", 3);
    addUseFlow(2, "Resident", "Retail", 2);
    
    //retail out
    addUseFlow(2, "Retail", "Business", 3);
    addUseFlow(2, "Retail", "Art and Culture", 3);
    addUseFlow(2, "Retail", "Education", 3);
    addUseFlow(2, "Retail", "Transit", 3);
    addUseFlow(2, "Retail", "Resident", 4);
    addUseFlow(2, "Retail", "Light Industry", 6);

    //light industry out
    addUseFlow(2, "Light Industry", "Retail", 3);


    /*EVENING (id 3)
     ********/
    //business out
    addUseFlow(3, "Business", "Art and Culture", 6);
    addUseFlow(3, "Business", "Transit", 4);
    addUseFlow(3, "Business", "Neighborhood", 6);
    addUseFlow(3, "Business", "Resident", 1);
    addUseFlow(3, "Business", "Retail", 1);
    
    //art and culture out
    addUseFlow(3, "Art and Culture", "Transit", 4);
    addUseFlow(3, "Art and Culture", "Retail", 4);
    
    //education out
    addUseFlow(3, "Education", "Art and Culture", 6);
    addUseFlow(3, "Education", "Transit", 4);
    addUseFlow(3, "Education", "Resident", 1);
    addUseFlow(3, "Education", "Retail", 1);
    
    //student resident out
    addUseFlow(3, "Student Resident", "Retail", 2);

    //transit out
    addUseFlow(3, "Transit", "Art and Culture", 6);
    addUseFlow(3, "Transit", "Education", 4);
    addUseFlow(3, "Transit", "Neighborhood", 4);
    addUseFlow(3, "Transit", "Resident", 1);
    addUseFlow(3, "Transit", "Retail", 1);
    
    //resident out
    addUseFlow(3, "Resident", "Art and Culture", 3);
    addUseFlow(3, "Resident", "Retail", 2);
    
    //retail out
    addUseFlow(3, "Retail", "Business", 3);
    addUseFlow(3, "Retail", "Art and Culture", 2);
    addUseFlow(3, "Retail", "Student Resident", 2);
    addUseFlow(3, "Retail", "Transit", 2);
    addUseFlow(3, "Retail", "Resident", 1);
    addUseFlow(3, "Retail", "Light Industry", 3);

    //light industry out
    addUseFlow(3, "Light Industry", "Art and Culture", 6);
    addUseFlow(3, "Light Industry", "Transit", 3);
    addUseFlow(3, "Light Industry", "Resident", 3);
    addUseFlow(3, "Light Industry", "Retail", 1);

    /*LATE EVENING
     ********/
    //Business out
    addUseFlow(4, "Business", "Transit", 6);
    addUseFlow(4, "Business", "Neighborhood", 6);
    addUseFlow(4, "Business", "Resident", 2);
    addUseFlow(4, "Business", "Retail", 2);
    
    //Art and Culture out
    addUseFlow(4, "Art and Culture", "Transit", 6);
    addUseFlow(4, "Art and Culture", "Resident", 2);
    addUseFlow(4, "Art and Culture", "Retail", 3);
    
    //Education out
    addUseFlow(4, "Education", "Transit", 6);
    addUseFlow(4, "Education", "Neighborhood", 6);
    addUseFlow(4, "Education", "Resident", 4);
    addUseFlow(4, "Education", "Retail", 4);
    
    //student resident out
    addUseFlow(4, "Student Resident", "Retail", 4);
    
    //Transit out
    addUseFlow(4, "Transit", "Neighborhood", 6);
    addUseFlow(4, "Transit", "Resident", 2);
    addUseFlow(4, "Transit", "Retail", 3);

    //Resident out
    addUseFlow(4, "Resident", "Business", 4);
    addUseFlow(4, "Resident", "Retail", 3);
    
    //Retail out
    addUseFlow(4, "Retail", "Business", 4);
    addUseFlow(4, "Retail", "Student Resident", 4);
    addUseFlow(4, "Retail", "Transit", 2);
    addUseFlow(4, "Retail", "Resident", 3);
    
    //Light Industry out
    addUseFlow(4, "Light Industry", "Transit", 6);
    addUseFlow(4, "Light Industry", "Resident", 4);
    addUseFlow(4, "Light Industry", "Retail", 4);
  }
  
  //initialize the time key and the matrix respond for the use_flows hashmap 
  void use_flows()
  {
    use_flows.put(0, morningFlow);
    use_flows.put(1, noonFlow);
    use_flows.put(2, afternoonFlow);
    use_flows.put(3, eveningFlow);
    use_flows.put(4, midNightFlow);
  }
}