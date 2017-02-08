class Person {
  PVector initial_position;
  PVector velocity;
  PVector dest_position;
  
  Person(float ini_xpos, float ini_ypos, float des_xpos, float des_ypos) 
  {
    initial_position = new PVector(ini_xpos, ini_ypos);
    dest_position = new PVector(des_xpos, des_ypos);
    
  }
  
  void run() 
  {  
    decide_direction();
    update();
    render();
  }

  void update() 
  {
    //move from left to right
    
    if(velocity.x == 1)
    {
      if(initial_position.x < dest_position.x)
      {
        initial_position.add(velocity);
      }
      
    } 
    //move from right to left
    else if (velocity.x == -1)
    {
      if(initial_position.x > dest_position.x)
      {
        initial_position.add(velocity);
      }
      
    }
    
    
    
  }
  
   void render() 
   {
     ellipse(initial_position.x, initial_position.y, 8, 8);
   }
   
   void decide_direction()
   {
     if (dest_position.x > initial_position.x)
     {
       velocity = new PVector(1, 0);
     }
     else if(dest_position.x < initial_position.x)
     {
       velocity = new PVector (-1, 0);
     }
     
   }
  
 
}