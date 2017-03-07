/**
 * The Person class represents a person who will be flowing between the buildings
 */

class Person 
{

  int initial_nodeID;
  int dest_nodeID;
  color density;
  int weight;
  int current_index = -1;
  int final_index = -1;
  float speed = 4;
  PVector initial_position;
  PVector next_position;
  ArrayList<GraphNode> nodes;
  float dis_x;
  float dis_y;
  float a;
  float angle;
  float lifespan;
  boolean isDead;
  float size;
  //ArrayList<PShape> dots;
  
  //head = createShape(ELLIPSE, 0, 0, 50, 50);

  /**
   * The Person constructor
   * @param initial_id Intial doorID of the person
   * @param dest_id destination doorID of the person
   * @param c the density of person from intial to dest
   */

  Person(int initial_id, int dest_id, int number) 
  {

    initial_nodeID = initial_id;
    dest_nodeID = dest_id;
    //density = c;
    weight = number;
    initial_position = new PVector();
    next_position = new PVector();
    nodes = new ArrayList<GraphNode>();
    nodes = GNWPathFinder.findPath(initial_nodeID, dest_nodeID);
    //if the path is found, get the initial and next 
    if (nodes.size() > 0)
    {
      initial();
    }
    //dots = new ArrayList<PShape>();
    size = 0;
    //this method have to move incase the color does not change with time
    density_decide();
  }

  void run() 
  {  

    update();
    render();
  }

  void update() 
  {
    if (nodes.size() > 0)
    {

      if (lifespan > 0 && !isDead)
      {

        initial_position.x += speed * Math.cos( angle );
        initial_position.y += speed * Math.sin( angle );
        lifespan -= 1;
      }
      //finish one path, continue to another path (not yet arrive the destination)
      else if (lifespan <= 0)
      {
        if (current_index < final_index - 1)
        {
          current_index ++;
          update_position();
        } else
        {
          isDead = true;
          //run = false;
          //initial();
          
          
        }
      }
    }
  }
  //update from, to, angle... every time finish one part of path.
  void update_position()
  {
    initial_position.x = nodes.get(current_index).xf();
    initial_position.y = nodes.get(current_index).yf();
    next_position.x = nodes.get(current_index + 1).xf(); 
    next_position.y = nodes.get(current_index + 1).yf(); 
    dis_x = next_position.x - initial_position.x;
    dis_y = next_position.y - initial_position.y;
    a = dis_y / dis_x;
    angle = (float)Math.atan2( dis_y, dis_x);
    lifespan = abs(dist(initial_position.x, initial_position.y, next_position.x, next_position.y)) / speed;
    
  }
  
  void render() 
  {
    fill(0, 128, 255);
    ellipse(initial_position.x, initial_position.y, size, size);
    //DrawDots();
    
  }
    
  
  
  void initial()
  {
    current_index = 0;
    final_index = nodes.size() - 1;
    update_position();
    isDead = false;
    
  }
  
  //still need to improve
  void DrawDots()
  {
    
    //improve the algorithm
    //float angle2 = (float)Math.atan2( dis_y, dis_x);
    for(int i = 0; i < 200; i = i + 20)
      {
        float random_x = 0;
        float random_y = 0;
        
        //float dot_x = initial_position.x + random * i;
        //float dot_y = initial_position.y + random * i;
        
        float vertical = (float)Math.sin(angle);
        float horizontal = (float)Math.cos(angle);
        
        if(vertical > 0 && horizontal > 0) // up
        {
          random_y = -1;
          random_x = -1;
        }
        else if (vertical > 0 && horizontal < 0) //down
        {
          random_y = -1;
          random_x = 1;
          
        }
        else if (vertical < 0 && horizontal > 0) //down
        {
          random_y = 1;
          random_x = -1;
          
        }
        else if (vertical < 0 && horizontal < 0) //down
        {
          random_y = 1;
          random_x = 1;
          
        }
        
        float dot_x = initial_position.x + i;
        float dot_y = initial_position.y + i * a;
        
        //PShape dot = createShape(ELLIPSE, dot_x, dot_y, 10, 10);
        ellipse(dot_x, dot_y, size, size);
        //dot.setFill(color(0, 128, 255));
        //shape(dot);
        //dots.add(dot);
        }
      
     
  }
  
 
 
  
  
  
  void density_decide()
  {
    
    if(weight == 5)
    {
      size = 5;
      
    }
    else if (weight == 10)
    {
      size = 7;
      
    }
    else if (weight == 20)
    {
      size = 10;
      
    }
    else if(weight == 30)
    {
      size = 13;
    }
    else if (weight == 50)
    {
      size = 15;
    }
    
  }
  
}