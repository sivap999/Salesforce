/*
    public
    private
    global
    virtual

*/
public with sharing class AccountController {

    public Account accountRecord { get; set; } // Object
    public Opportunity oppRecord { get; set; } // Object
    public Contact conRecord     { get; set; } // Object

    public AccountController(ApexPages.StandardController controller) {
           accountRecord = new Account();
           oppRecord     = new Opportunity();
           conRecord     = (Contact)controller.getRecord();
    }
    
    public PageReference saveRecords() {
    
        try {
        
            insert accountRecord; // Id
            oppRecord.AccountId = accountRecord.Id;
            insert oppRecord;
            
            conRecord.AccountId     = accountRecord.Id;
            conRecord.MailingStreet = accountRecord.BillingStreet;
            conRecord.MailingCity   = accountRecord.BillingCity;
            conRecord.MailingState  = accountRecord.BillingState;
            conRecord.MailingPostalCode = accountRecord.BillingPostalCode;
            conRecord.Mailingcountry = accountRecord.Billingcountry;
            insert conRecord;
            
            PageReference acctPage = new PageReference('/'+accountRecord.Id);
            acctPage.setRedirect(true);
            
            return null;
            
        } catch (System.Exception ex) {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                   String.valueOf(ex.getMessage())
               )
           );
           return null;
        }
        
    }

}