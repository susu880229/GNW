import pathfinder.*; //<>//
import controlP5.*;
import java.util.Map;

//FOR OUTPUT OF GRAPH NODE COORDINATES
//PrintWriter outputPathCoordinates;
//int nodeCounter = 0;
//-----------------------------------

GNWPathFinder GNWPathFinder;
GNWMap GNWMap;
GNWInterface GNWInterface;

ArrayList<BuildingUse> buildingUses;

HashMap<String, Building> artCultureBuildings;
HashMap<String, Building> lightIndustrialBuildings;
HashMap<String, Building> officesBuildings;
HashMap<String, Building> residentalBuildings;
HashMap<String, Building> retailBuildings;

int shiftX;
int shiftY;

//define the time selection parameter
String cur_time = "morning";
float prevTime;
boolean timeChanged = false;

//define the UI for radio button
ControlP5 cp5;
RadioButton r1;

//use 0.50 for laptops; 1 for tablet
float scaleFactor = .5;
//float scaleFactor = 1;

void setup()
{
  //FOR OUTPUT OF GRAPH NODE COORDINATES
  //outputPathCoordinates = createWriter("positions.txt"); 

  //fullScreen();
  size(2048, 1536);

  shiftX = 0;
  shiftY = 0;
  GNWMap = new GNWMap();
  GNWInterface = new GNWInterface();
  GNWPathFinder = new GNWPathFinder();
  buildingUses = new ArrayList<BuildingUse>();
  setBuildingUses();

  artCultureBuildings = new HashMap<String, Building>();
  lightIndustrialBuildings = new HashMap<String, Building>();
  officesBuildings = new HashMap<String, Building>();
  residentalBuildings = new HashMap<String, Building>();
  retailBuildings = new HashMap<String, Building>();

  //create the radio button interface to change the time
  cp5 = new ControlP5(this);
  r1 = cp5.addRadioButton("radioButton")
    .setPosition(100 * scaleFactor, 1300 * scaleFactor)
    .setSize(int(scaleFactor* 200), int(scaleFactor * 100))
    .setColorForeground(color(120))
    .setColorActive(color(200))
    .setColorLabel(color(0))
    .setItemsPerRow(5)
    .setSpacingColumn(70)
    .addItem("8AM", 10)
    .addItem("2PM", 14)
    ;
}

/** 
 * 
 */
void draw() {
  background(255);

  pushMatrix();
  scale(scaleFactor);

  pushMatrix();
  translate(shiftX, shiftY);
  GNWMap.render();
  //GNWPathFinder.drawGraph();  //show node and edges for debugging purposes
  update_time();

  if (GNWMap.isBuildingUseChanged || timeChanged)           //whenever a new building use is added or the time is changed, calculate the flow densities for all paths
  {
    GNWMap.isBuildingUseChanged = false;
    timeChanged = false;
    GNWMap.flowInit();
  }

  GNWMap.drawFlow();
  GNWMap.showSelectedBuilding();
  popMatrix();

  //render buildingUseBoxes and SelectedBUIcon
  GNWInterface.render();
  popMatrix();
}

//update time 
void update_time()
{
  float curTimeVal = r1.getValue();

  if (curTimeVal == 10)
  {
    cur_time = "morning";
  } else if (curTimeVal == 14)
  {
    cur_time = "mid_afternoon";
  } else 
  {
    cur_time = null;
  }

  if (curTimeVal != prevTime)
  {
    timeChanged = true;
  }

  prevTime = curTimeVal;
}

/**
 * Calculates mouse value if it was on original size sketch (i.e. if scaleFactor = 1)
 */
void scaleMouse() {
  pmouseX = int(pmouseX / scaleFactor);
  pmouseY = int(pmouseY / scaleFactor);
  mouseX = int(mouseX / scaleFactor);
  mouseY = int(mouseY / scaleFactor);
}

/**
 * Handles how to interpret mouse presses; both cases below checks raw values, so need to scale mouse values back to real size before checking
 * First case: select building use if mouse pressed onto interface
 * Second case: select building if mouse pressed onto map 
 **/
void mousePressed()
{
  scaleMouse();
  if (!isOnMap()) {
    GNWInterface.selectBuildingUse();
    GNWMap.clearSelectedBuilding();
  } else {
    try {
      GNWMap.selectTooltip();
    } 
    catch(Exception e) {
      println(e);
      GNWMap.selectBuilding();
    }
  }
}


/**
 * Handles how to interpret different mouse drags
 * First case: moving building use icon - it updates raw interface values, so need to scaleMouse() first
 * Second case: moving map - scaled map is being updated, so don't need to scaleMouse(); however, isOnMap() checks raw y values, so need to revert mouseY
 **/
void mouseDragged()
{
  if (GNWInterface.selectedBUIcon != null) {
    scaleMouse();
    GNWInterface.update();
  } else {
    mouseY = int(mouseY / scaleFactor);
    if (isOnMap()) {
      shiftX = shiftX - (pmouseX - mouseX);
      shiftX = constrain(shiftX, GNWInterface.interfaceImage.width - GNWMap.mapImage.width, 0);
    }
  }
} 

/**
 * Handles what happens when user releases icon; 
 * If dropped onto a building, handle any horizontal stroll and add building use to building
 * Icon is always removed from sketch wherever icon is released
 */
void mouseReleased()
{ 
  if (GNWInterface.selectedBUIcon != null && isOnMap()) {
    try {
      GNWMap.assignBuildingUse(GNWInterface.selectedBUIcon.buildingUse);
    } 
    catch(Exception e) {
      GNWInterface.clearSelected();
    }
  }
  GNWInterface.clearSelected();
}

/**
 * Checks if mouse position is on map; this checks raw coordinates (i.e. when scaleFactor is 1)
 */
boolean isOnMap()
{
  int midY = 913;
  return mouseY < midY;
}

void setBuildingUses()
{
  buildingUses.add(new BuildingUse("retail", "retail.png", #EA6C90, "offices"));
  buildingUses.add(new BuildingUse("artCulture", "artCulture.png", #AA96CC, "offices"));
  buildingUses.add(new BuildingUse("lightIndustrial", "lightIndustrial.png", #8ACE8A, "retail"));
  buildingUses.add(new BuildingUse("offices", "offices.png", #66D9E2, "retail"));
  buildingUses.add(new BuildingUse("residential", "residential.png", #F9D463, "artCulture"));

  GNWInterface.createBuildingUseBoxes();
}


////USED FOR DEBUGGING - prints x & y coordinate values of mouse click
//void mouseClicked() {
//  scaleMouse();
//  println("x: " + (mouseX - shiftX) + "; y: " +  (mouseY - shiftY));
//}

////FOR OUTPUT OF GRAPH NODE COORDINATES
//void mouseClicked() {
//  nodeCounter++;
//  mouseX = int(mouseX / scaleFactor);
//  mouseY = int(mouseY / scaleFactor);

//  outputPathCoordinates.println(nodeCounter + " " + (mouseX - shiftX) + " " + (mouseY - shiftY));
//}

//void keyPressed() {
//  outputPathCoordinates.flush(); // Writes the remaining data to the file
//  outputPathCoordinates.close(); // Finishes the file
//  exit(); // Stops the program
//}