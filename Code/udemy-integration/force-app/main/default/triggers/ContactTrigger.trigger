trigger ContactTrigger on Contact(before insert, after insert) {
    
    if(Trigger.isBefore && Trigger.isInsert && !System.isFuture() && !System.isBatch()) {
        
        Contact con = Trigger.new.get(0);
        Contact wrapper = new Contact();
        wrapper.FirstName	= con.FirstName;
        wrapper.LastName	= con.LastName;
        wrapper.Email	= con.Email;
        wrapper.Title	= con.Title;
        wrapper.Phone	= con.Phone;
        ContactTriggerHandler.handleBeforeInsert( JSON.serialize(wrapper) );
        
    }
    if(Trigger.isAfter && Trigger.isInsert && !System.isFuture() && !System.isBatch()) {
        
        ContactTriggerHandler.handleAfterInsert( Trigger.new.get(0).Id );
        
    }
    
}