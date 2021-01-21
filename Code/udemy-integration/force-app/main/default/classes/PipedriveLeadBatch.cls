public class PipedriveLeadBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id from User Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint('https://sfdcpanther.pipedrive.com/api/v1/leads?api_token=e027a80163779d475dc441d55bcc86b93c0bff07');
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
                
                PipedriveLead leads = (PipedriveLead)System.JSON.deserialize(responseBody, PipedriveLead.class);
                
                List<PipedriveLead.data> leadRecords = new List<PipedriveLead.data>();
                leadRecords = leads.data;
                
                List<Lead> pipedriveLeads = new List<Lead>();
                
                List<Pipedrive_User__c> users = new List<Pipedrive_User__c>();
                for(PipedriveLead.data lead : leadRecords){

                    Lead l = new Lead();
                    
                    l.LastName  = lead.title;
                    
                    l.Company = lead.title;
                    l.Status = 'Working - Contacted';
                    l.Pipedrive_Id__c = lead.id;
                    
                    l.Note__c = lead.note;
                    
                    PipedriveLead.value value = lead.value;
                    
                    l.Amount__c = value.amount;
                    l.CurrencyIsoCode = value.currency_x;
                    
                    Pipedrive_User__c owner = new Pipedrive_User__c(Pipedrive_Id__c = String.valueOf(lead.owner_id));
                    l.Pipedrive_Owner__r = owner;
                    users.add(owner);
                    
                    Account org = new Account(Organization_Id__c = String.valueOf(lead.organization_id));
                    l.Pipedrive_Organization__r = org;
                    
                    Contact person = new Contact(Pipedrive_Id__c = String.valueOf(lead.person_id) );
                    l.Pipedrive_Contact__r = person;
                    
                    pipedriveLeads.add(l);
                }
                try{
                    //upsert users;
                    upsert pipedriveLeads Pipedrive_Id__c; 
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