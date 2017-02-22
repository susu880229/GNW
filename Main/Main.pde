import pathfinder.*; //<>//
import java.util.Map;
import controlP5.*;

GNWPathFinder GNWPathFinder;
HashMap<String, Building> GNWMap; //String is building id

PImage mapImage;
int x;

//define the box parameters
int rest_x = 100;
int rest_y = 50;
int resi_x = 170;
int resi_y = 50;
int office_x = 240;
int office_y = 50;
int recre_x = 310;
int recre_y = 50;
int box_w = 50;
int box_h = 50;
color rest_red = color (200, 0, 0);
color resi_blue = color (0, 0, 200);
color office_green = color(0, 200, 0);
color recre_yellow = color(200, 200, 0);

Icon_Initial rest_box;
Icon_Initial resi_box;
Icon_Initial office_box;
Icon_Initial recre_box;
String choice;

//define icon
ArrayList<Icon_DragDrop> icons;
int icon_w = 30;
int icon_h = 30;

//define the time selection parameter
String cur_time = "morning";
//String pre_time = "morning";
//boolean time_change = false;
//define the UI for radio button
ControlP5 cp5;
RadioButton r1;


void setup()
{
  fullScreen();
  mapImage = loadImage("map.png");

  GNWMap = new HashMap<String, Building>();
  createGNWMap();
  GNWPathFinder = new GNWPathFinder();
  icons = new ArrayList<Icon_DragDrop>();

  //create four boxes objects 
  rest_box = new Icon_Initial(rest_red, rest_x, rest_y, box_w, box_h, "Restaurant");
  resi_box = new Icon_Initial(resi_blue, resi_x, resi_y, box_w, box_h, "Residential");
  office_box = new Icon_Initial(office_green, office_x, office_y, box_w, box_h, "Office");
  recre_box = new Icon_Initial(recre_yellow, recre_x, recre_y, box_w, box_h, "Recreation");

  //create the radio button interface to change the time
  cp5 = new ControlP5(this);
  r1 = cp5.addRadioButton("radioButton")
    .setPosition(400, 50)
    .setSize(40, 20)
    .setColorForeground(color(120))
    .setColorActive(color(200))
    .setColorLabel(color(0))
    .setItemsPerRow(5)
    .setSpacingColumn(50)
    .addItem("8AM", 10)
    .addItem("2PM", 14)
    ;
}

/** 
 * Draws all the buildings in GNWMap
 */
void draw() {
  background(255);
  renderInitalBoxes();


  translate(x, 0);

  //walk through the GNWmap to render building
  for (Map.Entry GNWMapEntry : GNWMap.entrySet()) {
    Building building = (Building) GNWMapEntry.getValue();
    building.render();
  }

  image(mapImage, 0, 0);
  //show node and edges for debugging purposes
  //GNWPathFinder.drawGraph();

  drawIcons();
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


void renderInitalBoxes() {
  //render boxes
  rest_box.render();
  resi_box.render();
  office_box.render();
  recre_box.render();
}

void drawIcons() 
{
  rectMode(CENTER);
  //detect the mouse 
  rest_box.detect();
  resi_box.detect();
  office_box.detect();
  recre_box.detect();

  if (rest_box.mouse_detect)
  {
    choice = "restaurant";
  } else if (resi_box.mouse_detect)
  {
    choice = "resident";
  } else if (recre_box.mouse_detect)
  {
    choice = "recreation";
  } else if (office_box.mouse_detect)
  {
    choice = "office";
  } else 
  {
    choice = null;
  }


  //render the icon and detect the mouse within the icon
  if (!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
      icons.get(i).update();
    }
  }
  update_time();
  //flow rendering


  for (Map.Entry GNWMapEntry : GNWMap.entrySet()) 
  {
    Building building = (Building) GNWMapEntry.getValue();
    building.flow_generate();
  }
}

void mousePressed()
{
  //mouse are on the box area to generate icon 
  if (choice != null)
  {
    if (choice == "restaurant")
    {
      icon_generate("restaurant.png", rest_x, rest_y + 50, icon_w, icon_h);
    } else if (choice == "resident")
    {
      icon_generate("resident.png", resi_x, resi_y + 50, icon_w, icon_h);
    } else if (choice == "recreation")
    {
      icon_generate("recreation.png", recre_x, recre_y + 50, icon_w, icon_h);
    } else if (choice == "office")
    {
      icon_generate("office.png", office_x, office_y + 50, icon_w, icon_h);
    }
  }

  //mouse is outside the box, if it is within icon, lock the icon and get the initial distance between mouse and its position
  else 
  {
    if (!icons.isEmpty())
    {
      for (int i = 0; i < icons.size(); i++)
      {
        icons.get(i).mousePressed();
      }
    }
  }
}

void mouseDragged()
{
  boolean mouseOnIcon = false;

  //update the icon position based on the mouse
  if (!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
      if (icons.get(i).isMouseOnIcon()) {
        icons.get(i).mouseDragged();
        mouseOnIcon = true;
      }
    }
  }

  if (!mouseOnIcon) {
    x = x - (pmouseX - mouseX);
    x = constrain(x, width-mapImage.width, 0);
  }
}

void mouseReleased()
{
  //unlock the icon
  if (!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
      Icon_DragDrop icon = icons.get(i);
      icon.mouseReleased();
    }
  }
}

//create icon object 
void icon_generate(String icon_name, int icon_x, int icon_y, int icon_w, int icon_h )
{
  Icon_DragDrop icon = new Icon_DragDrop(icon_name, icon_x, icon_y, icon_w, icon_h);
  icons.add(icon);
  icon.load();
}


//add building and name to hash GNWmap
void addBuilding(String name, Boolean c, int doorNodeId, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) 
{
  Building newBuilding = new Building(name, c, doorNodeId, x1, y1, x2, y2, x3, y3, x4, y4);
  GNWMap.put(name, newBuilding);
}

/** 
 * Creates GNWMap with all the buildings and lots
 * Buildings/lots are added to from left to right and top to bottom
 */
void createGNWMap() 
{  
  addBuilding("Lot5", true, 64, 272, 147, 354, 153, 347, 247, 268, 248);
  addBuilding("Park", false, 5, 267, 302, 350, 298, 341, 464, 271, 465);
  addBuilding("Lot7", true, 7, 265, 519, 342, 520, 360, 620, 276, 641);

  addBuilding("Lot4", true, 17, 394, 159, 586, 162, 584, 212, 400, 213);
  addBuilding("521", true, 14, 379, 364, 476, 367, 473, 463, 382, 466);  
  addBuilding("515", true, 12, 376, 533, 489, 522, 513, 580, 382, 603);

  addBuilding("EmilyCarr", false, 28, 535, 352, 924, 255, 951, 344, 565, 443); 
  addBuilding("Plaza", false, 22, 531, 517, 643, 491, 658, 546, 551, 573);
  addBuilding("569", false, 26, 678, 485, 1075, 386, 1091, 434, 700, 539);

  addBuilding("CDM1", false, 34, 1115, 177, 1235, 146, 1283, 336, 1167, 371);
  addBuilding("1933", true, 38, 1273, 147, 1406, 136, 1428, 225, 1297, 258);
  addBuilding("CDM2", false, 41, 1304, 312, 1444, 284, 1463, 352, 1314, 366); 

  addBuilding("701", true, 44, 1541, 210, 2000, 210, 2023, 357, 1575, 355); 
  addBuilding("1980", true, 46, 2117, 155, 2275, 150, 2412, 380, 2161, 368);
  addBuilding("887", true, 48, 2438, 157, 2655, 178, 2656, 381, 2578, 385);
  addBuilding("901", true, 50, 2701, 184, 2937, 210, 2924, 395, 2704, 386);
  addBuilding("Mec", false, 52, 2983, 217, 3163, 225, 3211, 404, 2977, 401);

  addBuilding("Shaw", true, 55, 3299, 225, 3595, 224, 3623, 326, 3346, 398);
  addBuilding("NaturesPath", true, 59, 3729, 218, 4022, 200, 4033, 237, 3754, 300);
}

//USED FOR DEBUGGING - prints x & y coordinate values of mouse click
//void mouseClicked() {
//  fill(0);
//  ellipse(mouseX, mouseY, 2, 2);
//  println("x: " + mouseX + "; y: " + mouseY);
//}