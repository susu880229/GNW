import pathfinder.*; //<>// //<>//
import controlP5.*;
import java.util.Map;

GNWPathFinder GNWPathFinder;
GNWMap GNWMap;
GNWInterface GNWInterface;

ArrayList<BuildingUse> buildingUses;
<<<<<<< HEAD
ArrayList<UseFlow> use_flows;
ArrayList<Path> paths;
HashMap<String, ArrayList<Building>> use_buildings;
=======

ArrayList<Building> artCultureBuildings;
ArrayList<Building> lightIndustrialBuildings;
ArrayList<Building> officesBuildings;
ArrayList<Building> residentalBuildings;
ArrayList<Building> retailBuildings;

>>>>>>> master
int shiftX;
int shiftY;

//define the time selection parameter
<<<<<<< HEAD
int cur_time = 12;
=======
String cur_time = "morning";
float prevTime;
boolean timeChanged = false;
>>>>>>> master

//define the UI for radio button
ControlP5 cp5;
RadioButton r1;
<<<<<<< HEAD
//boolean UpdatePerson;
int pre_time;
int interval_time;
=======

//use 0.50 for laptops; 1 for tablet
float scaleFactor = .5;
//float scaleFactor = 1;

>>>>>>> master
void setup()
{
  //fullScreen();
  size(2134, 1601);
  shiftX = 0;
  shiftY = 0;
  use_flows = new ArrayList<UseFlow>();
  use_buildings = new HashMap<String, ArrayList<Building>>();
  paths = new ArrayList<Path>();
  GNWMap = new GNWMap(); //include initialize the use_buildings hashmap and the use_flows arraylist
  GNWInterface = new GNWInterface();
  GNWPathFinder = new GNWPathFinder(); // put all the edge data to paths ArrayList
  buildingUses = new ArrayList<BuildingUse>();
  setBuildingUses();
<<<<<<< HEAD
=======

  artCultureBuildings = new ArrayList<Building>();
  lightIndustrialBuildings = new ArrayList<Building>();
  officesBuildings = new ArrayList<Building>();
  residentalBuildings = new ArrayList<Building>();
  retailBuildings = new ArrayList<Building>();

>>>>>>> master
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
    .addItem("8AM", 8)
    .addItem("2PM", 12)
    ;
  pre_time = millis();
  interval_time = 1000;
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
<<<<<<< HEAD
  UpdateFlow();
  drawFlow();
=======



  if (GNWMap.isBuildingUseAdded || timeChanged)           //whenever a new building use is added or the time is changed, calculate the flow densities for all paths
  {
    GNWMap.isBuildingUseAdded = false;
    timeChanged = false;
    GNWMap.flowInit();
  }


  GNWMap.drawFlow();
>>>>>>> master
  popMatrix();

  //render buildingUseBoxes and SelectedBUIcon
  GNWInterface.render();
<<<<<<< HEAD
  
  
=======
  popMatrix();
>>>>>>> master
}

void drawFlow()
{
  for(Map.Entry buildingEntry : GNWMap.buildings.entrySet())
  {
    
    Building building = (Building)buildingEntry.getValue();
    
    if(building.persons.size() > 0)
    {
       building.run();
       
    }
    
  }
  
}
 void UpdateFlow() {
   //int interval = 1000;
   if( millis() > interval_time + pre_time)
   {
    pre_time = millis();
    for (Map.Entry buildingEntry : GNWMap.buildings.entrySet()) {
      Building building = (Building) buildingEntry.getValue();
      building.generatePerson();
    }
   
   }
  }


//update time 
void update_time()
{
<<<<<<< HEAD
  r1.getValue();
  if (r1.getValue() == 8)
  {
    interval_time = 300;
  } else if (r1.getValue() == 12)
=======
  float curTimeVal = r1.getValue();

  if (curTimeVal == 10)
  {
    cur_time = "morning";
  } else if (curTimeVal == 14)
>>>>>>> master
  {
    interval_time = 1000;
  } else 
  {
    interval_time = 1000;
  }

  if (curTimeVal != prevTime)
  {
    timeChanged = true;
  }

  prevTime = curTimeVal;
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
<<<<<<< HEAD
  
  //define five customize buildinguses
  addBuildingUses("Resident", "resident.png", color (0, 200, 0), true); //green
  addBuildingUses("Business", "office.png", color(138, 220, 255), true); //light blue
  addBuildingUses("Art and Culture", "recreation.png", color(255, 255, 0), true); //yellow 
  addBuildingUses("Light Industry", "light.png", color(181, 185, 181), true); // grey
  addBuildingUses("Retail", "retail.png", color(200, 0, 0), true); // red
  
  //fefine four not customize buildinguses
  addBuildingUses("Education", "education.png", color(0, 255, 230), false); // gree_blue
  addBuildingUses("Transit", "transit.png", color(0, 0, 200), false); //dark blue
  addBuildingUses("Park and Public", "park_public.png", color(147, 196, 125), false); //light green
  addBuildingUses("Neighborhood", "neighborhood.png", color(56, 118, 29), false); //dark green
  
=======
  buildingUses.add(new BuildingUse("retail", "retail.png", #EA6C90, "offices"));
  buildingUses.add(new BuildingUse("artCulture", "artCulture.png", #AA96CC, "offices"));
  buildingUses.add(new BuildingUse("lightIndustrial", "lightIndustrial.png", #8ACE8A, "retail"));
  buildingUses.add(new BuildingUse("offices", "offices.png", #66D9E2, "retail"));
  buildingUses.add(new BuildingUse("residential", "residential.png", #F9D463, "artCulture"));

>>>>>>> master
  GNWInterface.createBuildingUseBoxes();
}

void addBuildingUses(String name, String imgSrc, color colorId, boolean cust)
{
  BuildingUse build_use = new BuildingUse(name, imgSrc, colorId, cust);
  //buildingUses_hash.put(name, build_use);
  buildingUses.add(build_use);
  
}


//USED FOR DEBUGGING - prints x & y coordinate values of mouse click
//void mouseClicked() {
//mouseX = int(mouseX / scaleFactor);
//mouseY = int(mouseY / scaleFactor);

//println("x: " + (mouseX - shiftX) + "; y: " +  (mouseY - shiftY));
//}