trigger SalesOrderTrigger on Sales_Order__c (
    before insert, before update, after update) {
        SalesOrderApprovalHandler handler = new SalesOrderApprovalHandler();
        handler.run();
} 