import java.util.Map;
import java.awt.Polygon; 

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
//define buildings
/*
Building buildingA;
Building buildingB;
int buildingA_x = 362;
int buildingA_y = 384;
int buildingB_x = 662;
int buildingB_y = 384;
int building_w = 100;
int building_h = 100;
*/
//define the person parameter
//ArrayList<Person> pAs;
//ArrayList<Person> pBs;
//define the map
HashMap<String, Building> GNWMap; 

void setup()
{
  //size(1024, 768);
  size(1400, 700);
  GNWMap = new HashMap<String, Building>();
  createGNWMap();
  //buildingA = new Building("buildingA", buildingA_x, buildingA_y, building_w, building_h);
  //buildingB = new Building("buildingB", buildingB_x, buildingB_y, building_w, building_h);
  //buildingA.addPerson();
  
  //create four boxes objects 
  rest_box = new Icon_Initial(rest_red, rest_x, rest_y, box_w, box_h, "Restaurant");
  resi_box = new Icon_Initial(resi_blue, resi_x, resi_y, box_w, box_h, "Residential");
  office_box = new Icon_Initial(office_green, office_x, office_y, box_w, box_h, "Office");
  recre_box = new Icon_Initial(recre_yellow, recre_x, recre_y, box_w, box_h, "Recreation");
  
  icons = new ArrayList<Icon_DragDrop>();
 
}

void draw() {
  background(0);
  //buildingA.render();
  //buildingB.render();
  
  //walk through the GNWmap to render building
  for (Map.Entry GNWMapEntry : GNWMap.entrySet()) {
    Building building = (Building) GNWMapEntry.getValue();
    building.render();
   
  }

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
  
  if(rest_box.mouse_detect)
  {
    choice = "restaurant";
  }
  else if(resi_box.mouse_detect)
  {
    choice = "resident";
  }
  else if(recre_box.mouse_detect)
  {
    choice = "recreation";
  }
  else if(office_box.mouse_detect)
  {
    choice = "office";
  }
  else 
  {
    choice = null;
  }
  //System.out.println(choice);
  
  //render the icon and detect the mouse within the icon
  if(!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
    icons.get(i).update();
    }
    
  }
 
  //System.out.println("buildingA:" + buildingA.iconDrags.size() + "," + "buildingB:" + buildingB.iconDrags.size());
  
  //flow_generate();
 
  //System.out.println("EmilyCarr" + GNWMap.get("EmilyCarr").iconDrags.size() + "CDM1" + GNWMap.get("CDM1").iconDrags.size());
  //System.out.println(GNWMap.get("521"));
  for (Map.Entry GNWMapEntry : GNWMap.entrySet()) {
    Building building = (Building) GNWMapEntry.getValue();
    //building.render();
    building.flow_generate();
  }
}

void mousePressed()
{
  
  //mouse are on the box area to generate icon 
  if (choice != null)
  {
    if(choice == "restaurant")
    {
      icon_generate("restaurant.png", rest_x, rest_y + 50, icon_w, icon_h);
    }
    
    else if(choice == "resident")
    {
      icon_generate("resident.png", resi_x, resi_y + 50, icon_w, icon_h);
    }
    
    else if(choice == "recreation")
    {
      icon_generate("recreation.png", recre_x, recre_y + 50, icon_w, icon_h);
    }
    
    else if(choice == "office")
    {
      icon_generate("office.png", office_x, office_y + 50, icon_w, icon_h);
    }
  }
   
   //mouse is outside the box, if it is within icon, lock the icon and get the initial distance between mouse and its position
  else 
  {
     if(!icons.isEmpty())
     {
       for(int i = 0; i < icons.size(); i++)
       {
         icons.get(i).mousePressed();
         
       }
      }
   }
   
}

void mouseDragged()
{
  //update the icon position based on the mouse
  if(!icons.isEmpty())
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
  if(!icons.isEmpty())
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
  //icon.mousePressed();
  
}


//add building and name to hash GNWmap
void addBuilding(String name, Boolean c, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) 
{
  Building newBuilding = new Building(name, c, x1, y1, x2, y2, x3, y3, x4, y4);
  newBuilding.createPolygon();
  GNWMap.put(name, newBuilding);
}
void createGNWMap() 
  {
  addBuilding("City", false, 220, 140, 265, 150, 252, 200, 205, 190);
  addBuilding("Park", false, 205, 195, 252, 205, 235, 275, 187, 265);
  addBuilding("Stn", true, 185, 270, 235, 280, 225, 330, 170, 330);
  
  addBuilding("Equinox", false, 264, 175, 328, 190, 323, 215, 258, 200);
  addBuilding("521", true, 250, 235, 290, 245, 280, 282, 240, 275);
  addBuilding("515", true, 240, 280, 295, 290, 295, 330, 230, 330);
  
  addBuilding("EmilyCarr", false, 305, 230, 475, 230, 475, 280, 305, 280);
  addBuilding("Plaza", false, 300, 290, 360, 290, 360, 330, 300, 330);
  addBuilding("PCI", false, 365, 290, 485, 290, 485, 330, 365, 330);

  addBuilding("CDM1", false, 490, 235, 540, 235, 540, 305, 490, 305);
   
  addBuilding("CDM2", true, 545, 235, 605, 258, 605, 285, 545, 285);
  addBuilding("CDM3", false, 545, 290, 605, 290, 605, 330, 545, 330); 
  
  addBuilding("Lot1", true, 610, 258, 760, 300, 745, 370, 610, 330);  
  addBuilding("Lot2", true, 765, 300, 825, 320, 845, 400, 750, 372);
  addBuilding("Lot3", true, 830, 320, 920, 348, 900, 417, 850, 402);
  addBuilding("Lot4", true, 925, 348, 1015, 375, 995, 445, 905, 418);
  addBuilding("Mec", false, 1020, 377, 1100, 400, 1100, 478, 1000, 447);
  
  addBuilding("Lot5", true, 1105, 400, 1210, 420, 1210, 480, 1105, 480);
  addBuilding("VCC", false, 1105, 500, 1210, 500, 1210, 550, 1105, 550);
   
  addBuilding("Lot6", true, 1220, 500, 1325, 500, 1325, 550, 1220, 550);
  addBuilding("Lot7", true, 1220, 420, 1325, 450, 1325, 480, 1220, 480);
  
  addBuilding("Residential1", false, 170, 350, 615, 350, 615, 550, 170, 550);
  addBuilding("Residential2", false, 615, 350, 1100, 500, 1100, 550, 615, 550);
}