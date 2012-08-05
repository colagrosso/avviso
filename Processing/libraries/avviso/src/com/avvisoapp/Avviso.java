/**
 * Avviso: iOS push notifications from an Arduino using Prowl and
 * Notify My Android.
 *
 * (c) 2011 Mike Colagrosso
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 * 
 * @author      Mike Colagrosso http://colagrosso.net
 * @modified    08/05/2012
 * @version     1.0
 */

package com.avvisoapp;

import com.usk.lib.NMAClientLib;
import net.sourceforge.prowl.api.DefaultProwlEvent;
import net.sourceforge.prowl.api.ProwlClient;
import net.sourceforge.prowl.api.ProwlEvent;
import net.sourceforge.prowl.exception.ProwlException;

public class Avviso {

    private String apiKey;
    private String applicationName;
    private static final String PROWL_URL = "https://api.prowlapp.com/publicapi/";
    private ProwlClient prowlClient;
    private DeliveryMethod deliveryMethod;

    public static final String AVVISO_API_KEY = "AVVISO_API_KEY ";
    public static final String AVVISO_APPLICATION_NAME = "AVVISO_APPLICATION_NAME ";
    public static final String AVVISO_PUSH = "AVVISO_PUSH"; // No trailing space

    public enum DeliveryMethod { PROWL, NOTIFY_MY_ANDROID };

    public Avviso() {
        this(DeliveryMethod.PROWL);
    }

    public Avviso(DeliveryMethod deliveryMethod) {
        apiKey = "";
        applicationName = "Avviso";
        this.deliveryMethod = deliveryMethod;
        if (deliveryMethod == DeliveryMethod.PROWL) {
            prowlClient = new ProwlClient();
            prowlClient.setProwlUrl(PROWL_URL);
        }
    }

    public String push(String eventStr, String messageStr, int priority) {
        String message = "";
        if (deliveryMethod == DeliveryMethod.PROWL) {
            ProwlEvent e = new DefaultProwlEvent(apiKey, applicationName, eventStr, messageStr, priority);
            try {
                message = prowlClient.pushEvent(e);
                System.out.println(message);
            } catch (ProwlException e1) {
                e1.printStackTrace();
            }            
        } else if (deliveryMethod == DeliveryMethod.NOTIFY_MY_ANDROID) {
            if (NMAClientLib.notify(applicationName, eventStr, messageStr, priority, apiKey) == 1) {
                System.out.println("Message sent to Notify My Android");
                message = "Message sent to Notify My Android";
            } else {
                System.out.println("NMAClientLib.getLastError(): " + NMAClientLib.getLastError());
                message = NMAClientLib.getLastError().toString();
                if (message == null) {
                    message = "Error sending to Notify My Android. Check your API key.";
                    System.out.println(message);
                }
            }
        }
        return message;
    }

    public String getApiKey() {
        return apiKey;
    }

    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }

    public String getApplicationName() {
        return applicationName;
    }

    public void setApplicationName(String applicationName) {
        this.applicationName = applicationName;
    }

    public DeliveryMethod getDeliveryMethod() {
        return deliveryMethod;
    }
    
    public void setDeliveryMethod(DeliveryMethod deliveryMethod) {
        this.deliveryMethod = deliveryMethod;
    }
}
