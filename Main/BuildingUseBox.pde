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
    box_width = 365;
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