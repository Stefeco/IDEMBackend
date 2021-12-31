@isTest
public with sharing class TestOrderBackEndService {
    
    //cette méthode vérifie que l'on peut passer un ordre en actif avec succès si un ou plusieurs produit/orderItems sont toujours dans l'ordre.
    @isTest(seeAllData=true) static void anOrderWithProductIsActivated () {

        //création des entrées pour le test
        List<Account> accts = TestDataFactory.createTestAccounts(1,'TestAccount');
        List <Order> ord = TestDataFactory.createTestOrders(2,'testOrderWithProductActivated');
        List<OrderItem> ordItems = new List<OrderItem>();
        Product2 prod = TestDataFactory.createSingleTestProduct('TestProduct','TestFamily');
        System.debug('test product is created : ' + prod);
        PricebookEntry pbe = TestDataFactory.createPriceBookEntry(prod);

        insert accts;
        System.debug('Test accounts = ' + accts);

        //ajout d'un ordre sur un compte
        for(Account acc1 : accts){
            for(Order ord1 : ord){
                ord1.AccountId = acc1.Id;
                ord1.status = 'Draft';
                ord1.EffectiveDate = Date.today();
                ord1.Pricebook2Id= pbe.Pricebook2Id;
                ord1.ShipmentCost__c = 200;
                ord1.NetAmount__c = 10.0;
            }
        }
        system.debug('Test orders = ' + ord);

        insert ord;

        //ajout d'un orderItem(produit) sur chaque ordre
        for(Order ord1 : ord){
            OrderItem oi1 = new OrderItem (OrderId = ord1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
            ordItems.add(oi1);
        }

        insert ordItems;

        //début du test, on passe chaque ordre en statut actif
        Test.startTest();
        for(Account acc1 : accts){
            for(Order ord1 : ord){
                ord1.status = 'Active';
            }
        }

        //mise à jour de la database pour le test du trigger
        Database.update(ord);

        System.debug('Nouveau Statut de l\'ordre : ' + ord[0].status);

        Test.stopTest();

        //on vérifie que l'ordre est bien passé en statut actif.
        System.assertEquals(ord[0].status, 'Active', 'L\'ordre aurait du passer en Active');

    }

} // end of class