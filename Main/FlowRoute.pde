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
   * @param initial_id          Intial doorID of the particle
   * @param dest_id             destination doorID of the particle
   * @param dUnit               the delay unit for the flow (taken from flow_matrix.txt)
   * @param d                   the actual delay for the flow calculated from the delay unit
   * @param from_use            the name of the use that the particles originate from
   * @param to_use              the name of the use that the particles are going towards
   * @param from_numRepeatedUse the "repeat use index" of the originator
   * @param to_numRepeatedUse   the "repeat use index" of the destination
   */
  FlowRoute(int initial_id, int dest_id, int dUnit, int d, String from_use, String to_use, int from_numRepeatedUse, int to_numRepeatedUse) 
  {
    initial_nodeID = initial_id;
    dest_nodeID = dest_id;
    numDelayUnit = dUnit;
    delay = d;
    timeToNextParticleGen = (int)random(0, 100);
    from_buildingUse = from_use;
    to_buildingUse = to_use;
    nodes = new ArrayList<GraphNode>();
    nodes = GNWPathFinder.findPath(initial_nodeID, dest_nodeID);
    isStartOfFlow = true;
    from_repeatUseIndex = from_numRepeatedUse;
    to_repeatUseIndex = to_numRepeatedUse;
  }

  /**
   * Return new particle
   */
  Particle getNewParticle()
  {
    return new Particle(nodes, initial_nodeID, dest_nodeID, from_buildingUse, to_buildingUse);
  }
}