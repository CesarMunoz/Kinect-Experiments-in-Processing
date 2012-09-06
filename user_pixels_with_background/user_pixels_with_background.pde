import SimpleOpenNI.*;

SimpleOpenNI kinect;
boolean tracking = false;
PImage backgroundImage;
int userID;
int[] userMap;

void setup(){
  size(640, 480);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE);
  kinect.alternativeViewPointDepthToImage();
  
  backgroundImage = loadImage("pr_beach.jpg");
  backgroundImage.resize(640, 480);
}

void draw(){
  //display the bg image
  image(backgroundImage, 0, 0);
  kinect.update();
  
  if(tracking){
    PImage rgbImage = kinect.rgbImage();
    //prep color pixels
    rgbImage.loadPixels();
    loadPixels();
    
    userMap = kinect.getUsersPixels(SimpleOpenNI.USERS_ALL);
    for(int i=0;i<userMap.length;i++){
      //if pixel is part of user
      if(userMap[i] != 0){
       // set pixel color
       pixels[i] = rgbImage.pixels[i]; 
      }
    }
    updatePixels();
  }
}

void onNewUser(int uID){
  userID = uID;
  tracking = true;
  println("TRACKING");
}
