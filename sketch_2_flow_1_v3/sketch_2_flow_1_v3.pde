ArrayList paths = new ArrayList();  //resizable array to store paths
Particle[][] particles;
int[] density;
float lowDensityPerUnit = 0.01;
float highDensityPerUnit = 0.1;
int highestDensity;
int numPaths;
float maxPathDeviation = 5;
PImage img;

void setup() 
{
  //fullScreen();
  size(2048, 1536);
  frameRate(30);
  noStroke();
  fill(130,0, 204, 80);
  img = loadImage("interface.png");
  
  buildPaths();
  
  numPaths = paths.size();
  density = new int[numPaths];
  initDensity();    //find the density of each path
    
  particles = new Particle[numPaths][highestDensity];
  flowInit();      //initialise the positions of the ellipses 
} 


void draw() 
{
  println(frameRate);
  background(img);
  float origX;
  float origY;
  float gradient;
  float constant;
  
  for (int curPath = 0; curPath < numPaths; curPath++)
  {
    Path p1 = (Path)paths.get(curPath);

    for (int i = 0; i < density[curPath]; i++) 
    {
      if (p1.densityLevel == 0) 
      {
        ellipse(particles[curPath][i].x, particles[curPath][i].y, 7, 7);
      }       
      else 
      {
        ellipse(particles[curPath][i].x, particles[curPath][i].y, 7, 7);
      }
      
      origX = particles[curPath][i].x;
      origY = particles[curPath][i].y;
      gradient = pathGradient(p1);
      constant = pathConstant(p1);
      
      particles[curPath][i].x += particles[curPath][i].velX;
      particles[curPath][i].y += particles[curPath][i].velY;
      
      //-----test: get people moving organically-----
      if (abs(gradient) <= 1)
      {
        float standardY = gradient * origX + constant;
        float deviation = particles[curPath][i].y - standardY;
        
        if (abs(deviation) < maxPathDeviation) 
        { 
          if (random(0,15) < 1) 
          {
            particles[curPath][i].y += random(-2,2);
          }
        }
        
        else 
        {
          if (random(0,15) < 1) 
          {
            if (deviation > 0)
            {
              particles[curPath][i].y -= random(-2,2);
            }
            
            else
            {
              particles[curPath][i].y += random(-2,2);
            }
          }
        }
      }
      
      else 
      {
        float standardX = (origY - constant)/gradient;
        float deviation = particles[curPath][i].x - standardX;
        
        if (abs(deviation) < maxPathDeviation) 
        { 
          if (random(0,15) < 1) 
          {
            particles[curPath][i].x += random(-2,2);
          }
        }
        
        else 
        {
          if (random(0,15) < 1) 
          {
            if (deviation > 0)
            {
              particles[curPath][i].x -= random(-2,2);
            }
            
            else
            {
              particles[curPath][i].x += random(-2,2);
            }
          }
        }
      }
      
      //---------------------------------------------
      
      
      
      
      //if the particle travels outside the path, bring it back to the start
      if (p1.end.x - p1.start.x == 0)
      {        
         if ((p1.end.y - p1.start.y > 0 && particles[curPath][i].y > p1.end.y) || (p1.end.y - p1.start.y < 0 && particles[curPath][i].y < p1.end.y))
         { 
          particles[curPath][i].x = p1.start.x;
          particles[curPath][i].y = p1.start.y;
         }
      } 
      
      else if (abs(gradient) <= 1) 
      {
        if (p1.end.x - p1.start.x < 0 && particles[curPath][i].x < p1.end.x)
        {
          particles[curPath][i].x = p1.start.x;
          particles[curPath][i].y = p1.start.y;
        } 
      
        else if (p1.end.x - p1.start.x > 0 && particles[curPath][i].x > p1.end.x)
        {
           particles[curPath][i].x = p1.start.x;
           particles[curPath][i].y = p1.start.y;
        }
      }
      
      else
      {
        if (p1.end.y - p1.start.y < 0 && particles[curPath][i].y < p1.end.y)
        {
          particles[curPath][i].x = p1.start.x;
          particles[curPath][i].y = p1.start.y;
        } 
      
        else if (p1.end.y - p1.start.y > 0 && particles[curPath][i].y > p1.end.y)
        {
           particles[curPath][i].x = p1.start.x;
           particles[curPath][i].y = p1.start.y;
        }
      }
    }
  }
}


void buildPaths()
{
  paths.add(new Path(new PVector(1, 682), new PVector(1050, 424), 1));
  paths.add(new Path(new PVector(173, 638), new PVector(175, 482),0));
  paths.add(new Path(new PVector(175, 482), new PVector(539, 440),0));
  paths.add(new Path(new PVector(243, 451), new PVector(243, 473),1));
  paths.add(new Path(new PVector(275, 517), new PVector(283, 517),1));
  paths.add(new Path(new PVector(283, 517), new PVector(295, 608),1));
  paths.add(new Path(new PVector(281, 517), new PVector(288, 323),0));
  paths.add(new Path(new PVector(288, 323), new PVector(405, 325),0));
  paths.add(new Path(new PVector(403, 436), new PVector(405, 325),1));
  paths.add(new Path(new PVector(403, 436), new PVector(432, 575),0));
  paths.add(new Path(new PVector(343, 462), new PVector(344, 456),0));
  paths.add(new Path(new PVector(358, 569), new PVector(364, 593),1));
  paths.add(new Path(new PVector(460, 547), new PVector(465, 569),0));
  paths.add(new Path(new PVector(538, 441), new PVector(566, 543),1));
  paths.add(new Path(new PVector(538, 441), new PVector(962, 339),0));
  paths.add(new Path(new PVector(683, 381), new PVector(688, 404),1));
  paths.add(new Path(new PVector(964, 337), new PVector(973, 385),1));
  paths.add(new Path(new PVector(973, 385), new PVector(1037, 374),1));
  paths.add(new Path(new PVector(1036, 361), new PVector(1049, 423),0));
}


void initDensity()    //find the density for each path
{
  highestDensity = 0;
    
  for (int curPath = 0; curPath < numPaths; curPath++)
  {
    Path p1 = (Path)paths.get(curPath);
    PVector v1 = p1.start;
    PVector v2 = p1.end;
    
    float pathLength = PVector.dist(v1, v2);
    float densityPerUnit;
    
    if (p1.densityLevel == 0) 
    {
      densityPerUnit = lowDensityPerUnit;
    } 
    
    else 
    {
      densityPerUnit = highDensityPerUnit;
    }
    
    density[curPath] = (int)(pathLength * densityPerUnit);
    
    if (density[curPath] > highestDensity)
    {
      highestDensity = density[curPath];
    }
  }
}


void flowInit()       //randomise the position of particles in the path
{
  float valX;
  float valY;
      
  float velocity;
  float gradient;
  float anglePath;
  float deltaX;
  float deltaY;
  
  for (int curPath = 0; curPath < numPaths; curPath++) 
  {
    Path p1 = (Path)paths.get(curPath);
    
    for (int i = 0; i < density[curPath]; i++) 
    {
      velocity = random(1,2);
      gradient = pathGradient(p1);
      anglePath = atan(gradient);
      deltaX = abs(velocity * cos(anglePath));
      deltaY = abs(velocity * sin(anglePath));
      
      if (p1.end.x - p1.start.x == 0)        //if vertical line
      {
        valX = p1.start.x;
        
        if (p1.end.y - p1.start.y > 0)
        {
          valY = random(p1.start.y, p1.end.y);
        } 
        else 
        {
          valY = random(p1.end.y, p1.start.y);
          deltaY = deltaY * -1;
        }
      } 
      else if (p1.end.y - p1.start.y == 0)   //if horizontal line
      {
        valY = p1.start.y;
        
        if (p1.end.x - p1.start.x > 0)
        {
           valX = random(p1.start.x, p1.end.x);
        }
        else 
        {
            valX = random(p1.end.x, p1.start.x);
            deltaX = deltaX * -1;
        }
      } 
      else                                 //if diagonal line
      {        
        valX = random(p1.start.x, p1.end.x);
        
        if (p1.end.x - p1.start.x < 0)
        {
          valX = random(p1.end.x, p1.start.x);
          deltaX = deltaX * -1;
        } 
        
        if (p1.end.y - p1.start.y < 0)
        {
          deltaY = deltaY * -1;
        }
        
        valY = gradient*valX+pathConstant(p1);
      }
      
      particles[curPath][i] = new Particle(valX, valY, deltaX, deltaY);
      
    }
  }
}


float pathGradient(Path p1)       //find the gradient of the path (y = mx + c), to be used to find value of y
{
  float step = (p1.end.y - p1.start.y)/(p1.end.x - p1.start.x); 
  return (step);
}


float pathConstant(Path p1)       //find the constant of the path (y = mx + c), to be used to find value of y
{
  float constant = p1.start.y - p1.start.x*pathGradient(p1); 
  return (constant);
}


class Path 
{
  PVector start;
  PVector end;
  int densityLevel;
  
  Path(PVector startLoc, PVector endLoc, int densityLvl) 
  {
    this.start = startLoc;
    this.end = endLoc;
    this.densityLevel = densityLvl;
  }
}


class Particle
{
    float x;
    float y;
    float velX;
    float velY;
    
    Particle(float xPos, float yPos, float xVelocity, float yVelocity)
    {
      this.x = xPos;
      this.y = yPos;
      this.velX = xVelocity;
      this.velY = yVelocity;
    }
}

//to get coordinates of the paths
//void mousePressed() 
//{
//  println("x1=     "+mouseX + "          y1=     "+mouseY);
//}