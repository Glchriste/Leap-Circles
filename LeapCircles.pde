//Author: Grace Christenbery
//Disclaimer: Use this code however you like. You should learn how to get the pixels your finger is pointing at (relative to the Processing app window) from this example.

import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.FingerList;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Vector;
import com.leapmotion.leap.Screen;
import com.leapmotion.leap.processing.LeapMotion;

LeapMotion leapMotion;
float[] pixelPoint = new float[2];

void setup()
{
    background(0);
    frameCount = 0;
    
    //int w = displayWidth;
    //int h = displayWidth;

    int w = 16*50;
    int h = 9*50;
  
    size(w, h);
    frameRate(40);

    leapMotion = new LeapMotion(this);
    
    pixelPoint[0] = 0;
    pixelPoint[1] = 0;
}

void draw()
{
    //Draw whatever you want.
    ellipse(pixelPoint[0],pixelPoint[1],30,30);
}

void onInit(final Controller controller)
{
    println("Initialized");
}

void onConnect(final Controller controller)
{
    println("Connected");
}

void onDisconnect(final Controller controller)
{
    println("Disconnected");
}

void onExit(final Controller controller)
{
    println("Exited");
}

void onFrame(final Controller controller)
{
    println("Frame");
    Frame frame = controller.frame();
    println("Frame id: " + frame.id()
      + ", timestamp: " + frame.timestamp()
      + ", hands: " + frame.hands().count()
      + ", fingers: " + frame.fingers().count()
      + ", tools: " + frame.tools().count());
    
    // Get the first hand
    Hand hand = frame.hands().get(0);
    // Get fingers
    FingerList fingers = hand.fingers();
      
    if (!frame.hands().empty()) {
    
    //Check if the hand has fingers.
    if (!fingers.empty()) {
      
      //Calculate the hand's average finger tip position
      Vector avgPos = Vector.zero();
      for (Finger finger : fingers) {
        avgPos = avgPos.plus(finger.tipPosition());
      }
      avgPos = avgPos.divide(fingers.count());
      println("Hand has " + fingers.count() + " fingers, average finger tip position: " + avgPos);
      
      //Tell the position of the leaper's (user's) fingertip.
      Screen screen = controller.calibratedScreens().get(0);
      Vector bottomLeftCorner = screen.bottomLeftCorner();
      Finger pointer = fingers.get(0);
      Vector point = pointer.tipPosition();
      println("You are pointing at: " + point);
      float distance = screen.distanceToPoint(point);
      println("The distance from the screen to your finger tip is: " + distance + "mm");
      
      //Tell what point on the screen the leaper is pointing at.
      Vector screenPoint = screen.intersect(pointer, true);
      println("You are pointing at this point on the screen: " + screenPoint);
      //The vector of the bottom left corner
      println("Bottom-left Corner: " +  bottomLeftCorner);
      
      //Tell what pixel coordinate the leaper is pointing to.
      float pixelX = width*screenPoint.get(0);
      //Without subtracting from 1, the Y is inverted.
      float pixelY = height*(1-abs(screenPoint.get(1)));
      println("X Pixel: " + pixelX + "Y Pixel: " + pixelY);
      
      //Give the pixel values to pixelPoint for the draw() function.
      pixelPoint[0] = pixelX;
      pixelPoint[1] = pixelY;
      
    }
  }
  
  //Get the hand's normal vector and direction
  Vector normal = hand.palmNormal();
  Vector direction = hand.direction();
  
  //Calculate the hand's pitch, roll, and yaw angles
  println("Hand pitch: " + Math.toDegrees(direction.pitch()) + " degrees, "
    + "roll: " + Math.toDegrees(normal.roll()) + " degrees, "
    + "yaw: " + Math.toDegrees(direction.yaw()) + " degrees\n");
    

  
  
}
