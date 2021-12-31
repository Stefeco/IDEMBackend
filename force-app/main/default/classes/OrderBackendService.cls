public with sharing class OrderBackendService {

    public static void checkOrdersWithProducts(List<Order> newOrders, List<Order> oldOrders) {

        for(Integer i = 0; i<newOrders.size(); i++){
            System.debug('OrderBackendService.checkOrdersWithProduct : Order to check from NewOrders = ' + newOrders[i]);

            if((newOrders[i].status == 'Active') && (oldOrders[i].status != 'Active')){
                if(OrderBackendService.allItemsExist(newOrders[i].Id) == false){
                    System.debug('allItemsExist newOrders(false?) = ' + newOrders[i].Id);
                    newOrders[i].addError('pas de produit sélectionné pour cet ordre');
                    system.debug('allItemsExist newOrders.addError = ' + newOrders[i].getErrors());
                }
            } // end of if
        } // end of for


    } // end of method

    public static boolean allItemsExist(String orderId){
        List<OrderItem> orderList = [SELECT Id from OrderItem WHERE OrderId = :orderId];
        System.debug('allItemsExist orderList = ' + orderList);
        if(orderList.size() != 0){
            return true;
        } else { return false;}
    } // end of method


    public static void checkOrderOnAccounts(List<Order> ord) {
        System.debug('methode checkOrderOnAccounts started');

        Account acc = [SELECT Id from Account where Id = :ord[0].AccountId];
        System.debug('SELECT Id from Account where Id = ord[0].AccountId = ' + acc);

        List<Order> orders = [SELECT Id from Order WHERE AccountId = :acc.Id];
        system.debug('SELECT Id from Order WHERE AccountId = acc.Id = ' + orders);

        if(orders.size() == null || orders.size() == 0){
            acc.Active__c = false;
        } else {
            acc.Active__c = true;
        }
        System.debug('acc.Active__c = ' + acc.Active__c);

        update acc;
    } //end of method

    public static List<Task> sendNewTaskOnAccount(List<Account>scope){

        List<Task> taskList = new List<Task>();

        if(scope.size()>0){
            for(Account acc : scope){
                Task tskRecord = new Task();
                tskRecord.WhatId = acc.Id;
                tskRecord.Subject = 'Call - prendre contact car plus d\'ordre ni de tâche';
                tskRecord.Status = 'Nouvelle';
                tskRecord.Priority = 'Normale';
                tskRecord.IsReminderSet = true;
                tskRecord.ReminderDateTime = Date.today()+5;
                taskList.add(tskRecord);
            } // end of for
        } // end of if
        if(taskList.size()>0){
            insert taskList;
        }
        System.debug('Insert TaskList after executeBatch = ' + taskList);

    return taskList;

    } // end of method

} // end of class
