/**
 * The Particle class represents each dot on the map.
 */

class Particle
{
  int maxPathDeviation = 5;    //how far the particles deviate from the standard path
  int devChance = 10;          //chance of particle deviating: a higher value means a lower chance
  int devScale = 3;            //how large each deviating step is
  int particleSize = 15;       //size of particle drawn on the map
  float randomVelocity = 8.0;  //the lower value of how fast the particles move
  
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
    vectorVelocity = random(randomVelocity, randomVelocity + 3);
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
    
    ellipse(positionX, positionY, particleSize, particleSize);
    
    boolean isOutOfBounds = false;

    positionX += velocityX;
    positionY += velocityY;
    
    randomizeMovement(paths.get(currentPathIndex));
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
  
  
  //check if the particle's position is within the same path.
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
  
  void selectFill()
  {
     if (from_buildingUse == "Business" || to_buildingUse == "Business")
    {
      flowColor = color(102, 217, 226, 200);
    } 
    else if (from_buildingUse == "Education" || to_buildingUse == "Education")
    {
      flowColor = color(255, 137, 49, 200);
    }
    else if (from_buildingUse == "Light Industry" || to_buildingUse == "Light Industry")
    {
      flowColor = color(249, 212, 99, 200);
    }
    else if (from_buildingUse == "Resident" || to_buildingUse == "Resident" || 
              from_buildingUse == "Student Resident" || to_buildingUse == "Student Resident")
    {
      flowColor = color(138, 206, 138, 200);
    }
    else if (from_buildingUse == "Neighborhood" || to_buildingUse == "Neighborhood" 
            || from_buildingUse == "Transit" || to_buildingUse == "Transit")
    {
      flowColor = color(20, 93, 158, 200);
    }
    else if ((from_buildingUse == "Art and Culture" && to_buildingUse == "Retail") 
            || (from_buildingUse == "Retail" && to_buildingUse == "Art and Culture"))
    {
      int colorChoice = (int)random(1,4);             //for Retail to Art and Culture and vice versa, randomise colours
      switch (colorChoice)
      {
        case 1:
          flowColor = color(102, 217, 226, 200);
          break;
         case 2:
           flowColor = color(255, 137, 49, 200);
           break;
         case 3:
         flowColor = color(138, 206, 138, 200);
           break;
         case 4:
           flowColor = color(20, 93, 158, 200);
           break;  
      }
    }
  }
}
