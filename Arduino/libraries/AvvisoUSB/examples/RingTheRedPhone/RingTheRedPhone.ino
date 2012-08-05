//  Copyright (C) 2011 Mike Colagrosso
//  http://colagrosso.net
//
//  This file is part of Avviso: iOS push notifications through Prowl
//
//  Avviso is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as
//  published by the Free Software Foundation, either version 3 of
//  the License, or (at your option) any later version.
//
//  Avviso is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public
//  License along with Avviso. If not, see
//  <http://www.gnu.org/licenses/>.
//

// Sends a push notification to your iOS device via Prowl or Android
// device via Notify My Android.

#include <AvvisoUSB.h>

#define DEBUG 0

int counterValue;

void setup() {
  counterValue = 10;
  Serial.begin(115200);

  // To use Notify My Android instead of Prowl, use this line:
  //Avviso.begin(NOTIFY_MY_ANDROID);
  // and comment out this begin line:
  Avviso.begin();
  // For Prowl, go to
  //   https://www.prowlapp.com/api_settings.php
  // to create an API key.
  // For Notify My Android, go to
  //   https://www.notifymyandroid.com/account.jsp
  // to create an API key.
  // If you don't, the server will return a 401 error code.
  Avviso.setApiKey("0123456789012345678901234567890123456789");

  Avviso.setApplicationName("Arduino Red Phone");
}

void loop() {
  if (counterValue > 0) {
    if (DEBUG) Serial.println(counterValue);
    counterValue--;
    delay(200);
  } else if (counterValue == 0) {
    counterValue--;
    if (DEBUG) Serial.print("Sending push notification...");
    Avviso.push("New event", "The sky is falling!", 0);
    if (DEBUG) Serial.println("OK.");
  }  
}