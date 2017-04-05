/**
 * BuildingUse represents a possible category/type of building
 */
class BuildingUse
{
  String name;
  String imgSrc;
  color colorId;

  /**
   * The BuildingUse constructor
   * @param name    Name of building use
   * @param imgSrc  The image location 
   * @param colorId Color of building use
   */
  BuildingUse(String name, String imgSrc, color colorId)
  {
    this.name = name;
    this.colorId = colorId;
    this.imgSrc = imgSrc;
  }
}


//---------------------------------------------------------
/**
 * Represents the building use boxes on interface
 */
class BuildingUseBox
{
  BuildingUse buildingUse;
  int box_x;
  int box_y;
  PImage pull_img;
  boolean lock;

  int box_width = 360;
  int box_height = 290;

  /**
   * The BuildingUseBox constructor
   * @param buildingUse The building use associated with this box
   * @param x           The x position of the box  
   * @param y           The y position of the box 
   * @param pull_imgSrc Location of the the associated pull image
   */
  BuildingUseBox(BuildingUse buildingUse, int x, int y, String pull_imgSrc)
  {
    this.buildingUse = buildingUse;
    box_x = x;
    box_y = y;
    pull_img = loadImage(pull_imgSrc);
    lock = false;
  }

  /**
   * Detect if the mouse is hover on the useBox to drag 
   */
  boolean drag_detect()
  {
    boolean checkX = mouseX > box_x && mouseX < box_x + box_width;
    boolean checkY_drag = mouseY > box_y && mouseY < box_y + box_height * 2 / 3;
    return checkX && checkY_drag;
  }

  /**
   * Detects if the mouse is to pull up information
   */
  boolean pull_detect()
  {
    boolean checkX = mouseX > box_x && mouseX < box_x + box_width;
    boolean checkY_pull = mouseY > box_y + box_height * 2 / 3 && mouseY < box_y + box_height;
    return checkX && checkY_pull;
  }
  
  /**
  * Draws pull up for this building use box
  */
  void renderPullUp() 
  {
    image(pull_img, box_x + 10, box_y + 16, box_width - 20, box_height - 16);
  }
}


//------------------------------------------------------
/**
 * Represents the building use icons
 */
class BuildingUseIcon
{
  BuildingUse buildingUse;
  int bx;
  int by;
  String icon_name;
  PImage bUIconImg;

  boolean hover = false;
  boolean locked = false;
  int difx = 0; 
  int dify = 0; 
  int Icon_class = -1;
  int iconWidth = 100;
  int iconHeight = 100;

  /**
   * The BuildingUseIcon constructor
   * @param buildingUse The building use associated with this icon
   * @param x           The x position of the icon  
   * @param y           The y position of the icon 
   */
  BuildingUseIcon(BuildingUse buildingUse, int x, int y)
  {
    this.buildingUse = buildingUse;
    bx = x - (iconWidth/2);
    by = y - (iconHeight/2);
    bUIconImg = loadImage(buildingUse.imgSrc);
  }

  /**
   * Draw icon image at coordinates
   */
  void render()
  {
    image(bUIconImg, bx, by, iconWidth, iconHeight);
  }

  /**
   * Update position of the image as user drags it
   */
  void mouseDragged() 
  {
    bx = mouseX - (iconWidth/2);
    by = mouseY - (iconHeight/2);
  }
}