import pathfinder.*; //<>// //<>//
import java.util.Map;

GraphNode[] gNodes, rNodes;
GraphEdge[] gEdges, exploredEdges;
IGraphSearch pathFinder;
Graph GNWGraph;

HashMap<String, Building> GNWMap; //String is building id
ArrayList<Integer> type_1_buildingIds;
ArrayList<Integer> type_2_buildingIds;
ArrayList<Integer> type_3_buildingIds;

void setup() {
  size(1400, 700);
  GNWGraph = new Graph();
  GNWMap = new HashMap<String, Building>();
  type_1_buildingIds = new ArrayList<Integer>();
  type_2_buildingIds = new ArrayList<Integer>();
  type_3_buildingIds = new ArrayList<Integer>();

  createGNWGraph();
  createGNWMap();
  addInitBuildingTypes();

  //TODO: dynamically add types to building (drag and drop type icon into buildings)
}

/** 
 * Draws all the buildings in GNWMap
 */
void draw() {
  background(255);
  for (Map.Entry GNWMapEntry : GNWMap.entrySet()) {
    Building building = (Building) GNWMapEntry.getValue();
    building.render();
    building.run();
  }

  drawNodes();

  drawRoute(rNodes, color(200, 0, 0), 5.0f);
}

void drawNodes() {
  float nodeSize = 12.0f;
  pushStyle();
  noStroke();
  fill(255, 0, 255, 72);
  for (GraphNode node : gNodes)
    ellipse(node.xf(), node.yf(), nodeSize, nodeSize);
  popStyle();
}

void drawRoute(GraphNode[] r, int lineCol, float sWeight) {
  float nodeSize = 12.0f;
  if (r.length >= 2) {
    pushStyle();
    stroke(lineCol);
    strokeWeight(sWeight);
    noFill();
    for (int i = 1; i < r.length; i++)
      line(r[i-1].xf(), r[i-1].yf(), r[i].xf(), r[i].yf());
    // Route start node
    strokeWeight(2.0f);
    stroke(0, 0, 160);
    fill(0, 0, 255);
    ellipse(r[0].xf(), r[0].yf(), nodeSize, nodeSize);
    // Route end node
    stroke(160, 0, 0);
    fill(255, 0, 0);
    ellipse(r[r.length-1].xf(), r[r.length-1].yf(), nodeSize, nodeSize); 
    popStyle();
  }
}


/**
 * Adds type to building and adds building to list of appropriate type of building
 * @param id is the building ID
 * @param type is the type of usage to add to building
 */
void addType(int id, Type type) {
  Building building = GNWMap.get(id);
  building.addType(type);

  //Adds building id to appropriate list of building Ids
  switch(type.id) {
  case 1:
    type_1_buildingIds.add(id);
    break;
  case 2:
    type_2_buildingIds.add(id);
    break;
  case 3:
    type_3_buildingIds.add(id);
    break;
  }
}

/**
 * Adds default/existing building usages
 */
void addInitBuildingTypes() {
  GNWMap.get("Stn").addType(new Type_3());

  GNWMap.get("521").addType(new Type_4());
  GNWMap.get("515").addType(new Type_4());

  GNWMap.get("EmilyCarr").addType(new Type_1());

  GNWMap.get("CDM1").addType(new Type_1());
  GNWMap.get("CDM2").addType(new Type_4());
  GNWMap.get("CDM3").addType(new Type_1());

  GNWMap.get("Lot1").addType(new Type_4());
  GNWMap.get("Lot2").addType(new Type_4());
  GNWMap.get("Lot3").addType(new Type_4());
  GNWMap.get("Lot4").addType(new Type_4());
  GNWMap.get("Mec").addType(new Type_4());

  GNWMap.get("VCC").addType(new Type_1());
  GNWMap.get("Lot5").addType(new Type_4());

  GNWMap.get("Lot6").addType(new Type_4());   
  GNWMap.get("Lot7").addType(new Type_3());
}

/** 
 * Creates GNWMap with all the buildings and lots
 * Buildings/lots are added to from left to right and top to bottom
 */
void createGNWMap() {  
  addBuilding("City", false, 0, 220, 140, 265, 150, 252, 200, 205, 190);
  addBuilding("Park", false, 1, 205, 195, 252, 205, 235, 275, 187, 265);
  addBuilding("Stn", true, 2, 185, 270, 235, 280, 225, 330, 170, 330);

  addBuilding("Equinox", false, 3, 264, 175, 328, 190, 323, 215, 258, 200);
  addBuilding("521", true, 4, 250, 235, 290, 245, 280, 282, 240, 275);  
  addBuilding("515", true, 5, 240, 280, 295, 290, 295, 330, 230, 330);

  addBuilding("EmilyCarr", false, 6, 305, 230, 475, 230, 475, 280, 305, 280); 
  addBuilding("Plaza", false, 7, 300, 290, 360, 290, 360, 330, 300, 330);
  addBuilding("PCI", false, 8, 365, 290, 485, 290, 485, 330, 365, 330);

  addBuilding("CDM1", false, 9, 490, 235, 540, 235, 540, 305, 490, 305);
  addBuilding("CDM2", true, 10, 545, 235, 605, 258, 605, 285, 545, 285);
  addBuilding("CDM3", false, 11, 545, 290, 605, 290, 605, 330, 545, 330); 

  addBuilding("Lot1", true, 12, 610, 258, 760, 300, 745, 370, 610, 330); 
  addBuilding("Lot2", true, 13, 765, 300, 825, 320, 845, 400, 750, 372);
  addBuilding("Lot3", true, 14, 830, 320, 920, 348, 900, 417, 850, 402);
  addBuilding("Lot4", true, 15, 925, 348, 1015, 375, 995, 445, 905, 418);
  addBuilding("Mec", false, 16, 1020, 377, 1100, 400, 1100, 478, 1000, 447);

  addBuilding("Lot5", true, 17, 1105, 400, 1210, 420, 1210, 480, 1105, 480);
  addBuilding("VCC", false, 18, 1105, 500, 1210, 500, 1210, 550, 1105, 550);

  addBuilding("Lot6", true, 19, 1220, 500, 1325, 500, 1325, 550, 1220, 550);
  addBuilding("Lot7", true, 20, 1220, 420, 1325, 450, 1325, 480, 1220, 480);

  addBuilding("Residential1", false, 21, 170, 350, 615, 350, 615, 550, 170, 550);
  addBuilding("Residential2", false, 22, 615, 350, 1100, 500, 1100, 550, 615, 550);
}

/**
 * Helper function to create new building and add the building to GNWMap
 * @param id This is the id of the building
 * @param customizable Sets if the building is customizable by user or not
 * @param doorNode The node id of the door to the building
 * @param x1 This is the x-coordinate of the top-left corner of the building
 * @param y1 This is the y-coordinate of the top-left corner of the building
 * @param x2 This is the x-coordinate of the top-right corner of the building
 * @param y2 This is the y-coordinate of the top-righteft corner of the building
 * @param x3 This is the x-coordinate of the bottom-right corner of the building
 * @param y3 This is the y-coordinate of the bottom-right corner of the building
 * @param x4 This is the x-coordinate of the bottom-left corner of the building
 * @param y4 This is the y-coordinate of the bottom-left corner of the building
 */
void addBuilding(String id, Boolean customizable, int doorNodeId, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  HashMap<String, Coord> buildingCoords = new HashMap<String, Coord>();
  buildingCoords.put("topLeft", new Coord(x1, y1));
  buildingCoords.put("topRight", new Coord(x2, y2));
  buildingCoords.put("bottomRight", new Coord(x3, y3));
  buildingCoords.put("bottomLeft", new Coord(x4, y4));

  Building newBuilding = new Building(id, customizable, buildingCoords, doorNodeId);
  GNWMap.put(id, newBuilding);
}

/**
 * Creates GNWGraph with nodes and edges for path finding
 */
void createGNWGraph() {
  makeGraphFromFile(GNWGraph, "assets/graph.txt");
  pathFinder = new GraphSearch_Astar(GNWGraph, new AshCrowFlight(1.0f));
  usePathFinder(pathFinder);
  gNodes = GNWGraph.getNodeArray();
}

void usePathFinder(IGraphSearch pf){
  pf.search(0, 1, true);
  rNodes = pf.getRoute();
  exploredEdges = pf.getExaminedEdges();
}


void makeGraphFromFile(Graph g, String fname) {
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

void makeNode(String s, Graph g) {
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
 * Creates an edge(s) between 2 nodes.
 * @param s a line from the configuration file.
 * @param g the graph to add the edge.
 */
void makeEdge(String s, Graph g) {
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



//USED FOR DEBUGGING - prints x & y coordinate values of mouse click
void mouseClicked() {
  fill(0);
  ellipse(mouseX, mouseY, 2, 2);
  println("x: " + mouseX + "; y: " + mouseY);
}