/**  //<>// //<>//
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
  
  
  
 //when the selectedUse is on the building hot spot, the use will be added to this building
  void addBuildingUse(BuildingUse buildingUse) {
    if (buildingUses.size() <= maxBuildingUses && isCustomizable) {
      buildingUses.add(buildingUse);
      
    }
    else
    {
      System.out.println("the building is not customizable or full");
    }
  }

  void addPerson(int dest_doorNodeId, int weight)
  { 
    
    Person pA = new Person(this.doorNodeId, dest_doorNodeId, weight);
    persons.add(pA);
    
      
  }
  
  
  //draw the circle as person and update the position info
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

  int generatePerson()
  {
    //boolean add = false;
    //persons.clear();
    int weight = 0;
    pre_time = millis();
    ArrayList<Building> destBuildings = new ArrayList<Building>();
    if (!buildingUses.isEmpty())
    {
      for (int i = 0; i < buildingUses.size(); i++) 
      {
        BuildingUse bUse = buildingUses.get(i);
        for (UseFlow flow : use_flows)
        {
          if(flow.time == cur_time && flow.from_use == bUse.name)
          {
            destBuildings = findBuildingDoorNodes(flow.to_use);
            weight = flow.weight;
            if (destBuildings != null && !destBuildings.isEmpty()) 
            {
              for (int j = 0; j < destBuildings.size(); j ++) 
              {
                int destDoorNodeId = destBuildings.get(j).doorNodeId;
                //add this condition incase there flow generate inside the same building (findPah) get error
                if(destDoorNodeId != this.doorNodeId)
                {
                  addPerson(destDoorNodeId, weight);
                  //run();
                  
                }
                
              }
            }
          }
        
        }
      }
      
    }
    return weight;
  }

  //
  ArrayList<Building> findBuildingDoorNodes(String UseName)
  {
    ArrayList<Building> buildings = (ArrayList<Building>) use_buildings.get(UseName);
    return buildings;  
    
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