class GNWPathFinder 
{
  ArrayList<GraphNode> gNodes;
  ArrayList<GraphEdge> gEdges;
  IGraphSearch pathFinder;
  Graph GNWGraph;
  float nodeSize;

  GNWPathFinder() 
  {
    nodeSize = 12.0f;
    GNWGraph = new Graph();
    createGNWGraph();
  }

  /**
   * Creates GNWGraph with nodes and edges for path finding
   */
  void createGNWGraph() 
  {
    makeGraphFromFile(GNWGraph, "graph.txt");
    pathFinder = new GraphSearch_Astar(GNWGraph, new AshCrowFlight(1.0f));
    gNodes = new ArrayList<GraphNode>();
    Node_arrayTolist();
    gEdges = new ArrayList<GraphEdge>();
    Edge_arrayToList();
  }
  

  /**
   * Finds route
   * @return GraphNode[] List of nodes to visit to go from startNode to endNode
   */
  ArrayList<GraphNode> findPath(int startNode, int endNode) 
  {
    ArrayList<GraphNode> path_nodes = new ArrayList<GraphNode>();
    pathFinder.search(startNode, endNode, true);
    for (GraphNode node : pathFinder.getRoute())
    {
      path_nodes.add(node);
    }
    return path_nodes;
  }
 
  /**
    *change gNodes from Array to ArrayList
    */
  void Node_arrayTolist()
  {

    for (GraphNode node : GNWGraph.getNodeArray())
    {
      gNodes.add(node);
    }
    
   }
   
  
  /**
     *change gEdges from Array to ArrayList
     */
  void Edge_arrayToList()
  {
    for (GraphEdge edge : GNWGraph.getAllEdgeArray())
    {
      gEdges.add(edge);
    }
  }

  /**
   * Draws nodes and edges of graph for debugging help
   */
  void drawGraph()
  {
    drawNodes();
    drawEdges(gEdges, color(192, 192, 192, 128), 1.0f, true);
  }

  /** 
   * Helper to draw nodes
   */
  void drawNodes() 
  {
    pushStyle();
    noStroke();
    for (GraphNode node : gNodes) {
      fill(255, 0, 0);
      textSize(12);
      text(node.id(), node.xf() - 3, node.yf()+2);
    }
    popStyle();
  }


  /** 
   * Helper to draw edges
   */
  void drawEdges(ArrayList<GraphEdge> edges, int lineCol, float sWeight, boolean arrow) {
    if (edges != null) {
      pushStyle();
      noFill();
      stroke(lineCol);
      strokeWeight(sWeight);
      for (GraphEdge ge : edges) {
        if (arrow)
          drawArrow(ge.from(), ge.to(), nodeSize / 2.0f, 6);
        else {
          line(ge.from().xf(), ge.from().yf(), ge.to().xf(), ge.to().yf());
        }
      }
      popStyle();
    }
  }

  /** 
   * Helper to draw arrows on edges to indicate which direction it allows
   */
  void drawArrow(GraphNode fromNode, GraphNode toNode, float nodeRad, float arrowSize) {
    float fx, fy, tx, ty;
    float ax, ay, sx, sy, ex, ey;
    float awidthx, awidthy;

    fx = fromNode.xf();
    fy = fromNode.yf();
    tx = toNode.xf();
    ty = toNode.yf();

    float deltaX = tx - fx;
    float deltaY = (ty - fy);
    float d = sqrt(deltaX * deltaX + deltaY * deltaY);

    sx = fx + (nodeRad * deltaX / d);
    sy = fy + (nodeRad * deltaY / d);
    ex = tx - (nodeRad * deltaX / d);
    ey = ty - (nodeRad * deltaY / d);
    ax = tx - (nodeRad + arrowSize) * deltaX / d;
    ay = ty - (nodeRad + arrowSize) * deltaY / d;

    awidthx = - (ey - ay);
    awidthy = ex - ax;

    noFill();
    strokeWeight(4.0f);
    stroke(160, 128);
    line(sx, sy, ax, ay);

    noStroke();
    fill(48, 128);
    beginShape(TRIANGLES);
    vertex(ex, ey);
    vertex(ax - awidthx, ay - awidthy);
    vertex(ax + awidthx, ay + awidthy);
    endShape();
  }

  /**
   * THIS FUNCTION IS ONLY TEMP HERE TO ILLUSTRATE ROUTES
   */

  //use the findpath result (a series of GraphNodes) as argument to draw lines between these nodes
  void drawRoute(ArrayList<GraphNode> r) 
  {
    int lineCol =color(200, 0, 0);
    float sWeight = 5.0f;
    if (r.size() >= 2) {
      pushStyle();
      stroke(lineCol);
      strokeWeight(sWeight);
      noFill();
      for (int i = 1; i < r.size(); i++)
        line(r.get(i-1).xf(), r.get(i-1).yf(), r.get(i).xf(), r.get(i).yf());

      // Route start node
      strokeWeight(2.0f);
      stroke(0, 0, 160);
      fill(0, 0, 255);
      ellipse(r.get(0).xf(), r.get(0).yf(), nodeSize, nodeSize);
      // Route end node
      stroke(160, 0, 0);
      fill(255, 0, 0);
      ellipse(r.get(r.size()-1).xf(), r.get(r.size()-1).yf(), nodeSize, nodeSize); 
      popStyle();
    }
  }

  /**
   * Creates graph from text file 
   * @param g Initial graph
   * @param fname Filenamet
   */
  void makeGraphFromFile(Graph g, String fname) 
  {
    String lines[];
    lines = loadStrings(fname);
    int mode = 0;
    int count = 0;
    while (count < lines.length) {
      lines[count].trim();
      if (!lines[count].startsWith("#") && lines[count].length() > 1) {
        switch(mode) {
        case 0:
          if (lines[count].equalsIgnoreCase("<nodes>"))
            mode = 1;
          else if (lines[count].equalsIgnoreCase("<edges>"))
            mode = 2;
          break;
        case 1:
          if (lines[count].equalsIgnoreCase("</nodes>"))
            mode = 0;
          else 
          makeNode(lines[count], g);
          break;
        case 2:
          if (lines[count].equalsIgnoreCase("</edges>"))
            mode = 0;
          else
            makeEdge(lines[count], g);
          break;
        } // end switch
      } // end if
      count++;
    } // end while
  }

  /**
   * Creates a node
   * @param s a coordinate from the configuration file
   * @param g the graph to add the node
   */
  void makeNode(String s, Graph g) 
  {
    int nodeID;
    float x, y = 0;
    String part[] = split(s, " ");
    if (part.length >= 3) {
      nodeID = Integer.parseInt(part[0]);
      x = Float.parseFloat(part[1]);
      y = Float.parseFloat(part[2]);
      g.addNode(new GraphNode(nodeID, x, y));
    }
  }

  /**
   * Creates an edge(s) between 2 nodes
   * @param s a line from the configuration file
   * @param g the graph to add the edge
   */
  void makeEdge(String s, Graph g) 
  {
    int fromID, toID;
    float costOut = 0, costBack = 0;
    String part[] = split(s, " ");
    if (part.length >= 3) {
      fromID = Integer.parseInt(part[0]);
      toID = Integer.parseInt(part[1]);
      try {
        costOut = Float.parseFloat(part[2]);
      }
      catch(Exception excp) {
        costOut = -1;
      }
      try {
        costBack = Float.parseFloat(part[3]);
      }
      catch(Exception excp) {
        costBack = -1;
      }
      if (costOut >= 0)
        g.addEdge(fromID, toID, costOut);
      if (costBack >= 0)
        g.addEdge(toID, fromID, costBack);
    }
  }
}
