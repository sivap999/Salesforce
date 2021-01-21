public class PipedrivePersonBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id from User Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint('https://sfdcpanther.pipedrive.com/api/v1/persons?api_token=e027a80163779d475dc441d55bcc86b93c0bff07');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        String errorMessage = '';
        try{
            
            response = http.send(httpReq);
            
            if( response.getStatusCode() == 200  ){
                
                String responseBody = response.getBody();
                
                PipedrivePerson persons = (PipedrivePerson)System.JSON.deserialize(responseBody, PipedrivePerson.class);
                
                List<PipedrivePerson.data> contacts = new List<PipedrivePerson.data>();
                contacts = persons.data;
                
                List<Contact> pipedriveContacts = new List<Contact>();
                
                for(PipedrivePerson.data con : contacts){
                    Contact c = new Contact();
                    c.Pipedrive_Id__c = String.valueOf(con.id);
                    c.FirstName = con.first_name;
                    c.LastName  = con.last_name == null ? con.name:con.last_name ;
                    c.active__c = con.active_flag;
                    c.activities_count__c = con.activities_count;
                    c.closed_deals_count__c = con.closed_deals_count;
                    c.done_activities_count__c = con.done_activities_count;
                    c.email_messages_count__c  = con.email_messages_count;
                    c.files_count__c	= con.files_count;
                    c.followers_count__c = con.followers_count;
                    c.lost_deals_count__c = con.lost_deals_count;
                    c.notes_count__c = con.notes_count;
                    c.open_deals_count__c = con.open_deals_count;
                    c.participant_closed_deals_count__c = con.participant_closed_deals_count;
                    c.participant_open_deals_count__c	= con.participant_open_deals_count;
                    c.related_closed_deals_count__c = con.related_closed_deals_count;
                    c.related_lost_deals_count__c = con.related_lost_deals_count;
                    c.related_open_deals_count__c = con.related_open_deals_count;
                    c.related_won_deals_count__c = con.related_won_deals_count;
                    c.undone_activities_count__c = con.undone_activities_count;
                    c.won_deals_count__c = con.won_deals_count;
                    
                    Pipedrive_User__c owner = new Pipedrive_User__c(Pipedrive_Id__c = String.valueOf(con.owner_id.id));
                    c.Pipedrive_Owner__r = owner;
                    
                    Account org = new Account(Organization_Id__c = String.valueOf(con.org_id.value));
                    c.Account = org;
                    
                    pipedriveContacts.add(c);
                }
                try{
                    upsert pipedriveContacts Pipedrive_Id__c;
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