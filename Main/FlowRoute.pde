/**
 * The FlowRoute class represents each route on the map between two buildings.
 */

class FlowRoute 
{

  int initial_nodeID;
  int dest_nodeID;
  float density;
  ArrayList<GraphNode> nodes;

  /**
   * The FlowRoute constructor
   * @param initial_id Intial doorID of the person
   * @param dest_id destination doorID of the person
   * @param d the density of person from intial to dest
   */

  FlowRoute(int initial_id, int dest_id, float d) 
  {
    initial_nodeID = initial_id;
    dest_nodeID = dest_id;
    density = d;
    nodes = new ArrayList<GraphNode>();
    nodes = GNWPathFinder.findPath(initial_nodeID, dest_nodeID);
  }

  /*
  *  From the route found between two buildings, update the Arraylist path. 
   *  If the route passes through paths that have an existing flow, 
   *  add the densities together. Else, add the new path into the Arraylist path.
   */

  ArrayList<Path> buildPathDensities(float d, ArrayList<Path> flowPaths)
  {
    for (int i = 0; i < nodes.size() - 1; i++)
    {
      float nodeStartX = nodes.get(i).xf();
      float nodeStartY = nodes.get(i).yf();
      float nodeEndX = nodes.get(i+1).xf();
      float nodeEndY = nodes.get(i+1).yf();
      boolean doesPathExist = false;

      Path curPath = new Path(new PVector(nodeStartX, nodeStartY), new PVector(nodeEndX, nodeEndY), d);
      curPath.density = curPath.calcFinalDensity();

      for (int j = 0; j < flowPaths.size(); j++) 
      {
        Path examPath = flowPaths.get(j);
        if (nodeStartX == examPath.pathStartPoint.x && nodeStartY == examPath.pathStartPoint.y &&
          nodeEndX == examPath.pathEndPoint.x && nodeEndY == examPath.pathEndPoint.y)
        {
          doesPathExist = true;  
          flowPaths.get(j).density += curPath.density;
          break;
        }
      }

      if (!doesPathExist)
      {
        flowPaths.add(curPath);
      }
    }

    return flowPaths;
  }
}