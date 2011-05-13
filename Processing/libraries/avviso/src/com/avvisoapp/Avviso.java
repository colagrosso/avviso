/**
 * Avviso: iOS push notifications from an Arduino using Prowl
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
 * @modified    05/04/2011
 * @version     1.0
 */

package com.avvisoapp;

import net.sourceforge.prowl.api.DefaultProwlEvent;
import net.sourceforge.prowl.api.ProwlClient;
import net.sourceforge.prowl.api.ProwlEvent;
import net.sourceforge.prowl.exception.ProwlException;

public class Avviso {

    private String apiKey;
    private String applicationName;
    private static final String PROWL_URL = "https://api.prowlapp.com/publicapi/";
    private ProwlClient prowlClient;

    public static final String AVVISO_API_KEY = "AVVISO_API_KEY ";
    public static final String AVVISO_APPLICATION_NAME = "AVVISO_APPLICATION_NAME ";
    public static final String AVVISO_PUSH = "AVVISO_PUSH"; // No trailing space

    public Avviso() {
        prowlClient = new ProwlClient();
        prowlClient.setProwlUrl(PROWL_URL);
        apiKey = "";
        applicationName = "Avviso";
    }

    public String push(String eventStr, String messageStr, int priority) {
        ProwlEvent e = new DefaultProwlEvent(apiKey, applicationName, eventStr, messageStr, priority);
        String message = "";
        try {
            message = prowlClient.pushEvent(e);
            System.out.println(message);
        } catch (ProwlException e1) {
            e1.printStackTrace();
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
}
