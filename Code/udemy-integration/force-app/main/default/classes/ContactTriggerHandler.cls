public class ContactTriggerHandler {
    
    public static String contactBody = '';
    
    public static void handleBeforeInsert(String body){
        contactBody = body;
    }
    
    @future(callout=true)
    public static void handleAfterInsert(Id contactId ){
        
        List<Contact> contactList = [Select FirstName, LastName, Email, Title, Phone From Contact Where Id  =: contactId];
        
        Contact conRecord = [Select FirstName, LastName, Email, Title, Phone From Contact Where Id  =: contactId];
        
        ContactWrapper wrapper = new ContactWrapper();
        for(Contact con : contactList){
            wrapper.FirstName	= con.FirstName;
            wrapper.LastName	= con.LastName;
            wrapper.Email	= con.Email;
            wrapper.Title	= con.Title;
            wrapper.Phone	= con.Phone;
        }
        String requestBody = JSON.serialize(wrapper);
        
        if(!String.isBlank(requestBody)){
            SalesforceUtil.createContact(requestBody);
        }
    }
    
    public class ContactWrapper {
        public String FirstName {get; set;}
        public String LastName  {get; set;}
        public String Email     {get; set;}
        public String Title		{get; set;}
        public String Phone		{get; set;}
    }
}