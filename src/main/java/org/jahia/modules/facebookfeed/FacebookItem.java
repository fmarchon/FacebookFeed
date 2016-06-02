package org.jahia.modules.facebookfeed;

import com.restfb.Facebook;

/**
 * Created by ramiroc on 5/17/2016.
 */
public class FacebookItem {
    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    @Facebook
    public String id;

    @Facebook
    public String name;
}
