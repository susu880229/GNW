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
  int center_x;
  int center_y;
  String buildingName;
  boolean isCustomizable;
  int doorNodeId;
  float node_x;
  float node_y;
  
  //TODO currently limit 1 for each building; should allow up to 3 for some
  //TODO implement delete to allow user to replace building use
  int maxBuildingUses = 1;

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

    center_x = ((xpos1 + xpos2 + xpos3 + xpos4) /4) - 15;
    center_y = ((ypos1 + ypos2 + ypos3 + ypos4) /4) + 5;

    persons = new ArrayList<Person>();
    buildingUses = new ArrayList<BuildingUse>();
  }

  //rendering the block
  void render() 
  {
    drawPolygon();


//TODO: currently only shows one dot. so using center is fine. but if more than 1 in the future, then will need to implement logic for it. 
    if (!buildingUses.isEmpty())
    {
      for (int i = 0; i < buildingUses.size(); i++) {
        color c = buildingUses.get(i).colorId;
        fill(c);
        ellipse(center_x, center_y, 20, 20);
      }
    }
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

  void addBuildingUse(BuildingUse buildingUse) {
    if(buildingUses.size() < maxBuildingUses) {
    buildingUses.add(buildingUse);
    }
  }

  void addPerson(int dest_doorNodeId, color c)
  { 
    /*
    float dis_x = target_x - center_x;
     float dis_y = target_y - center_y;
     float a = dis_y / dis_x;
     
     for (int i = 0; i < 2; i = i + 10)
     {
     Person pA = new Person(center_x - i, center_y + a * i, target_x, target_y, c);
     persons.add(pA);
     }
     */
    Person pA = new Person(this.doorNodeId, dest_doorNodeId, c);
    persons.add(pA);
  }


  //flows start from this building 
  void flow_generate()
  {
    int icon_classA;
    int icon_classB;
    String icon_nameA;
    String icon_nameB;
    color c1 = color(135, 206, 250);
    
    if (this.buildingUses.size() > 0)
    {
     icon_classA = this.building_class();
     icon_nameA = this.Icon_name();
     if (icon_classA > 0)
     {
       for (Map.Entry GNWMapEntry : GNWMap.buildings.entrySet()) 
       {
         Building building = (Building) GNWMapEntry.getValue();
         if (building.buildingUses.size() > 0 && building.buildingName != this.buildingName)
         {
           icon_classB = building.building_class();
           icon_nameB = building.Icon_name();
           if (icon_classA > icon_classB && icon_classB > 0)
           {
             c1 = decide_color(icon_nameA, icon_nameB);
             addPerson(building.doorNodeId, c1);
             run();
           }
         }
     //remove the persons when no icon within the building
         else if (building.buildingUses.size() <= 0)
         {
           for (int i = 0; i < persons.size(); i++)
           {
             Person p = persons.get(i);
             if (p.dest_nodeID == building.doorNodeId)
             {
               persons.remove(i);
             }
           }
         }
       }
     }
    }
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
  
  int building_class()
  {
    int building_class = -1;
    for(BuildingUse use : buildingUses)
    {
      building_class = use.class_decide();
      break;
    }
    return building_class;
   }
   
   String Icon_name()
   {
     String icon_name = null;
     for(BuildingUse use : buildingUses)
     {
        icon_name = use.imgSrc;
        break;
     }
     return icon_name;
     
    }
  //decide the path density from icon a to icon b
  color decide_color(String icon_nameA, String icon_nameB)
  {
    //three level of density to show by color
    color c1 = color(0, 0, 255);
    color c2 = color(0, 191, 255);
    //color c3 = color(135, 206, 250);
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