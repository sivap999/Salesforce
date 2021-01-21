public class FreshdeskUtil {

    public static FINAL STRING TICKET_ENDPOINT  = '/api/v2/tickets';
    public static FINAL STRING CONTACT_ENDPOINT = '/api/v2/contacts';
    
    public static void createContact(String name, String email,String phone, String mobile){

        String errorMessage = '';
		String endPoint     = CONTACT_ENDPOINT;
        
        String cred = System.Label.Freshdesk; // base64Encode(username:password)
        
        String requestBody  = '{'+
                                '"name": "'+name+'",'+
                                '"email": "'+email+'",'+
                                '"phone" : "'+phone+'",'+
                                '"mobile" : "'+mobile+'"'+
                            '}';
        
        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        
        httpReq.setMethod('POST');
        httpReq.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(cred)));
        httpReq.setEndpoint(endPoint);
        
        httpReq.setBody(requestBody);
        
        httpReq.setHeader('Content-Type', 'application/json');
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 201 ){
                String responseBody = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+responseBody);
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
    
    public static void createTicket(String sub, String email, String description, Integer priorty, Integer status, Integer source){

        String errorMessage = '';
		String endPoint     = TICKET_ENDPOINT;
        String cred = System.Label.Freshdesk; // base64Encode(username:password)
        
        String requestBody  = '{'+
                                '"description": "'+description+'",'+
                                '"subject": "'+sub+'",'+
                                '"email": "'+email+'",'+
                                '"priority": '+priorty+','+
                                '"status": '+status+','+
                                '"source": '+source+
                            '}';
        System.debug(' requestBody '+requestBody);
        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type', 'application/json');
        //httpReq.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(cred)));
        httpReq.setEndpoint('callout:Freshdesk/api/v2/tickets');
        httpReq.setBody(requestBody);
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 201 ){
                String responseBody = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+responseBody);
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
    
    public static void listAllContacts(){

        String errorMessage = '';
		String endPoint = CONTACT_ENDPOINT;
        
        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint('callout:Freshdesk/api/v2/contacts');
        httpReq.setHeader('Content-Type', 'application/json');
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 200 ){
                String body = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+body);
                List<FreshdeskContact> contacts = (List<FreshdeskContact>)System.JSON.deserialize(body, List<FreshdeskContact>.class);
                for(FreshdeskContact contact : contacts){
                    
                }
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+body);
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
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
    
    public static void listAllTickets(){

        String errorMessage = '';
        String endPoint     = TICKET_ENDPOINT;
        String cred = System.Label.Freshdesk; // base64Encode(username:password)
        
        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(endPoint);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(cred)));
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 200 ){
                String body = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+body);
                List<FreshdeskTicket> tickets = (List<FreshdeskTicket>)System.JSON.deserialize(body, List<FreshdeskTicket>.class);
                for(FreshdeskTicket ticket : tickets){
                    // upsert Fr_Ticket__c record here
                }
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+tickets);
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
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
    
    public static void listCustomerTickets(String email){

        String errorMessage = '';
		String endPoint = TICKET_ENDPOINT+'?email='+EncodingUtil.urlEncode(email, 'UTF-8');
        String cred = System.Label.Freshdesk;
        
        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(endPoint);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(cred)));
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 200 ){
                String body = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+body);
                List<FreshdeskTicket> tickets = (List<FreshdeskTicket>)System.JSON.deserialize(body, List<FreshdeskTicket>.class);
                for(FreshdeskTicket ticket : tickets){
                    // upsert Fr_Ticket__c record here
                }
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
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
}