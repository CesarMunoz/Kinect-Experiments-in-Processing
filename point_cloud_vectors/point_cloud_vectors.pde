import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;

// current roation value in degrees
float rotation =0;
int zDepth = 1100;
void setup()
{
  size(1024,768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  //line up color pixels with depth data
  kinect.alternativeViewPointDepthToImage();
}

void draw()
{
  background(0);
  
  kinect.update();
  
  // load RGB image
  PImage rgbImage = kinect.rgbImage();
  
  //prepare to draw centered x-y
  // pull z axis in by 1000
  translate(width/2, height/2, -zDepth);
  //flip y axis
  //rotate(radians(180));
  
  //flip point cloud vertically
  rotateX(radians(180));
  
  //move the center of rotation
  //to inside the point cloud
  translate(0, 0, zDepth);
  
  // rotate around y axis and bump rotation val
  //rotateY(radians(rotation));
  //rotation++;
  
  // rotate around y axis based on mouse position
  float mouseRotation = map(mouseX, 0, width, -180, 180);
  rotateY(radians(mouseRotation));
  
  //stroke(255);
  
  // get depth data as 3D points
  PVector[] depthPoints = kinect.depthMapRealWorld();
  
//  // draw every 10th point for speed's sake
//  for(int i=0; i<depthPoints.length; i+=10)
//  {
//    PVector currentPoint = depthPoints[i];
//    
//    //draw current point
//    point(currentPoint.x, currentPoint.y, currentPoint.z);
//  }
  
  // draw all color points
  for(int i=0; i<depthPoints.length; i++)
  {
    PVector currentPoint = depthPoints[i];
    stroke(rgbImage.pixels[i]);
    //draw current point
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
}
