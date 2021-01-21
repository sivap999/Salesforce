/*
     ******** Test User Credentials *********
     Username - udemy@integration.org
     Password - donotchangeme@1
     
     Double theLatitude = myObject__c.aLocation__latitude__s;
    myObject__c.aLocation__longitude__s = theLongitude;

*/
global with sharing class AddressValidator {
    
    @future(callout = true )
    global static void validateAddress(String accountId) {
    
         List<Account> accountList = [Select Id, BillingStreet, BillingCity, BillingState,
                                      BillingPostalCode, BillingCountry, Name From Account 
                                     Where Id =: accountId ];
         
         if(!accountList.isEmpty()){
         
             Account acc = accountList.get(0);
             String accountAddress = '';
             
             if(!String.isBlank(acc.BillingStreet)){
                 accountAddress+= acc.BillingStreet+', ';
             }
             if(!String.isBlank(acc.BillingCity)){
                 accountAddress+= acc.BillingCity+', ';
             }
             if(!String.isBlank(acc.BillingState)){
                 accountAddress+= acc.BillingState+', ';
             }
             if(!String.isBlank(acc.BillingPostalCode)){
                 accountAddress+= acc.BillingPostalCode+', ';
             }
             if(!String.isBlank(acc.BillingCountry)){
                 accountAddress+= acc.BillingCountry+', ';
             }
             
             String finalString = accountAddress.subStringBeforeLast(',');
             System.debug('\n **** finalString ****\n'+finalString);
             
             /* URL Encode the Address String using EncodingUtil Class */
             
             String encodedString = EncodingUtil.urlEncode(finalString,'UTF-8');
             System.debug('\n **** encodedString ****\n'+encodedString);
             
             /* Create a Variable to Store the Error Message */
             String message = '';
             
             /* Prepare Endpoint to be Executed from Salesforce */
             String endPoint = System.Label.OpenCageEndpoint+'key='+System.Label.OpenCageAPI;

             endPoint+= '&q='+encodedString;
             
             System.debug('\n **** finalEndpoint ****\n'+endPoint);
             
             /* Prepare the HttpRequest */
             HttpRequest httpReq = new HttpRequest();
             
             httpReq.setEndpoint(endPoint);
             httpReq.setMethod('GET');
             httpReq.setHeader('Content-Type','application/json');
             
             /* Create Http object to send the request */
             
             Http http = new Http();
             
             /* Create an Objet of HttpResponse to store the Response */
             HttpResponse httpRes = new HttpResponse();
             
             try{
                 httpRes = http.send(httpReq);
                 Integer statusCode = httpRes.getStatusCode();
                 if(statusCode==200){
                 
                     /* Prepare Account Record to Update */

                     String responseBody = httpRes.getBody();
                     Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
                     
                     Map<String, Object> statusMap = (Map<String, Object>)responseMap.get('status');
                     Integer code = (Integer)statusMap.get('code');
                     
                     if( code == 200 ){
                         
                         List<Object> results = (List<Object>)responseMap.get('results');
                         
                         String serializesAddress = JSON.serialize(results);
                         /* Get all the address information into the apex class AddressInformation */
                         List<AddressInformation> addressFound = (List<AddressInformation>)JSON.deserialize(
                            serializesAddress , List<AddressInformation>.class
                         );
                         
                         /* Iterate through with the list, compare the address values & update lat, lang */
                         for(Integer i=0; i<addressFound.size(); i++){
                         
                             AddressInformation address = addressFound.get(i);
                             /* get the Address information */
                             AddressInformation.Components comp = address.Components;
                             AddressInformation.Geometry gm = address.Geometry;
                             
                         }
                         
                     }else {
                         String errorMessage = (String)statusMap.get('message');
                         
                     }
                     
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
                 System.debug('\n **** Execption Executed **** \n '+message);
             }
             
             
         }
         
    }
}