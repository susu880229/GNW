/**
 * The Person class represents a person who will be flowing between the buildings 
 */
class Person {
  PVector sourcePos;
  PVector destinationPos;
  PVector velocity;
  float lifespan;

  /**
   * The Person constructor
   * @param buildingPosition This is the position of the building the person is in
   * @param destinationPosition This is the position of the building the person will go to
   */
  Person(float x, float y, PVector destinationPosition) {
    sourcePos = new PVector(x, y);
    destinationPos = destinationPosition;
    velocity = new PVector(1, 0);
    lifespan = destinationPos.x - sourcePos.x;
  }

  /**
   * The animation of people flow
   */
  void run() {    
    update();
    render();
  }

  /**
   * Renders a dot to represent the person onto the screen
   */
  void render() {
    ellipse(sourcePos.x, sourcePos.y, 8, 8);
  }

  /**
   * Updates position of dot
   */
  void update() {
    sourcePos.add(velocity);
    lifespan -= 1;
  }

  /**
   * Checks if dot is still active or not
   */
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }


  /**
   * Finds path to take between two buildings
   * @param start Start node (aka "door") of person to travel from
   * @param dest Destination node for person to travel to
   */
  ArrayList<Coord> findPath (NodeBuilding start, NodeBuilding dest) {
    ArrayList<Node> visited = new ArrayList<Node>();
    ArrayList<Coord> path = new ArrayList<Coord>();
    ArrayList<WorkListEntry> todo = new ArrayList<WorkListEntry>();

    path.add(start.buildingPos);
    return findPathHelper(start, dest, visited, path, todo);
  }

  /** 
   * Recursive path finder helper function
   * If failed to find valid path, null will return
   */
  private ArrayList<Coord> findPathHelper (Node start, Node dest, ArrayList<Node> visited, ArrayList<Coord> path, ArrayList<WorkListEntry> todo) {
    if (start.getId() == dest.getId()) {
      return path;
    } else if (visited.contains(start)) {
      findPathToDoHandler(todo, visited, dest);
    } else {
      for (Road road : start.getRoads()) {
        for (Node node : road.nodes) {
          ArrayList<Coord> newPath = new ArrayList<Coord>();
          newPath.addAll(path);
          WorkListEntry wle = new WorkListEntry(node, newPath);
          todo.add(wle);
        }
      }
      visited.add(start);
      findPathToDoHandler(todo, visited, dest);
    }
    return null;
  }

  private ArrayList<Coord> findPathToDoHandler (ArrayList<WorkListEntry> todo, ArrayList<Node> visited, Node dest) {
    if (todo.isEmpty()) {
      return null;
    } else {
      Node nextNode = todo.get(0).node;
      ArrayList<Coord> pathInstance = todo.get(0).coordinates;
      todo.remove(0);
      return findPathNodeHandler(nextNode, visited, pathInstance, todo, dest);
    }
  }

  private ArrayList<Coord> findPathNodeHandler (Node nextNode, ArrayList<Node> visited, ArrayList<Coord> path, ArrayList<WorkListEntry> todo, Node dest) {
    path.add(nextNode.getPos());
    return findPathHelper(nextNode, dest, visited, path, todo) ;
  }
}