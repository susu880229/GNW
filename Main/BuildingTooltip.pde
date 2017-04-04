/** //<>//
 * The BuildingTooltip class represents the tooltip that popups for customizable lots
 */
class BuildingTooltip
{
  PImage tooltipImage;
  boolean isOnRight;
  float initialIconX;
  float initialIconY;
  float tooltipX;
  float tooltipY;
  int maxSlots;
  HotspotCoords buildingCoords;

  float tooltipArrowSpace = 25;
  float dividerSpace = 50;
  float rightWhiteSpace = 20;
  float topWhiteSpace = 30;
  float mapPorportion = .8;

  /**
   * The BuildingTooltip constructor
   *
   * @param buildingCoords This is the hotspot of the building
   * @param maxSlots This is the most number of uses you can add to this building
   */
  BuildingTooltip(HotspotCoords buildingCoords, int maxSlots)
  {
    this.maxSlots = maxSlots;
    this.buildingCoords = buildingCoords;
  }

  /**
   * Draws the tooltip on to the map next to the building
   *
   * @param buildingUses This is an arraylist of all the current building uses of the building
   */
  void drawTooltip(ArrayList<BuildingUse> buildingUses)
  {
    isOnRight = (buildingCoords.bottomRight.x < (GNWInterface.interfaceImage.width - shiftX) * mapPorportion);

    String imageName = (isOnRight) ? "tooltip_right" : "tooltip_left";
    imageName += "_" + maxSlots + ".png";
    tooltipImage = loadImage(imageName);

    initialIconX = (isOnRight) ? tooltipArrowSpace + rightWhiteSpace : rightWhiteSpace;
    initialIconY = topWhiteSpace;

    tooltipX = (isOnRight) ? buildingCoords.topRight.x :  buildingCoords.bottomLeft.x - tooltipImage.width;
    tooltipY = (isOnRight) ? buildingCoords.topRight.y - 30 : buildingCoords.topLeft.y;

    image(tooltipImage, tooltipX, tooltipY);

    if (!buildingUses.isEmpty()) {
      for (int i = 0; i < buildingUses.size(); i++) {        
        drawBuildingUse(buildingUses.get(i), i);
      }
    }
  }

  /**
   * Draws the building use onto the tooltip
   *
   * @param bUse The building use to draw icon onto tooltip
   * @param bUseIndex The position of icon on the tooltip
   */
  void drawBuildingUse(BuildingUse bUse, int bUseIndex)
  {
    PImage bUseImage = loadImage(bUse.imgSrc);

    float space = (bUseIndex == 0) ? initialIconX : initialIconX + bUseIndex * (dividerSpace + bUseImage.width);
    float bUX = tooltipX + space;
    float bUY = tooltipY + initialIconY;
    image(bUseImage, bUX, bUY);
    
    float crossImageX = bUX + bUseImage.width - 30;
    float crossImageY = bUY - 20;
    PImage crossImage = loadImage("cross_sign.png");
    image(crossImage, crossImageX, crossImageY);
  }

  /**
   * Selects the building use that the mouse has pressed. Exception is thrown if no building use was identified at the mouse position.
   *
   * @param ArrayList<BuildingUse> buildingUses This is an arraylist of all the current building uses of the building
   * @return Returns the index of the building use that the mouse pressed.
   */
  int selectBuildingUse(ArrayList<BuildingUse> buildingUses) throws Exception
  {
    if (isOnRight) { 
      tooltipX = tooltipX + tooltipArrowSpace;
    }

    for (int i = 0; i < buildingUses.size(); i++) {        
      float bUTooltipWidth = (tooltipImage.width - tooltipArrowSpace) / maxSlots;
      int currentMouseX = mouseX - shiftX;

      Boolean inX = tooltipX + (i * bUTooltipWidth) < currentMouseX && tooltipX + ((i+1) * bUTooltipWidth) > currentMouseX; 
      Boolean inY = tooltipY < mouseY && tooltipY + tooltipImage.height > mouseY;

      if (inX && inY) {
        return i;
      }
    }
    throw new Exception ("No building use selected");
  }
}