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

//  Illustrates how to do synchronous (blocking) DNS queries.

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
                 " resolved.");
  
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
    Serial.println("...");
    
    // Resolve the host name and block until a result has been obtained.
    // This means that the call will not return until a result has been found
    // or the query times out. While it is less effort to write a query this
    // way, the problem is that the whole sketch will "hang", which might not
    // be what you want. If you want to retain control over the sketch while
    // the query is being processed, check out the PollingDNS example.
    DNSError err = EthernetDNS.resolveHostName(hostName, ipAddr);
    
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
