public class SalesforceUtil {
    
    public static sfdc_Config__mdt getSFDCConfig(){
        String query = SOQLUtil.buildSOQLQuery('sfdc_Config__mdt', System.Label.SalesforceToken);
        List<sfdc_Config__mdt> sfdcCredList = Database.query(query);
        sfdc_Config__mdt sfdcCred = new sfdc_Config__mdt();
        if(sfdcCredList != null && !sfdcCredList.isEmpty()){
            sfdcCred     = sfdcCredList.get(0);
        }else{
            return null;
        }
        return sfdcCred;
    }
    
    public static Boolean checkTokenValidity(sfdc_Config__mdt token){
        Boolean isValid = true;
        if(token.expires_in_time__c < system.now()){
            isValid = false;
        }
        return isValid;
    }
    
    public static PageReference getAuthorizationCode(){
        
        sfdc_Config__mdt sfdcCred = getSFDCConfig();
        if(sfdcCred == null){
            return null;
        }
        String loginUrl = 'https://test.salesforce.com';
        if(sfdcCred.Environment__c == 'Production'){
            loginUrl = 'https://login.salesforce.com';
        }
        String endPoint = loginUrl+sfdcCred.authurl__c;
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/'+sfdcCred.PageName__c;
        endPoint += '?client_id='+sfdcCred.clientid__c+'&redirect_uri='+baseUrl+'&response_type=code&scope='+sfdcCred.scope__c;
        
        String authUrl = endPoint;
        
        PageReference pageRef = new PageReference(authUrl);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public static void getAccessToken(){
        
        sfdc_Config__mdt sfdcCred = getSFDCConfig();
        if(sfdcCred == null){
            return;
        }
        
        String loginUrl = 'https://test.salesforce.com';
        if(sfdcCred.Environment__c == 'Production'){
            loginUrl = 'https://login.salesforce.com';
        }
        
        
        String errorMessage = '';
        String endPoint = loginUrl+sfdcCred.tokenurl__c;
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/'+sfdcCred.PageName__c;
        String code    = ApexPages.currentPage().getParameters().get('code');
        
        String requestBody ='code='+code+'&client_id='+sfdcCred.clientid__c+
            			    '&client_secret='+sfdcCred.clientsecret__c+
            				'&redirect_uri='+baseUrl+'&grant_type=authorization_code';
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, '', 'POST', requestBody,'application/x-www-form-urlencoded');
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 200 ){
                String body = response.getBody();
                //System.debug(System.LoggingLevel.DEBUG, ' Salesforce Responsse from Server '+body);
                
                SalesforceToken token = (SalesforceToken)JSON.deserialize(body, SalesforceToken.class);
                
                Map<String, Object> tokenMap = new Map<String, Object>();
                tokenMap.put('accesstoken__c',token.access_token);
                tokenMap.put('refreshtoken__c',token.refresh_token);
                tokenMap.put('expires_in__c',Decimal.valueOf(token.issued_at));
                tokenMap.put('instanceurl__c',token.instance_url);
                tokenMap.put('expires_in_time__c',System.now().addHours(24) );
                
                String fullName = 'sfdc_Config.'+System.Label.SalesforceToken;
                CreateUpdateMetadataUtils.createUpdateMetadata(fullName,System.Label.SalesforceToken,tokenMap);
                
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
    
    public static Map<String, Object> refreshToken(sfdc_Config__mdt Config){
        
        String errorMessage = '';
        
        String loginUrl = 'https://test.salesforce.com';
        if(Config.Environment__c == 'Production'){
            loginUrl = 'https://login.salesforce.com';
        }
        
        String endPoint = loginUrl+Config.tokenurl__c;
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/'+Config.PageName__c;
        
        String requestBody = 'client_id='+Config.clientid__c+'&client_secret='+Config.clientsecret__c+
            				 '&refresh_token='+Config.refreshtoken__c+'&grant_type=refresh_token';
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, '', 'POST', requestBody,'application/x-www-form-urlencoded');
        HttpResponse response = new HttpResponse();
        
        Map<String, Object> tokenMap = new Map<String, Object>();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                String responseBody = response.getBody();
                SalesforceToken token = (SalesforceToken)JSON.deserialize(responseBody, SalesforceToken.class);
                tokenMap.put('accesstoken__c',token.access_token);
                tokenMap.put('refreshtoken__c',token.refresh_token);
                
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
    
    public static void createAccount(String name){
        
        sfdc_Config__mdt sfdcCred = getSFDCConfig();
        if(sfdcCred != null && String.isBlank(sfdcCred.accesstoken__c)){
            return;
        }
        
        String errorMessage = '';
        
        String instanceUrl = sfdcCred.instanceurl__c;
        String accessToken = sfdcCred.accesstoken__c;
        
        String endPoint = instanceUrl+'/services/data/v49.0/sobjects/Account';
        
        Boolean isValid = checkTokenValidity(sfdcCred);
        Map<String, Object> tokenMap = new Map<String, Object>();
        if(!isValid){
            tokenMap = refreshToken(sfdcCred);
            accessToken = (String)tokenMap.get('accesstoken__c');
        }
        
        String requestBody = '{'+
		'  "Name":"'+Name+'",'+
		'  "SLA__c" :"Gold"'+
		'}';
        
        Http http = new Http();
        HttpRequest httpReq = prepareRequest(endPoint, accessToken, 'POST', requestBody, 'application/json');
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                String responseBody = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, '****\n responseBody \n '+responseBody);
                
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
        
    }
    
    public static void createContact(String requestBody){
        sfdc_Config__mdt sfdcCred = getSFDCConfig();
        if(sfdcCred != null && String.isBlank(sfdcCred.accesstoken__c)){
            return;
        }
        
        String errorMessage = '';
        
        String instanceUrl = sfdcCred.instanceurl__c;
        String accessToken = sfdcCred.accesstoken__c;
        
        String endPoint = instanceUrl+'/services/data/v49.0/sobjects/Contact';
        
        Boolean isValid = checkTokenValidity(sfdcCred);
        Map<String, Object> tokenMap = new Map<String, Object>();
        /*if(!isValid){
            tokenMap = refreshToken(sfdcCred);
            accessToken = (String)tokenMap.get('accesstoken__c');
        }*/
        System.debug(' ***** \n '+requestBody);
        Http http = new Http();
        HttpRequest httpReq = prepareRequest(endPoint, accessToken, 'POST', requestBody, 'application/json');
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                String responseBody = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, '****\n responseBody \n '+responseBody);
                
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