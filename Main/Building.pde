/** //<>// //<>// //<>//
 * The Building class represents a physical building
 */
class Building 
{    
  ArrayList<BuildingUse> buildingUses;
  BuildingCoords buildingCoords;
  PVector[] bUDotCoords;
  String buildingName;
  int dotSize;
  int doorNodeId;
  float node_x;
  float node_y;

  BuildingTooltip tooltip;
  boolean showTooltip;
  int maxBuildingUses;

  /**
   * The Building constructor
   * @param name This is the id of the building
   * @param smallDot This sets if building use feedback dot is small size
   * @param doorNode The door id to the building.
   * @param buildingCoords This is the 4 coordinates of the building block
   * @param bUDotCoords This is a list of possible dot locations
   */
  Building (String name, boolean smallDot, int doorNodeId, BuildingCoords buildingCoords, PVector[] bUDotCoords) 
  {
    buildingName = name;
    dotSize = (smallDot) ? 40 : 70;
    this.doorNodeId = doorNodeId;
    this.buildingCoords = buildingCoords;
    this.bUDotCoords = bUDotCoords;
    maxBuildingUses = bUDotCoords.length;
    buildingUses = new ArrayList<BuildingUse>();
    tooltip = new BuildingTooltip(buildingCoords, maxBuildingUses);
  }

  //rendering the block
  void render() 
  {
    drawPolygon();
    drawBuildingUses();
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
    if (!buildingUses.isEmpty())
      for (int i = 0; i < buildingUses.size(); i++) {
        BuildingUse bUse = buildingUses.get(i);

        color c = bUse.colorId;
        fill(c);
        ellipse(bUDotCoords[i].x, bUDotCoords[i].y, dotSize, dotSize);
      }
  }
  
  void drawTooltip()
  {
    tooltip.drawTooltip(buildingUses);
  }

  ArrayList<Path> buildPaths(ArrayList<Path> paths)
  {
    if (!buildingUses.isEmpty())
    {
      for (int i = 0; i < buildingUses.size(); i++) {
        BuildingUse bUse = buildingUses.get(i);
        float density = decide_density(bUse.name, bUse.matchBUse);
        HashMap<String, Building> destBuildings = findBuildingList(bUse.matchBUse);    

        if (destBuildings != null && !destBuildings.isEmpty()) {
          for (Map.Entry buildingEntry : destBuildings.entrySet()) {
            Building destBuilding = (Building) buildingEntry.getValue();
            int destDoorNodeId = destBuilding.doorNodeId;
            FlowRoute fA = new FlowRoute (this.doorNodeId, destDoorNodeId, density);
            paths = fA.buildPathDensities(density, paths);
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
  HashMap<String, Building> findBuildingList(String bUName)
  {
    if (bUName == "artCulture" && !artCultureBuildings.isEmpty()) {
      return artCultureBuildings;
    } else if (bUName == "lightIndustrial" && !lightIndustrialBuildings.isEmpty()) {
      return lightIndustrialBuildings;
    } else if (bUName == "offices" && !officesBuildings.isEmpty()) {
      return officesBuildings;
    } else if (bUName =="retail" && !retailBuildings.isEmpty()) {
      return retailBuildings;
    } else if (bUName =="residential" && !residentalBuildings.isEmpty()) {
      return residentalBuildings;
    } else {
      return null;
    }
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

  //decide the path density from building use src to building use dest
  float decide_density(String bUNameSrc, String bUNameDest)
  {
    //three levels of density per unit length
    float d1 = 0.08;
    float d2 = 0.03;
    float d3 = 0.01;

    //defaut density is the third level
    float d = d3;

    //morning time density rule
    if (cur_time == "morning")
    {
      if (bUNameSrc == "residential" || bUNameSrc == "transit")
      {
        if (bUNameDest == "retail")
        {
          //the second level density
          d = d2;
        } else if (bUNameDest == "offices" || bUNameDest == "lightIndustrial")
        {
          //the first level density
          d = d1;
        }
      } else if (bUNameSrc == "retail")
      {
        if (bUNameDest == "offices" || bUNameDest == "lightIndustrial")
        {
          //the second level density
          d = d2;
        }
      }
    }
    //around mid afternoon time density rule
    else if (cur_time == "mid_afternoon")
    {
      if (bUNameSrc == "resident" || bUNameSrc == "transit")
      {
        if (bUNameDest == "retail")
        {
          //the third level density
          d = d3;
        } else if (bUNameDest == "offices" || bUNameDest == "lightIndustrial")
        {
          //the third level density
          d = d3;
        } else if (bUNameDest == "artCulture")
        {
          //the second level density
          d = d2;
        }
      }
    }
    return d;
  }

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