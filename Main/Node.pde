/**
 * Interface for nodes (BuildingNode and RoadNoad)
 */
interface Node {
  
  String getId();
  
  ArrayList<Road> getRoads();
  
  Coord getPos();
}