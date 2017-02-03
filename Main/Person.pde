/**
* The Person class represents a person who will be flowing between the buildings 
*/
class Person {
  PVector sourcePos;
  PVector destinationPos;
  PVector velocity;
  float lifespan;
  
   /**
    * The Person constructor
    * @param buildingPosition This is the position of the building the person is in
    * @param destinationPosition This is the position of the building the person will go to
    */
    Person(float x, float y, PVector destinationPosition) {
      sourcePos = new PVector(x, y);
      destinationPos = destinationPosition;
      velocity = new PVector(1, 0);
      lifespan = destinationPos.x - sourcePos.x;
    }
  
   /**
   * The animation of people flow
   */
  void run() {    
    update();
    render();
  }

  /**
  * Renders a dot to represent the person onto the screen
  */
  void render() {
    ellipse(sourcePos.x, sourcePos.y, 8, 8);
  }
  
  /**
  * Updates position of dot
  */
  void update() {
    sourcePos.add(velocity);
    lifespan -= 1;
  }
  
  /**
  * Checks if dot is still active or not
  */
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }

}