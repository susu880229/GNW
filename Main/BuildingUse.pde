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