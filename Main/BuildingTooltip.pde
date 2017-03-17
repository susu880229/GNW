class BuildingTooltip
{
  PImage tooltipImage;
  PImage crossImage;
  boolean isOnRight;
  float initialIconX;
  float initialIconY;
  float tooltipX;
  float tooltipY;
  float dividerSpace = 60;
  int maxSlots;
  BuildingCoords buildingCoords;

  BuildingTooltip(BuildingCoords buildingCoords, int maxSlots)
  {
    crossImage = loadImage("cross_sign.png");
    crossImage.resize(50, 0);

    this.maxSlots = maxSlots;
    this.buildingCoords = buildingCoords;
  }

  void drawTooltip(ArrayList<BuildingUse> buildingUses) //<>//
  {
    isOnRight = (buildingCoords.bottomRight.x < (GNWInterface.interfaceImage.width - shiftX) * 8/10); //<>//

    String imageName = (isOnRight) ? "tooltip_right" : "tooltip_left";
    imageName += "_" + maxSlots + ".png";
    tooltipImage = loadImage(imageName);

    initialIconX = (isOnRight) ? 50 : 25;
    initialIconY = 40;

    tooltipX = (isOnRight) ? buildingCoords.topRight.x :  buildingCoords.bottomLeft.x - tooltipImage.width;
    tooltipY = (isOnRight) ? buildingCoords.topRight.y - 30 : buildingCoords.topLeft.y;

    image(tooltipImage, tooltipX, tooltipY);

    if (buildingUses.isEmpty()) {
      return;
    } else {
      for (int i = 0; i < buildingUses.size(); i++) {        
        BuildingUse bUse = buildingUses.get(i);
        float space = (i == 0) ? initialIconX : initialIconX + i * (dividerSpace + bUse.img.width);
        float bUX = tooltipX + space;
        float bUY = tooltipY + initialIconY;
        image(bUse.img, bUX, bUY);
        image(crossImage, bUX + bUse.img.width - 20, bUY - 25);
      }
    }
  }

  String selectBuildingUse(ArrayList<BuildingUse> buildingUses) throws Exception
  {
    for (int i = 0; i < buildingUses.size(); i++) {        
      String bUName = buildingUses.get(i).name;

      float bUTooltipWidth = (tooltipImage.width - initialIconX) / maxSlots;
      int currentMouseX = mouseX - shiftX;

      Boolean inX = tooltipX + (i * bUTooltipWidth) < currentMouseX && tooltipX + ((i+1) * bUTooltipWidth) > currentMouseX; 
      Boolean inY = tooltipY < mouseY && tooltipY + tooltipImage.height > mouseY;

      if (inX && inY) {
        return bUName;
      }
    }
    throw new Exception ("No building use selected");
  }
}