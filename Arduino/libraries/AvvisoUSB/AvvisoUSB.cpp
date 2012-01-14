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
#include "AvvisoUSB.h"

AvvisoUsbClass::AvvisoUsbClass() {
}

void AvvisoUsbClass::begin() {
  // No-op when using USB
}

void AvvisoUsbClass::setApiKey(char *apiKey) {
  Serial.println("");
  Serial.println("");
  Serial.print("AVVISO_API_KEY ");
  Serial.println(apiKey);
}

void AvvisoUsbClass::setApplicationName(char *applicationName) {
  Serial.print("AVVISO_APPLICATION_NAME ");
  Serial.println(applicationName);  
}

void AvvisoUsbClass::push(char *eventStr, char *messageStr, int priority) {
  Serial.println("");
  Serial.println("");
  Serial.println("AVVISO_PUSH");
  Serial.println(eventStr);  
  Serial.println(messageStr);  
  Serial.println(priority);   
}

AvvisoUsbClass Avviso;