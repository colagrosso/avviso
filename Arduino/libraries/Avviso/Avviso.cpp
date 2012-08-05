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

#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif
#include "Avviso.h"
#include <string.h>
#include <Ethernet.h>
#include <Dns.h>
#include <HTTPClient.h>

#define PROWL_API_HOST "api.prowlapp.com"
#define PROWL_PUSH_PATH_URI "/publicapi/add"

#define NMA_API_HOST "www.notifymyandroid.com"
#define NMA_PUSH_PATH_URI "/publicapi/notify"

#define AVVISO_DEBUG 0

AvvisoClass::AvvisoClass() {
}

void AvvisoClass::begin() {
  begin(PROWL);
}

void AvvisoClass::begin(DeliveryMechanism deliveryMechanism) {

  if (deliveryMechanism == PROWL) {
    notificationServiceHost = PROWL_API_HOST;
    notificationServiceUrlPath = PROWL_PUSH_PATH_URI;
  } else {
    notificationServiceHost = NMA_API_HOST;
    notificationServiceUrlPath = NMA_PUSH_PATH_URI;
  }
  
  // At the time of writing,
  // notificationServiceIpAddr should be
  //    {209, 20, 72, 170} for Prowl
  //    {50, 116, 34, 97} for Notify My Android
  int ret = 0;
  DNSClient dns;
  IPAddress remote_addr;

  dns.begin(Ethernet.dnsServerIP());
  ret = dns.getHostByName(notificationServiceHost, remote_addr);
  if (ret == 1) {
    // Copy the DNS-resolved IPAddress bytes to notificationServiceIpAddr
    for (int i = 0; i < 4; i++) {
        notificationServiceIpAddr[i] = remote_addr[i];
    }
  }
  if (AVVISO_DEBUG) {
    if (ret == 1) {
      Serial.print("The IP address of ");
      Serial.print(notificationServiceHost);
      Serial.print(" is: ");
      remote_addr.printTo(Serial);
      Serial.println(".");
    } else if (ret == -1) {
      Serial.println("Timed out.");
    } else {
      Serial.print("Failed with error code: ");
      Serial.print(ret);
      Serial.println(".");
    }
  }
}

void AvvisoClass::setApiKey(char *aApiKey) {
  strncpy(apiKey, aApiKey, 51);
}

void AvvisoClass::setApplicationName(char *aApplicationName) {
  strncpy(applicationName, aApplicationName, 257);
}

int AvvisoClass::push(char *eventStr, char *messageStr, int priority) {
  if (AVVISO_DEBUG) {
    Serial.println(apiKey);  
    Serial.println(applicationName);  
    Serial.println(eventStr);  
    Serial.println(messageStr);  
    Serial.println(priority);   
  }
  char priorityStr[5];
  sprintf(priorityStr, "%d", priority);

  HTTPClient client(notificationServiceHost, notificationServiceIpAddr);
  http_client_parameter push_arguments[] = {
      { "apikey", apiKey }, 
      { "application", applicationName }, 
      { "event", eventStr }, 
      { "description", messageStr }, 
      { "priority", priorityStr }, 
    { NULL ,NULL }
  };
  FILE* result = client.getURI(notificationServiceUrlPath, push_arguments);
  int returnCode = client.getLastReturnCode();
  if (result!=NULL) {
    client.closeStream(result);
  } 
  else {
    if (AVVISO_DEBUG) {
      Serial.println("failed to connect");      
    }
  }
  if (returnCode==200) {
    if (AVVISO_DEBUG) {
      Serial.println("data uploaded");
    }
  } 
  else {
    if (AVVISO_DEBUG) {
      Serial.print("ERROR: Server returned ");
      Serial.println(returnCode);
    }
  }
  
  return returnCode;
}

AvvisoClass Avviso;
