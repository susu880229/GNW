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
  int iconWidth = 100;
  int iconHeight = 100;
  //constructor
  BuildingUseIcon(BuildingUse buildingUse, int x, int y)
  {
    this.buildingUse = buildingUse;
    w = 100;
    h = 100;
    bx = x - (iconWidth/2);
    by = y - (iconHeight/2);
    a = buildingUse.img;
  }


  //the image is controlled by the bx, by parameters
  void render()
  {
    image(a, bx, by, w, h);
  }

  void mouseDragged() 
  {
    //update the new position of the image everytime user drag it
    bx = mouseX - (iconWidth/2);
    by = mouseY - (iconHeight/2);
  }
}