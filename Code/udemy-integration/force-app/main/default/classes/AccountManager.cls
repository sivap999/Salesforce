/*
     ******** Test User Credentials *********
     Username - udemy@integration.org
     Password - donotchangeme@1
*/
/*

  https://ap17.salesforce.com/services/apexrest/v1/Account/
  https://ap17.salesforce.com/services/apexrest/v1/Account/
  
  Sample Request for JSON as input ( for the wrapper class that we used )
  
  {
     "information" : {
        "accountRecord" : {
          "Name" : "JSON Account"
        },
        "contactRecord" : {
          "LastName" : "JSON",
          "FirstName" : "Contact"
        },
        "testMessage":"Contact us for any questions on your order."
     }
  }
*/

@RestResource(urlmapping='/v1/Account/*')
global class AccountManager {


    @httpPatch
    global static ResponseWrapper updateAccount(String rating, String accNumber, 
                                        String description){
        // Get the Account Id from URI
        RestRequest request = RestContext.request;
        String requestURI = request.requestURI;
        String accountId = requestURI.subStringAfterLast('/');
        // prepare the account rec
        List<Account> accountList = [Select Id FROM Account Where Id =: accountId];
        Account accRec;
        ResponseWrapper wrapper = new ResponseWrapper();
        if(accountList!=null && accountList.size() > 0 ){
            accRec = new Account(Id = accountId, Rating = rating, AccountNumber = accNumber,
            Description = description );
            update accRec;
            wrapper.accRec = accRec;
            wrapper.message = 'Account Record Updated';
        }else{
            wrapper.message = 'Account Record Not Found';
        }
        return wrapper;
    }
    
    @httpDelete
    global static String deleteAccount(){
    
        RestRequest request = RestContext.request;
        String requestURI = request.requestURI;
        System.debug('requestURI '+requestURI);
        String accountId = requestURI.subStringAfterLast('/');
        
        List<Account> accList = [Select Id From Account Where Id =: accountId ];
        if(accList != null && accList.size() >0){
            try{
                delete accList;
                return '{"message":"Account Record Deleted"}';
            }catch(System.Exception ex){
                String errrorMeesage = ex.getMessage();
                return '{"message":"'+errrorMeesage+'"}';
            }
        }else{
            return '{"message":"Account Record not Found"}';
        }
        
    }

    @httpPost
    global static AccountInformation postAccount(AccountInformation information ){
       Account accountRecord = information.accountRecord;
       insert accountRecord;
       Contact conRec = information.contactRecord;
       conRec.AccountId = accountRecord.Id;
       conRec.Description = information.testMessage;
       insert conRec;
       return information;
    }

    @httpGet
    global static AccountWrapper accountInformation(){
    
        RestRequest request = RestContext.request;
        String requestURI = request.requestURI;
        String accountId = requestURI.subStringAfterLast('/');
        
        List<Account> accountList = [Select Id, Name, Rating, 
                                        Industry, Description, Phone, Fax
                                    FROM Account Where Id =: accountId];
                                    
        List<Contact> contactList = [Select Id, Name, FirstName, LastName, Email, Phone
                                        FROM Contact
                                     Where AccountId =: accountId ];
                                     
        List<Case> caseList = [Select Id, CaseNumber, Subject, Description, Status, Owner.Name
                                FROM Case
                               Where AccountId =: accountId];
                               
        AccountWrapper wrapper = new AccountWrapper();
        
        if(!accountList.isEmpty()){
            wrapper.accountRecord = accountList.get(0);
            wrapper.contactList = contactList;
            wrapper.caseList = caseList;
        }else{
        
        }
        
        return wrapper;
                               
    }
    
    @httpPut
    global static Account updateAccountInformation(String accName, String Rating, String accNumber){
        RestRequest request = RestContext.request;
        String requestURI = request.requestURI;
        String accountId = requestURI.subStringAfterLast('/');
        
        Account acc = new Account(Id = accountId, Name = accName, Rating = Rating, AccountNumber = accNumber);
        update acc;
        
        return acc;
    }
    
    global class AccountInformation{
        global Account accountRecord { get; set; }
        global Contact contactRecord { get; set; }
        global String testMessage { get; set ; }
    }
    
    global class AccountWrapper {
        global Account accountRecord;
        global List<Contact> contactList;
        global List<Case> caseList;
    }
    
    global class ResponseWrapper{
        global Account accRec;
        global String message;
    }
    
}