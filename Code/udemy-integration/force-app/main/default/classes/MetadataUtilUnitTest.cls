@IsTest
public class MetadataUtilUnitTest {
	
    @IsTest
    public static void createMethodTest(){
        Test.setMock(WebServiceMock.class, new MetadataUtilMock());
        Test.startTest();
        MetadataUtil.createObject('Mock Object','Mock Objects','Mock Objects');
        Test.stopTest();
    }
    
    @IsTest
    public static void raadMetadataMethodTest(){
        Test.setMock(WebServiceMock.class, new MetadataUtilMock());
        Test.startTest();
        MetadataUtil.readMetadata();
        Test.stopTest();
    }
    @IsTest
    public static void listMetadataMethodTest(){
        Test.setMock(WebServiceMock.class, new MetadataUtilMock());
        Test.startTest();
        MetadataUtil.listMetadata('Profile');
        Test.stopTest();
    }
}