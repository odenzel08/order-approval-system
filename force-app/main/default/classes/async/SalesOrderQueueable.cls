public with sharing class SalesOrderQueueable implements Queueable {

    private Set<Id> orderIds;

    public SalesOrderQueueable(Set<Id> orderIds) {
        this.orderIds = orderIds;
    }

    public void execute(QueueableContext context) {

        List<Sales_Order__c> orders = [
            SELECT Id, Name, TotalAmount__c, Status__c, CreatedBy.ManagerId
            FROM Sales_Order__c
            WHERE Id IN :orderIds
        ];

        List<Sales_Order__c> orderForUpdate = new List<Sales_Order__c>();
        List<Task> taskForUpdate = new List<Task>();

        for (Sales_Order__c order : orders) {
            if (order.TotalAmount__c < 10000) {
                order.Status__c = 'Approved';
                order.ProcessedAt__c = System.now();
                orderForUpdate.add(order);

            } else if (order.CreatedBy.ManagerId != null) {
                Task approval = new Task(
                    Subject = 'Aprovar pedido ' + order.Name,
                    WhatId = order.Id,
                    OwnerId = order.CreatedBy.ManagerId,
                    ActivityDate = Date.today().addDays(1),
                    Priority = 'High',
                    Status = 'Not Started'
                );
                taskForUpdate.add(approval);
                orderForUpdate.add(order);

            } else {
                order.Status__c = 'Rejected';
                orderForUpdate.add(order);
                ErrorLogService.log(
                    order,
                    'Não foi possível localizar o gestor responsável para aprovação do pedido ' + order.Name,
                    'System',
                    System.now()
                );
            }
        }

        if (!orderForUpdate.isEmpty()) {
            update orderForUpdate;
        }
        if (!taskForUpdate.isEmpty()) {
            insert taskForUpdate;
        }
    }
}