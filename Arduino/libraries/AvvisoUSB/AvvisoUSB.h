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

#ifndef AVVISO_USB_H
#define AVVISO_USB_H

class AvvisoUsbClass {
  public:
    AvvisoUsbClass();
    void begin();
    void setApiKey(char *apiKey);
    void setApplicationName(char *applicationName);
    void push(char *eventStr, char *messageStr, int priority);

  private:
};

extern AvvisoUsbClass Avviso;

#endif /* AVVISO_USB_H */
