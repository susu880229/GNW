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