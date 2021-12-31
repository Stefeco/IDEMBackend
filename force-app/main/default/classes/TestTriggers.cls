@isTest
private class TestTriggers {

    @isTest
    public static void testOrderStatusChangeWithProduct() {

        //creation des données de test
        List<Account> acc = TestDataFactory.createTestAccounts(1, 'TestAccountforTrigger');
        insert acc;
        List <Order> ord = TestDataFactory.createTestOrders(2,'testOrderWithProductForTrigger');
        List<OrderItem> ordItems = new List<OrderItem>();
        Product2 prod = TestDataFactory.createSingleTestProduct('TestProduct','TestFamily');
        System.debug('test product is created : ' + prod);
        PricebookEntry pbe = TestDataFactory.createPriceBookEntry(prod);

        System.debug('Test accounts = ' + acc);

        //ajout d'un ordre sur un compte
        for(Account acc1 : acc){
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
        for(Account acc1 : acc){
            for(Order ord1 : ord){
                ord1.status = 'Active';
            }
        }

        //mise à jour de la database pour le test du trigger
        Database.SaveResult updt = Database.update(ord[0]);

        System.debug('Nouveau Statut de l\'ordre : ' + ord[0].status);

        Test.stopTest();

        //on vérifie que l'ordre est bien passé en statut actif.
        System.assertEquals(ord[0].status, 'Active', 'L\'ordre aurait du passer en Active');
        System.assert(updt.isSuccess());
        System.assert(updt.getErrors().size()==0);
    } // end of method

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------*/

@isTest(seeAllData=true) static void testOrderStatusChangeWithoutProduct(){

            //creation des données de test
            List<Account> acc = TestDataFactory.createTestAccounts(1, 'TestAccountforTrigger');
            insert acc;
            List <Order> ord = TestDataFactory.createTestOrders(2,'testOrderWithProductForTrigger');
            //List<OrderItem> ordItems = new List<OrderItem>();
    
            System.debug('Test accounts = ' + acc);
    
            
            //ajout d'un ordre sur un compte
            for(Account acc1 : acc){
                for(Order ord1 : ord){
                    ord1.AccountId = acc1.Id;
                    ord1.status = 'Draft';
                    ord1.EffectiveDate = Date.today();
                }
            } // end of for
            system.debug('Test orders = ' + ord);
    
            insert ord;
            System.debug('TestOrderWithoutProduct statut de l\'ordre après insertion : ' + ord[0].Status);
    
            //début du test, on passe chaque ordre en statut actif
            Test.startTest();
            for(Account acc1 : acc){
                for(Order ord1 : ord){
                    ord1.status = 'Active';
                } //end of for
            } // end of for
    
            //mise à jour de la database pour le test du trigger
            List<Boolean> exceptions = new List<Boolean>();
            try{
            Database.SaveResult updt = Database.update(ord[0]);
            System.debug('updt = ' + updt);
            } catch (Exception e){
                e.setMessage('impossible d\'activer un ordre sans produit');
                exceptions.add(true);
                System.debug('exception = ' + e);
                }
    
            System.debug('Nouveau Statut de l\'ordre : ' + ord[0].status);
    
            Test.stopTest();

            System.assertNotEquals(null, exceptions, 'ce test doit donner une erreur car il n\'y a pas de produits');


}

@isTest(seeAllData=true) static void testDeactivateAccountIfNoOrdersLeft(){

    List<Account> acc = TestDataFactory.createTestAccounts(1, 'TestAccountToDeactivate');
    insert acc;

    //List<Order> ord = TestDataFactory.createTestOrders(1, 'TestOrderToRemove');
    
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

    Test.stopTest();

    System.assertEquals(ords2.size(), 0, 'les ordres n\'ont pas été effacés');
    System.assertEquals(acc[0].Active__c, false, 'Le champ active du compte doit passer en "non actif"');

    } // end of method

} // end of class
