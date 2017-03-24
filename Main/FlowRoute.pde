/**
 * The FlowRoute class represents each route on the map between two buildings.
 */

class FlowRoute 
{
  int initial_nodeID;
  int dest_nodeID;
  int numDelayUnit;
  int delay;
  int timeToNextParticleGen;
  int from_repeatUseIndex;      //1 = 1 use of that type in the building, 2 = 2 use of that type, 3 = 3 use of that type
  int to_repeatUseIndex;        //1 = 1 use of that type in the building, 2 = 2 use of that type, 3 = 3 use of that type
  String from_buildingUse;
  String to_buildingUse;
  ArrayList<GraphNode> nodes;
  boolean isStartOfFlow;

  /**
   * The FlowRoute constructor
   * @param initial_id Intial doorID of the particle
   * @param dest_id destination doorID of the particle
   * @param d the delay between each particle appearing at the start node 
   */

  FlowRoute(int initial_id, int dest_id, int dUnit, int d, String from_use, String to_use, int from_numRepeatedUse, int to_numRepeatedUse) 
  {
    initial_nodeID = initial_id;
    dest_nodeID = dest_id;
    numDelayUnit = dUnit;
    delay = d;
    timeToNextParticleGen = (int)random(0,d);
    from_buildingUse = from_use;
    to_buildingUse = to_use;
    nodes = new ArrayList<GraphNode>();
    nodes = GNWPathFinder.findPath(initial_nodeID, dest_nodeID);
    isStartOfFlow = true;
    from_repeatUseIndex = from_numRepeatedUse;
    to_repeatUseIndex = to_numRepeatedUse;
  }

  ArrayList<Particle> addNewParticle(ArrayList<Particle> particles)
  {
    Particle pA = new Particle(nodes, initial_nodeID, dest_nodeID, from_buildingUse, to_buildingUse);
    particles.add(pA);
    return particles;
  }
}