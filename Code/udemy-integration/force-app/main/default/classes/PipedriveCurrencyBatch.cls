public class PipedriveCurrencyBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id from User Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint('https://sfdcpanther.pipedrive.com/api/v1/currencies?api_token=e027a80163779d475dc441d55bcc86b93c0bff07');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        String errorMessage = '';
        try{
            
            response = http.send(httpReq);
            
            if( response.getStatusCode() == 200  ){
                
                String responseBody = response.getBody();
                
                PipedriveCurrency currencies = (PipedriveCurrency)System.JSON.deserialize(responseBody, PipedriveCurrency.class);
                
                List<PipedriveCurrency.data> currenciesList = new List<PipedriveCurrency.data>();
                currenciesList = currencies.data;
				
				List<Currency__c> currencyList = new List<Currency__c>();                
                for(PipedriveCurrency.data curr : currenciesList){
                    Currency__c c = new Currency__c();
                    c.Name	    = curr.name;
                    c.Active__c = curr.active_flag;
                    c.Code__c = curr.code;
                    c.Custom__c = curr.is_custom_flag;
                    c.decimal_points__c = curr.decimal_points;
                    c.Id__c	= String.valueOf(curr.id);
                    c.Symbol__c = curr.symbol;
                    
                    currencyList.add(c);
                }
                
                upsert currencyList Id__c;
                
                
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