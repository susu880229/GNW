class BuildingUse
{
  String name;
  PImage img;
  color colorId;

  //TODO this should be a hashmap to store all the locations depending on time of the day
  String matchBUse;

  BuildingUse(String name, String imgSrc, color colorId, String matchBUse)
  {
    this.name = name;
    this.colorId = colorId;
    this.matchBUse = matchBUse;
    img = loadImage(imgSrc);
    img.resize(90, 0);
  }
}