Building buildingA;
Building buildingB;

void setup() {
  size(1024, 768);
  buildingA = new Building(362, 384, 100, 100);
  buildingB = new Building(662, 384, 100, 100);
  
  buildingA.addPerson();
}

void draw() {
  background(0);
  buildingA.render();
  buildingB.render();
  buildingA.run();
}