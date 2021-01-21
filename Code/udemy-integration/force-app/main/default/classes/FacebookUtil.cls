public class FacebookUtil {

    public static Facebook_Config__mdt getfacebookConfig(){
        String query = SOQLUtil.buildSOQLQuery('Facebook_Config__mdt', System.Label.LinkedInToken);
        List<Facebook_Config__mdt > facebookList = Database.query(query);
        Facebook_Config__mdt  facebookCred = new Facebook_Config__mdt ();
        if(facebookList != null && !facebookList.isEmpty()){
            facebookCred     = facebookList.get(0);
        }else{
            return null;
        }
        return facebookCred;
    }
    
    public PageReference getAuthorizationCode(){
        
        Facebook_Config__mdt facebookCred = getfacebookConfig();
        if(facebookCred == null){
            return null;
        }
        
        PageReference pageRef = new PageReference('');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public static void getAccessToken(){
        Facebook_Config__mdt facebookCred = getfacebookConfig();
        if(facebookCred == null){
            return;
        }
    }
    
    public static HttpRequest prepareRequest(String endPoint, String accessToken, String method, String requestBody,
                                            String contentType){
        
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod(method);
        httpReq.setEndpoint(endPoint);
        httpReq.setHeader('Content-Type', contentType);
        httpReq.setHeader('Accept', 'application/json');
        if(!String.isBlank(accessToken)){
            httpReq.setHeader('Authorization', 'Bearer '+accessToken);
        }
        if(!String.isBlank(requestBody)){
            httpReq.setBody(requestBody);
        }
        return httpReq;
        
    }
    
}