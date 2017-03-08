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

  BuildingUseBox(BuildingUse buildingUse, int x, int y)
  {
    this.buildingUse = buildingUse;
    box_x = x;
    box_y = y;
    box_width = 385;
    box_height = 290;

  }

  //draw method
  void render()
  {
    fill(buildingUse.colorId);
    rect(box_x, box_y, box_width, box_height);
  }

  boolean detect()
  {
    boolean checkX = mouseX > box_x && mouseX < box_x + box_width;
    boolean checkY = mouseY > box_y && mouseY < box_y + box_height;

    return checkX && checkY;
  }
}
