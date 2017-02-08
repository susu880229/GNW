class Building 
{    
    
    ArrayList<Person> pAs;
    ArrayList<Person> pBs;
    //ArrayList<Person> persons;
    ArrayList<Icon_DragDrop> iconDrags;
    int xpos;
    int ypos; 
    int buildingWidth;
    int buildingHeight;
    String buildingName;
    int building_class;
    
    Building (String name, int x, int y, int w, int h) 
    {
      xpos = x;
      ypos = y;
      buildingWidth = w;
      buildingHeight = h;
      buildingName = name;
      
      pAs = new ArrayList<Person>();
      pBs = new ArrayList<Person>();
      iconDrags = new ArrayList<Icon_DragDrop>();
     }
    
    //rendering the block
    void render() 
    {
      fill(255);
      rectMode(CENTER);
      rect(xpos, ypos, buildingWidth, buildingHeight);
    }

  //iterate the iconlist to find the icon class for this building
    int findIcon_class()
    {
      for (int i = 0; i < iconDrags.size(); i++)
      {
        Icon_DragDrop iconA = iconDrags.get(i);
        building_class = iconA.Icon_class;
      }
    return building_class;
    
    }
    
    void addPerson()
    {
      for(int i = 0; i < 50; i = i + 10)
      {
        
        Person pA = new Person(buildingA_x - i, buildingA_y, buildingB_x, buildingB_y);
        pAs.add(pA);
        Person pB = new Person(buildingB_x + i, buildingB_y, buildingA_x, buildingA_y);
        pBs.add(pB);
        
        //Person p = new Person(xpos, ypos, 
      }
      
    }
    
    
    //run from buildingA to buildingB
    void pAs_run()
    {
      for(int i = 0; i < pAs.size(); i++)
      {
       pAs.get(i).run();
       if(pAs.get(i).initial_position.x >= buildingB_x)
       {
        pAs.get(i).initial_position.x = buildingA_x;
        pAs.get(i).initial_position.y = buildingA_y;
       }
        
      }
      
      
    }
    
    //run from buildingB to buildingA
    void pBs_run()
    {
      for(int i = 0; i < pBs.size(); i++)
      {
        pBs.get(i).run();
        if(pBs.get(i).initial_position.x <= buildingA_x)
        {
          pBs.get(i).initial_position.x = buildingB_x;
          pBs.get(i).initial_position.y = buildingB_y;
        }
        
        
      }
      
      
    }
    
    
    
}