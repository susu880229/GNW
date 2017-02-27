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
    a = loadImage(icon_name);
  }

  
  //the image is controlled by the bx, by parameters
  void render()
  {
    image(a, bx, by, w, h);
  }
  
  void mouseDragged() 
  {

    //update the new position of the image everytime user drag it
    bx = mouseX;
    by = mouseY;
  }


  

  
}