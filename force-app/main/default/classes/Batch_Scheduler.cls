global class Batch_Scheduler implements Schedulable {

    global void execute (SchedulableContext SC) {

    UpdateAllAccountsWithoutTask_Batch reminder = new UpdateAllAccountsWithoutTask_Batch();
    // pour CRON table : // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
    /*String sch = '00 00 02 ? * 2#1';
    String jobId = System.schedule('rappel tâches', sch, reminder);*/

    Database.executeBatch(reminder);

    }
}
