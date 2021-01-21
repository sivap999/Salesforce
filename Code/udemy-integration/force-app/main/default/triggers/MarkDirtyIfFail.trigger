/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 11-18-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   11-18-2020   Amit Singh   Initial Version
**/
trigger MarkDirtyIfFail on BatchApexErrorEvent (after insert) {
    
    Set<Id> asyncApexJobIds = new Set<Id>();
    for(BatchApexErrorEvent evt:Trigger.new){
        asyncApexJobIds.add(evt.AsyncApexJobId);
    }
    
    Map<Id,AsyncApexJob> jobs = new Map<Id,AsyncApexJob>(
        [SELECT id, ApexClass.Name FROM AsyncApexJob WHERE Id IN :asyncApexJobIds]
    );
    
    List<Account> records = new List<Account>();
    for(BatchApexErrorEvent evt:Trigger.new){
        if(jobs.get(evt.AsyncApexJobId).ApexClass.Name == 'PlatformEventBatchDemo'){
            for (String item : evt.JobScope.split(',')) {
                Account a = new Account(
                    Id = (Id)item,
                    ExceptionType__c = evt.ExceptionType,
                    Dirty__c = true
                );
                records.add(a);
            }
        }
    }
    update records;
}