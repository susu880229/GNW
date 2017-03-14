import pathfinder.*;  //<>//
import controlP5.*;
import java.util.Map;

//FOR OUTPUT OF GRAPH NODE COORDINATES
//PrintWriter outputPathCoordinates;
//int nodeCounter = 0;

GNWPathFinder GNWPathFinder;
GNWMap GNWMap;
GNWInterface GNWInterface;

ArrayList<BuildingUse> buildingUses;
HashMap<String, ArrayList<Building>> use_buildings;
HashMap<Integer, ArrayList<UseFlow>> use_flows;

//transformations
int shiftX;
int shiftY;
float scaleFactor;

//define the time selection parameter
int cur_time = 12;
int pre_time = -1;
boolean timeChanged = false;
//define the UI for radio button
ControlP5 cp5;
RadioButton r1;

void setup()
{
  //FOR OUTPUT OF GRAPH NODE COORDINATES
  //outputPathCoordinates = createWriter("positions.txt"); 

  fullScreen();

  shiftX = 0;
  shiftY = 0;
  use_flows = new HashMap<Integer, ArrayList<UseFlow>>();
  use_buildings = new HashMap<String, ArrayList<Building>>();
  GNWMap = new GNWMap(); //include initialize the use_buildings hashmap and the use_flows hashmap
  GNWInterface = new GNWInterface();
  GNWPathFinder = new GNWPathFinder(); // put all the edge data to paths ArrayList
  buildingUses = new ArrayList<BuildingUse>();
  setBuildingUses();

  scaleFactor = height/(float)GNWInterface.interfaceImage.height;

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
    .addItem("12PM", 12)
    .addItem("11PM", 23)
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
  //GNWPathFinder.drawGraph();
  update_time();
  if (GNWMap.isBuildingUseChanged || timeChanged == true )           //whenever a new building use is added or the time is changed, calculate the flow densities for all paths
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

//update time and time change does not work
void update_time()
{
  cur_time = (int)r1.getValue();
  if (cur_time != pre_time)
  {
    timeChanged = true;
    pre_time = cur_time;
  }
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
      //add use to building as well as add building to use arraylist 
      GNWMap.assignBuildingUse(GNWInterface.selectedBUIcon.buildingUse);
      //UpdateFlow();
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

  buildingUses.add(new BuildingUse("Retail", "retail.png", #EA6C90));
  buildingUses.add(new BuildingUse("Art and Culture", "artCulture.png", #AA96CC));
  buildingUses.add(new BuildingUse("Light Industry", "lightIndustrial.png", #8ACE8A));
  buildingUses.add(new BuildingUse("Business", "offices.png", #66D9E2));
  buildingUses.add(new BuildingUse("Resident", "residential.png", #F9D463));

  use_buildings.put("Retail", new ArrayList<Building>());
  use_buildings.put("Art and Culture", new ArrayList<Building>());
  use_buildings.put("Light Industry", new ArrayList<Building>());
  use_buildings.put("Business", new ArrayList<Building>());
  use_buildings.put("Resident", new ArrayList<Building>());

  GNWInterface.createBuildingUseBoxes();
}


////USED FOR DEBUGGING - prints x & y coordinate values of mouse click
//void mouseClicked() {
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