public class PipedriveActivityBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id from User Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint('https://sfdcpanther.pipedrive.com/api/v1/activities?api_token=e027a80163779d475dc441d55bcc86b93c0bff07');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        String errorMessage = '';
        try{
            
            response = http.send(httpReq);
            
            if( response.getStatusCode() == 200  ){
                
                String responseBody = response.getBody();
                responseBody = responseBody.replace('currency', 'currency_x');
                responseBody = responseBody.replace('type', 'type_x');
                
                PipedriveActivities activities = (PipedriveActivities)System.JSON.deserialize(responseBody, PipedriveActivities.class);
                
                List<PipedriveActivities.data> activitiesRecords = new List<PipedriveActivities.data>();
                activitiesRecords = activities.data;
                                
                List<Opportunity> pipedriveDeals = new List<Opportunity>();

                for(PipedriveActivities.data act : activitiesRecords){
                    
                    
                }
                try{
                    upsert pipedriveDeals Pipedrive_Id__c; 
                }catch(System.Exception e){
                    System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+e.getMessage());
                }
                
            }else{
                
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
                
            }
        }catch(System.Exception e){
            
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add https://sfdcpnather.pipedrive.com Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode()+' '+e.getStackTraceString();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
            
        }
    }
    
    public void finish(Database.BatchableContext BC) {
    }
}