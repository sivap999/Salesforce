@IsTest
public class PhoneValidatorUnitTest {

    @isTest
    public static void unitTest(){
        Account acc = New Account(
        	Name = 'Account Testing',
            Phone = '9807654321'
        );
        insert acc;
        String json=		'{'+
		'  "valid": true,'+
		'  "number": "14158586273",'+
		'  "local_format": "4158586273",'+
		'  "international_format": "+14158586273",'+
		'  "country_prefix": "+1",'+
		'  "country_code": "US",'+
		'  "country_name": "United States of America",'+
		'  "location": "Novato",'+
		'  "carrier": "AT&T Mobility LLC",'+
		'  "line_type": "mobile"'+
		'}    ';
        SingleRequstMock mock = new SingleRequstMock(200, 'OK', json, null);
        Test.setMock(HttpCalloutMock.class, mock);
        //Test.setMock(HttpCalloutMock.class, new PhoneValidatorErrorMock());
        Test.startTest();
        	PhoneValidator.validatePhone(acc.Id);
        Test.stopTest();
    }
    /*
    @isTest
    public static void unitTestError(){
        Account acc = New Account(
        	Name = 'Account Testing',
            Phone = '9807654321'
        );
        insert acc;
        Test.setMock(HttpCalloutMock.class, new PhoneValidatorErrorMock());
        Test.startTest();
        	PhoneValidator.validatePhone(acc.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void unitTestExpection(){
        Account acc = New Account(
        	Name = 'Account Testing',
            Phone = '9807654321'
        );
        insert acc;
        //Test.setMock(HttpCalloutMock.class, new PhoneValidatorErrorMock());
        Test.startTest();
        	PhoneValidator.validatePhone(acc.Id);
        Test.stopTest();
    }*/
}