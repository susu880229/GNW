class BuildingUse
{
  String name;
  String imgSrc;
  color colorId;

  //TODO this should be a hashmap to store all the locations depending on time of the day
  String matchBUse;

  BuildingUse(String name, String imgSrc, color colorId, String matchBUse)
  {
    this.name = name;
    this.imgSrc = imgSrc;
    this.colorId = colorId;
    this.matchBUse = matchBUse;
  }
}