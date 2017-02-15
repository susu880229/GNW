/**  //<>//
 * The Building class represents a physical building
 */
class Building 
{    
  ArrayList<Person> persons;
  ArrayList<Icon_DragDrop> iconDrags;
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
  Polygon p;
  Icon_DragDrop icon;

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
    iconDrags = new ArrayList<Icon_DragDrop>();
  }

  void createPolygon()
  {
    p = new Polygon(); 
    p.addPoint(xpos1, ypos1);
    p.addPoint(xpos2, ypos2);
    p.addPoint(xpos3, ypos3);
    p.addPoint(xpos4, ypos4);
  }

  //rendering the block
  void render() 
  {
    if (isCustomizable) 
    {
      fill(200);
    } else 
    {
      fill(150);
    }
    noStroke();
    //quad(xpos1, ypos1, xpos2, ypos2, xpos3, ypos3, xpos4, ypos4);
    //draw the polygon 
    beginShape();
    for (int i = 0; i < p.npoints; i++) 
    {
      vertex(p.xpoints[i], p.ypoints[i]);
    }
    endShape();
    //render text
    fill(0);
    textSize(9);
    text(buildingName, center_x, center_y);
  }

  //iterate the iconlist to find the icon class for this building
  int building_class()
  {

    get_icon();
    return icon.class_decide();
  }

  String Icon_name()
  {

    get_icon();
    return icon.icon_name;
  }

  void get_icon()
  {
    for (int i = 0; i < iconDrags.size(); i++)
    {
      icon = iconDrags.get(i);
    }
  }

  void addPerson(int target_x, int target_y, color c)
  { 

    float dis_x = target_x - center_x;
    float dis_y = target_y - center_y;
    float a = dis_y / dis_x;

    for (int i = 0; i < 2; i = i + 10)
    {

      Person pA = new Person(center_x - i, center_y + a * i, target_x, target_y, c);
      persons.add(pA);

      //Person p = new Person(xpos, ypos,
    }

    //Person pA = new Person(center_x, center_y, target_x, target_y);
    //persons.add(pA);
  }


  //flows start from this building 
  void flow_generate()
  {
    int icon_classA;
    int icon_classB;
    String icon_nameA;
    String icon_nameB;
    color c1 = color(135, 206, 250);

    if (this.iconDrags.size() > 0)
    {
      icon_classA = this.building_class();
      icon_nameA = this.Icon_name();
      if (icon_classA > 0)
      {
        for (Map.Entry GNWMapEntry : GNWMap.entrySet()) 
        {
          Building building = (Building) GNWMapEntry.getValue();
          if (building.iconDrags.size() > 0 && building.buildingName != this.buildingName)
          {
            icon_classB = building.building_class();
            icon_nameB = building.Icon_name();
            if (icon_classA > icon_classB && icon_classB > 0)
            {
              c1 = decide_color(icon_nameA, icon_nameB);

              addPerson(building.center_x, building.center_y, c1);
              run();
            }
          }
          //remove the persons when no icon within the building
          else if (building.iconDrags.size() <= 0)
          {
            for (int i = 0; i < persons.size(); i++)
            {
              Person p = persons.get(i);
              if (p.dest_position.x == building.center_x && p.dest_position.y == building.center_y)
              {
                persons.remove(i);
              }
            }
          }//
        }
      }
    }
  }

  //run from buildingA to buildingB

  void run()
  {

    for (int i = 0; i < persons.size(); i++)
    {
      persons.get(i).run();
      if (persons.get(i).isDead())
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
}