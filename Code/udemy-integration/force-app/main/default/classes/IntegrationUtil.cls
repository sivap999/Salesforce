public class IntegrationUtil {

    public static void templateMethod(){

        String errorMessage = '';
		String endPoint = '';
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(endPoint, '', 'POST', '','application/json');
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 200 ){
                String body = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+body);
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
    
    public static Map<String, Object> refreshToken(Google_Config__mdt gConfig){
        
        String errorMessage = '';
        
        String endPoint = '';
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