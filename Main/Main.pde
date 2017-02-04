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
  
  //Buildings listed from left to right, top to bottom
  
  //addBuilding("City", 100, 100, 50, 80);
  //addBuilding("Park", 100, 210, 60, 130);
  addBuilding("ThorntonStn", 184, 270, 234, 279, 232, 326, 177, 327);
  
  //addBuilding("Equinox", 180, 120, 100, 40);
  //addBuilding("521", 160, 235, 50, 80);
  addBuilding("515", 240, 280, 295, 290, 295, 330, 237, 330);
  
  addBuilding("EmilyCarr", 305, 230, 475, 230, 475, 280, 305, 280);
  addBuilding("Plaza", 300, 290, 360, 290, 360, 330, 300, 330); //<>//
  addBuilding("PCI", 365, 290, 485, 290, 485, 330, 365, 330);

  addBuilding("CDM1", 495, 235, 555, 235, 555, 305, 495, 305);
   
  addBuilding("CDMParking", 560, 235, 620, 258, 620, 285, 560, 285);
  addBuilding("CDM2", 560, 290, 620, 290, 620, 330, 560, 330); 
  
  addBuilding("Lot1", 625, 258, 760, 310, 730, 365, 625, 330);  
  addBuilding("Lot2", 765, 310, 825, 330, 845, 405, 735, 365);
  addBuilding("Lot3", 830, 330, 920, 356, 895, 421, 850, 405);
  addBuilding("Lot4", 925, 356, 1015, 380, 995, 449, 900, 421);
  addBuilding("Mec", 1020, 380, 1120, 400, 1120, 477, 1000, 449);
  
  addBuilding("Lot5", 1130, 400, 1230, 421, 1230, 480, 1130, 480);
  addBuilding("VCC", 1130, 500, 1230, 500, 1230, 550, 1130, 550);
   
  addBuilding("Lot6", 1250, 500, 1350, 500, 1350, 550, 1250, 550);
  addBuilding("Lot7", 1250, 420, 1350, 450, 1350, 480, 1250, 480);
  
  //TODO: dynamically add types to building (drag and drop type icon into buildings)
  //GNWMap.get("521").addType(new Type_1());
  //GNWMap.get("PCI1").addType(new Type_1());
  //GNWMap.get("PCI2").addType(new Type_2());
  //GNWMap.get("L0").addType(new Type_2());
  //GNWMap.get("L1").addType(new Type_3());
  //GNWMap.get("L2").addType(new Type_3());
}

void draw() {
  //background(255);
  for (Map.Entry GNWMapEntry : GNWMap.entrySet()) {
    Building building = (Building) GNWMapEntry.getValue();
    building.render();
    building.run();
  }
}

void mouseClicked() {
  fill(0);
  ellipse(mouseX, mouseY, 8, 8);
  println("x: " + mouseX + "; y: " + mouseY);
}

void addBuilding(String id, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  Building newBuilding = new Building(x1, y1, x2, y2, x3, y3, x4, y4);
  GNWMap.put(id, newBuilding);
}

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