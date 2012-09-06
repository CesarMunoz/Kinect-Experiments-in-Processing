import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestVal;
int closestX;
int closestY;

float lastX;
float lastY;

float img1X;
float img1Y;
float img1Scale;
int img1Width = 100;
int img1Height = 100;

float img2X;
float img2Y;
float img2Scale;
int img2Width = 100;
int img2Height = 100;

float img3X;
float img3Y;
float img3Scale;
int img3Width = 100;
int img3Height = 100;

int currentImage = 1;

//boolean imageMoving;

PImage img1;
PImage img2;
PImage img3;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  //start image moving so mouse press will drop it
  //imageMoving = true;
  //load image
  img1 = loadImage("Untitled1.jpg");
  img2 = loadImage("Untitled2.jpg");
  img3 = loadImage("Untitled3.jpg");
  
  background(0);
}

void draw()
{
  closestVal = 8000;
  
  kinect.update();
  
  int[] depthValues = kinect.depthMap();
  
  for(int y=0; y<480; y++)
  {
    for(int x=0; x<640; x++)
    {
      int reversedX = 640-x-1;
     // println("reversedX: "+reversedX);
      int i = reversedX+y*640;
      int currentDepthVal = depthValues[i];
      
      if(currentDepthVal>450
          && currentDepthVal<1000
          && currentDepthVal<closestVal)
      {
        closestVal = currentDepthVal;
        closestX = x;
        closestY = y;
      }
    }
  }
  
//  // draw image on screen
//  image(kinect.depthImage(),0,0);
//
//  //draw red circle to interact with at x, y and closest pixel
//  fill(255,0,0);
//  ellipse(closestX, closestY, 25, 25);
  
  float interpolatedX = lerp(lastX, closestX, 0.3);
  float interpolatedY = lerp(lastY, closestY, 0.3);
  
  // clear previous drawing
  background(0);
  
  // select current image
  switch(currentImage)
  {
    case 1:
      //update x,y
      img1X = interpolatedX;
      img1Y = interpolatedY;
      // update scale based on closestVal
      img1Scale = map(closestVal, 450, 1000, 0, 4);
     break;
     case 2:
      //update x,y
      img2X = interpolatedX;
      img2Y = interpolatedY;
      // update scale based on closestVal
      img2Scale = map(closestVal, 450, 1000, 0, 4);
     break;
     case 3:
      //update x,y
      img3X = interpolatedX;
      img3Y = interpolatedY;
      // update scale based on closestVal
      img3Scale = map(closestVal, 450, 1000, 0, 4);
     break;
  }
  //only update image if it is moving
//  if(imageMoving)
//  {
//    //println("lastX: "+lastX+"  closestX: "+closestX+"  interpolatedX: "+interpolatedX);
//    img1X = interpolatedX;
//    img1Y = interpolatedY;
//  }
  
  //draw image
  image(img1, img1X, img1Y, img1Width*img1Scale, img1Height*img1Scale);
  image(img2, img2X, img2Y, img2Width*img2Scale, img2Height*img2Scale);
  image(img3, img3X, img3Y, img3Width*img3Scale, img3Height*img3Scale);
  
  lastX = interpolatedX;
  lastY = interpolatedY;
}

void mousePressed()
{
  // drop image/move image
  //imageMoving = !imageMoving;
  currentImage++;
  if(currentImage>3)
  {
    currentImage = 1;
  }
}
