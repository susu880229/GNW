/** //<>//
 * The Building class represents a physical building 
 */
class Building {    
  ArrayList<Person> persons; 
  ArrayList<Type> blockTypes;
  String buildingId;
  int maxTypes;
  boolean isCustomizable;
  HashMap<String, Coord> buildingCoords;
  int doorNode;
  float buildingCenter_x;
  float buildingCenter_y;

  /**
   * The Building constructor
   * @param id This is the id of the building
   * @param customizable Sets if the building is customizable by user or not
   * @param buildingCoords Building's coordinates of its 4 corners
   * @param doorNode The door id to the building. 
   */
  Building (String id, boolean customizable, HashMap<String, Coord> buildingCoords, int doorNodeId) {
    persons = new ArrayList<Person>();
    blockTypes = new ArrayList<Type>(); 
    maxTypes = 3;

    buildingId = id;
    isCustomizable = customizable;
    this.buildingCoords = buildingCoords;
    this.doorNode = doorNodeId;

    buildingCenter_x = ((buildingCoords.get("topLeft").x + buildingCoords.get("topRight").x + buildingCoords.get("bottomRight").x+ buildingCoords.get("bottomLeft").x) /4) - 15;
    buildingCenter_y = ((buildingCoords.get("topLeft").y + buildingCoords.get("topRight").y + buildingCoords.get("bottomRight").y+ buildingCoords.get("bottomLeft").y) /4) + 5;
  }

  /**
   * The animation for people to flow out of this building to another building
   */
  void run() {
    for (int i = persons.size()-1; i >= 0; i--) {
      Person p = persons.get(i);
      p.run();
      if (p.isDead()) {
        persons.remove(i);
      }
    }
  }

  /**
   * Renders a block to represent the building onto the screen
   */
  void render() {
    //draws building/lot
    if (isCustomizable) {
      fill(200);
    } else {
      fill(150);
    }
    noStroke();    
    quad(buildingCoords.get("topLeft").x, buildingCoords.get("topLeft").y, buildingCoords.get("topRight").x, buildingCoords.get("topRight").y, buildingCoords.get("bottomRight").x, buildingCoords.get("bottomRight").y, buildingCoords.get("bottomLeft").x, buildingCoords.get("bottomLeft").y);

    if (blockTypes.size() > 0) {
      renderIcons();
    }

    //draws label
    fill(0);
    textSize(9);
    text(buildingId, buildingCenter_x, buildingCenter_y);
  }

  /**
   * Draws usage icons ontop of buildings
   **/
  void renderIcons() {
    for (int i = 0; i < blockTypes.size(); i++) {
      Type type = blockTypes.get(i); 
      PImage typeIcon = loadImage(type.imageSource);
      image(typeIcon, buildingCenter_x, buildingCenter_y);
    }
  }

  /**
   * Adds a person to this building
   */
  void addPerson(PVector destinationPosition) {
    //TODO figure out how person will flow between buildings
   // persons.add(new Person(buildingCenter_x, buildingCenter_y, destinationPosition));
  }  

  /**
   * Adds a usage types to this building
   */
  void addType(Type type) {
    blockTypes.add(type);

    //TODO: change flow animation based on number of people
    //  for (int i = 0; i < type.numberOfPeople; i++) {

    PVector destinationPosition = new PVector (500, 500);
    addPerson(destinationPosition);
    // }
  }
}