
class Icon_Initial
{
  
  color box_color;
  int box_x;
  int box_y;
  int box_width;
  int box_height;
  String box_type;
  boolean mouse_detect = false;
  
  Icon_Initial(color c, int x, int y, int w, int h, String icon_type)
  {
    box_color = c;
    box_x = x;
    box_y = y;
    box_width = w;
    box_height = h;
    box_type = icon_type;
    
  }
  
  
  //draw method
  void render()
  {
    fill(box_color);
    rect(box_x, box_y, box_width, box_height);
    fill(255);
    textSize(9);
    text(box_type, box_x - 10, box_y);
  }
  
  //draw method
  void detect()
  {
    if(mouseX > box_x - box_width/2 && mouseX < box_x + box_width/2 && mouseY > box_y - box_height/2 && mouseY < box_y + box_height/2)
    {
      mouse_detect = true;
    }
    else
    {
      mouse_detect = false;
    }
  }
  

}