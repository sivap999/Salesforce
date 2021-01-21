/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 11-20-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   11-19-2020   Amit Singh   Initial Version
**/

trigger LogoutEventStreamTrigger on LogoutEventStream (after insert) {
    List<LogoutEvent__c> eventList = new List<LogoutEvent__c>();
    For(LogoutEventStream event : Trigger.new){
        LogoutEvent__c record            = new LogoutEvent__c();
        record.EventIdentifier__c        = event.EventIdentifier;
        record.UserId__c                 = event.UserId;
        record.Username__c               = event.Username;
        record.EventDate__c              = event.EventDate;
        record.RelatedEventIdentifier__c = event.RelatedEventIdentifier;
        record.ReplayId__c               = event.ReplayId;
        record.SessionLevel__c           = event.SessionLevel;
        record.SourceIp__c               = event.SourceIp;
        record.SessionKey__c             = event.SessionKey;
        record.LoginKey__c               = event.LoginKey;
        eventList.add(record);
        
    }
    //insert eventList;
}