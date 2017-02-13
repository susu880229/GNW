
class Building 
{    
    
    //ArrayList<Person> pAs;
    //ArrayList<Person> pBs;
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
    //int buildingWidth;
    //int buildingHeight;
    String buildingName;
    //int building_class;
    boolean isCustomizable;
    Polygon p;
    
    Building (String name, boolean c, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) 
    {
      xpos1 = x1;
      ypos1 = y1;
      xpos2 = x2;
      ypos2 = y2;
      xpos3 = x3;
      ypos3 = y3;
      xpos4 = x4;
      ypos4 = y4;
      //buildingWidth = w;
      //buildingHeight = h;
      buildingName = name;
      isCustomizable = c;
      center_x = ((xpos1 + xpos2 + xpos3 + xpos4) /4) - 15;
      center_y = ((ypos1 + ypos2 + ypos3 + ypos4) /4) + 5;
      //pAs = new ArrayList<Person>();
      //pBs = new ArrayList<Person>();
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
      if(isCustomizable) 
      {
        fill(200);
      } 
      else 
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
    int findIcon_class()
    {
      int building_class = -1;
      for (int i = 0; i < iconDrags.size(); i++)
      {
        Icon_DragDrop iconA = iconDrags.get(i);
        building_class = iconA.Icon_class;
      }
      return building_class;
    
    }
    
    
    void addPerson(int target_x, int target_y)
    {
      
      float dis_x = target_x - center_x;
      float dis_y = target_y - center_y;
      float a = dis_y / dis_x;
      
      for(int i = 0; i < 2; i = i + 10)
      {
        
        Person pA = new Person(center_x - i, center_y + a * i, target_x, target_y);
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
      if(this.iconDrags.size() > 0)
      {
        icon_classA = this.findIcon_class();
        if(icon_classA > 0)
        {
          for (Map.Entry GNWMapEntry : GNWMap.entrySet()) 
          {
            Building building = (Building) GNWMapEntry.getValue();
            if(building.iconDrags.size() > 0)
            {
              icon_classB = building.findIcon_class();
              if(icon_classA > icon_classB)
              {
                addPerson(building.center_x, building.center_y);
                run();
              }
              
            
            }
          
          }
        }
      }
      
      
    }
    
    //run from buildingA to buildingB
    
    void run()
    {
      
      for(int i = 0; i < persons.size(); i++)
      {
       persons.get(i).run();
       if(persons.get(i).isDead())
       {
        persons.remove(i);
       }
        
      }
      
      
    }
    
    
    
    
    
}