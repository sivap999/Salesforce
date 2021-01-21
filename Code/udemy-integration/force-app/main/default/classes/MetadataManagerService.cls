/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 12-28-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   12-28-2020   Amit Singh   Initial Version
**/
public with sharing class MetadataManagerService {
    
    @AuraEnabled(continuation=true cacheable=true)
    public static String listMetadata(){
        List<MetadataService.FileProperties> fileProperties = MetadataUtil.listMetadata('CustomObject');
        return JSON.serialize(FileProperties);
    }

    @AuraEnabled(continuation=true)
    public static String readMetadata(String objectApiName) {
        MetadataService.CustomObject objectInformation = MetadataUtil.readCustomObjectMetadata(objectApiName);
        return JSON.serialize(objectInformation);
    }
}