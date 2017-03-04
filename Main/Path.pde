/**
 * The Path class represents each graph edge on the map that has a flow running.
 */

class Path 
{
  int maxPathDeviation = 5;    //how far the particles deviate from the standard path
  int devChance = 10;          //chance of particle deviating: a higher value means a lower chance
  int devScale = 3;            //how large each deviating step is
  int particleSize = 15;       //size of particle drawn on the map
  int randomVelocity = 3;      //the lower value of how fast the particles move

  float density;
  float velocity;
  float dis_x;
  float dis_y;
  float gradient;
  float constant;
  PVector pathStartPoint;
  PVector pathEndPoint;
  ArrayList<GraphNode> nodes;
  ArrayList<PVector> particlePos;
  ArrayList<PVector> particleVelocity;


  /**
   * The Path constructor
   * @param start x and y value of start point
   * @param end x and y value of end point
   * @param d the density of path from intial to dest
   */

  Path (PVector start, PVector end, float d) 
  {
    pathStartPoint = start;
    pathEndPoint = end;
    dis_x = end.x - start.x;
    dis_y = end.y - start.y;
    gradient = dis_y / dis_x;
    constant = start.y - (start.x * gradient);
    density = d;
    particlePos = new ArrayList<PVector>();
    particleVelocity = new ArrayList<PVector>();
  }

  /*
  *  Finds the actual density of the path by multiplying the density per unit with the length
   */
  float calcFinalDensity()
  {
    float pathLength = PVector.dist(pathEndPoint, pathStartPoint);
    return density * pathLength;
  }

  /*
  *  Initializes the position and velocities of each particle on the path
   */
  void particleInit()
  {
    for (int i = 0; i < density; i++)
    {
      velocity = random(randomVelocity, randomVelocity + 1);
      float posX;
      float posY;
      float angle = atan(gradient);

      float deltaX = abs(velocity * cos(angle));
      float deltaY = abs(velocity * sin(angle));

      if (dis_x == 0 || dis_y == 0)     //if vertical or horizontal line
      {
        posX = random(min(pathStartPoint.x, pathEndPoint.x), max(pathStartPoint.x, pathEndPoint.x));
        posY = random(min(pathStartPoint.y, pathEndPoint.y), max(pathStartPoint.y, pathEndPoint.y));
      } else
      {
        posX = random(min(pathStartPoint.x, pathEndPoint.x), max(pathStartPoint.x, pathEndPoint.x));
        posY = gradient * posX + constant;
      }

      if (dis_x < 0) 
      {
        deltaX *= -1;
      }

      if (dis_y < 0) 
      {
        deltaY *= -1;
      }

      PVector position = new PVector(posX, posY);
      PVector velVector = new PVector(deltaX, deltaY);

      particlePos.add(position);
      particleVelocity.add(velVector);
    }
  }

  void run()
  {
    noStroke();
    fill(130, 0, 204, 80);
    for (int i = 0; i < particlePos.size(); i++)
    {
      PVector nextPos;

      this.particlePos.get(i).x += particleVelocity.get(i).x;
      this.particlePos.get(i).y += particleVelocity.get(i).y;

      nextPos = randomizeMovement(particlePos.get(i));
      nextPos = checkBoundaries(nextPos);

      particlePos.get(i).x = nextPos.x;
      particlePos.get(i).y = nextPos.y;

      ellipse(particlePos.get(i).x, particlePos.get(i).y, particleSize, particleSize);
    }
  }



  /*
  *  Make the particle move more organically by giving it a chance to deviate from the path.
   */

  PVector randomizeMovement(PVector position)
  {
    if (abs(gradient) <= 1)    //if line is more horizontal than vertical
    {
      float standardY = gradient * position.x + constant;
      float deviation = position.y - standardY;
      float newY = position.y;
      PVector newPos;

      if (abs(deviation) < maxPathDeviation)    //if the current deviation is less than standard, it can deviate both ways
      {
        if (random(0, devChance) < 1)
        {
          newY = position.y + random(-1*devScale, devScale);
        }
      } else if (abs(deviation) >= maxPathDeviation)    //if the current deviation is maximum, it can only move inwards
      {
        if (random(0, devChance) < 1)
        {
          if (deviation > 0)
          {
            newY = position.y - random(0, devScale);
          } else
          {
            newY = position.y + random(0, devScale);
          }
        }
      }

      newPos = new PVector (position.x, newY);
      return newPos;
    } else                            //if line is more vertical than horizontal
    {
      float standardX = (position.y - constant) / gradient;
      float deviation = position.x - standardX;
      float newX = position.x;
      PVector newPos;

      if (abs(deviation) < maxPathDeviation)    //if the current deviation is less than standard, it can deviate both ways
      {
        if (random(0, devChance) < 1)
        {
          newX = position.x + random(-1*devScale, devScale);
        }
      } else if (abs(deviation) >= maxPathDeviation)    //if the current deviation is maximum, it can only move inwards
      {
        if (random(0, devChance) < 1)
        {
          if (deviation > 0)
          {
            newX = position.x - random(0, devScale);
          } else
          {
            newX = position.x + random(0, devScale);
          }
        }
      }

      newPos = new PVector (newX, position.y);
      return newPos;
    }
  }



  /*
  *  Check if the particle has moved beyond the path. If so, bring it back to the start
   */

  PVector checkBoundaries(PVector position)
  {
    if (abs(gradient) <= 1)    //if line is more horizontal than vertical
    {
      if (position.x < min(pathStartPoint.x, pathEndPoint.x) || position.x > max(pathStartPoint.x, pathEndPoint.x))
      {
        return pathStartPoint;
      }

      return position;
    } else                            //if line is more vertical than horizontal
    {
      if (position.y < min(pathStartPoint.y, pathEndPoint.y) || position.y > max(pathStartPoint.y, pathEndPoint.y))
      {
        return pathStartPoint;
      }
      return position;
    }
  }
}