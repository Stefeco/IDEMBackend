@isTest
public with sharing class TestDataFactory {

    public static List<Account> createTestAccounts(Integer acctsNumber, String name){

        List<Account> accts = new List<Account>();

        for(Integer i=0; i<acctsNumber;i++){
            Account acc1 = new Account(name = name + ' ' + i);
            accts.add(acc1);
        }
        System.debug('List of accounts created in factory : ' + accts);
        return accts;
    }
    
    public static List<Order> createTestOrders(Integer orderNum, String name) {

        List<Order> ords = new List<Order>();
        for( Integer i = 0; i< orderNum; i++){
            Order ord1 = new Order(name = name + ' ' +  i);
            ords.add(ord1);
        }
        System.debug('List of orders created in factory : ' + ords);
        return ords;
    }

    public static Order createSingleTestOrder(String name){
        Order ord1 = new Order(name = name);
        ord1.Status = 'draft';
        return ord1;
    }

    public static Product2 createSingleTestProduct(String prdName, String family){
        Product2 prd1 = new Product2(name = prdName, family = family);
        insert prd1;
        return prd1;
    }

    public static PricebookEntry createPriceBookEntry(Product2 prd){
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = prd.id,
            UnitPrice = 200,
            IsActive = true
        );
        insert pbe;
        return pbe;
    }
}
