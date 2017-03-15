/**
 * The Particle class represents each dot on the map.
 */

class Particle
{
  int maxPathDeviation = 5;    //how far the particles deviate from the standard path
  int devChance = 10;          //chance of particle deviating: a higher value means a lower chance
  int devScale = 3;            //how large each deviating step is
  int particleSize = 15;       //size of particle drawn on the map
  float randomVelocity = 5.0;  //the lower value of how fast the particles move
  
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
    vectorVelocity = random(randomVelocity, randomVelocity + 1);
    currentPathIndex = 0;
    isEndOfRoute = false;
    paths = new ArrayList<Path>();
    
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
    //selectFill();          //colours of dots by from_use
    fill(130, 0, 204, 100);
    
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
  
  //set the colour of the partcles based on the buildingUse they come from
  void selectFill()
  {
     if (from_buildingUse == "Retail")
    {
      fill(#EA6C90, 200);
    }
    else if (from_buildingUse == "Art and Culture")
    {
      fill(#AA96CC, 200);
    }
    else if (from_buildingUse == "Light Industry")
    {
      fill(#8ACE8A, 200);
    }
    else if (from_buildingUse == "Business")
    {
      fill(#66D9E2, 200);
    }
    else if (from_buildingUse == "Resident")
    {
      fill(#F9D463, 200);
    }
    else
    {
      fill(130, 0, 204, 200);
    }
  }
}