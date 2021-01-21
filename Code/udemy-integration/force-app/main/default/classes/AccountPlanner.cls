/*
    Information about SOAP Request
    /services/apexrest/class/namespace/v1/AccountManager
    
    /services/Soap/class/namespace/classname - Where in Soap word S will always be in Capital
    
Content-Type: text/xml; charset=UTF-8;
Accept: text/xml;
SOAPAction: '';
    
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:amit="http://soap.sforce.com/schemas/class/namespace/AccountPlanner">
   <soapenv:Header>
      <amit:SessionHeader>
         <amit:sessionId>00D2x000000EEAD!AR0AQCZy6SrMK7qIDgtWqqB92d6w3nxDoC5X6qNC.pvONhI67y.1EG1kE7vm3DZLxofBv1yR5oyvNBMHa1.ozezQQbm5sdtN</amit:sessionId>
      </amit:SessionHeader>
   </soapenv:Header>
   <soapenv:Body>
      <amit:createAccount>
         <amit:accountRec>
            <amit:Name>WebService Account</amit:Name>
            <amit:Rating>Hot</amit:Rating>
            <amit:Industry>Education</amit:Industry>
            <amit:Phone>9999999999</amit:Phone>
            <amit:AccountNumber>HJHJDUI34</amit:AccountNumber>
         </amit:accountRec>
      </amit:createAccount>
   </soapenv:Body>
</soapenv:Envelope>
    
*/

/*
     ******** Guest User Credentials *********
     Username - udemy@integration.org
     Password - donotchangeme@1
*/

global with sharing class AccountPlanner {

 webservice static String fullName(String firstName, String lastName){
     String greetMessage = 'Welcome '+firstName+' '+lastName;
     return greetMessage;
  }

  webservice static AccountWrapper createAccount(AccountWrapper accountRec){ 

    AccountWrapper accountResponse = new AccountWrapper();

    Account accRec = new Account();
    accRec.Name = accountRec.Name;
    accRec.Rating = accountRec.Rating;
    accRec.Industry = accountRec.Industry;
    accRec.Phone = accountRec.Phone;
    accRec.AccountNumber = accountRec.AccountNumber;
    
    insert accRec;
    Contact conRec = new Contact();
    conRec.LastName = accountRec.contactLastName;
    conRec.AccountId = accRec.Id;
    insert conRec;
    
    accountResponse = accountRec;
    
    return accountResponse;
    
}

global class AccountWrapper {

    webservice String Name;
    webservice String Rating;
    webservice String Industry;
    webservice String Phone;
    webservice String AccountNumber;
    webservice String contactLastName;
    
   }
 
 }