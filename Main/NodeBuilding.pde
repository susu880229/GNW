/**
 * The NodeBuilding class represents the connection points between roads and buildings
 */
class NodeBuilding implements Node {
  Building building;
  ArrayList<Road> roads;
  Coord buildingPos;    

  /*
  * NodeBuilding constructor 
   * @param building The building object
   * @param roads The list of road(s) it is connected to. There should only be 1 road in this list
   * @param buildingPos The coordinates of the "door" to the building. 
   */
  NodeBuilding (Building building, ArrayList<Road> roads, Coord buildingPos) {
    this.building = building;
    this.roads = roads;
    this.buildingPos = buildingPos;
  }

  /*
  * Returns the id of the associated BuildingID
   */
  String getId() {
    return building.buildingId;
  }

  /*
  * Returns all the associated roads
   */
  ArrayList<Road> getRoads() {
    return roads;
  }

  /*
 * Returns the coordinates of the access point to building
   */
  Coord getPos() {
    return buildingPos;
  }
}