public class PipedriveStageBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id from User Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint('https://sfdcpanther.pipedrive.com/api/v1/stages?api_token=e027a80163779d475dc441d55bcc86b93c0bff07');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        String errorMessage = '';
        try{
            
            response = http.send(httpReq);
            
            if( response.getStatusCode() == 200  ){
                
                String responseBody = response.getBody();
                
                PipedriveStage stages = (PipedriveStage)System.JSON.deserialize(responseBody, PipedriveStage.class);
                
                List<PipedriveStage.data> stageList = new List<PipedriveStage.data>();
                stageList = stages.data;
                
                List<Stage__c> stagesList = new List<Stage__c>();
                
                for(PipedriveStage.data stage : stageList){
                    Stage__c s = new Stage__c();
                    s.Active__c = stage.active_flag;
                    s.Deal_Probability__c = stage.deal_probability;
                    s.Id__c = String.valueOf(stage.id);
                    s.Pipeline_Name__c = stage.pipeline_name;
                    s.Name	= stage.name;
                    stagesList.add(s);
                }
                
                upsert stagesList Id__c;
                
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
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
            
        }
    }
    
    public void finish(Database.BatchableContext BC) {
    }
    
}