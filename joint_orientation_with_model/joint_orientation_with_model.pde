import processing.opengl.*;
import SimpleOpenNI.*;
import saito.objloader.*;

SimpleOpenNI kinect;
OBJModel model;
PImage colorImage;
boolean gotImage;

void setup(){
  size(1028, 768, OPENGL);
  
  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLES);
  model.translateToCenter();
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
  
  fill(255, 0, 0);
}

void draw(){
  kinect.update();
  background(0);
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  
  scale(0.9);
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if(userList.size() > 0){
    int userID = userList.get(0);
    
    if(kinect.isTrackingSkeleton(userID)){
      PVector position = new PVector();
      kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW, position);
      PMatrix3D orientation = new PMatrix3D();
      float confidence = kinect.getJointOrientationSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW, orientation);
      pushMatrix();
        translate(position.x, position.y, position.z);
        applyMatrix(orientation);
        model.draw();
      popMatrix();
    }
  }
  
}

//user-tracking callbacks
void onNewUser(int userID){
  println("start pose detection");
  kinect.startPoseDetection("Psi", userID);
}

void onEndCalibration(int userID, boolean successful){
  if(successful)
  {
    println("  User calibrated!!!");
    kinect.startTrackingSkeleton(userID);
  }else{
    println("  Failed to calibrate user!!!");
    kinect.startPoseDetection("Psi", userID);
  }
}

void onStartPose(String pose, int userID){
  println("Started pose for user");
  kinect.stopPoseDetection(userID);
  kinect.requestCalibrationSkeleton(userID, true);
}
