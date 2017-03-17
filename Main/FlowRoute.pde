/**
 * The FlowRoute class represents each route on the map between two buildings.
 */

class FlowRoute 
{
  int initial_nodeID;
  int dest_nodeID;
  int delay;
  int timeToNextParticleGen;
  String from_buildingUse;
  String to_buildingUse;
  ArrayList<GraphNode> nodes;

  /**
   * The FlowRoute constructor
   * @param initial_id Intial doorID of the particle
   * @param dest_id destination doorID of the particle
   * @param d the delay between each particle appearing at the start node 
   */

  FlowRoute(int initial_id, int dest_id, int d, String from_use, String to_use) 
  {
    initial_nodeID = initial_id;
    dest_nodeID = dest_id;
    delay = d;
    timeToNextParticleGen = (int)random(0,d);
    from_buildingUse = from_use;
    to_buildingUse = to_use;
    nodes = new ArrayList<GraphNode>();
    nodes = GNWPathFinder.findPath(initial_nodeID, dest_nodeID);
  }

  ArrayList<Particle> addNewParticle(ArrayList<Particle> particles)
  {
    Particle pA = new Particle(nodes, initial_nodeID, dest_nodeID, from_buildingUse, to_buildingUse);
    particles.add(pA);
    return particles;
  }
}