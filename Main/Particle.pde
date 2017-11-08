/**
 * The Particle class represents each dot on the map.
 */
class Particle
{
  int maxPathDeviation = 5;    //how far the particles can deviate from the standard path (how much the particles can stray from their path)
  int devChance = 10;          //chance of particle deviating: a higher value means a lower chance
  int devScale = 3;            //how large each deviating step is 
  int particleSize = 15;       //size of particle drawn on the map
  float minRandomVelocity = 7.0;  //the lowest value of how fast the particles move
  float maxRandomVelocity = 9.0;  //the highest value of how fast the particles move
  
  int initial_nodeID;
  int dest_nodeID;
  float positionX;
  float positionY;
  float velocityX;
  float velocityY;
  float vectorVelocity;
  String from_buildingUse;
  String to_buildingUse;
  int currentPathIndex;
  boolean isEndOfRoute;
  color flowColor;
  ArrayList<GraphNode> nodes;
  ArrayList<Path> paths;
  
  
  /**
   * The Particle constructor
   * 
   * @param routeNodes the graph nodes of the route that the particle will travel through.
   * @param start_nodeID the node at the beginning of the route
   * @param end_nodeID the node at the end of the route
   * @param from_use the building use at the start point of the route
   * @param to_use the building use at the end point of the route
   */
  Particle (ArrayList<GraphNode> routeNodes, int start_nodeID, int end_nodeID, String from_use, String to_use) 
  {
    nodes = routeNodes;
    from_buildingUse = from_use;
    to_buildingUse = to_use;
    initial_nodeID = start_nodeID;
    dest_nodeID = end_nodeID;
    positionX = nodes.get(0).xf();
    positionY = nodes.get(0).yf();
    velocityX = 0;
    velocityY = 0;
    vectorVelocity = random(minRandomVelocity, maxRandomVelocity);
    currentPathIndex = 0;
    isEndOfRoute = false;
    paths = new ArrayList<Path>();
    flowColor = color(130, 0, 204, 100);
    
    //decide the color of the particle
    selectFill();
    
    //build the Paths that the particle will travel through
    for (int i = 0; i < nodes.size() - 1; i++)
    {
      float nodeStartX = nodes.get(i).xf();
      float nodeStartY = nodes.get(i).yf();
      float nodeEndX = nodes.get(i+1).xf();
      float nodeEndY = nodes.get(i+1).yf();

      Path curPath = new Path(new PVector(nodeStartX, nodeStartY), new PVector(nodeEndX, nodeEndY));
      paths.add(curPath);
    }
    
    //calculate the x and y components of the velocity for the first path
    Path startPath = paths.get(0);
    calcVelocity(startPath);
  }
  
  void run()
  {
    noStroke();
    fill(flowColor);
    
    //draw the particle
    ellipse(positionX, positionY, particleSize, particleSize);
    
    boolean isOutOfBounds = false;

    //calculate the next postion of the particle
    positionX += velocityX;
    positionY += velocityY;
    
    //give a random chance for the particle to deviate from its path
    randomizeMovement(paths.get(currentPathIndex));
    
    //check if the particle has moved out of the current graph edge. 
    //If it is, move it onto the next edge. If it has reached the destination, return isEndOfRoute = true.
    isOutOfBounds = checkBoundaries(paths.get(currentPathIndex));
    
    if(isOutOfBounds && currentPathIndex < paths.size() - 1)
    {
      currentPathIndex += 1;
      Path nextPath = paths.get(currentPathIndex);
      positionX = nextPath.pathStartPoint.x;
      positionY = nextPath.pathStartPoint.y;
      calcVelocity(nextPath);
    }
    
    else if (isOutOfBounds && currentPathIndex >= paths.size() - 1)
    {
      isEndOfRoute = true;
    }

  }
  
  
  //calculates the x and y values of the velocity based on the current path that the particle is on
  void calcVelocity(Path path)
  {
    velocityX = abs(vectorVelocity * cos(path.angle));
    velocityY = abs(vectorVelocity * sin(path.angle));

    if (path.dis_x < 0) 
    {
      velocityX *= -1;
    }

    if (path.dis_y < 0) 
    {
      velocityY *= -1;
    }
  }
  
  
  //make the particles move more organically by allowing them to deviate from the path
   void randomizeMovement(Path path)
  {
    if (abs(path.gradient) <= 1)    //if line is more horizontal than vertical
    {
      float standardY = path.gradient * positionX + path.constant;
      float deviation = positionY - standardY;
      float newY = positionY;

      if (abs(deviation) < maxPathDeviation)    //if the current deviation is less than standard, it can deviate both ways
      {
        if (random(0, devChance) < 1)
        {
          newY = positionY + random(-1*devScale, devScale);
        }
      } else if (abs(deviation) >= maxPathDeviation)    //if the current deviation is maximum, it can only move inwards
      {
        if (random(0, devChance) < 1)
        {
          if (deviation > 0)
          {
            newY = positionY - random(0, devScale);
          } else
          {
            newY = positionY + random(0, devScale);
          }
        }
      }

      positionY = newY;
    } else                            //if line is more vertical than horizontal
    {
      float standardX = (positionY - path.constant) / path.gradient;
      float deviation = positionX - standardX;
      float newX = positionX;

      if (abs(deviation) < maxPathDeviation)    //if the current deviation is less than standard, it can deviate both ways
      {
        if (random(0, devChance) < 1)
        {
          newX = positionX + random(-1*devScale, devScale);
        }
      } else if (abs(deviation) >= maxPathDeviation)    //if the current deviation is maximum, it can only move inwards
      {
        if (random(0, devChance) < 1)
        {
          if (deviation > 0)
          {
            newX = positionX - random(0, devScale);
          } else
          {
            newX = positionX + random(0, devScale);
          }
        }
      }

      positionX = newX;
    }
  }
  
  
  /** 
  * Checks if the particle's position is within the same path
  * 
  * @param path Path to check 
  */
  boolean checkBoundaries(Path path)
  {
    if (abs(path.gradient) <= 1)    //if line is more horizontal than vertical
    {
      if (positionX < min(path.pathStartPoint.x, path.pathEndPoint.x) || positionX > max(path.pathStartPoint.x, path.pathEndPoint.x))
      {
        return true;
      }

      return false;
    } else                            //if line is more vertical than horizontal
    {
      if (positionY < min(path.pathStartPoint.y, path.pathEndPoint.y) || positionY > max(path.pathStartPoint.y, path.pathEndPoint.y))
      {
        return true;
      }
      return false;
    }
  }
  
  /**
  * Select color of dot depending on building use destination and source
  */
  void selectFill()
  {
    color officeWorkerColor = color(102, 217, 226, 200);
    color studentColor = color(255, 137, 49, 200);
    color lightIndustryColor = color(249, 212, 99, 200);
    color residentColor = color(138, 206, 138, 200);
    color visitorColor = color(20, 93, 158, 200);
    
    if (from_buildingUse.equals("Office") || to_buildingUse.equals("Office"))
    {
      flowColor = officeWorkerColor;
    } 
    else if (from_buildingUse.equals("Education") || to_buildingUse.equals("Education"))
    {
      flowColor = studentColor;
    }
    else if (from_buildingUse.equals("Light Industry") || to_buildingUse.equals("Light Industry"))
    {
      flowColor = lightIndustryColor;
    }
    else if (from_buildingUse.equals("Resident") || to_buildingUse.equals("Resident") || 
              from_buildingUse.equals("Student Resident") || to_buildingUse.equals("Student Resident"))
    {
      flowColor = residentColor;
    }
    else if (from_buildingUse.equals("Neighborhood") || to_buildingUse.equals("Neighborhood") 
            || from_buildingUse.equals("Transit") || to_buildingUse.equals("Transit"))
    {
      flowColor = visitorColor;
    }
    else if ((from_buildingUse.equals("Art and Culture") && to_buildingUse.equals("Retail")) 
            || (from_buildingUse.equals("Retail") && to_buildingUse.equals("Art and Culture")))
    {
      int colorChoice = (int)random(1,4);             //for Retail to Art and Culture and vice versa, randomise colours
      switch (colorChoice)
      {
        case 1:
          flowColor = officeWorkerColor;
          break;
         case 2:
           flowColor = studentColor;
           break;
         case 3:
         flowColor = residentColor;
           break;
         case 4:
           flowColor = visitorColor;
           break;  
      }
    }
  }
}