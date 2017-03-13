/** 
 * The Building class represents a physical building
 */
class Building 
{    
  ArrayList<BuildingUse> buildingUses;
  int xpos1;
  int ypos1; 
  int xpos2;
  int ypos2; 
  int xpos3;
  int ypos3; 
  int xpos4;
  int ypos4; 
  String buildingName;
  boolean isCustomizable;
  int doorNodeId;
  float node_x;
  float node_y;

  BuildingTooltip tooltip;
  boolean showTooltip;

  //TODO this should be customizable depending on building; will implement in future
  //TODO implement delete to allow user to replace building use
  int maxBuildingUses = 3;

  /**
   * The Building constructor
   * @param name This is the id of the building
   * @param c Sets if the building is customizable by user or not
   * @param doorNode The door id to the building.
   * @param x1 This is the x-coordinate of the top-left corner of the building
   * @param y1 This is the y-coordinate of the top-left corner of the building
   * @param x2 This is the x-coordinate of the top-right corner of the building
   * @param y2 This is the y-coordinate of the top-righteft corner of the building
   * @param x3 This is the x-coordinate of the bottom-right corner of the building
   * @param y3 This is the y-coordinate of the bottom-right corner of the building
   * @param x4 This is the x-coordinate of the bottom-left corner of the building
   * @param y4 This is the y-coordinate of the bottom-left corner of the building
   */
  Building (String name, boolean c, int doorNodeId, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) 
  {
    xpos1 = x1;
    ypos1 = y1;
    xpos2 = x2;
    ypos2 = y2;
    xpos3 = x3;
    ypos3 = y3;
    xpos4 = x4;
    ypos4 = y4;

    buildingName = name;
    isCustomizable = c;
    this.doorNodeId = doorNodeId;

    tooltip = new BuildingTooltip();
    buildingUses = new ArrayList<BuildingUse>();
  }

  //rendering the block
  void render() 
  {
    drawPolygon();
    drawBuildingUses();
  }

  void showTooltip() 
  {
    boolean isOnRight = xpos3 < int(GNWMap.mapImage.width*9/10);
    int tooltipX;
    int tooltipY;

    if (isOnRight) {
      tooltipX = xpos2;
      tooltipY = ypos2 - 30;
    } else {
      tooltipX = xpos4 - tooltip.tooltipImage.width;
      tooltipY = ypos1;
    }

    tooltip.drawTooltip(tooltipX, tooltipY, buildingUses, isOnRight);
  }

  void drawPolygon() 
  {
    noFill();
    noStroke();
    beginShape();
    vertex(xpos1, ypos1);
    vertex(xpos2, ypos2);
    vertex(xpos3, ypos3);
    vertex(xpos4, ypos4);
    endShape(CLOSE);
  }

  void drawBuildingUses() 
  {
    if (!buildingUses.isEmpty())
      for (int i = 0; i < buildingUses.size(); i++) {
        BuildingUse bUse = buildingUses.get(i);
        int dotX = ((xpos1 + xpos2 + xpos3 + xpos4) /4) - 50 + (i*60);
        int dotY = ((ypos1 + ypos2 + ypos3 + ypos4) /4) + 5;

        color c = bUse.colorId;
        fill(c);
        ellipse(dotX, dotY, 60, 60);
      }
  }
  
  //write and read from the ArrayList paths to update the edges and their density
  ArrayList<Path> buildPaths(ArrayList<Path> paths)
  {
    float density = 0;
    ArrayList<Building> destBuildings = new ArrayList<Building>();
    ArrayList<UseFlow> time_flows = new ArrayList<UseFlow>();
    if (!buildingUses.isEmpty())
    {
      for (int i = 0; i < buildingUses.size(); i++) {
        BuildingUse FromUse = buildingUses.get(i);
        if(cur_time == 12 || cur_time == 23)
        {
          time_flows = findFlows(cur_time);
          for(UseFlow flow: time_flows)
          {
            if(flow.from_use == FromUse.name)
            {
              destBuildings = findBuildingDoorNodes(flow.to_use);
              density = flow.density / 1000;
              if (destBuildings != null && !destBuildings.isEmpty()) {
                for (int j = 0; j < destBuildings.size(); j ++) {
                  int destDoorNodeId = destBuildings.get(j).doorNodeId;
                  if(destDoorNodeId != this.doorNodeId)
                  {
                    FlowRoute fA = new FlowRoute (this.doorNodeId, destDoorNodeId, density);
                    paths = fA.buildPathDensities(density, paths);
                  }
                }
              }
            }
          }
        }
      }
    }
    return paths;  
  }

  /**
   * Returns list of buildings with the same building use name
   * @param buName is the name of building use
   */
  ArrayList<Building> findBuildingDoorNodes(String UseName)
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
  void addBuildingUse(BuildingUse buildingUse) {
    if (buildingUses.size() < maxBuildingUses) {
      buildingUses.add(buildingUse);

      if (buildingUse.name == "artCulture") {
        artCultureBuildings.put(buildingName, this);
      } else if (buildingUse.name == "lightIndustrial") {
        lightIndustrialBuildings.put(buildingName, this);
      } else if (buildingUse.name == "offices") {
        officesBuildings.put(buildingName, this);
      } else if (buildingUse.name =="retail") {
        retailBuildings.put(buildingName, this);
      } else if (buildingUse.name =="residential") {
        residentalBuildings.put(buildingName, this);
      }
    }
  }

  void deleteBuildingUse() throws Exception
  {
    String bUtoDelete = tooltip.selectBuildingUse(buildingUses);

    for (int i = 0; i < buildingUses.size(); i++) {
      String bUName = buildingUses.get(i).name;      
      if (bUtoDelete == bUName) {
        buildingUses.remove(i);
      }
    }

    if (bUtoDelete == "artCulture") {
      artCultureBuildings.remove(buildingName);
    } else if (bUtoDelete == "lightIndustrial") {
      lightIndustrialBuildings.remove(buildingName);
    } else if (bUtoDelete == "offices") {
      officesBuildings.remove(buildingName);
    } else if (bUtoDelete =="retail") {
      retailBuildings.remove(buildingName);
    } else if (bUtoDelete =="residential") {
      residentalBuildings.remove(buildingName);
    }
  }

  /**
    * to detect one point(the mouse) if within this building's hot pot or not
    */
  boolean contains(int x, int y) {    
    PVector[] verts = { new PVector(xpos1, ypos1), new PVector(xpos2, ypos2), new PVector(xpos3, ypos3), new PVector(xpos4, ypos4) }; 
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