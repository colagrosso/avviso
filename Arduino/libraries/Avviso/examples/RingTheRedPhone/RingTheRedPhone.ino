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

#include <SPI.h>
#include <Ethernet.h>

#include <HTTPClient.h>
#include <Ethernet.h>
#include <Avviso.h>

#define DEBUG 1

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };

int counterValue;

void setup() {
  counterValue = 10;
  Serial.begin(115200);
  if (DEBUG) Serial.println("Attempting to obtain a DHCP lease...");
  Ethernet.begin(mac);

  if (DEBUG) {
    Serial.print("My IP address: ");
    Ethernet.localIP().printTo(Serial);
    Serial.println();

    Serial.print("Gateway IP address is ");
    Ethernet.gatewayIP().printTo(Serial);
    Serial.println();

    Serial.print("DNS IP address is ");
    Ethernet.dnsServerIP().printTo(Serial);
    Serial.println();
  }

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
    delay(300);
  } else if (counterValue == 0) {
    counterValue--;
    if (DEBUG) Serial.print("Sending push notification...");
    int returnCode = Avviso.push("New event", "The sky is falling!", 0);
    if (returnCode == 200) {
      if (DEBUG) Serial.println("OK.");      
    } else {
      if (DEBUG) Serial.print("Error. Server returned: ");      
      if (DEBUG) Serial.print(returnCode);      
    }
  }  
}
