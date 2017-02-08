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
  String img;
  PImage a;
  int Icon_class;
  String building_name;
  String building_cur = null;
  String building_pre = null;
  
  //constructor
  Icon_DragDrop(String img_name, int x, int y,int wi, int hi)
  {
    img = img_name;
    w = wi;
    h = hi;
    bx = x;
    by = y;
    class_decide();
    
  }
  
  //load he image to drop at the beginning
  void load()
  {
    //a = loadImage("data/Button.jpg");
    a = loadImage(img);
    
  }
  
  //the image is controlled by the bx, by parameters
  void update()
  {
    
    if (mouseX > bx - w/2 && mouseX < bx + w/2 && mouseY > by - h/2 && mouseY < by + h/2) 
    {
      hover = true;  
    } 
    else 
    {
      hover = false;
    }
    imageMode(CENTER);
    image(a, bx, by, w, h);
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
  }
  
  void class_decide()
  {
    if(img == "food_icon.png")
    {
      Icon_class = 2;
    }
    else if(img == "transit_icon.png")
    {
      Icon_class = 3;
    }
    else if(img == "office_icon.png")
    {
      Icon_class = 1;
    }
    else if(img == "school_icon.png")
    {
      Icon_class = 1;
    }
    
  }
  
  void building_decide()
  {
    //icon is within buildingA
    if(bx > buildingA_x - building_w/2 && bx < buildingA_x + building_w/2 && by > buildingA_y - building_h/2 && by < buildingA_y + building_h/2)
    {
      building_name = "buildingA";
      
    }
    //icon is within buildingB
    else if(bx > buildingB_x - building_w/2 && bx < buildingB_x + building_w/2 && by > buildingB_y - building_h/2 && by < buildingB_y + building_h/2)
    {
      building_name = "buildingB";
      
    }
    else
    {
      building_name = null;
      
    }
    
    
  }

  void addToBuilding ()
  {
    if(building_name == "buildingA")
    {
      building_cur = "buildingA";
      if(building_cur != building_pre)
      {
        
        if(building_pre == "buildingB")
        {
          buildingB.iconDrags.remove(this);
        
        }
        buildingA.iconDrags.add(this);
       
        building_pre = building_cur;
      }
    }
    else if (building_name == "buildingB")
    {
      building_cur = "buildingB";
      if(building_cur != building_pre)
      {
        if(building_pre == "buildingA")
        {
          buildingA.iconDrags.remove(this);
        
        }
        buildingB.iconDrags.add(this);
        building_pre = building_cur;
      }
    }
    else if (building_name == null)
    {
      building_cur = null;
      if(building_pre == "buildingA")
      {
        buildingA.iconDrags.remove(this);
        
      }
      else if(building_pre == "buildingB")
      {
        buildingB.iconDrags.remove(this);
        
      }
      building_pre = building_cur;
    }
      
  }
  
  
}