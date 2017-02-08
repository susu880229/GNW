Building buildingA;
Building buildingB;
ArrayList<Icon_DragDrop> icons;
//define the box parameters
int food_x = 100;
int food_y = 100;
int transit_x = 170;
int transit_y = 100;
int office_x = 240;
int office_y = 100;
int school_x = 310;
int school_y = 100;
int icon_w = 30;
int icon_h = 30;
int box_w = 50;
int box_h = 50;
color food_red = color (200, 0, 0);
color transit_blue = color (0, 0, 200);
color office_green = color(0, 200, 0);
color school_yellow = color(200, 200, 0);
String choice;
int buildingA_x = 362;
int buildingA_y = 384;
int buildingB_x = 662;
int buildingB_y = 384;
int building_w = 100;
int building_h = 100;

Icon_Initial food_box;
Icon_Initial transit_box;
Icon_Initial office_box;
Icon_Initial school_box;
//define the person parameter
ArrayList<Person> pAs;
ArrayList<Person> pBs;



void setup()
{
  size(1024, 768);
  buildingA = new Building("buildingA", buildingA_x, buildingA_y, building_w, building_h);
  buildingB = new Building("buildingB", buildingB_x, buildingB_y, building_w, building_h);
  buildingA.addPerson();
  //buildingB.addPerson();
  //create four boxes objects 
  food_box = new Icon_Initial(food_red, food_x, food_y, box_w, box_h, "Food");
  transit_box = new Icon_Initial(transit_blue, transit_x, transit_y, box_w, box_h, "Transit");
  office_box = new Icon_Initial(office_green, office_x, office_y, box_w, box_h, "Office");
  school_box = new Icon_Initial(school_yellow, school_x, school_y, box_w, box_h, "School");
  
  icons = new ArrayList<Icon_DragDrop>();
 
}

void draw() {
  background(0);
  buildingA.render();
  buildingB.render();
  //buildingA.run();

  rectMode(CENTER);
  
  //render boxes
  food_box.render();
  transit_box.render();
  office_box.render();
  school_box.render();
  
  //detect the mouse 
  food_box.detect();
  transit_box.detect();
  office_box.detect();
  school_box.detect();
  
  if(food_box.mouse_detect)
  {
    choice = "food";
  }
  else if(transit_box.mouse_detect)
  {
    choice = "transit";
  }
  else if(school_box.mouse_detect)
  {
    choice = "school";
  }
  else if(office_box.mouse_detect)
  {
    choice = "office";
  }
  else 
  {
    choice = null;
  }
  //System.out.println(choice);
  
  //render the icon and detect the mouse within the icon
  if(!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
    icons.get(i).update();
    }
    
  }
 
  System.out.println("buildingA:" + buildingA.iconDrags.size() + "," + "buildingB:" + buildingB.iconDrags.size());
  
  flow_generate();
  
  
}

void mousePressed()
{
  
  //mouse are on the box area to generate icon 
  if (choice != null)
  {
    if(choice == "food")
    {
      icon_generate("food_icon.png", food_x, food_y + 50, icon_w, icon_h);
    }
    
    else if(choice == "transit")
    {
      icon_generate("transit_icon.png", transit_x, transit_y + 50, icon_w, icon_h);
    }
    
    else if(choice == "school")
    {
      icon_generate("school_icon.png", school_x, school_y + 50, icon_w, icon_h);
    }
    
    else if(choice == "office")
    {
      icon_generate("office_icon.png", office_x, office_y + 50, icon_w, icon_h);
    }
  }
   
   //mouse is outside the box, if it is within icon, lock the icon and get the initial distance between mouse and its position
  else 
  {
     if(!icons.isEmpty())
     {
       for(int i = 0; i < icons.size(); i++)
       {
         icons.get(i).mousePressed();
         
       }
      }
   }
   
}

void mouseDragged()
{
  //update the icon position based on the mouse
  if(!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
    icons.get(i).mouseDragged();
    
    }
    
  }
}

void mouseReleased()
{
  
 
  //unlock the icon
  if(!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
      Icon_DragDrop icon = icons.get(i);
      icon.mouseReleased();
        
    }
  }
  
}

//create icon object 
void icon_generate(String icon_name, int icon_x, int icon_y, int icon_w, int icon_h )
{
  Icon_DragDrop icon = new Icon_DragDrop(icon_name, icon_x, icon_y, icon_w, icon_h);
  icons.add(icon);
  icon.load();
  //icon.mousePressed();
  
}

void flow_generate()
{
  int buildingA_iconClass = 0;
  int buildingB_iconClass = 0;
  if(buildingA.iconDrags.size() > 0 && buildingB.iconDrags.size() > 0)
  {
    //get the icon class from two buildings
    
    buildingA_iconClass = buildingA.findIcon_class();
    buildingB_iconClass = buildingB.findIcon_class();
    
    //flow from buildingA to buildingB
    if(buildingA_iconClass > buildingB_iconClass)
    {
      
      buildingA.pAs_run();
      
    }
    
    //flow from buildingB to buildingA
    else if (buildingA_iconClass < buildingB_iconClass)
    {
      
      buildingA.pBs_run();
    }
  }//finish if
  
  
}