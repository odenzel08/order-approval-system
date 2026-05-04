public with sharing class SalesOrderQueueable implements Queueable{

    private Set<Id> orderIds;

    public SalesOrderQueueable(Set<Id> orderIds){
        this.orderIds = orderIds;
    }

    public void execute(QueueableContext context){

        User admin = [SELECT Id FROM User WHERE Profile.Name == 'System Administrator'];
        List<Sales_Order__c> orders = [
            SELECT Id, TotalAmount__c, Status__c 
            FROM Sales_Order__c
            WHERE Id IN :orderIds   
        ];
        List<Sales_Order__c> orderForUpdate = new List<Sales_Order__c>();

        for (Sales_Order__c order : orders){
            try {
                if(order.TotalAmount__c < 10000){
                    order.Status__c = 'Approved';
                    order.ProcessedAt__c = System.now();
                    orderForUpdate.add(order);
                }
            } catch (Exception e) {
                order.Status__c = 'Rejected';
                orderForUpdate.add(order);
                ErrorLogService.log(order.OrderNumber__c, e.getMessage(), '')
            }
        }
        
        
    }
    

}