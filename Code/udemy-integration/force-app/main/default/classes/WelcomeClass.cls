/*
     ******** Test User Credentials *********
     Username - udemy@integration.org
     Password - donotchangeme@1
     REST Service URL - https://ap17.salesforce.com/services/apexrest/v1/Welcome/HSJS
*/
@RestResource(urlMapping='/v1/Welcome/*')
global with sharing class WelcomeClass {

    global Final static String WELCOME_MESSAGE = 'Welcome To SFDCPanther Integration Tutorials';
    
    @httpGet
    global static String greetingMessage(){
    
        return WELCOME_MESSAGE;
    }
    
    @httpPost
    global static String postGreetingMessage(){
        
        return WELCOME_MESSAGE;
    }
    
    @httpPatch
    global static String patchGreetingMessage(){
        
        return WELCOME_MESSAGE+' UPDATE WITH PATHC';
    }
    
    
}