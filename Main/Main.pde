import java.util.Map;

//String here is building id
HashMap<String, Building> GNWMap; 
ArrayList<Integer> type_1_buildingIds;
ArrayList<Integer> type_2_buildingIds;
ArrayList<Integer> type_3_buildingIds;

void setup() {
  size(1024, 768);
  GNWMap = new HashMap<String, Building>();
  type_1_buildingIds = new ArrayList<Integer>();
  type_2_buildingIds = new ArrayList<Integer>();
  type_3_buildingIds = new ArrayList<Integer>();
  
  //TODO: create building/lots according to map
  addBuilding("PCI0", 200, 500, 100, 100);
  addBuilding("PCI1", 500, 500, 100, 100);
  addBuilding("PCI2", 800, 500, 100, 100);
  addBuilding("L0", 200, 200, 100, 100);
  addBuilding("L1", 500, 200, 100, 100);
  addBuilding("L2", 800, 200, 100, 100); //<>//
  
  //TODO: dynamically add types to building (drag and drop type icon into buildings)
  GNWMap.get("PCI0").addType(new Type_1());
  GNWMap.get("PCI1").addType(new Type_1());
  GNWMap.get("PCI2").addType(new Type_2());
  GNWMap.get("L0").addType(new Type_2());
  GNWMap.get("L1").addType(new Type_3());
  GNWMap.get("L2").addType(new Type_3());
}

void draw() {
  background(0);
  for (Map.Entry GNWMapEntry : GNWMap.entrySet()) {
    Building building = (Building) GNWMapEntry.getValue();
    building.render();
    building.run();
  }
}

void addBuilding(String id, float x, float y, float w, float h) {
  Building newBuilding = new Building(x, y, w, h);
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