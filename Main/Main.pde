import pathfinder.*; //<>//
import controlP5.*;

GNWPathFinder GNWPathFinder;
GNWMap GNWMap;
GNWInterface GNWInterface;

ArrayList<BuildingUse> buildingUses;

ArrayList<Building> artCultureBuildings;
ArrayList<Building> lightIndustrialBuildings;
ArrayList<Building> officesBuildings;
ArrayList<Building> residentalBuildings;
ArrayList<Building> retailBuildings;

int shiftX;
int shiftY;

//define the time selection parameter
String cur_time = "morning";

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
  GNWMap = new GNWMap();
  GNWInterface = new GNWInterface();
  GNWPathFinder = new GNWPathFinder();
  buildingUses = new ArrayList<BuildingUse>();
  setBuildingUses();

  artCultureBuildings = new ArrayList<Building>();
  lightIndustrialBuildings = new ArrayList<Building>();
  officesBuildings = new ArrayList<Building>();
  residentalBuildings = new ArrayList<Building>();
  retailBuildings = new ArrayList<Building>();

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
  GNWMap.drawFlow();
  popMatrix();

  //render buildingUseBoxes and SelectedBUIcon
  GNWInterface.render();
  popMatrix();
}

//update time 
void update_time()
{
  r1.getValue();
  if (r1.getValue() == 10)
  {
    cur_time = "morning";
  } else if (r1.getValue() == 14)
  {
    cur_time = "mid_afternoon";
  } else 
  {
    cur_time = null;
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
    //shiftX = constrain(shiftX, width-GNWMap.mapImage.width, 0);
  }
} 

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
  buildingUses.add(new BuildingUse("retail", "retail.png", #EA6C90, "offices"));
  buildingUses.add(new BuildingUse("artCulture", "artCulture.png", #AA96CC, "offices"));
  buildingUses.add(new BuildingUse("lightIndustrial", "lightIndustrial.png", #8ACE8A, "retail"));
  buildingUses.add(new BuildingUse("offices", "offices.png", #66D9E2, "retail"));
  buildingUses.add(new BuildingUse("residential", "residential.png", #F9D463, "artCulture"));

  GNWInterface.createBuildingUseBoxes();
}


//USED FOR DEBUGGING - prints x & y coordinate values of mouse click
//void mouseClicked() {
//mouseX = int(mouseX / scaleFactor);
//mouseY = int(mouseY / scaleFactor);

//println("x: " + (mouseX - shiftX) + "; y: " +  (mouseY - shiftY));
//}