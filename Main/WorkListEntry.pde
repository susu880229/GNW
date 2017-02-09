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