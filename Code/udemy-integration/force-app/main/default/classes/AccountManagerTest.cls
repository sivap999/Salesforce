/*
     ******** Test User Credentials *********
     Username - udemy@integration.org
     Password - donotchangeme@1
*/

@isTest
public class AccountManagerTest {

    public static testMethod void getAccountTest(){
    
        String recordId = createTestRecord();
        
        String url = '/service/apexrest/v1/Account/'+recordId;
        
        RestRequest request = new RestRequest();
        request.requestURI = url;
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        
        Test.startTest();
            AccountManager.AccountWrapper wrapper = AccountManager.accountInformation();
            System.assertNotEquals(null, wrapper);
            
        Test.stopTest();
        
    }
    
    public static testMethod void postAccountTest(){
    
        String url = '/service/apexrest/v1/Account';
        RestRequest request = new RestRequest();
        request.requestURI = url;
        request.httpMethod = 'POST';
        
        Account acc = new Account(Name='Test');
        
        Contact con = new Contact(LastName='Contact', FirstName='Test', 
                                    Email='sfdcpanther@gmail.com');
                                    
        String testMessage = 'This is the message from Test Class';
        
        AccountManager.AccountInformation information = new AccountManager.AccountInformation();
        information.accountRecord = acc;
        information.contactRecord = con;
        information.testMessage = testMessage;
        
        
        RestContext.request = request;
        
        Test.startTest();
          AccountManager.AccountInformation inserttedRec = AccountManager.postAccount(information);
            
        Test.stopTest();
        
    }
    
    

    public static testMethod void updateAccountTest(){
    
        String recordId = createTestRecord();
        
        String url = '/service/apexrest/v1/Account/'+recordId;//+'?_HttpMethod=PATCH';
        
        RestRequest request = new RestRequest();
        request.requestURI = url;
        request.httpMethod = 'PATCH';
        
        RestContext.request = request;
        
        Test.startTest();
            AccountManager.updateAccount('Cold','UDEMYTEST','Description From Test Class');
        Test.stopTest();
        
    }
    public static testMethod void updateAccountTest_Else(){
    
        String recordId = createTestRecord();
        
        String url = '/service/apexrest/v1/Account/'+recordId+'1';//+'?_HttpMethod=PATCH';
        
        RestRequest request = new RestRequest();
        request.requestURI = url;
        request.httpMethod = 'PATCH';
        
        RestContext.request = request;
        
        Test.startTest();
            AccountManager.updateAccount('Cold','UDEMYTEST','Description From Test Class');
        Test.stopTest();
        
    }
    
    public static testMethod void deleteAccountTest(){
    
        String recordId = createTestRecord();
        
        String url = '/service/apexrest/v1/Account/'+recordId;
        RestRequest request = new RestRequest();
        request.requestURI = url;
        request.httpMethod = 'DELETE';
        
        RestContext.request = request;
        Test.startTest();
            AccountManager.deleteAccount();
        Test.stopTest();
        
    }
    
    static Id createTestRecord() {
        // Create test record
        Account TestAcc = new Account(
          Name='Test record');
        insert TestAcc;
        
        Contact TestCon= new Contact(
        LastName='Test', 
        AccountId = TestAcc.id);
        
        return TestAcc.Id;
    }      
}