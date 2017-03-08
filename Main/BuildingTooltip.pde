class BuildingTooltip
{
  PImage tooltipImage;
  boolean isOnRight;
  float initialIconX;
  float initialIconY;
  float tooltipX;
  float tooltipY;
  float dividerSpace = 45;

  BuildingTooltip()
  {
    tooltipImage = loadImage("tooltip_right.png");
  }

  void drawTooltip(float x, float y, ArrayList<BuildingUse> buildingUses, boolean isOnRight)
  {
    this.isOnRight = isOnRight;
    initialIconX = (isOnRight) ? 55 : 30;
    initialIconY = y + 30;

    tooltipX = x;
    tooltipY = y;
    tooltipImage = (isOnRight) ? loadImage("tooltip_right.png") : loadImage("tooltip_left.png");
    image(tooltipImage, tooltipX, tooltipY);

    if (buildingUses.isEmpty()) {
      return;
    } else {
      for (int i = 0; i < buildingUses.size(); i++) {        
        BuildingUse bUse = buildingUses.get(i);
        float space = (i == 0) ? initialIconX : initialIconX + i * (dividerSpace + bUse.img.width);
        float bUX = tooltipX + space;
        float bUY = initialIconY;
        image(bUse.img, bUX, bUY);
      }
    }
  }

  String selectBuildingUse(ArrayList<BuildingUse> buildingUses) throws Exception
  {
    for (int i = 0; i < buildingUses.size(); i++) {        
      String bUName = buildingUses.get(i).name;

      float bUTooltipWidth = (tooltipImage.width - initialIconX) /3;

      int currentMouseX = mouseX - shiftX;

      Boolean inX = tooltipX + (i * bUTooltipWidth) < currentMouseX && tooltipX + ((i+1) * bUTooltipWidth) > currentMouseX; 
      Boolean inY = tooltipY < mouseY && tooltipY + tooltipImage.height > mouseY;


      println(currentMouseX + " " + mouseY);
      println(initialIconX + (i * bUTooltipWidth) + " " + tooltipY);
      println( (initialIconX + ((i+1) * bUTooltipWidth)) + " " + (tooltipY + tooltipImage.height));

      if (inX && inY) {
        return bUName;
      }
    }
    throw new Exception ("No building use selected");
  }
}