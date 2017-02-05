import java.util.Map;

//String here is building id
HashMap<String, Building> GNWMap; 
ArrayList<Integer> type_1_buildingIds;
ArrayList<Integer> type_2_buildingIds;
ArrayList<Integer> type_3_buildingIds;

void setup() {
  size(1400, 700);
  GNWMap = new HashMap<String, Building>();
  type_1_buildingIds = new ArrayList<Integer>();
  type_2_buildingIds = new ArrayList<Integer>();
  type_3_buildingIds = new ArrayList<Integer>();
  
  createGNWMap();
  addInitBuildingTypes();
  
  //TODO: dynamically add types to building (drag and drop type icon into buildings)
}

/** 
* Draws all the buildings in GNWMap
*/
void draw() {
  background(255);
  for (Map.Entry GNWMapEntry : GNWMap.entrySet()) { //<>//
    Building building = (Building) GNWMapEntry.getValue();
    building.render();
    building.run();
  }
}


/**
* Creates new building and adds the building to GNWMap
*/
void addBuilding(String id, Boolean customizable, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  Building newBuilding = new Building(id, customizable, x1, y1, x2, y2, x3, y3, x4, y4);
  GNWMap.put(id, newBuilding);
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


//USED FOR DEBUGGING - prints x & y coordinate values of mouse click
//void mouseClicked() {
//  fill(0);
//  ellipse(mouseX, mouseY, 2, 2);
//  println("x: " + mouseX + "; y: " + mouseY);
//}