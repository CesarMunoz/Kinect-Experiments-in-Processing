import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;
PImage userImage;
int userID;
int[] userMap;
PImage rgbImage;

void setup(){
  size(640, 480, OPENGL);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE);
}

void draw(){
  background(0);
  kinect.update();
  
  //user detected?
  if(kinect.getNumberOfUsers() > 0){
    //what pixels have users?
    userMap = kinect.getUsersPixels(SimpleOpenNI.USERS_ALL);
    //populate pixel array from current content
    loadPixels();
    for(int i=0;i<userMap.length;i++){
      if(userMap[i] != 0){
        pixels[i] = color(0, 255, 0);
      }    
    }    
    //display affected pixels
    updatePixels();
  }
}

void onNewUser(int uID){
  userID = uID;
  println("NEW USER");
}
