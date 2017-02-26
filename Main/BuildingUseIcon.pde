class BuildingUseIcon
{
  BuildingUse buildingUse;
  int bx;
  int by;
  int w;
  int h;
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
  BuildingUseIcon(BuildingUse buildingUse, int x, int y)
  {
    this.buildingUse = buildingUse;
    icon_name = buildingUse.imgSrc;
    w = 60;
    h = 60;
    bx = x;
    by = y;
    //class_decide();

    load();
  }

  //load the image to drop at the beginning
  void load()
  {
    a = loadImage(icon_name);
    image(a, bx, by, w, h);
  }

  //the image is controlled by the bx, by parameters
  void update()
  {
    if (isMouseOnIcon()) 
    {
      hover = true;
    } else 
    {
      hover = false;
    }
    image(a, bx, by, w, h);
  }

  boolean isMouseOnIcon()
  {
    boolean checkX = mouseX > bx - 2*w && mouseX < bx + 2*w;
    boolean checkY =  mouseY > by - 2*h && mouseY < by + 2*h;

    return checkX && checkY;
  }

  void mousePressed() 
  {
    if (hover) 
    { 
      locked = true; 
      //copy the image after hold the mouse
    } else 
    {
      locked = false;
    }
    difx = mouseX - bx; 
    dify = mouseY - by;
  }

  void mouseDragged() 
  {

    //update the new position of the image everytime user drag it
    bx = mouseX - difx; 
    by = mouseY - dify;
  }


  int class_decide()
  {
    if (cur_time == "morning")
    {
      if (icon_name == "restaurant.png")
      {
        Icon_class = 2;
      } else if (icon_name == "resident.png" || icon_name == "transit.png")
      {
        Icon_class = 3;
      } else if (icon_name == "office.png" || icon_name == "school.png")
      {
        Icon_class = 1;
      }
      //creation does not have any flow
      else if (icon_name == "recreation.png")
      {
        Icon_class = -1;
      }
    } else if (cur_time == "mid_afternoon")
    {
      if (icon_name == "restaurant.png")
      {
        Icon_class = 2;
      } else if (icon_name == "resident.png" || icon_name == "transit.png" )
      {
        Icon_class = 3;
      } else if (icon_name == "office.png" || icon_name == "school.png" )
      {
        Icon_class = 2;
      } else if (icon_name == "recreation.png")
      {
        //the icon is inactive at this time
        Icon_class = 2;
      }
    }

    return Icon_class;
  }


  
}