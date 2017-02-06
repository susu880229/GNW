class Drag_Drop
{
  int bx;
  int by;
  int w = 30;
  int h = 30;
  
  boolean hover = false;
  boolean locked = false;
  int difx = 0; 
  int dify = 0; 
  String img;
  PImage a;
  
  //constructor
  Drag_Drop(String img_name, int x, int y,int wi, int hi)
  {
    img = img_name;
    w = wi;
    h = hi;
    bx = x;
    by = y;
  }
  
  //load he image to drop at the beginning
  void load()
  {
    //a = loadImage("data/Button.jpg");
    a = loadImage(img);
    
  }
  
  //the image is controlled by the bx, by parameters
  void update()
  {
    
    if (mouseX > bx && mouseX < bx + w && mouseY > by && mouseY < by + h) 
    {
    hover = true;  
    } 
    else 
    {
    hover = false;
    }
    
    image(a, bx, by, w, h);
  }
  void mousePressed() 
  {
    if(hover) 
    { 
    locked = true; 
    //copy the image after hold the mouse
    }
    else 
    {
    locked = false;
    }
    difx = mouseX - bx; 
    dify = mouseY - by; 
  }

  void mouseDragged() 
  {
    if(locked) 
    {
    //update the new position of the image everytime user drag it
    bx = mouseX - difx; 
    by = mouseY - dify; 
    
    }
  }

  void mouseReleased() 
  {
  locked = false;
  }
  
  

  
  
}