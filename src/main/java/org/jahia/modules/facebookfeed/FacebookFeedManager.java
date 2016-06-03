package org.jahia.modules.facebookfeed;
import com.restfb.*;
import com.restfb.types.Page;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import java.util.List;

/**
 * Created by ramiroc on 5/17/2016.
 * This class is used  to interface with the facebook graph api
 */
public class FacebookFeedManager {
    private static final Logger logger = LoggerFactory.getLogger(FacebookFeedManager.class);
    private static FacebookClient.AccessToken accessToken;
    private DefaultFacebookClient client;
    private String pageName;
    private String facebookAppId;
    private String facebookAppSecret;
    private String albumName;

    public String getFacebookAppId()
    {
        return this.facebookAppId;
    }
    public void setFacebookAppId(String value)
    {
        this.facebookAppId = value;
    }

    public String getFacebookAppSecret()
    {
        return this.facebookAppSecret;
    }
    public void setFacebookAppSecret(String value)
    {
        this.facebookAppSecret = value;
    }

    public String getPageName()
    {
        return this.pageName;
    }

    public void setPageName(String value)
    {
        this.pageName = value;
    }

    public List<FacebookPhoto> getPhotos()
    {
        return retrievePhotosFromAlbum();
    }
    public List<FacebookAlbum> getAlbums()
    {
        return retrieveAlbums();
    }

    public String getAlbumName(){
        return this.albumName;
    }

    public void setAlbumName(String value){
        this.albumName = value;
    }

    public FacebookFeedManager() {
    }


    public void initialize()
    {
        // Obtains an access token which can be used to perform Graph API operations
        // on behalf of an application instead of a user.
        if (FacebookFeedManager.accessToken == null ||
                (FacebookFeedManager.accessToken.getExpires() != null && FacebookFeedManager.accessToken.getExpires().before(new Date()))) {
            FacebookFeedManager.accessToken = new DefaultFacebookClient(Version.VERSION_2_6).obtainAppAccessToken(facebookAppId,
                                                        facebookAppSecret);
            System.out.println(String.format("Facebook Access Token: %s \n Facebook Token Type: %s",
                            FacebookFeedManager.accessToken.getAccessToken(),
                            FacebookFeedManager.accessToken.getTokenType()));
            // invalidate the client if it was already created
            client = null;
        }

        if (client == null)
        {
            client = new DefaultFacebookClient(FacebookFeedManager.accessToken.getAccessToken(), facebookAppSecret,
                    Version.VERSION_2_6);
        }
    }
    
    private String getAlbumId(String albumName)
    {
        Connection<FacebookItem> albums = client.fetchConnection(String.format("%s/albums", pageName),
                                                FacebookItem.class, Parameter.with("fields","name,id"));
        for (List<FacebookItem> pageAlbums : albums){
            for(FacebookItem album: pageAlbums){
                if(album.name.equalsIgnoreCase(albumName) || album.id.equalsIgnoreCase(albumName)){
                    return album.id;
                }
            }
        }
        return null;
    }

    private List<FacebookAlbum> retrieveAlbums()
    {
        initialize();
        try{
            client.fetchObject(pageName, Page.class);
        }catch (com.restfb.exception.FacebookGraphException e){
            logger.error("Facebook page '"+pageName+"' does not exist");
            return null;
        }
        Connection<FacebookAlbum> albums = client.fetchConnection(String.format("%s/albums", pageName),
                FacebookAlbum.class, Parameter.with("fields","id,name,description,link,cover_photo,count"));
        return albums.getData();
    }

    public List<FacebookPhoto> retrievePhotosFromAlbum()
    {
        initialize();
        try{
            client.fetchObject(pageName, Page.class);
        }catch (com.restfb.exception.FacebookGraphException e){
            logger.error("Facebook page '"+pageName+"' does not exist");
            return null;
        }
        String albumId = getAlbumId(this.albumName);
        if (albumId!= null){
            Connection<FacebookPhoto> photos = client.fetchConnection(String.format("%s/photos", albumId),
                    FacebookPhoto.class, Parameter.with("fields","name,id,source,width,height"));
            return photos.getData();
        }else
            logger.error("Cannot retrieve facebook album named "+this.albumName+" from the facebook page "+this.pageName );
            return null;

    }
}
