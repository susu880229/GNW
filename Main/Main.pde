import pathfinder.*; //<>// //<>// //<>//
import controlP5.*;
import java.util.Map;

GNWPathFinder GNWPathFinder;
GNWMap GNWMap;
GNWInterface GNWInterface;
ArrayList<BuildingUse> buildingUses;
//ArrayList<UseFlow> use_flows;
HashMap<String, ArrayList<Building>> use_buildings;
HashMap<Integer, ArrayList<UseFlow>> use_flows;
int shiftX;
int shiftY;
//define the time selection parameter
int cur_time = 12;
int pre_time = -1;
boolean timeChanged = false;
//define the UI for radio button
ControlP5 cp5;
RadioButton r1;
//use 0.50 for laptops; 1 for tablet
float scaleFactor = .5;
//float scaleFactor = 1;


void setup()
{
  //fullScreen();
  size(2134, 1601);
  shiftX = 0;
  shiftY = 0;
  use_flows = new HashMap<Integer, ArrayList<UseFlow>>();
  use_buildings = new HashMap<String, ArrayList<Building>>();
  GNWMap = new GNWMap(); //include initialize the use_buildings hashmap and the use_flows hashmap
  GNWInterface = new GNWInterface();
  GNWPathFinder = new GNWPathFinder(); // put all the edge data to paths ArrayList
  buildingUses = new ArrayList<BuildingUse>();
  setBuildingUses();
  //create the radio button interface to change the time
  cp5 = new ControlP5(this);
  r1 = cp5.addRadioButton("radioButton")
    .setPosition(100 * scaleFactor, 1300 * scaleFactor)
    .setSize(int(scaleFactor* 100), int(scaleFactor * 50))
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
  if (GNWMap.isBuildingUseAdded || timeChanged == true )           //whenever a new building use is added or the time is changed, calculate the flow densities for all paths
  {
    GNWMap.isBuildingUseAdded = false;
    timeChanged = false;
    GNWMap.flowInit();
  }
  GNWMap.drawFlow();
  popMatrix();
  //render buildingUseBoxes and SelectedBUIcon
  GNWInterface.render();
  popMatrix();
  System.out.println(timeChanged);
  
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

void mousePressed()
{

  mouseX = int(mouseX / scaleFactor);
  mouseY = int(mouseY / scaleFactor);

  if (!isOnMap()) {
    GNWInterface.selectBuildingUse();
  }
}

void mouseDragged()
{
  //differiate between icon move and map move
  if (GNWInterface.selectedBUIcon != null) {
    pmouseX = int(pmouseX / scaleFactor);
    mouseX = int(mouseX / scaleFactor);
    mouseY = int(mouseY / scaleFactor);

    GNWInterface.update();
  } else if (isOnMap()) {
    shiftX = shiftX - (pmouseX - mouseX);
    shiftX = constrain(shiftX, width-GNWMap.mapImage.width, 0);
  }
} 

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
  //remove the icon after release the mouse
  GNWInterface.clearSelected();
}

/**
 * Checks if mouse position is on map
 * TODO: update to actual pixel. Currently assuming first half of app is map
 */
boolean isOnMap()
{
  return mouseY< height/2;
}

void setBuildingUses()
{

  buildingUses.add(new BuildingUse("Retail", "retail.png", #EA6C90));
  buildingUses.add(new BuildingUse("Art and Culture", "artCulture.png", #AA96CC));
  buildingUses.add(new BuildingUse("Light Industry", "lightIndustrial.png", #8ACE8A));
  buildingUses.add(new BuildingUse("Business", "offices.png", #66D9E2));
  buildingUses.add(new BuildingUse("Resident", "residential.png", #F9D463));


  GNWInterface.createBuildingUseBoxes();
}


//USED FOR DEBUGGING - prints x & y coordinate values of mouse click
//void mouseClicked() {
//mouseX = int(mouseX / scaleFactor);
//mouseY = int(mouseY / scaleFactor);

//println("x: " + (mouseX - shiftX) + "; y: " +  (mouseY - shiftY));
//}