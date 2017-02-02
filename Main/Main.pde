import java.util.Map;

//String here is building id
HashMap<String, Building> GNWMap; 

void setup() {
  size(1024, 768);
  GNWMap = new HashMap<String, Building>();
  
  //TODO: create building/lots according to map
  addBuilding("PCI0", 200, 500, 100, 100);
  addBuilding("PCI1", 500, 500, 100, 100);
  addBuilding("PCI2", 800, 500, 100, 100);
  addBuilding("L0", 200, 200, 100, 100);
  addBuilding("L1", 500, 200, 100, 100);
  addBuilding("L2", 800, 200, 100, 100); //<>//
  
  //TODO: dynamically add types to building (drag and drop type icon into buildings)
  GNWMap.get("PCI0").addType(new Type_1());
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
  
  //TODO remove this and use building type to determine how to add people
  newBuilding.addPerson();
}