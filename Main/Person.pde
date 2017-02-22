/**
 * The Person class represents a person who will be flowing between the buildings
 */

class Person 
{
  
  int initial_nodeID;
  int dest_nodeID;
  color density;
  int current_index = -1;
  int final_index = -1;
  float speed = 4;
  PVector initial_position;
  PVector next_position;
  ArrayList<GraphNode> nodes;
  float dis_x;
  float dis_y;
  float angle;
  float lifespan;
  boolean isDead = false;
 
  
  /**
   * The Person constructor
   * @param initial_id Intial doorID of the person
   * @param dest_id destination doorID of the person
   * @param c the density of person from intial to dest
   */

  Person(int initial_id, int dest_id, color c) 
  {
    
    initial_nodeID = initial_id;
    dest_nodeID = dest_id;
    density = c;
    initial_position = new PVector();
    next_position = new PVector();
    nodes = new ArrayList<GraphNode>();
    nodes = GNWPathFinder.findPath(initial_nodeID , dest_nodeID);
    //if the path is found, get the initial and next 
    if(nodes.size() > 0)
    {
      current_index = 0;
      final_index = nodes.size() - 1;
      update_position();
    }
    
  }
  
  void run() 
  {  
    
    update();
    render();
    
  }

  void update() 
  {
    if(nodes.size() > 0)
    {
      
      if(lifespan > 0 && !isDead)
      {
        
        initial_position.x += speed * Math.cos( angle );
        initial_position.y += speed * Math.sin( angle );
        lifespan -= 1;
       
      }
      //finish one path, continue to another path (not yet arrive the destination)
      else if(lifespan <= 0)
      {
        if(current_index < final_index - 1)
        {
          current_index ++;
          update_position();
        }
        else
        {
          isDead = true;
          //run = false;
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
    angle = (float)Math.atan2( dis_y, dis_x);
    lifespan = abs(dist(initial_position.x, initial_position.y, next_position.x, next_position.y)) / speed;
    
  }
  void render() 
  {
    fill(density);
    ellipse(initial_position.x, initial_position.y, 6, 6);
    
  }


 
  
}