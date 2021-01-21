public class PipeDriveUserBatchScheduler implements System.Schedulable {

    public static void execute(System.SchedulableContext SC){
        Database.executeBatch(new PipeDriveUserBatch());
    }
}