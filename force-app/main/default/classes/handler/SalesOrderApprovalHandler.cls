public with sharing class SalesOrderApprovalHandler{
    
    private List<Sales_Order__c> newList;
    private List<Sales_Order__c> oldList;
    private Map<Id, Sales_Order__c> newMap;
    private Map<Id, Sales_Order__c> oldMap;

    public SalesOrderApprovalHandler(
        List<Sales_Order__c> newList, List<Sales_Order__c> oldList,
        Map<Id, Sales_Order__c> newMap, Map<Id, Sales_Order__c> oldMap){

           this.newList = newList;
           this.oldList = oldList;
           this.newMap = newMap;
           this.oldMap = oldMap; 
    }

    public void run(){
        if(Trigger.isBefore){
            if(Trigger.isInsert){ onBeforeInsert(); }
            if(Trigger.isUpdate){ onBeforeUpdate(); }
        }
        if(Trigger.isAfter){
            if(Trigger.isInsert){ onAfterInsert(); }
        }
    }

    private void onBeforeInsert(){

        for (Sales_Order__c order : this.newList){
            if (order.TotalAmount__c < 100) {
                order.addError('Valor de pedido minímo não atingido.');
            }
        }
    }

    private void onBeforeUpdate(){

        for (Sales_Order__c order : this.newList){
            String oldOrderStatus = this.oldMap.get(order.Id).Status__c;
            String newOrderStatus = order.Status__c;

            if ((oldOrderStatus == 'Approved' || oldOrderStatus == 'Rejected') && newOrderStatus != oldOrderStatus) {
                order.addError('Pedidos finalizados não podem ser reenfileirados.');
            }
        }
    }
        
    private void onAfterInsert(){
        Set<Id> idToProcess = new Set<Id>();

        for(Sales_Order__c order : this.newList){
            if(order.Status__c == 'Pending'){
                idToProcess.add(order.Id);
            }
        }
        if(!idToProcess.isEmpty()){
            System.debug('Enfileirando pedidos para processamento...');
            SalesOrderQueueable soq = new SalesOrderQueueable(idToProcess);
            System.enqueueJob(soq);
        }
    }   
}
