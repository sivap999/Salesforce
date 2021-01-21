public class PlatformEventBatchDemo implements Database.Batchable<sObject>, Database.RaisesPlatformEvents {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id FROM ACCOUNT LIMIT 10' 
        );
    }
    public void execute(Database.BatchableContext bc, List<sObject> records){
        Integer i = 10/0;
    }
    public void finish(Database.BatchableContext bc){
        
    }
}