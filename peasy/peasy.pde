import peasy.*;
import SimpleOpenNI.*;
import saito.objloader.*;
import processing.opengl.*;

PeasyCam cam;
SimpleOpenNI kinect;
OBJModel model;

void setup()
{
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLES);
  model.translateToCenter();
  noStroke();
  
  // create camera
  // arguments are for point to look at and distance from that point
  cam = new PeasyCam(this, 0, 0, 0, 1000);
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
  }
}
