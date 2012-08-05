/*
This example posts a message to Prowl or Notify My Android directly from
Processing.
*/

import com.avvisoapp.Avviso;
import controlP5.*;

// For Prowl, go to
//   https://www.prowlapp.com/api_settings.php
// to create an API key.
// For Notify My Android, go to
//   https://www.notifymyandroid.com/account.jsp
// to create an API key.
String myApiKey = "0123456789012345678901234567890123456789";
String myApplicationName = "My application";
String myEventName = "New Event";
int priority = 0;

Avviso avviso;
ControlP5 controlP5;
Textfield myTextfield;

void setup() {
  size(400,400);
  smooth();
  background(255);
  fill(0);
  PImage b;
  // Images must be in the "data" directory to load correctly
  b = loadImage("redphone-400.jpg");
  image(b, 0, 20);
  
  controlP5 = new ControlP5(this);

  // To use Notify My Android, use this line to initialize avviso:
  //avviso = new Avviso(Avviso.DeliveryMethod.NOTIFY_MY_ANDROID);
  // and comment out this initialization:
  avviso = new Avviso();
  avviso.setApiKey(myApiKey);
  avviso.setApplicationName(myApplicationName);
  myTextfield = controlP5.addTextfield("Message",100,320,200,20);
  myTextfield.setFocus(true);
  myTextfield.setColorActive(color(255,50,0));
  myTextfield.setColorBackground(color(50,50,50)); 
  myTextfield.setColorLabel(color(0,0,0,0)); 
}

void draw() {
}

public void Message(String theMessage) {
  println("Sending message: " + theMessage);
  avviso.push(myEventName, theMessage, priority);  
}