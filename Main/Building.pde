/**  //<>//
 * The Building class represents a physical building
 */
class Building 
{    
  ArrayList<Person> persons;
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

    persons = new ArrayList<Person>();
    buildingUses = new ArrayList<BuildingUse>();
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
    vertex(xpos1, ypos1);
    vertex(xpos2, ypos2);
    vertex(xpos3, ypos3);
    vertex(xpos4, ypos4);
    endShape(CLOSE);
  }

  void drawBuildingUses() 
  {
    if (!buildingUses.isEmpty())
    {
      for (int i = 0; i < buildingUses.size(); i++) {
        BuildingUse bUse = buildingUses.get(i);
        int dotX = ((xpos1 + xpos2 + xpos3 + xpos4) /4) - 30 + (i*20);
        int dotY = ((ypos1 + ypos2 + ypos3 + ypos4) /4) + 5;
        
        color c = bUse.colorId;
        fill(c);
        ellipse(dotX , dotY, 20, 20);
      }
    }
  }

  void generateFlow()
  {
    if (!buildingUses.isEmpty())
    {
      for (int i = 0; i < buildingUses.size(); i++) {
        BuildingUse bUse = buildingUses.get(i);
        color flowColor = decide_color(bUse.name, bUse.matchBUse);
        ArrayList<Building> destBuildings = findBuildingDoorNodes(bUse.matchBUse);    

        if (destBuildings != null && !destBuildings.isEmpty()) {
          for (int j = 0; j < destBuildings.size(); j ++) {
            int destDoorNodeId = destBuildings.get(j).doorNodeId;
            addPerson(destDoorNodeId, flowColor);
            run();
          }
        }
      }
    }
  }

  //TODO currently returns the first doornode of the first building in category; should should return all?
  ArrayList<Building> findBuildingDoorNodes(String buildingName)
  {
    if (buildingName == "Restaurant" && !restaurantBuildings.isEmpty()) {
      return restaurantBuildings;
    } else if (buildingName == "Office" && officeBuildings.size() > 0) {
      return officeBuildings;
    } else if (buildingName == "Recreation" && recBuildings.size() > 0) {
      return recBuildings;
    } else if (buildingName =="Resident" && residentBuildings.size() > 0) {
      return residentBuildings;
    } else if (buildingName =="Retail" && retailBuildings.size() > 0) {
      return retailBuildings;
    } else {
      return null;
    }
  }

  void addBuildingUse(BuildingUse buildingUse) {
    if (buildingUses.size() < maxBuildingUses) {
      buildingUses.add(buildingUse);

      if (buildingUse.name == "Restaurant") {
        restaurantBuildings.add(this);
      } else if (buildingUse.name == "Office") {
        officeBuildings.add(this);
      } else if (buildingUse.name == "Recreation") {
        recBuildings.add(this);
      } else if (buildingUse.name =="Resident") {
        residentBuildings.add(this);
      } else if (buildingUse.name =="Retail") {
        retailBuildings.add(this);
      }
    }
  }

  void addPerson(int dest_doorNodeId, color c)
  {     
    Person pA = new Person(this.doorNodeId, dest_doorNodeId, c);
    persons.add(pA);
  }

  void run()
  {

    for (int i = 0; i < persons.size(); i++)
    {
      persons.get(i).run();
      if (persons.get(i).isDead)
      {
        persons.remove(i);
      }
    }
  }

  //decide the path density from icon a to icon b
  color decide_color(String icon_nameA, String icon_nameB)
  {
    //three level of density to show by color
    color c1 = color(0, 0, 255);
    color c2 = color(0, 191, 255);
    color c3 = color(173, 216, 230);
    //defaut color is the third level
    color c = c3;

    //morning time density rule
    if (cur_time == "morning")
    {
      if (icon_nameA == "resident.png" || icon_nameA == "transit.png")
      {
        if (icon_nameB == "restaurant.png")
        {
          //the second level density
          c = c2;
        } else if (icon_nameB == "office.png" || icon_nameB == "school.png")
        {
          //the first level density
          c = c1;
        }
      } else if (icon_nameA == "restaurant.png")
      {
        if (icon_nameB == "office.png" || icon_nameB == "school.png")
        {
          //the second level density
          c = c2;
        }
      }
    }
    //around mid afternoon time density rule
    else if (cur_time == "mid_afternoon")
    {
      if (icon_nameA == "resident.png" || icon_nameA == "transit.png")
      {
        if (icon_nameB == "restaurant.png")
        {
          //the third level density
          c = c3;
        } else if (icon_nameB == "office.png" || icon_nameB == "school.png")
        {
          //the third level density
          c = c3;
        } else if (icon_nameB == "recreation.png")
        {
          //the second level density
          c = c2;
        }
      }
    }
    return c;
  }

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