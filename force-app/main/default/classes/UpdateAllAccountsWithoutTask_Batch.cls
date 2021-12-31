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








/*global class UpdateAllAccountsWithoutTask_Batch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext BC){
        //requête qui permet de trouver les comptes n'ayant pas de taches attribuées
        return Database.getQueryLocator('SELECT Id FROM Account WHERE (SELECT AccountId FROM Order WHERE Id == null) && (SELECT taskId FROM Task WHERE Id == null)');
    }

    global void execute(Database.BatchableContext BC, List<Account> scope){
        //appel de la méthode de la classe de service a exécuter pour le batch
        OrderBackendService.sendNewTaskOnAccount(scope);
    }

    Global void finish(Database.BatchableContext BC){

    }

} // end of first batch
*/


