public class GoogleUtil {
    
    public static Google_Config__mdt getGoogleConfig(){
        String query = SOQLUtil.buildSOQLQuery('Google_Config__mdt', System.Label.GoogleToken);
        List<Google_Config__mdt> g_CredList = Database.query(query);
        Google_Config__mdt g_Cred = new Google_Config__mdt();
        if(g_CredList != null && !g_CredList.isEmpty()){
            g_Cred     = g_CredList.get(0);
        }else{
            return null;
        }
        return g_Cred;
    }
    
    public PageReference getAuthorizationCode(){
        
        Google_Config__mdt g_Cred = getGoogleConfig();
        if(g_Cred == null){
            return null;
        }
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/'+g_Cred.PageName__c;
        
        String authUrl = g_Cred.auth_url__c+'?scope='+g_Cred.scope__c+'&prompt=consent&access_type=offline';
        authUrl += '&include_granted_scopes=true&response_type=code&state'+Crypto.getRandomInteger();
        authUrl += '&redirect_uri='+baseUrl+'&client_id='+g_Cred.client_id__c;
        
        PageReference pageRef = new PageReference(authUrl);
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    
    public static Boolean checkTokenValidity(Google_Config__mdt token){
        Boolean isValid = true;
        if(token.expires_in_time__c < system.now()){
            isValid = false;
        }
        return isValid;
    }
    
    public static void getAccessToken(){
        
        Google_Config__mdt g_Cred = getGoogleConfig();
        
        if(g_Cred == null){
            return;
        }
        
        String errorMessage = '';
        String endPoint = g_Cred.token_url__c;
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/'+g_Cred.PageName__c;
        String code    = ApexPages.currentPage().getParameters().get('code');

        String requestBody ='code='+code+'&client_id='+g_Cred.client_id__c+
            			    '&client_secret='+g_Cred.client_secret__c+
            				'&redirect_uri='+baseUrl+'&grant_type=authorization_code';
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, '', 'POST', requestBody,'application/x-www-form-urlencoded');
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                String body = response.getBody();
                Map<String, Object> tokenMap = new Map<String, Object>();
                
                GoogleToken token = (GoogleToken)System.JSON.deserialize(body, GoogleToken.class);
                tokenMap.put('access_token__c',token.access_token);
                tokenMap.put('refresh_token__c',token.refresh_token);
                tokenMap.put('expires_in__c',Decimal.valueOf(token.expires_in));
                tokenMap.put('expires_in_time__c',System.now().addSeconds(token.expires_in));
                
                String fullName = 'Google_Config.'+System.Label.GoogleToken;
                CreateUpdateMetadataUtils.createUpdateMetadata(fullName,System.Label.GoogleToken,tokenMap);
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,
                                                           'Successfully Authenticated! You can close the window now.'));
                
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,response.getBody()));
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
        } 
    }
    
    public static void createGoogleEvent(String requestBody){
        
        Google_Config__mdt g_Cred = getGoogleConfig();
        
        if(g_Cred == null || ( g_Cred != null && String.isBlank(g_Cred.access_token__c) ) ){
            return;
        }
        
        String errorMessage = '';
        String endPoint = g_Cred.Event_Url__c;
        endPoint = endPoint.replace('{calendarId}', 'cse.amitallenhouse@gmail.com');
        
        String accessToken = g_Cred.access_token__c;
        
        Boolean isValid = checkTokenValidity(g_Cred);
        Map<String, Object> refreshTokenMap = new Map<String, Object>();
        
        if(!isValid){
            refreshTokenMap = refreshToken(g_Cred);
            accessToken     = (String)refreshTokenMap.get('access_token__c');
        }
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, accessToken, 'POST', requestBody,'application/json');
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                String body = response.getBody();
                System.debug(' Google Event Response '+body);
                if(!isValid){
                    String fullName = 'Google_Config.'+System.Label.GoogleToken;
                    CreateUpdateMetadataUtils.createUpdateMetadata(fullName, System.Label.GoogleToken, refreshTokenMap);
                }

            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
        } 
    }
    
    public static void getAllGoogleEvent(){
        
        String errorMessage = '';

        Http http = new Http();
        HttpRequest httpReq   = prepareRequest('callout:Google/calendar/v3/calendars/cse.amitallenhouse@gmail.com/events',
                                               '', 'GET', '','application/json');
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                String body = response.getBody();
                System.debug(' Google Event Response '+body);
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add  Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
        } 
    }
    
    public static Map<String, Object> refreshToken(Google_Config__mdt gConfig){
        
        String errorMessage = '';
        
        String endPoint = gConfig.token_url__c;
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/'+gConfig.PageName__c;
        
        String requestBody = 'client_id='+gConfig.client_id__c+'&client_secret='+gConfig.client_secret__c+
            '&refresh_token='+gConfig.refresh_token__c+'&grant_type=refresh_token';
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, '', 'POST', requestBody,'application/x-www-form-urlencoded');
        HttpResponse response = new HttpResponse();
        
        Map<String, Object> tokenMap = new Map<String, Object>();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                String responseBody = response.getBody();
                GoogleToken token = (GoogleToken)System.JSON.deserialize(responseBody, GoogleToken.class);
                tokenMap.put('access_token__c',token.access_token);
                tokenMap.put('expires_in__c',Decimal.valueOf(token.expires_in));
                tokenMap.put('expires_in_time__c',System.now().addSeconds(token.expires_in));
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed in Refresh Token '+response.getBody());
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed in Refresh Token '+errorMessage);
        } 
        return tokenMap;
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