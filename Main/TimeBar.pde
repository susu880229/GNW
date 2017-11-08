/** 
 * The TimeBar class represent the time slider
 */
class TimeBar
{
  int x;
  int y;
  int wi;
  int hi;
  int back_x;
  int back_y;
  int back_wi;
  int back_hi;
  int position;
  color dot_color;
  
  int numOfSections = 8;
  
  /**
   * TimeBar constructor
   * @dot_x is the x coordiate of the dot
   * @dot_y is the y corridiate of the dot
   * @dot_wi is the width of the dot
   * @dot_hi is the height of the dot
   * @back_x is the x corridate of the invisible bar under the dot 
   * @back_y is the y coordiate of the invisible bar under the dot
   * @back_wi is the width of the bar (the length of the dots moving)
   * @back_hi is the height of the bar
   * @position is the index of the dots (multiplied by the back_wi / 8).
   */
  TimeBar(int dot_x, int dot_y, int dot_wi, int dot_hi)
  {
    x = dot_x;
    y = dot_y;
    wi = dot_wi;
    hi = dot_hi;
    back_wi = 1727; //define the bar length
    back_hi = 12;
    back_x = x;
    back_y = y - 6;
    dot_color = color(22, 184, 189);
  }
  
  void render()
  {
    //the background bar
    fill(color(255, 255, 255, 0));
    rect(back_x, back_y, back_wi, back_hi);
    //the changable bar
    fill(dot_color);
    rect(back_x, back_y, x  - back_x, back_hi);
    //draw the current time dots
    fill(dot_color);
    ellipseMode(CENTER);
    ellipse(x, y, wi, hi);
    //draw the previous time dots
    draw_dots(position);
  }
  
  void draw_dots(int number)
  {
    for(int i = 0; i < number; i++)
    {
      if(i % 2 == 0)
      {
        fill(dot_color);
        ellipseMode(CENTER);
        ellipse(back_x + back_wi / numOfSections * i, y, wi, hi);
      }
    }
  }
  
  void mouseDragged()
  {
    position_decide();
  }
  
  /**
   * Draw the dots only on the certain five time selections of the slider bar
   */
  void position_decide()
  {
    
    for(int i = 0; i < numOfSections; i++)
    {
      int next_i = i + 1;
      
      if(mouseX >= back_x + back_wi / numOfSections * i && mouseX < back_x + back_wi / numOfSections * next_i)
      {
        if(i % 2 == 0) // even number
        {
          x = back_x + back_wi / numOfSections * i;
          cur_time = floor(i/2);
          position = i;          
        }
        else if (next_i % 2 == 0)
        {
          x = back_x + back_wi / numOfSections * next_i;
          cur_time = floor(next_i / 2);
          position = next_i;
        }
        break;
      }
    }    
  }  
}