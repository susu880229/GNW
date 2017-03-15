/**
 * The Path class represents each graph edge on the map that has a flow running.
 */

class Path 
{
  float dis_x;
  float dis_y;
  float gradient;
  float constant;
  float angle;
  PVector pathStartPoint;
  PVector pathEndPoint;
  ArrayList<GraphNode> nodes;


  /**
   * The Path constructor
   * @param start x and y value of start point
   * @param end x and y value of end point
   */

  Path (PVector start, PVector end) 
  {
    pathStartPoint = start;
    pathEndPoint = end;
    dis_x = end.x - start.x;
    dis_y = end.y - start.y;
    gradient = dis_y / dis_x;
    constant = start.y - (start.x * gradient);
    angle = atan(gradient);
  }
}