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
    }

    private void onBeforeInsert(){

        for (Sales_Order__c order : newList){
            if (order.TotalAmount__c < 100) {
                order.addError('Valor de pedido minímo não atingido.');
                ErrorLogService.log(
                    order.OrderNumber__c,
                    'Não é possível criar o pedido, pois o valor mínimo de R$100,00 não foi atingido.',
                    'Validation',
                    System.now()
                );
            } else {
                // Chama a Queueable
            }
        }

        private void onBeforeUpdate(){
            for (Sales_Order__c order : newList){
                String statusAntigo = oldMap.get(order.Id).Status__c;
                String statusNovo = order.Status__c;

                if (statusNovo == 'Pending' && (statusAntigo == 'Approved' || statusAntigo == 'Rejected')){
                    order.addError('Pedidos finalizados não podem ser reenfileirados.')
                }
            }
        }

    }

}