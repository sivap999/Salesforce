public class PhoneValidator {
    
    @future(callout =true)
    public static void validatePhone(String accountId){
        
        List<Account> accountList = [SELECT Id, Phone FROM Account 
                                     WHERE Id =: accountId ];
        
        if(!accountList.isEmpty()){
            
            Account acc = accountList.get(0);
            
            String message = '';
            
            /* Prepare Endpoint to be Executed from Salesforce */
            
            String endPoint = System.LABEL.NumVerifyURL+'?access_key='+System.Label.NumVerifyAPI+'&number='+acc.Phone+'country_code=&format=1';
            
            /* Prepare the HttpRequest */
            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint(endPoint);
            httpReq.setMethod('GET');
            httpReq.setHeader('Content-Type','application/json');
            httpReq.setTimeout(12000); // 10 sec // 120 sec
            
            /* Create Http object to send the request */
            Http http = new Http();
            
            /* Create an Objet of HttpResponse to store the Response */
            HttpResponse httpRes = new HttpResponse();
            
            try{
                
                httpRes = http.send(httpReq);
                Integer statusCode = httpRes.getStatusCode();
                
                if(statusCode==200){
                    String responseBody = httpRes.getBody();
                    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
                    Boolean isValid = (Boolean)responseMap.get('valid');
                    
                    if(isValid){
                        acc.Phone_Validation__c = 'Valid';
                    }else{
                        acc.Phone_Validation__c = 'InValid';
                    }
                    update acc;
                }else{
                    
                    message += 'An Error occured while making the API Callout ';
                    message += httpRes.getBody();
                    System.debug('\n **** Error Occured **** \n '+message);
                    
                }
                
            }catch(System.Exception ex){
                
                message += 'An Error occured while making the API Callout ';
                
                if(String.valueOf(ex).startsWith('Unauthorized endpoint')){
                    
                    message += 'Ask your System Administrator to visit Setup->Security->Remote site settings and ';
                    message += ' Add '+endPoint+' endpoint and then try again';
                    
                }else{
                    
                    message += ex.getStackTraceString();
                    
                }
                System.debug('\n **** Execption Executed **** \n '+ex.getMessage());
            }
            
            
        }
    }
}