/**
 * Interface for nodes (BuildingNode and RoadNoad)
 */
interface Node {
  
  String getId();
  
  ArrayList<Road> getRoads();
  
  Coord getPos();
}

//--------------------------------------------------------------------------

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

//--------------------------------------------------------------------------

/**
 * The NodeRoad class represents the connection points (intersection) & between roads and other roads
 */
class NodeRoad implements Node {
  ArrayList<Road> roads;
  Coord nodePos;  

  /*
  * NodeRoad constructor 
   * @param roads The list of road(s) it interesects with
   * @param nodePos The coordinates of the road intersection
   */
  NodeRoad (ArrayList<Road> roads, Coord nodePos) {
    this.roads = roads;
    this.nodePos = nodePos;
  }

  /*
  * Returns a blank string. An intersection doesn't have a specific road or building it is associated to.
   */
  String getId() {
    return "";
  }

  /*
  * Returns all the associated roads
   */
  ArrayList<Road> getRoads() {
    return roads;
  }

  /*
 * Returns the coordinates of the intersection
   */
  Coord getPos() {
    return nodePos;
  }
}