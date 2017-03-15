/**
 * The Building class represents a physical building
 */
class Building 
{    

  ArrayList<BuildingUse> customizableUses;
  ArrayList<BuildingUse> permanentUses;

  int FLOW_DELAY_MULTIPLIER = 50;

  BuildingCoords buildingCoords;
  PVector[] bUDotCoords;
  String buildingName;
  int dotSize;
  int doorNodeId;
  float node_x;
  float node_y;
  Boolean isCustomizable;
  float particleGenRate;

  BuildingTooltip tooltip;
  Boolean showTooltip;
  int maxBuildingUses;

  /**
   * The Building constructor
   * @param name This is the id of the building
   * @param smallDot This sets if building use feedback dot is small size
   * @param doorNode The door id to the building.
   * @param buildingCoords This is the 4 coordinates of the building block
   * @param bUDotCoords This is a list of possible dot locations
   */
  Building (String name, Boolean smallDot, int doorNodeId, BuildingCoords buildingCoords, PVector[] bUDotCoords) 
  {
    buildingName = name;
    dotSize = (smallDot) ? 40 : 70;
    this.doorNodeId = doorNodeId;
    this.buildingCoords = buildingCoords;
    this.bUDotCoords = bUDotCoords;

    maxBuildingUses = (bUDotCoords!= null && bUDotCoords.length > 0) ? bUDotCoords.length : 0;
    customizableUses = new ArrayList<BuildingUse>();
    permanentUses = new ArrayList<BuildingUse>();
    isCustomizable = maxBuildingUses > 0;
    tooltip = (isCustomizable) ? new BuildingTooltip(buildingCoords, maxBuildingUses) :  null;
    particleGenRate = 0;
  }

  //rendering the block
  void render() 
  {
    drawPolygon();
    drawBuildingUses();
  }

  void highlight()
  { 
    if (buildingUses.size() < bUDotCoords.length)
    {
      switch(doorNodeId)    //use doorNodeId because Android does not support switch(String)
      {
      case 64:    //Lot5
        image(glowImage_lot5, 0, 0);
        break;
      case 17:    //Lot4
        image(glowImage_lot4, 0, 0);
        break;
      case 14:     //521
        image(glowImage_521, 0, 0);
        break;
      case 7:    //Lot7
        image(glowImage_lot7, 0, 0);
        break;
      case 12:    //515
        image(glowImage_515, 0, 0);
        break;

        //images starting from 1/4 of the width to save memory
      case 38:    //1933
        image(glowImage_1933, 1154, 0);
        break;
      case 44:    //701
        image(glowImage_701, 1154, 0);
        break;
      case 46:    //1980
        image(glowImage_1980, 1154, 0);
        break;

        //images starting from 1/2 of the width to save memory
      case 48:    //887
        image(glowImage_887, 2308, 0);
        break;
      case 50:    //901
        image(glowImage_901, 2308, 0);
        break;
      case 55:    //Shaw
        image(glowImage_shaw, 2308, 0);
        break;

        //images starting from 3/4 of the width to save memory
      case 59:    //Nature's Path
        image(glowImage_naturesPath, 3462, 0);
        break;
      }
    }
  }

  void drawPolygon() 
  {
    noFill();
    noStroke();
    beginShape();
    vertex(buildingCoords.topLeft.x, buildingCoords.topLeft.y);
    vertex(buildingCoords.topRight.x, buildingCoords.topRight.y);
    vertex(buildingCoords.bottomRight.x, buildingCoords.bottomRight.y);
    vertex(buildingCoords.bottomLeft.x, buildingCoords.bottomLeft.y);
    endShape(CLOSE);
  }

  void drawBuildingUses() 
  {
    if (!customizableUses.isEmpty())
      for (int i = 0; i < customizableUses.size(); i++) {
        BuildingUse bUse = customizableUses.get(i);

        color c = bUse.colorId;
        fill(c);
        ellipse(bUDotCoords[i].x, bUDotCoords[i].y, dotSize, dotSize);
      }
  }

  void drawTooltip()
  {
    if (maxBuildingUses > 0) 
    {
      tooltip.drawTooltip(customizableUses);
    }
  }

  //find the particle generation rate of each FlowRoute and add the FlowRoutes into an array
  ArrayList<FlowRoute> findParticleGenRate(ArrayList<FlowRoute> flowRoutes)
  {
    int delay = 0;
    ArrayList<Building> destBuildings = new ArrayList<Building>();
    ArrayList<UseFlow> time_flows = new ArrayList<UseFlow>();
    if (!customizableUses.isEmpty()) {
      findParticleGenRateHelper(customizableUses, delay, destBuildings, time_flows, flowRoutes);
    }

    if (!permanentUses.isEmpty()) {
      findParticleGenRateHelper(permanentUses, delay, destBuildings, time_flows, flowRoutes);
    }
    
    return flowRoutes;
  }

  void findParticleGenRateHelper( ArrayList<BuildingUse> buildingUses, int delay, ArrayList<Building> destBuildings,  ArrayList<UseFlow> time_flows, ArrayList<FlowRoute> flowRoutes)
  {
    for (int i = 0; i < buildingUses.size(); i++) {
      BuildingUse FromUse = buildingUses.get(i);
      if (cur_time == 9 || cur_time == 12 || cur_time == 15 || cur_time == 19 ||  cur_time == 23)
      {
        time_flows = findFlows(cur_time);
        for (UseFlow flow : time_flows)
        {
          if (flow.from_use == FromUse.name)
          {
            destBuildings = findBuildings(flow.to_use);
            delay = flow.delay * FLOW_DELAY_MULTIPLIER;
            if (destBuildings != null && !destBuildings.isEmpty()) {
              for (int j = 0; j < destBuildings.size(); j++) {
                int destDoorNodeId = destBuildings.get(j).doorNodeId;
                if (destDoorNodeId != this.doorNodeId)
                {
                  FlowRoute fA = new FlowRoute (this.doorNodeId, destDoorNodeId, delay, flow.from_use, flow.to_use);
                  flowRoutes.add(fA);
                }
              }
            }
          }
        }
      }
    }
  }

  /**
   * Returns list of buildings for specific building use
   * @param buName is the name of building use
   */
  ArrayList<Building> findBuildings(String UseName)
  {
    ArrayList<Building> buildings = (ArrayList<Building>) use_buildings.get(UseName);
    return buildings;
  }

  ArrayList<UseFlow> findFlows(int time)
  {    
    ArrayList<UseFlow> flows = (ArrayList<UseFlow>) use_flows.get(time);
    return flows;
  }

  /**
   * Adds building use to the building
   * @param buildingUse is the building use object to be added
   */
  void addBuildingUse(BuildingUse buildingUse) throws Exception
  {
    if (customizableUses.size() < maxBuildingUses) {
      customizableUses.add(buildingUse);      
      use_buildings.get(buildingUse.name).add(this);
    } else {
      throw new Exception ("too many building uses");
    }
  }

  void addPermanentUse(BuildingUse buildingUse) 
  {
    permanentUses.add(buildingUse);      
    use_buildings.get(buildingUse.name).add(this);
  }

  ArrayList<Particle> deleteBuildingUse(ArrayList<Particle> particles) throws Exception
  {
    String bUtoDelete = tooltip.selectBuildingUse(customizableUses);

    for (int i = 0; i < customizableUses.size(); i++) {
      String bUName = customizableUses.get(i).name;      
      if (bUtoDelete == bUName) {
        customizableUses.remove(i);

        //remove the particles associated with the removed building use
        for (int j = particles.size() - 1; j >= 0; j--)
        {
          Particle curParticle = particles.get(j);
          if (curParticle.initial_nodeID == doorNodeId &&  curParticle.from_buildingUse == bUName || curParticle.dest_nodeID == doorNodeId && curParticle.to_buildingUse == bUName)
          {
            particles.remove(j);
          }
        }
      }
      ArrayList<Building> bUBuildings = (ArrayList<Building>)use_buildings.get(bUtoDelete);        
      bUBuildings.remove(this);

      return particles;
    }
    throw new Exception("Can't delete building use");
  }


  /**
   * to detect one point(the mouse) if within this building's hot pot or not
   */
  boolean contains(int x, int y) {    
    PVector[] verts = {  buildingCoords.topLeft, buildingCoords.topRight, buildingCoords.bottomRight, buildingCoords.bottomLeft }; 
    PVector pos = new PVector(x, y);
    int i, j;
    boolean c=false;
    int sides = verts.length;
    for (i=0, j=sides-1; i<sides; j=i++) {
      if (( ((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
        (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) {
        c = !c;
      }
    }
    return c;
  }
}


// ====================================
class BuildingCoords
{
  PVector topLeft;
  PVector topRight;
  PVector bottomRight;
  PVector bottomLeft;

  /**
   * @param x1 This is the x-coordinate of the top-left corner of the building
   * @param y1 This is the y-coordinate of the top-left corner of the building
   * @param x2 This is the x-coordinate of the top-right corner of the building
   * @param y2 This is the y-coordinate of the top-righteft corner of the building
   * @param x3 This is the x-coordinate of the bottom-right corner of the building
   * @param y3 This is the y-coordinate of the bottom-right corner of the building
   * @param x4 This is the x-coordinate of the bottom-left corner of the building
   * @param y4 This is the y-coordinate of the bottom-left corner of the building
   */
  BuildingCoords(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4)
  {
    topLeft = new PVector(x1, y1);
    topRight = new PVector(x2, y2);
    bottomRight = new PVector(x3, y3);
    bottomLeft = new PVector(x4, y4);
  }
}