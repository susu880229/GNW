/**
* The Person class represents a person who will be flowing between the buildings 
*/
class Person {
  PVector position;
  PVector velocity;
  float lifespan;
  float xpos_destination = 350;
  
   /**
    * The Person constructor
    * @param x This is the x-coordinate of the building the person is in
    * @param y This is the y-coordinate of the building the person is in
    */
    Person(float x, float y) {
      position = new PVector(x, y);
      velocity = new PVector(1, 0);
      lifespan = xpos_destination - position.x;
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
    ellipse(position.x, position.y, 8, 8);
  }
  
  /**
  * Updates position of dot
  */
  void update() {
    position.add(velocity);
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