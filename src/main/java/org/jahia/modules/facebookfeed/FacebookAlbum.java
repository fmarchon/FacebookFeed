package org.jahia.modules.facebookfeed;

import com.restfb.Facebook;

/**
 * Created by ramiroc on 5/18/2016.
 */
public class FacebookAlbum extends FacebookItem {
    public FacebookPhoto getCoverPhoto() {
        return coverPhoto;
    }

    public String getDescription() {
        return description;
    }

    public String getLink() {
        return link;
    }

    @Facebook("cover_photo")
    public FacebookPhoto coverPhoto;

    @Facebook
    public String description;

    @Facebook
    public String link;
}
