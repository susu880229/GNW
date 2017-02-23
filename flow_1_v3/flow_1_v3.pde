ArrayList paths = new ArrayList();  //resizable array to store paths
PVector[][] people;
int density = 50;     

void setup() {
  fullScreen();
  background(255);  
  stroke(125, 50);
  fill(0, 150, 255, 50);
  
  paths.add(new Path(new PVector(60, 500), new PVector(1900, 1000)));
  paths.add(new Path(new PVector(0, 0), new PVector(1900, 1900)));
  paths.add(new Path(new PVector(100, 299), new PVector(200, 1000)));
  paths.add(new Path(new PVector(300, 500), new PVector(550, 820)));
  paths.add(new Path(new PVector(470, 200), new PVector(700, 569)));
  paths.add(new Path(new PVector(230, 1000), new PVector(900, 130)));
  paths.add(new Path(new PVector(890, 10), new PVector(1200, 430)));
  paths.add(new Path(new PVector(650, 700), new PVector(1500, 250)));
  paths.add(new Path(new PVector(500, 300), new PVector(1300, 700)));
  paths.add(new Path(new PVector(900, 850), new PVector(1700, 354)));
  paths.add(new Path(new PVector(200, 753), new PVector(1600, 236)));
  paths.add(new Path(new PVector(460, 572), new PVector(1500, 173)));
  paths.add(new Path(new PVector(500, 474), new PVector(1800, 235)));
  paths.add(new Path(new PVector(1080, 547), new PVector(1780, 567)));
  
  people = new PVector[paths.size()][density];
  noStroke();
  flowInit();      //initialise the positions of the ellipses
  
} 

void draw() {
  background(255);
  println(frameRate);
  
  for (int numPaths = 0; numPaths < paths.size(); numPaths++){
    Path p1 = (Path)paths.get(numPaths);
  
    for (int i = 0; i < density; i++) {
  
      people[numPaths][i].x += people[numPaths][i].z;    //people[i].z is where the velocity is stored
    
      if (people[numPaths][i].x > p1.end.x){
       people[numPaths][i].x = p1.start.x;     //if the particle travels outside the path, bring it back to the start
      }
    
      people[numPaths][i].y = people[numPaths][i].x * pathGradient(p1) + pathConstant(p1);    //calculate the corresponding value
    
      //-----test: get people moving organically-----
      //if (i % 3 == 1) {
      //  people[i].y += 15;
      //} else if (i % 3 == 2) {
      //  people[i].y -= 15;
      //}
      //---------------------------------------------
    
      ellipse(people[numPaths][i].x, people[numPaths][i].y, 10, 10);
    }
  }
}

void flowInit() {
  
  for (int numPaths = 0; numPaths < paths.size(); numPaths++) {
    
    Path p1 = (Path)paths.get(numPaths);
    line(p1.start.x, p1.start.y, p1.end.x, p1.end.y);
    
    for (int i = 0; i < density; i++) {
      float valX = random(p1.start.x, p1.end.x);  //randomise the start position of each particle
      float velocityX = random(1,2);              //store the velocity in the z value of the vector 
      people[numPaths][i] = new PVector(valX, pathGradient(p1)*valX+pathConstant(p1), velocityX);
      
      //ellipse(people[numPaths][i].x, people[numPaths][i].y, 20, 20);
    }
  }
}

//find the gradient of the path (y = mx + c), to be used to find value of y
float pathGradient(Path p1) {
  float step = (p1.end.y - p1.start.y)/(p1.end.x - p1.start.x); 
  return (step);
}

//find the constant of the path (y = mx + c), to be used to find value of y
float pathConstant(Path p1) {
  float constant = p1.start.y - p1.start.x*pathGradient(p1); 
  return (constant);
}

class Path {
  PVector start;
  PVector end;
  
  Path(PVector startLoc, PVector endLoc) {
    this.start = startLoc;
    this.end = endLoc;
  }
  
  void draw() {
    line(start.x, start.y, end.x, end.y);
  }
}