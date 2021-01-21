/*
     ******** Test User Credentials *********
     Username - udemy@integration.org
     Password - donotchangeme@1
*/
global with sharing class FreshdeskWrapper {
    
    global static FINAL String username ='wOb3rp9WXfxFtejIMM';
    global static FINAL String password = 'X';
    global static FINAL String baseEndpoint = 'https://sfdcpantherhelp.freshdesk.com/api/v2';
    
    global static String authHeader() {
        
        String userNamepass = username+':'+password;
        String base64String = EncodingUtil.base64Encode(blob.valueOf(userNamepass));
        return base64String;
        
    }
    
    @AuraEnabled
    global static String getAllTickets(){
        
        String message='';
        
        String endPoint = baseEndpoint+'/tickets?include=requester';
        String authH = authHeader();
        
        /* Prepare the HttpRequest */
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint(endPoint);
        httpReq.setMethod('GET');
        httpReq.setHeader('Content-Type','application/json');
        httpReq.setHeader('Authorization','Basic '+authH);
        httpReq.setTimeout(12000); // 10 sec // 120 sec
        
        /* Create Http object to send the request */
        Http http = new Http();
        
        /* Create an Objet of HttpResponse to store the Response */
        HttpResponse httpRes = new HttpResponse();
        
        try{
            
            httpRes = http.send(httpReq);
            Integer statusCode = httpRes.getStatusCode();
            
            if( statusCode==200 ){
                String responseBody = httpRes.getBody();
                List<TicketWrapper> wrapperList = (List<TicketWrapper>)JSON.deserialize(responseBody, List<TicketWrapper>.class);
                System.debug(System.LoggingLevel.DEBUG, '\n **** wrapperList **** \n '+wrapperList);
                System.debug(System.LoggingLevel.DEBUG, '\n **** wrapperList **** \n '+wrapperList.size());
                
                return JSON.serialize(wrapperList);
                
            }else{
                
                message += 'An Error occured while making the API Callout ';
                message += httpRes.getBody();
                System.debug('\n **** Error Occured **** \n '+message);
                return message;
            }
            
        }catch(System.Exception ex){
            
            message += 'An Error occured while making the API Callout ';
            
            if(String.valueOf(ex).startsWith('Unauthorized endpoint')){
                
                message += 'Ask your System Administrator to visit Setup->Security->Remote site settings and ';
                message += ' Add '+endPoint+' endpoint and then try again';
                
            }else{
                
                message += ex.getStackTraceString()+' '+ex.getMessage();
                
            }
            
            System.debug('\n **** Execption Executed **** \n '+message);
            return message;
        }
    }
    
    @AuraEnabled
    global static void createTicket(String name, String email, String phone, String subject, String description,
                                   Integer priorty, Integer source, Integer status){
        String message = '';
                                                  
        /* Prepare Request Body */
        String requestBody =		'{'+
		'    "description": "'+description+'",'+
		'    "subject": "'+subject+'",'+
		'    "name" : "'+name+'",'+
		'    "phone":"'+phone+'",'+
		'    "email": "'+email+'",'+
		'    "priority": '+priorty+','+
		'    "status": '+status+','+
		'    "source": '+source+','+
		'    "cc_emails": ["ram@freshdesk.com","diana@freshdesk.com"],'+
		'    "tags" : ['+
		'    	"Account",'+
		'    	"Money Related Issue"'+
		'    ]'+
		'}';
                                       
        System.debug(System.LoggingLevel.DEBUG, '\n **** requestBody **** \n'+requestBody);
        /* Prepare Endpoint to be Executed from Salesforce */
        String endPoint = baseEndpoint+'/tickets';
        String authH = authHeader();
        //System.debug(' authH '+authH);
        /* Prepare the HttpRequest */
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint(endPoint);
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type','application/json');
        httpReq.setHeader('Authorization','Basic '+authH);
        httpReq.setBody(requestBody);
        httpReq.setTimeout(12000); // 10 sec // 120 sec
        
        /* Create Http object to send the request */
        Http http = new Http();
        
        /* Create an Objet of HttpResponse to store the Response */
        HttpResponse httpRes = new HttpResponse();
        
        try{
            
            httpRes = http.send(httpReq);
            Integer statusCode = httpRes.getStatusCode();
            
            if( statusCode == 200 || statusCode == 201 ){
                
                String responseBody = httpRes.getBody();
                TicketWrapper wrapper = (TicketWrapper)JSON.deserialize(responseBody, TicketWrapper.class);
                
                System.debug(System.LoggingLevel.DEBUG, '\n **** wrapper **** \n '+wrapper);
                
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
                
                message += ex.getStackTraceString()+' '+ex.getMessage();
                
            }
            
            System.debug('\n **** Execption Executed **** \n '+message);
        }
        
    }
    
}