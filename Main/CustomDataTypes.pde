/**
 * Coord class represents the x & y coordinates of a point on the map
 */
class Coord {
  float x;
  float y;
  
  Coord(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

//--------------------------------------------------------------------------

/**
 * The WorkListEntry class holds a node and a list of coordinates (represents a path). It is used in the pathfinding
 */
class WorkListEntry {
  Node node;
  ArrayList coordinates;
  
  WorkListEntry(Node node, ArrayList<Coord> coordinates) {
    this.node = node;
    this.coordinates = coordinates;
  }
}