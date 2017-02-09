/**
 * The Road class represents the roads between the buildings/lots that people can travel on
 */
class Road {
  ArrayList<Node> nodes;
  String roadId; 
  Coord roadPos1;
  Coord roadPos2;
  
  /**
  * Road constructor 
  * @param id This is the id of the road
  * @param nodes This is the list of building nodes and road nodes that are on the road 
  * @param pos1 This is the coordinates of one end of the road
  * @param pos1 This is the coordinates of the other end of the road
  */
  Road (String id, ArrayList<Node> nodes, Coord pos1, Coord pos2) {
    this.nodes = nodes;
    roadId = id;
    roadPos1 = pos1;
    roadPos2 = pos2;
  } 
}