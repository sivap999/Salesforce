@IsTest
public class MarkDirtyIfFailTest {
    @isTest
    public static void testBatchApexErrorEvent() {
        insert new Account(Name = 'Test Account');
        try{
            Test.startTest();
                Database.executeBatch(new PlatformEventBatchDemo(), 10);
            	Test.getEventBus().deliver();
            Test.stopTest();
        } catch(System.MathException e){
            
        }
        Test.getEventBus().deliver(); 
    }
}