public class QuickbooksUtil {
    
    public static String quickBooksQuery(){
        String query = SOQLUtil.buildSOQLQuery('qb_Metadata__mdt', System.Label.QuickbookSandbox);
        return query;
    }
    
    public static qb_Metadata__mdt quickbooksCred(){
        String query   = quickBooksQuery();
        List<qb_Metadata__mdt> qb_CredList = Database.query(query);
        qb_Metadata__mdt qb_Cred = new qb_Metadata__mdt();
        if(qb_CredList != null && !qb_CredList.isEmpty()){
            qb_Cred     = qb_CredList.get(0);
        }else{
            return null;
        }
        return qb_Cred;
    }
    
    public PageReference accessToken(){
        
        String query   = quickBooksQuery();
        List<qb_Metadata__mdt> qb_CredList = Database.query(query);
        qb_Metadata__mdt qb_Cred = new qb_Metadata__mdt();
        
        String errorMessage = '';
        
        if(qb_CredList != null && !qb_CredList.isEmpty()){
            qb_Cred     = qb_CredList.get(0);
        }else{
            return null;
        }

        String code    = ApexPages.currentPage().getParameters().get('code');
        String realmId = ApexPages.currentPage().getParameters().get('realmId');
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/'+qb_Cred.PageName__c;
        
        String requestBody = 'grant_type=authorization_code&code='+code+'&redirect_uri='+baseUrl;
        
        String endPoint      = qb_Cred.token_url__c;
        String basic         = qb_Cred.Client_Id__c+':'+qb_Cred.Client_Secret__c;
        String encodedString = 'Basic '+EncodingUtil.base64Encode( Blob.valueOf(basic) );

        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('POST');
        httpReq.setEndpoint(endPoint);
        httpReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        httpReq.setHeader('Accept', 'application/json');
        httpReq.setHeader('Authorization', encodedString );
        httpReq.setBody(requestBody);
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                
                String responseBody = response.getBody();
                
                QuickbooksToken token = (QuickbooksToken)System.JSON.deserialize(responseBody, QuickbooksToken.class);
                
                Map<String, Object> tokenMap = new Map<String, Object>();
                
                tokenMap.put('realmId__c', realmId);
                tokenMap.put('expires_in__c',Decimal.valueOf(token.expires_in));// 3600
                tokenMap.put('expires_in_time__c',System.now().addSeconds(token.expires_in));// 12:00-1:00PM,1:01 PM
                tokenMap.put('access_token__c', token.access_token );
                tokenMap.put('refresh_token__c', token.refresh_token);
                tokenMap.put('token_type__c', token.token_type);
                String fullName = 'qb_Metadata.'+System.Label.QuickbookSandbox;
                CreateUpdateMetadataUtils.createUpdateMetadata(fullName,System.Label.QuickbookSandbox,tokenMap);
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,
                                                           'Successfully Authenticated! You can close the window now.'));
                
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, response.getBody() ));
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        } 
        return null;
    }
    
    public static Map<String, Object> refreshToken(qb_Metadata__mdt qb_Cred){
        
        String errorMessage = '';
        
        String endPoint = qb_Cred.token_url__c;
        
        String basic    = qb_Cred.Client_Id__c+':'+qb_Cred.Client_Secret__c;
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/'+qb_Cred.PageName__c;
        
        String requestBody = 'grant_type=refresh_token&refresh_token='+qb_Cred.refresh_token__c;
        
        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('POST');
        httpReq.setEndpoint(endPoint);
        httpReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        httpReq.setHeader('Accept', 'application/json');
        httpReq.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(basic)));
        httpReq.setBody(requestBody);
        HttpResponse response = new HttpResponse();
        
        Map<String, Object> tokenMap = new Map<String, Object>();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                
                String responseBody = response.getBody();
                
                QuickbooksToken token = (QuickbooksToken)System.JSON.deserialize(responseBody, QuickbooksToken.class);
                tokenMap.put('expires_in__c',Decimal.valueOf(token.expires_in));
                tokenMap.put('expires_in_time__c',System.now().addSeconds(token.expires_in));
                tokenMap.put('access_token__c', token.access_token );
                tokenMap.put('refresh_token__c', token.refresh_token);
                
                // You have some uncomitted or pending work, please commit or rollback
                // Callout
                // DML, Deployment
                
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed in Refresh Token '+response.getBody());
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed in Refresh Token '+errorMessage);
        } 
        return tokenMap;
    }
    
    public static Boolean checkTokenValidity(qb_Metadata__mdt token){
        Boolean isValid = true;
        if(token.expires_in_time__c < system.now()){
            isValid = false;
        }
        return isValid;
    }
    
    public static void createCustomer( QuickbooksCustomer customer ){
        
        qb_Metadata__mdt qb_Cred = quickbooksCred();
        
        if(qb_Cred != null && String.isBlank(qb_Cred.access_token__c)){
            return;
        }
        
        String accessToken = qb_Cred.access_token__c;
        
        Boolean isValid = checkTokenValidity(qb_Cred);
        Map<String, Object> refreshTokenMap = new Map<String, Object>();
        
        if(!isValid){
            refreshTokenMap = refreshToken(qb_Cred);
            accessToken     = (String)refreshTokenMap.get('access_token__c');
        }
        //https://sandbox-quickbooks.api.intuit.com/v3/company/4620816365150899770/customer?minorversion=55
        String endPoint = qb_Cred.Environment__c == 'Sandbox'?qb_Cred.Sanbdox_Base_URL__c : qb_Cred.Prod_Base_URL__c;
        
        String customerURL = qb_Cred.Create_Customer__c;
        customerURL = customerURL.replace('{realmId}', qb_Cred.realmId__c);
        
        String finalEndpoint = endPoint + customerURL + qb_Cred.minorversion__c;
        
        String errorMessage = '';
        
        customer.FullyQualifiedName = 'Ankit Singh';
        
        QuickbooksCustomer.PrimaryEmailAddr email = new QuickbooksCustomer.PrimaryEmailAddr();
        email.Address = 'ankit.singh@myemail.com';
        
        customer.PrimaryEmailAddr = email;
        
        customer.DisplayName = 'Ankit Singh';
        customer.Notes = 'Creating the custom from Salesforce As part of demo';
        
        QuickbooksCustomer.PrimaryPhone phone = new QuickbooksCustomer.PrimaryPhone();
        phone.FreeFormNumber = '9087876542';
        customer.PrimaryPhone = phone;
        
        customer.CompanyName = 'Salesforce.com';
        
        /*
            customer.FamilyName = 'Marc';
            cusromer.Suffi = 'Sr';
            cusromer.Title = 'Mrs';
            cusromer.MiddleName = 'Ben';
            customer.GivenName = 'Marc';

			QuickbooksCustomer.BillAddr billaddr = new QuickbooksCustomer.BillAddr();
            billaddr.CountrySubDivisionCode = 'CA';
            billaddr.City = 'Mountain View';
            billaddr.PostalCode = '94042';
            billaddr.Line1 = '123 Main Street';
            billaddr.Country = 'USA';

			customer.BillAddr = billaddr;
		*/
        
        String reqBody = JSON.serialize(customer);
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(finalEndpoint, accessToken, 'POST', reqBody);
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 201 || response.getStatusCode() == 200 ){
                String body = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+body);
                if(!isValid){
                    String fullName = 'qb_Metadata.'+System.Label.QuickbookSandbox;
                    CreateUpdateMetadataUtils.createUpdateMetadata(fullName,System.Label.QuickbookSandbox,refreshTokenMap);
                }
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
        } 
    }
    
    public static void createPaynent(Decimal amount, String customer){
        
        qb_Metadata__mdt qb_Cred = quickbooksCred();
        
        if(qb_Cred != null && String.isBlank(qb_Cred.access_token__c)){
            return;
        }
        
        String accessToken = qb_Cred.access_token__c;
        
        Boolean isValid = checkTokenValidity(qb_Cred);
        Map<String, Object> refreshTokenMap = new Map<String, Object>();
        
        if(!isValid){
            refreshTokenMap = refreshToken(qb_Cred);
            accessToken     = (String)refreshTokenMap.get('access_token__c');
        }
        String endPoint = qb_Cred.Environment__c == 'Sandbox'?qb_Cred.Sanbdox_Base_URL__c : qb_Cred.Prod_Base_URL__c;
        
        String customerURL = qb_Cred.Create_Payment__c;
        customerURL = customerURL.replace('{realmId}', qb_Cred.realmId__c);
        
        String finalEndpoint = endPoint + customerURL + qb_Cred.minorversion__c;
        
        String errorMessage = '';
        
        String requestBody = '{'+
		'  "TotalAmt": '+amount+', '+
		'  "CustomerRef": {'+
		'    "value": "'+customer+'"'+
		'  }'+
		'}';
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(finalEndpoint, accessToken, 'POST', requestBody);
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 201 || response.getStatusCode() == 200 ){
                String body = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+body);
                if(!isValid){
                    String fullName = 'qb_Metadata.'+System.Label.QuickbookSandbox;
                    CreateUpdateMetadataUtils.createUpdateMetadata(fullName,System.Label.QuickbookSandbox,refreshTokenMap);
                }
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
        }
    }
    
    public static void createInvoice(){
        qb_Metadata__mdt qb_Cred = quickbooksCred();
        
        if(qb_Cred != null && String.isBlank(qb_Cred.access_token__c)){
            return;
        }
        
        String accessToken = qb_Cred.access_token__c;
        
        Boolean isValid = checkTokenValidity(qb_Cred);
        Map<String, Object> refreshTokenMap = new Map<String, Object>();
        
        if(!isValid){
            refreshTokenMap = refreshToken(qb_Cred);
            accessToken     = (String)refreshTokenMap.get('access_token__c');
        }
        String endPoint = qb_Cred.Environment__c == 'Sandbox'?qb_Cred.Sanbdox_Base_URL__c : qb_Cred.Prod_Base_URL__c;
        
        String customerURL = qb_Cred.Create_Invoice__c;
        customerURL = customerURL.replace('{realmId}', qb_Cred.realmId__c);
        
        String finalEndpoint = endPoint + customerURL + qb_Cred.minorversion__c;
        
        String errorMessage = '';
        
        String json=		'{'+
		'  "Line": ['+
		'    {'+
		'      "DetailType": "SalesItemLineDetail", '+
		'      "Amount": 100.0, '+
		'      "SalesItemLineDetail": {'+
		'        "ItemRef": {'+
		'          "name": "Services", '+
		'          "value": "1"'+
		'        }'+
		'      }'+
		'    },'+
		'    {'+
		'      "DetailType": "SalesItemLineDetail", '+
		'      "Amount": 100.0, '+
		'      "SalesItemLineDetail": {'+
		'        "ItemRef": {'+
		'          "name": "Services", '+
		'          "value": "1"'+
		'        }'+
		'      }'+
		'    },'+
		'    {'+
		'      "DetailType": "SalesItemLineDetail", '+
		'      "Amount": 100.0, '+
		'      "SalesItemLineDetail": {'+
		'        "ItemRef": {'+
		'          "name": "Services", '+
		'          "value": "1"'+
		'        }'+
		'      }'+
		'    }'+
		'  ], '+
		'  "CustomerRef": {'+
		'    "value": "65"'+
		'  }'+
		'}';
        
        String requestBody = '{'+
                    '  "Line": ['+
                    '    {'+
                    '      "DetailType": "SalesItemLineDetail", '+
                    '      "Amount": 1080.0, '+
                    '      "SalesItemLineDetail": {'+
                    '        "ItemRef": {'+
                    '          "name": "Services", '+
                    '          "value": "1"'+
                    '        }'+
                    '      }'+
                    '    }'+
                    '  ], '+
                    '  "CustomerRef": {'+
                    '    "value": "65"'+
                    '  }'+
                    '}';
        
        Http http = new Http();
        HttpRequest httpReq   = prepareRequest(finalEndpoint, accessToken, 'POST', json);
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 201 || response.getStatusCode() == 200 ){
                String body = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+body);
                if(!isValid){
                    String fullName = 'qb_Metadata.'+System.Label.QuickbookSandbox;
                    CreateUpdateMetadataUtils.createUpdateMetadata(fullName,System.Label.QuickbookSandbox,refreshTokenMap);
                }
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
        }
    }
    
    public static HttpRequest prepareRequest(String endPoint, String accessToken, String method, String requestBody){
        
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod(method);
        httpReq.setEndpoint(endPoint);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        httpReq.setHeader('Authorization', 'Bearer '+accessToken);
        if(!String.isBlank(requestBody)){
            httpReq.setBody(requestBody);
        }
        return httpReq;
        
    }
}