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

// Sends a push notification to your iOS device via Prowl

// This example adds DHCP, based on the EthernetDHCP's SynchronousDHCP.pde
// example. Find that example in the Arduino IDE at:
//    File >> Examples >> EthernetDHCP >> SynchronousDHCP
//
// It also adds (synchronous) DNS from EthernetDNS.
//

#if defined(ARDUINO) && ARDUINO > 18
#include <SPI.h>
#endif
#include <Ethernet.h>
#include <EthernetDHCP.h>
#include <EthernetDNS.h>
#include <HTTPClient.h>
#include <Avviso.h>

#define DEBUG 1

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };

int counterValue;

void setup() {
  counterValue = 10;
  Serial.begin(115200);
  if (DEBUG) Serial.println("Attempting to obtain a DHCP lease...");
  EthernetDHCP.begin(mac);

  if (DEBUG) {
    const byte* ipAddr = EthernetDHCP.ipAddress();
    const byte* gatewayAddr = EthernetDHCP.gatewayIpAddress();
    const byte* dnsAddr = EthernetDHCP.dnsIpAddress();

    Serial.println("A DHCP lease has been obtained.");

    Serial.print("My IP address is ");
    Serial.println(ip_to_str(ipAddr));

    Serial.print("Gateway IP address is ");
    Serial.println(ip_to_str(gatewayAddr));

    Serial.print("DNS IP address is ");
    Serial.println(ip_to_str(dnsAddr));
  }

  // Avviso depends on EthernetDNS to look up the address of 
  // api.prowlapp.com. If you remove EthernetDNS, add the IP
  // address manually to the begin() method in Avviso.cpp.
  EthernetDNS.setDNSServer(EthernetDHCP.dnsIpAddress());

  Avviso.begin();
  // Go to
  //   https://www.prowlapp.com/api_settings.php
  // to create an API key.
  // If you don't, the server will return a 401 error code.
  Avviso.setApiKey("0123456789012345678901234567890123456789");

  Avviso.setApplicationName("Arduino Red Phone");
}

void loop() {
  // Call this once per loop().
  EthernetDHCP.maintain();  
  
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

// Just a utility function to nicely format an IP address.
const char* ip_to_str(const uint8_t* ipAddr)
{
  static char buf[16];
  sprintf(buf, "%d.%d.%d.%d\0", ipAddr[0], ipAddr[1], ipAddr[2], ipAddr[3]);
  return buf;
}
