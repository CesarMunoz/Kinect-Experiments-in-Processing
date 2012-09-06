import processing.opengl.*;
import SimpleOpenNI.*;
import saito.objloader.*;
import peasy.*;

PeasyCam cam;
SimpleOpenNI kinect;
OBJModel model;
Hotpoint hp1;
Hotpoint hp2;

void setup()
{
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLE);
  model.translateToCenter();
  noStroke();
  
  cam = new PeasyCam(this, 0, 0, 0, 1000);
  
  hp1 = new Hotpoint(200, 200, 800, 150);
  hp2 = new Hotpoint(-200, 200, 800, 150);
}

void draw()
{
  background(0);
  kinect.update();
  
  rotateX(radians(180));
  
  lights();
  noStroke();
  
  pushMatrix();
    rotateX(radians(-90));
    rotateZ(radians(180));
    model.draw();
  popMatrix();
  
  stroke(255);
  
  PVector[] depthPoints = kinect.depthMapRealWorld();
  
  for(int i=0; i<depthPoints.length; i+=10)
  {
    PVector cp = depthPoints[i];
    point(cp.x, cp.y, cp.z);
    
    hp1.check(cp);
    hp2.check(cp);
  }
  
  hp1.draw();
  hp2.draw();
    
    if(hp1.isHit())
    {
      cam.lookAt(hp1.center.x, hp1.center.y*-1, hp1.center.z*-1, 500, 500);
    }
    
    if(hp2.isHit())
    {
      cam.lookAt(hp2.center.x, hp2.center.y*-1, hp2.center.z*-1, 500, 500);
    }
    
    hp1.clear();
    hp2.clear();
}
