import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup(){
  size(1028, 768, OPENGL);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
  
  fill(255, 0, 0);
}

void draw(){
  kinect.update();
  background(255);
  
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if(userList.size() > 0)  {
    int userID = userList.get(0);
    
    if(kinect.isTrackingSkeleton(userID))    {
      PVector position = new PVector();
      kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_TORSO, position);
      
      PMatrix3D orientation = new PMatrix3D();
      //confidence
      float confidence = kinect.getJointOrientationSkeleton(userID, SimpleOpenNI.SKEL_TORSO, orientation);
      println("confidence: "+ confidence);
      
      drawSkeleton(userID);
      
      pushMatrix();
        //move to position of skeleton to TORSO position
        translate(position.x, position.y, position.z);
        //adpot torso's orientation to be our coordinate system
        applyMatrix(orientation);
        // draw lines x, y, z
        stroke(255, 0, 0);
        strokeWeight(3);
        line(0, 0, 0, 150, 0, 0);
        
        stroke(0, 255, 0);
        line(0, 0, 0, 0, 150, 0);
        
        stroke(0, 0, 255);
        line(0, 0, 0, 0, 0, 150);
      popMatrix();      
    }
  }
}

void drawSkeleton(int userID){
  drawLimb(userID, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  
  drawLimb(userID, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawLimb(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawLimb(userID, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  
  drawLimb(userID, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  
  drawLimb(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  
  drawLimb(userID, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  drawLimb(userID, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawLimb(userID, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  
  drawLimb(userID, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  
  drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
}

void drawLimb(int userID, int jointType1, int jointType2){
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float confidence; //confidence
  
  confidence = kinect.getJointPositionSkeleton(userID, jointType1, jointPos1);
  confidence += kinect.getJointPositionSkeleton(userID, jointType2, jointPos2);
  
  stroke(100);
  strokeWeight(5);
  if(confidence > 1){
   line(jointPos1.x, jointPos1.y, jointPos1.z, jointPos2.x, jointPos2.y, jointPos2.z); 
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
