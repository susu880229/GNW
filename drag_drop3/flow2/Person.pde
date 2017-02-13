class Person 
{
  PVector initial_position;
  float speed = 4;
  PVector dest_position;
  color weight;
  float dis_x;
  float dis_y;
  float angle;
  float lifespan;
  
  Person(float ini_xpos, float ini_ypos, float des_xpos, float des_ypos) 
  {
    initial_position = new PVector(ini_xpos, ini_ypos);
    dest_position = new PVector(des_xpos, des_ypos);
    dis_x = des_xpos - ini_xpos;
    dis_y = des_ypos - ini_ypos;
    angle = (float)Math.atan2( dis_y, dis_x);
    lifespan = abs(dist(initial_position.x, initial_position.y, dest_position.x, dest_position.y)) / speed;
  }
  
  void run() 
  {  
    
    update();
    render();
  }

  void update() 
  {
    //move from left to right
    initial_position.x += speed * Math.cos( angle );
    initial_position.y += speed * Math.sin( angle );
    lifespan -= 1;
    
    
    
  }
  
   void render() 
   {
     fill(0, 0, 200);
     ellipse(initial_position.x, initial_position.y, 8, 8);
   }
   
   
  
   //decide weight by color
   void decide_color()
   {
     
     
   }
   
   boolean isDead() 
   {
     if (lifespan < 0.0) 
     {
      return true;
     } 
     else 
     {
      return false;
     }
   }
  
  
  
  
}