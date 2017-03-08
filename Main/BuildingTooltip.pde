class BuildingTooltip
{
  PImage tooltipImage;
  HashMap<String, float[]> bUIconCoords;
  boolean isOnRight;
  float initialIconX;
  float initialIconY;
  float dividerSpace = 45;

  BuildingTooltip()
  {
    tooltipImage = loadImage("tooltip_right.png");
    bUIconCoords = new HashMap<String, float[]>();
  }

  void drawTooltip(float tooltipX, float tooltipY, ArrayList<BuildingUse> buildingUses, boolean isOnRight)
  {
    this.isOnRight = isOnRight;
    initialIconX = (isOnRight) ? 55 : 30;
    initialIconY = tooltipY + 30;
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

        float[] bUCoord = {bUX, bUY};
        bUIconCoords.put(bUse.name, bUCoord);
      }
    }
  }

  String selectBuildingUse() throws Exception
  {
    int count = 1;
    for (Map.Entry bUIconCoordEntry : bUIconCoords.entrySet()) {
      String bUName = (String) bUIconCoordEntry.getKey();
      float[] bUTooltipCoords = (float[]) bUIconCoordEntry.getValue();
      float bUTooltipWidth = (tooltipImage.width - initialIconX) /3;

      int currentMouseX = mouseX - shiftX;
      
      Boolean inX = bUTooltipCoords[0] < currentMouseX && bUTooltipCoords[0] + (count * bUTooltipWidth) > currentMouseX; 
      Boolean inY = bUTooltipCoords[1] < mouseY && bUTooltipCoords[1] + tooltipImage.height > mouseY;


//      println(currentMouseX + " " + mouseY);
//      println(bUTooltipCoords[0] + " " + bUTooltipCoords[1]);
//      println( (bUTooltipCoords[0] + (count * bUTooltipWidth) ) + " " + (bUTooltipCoords[1] + tooltipImage.height));
      
      
      if (inX && inY) {
        return bUName;
      }
      count ++;
    }
    throw new Exception ("No building use selected");
  }
}