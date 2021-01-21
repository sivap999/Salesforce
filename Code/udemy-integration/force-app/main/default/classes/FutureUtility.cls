public class FutureUtility {
    
    /*
     *  Insert/Delete operation is allowed on Group Object with other obejcts.
     *  GroupMember
        ObjectPermissions PermissionSet PermissionSetAssignment
        QueueSObject
        ObjectTerritory2AssignmentRule ObjectTerritory2AssignmentRuleItem RuleTerritory2Association
        SetupEntityAccess Territory2 Territory2Model UserTerritory2Association
        User 
     */ 
    /*
     	Account acc = new Account(Name='Future Account', 
                          Rating='Cold', 
                          Industry='Banking',
                          Description = 'demo description'
                         );
        insert acc;
        FutureUtility.futureWithSObject(JSON.serialize(acc));
        acc.Name = 'Salesforce';
        acc.Description = 'Update From Future Salesforce';
        update acc;
        System.debug(' \n **** acc **** \n'+acc.Id);
     */ 

    @future
    public static void futureWithSObject(String accountRecord) {
        
        Account accRec = (Account)JSON.deserialize(accountRecord, Account.class);
        
        //accRec.Name = 'Salesforce California';
        accRec.Rating = 'Cold';
        accRec.Industry = 'Technology';
        //accRec.Description = 'Update From Future Method which accepts sObject as input';
        
        update new List<Account>{accRec};
    }
    
    @future
    public static void futureWithoutSObject(String Id) {
        List<Account> accountList = [SELECT Id, Name, Rating, Industry, Description FROM Account Where Id =:Id];
        if(!accountList.isEmpty()){
            Account accountRecord = accountList.get(0);
            //accountRecord.Name = 'Salesforce California HQ';
            accountRecord.Rating = 'Warm';
            accountRecord.Industry = 'Education';
            //accountRecord.Description = 'Update From Future Method';
            
            update new List<Account>{accountRecord};
        }
    }
   
    public static void updateUsersWithNoDMLError() {
        User userRec = new User(Id = userInfo.getUserId());
        userRec.Title = 'Salesforce MVP';
        update userRec;
    }
    
    /*
     *  UserRoleId
        IsActive
        ForecastEnabled
        IsPortalEnabled
        Username
        ProfileId
     */ 
    public static void updateUserWithMixedDMLError() {
        User userRec = new User(Id = userInfo.getUserId());
        userRec.Title = 'Salesforce Developer';
        List<UserRole> userRoleList = [Select Id, Name From UserRole Where Name ='CEO'];
        if(!userRoleList.isEmpty()){
            userRec.UserRoleId = userRoleList.get(0).Id;
        }
        update userRec;
    }
    
    public static void createUserWithRole() {
        User u = getUserRecord(
            'Standard User', 'amitsingh@sfdcpanther.com', 'Amit', 'Singh', 'CEO'
        );
        insert u;
    }
    
    public static void createUserWithoutRole() {
        User u = getUserRecord(
            'Chatter Free User', 'amitsingh@sfdcpanther.com', 'Future', 'Demo', ''
        );
        insert u;
    }
    
    @future
    public static void addUsersToGroup() {
        List<Group> groupList = [SELECT Id, Name, DeveloperName, Type FROM Group Where Type = 'Regular'];
        if(!groupList.isEmpty()){
            Group apacEmployees = groupList.get(0);
            GroupMember grpMember = new GroupMember();
            grpMember.GroupId = apacEmployees.Id;
            grpMember.UserOrGroupId = UserInfo.getUserId();
            insert new List<GroupMember>{grpMember};
        }
    }
    
    @future(callout=true)
    public static void validatePhone(String accountId) {
        
        List<Account> accountList = [SELECT Id, Phone FROM Account 
                                     WHERE Id =: accountId ];
        
        if(!accountList.isEmpty()){
            
            Account acc = accountList.get(0);
            
            String message = '';
            
            /* Prepare Endpoint to be Executed from Salesforce */
            
            String endPoint = System.LABEL.NumVerifyURL+'?access_key='+System.Label.NumVerifyAPI+'&number='+acc.Phone+'country_code=&format=1';
            
            /* Prepare the HttpRequest */
            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint(endPoint);
            httpReq.setMethod('GET');
            httpReq.setHeader('Content-Type','application/json');
            httpReq.setTimeout(12000); // 10 sec // 120 sec
            
            /* Create Http object to send the request */
            Http http = new Http();
            
            /* Create an Objet of HttpResponse to store the Response */
            HttpResponse httpRes = new HttpResponse();
            
                
                httpRes = http.send(httpReq);
                Integer statusCode = httpRes.getStatusCode();
                
                if(statusCode==200){
                    String responseBody = httpRes.getBody();
                    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
                    Boolean isValid = (Boolean)responseMap.get('valid');
                    
                    if(isValid){
                        acc.Phone_Validation__c = 'Valid';
                    }else{
                        acc.Phone_Validation__c = 'InValid';
                    }
                    update acc;
                }else{
                    
                    message += 'An Error occured while making the API Callout ';
                    message += httpRes.getBody();
                    System.debug('\n **** Error Occured **** \n '+message);
                    
                }
                
            
            
            
        }
    }
    
    public static User getUserRecord(String profileName, String email, 
                                   String firstName, String lastName, String roleName) {
                                      
        User userRecord = new User();
        List<Profile> profileList = [Select Id, Name From Profile Where Name  =:profileName ];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
                                      
        if(!profileList.isEmpty()){
            userRecord = new User(Alias = uniqueName.substring(18, 23), 
                                  Email = email,
                                  FirstName = firstName,
                                  LastName  = lastName,
                                  EmailEncodingKey = 'UTF-8',  
                                  LanguageLocaleKey = 'en_US', 
                         		  LocaleSidKey = 'en_US', 
                                  ProfileId = profileList.get(0).Id, 
                         		  TimeZoneSidKey ='America/Los_Angeles', 
                         		  UserName = uniqueName + '@test' + orgId + '.org');
        }
                                      
        List<UserRole> userRoleList = [Select Id, Name From UserRole Where Name =: roleName];
        if(!userRoleList.isEmpty()){
            userRecord.UserRoleId = userRoleList.get(0).Id;
        }
        return userRecord;
    }
    
}