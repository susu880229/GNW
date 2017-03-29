import pathfinder.*; //<>//
import java.util.Map;

GNWPathFinder GNWPathFinder;
GNWMap GNWMap;
GNWInterface GNWInterface;

HashMap<String, BuildingUse> buildingUses;
HashMap<String, ArrayList<Building>> use_buildings;
HashMap<Integer, ArrayList<UseFlow>> use_flows;

//transformations
int shiftX = 0;
int shiftY = 0;
float scaleFactor;

//define the time selection parameter
int cur_time;
int pre_time;
boolean timeChanged;

//images for the drop feedback
PImage glowImage_515;
PImage glowImage_521;
PImage glowImage_701;
PImage glowImage_887;
PImage glowImage_901;
PImage glowImage_1933;
PImage glowImage_1980;
PImage glowImage_lot4;
PImage glowImage_lot5;
PImage glowImage_lot7;
PImage glowImage_naturesPath;
PImage glowImage_shaw;

boolean start;
PImage instruction;
//define the PCIMode outside of setup to set it true
Boolean PCIMode = false;

void setup()
{
  fullScreen();
  //frameRate(20);

  cur_time = 0;
  pre_time = -1;
  timeChanged = false;

  use_flows = new HashMap<Integer, ArrayList<UseFlow>>();
  use_buildings = new HashMap<String, ArrayList<Building>>();
  buildingUses = new HashMap<String, BuildingUse>();

  GNWMap = new GNWMap(); //include initialize the use_buildings hashmap and the use_flows hashmap
  setBuildingUses();
  GNWInterface = new GNWInterface();
  GNWPathFinder = new GNWPathFinder(); 
  scaleFactor = height/(float)GNWInterface.interfaceImage.height;

  loadDropFeedbackImages();
  start = true;
  instruction = loadImage("instruction.png");
}

/** 
 * 
 */
void draw() {
  pushMatrix();
  scale(scaleFactor);

  pushMatrix();
  translate(shiftX, shiftY);
  GNWMap.render();
  //GNWPathFinder.drawGraph();
  update_time();

  if (GNWMap.isBuildingUseChanged || timeChanged)           //whenever a new building use is added or the time is changed, calculate the flow densities for all paths
  {
    GNWMap.flowInit(timeChanged);
    GNWMap.isBuildingUseChanged = false;
    timeChanged = false;
  }
  GNWInterface.dropFeedback(isOnMap());
  GNWMap.drawFlow();
  GNWMap.showSelectedBuilding(); //draw the tooltip and place holder
  popMatrix();
  //render buildingUseBoxes and SelectedBUIcon
  GNWInterface.render();

  if (!start) 
  {
    image(instruction, 0, 0);
  }

  popMatrix();
  println(cur_time);
}

void update_time()
{

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
 * First case: select building use or pull out the detailed information of each use if mouse pressed onto interface
 * Second case: select building to show the uses or select use to delete if mouse pressed onto map 
 **/
void mousePressed()
{
  scaleMouse();
  if (start)
  {
    GNWMap.show = false; //turn off the place holder
    if (!isOnMap()) {
      GNWMap.clearSelectedBuilding();
      GNWInterface.selectInterface();
    } else {
      try 
      {
        GNWMap.selectTooltip();
      } 
      catch(Exception e) 
      {
        GNWMap.selectBuilding();   
        GNWInterface.clearSelectedBox();
      }
    }
  } else
  {
    GNWInterface.close_instruction();
  }
}


/**
 * Handles how to interpret different mouse drags
 * First case: moving building use icon - it updates raw interface values, so need to scaleMouse() first
 * Second case: moving the time slider dot - it updates raw interface values, so need to scaleMouse() first
 * Third case: moving map - scaled map is being updated, so don't need to scaleMouse(); however, isOnMap() checks raw y values, so need to revert mouseY
 **/
void mouseDragged()
{
  scaleMouse();
  //avoid the user move the map to impact the close instruction button to work
  if (start)
  {
    if (GNWInterface.selectedBUIcon != null)
    {
      GNWInterface.update();
    } else if (GNWInterface.selectedBUIcon == null && isOnTimeSlider()) 
    {
      GNWInterface.time_bar.mouseDragged();
    } else if (isOnMap()) 
    {
      mouseX = int(mouseX * scaleFactor);
      pmouseX = int(pmouseX * scaleFactor);
      pmouseY = int(pmouseY * scaleFactor); 
      shiftX = shiftX - (pmouseX - mouseX);
      shiftX = constrain(shiftX, GNWInterface.interfaceImage.width - GNWMap.mapImage.width, 0);
    }
  }
}

/**
 * Handles what happens when user releases icon; 
 * If dropped onto a building, handle any horizontal scroll and add building use to building and building to use
 * Icon is always removed from sketch wherever icon is released
 */
void mouseReleased()
{ 
  if (GNWInterface.selectedBUIcon != null && isOnMap()) {
    try {
      //add use to building as well as add building to use arraylist 
      GNWMap.assignBuildingUse(GNWInterface.selectedBUIcon.buildingUse);
    } 
    catch(Exception e) {
      GNWInterface.clearSelected();
    }
  }
  GNWInterface.clearSelected();
}

/**
 * Checks if mouse position is on map / drag and drop / time bar/ setting ; this checks raw coordinates (i.e. when scaleFactor is 1)
 */
boolean isOnMap()
{
  int midY = 913;
  return mouseY < midY;
}

boolean isOnTimeSlider()
{
  int time_top = 1280;
  int time_bottom = 1450;
  return mouseY > time_top && mouseY < time_bottom;
}

void setBuildingUses()
{
  buildingUses.put("Retail", new BuildingUse("Retail", "retail.png", #EA6C90));
  buildingUses.put("Art and Culture", new BuildingUse("Art and Culture", "artCulture.png", #AA96CC));
  buildingUses.put("Light Industry", new BuildingUse("Light Industry", "lightIndustrial.png", #F9D463));
  buildingUses.put("Office", new BuildingUse("Office", "offices.png", #66D9E2));
  buildingUses.put("Resident", new BuildingUse("Resident", "residential.png", #8ACE8A));

  buildingUses.put("Transit", new BuildingUse("Transit", "", 0));
  buildingUses.put("Neighborhood", new BuildingUse("Neighborhood", "", 0));
  buildingUses.put("Park and Public", new BuildingUse("Park and Public", "", 0));
  buildingUses.put("Education", new BuildingUse("Education", "", 0));
  buildingUses.put("Student Resident", new BuildingUse("Student Resident", "", 0));

  use_buildings.put("Retail", new ArrayList<Building>());
  use_buildings.put("Art and Culture", new ArrayList<Building>());
  use_buildings.put("Light Industry", new ArrayList<Building>());
  use_buildings.put("Office", new ArrayList<Building>());
  use_buildings.put("Resident", new ArrayList<Building>());

  use_buildings.put("Transit", new ArrayList<Building>());
  use_buildings.put("Neighborhood", new ArrayList<Building>());
  use_buildings.put("Park and Public", new ArrayList<Building>());
  use_buildings.put("Education", new ArrayList<Building>());
  use_buildings.put("Student Resident", new ArrayList<Building>());

  GNWMap.addDefaultBuildingUses();
}

void loadDropFeedbackImages()
{
  glowImage_515 = loadImage("highlight_515.png");
  glowImage_521 = loadImage("highlight_521.png");
  glowImage_701 = loadImage("highlight_701.png");
  glowImage_887 = loadImage("highlight_887.png");
  glowImage_901 = loadImage("highlight_901.png");
  glowImage_1933 = loadImage("highlight_1933.png");
  glowImage_1980 = loadImage("highlight_1980.png");
  glowImage_lot4 = loadImage("highlight_lot4.png");
  glowImage_lot5 = loadImage("highlight_lot5.png");
  glowImage_lot7 = loadImage("highlight_lot7.png");
  glowImage_naturesPath = loadImage("highlight_naturesPath.png");
  glowImage_shaw = loadImage("highlight_shaw.png");
}


////USED FOR DEBUGGING - prints x & y coordinate values of mouse click
//void mouseClicked() {
//  println("x: " + (mouseX - shiftX) + "; y: " +  (mouseY - shiftY));
//}