Building buildingA;
Building buildingB;
ArrayList<Drag_Drop> icons;
int food_x = 100;
int food_y = 100;
int transit_x = 170;
int transit_y = 100;
int office_x = 240;
int office_y = 100;
int school_x = 310;
int school_y = 100;
int icon_w = 30;
int icon_h = 30;
String choice;
//Drag_Drop icon;

void setup()
{
  size(1024, 768);
  buildingA = new Building(362, 384, 100, 100);
  buildingB = new Building(662, 384, 100, 100);
  buildingA.addPerson();
  icons = new ArrayList<Drag_Drop>();
 

}

void draw() {
  background(0);
  buildingA.render();
  buildingB.render();
  buildingA.run();

  //food icon
  rectMode(CENTER);
  fill(200, 0, 0);
  rect(food_x, food_y, 50, 50);
  fill(255);
  textSize(9);
  text("Food", 90, 100);
  
  //Transit icon
  fill(0, 0, 200);
  rect(transit_x, transit_y, 50, 50);
  fill(255);
  textSize(9);
  text("Transit", 160, 100);
  
  //office icon
  fill(0, 200, 0);
  rect(office_x, office_y, 50, 50);
  fill(255);
  textSize(9);
  text("Office", 230, 100);
  
  //school icon
  fill(200, 200, 0);
  rect(school_x, school_y, 50, 50);
  fill(255);
  textSize(9);
  text("School", 300, 100);
  
  //detect which icon user choose
  if(mouseX > food_x - 25 && mouseX < food_x + 25 && mouseY > food_y - 25 && mouseY < food_y + 25)
  {
    choice = "food";
  }
  else if (mouseX > transit_x - 25 && mouseX < transit_x + 25 && mouseY > transit_y - 25 && mouseY < transit_y + 25)
  {
    choice = "transit";
  }
  else if (mouseX > office_x - 25 && mouseX < office_x + 25 && mouseY > office_y - 25 && mouseY < office_y + 25)
  {
    choice = "office";
  }
  else if (mouseX > school_x - 25 && mouseX < school_x + 25 && mouseY > school_y - 25 && mouseY < school_y + 25)
  {
    choice = "school";
  }
  else 
  {
    choice = null;
  }
  
  
  if(!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
    Drag_Drop icon = icons.get(i);
    icon.update();
    }
    
  }
  

}

void mousePressed()
{
  //p1.mousePressed(); 
  
  //load icon image according to users' choice and start to drag and drop function
  if (choice != null)
  {
    if(choice == "food")
    {
      icon_generate("food_icon.png", food_x, food_y + 50, icon_w, icon_h);
    }
    
    else if(choice == "transit")
    {
      icon_generate("transit_icon.png", transit_x, transit_y + 50, icon_w, icon_h);
    }
    
    else if(choice == "school")
    {
      icon_generate("school_icon.png", school_x, school_y + 50, icon_w, icon_h);
    }
    
    else if(choice == "office")
    {
      icon_generate("office_icon.png", office_x, office_y + 50, icon_w, icon_h);
    }
   }
   
   //if user finish create icon, they start drag and drop icon
   else 
   {
     if(!icons.isEmpty())
     {
       for(int i = 0; i < icons.size(); i++)
       {
         icons.get(i).mousePressed();
         
       }
      }
    }
   
}

void mouseDragged()
{
  //p1.mouseDragged();
  if(!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
    icons.get(i).mouseDragged();
    
    }
    
  }
}

void mouseReleased()
{
  //p1.mouseReleased();
  if(!icons.isEmpty())
  {
    for (int i = 0; i < icons.size(); i++)
    {
      icons.get(i).mouseReleased();
    }
  }
  
}

//create icon object 
void icon_generate(String icon_name, int icon_x, int icon_y, int icon_w, int icon_h )
{
  Drag_Drop icon = new Drag_Drop(icon_name, icon_x, icon_y, icon_w, icon_h);
  icons.add(icon);
  icon.load();
  //icon.mousePressed();
  
}

//create block class
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
    
    //rendering the block
    void render() {
      fill(255);
      rectMode(CENTER);
      rect(xpos, ypos, buildingWidth, buildingHeight);
    }
    
    //create person dot between two block
    void addPerson() {
      for (int i = 0; i <= 50; i = i + 10)
      {
        persons.add(new Person(xpos - i, ypos));
        
      }
      
    }  
    
   void run() {
      for (int i = persons.size()-1; i >= 0; i--) {
        Person p = persons.get(i);
        p.run();
        if (p.isDead()) {
          //persons.remove(i);
          p.position = new PVector (xpos, ypos);
          p.lifespan = 300;
        }
      }
    }

  
}


class Person {
  PVector position;
  PVector velocity;
  float lifespan;
  
  int xpos_destination = 350;
  
  Person(float xpos, float ypos) {
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