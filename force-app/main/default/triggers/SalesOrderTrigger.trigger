trigger SalesOrderTrigger on Sales_Order__c (
    before insert, before update) {
        SalesOrderApprovalHandler handler = new SalesOrderApprovalHandler();
        handler.run();
}