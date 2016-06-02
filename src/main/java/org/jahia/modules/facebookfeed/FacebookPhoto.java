package org.jahia.modules.facebookfeed;

import com.restfb.Facebook;

/**
 * Created by ramiroc on 5/17/2016.
 */
public class FacebookPhoto extends FacebookItem {
    @Facebook("source")
    public String url;

    @Facebook
    public String width;

    @Facebook
    public String height;

    public String getUrl()
    {
        return this.url;
    }

    public String getWidth(){ return this.width; }
    public String getHeight(){ return this.height; }
}
