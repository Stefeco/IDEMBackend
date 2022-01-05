global class UpdateAllAccountsWithoutTask_Batch implements Database.Batchable<SObject> {

    global Database.QueryLocator start (Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Account.Id, (SELECT AccountId FROM Account.Orders WHERE Id = null ), (SELECT AccountId FROM Account.tasks WHERE ID = null) FROM Account a'); 
    }

    global void execute(Database.BatchableContext BC, List<Account> scope){
        OrderBackendService.sendNewTaskOnAccount(scope);
    }

    global void finish(Database.BatchableContext BC){

    }
    
}











