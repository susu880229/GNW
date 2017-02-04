/**
* The Building class represents a physical building 
*/
class Building {    
    ArrayList<Person> persons; 
    ArrayList<Type> blockTypes;
    float buildingPos_x1;
    float buildingPos_y1;
    float buildingPos_x2;
    float buildingPos_y2;
    float buildingPos_x3;
    float buildingPos_y3;
    float buildingPos_x4;
    float buildingPos_y4;
    int maxTypes;
    
    /**
    * The Building constructor
    * @param x1 This is the x-coordinate of the top-left corner of the building
    * @param y1 This is the y-coordinate of the top-left corner of the building
    * @param x2 This is the x-coordinate of the top-right corner of the building
    * @param y2 This is the y-coordinate of the top-righteft corner of the building
    * @param x3 This is the x-coordinate of the bottom-right corner of the building
    * @param y3 This is the y-coordinate of the bottom-right corner of the building
    * @param x4 This is the x-coordinate of the bottom-left corner of the building
    * @param y4 This is the y-coordinate of the bottom-left corner of the building
    */
    Building (float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
      buildingPos_x1 = x1;
      buildingPos_y1 = y1;
      buildingPos_x2 = x2;
      buildingPos_y2 = y2;
      buildingPos_x3 = x3;
      buildingPos_y3 = y3;
      buildingPos_x4 = x4;
      buildingPos_y4 = y4; //<>// //<>//
      
      maxTypes = 3;
      
      persons = new ArrayList<Person>();
      blockTypes = new ArrayList<Type>();
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
      fill(100);
      noStroke();
      
      quad(buildingPos_x1, buildingPos_y1, buildingPos_x2, buildingPos_y2, buildingPos_x3, buildingPos_y3, buildingPos_x4, buildingPos_y4);
    }
    
    /**
    * Adds a person to this building
    */
    void addPerson(PVector destinationPosition) {
      //TODO figure out how person will flow between buildings
      float buildingXPos = (buildingPos_x1 + buildingPos_x2) /2;
      float buildingYPos = (buildingPos_y1 + buildingPos_y2) /2;
      
      persons.add(new Person(buildingXPos, buildingYPos, destinationPosition));
    }  
    
    /**
    * Adds a usage types to this building
    */
    void addType(Type type) {
      blockTypes.add(type);
      
      //TODO: change flow animation based on number of people
    //  for (int i = 0; i < type.numberOfPeople; i++) {
      
      PVector destinationPosition = new PVector (500,500);
      addPerson(destinationPosition);
     // }
    } 
    

}