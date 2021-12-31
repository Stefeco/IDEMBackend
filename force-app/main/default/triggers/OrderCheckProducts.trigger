trigger OrderCheckProducts on Order (before update, after delete) {

    if(trigger.isUpdate){
        OrderBackendService.checkOrdersWithProducts(trigger.new, trigger.old);
        System.debug('Trigger checkOrderWithProducts add started');
    } else if (trigger.isDelete){

        System.debug('Trigger OrderCheckProducts isDelete started');

        OrderBackendService.checkOrderOnAccounts(Trigger.old);

    }

}