class BuildingTooltip
{
  PImage tooltipImage_Left;
  PImage tooltipImage_Right;
  float tooltipX;
  float tooltipY;

  BuildingTooltip()
  {
    tooltipImage_Left = loadImage("tooltip_left.png");
    tooltipImage_Right = loadImage("tooltip_right.png");
  }

  void drawTooltip(float tooltipX, float tooltipY, ArrayList<BuildingUse> buildingUses, boolean isOnRight)
  {
    float initalX = (isOnRight) ? 55 : 30;
    PImage tooltipImage = (isOnRight) ? tooltipImage_Right : tooltipImage_Left;
    image(tooltipImage, tooltipX, tooltipY);

    if (buildingUses.isEmpty()) {
      return;
    } else {
      for (int i = 0; i < buildingUses.size(); i++) {
        BuildingUse bUse = buildingUses.get(i);
        float space = (i == 0) ? initalX : initalX + i * (45 + bUse.img.width);
        float bUX = tooltipX + space;
        float bUY = tooltipY + 30;
        image(bUse.img, bUX, bUY);
      }
    }
  }
}