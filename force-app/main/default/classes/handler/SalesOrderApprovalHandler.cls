public with sharing class OrderApprovalHandler {
    
    private List<Sales_Order__c> newList = Trigger.new;
    private List<Sales_Order__c> oldList = Trigger.old;
    private Map<Id, Sales_Order__c> newMap = (Map<Id, Sales_Order__c>) Trigger.newMap;
    private Map<Id, Sales_Order__c> oldMap = (Map<Id, Sales_Order__c>) Trigger.oldMap;

    public void run(){
        if(Trigger.isBefore){
            if(Trigger.isInsert){ onBeforeInsert(); }
            if(Trigger.isBefore){ onBeforeUpdate(); }
        }
        if(Trigger.isAfter){
            if(Trigger.isInsert){ onAfterInsert(); }
        }
    }

    private void onBeforeInsert(){

        for (Sales_Order__c order : newList){
            if (order.TotalAmount__c < 100) {
                order.addError('Valor de pedido minímo não atingido.');
                ErrorLogService.log(
                    order.Name,
                    'Não é possível criar o pedido, pois o valor mínimo de R$100,00 não foi atingido.',
                    'Validation',
                    System.now()
                );
            }
        }

        private void onBeforeUpdate(){
            for (Sales_Order__c order : newList){
                String statusAntigo = oldMap.get(order.Id).Status__c;
                String statusNovo = order.Status__c;

                if (statusNovo == 'Pending' || statusNovo == 'Aprovved' && (statusAntigo == 'Approved' || statusAntigo == 'Rejected')){
                    order.addError('Pedidos finalizados não podem ser reenfileirados.')
                }
            }
        }
        private void onAfterInsert(){
            Set<Id> idToProcess = new Set<Id>();

            for(Sales_Order__c order : newList){
                if(order.Status__c == 'Pending'){
                    idToProcess.add(order.Id);
                }
            }
            if(!idToProcess == null){
                System.enqueueJob(new SalesOrderQueueable(idToProcess));
            }
        }
    }
}