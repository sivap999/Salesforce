public class PipeDriveUserBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id from User Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint('https://sfdcpanther.pipedrive.com/api/v1/users?api_token=e027a80163779d475dc441d55bcc86b93c0bff07');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        String errorMessage = '';
        try{
            
            response = http.send(httpReq);
            
            if( response.getStatusCode() == 200  ){
                
                String responseBody = response.getBody();
                
                PipeDriveUsers users = (PipeDriveUsers)System.JSON.deserialize(responseBody, PipeDriveUsers.class);
                
                List<PipeDriveUsers.data> usersData = new List<PipeDriveUsers.data>();
                usersData = users.data;
                
                List<Pipedrive_User__c> userList = new List<Pipedrive_User__c>();
                
                for(PipeDriveUsers.data user : usersData){
                    
                    Pipedrive_User__c u = new Pipedrive_User__c();
                    u.activated__c = user.activated;
                    u.default_currency__c = user.default_currency;
                    u.email__c = user.email;
                    u.Is_Active__c = user.activated;
                    u.Is_Admin__c = user.is_admin == 1? true:false;
                    u.last_login__c = user.last_login;
                    u.locale__c	      = user.locale;
                    u.Name	= user.name;
                    u.Pipedrive_Id__c = String.valueOf(user.id);
                    u.timezone_name__c = user.timezone_name;
                    u.timezone_offset__c = user.timezone_offset;
                    
                    userList.add(u);
                    
                }
                
                upsert userList Pipedrive_Id__c;
                
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