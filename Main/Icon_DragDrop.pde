class Icon_DragDrop
{
  int bx;
  int by;
  int w = 30;
  int h = 30;
  boolean hover = false;
  boolean locked = false;
  int difx = 0; 
  int dify = 0; 
  String icon_name;
  PImage a;
  int Icon_class = -1;
  float flow_percent;
  String building_name = null;
  String building_cur = null;
  String building_pre = null;
  
  //constructor
  Icon_DragDrop(String img_name, int x, int y,int wi, int hi)
  {
    icon_name = img_name;
    w = wi;
    h = hi;
    bx = x;
    by = y;
    //class_decide();
    
  }
  
  //load the image to drop at the beginning
  void load()
  {
    a = loadImage(icon_name);
    
  }
  
  //the image is controlled by the bx, by parameters
  void update()
  {
    if (isMouseOnIcon()) 
    {
      hover = true;  
    } 
    else 
    {
      hover = false;
    }
    image(a, bx, by, w, h);
  }
  
  boolean isMouseOnIcon()
  {
    boolean checkX = mouseX > bx - w && mouseX < bx + w;
    boolean checkY =  mouseY > by - h && mouseY < by + h;
    
    return checkX && checkY;
  }
  
  void mousePressed() 
  {
    if(hover) 
    { 
      locked = true; 
    //copy the image after hold the mouse
    }
    else 
    {
      locked = false;
    }
    difx = mouseX - bx; 
    dify = mouseY - by; 
  }

  void mouseDragged() 
  {
    if(locked) 
    {
    //update the new position of the image everytime user drag it
      bx = mouseX - difx; 
      by = mouseY - dify; 
    
    }
  }

  void mouseReleased() 
  {
    locked = false;
    building_decide();
    addToBuilding ();
    //System.out.println(building_name);
  }
  
  int class_decide()
  {
    if(cur_time == "morning")
    {
      if(icon_name == "restaurant.png")
      {
        Icon_class = 2;
      }
      else if(icon_name == "resident.png" || icon_name == "transit.png")
      {
        Icon_class = 3;
      }
      else if(icon_name == "office.png" || icon_name == "school.png")
      {
        Icon_class = 1;
      }
      //creation does not have any flow
      else if(icon_name == "recreation.png")
      {
        Icon_class = -1;
      }
    }
    else if(cur_time == "mid_afternoon")
    {
      if(icon_name == "restaurant.png")
      {
      Icon_class = 2;
      }
      else if(icon_name == "resident.png" || icon_name == "transit.png" )
      {
      Icon_class = 3;
      }
      else if(icon_name == "office.png" || icon_name == "school.png" )
      {
      Icon_class = 2;
      }
      else if(icon_name == "recreation.png")
      {
      //the icon is inactive at this time
      Icon_class = 2;
      }
      
      
    }
    
    return Icon_class;
  }
  
  
  void building_decide()
  {
    //icon is within specific building
    for (Map.Entry GNWMapEntry : GNWMap.entrySet()) 
    {
      Building building = (Building) GNWMapEntry.getValue();
      if(building.contains(bx,by))
      {
        building_name = building.buildingName;
        break;
      }
      else
      {
        building_name = null;
      }
    }
    
    
  }
 
  
  void addToBuilding()
  {
    building_cur = building_name;
    if(building_cur != building_pre)
    {
      for (Map.Entry GNWMapEntry : GNWMap.entrySet()) 
      {
        Building building = (Building) GNWMapEntry.getValue();
        if(building.buildingName == building_pre)
        {
          building.iconDrags.remove(this);
        }
        else if(building.buildingName == building_cur)
        {
           building.iconDrags.add(this);
        }
        
      }
      building_pre = building_cur;
    }
    
  }
  
  
  
  
  
}