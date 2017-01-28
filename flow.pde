Building buildingA;
Building buildingB;

void setup() {
  size(500, 300);
  buildingA = new Building(150, 150, 100, 100);
  buildingB = new Building(350, 150, 100, 100);
  
  buildingA.addPerson();
}

void draw() {
  background(0);
  buildingA.render();
  buildingB.render();
  
  buildingA.run();
}

class Building {    
    ArrayList<Person> persons; 
    int xpos;
    int ypos; 
    int buildingWidth;
    int buildingHeight;
    
    Building (int x, int y, int w, int h) {
      xpos = x;
      ypos = y;
      buildingWidth = w;
      buildingHeight = h;
      
      persons = new ArrayList<Person>();
    }
    
    void render() {
      fill(255);
      rectMode(CENTER);
      rect(xpos, ypos, buildingWidth, buildingHeight);
    }
    
    void addPerson() {
      persons.add(new Person(xpos, ypos));
    }  
    
   void run() {
      for (int i = persons.size()-1; i >= 0; i--) {
        Person p = persons.get(i);
        p.run();
        if (p.isDead()) {
          persons.remove(i);
        }
      }
    }

  
}


class Person {
  PVector position;
  PVector velocity;
  float lifespan;
  
  int xpos_destination = 350;
  
  Person(float xpos, int ypos) {
    position = new PVector(xpos, ypos);
    velocity = new PVector(1, 0);
    lifespan = xpos_destination - position.x;
  }
  
  void run() {    
    update();
    render();
  }

 void update() {
    position.add(velocity);
    lifespan -= 1;
  }
  
  void render() {
    ellipse(position.x, position.y, 8, 8);
  }
  
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }

}