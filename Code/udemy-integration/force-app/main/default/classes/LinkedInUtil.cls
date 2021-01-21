public class LinkedInUtil {

    public static LinkedIn_Config__mdt getLinkedInConfig(){
        String query = SOQLUtil.buildSOQLQuery('LinkedIn_Config__mdt', System.Label.LinkedInToken);
        List<LinkedIn_Config__mdt> linkedInList = Database.query(query);
        LinkedIn_Config__mdt linkedInCred = new LinkedIn_Config__mdt();
        if(linkedInList != null && !linkedInList.isEmpty()){
            linkedInCred     = linkedInList.get(0);
        }else{
            return null;
        }
        return linkedInCred;
    }
    
    public static void getAccessToken(){
        
        LinkedIn_Config__mdt linkedInCred = getLinkedInConfig();
        if(linkedInCred == null){
            return;
        }

        String errorMessage = '';
        String endPoint = linkedInCred.token_url__c;
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/'+linkedInCred.PageName__c;
        String code    = ApexPages.currentPage().getParameters().get('code');
        
        String requestBody ='code='+code+'&client_id='+linkedInCred.client_id__c+
            			    '&client_secret='+linkedInCred.client_secret__c+
            				'&redirect_uri='+baseUrl+'&grant_type=authorization_code';
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, '', 'POST', requestBody,'application/x-www-form-urlencoded');
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 200 ){
                String body = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' LinkedIn Responsse from Server '+body);
                LinkedInToken token = (LinkedInToken)JSON.deserialize(body, LinkedInToken.class);
                Map<String, Object> tokenMap = new Map<String, Object>();
                tokenMap.put('access_token__c',token.access_token);
                tokenMap.put('refresh_token__c',token.refresh_token);
                tokenMap.put('expires_in__c',Decimal.valueOf(token.expires_in));
                tokenMap.put('expires_in_time__c',System.now().addSeconds(token.expires_in));
                String fullName = 'LinkedIn_Config.'+System.Label.LinkedInToken;
                CreateUpdateMetadataUtils.createUpdateMetadata(fullName,System.Label.LinkedInToken,tokenMap);
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,
                                                           'Successfully Authenticated! You can close the window now.'));
                
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,response.getBody() ));
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
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        } 
    }
    
    public static Map<String, Object> refreshToken(LinkedIn_Config__mdt Config){
        
        String errorMessage = '';
        
        String endPoint = Config.token_url__c;
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/'+Config.PageName__c;
        
        String requestBody = 'client_id='+Config.client_id__c+'&client_secret='+Config.client_secret__c+
            				 '&refresh_token='+Config.refresh_token__c+'&grant_type=refresh_token';
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, '', 'POST', requestBody,'application/x-www-form-urlencoded');
        HttpResponse response = new HttpResponse();
        
        Map<String, Object> tokenMap = new Map<String, Object>();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                String responseBody = response.getBody();
                
                LinkedInToken token = (LinkedInToken)JSON.deserialize(responseBody, LinkedInToken.class);
                tokenMap.put('access_token__c',token.access_token);
                tokenMap.put('refresh_token__c',token.refresh_token);
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
    
    public static void sharePostToLinkedId(){
       
        
        LinkedIn_Config__mdt linkedInCred = getLinkedInConfig();
        if(linkedInCred == null){
            return;
        }

        String errorMessage = '';
        String endPoint = linkedInCred.Create_Post__c;
        String accessToken = linkedInCred.access_token__c;
        
        String owner = 'urn:li:person:'+linkedInCred.LinkedPersonId__c;
        
        String requestBody =		'{'+
		'    "content": {'+
		'        "contentEntities": ['+
		'            {'+
		'                "entityLocation": "https://www.sfdcpanther.com/linkedin-salesforce-integration/",'+
		'                "thumbnails": ['+
		'                    {'+
		'                        "resolvedUrl": "https://sfdcpanther.files.wordpress.com/2017/10/custom-setting-linkedin.png"'+
		'                    }'+
		'                ]'+
		'            }'+
		'        ],'+
		'        "title": "Integrate LinkedIn with Salesforce with SFDCPanther"'+
		'    },'+
		'    "distribution": {'+
		'        "linkedInDistributionTarget": {}'+
		'    },'+
		'    "owner": "'+owner+'",'+
		'    "subject": "Integrate LinkedIn with Salesforce",'+
		'    "text": {'+
		'        "text": "Hi There, Looking to integrate Salesforce with LinkedIn Follow the below link - This post is from the LinkedId API :)"'+
		'    }'+
		'}';
        
        Boolean isValid = checkTokenValidity(linkedInCred);
        Map<String, Object> tokenMap = new Map<String, Object>();
        if(!isValid){
            tokenMap = refreshToken(linkedInCred);
            accessToken = (String)tokenMap.get('access_token__c');
        }
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, accessToken, 'POST', requestBody,'application/json');
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                System.debug('Response from LinkedIn '+response.getBody() );
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.CalloutException e ){
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
    public static void getUserInformation(){
        LinkedIn_Config__mdt linkedInCred = getLinkedInConfig();
        if(linkedInCred == null){
            return;
        }

        String errorMessage = '';
        String endPoint = linkedInCred.Profile_Url__c;
        String accessToken = linkedInCred.access_token__c;
        
        Boolean isValid = checkTokenValidity(linkedInCred);
        Map<String, Object> tokenMap = new Map<String, Object>();
        if(!isValid){
            tokenMap = refreshToken(linkedInCred);
            accessToken = (String)tokenMap.get('access_token__c');
        }
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, accessToken, 'GET', '','application/json');
        HttpResponse response = new HttpResponse();
        try{
            response = http.send(httpReq);
            
            if(response.getStatusCode() == 200){
                //LinkedPersonId__c 
                Map<String, Object> responseMap = (Map<String, Object>)System.JSON.deserializeUntyped(response.getBody());
                String userId = (String)responseMap.get('id');
                
                Map<String, Object> userIdMap = new Map<String, Object>();
                userIdMap.put('LinkedPersonId__c', userId);
                String fullName = 'LinkedIn_Config.'+System.Label.LinkedInToken;
                CreateUpdateMetadataUtils.createUpdateMetadata(fullName,System.Label.LinkedInToken,userIdMap);
                
                System.debug('Response from LinkedIn '+response.getBody() );
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.CalloutException e ){
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
    
    public static void comentOnLinkedInPost(String postId){
        LinkedIn_Config__mdt linkedInCred = getLinkedInConfig();
        if(linkedInCred == null){
            return;
        }
        
        if(String.isBlank(postId)){
            postId = 'urn:li:activity:6727905029015027712';
        }
        
        String owner = 'urn:li:person:'+linkedInCred.LinkedPersonId__c;
        
        String errorMessage = '';
        String endPoint = linkedInCred.commenturl__c;
        endPoint		= endPoint.replace('{shareUrn}', postId);
        String accessToken = linkedInCred.access_token__c;
        
        String requestBody = '{'+
		'   "actor":"'+owner+'",'+
		'   "object":"'+postId+'",'+
		'   "message":{'+
		'      "text":"You can get the code from the GitHub Repo - https://github.com/amitastreait/Salesforce---LinkedIn-Integration "'+
		'   }'+
		'}';
        
        Boolean isValid = checkTokenValidity(linkedInCred);
        Map<String, Object> tokenMap = new Map<String, Object>();
        if(!isValid){
            tokenMap = refreshToken(linkedInCred);
            accessToken = (String)tokenMap.get('access_token__c');
        }
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, accessToken, 'POST', requestBody,'application/json');
        HttpResponse response = new HttpResponse();
        try{
            response = http.send(httpReq);
            
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                
                System.debug('Response from LinkedIn '+response.getBody() );
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.CalloutException e ){
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
    
    public static void likeLinkedInPost(String postId){
        LinkedIn_Config__mdt linkedInCred = getLinkedInConfig();
        if(linkedInCred == null){
            return;
        }
        
        if(String.isBlank(postId)){
            postId = 'urn:li:activity:6727905029015027712';
        }
        
        String owner = 'urn:li:person:'+linkedInCred.LinkedPersonId__c;
        
        String errorMessage = '';
        String endPoint = linkedInCred.likeurl__c;
        endPoint		= endPoint.replace('{shareUrn}', postId);
        String accessToken = linkedInCred.access_token__c;
        
        String requestBody = '{'+
		'    "actor": "'+owner+'",'+
		'    "object": "'+postId+'"'+
		'}';
        
        Boolean isValid = checkTokenValidity(linkedInCred);
        Map<String, Object> tokenMap = new Map<String, Object>();
        if(!isValid){
            tokenMap = refreshToken(linkedInCred);
            accessToken = (String)tokenMap.get('access_token__c');
        }
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, accessToken, 'POST', requestBody,'application/json');
        HttpResponse response = new HttpResponse();
        try{
            response = http.send(httpReq);
            
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                
                System.debug('Response from LinkedIn Like on Share '+response.getBody() );
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.CalloutException e ){
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
    
    public static Boolean checkTokenValidity(LinkedIn_Config__mdt token){
        Boolean isValid = true;
        if(token.expires_in_time__c < system.now()){
            isValid = false;
        }
        return isValid;
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