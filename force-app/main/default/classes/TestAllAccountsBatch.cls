@isTest
public with sharing class TestAllAccountsBatch {
    
    @isTest(seeAllData=true) static void testUpdateAllAccountsWithoutBatch(){

        List<Account> acc = TestDataFactory.createTestAccounts(1, 'TestAccountToDeactivate');
        insert acc;

        Order ord1 = new Order();
        ord1.AccountId = acc[0].Id;
        ord1.status = 'Draft';
        ord1.EffectiveDate = Date.today();
        //ord1.Pricebook2Id= pbe.Pricebook2Id;
        ord1.ShipmentCost__c = 200;
        ord1.NetAmount__c = 10.0;
    
        Order ord2 = new Order();
        ord2.AccountId = acc[0].Id;
        ord2.status = 'Draft';
        ord2.EffectiveDate = Date.today();
        //ord1.Pricebook2Id= pbe.Pricebook2Id;
        ord2.ShipmentCost__c = 200;
        ord2.NetAmount__c = 10.0;
    
        system.debug('Test orders = ' + ord1 + ' ' + ord2);
    
        insert ord1;
        insert ord2;

        Test.startTest();

        List<Order> ords = [SELECT id from Order WHERE Account.Name = 'TestAccountToDeactivate 0'];
        System.debug('liste des ordres : ' + ords);
    
        delete ords;
        List<Order> ords2 = [SELECT id from Order WHERE Account.Name = 'TestAccountToDeactivate 0'];
        System.debug('liste des ordres après delete : ' + ords2);
    
        System.debug('number of orders after deletion : ' + ords2.size());

        UpdateAllAccountsWithoutTask_Batch upa = new UpdateAllAccountsWithoutTask_Batch();
        Id batchId = Database.executeBatch(upa);
    
        Test.stopTest();

        //System.assertEquals(expected, actual, msg);





    }
}
