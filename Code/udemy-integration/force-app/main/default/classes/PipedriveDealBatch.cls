public class PipedriveDealBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id from User Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint('https://sfdcpanther.pipedrive.com/api/v1/deals?api_token=e027a80163779d475dc441d55bcc86b93c0bff07');
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
                
                PipedriveDeal deals = (PipedriveDeal)System.JSON.deserialize(responseBody, PipedriveDeal.class);
                
                List<PipedriveDeal.data> dealRecords = new List<PipedriveDeal.data>();
                dealRecords = deals.data;
                
                System.debug(' deals '+deals);
                
                List<Opportunity> pipedriveDeals = new List<Opportunity>();
                
                List<Stage__c> stageList = [Select Id__c, Id, Name FROM Stage__c Limit 100];
                Map<String, String> stagesMap = new Map<String, String>();
                for(Stage__c s : stageList){
                    stagesMap.put(s.Id__c, s.Name);
                }

                for(PipedriveDeal.data deal : dealRecords){
                    
                    Opportunity opp = new Opportunity();
                    opp.Name = deal.title;
                    opp.title__c = deal.title;
                    opp.Amount = Decimal.valueOf(deal.value);
                    opp.CurrencyIsoCode = deal.currency_x;
                    opp.Pipedrive_Id__c = String.valueOf(deal.id);
                    
                    if(deal.expected_close_date != null){
                        List<String> dates  = deal.expected_close_date.split('-');
                        opp.CloseDate = date.newInstance(Integer.valueOf(dates.get(0)), Integer.valueOf(dates.get(1)), Integer.valueOf(dates.get(2)));
                    }else{
                        opp.CloseDate = System.today();
                    }
                    opp.StageName	= stagesMap.get(String.valueOf(deal.stage_id));
                    
                    Pipedrive_User__c owner = new Pipedrive_User__c(Pipedrive_Id__c = String.valueOf(deal.user_id.value));
                    opp.Pipedrive_Owner__r = owner;
                    
                    Account org = new Account(Organization_Id__c = String.valueOf(deal.org_id.value));
                    opp.Account = org;
                    
                    Contact person = new Contact(Pipedrive_Id__c = String.valueOf(deal.person_id.value) );
                    opp.Pipedrive_Person__r = person;
                    
                    pipedriveDeals.add(opp);
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