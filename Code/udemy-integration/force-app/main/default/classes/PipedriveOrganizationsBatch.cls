public class PipedriveOrganizationsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id from User Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint('https://sfdcpanther.pipedrive.com/api/v1/organizations?api_token=e027a80163779d475dc441d55bcc86b93c0bff07');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        String errorMessage = '';
        try{
            
            response = http.send(httpReq);
            
            if( response.getStatusCode() == 200  ){
                
                String responseBody = response.getBody();
                
                PipedriveOrganization orgaization = (PipedriveOrganization)System.JSON.deserialize(responseBody, PipedriveOrganization.class);
                
                List<PipedriveOrganization.data> accounts = new List<PipedriveOrganization.data>();
                accounts = orgaization.data;
                
                List<Account> pipedriveAccounts = new List<Account>();
                
                for(PipedriveOrganization.data acc : accounts){
                    
                    Account a = new Account();
                    a.Name = acc.name;
                    a.Organization_id__c = String.valueOf(acc.id);
                    a.active_p__c = acc.active_flag;
                    
                    a.activities_count__c = acc.activities_count;
                    a.cc_email__c = acc.cc_email;
                    a.closed_deals_count__c = acc.closed_deals_count;
                    a.done_activities_count__c = acc.done_activities_count;
                    a.email_messages_count__c = acc.email_messages_count;
                    a.files_count__c = acc.files_count;
                    a.followers_count__c	= acc.followers_count;
                    a.lost_deals_count__c = acc.lost_deals_count;
                    a.notes_count__c	= acc.notes_count;
                    a.open_deals_count__c = a.open_deals_count__c;
                    a.owner_name__c = acc.owner_name;
                    a.people_count__c	= acc.people_count;
                    a.related_closed_deals_count__c = acc.related_closed_deals_count;
                    a.related_lost_deals_count__c = acc.lost_deals_count;
                    a.related_open_deals_count__c = acc.related_open_deals_count;
                    a.related_won_deals_count__c	= acc.related_won_deals_count;
                    a.won_deals_count__c = acc.won_deals_count;
                    
                    Pipedrive_User__c owner = new Pipedrive_User__c(Pipedrive_Id__c = String.valueOf(acc.owner_id.id));
                    a.Pipedrive_Owner__r = owner;
                    
                    pipedriveAccounts.add(a);
                }
                
                upsert pipedriveAccounts Organization_id__c;
                
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