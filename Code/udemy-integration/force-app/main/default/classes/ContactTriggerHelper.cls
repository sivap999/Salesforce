public class ContactTriggerHelper {
    
    public static void deleteOldestContact(Set<Id> accountIdsSet, Set<Id> newContactIdsSet ) {
        
        Map<Id, Account> accountMap = new Map<Id, Account>([
            SELECT Id, (SELECT Id, Name From Contacts Order by CreatedDate asc Limit 1)
            FROM ACCOUNT
            WHERE Id IN:accountIdsSet
        ]);
        
        List<Contact> contactListToDelete;
        
        for(Integer i=0; i< accountMap.size(); i ++ ){
            Account accRecord = accountMap.get(accountMap.values().get(i).Id);
            if(accRecord.contacts!=null && !accRecord.contacts.isEmpty()){
                if(contactListToDelete == null)
                    contactListToDelete = new List<Contact>();
                    
                contactListToDelete.addAll(accRecord.contacts);
            }
        }
        
        if(!contactListToDelete.isEmpty()){
            Database.delete(contactListToDelete, false );
        }
    }
}