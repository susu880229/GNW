/**
* BuildingUse represents a possible category/type of building
*/
class BuildingUse
{
  String name;
  PImage img;
  color colorId;


  BuildingUse(String name, String imgSrc, color colorId)
  {
    this.name = name;
    this.colorId = colorId;
    if (imgSrc != "") {
      img = loadImage(imgSrc);
      img.resize(90, 0);
    } else {
      img = null;
    }
    
  }
}


//---------------------------------------------------------
/*
* Represents the building use icons/boxes on interface
 */
class BuildingUseBox
{
  BuildingUse buildingUse;
  int box_x;
  int box_y;
  int box_width;
  int box_height;
  PImage pull_img;
  //boolean hover;
  boolean lock;

  BuildingUseBox(BuildingUse buildingUse, int x, int y, String pull_imgSrc)
  {
    this.buildingUse = buildingUse;
    box_x = x;
    box_y = y;
    box_width = 360;
    box_height = 290;
    pull_img = loadImage(pull_imgSrc);
    lock = false;
  }

  //draw method
  void render()
  {
    fill(buildingUse.colorId);
    rect(box_x, box_y, box_width, box_height);
    
  }

  //detect the mouse is hover on the useBox to drag or to pull up the information
  boolean drag_detect()
  {
    boolean checkX = mouseX > box_x && mouseX < box_x + box_width;
    boolean checkY_drag = mouseY > box_y && mouseY < box_y + box_height * 2 / 3;
    return checkX && checkY_drag;
  }
  
  boolean pull_detect()
  {
    boolean checkX = mouseX > box_x && mouseX < box_x + box_width;
    boolean checkY_pull = mouseY > box_y + box_height * 2 / 3 && mouseY < box_y + box_height;
    return checkX && checkY_pull;
  }
}


//---------------------------------------------------------
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