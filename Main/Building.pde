/**
* The Building class represents a physical building 
*/
class Building {    
    ArrayList<Person> persons; 
    ArrayList<Type> blockTypes;
    float buildingXPos;
    float buildingYPos;
    float buildingWidth;
    float buildingHeight;
    int maxTypes;
    
    /**
    * The Building constructor
    * @param x This is the x-coordinate of the building
    * @param y This is the y-coordinate of the building
    * @param w This is the width of the building
    * @param h This is the height of the building
    */
    Building (float x, float y, float w, float h) {
      buildingXPos = x; //<>//
      buildingYPos = y;
      buildingWidth = w;
      buildingHeight = h;
      
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
      fill(255);
      rectMode(CENTER);
      rect(buildingXPos, buildingYPos, buildingWidth, buildingHeight);
    }
    
    /**
    * Adds a person to this building
    */
    void addPerson(PVector destinationPosition) {
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