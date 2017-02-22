import pathfinder.*;
import java.util.Map;
import controlP5.*;

GNWPathFinder GNWPathFinder;
HashMap<String, Building> GNWMap; //String is building id

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
  //fullScreen();
  size(1400, 768);
  GNWMap = new HashMap<String, Building>();
  createGNWMap();
  renderInitalBoxes();
  GNWPathFinder = new GNWPathFinder();
  icons = new ArrayList<Icon_DragDrop>();
  
  //create the radio button interface to change the time
  cp5 = new ControlP5(this);
  r1 = cp5.addRadioButton("radioButton")
         .setPosition(400,50)
         .setSize(40,20)
         .setColorForeground(color(120))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setItemsPerRow(5)
         .setSpacingColumn(50)
         .addItem("8AM", 10)
         .addItem("2PM", 14)
         ;
}

//update time 
void update_time()
{
  
  r1.getValue();
  if(r1.getValue() == 10)
  {
    cur_time = "morning";
  }
  else if(r1.getValue() == 14)
  {
    cur_time = "mid_afternoon";
  }
  else 
  {
    cur_time = null;
  }
  
}

/** 
 * Draws all the buildings in GNWMap
 */
void draw() {
  background(0);

  //walk through the GNWmap to render building
  for (Map.Entry GNWMapEntry : GNWMap.entrySet()) {
    Building building = (Building) GNWMapEntry.getValue();
    building.render();
  }
  drawIcons();

  //show node and edges for debugging purposes
  //GNWPathFinder.drawGraph();

  //TODO: use returned path and draw actual animation
  //ArrayList<GraphNode> path = GNWPathFinder.findPath(0, 2);
  //GNWPathFinder.drawRoute(path);
}

void renderInitalBoxes() {
  //create four boxes objects 
  rest_box = new Icon_Initial(rest_red, rest_x, rest_y, box_w, box_h, "Restaurant");
  resi_box = new Icon_Initial(resi_blue, resi_x, resi_y, box_w, box_h, "Residential");
  office_box = new Icon_Initial(office_green, office_x, office_y, box_w, box_h, "Office");
  recre_box = new Icon_Initial(recre_yellow, recre_x, recre_y, box_w, box_h, "Recreation");
}

void drawIcons() 
{
  rectMode(CENTER);

  //render boxes
  rest_box.render();
  resi_box.render();
  office_box.render();
  recre_box.render();

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
  //update the icon position based on the mouse
  if (!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
      icons.get(i).mouseDragged();
    }
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
  addBuilding("City", true, 0, 220, 140, 265, 150, 252, 200, 205, 190);
  addBuilding("Park", false, 1, 205, 195, 252, 205, 235, 275, 187, 265);
  addBuilding("Stn", true, 2, 185, 270, 235, 280, 225, 330, 170, 330);

  addBuilding("Equinox", true, 3, 264, 175, 328, 190, 323, 215, 258, 200);
  addBuilding("521", true, 4, 250, 235, 290, 245, 280, 282, 240, 275);  
  addBuilding("515", true, 5, 240, 280, 295, 290, 295, 330, 230, 330);

  addBuilding("EmilyCarr", false, 6, 305, 230, 475, 230, 475, 280, 305, 280); 
  addBuilding("Plaza", false, 7, 300, 290, 360, 290, 360, 330, 300, 330);
  addBuilding("PCI", true, 8, 365, 290, 485, 290, 485, 330, 365, 330);

  addBuilding("CDM1", false, 9, 490, 235, 540, 235, 540, 305, 490, 305);
  addBuilding("CDM2", true, 10, 545, 235, 605, 258, 605, 285, 545, 285);
  addBuilding("CDM3", false, 11, 545, 290, 605, 290, 605, 330, 545, 330); 

  addBuilding("Lot1", true, 12, 610, 258, 760, 300, 745, 370, 610, 330); 
  addBuilding("Lot2", true, 13, 765, 300, 825, 320, 845, 400, 750, 372);
  addBuilding("Lot3", true, 14, 830, 320, 920, 348, 900, 417, 850, 402);
  addBuilding("Lot4", true, 15, 925, 348, 1015, 375, 995, 445, 905, 418);
  addBuilding("Mec", false, 16, 1020, 377, 1100, 400, 1100, 478, 1000, 447);

  addBuilding("Lot5", true, 17, 1105, 400, 1210, 420, 1210, 480, 1105, 480);
  addBuilding("Lot7", true, 19, 1220, 420, 1325, 450, 1325, 480, 1220, 480);
}

//USED FOR DEBUGGING - prints x & y coordinate values of mouse click
//void mouseClicked() {
//  fill(0);
//  ellipse(mouseX, mouseY, 2, 2);
//  println("x: " + mouseX + "; y: " + mouseY);
//}