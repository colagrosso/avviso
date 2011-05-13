//  Copyright (C) 2010 Georg Kaindl
//  http://gkaindl.com
//
//  This file is part of Arduino EthernetDNS.
//
//  EthernetDNS is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as
//  published by the Free Software Foundation, either version 3 of
//  the License, or (at your option) any later version.
//
//  EthernetDNS is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public
//  License along with EthernetDNS. If not, see
//  <http://www.gnu.org/licenses/>.
//

//  Illustrates how to do non-blocking DNS queries via polling.

#if defined(ARDUINO) && ARDUINO > 18
#include <SPI.h>
#endif
#include <Ethernet.h>
#include <EthernetDNS.h>

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };

// substitute an address on your own network here
byte ip[] = { 192, 168, 0, 250 };
// substitute your DNS server ip address
byte dnsServerIp[] = { 192, 168, 0, 1};

// NOTE: Alternatively, you can use the EthernetDHCP library to configure your
//       Ethernet shield and find out the DNS server IP address.

const char* ip_to_str(const uint8_t*);

void setup()
{
  Ethernet.begin(mac, ip);
  
  Serial.begin(9600);
  Serial.println("Enter a host name via the Arduino Serial Monitor to have it "
                 "resolved.");
  
  // You will often want to set your own DNS server IP address (that is
  // reachable from your Arduino board) before doing any DNS queries. Per
  // default, the DNS server IP is set to one of Google's public DNS servers.
  EthernetDNS.setDNSServer(dnsServerIp);
}

void loop()
{ 
  char hostName[512];
  int length = 0;
  
  while (Serial.available()) {
    hostName[length] = Serial.read();
    length = (length+1) % 512;
    delay(50);
  }
  hostName[length] = '\0';
  
  if (length > 0) {
    
    byte ipAddr[4];
    
    Serial.print("Resolving ");
    Serial.print(hostName);
    Serial.print("...");
    
    // Let's send our DNS query. If anything other than DNSSuccess is returned,
    // an error has occurred. A full list of possible return values is
    // available in EthernetDNS.h
    DNSError err = EthernetDNS.sendDNSQuery(hostName);

    if (DNSSuccess == err) {
      do {
        // This will not wait for a reply, but return immediately if no reply
        // is available yet. In this case, the return value is DNSTryLater.
        // We can use this behavior to go on with our sketch while the DNS
        // server and network are busy finishing our request, rather than
        // being blocked and waiting.
        err = EthernetDNS.pollDNSReply(ipAddr);
			
        if (DNSTryLater == err) {
          // You could do real stuff here, or go on with a your loop(). I'm
          // just printing some dots to signal that the query is being
          // processed.
          delay(20);
          Serial.print(".");
        }
      } while (DNSTryLater == err);
    }

    Serial.println();

    // Finally, we have a result. We're just handling the most common errors
    // here (success, timed out, not found) and just print others as an
    // integer. A full listing of possible errors codes is available in
    // EthernetDNS.h
    if (DNSSuccess == err) {
      Serial.print("The IP address is ");
      Serial.print(ip_to_str(ipAddr));
      Serial.println(".");
    } else if (DNSTimedOut == err) {
      Serial.println("Timed out.");
    } else if (DNSNotFound == err) {
      Serial.println("Does not exist.");
    } else {
      Serial.print("Failed with error code ");
      Serial.print((int)err, DEC);
      Serial.println(".");
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
