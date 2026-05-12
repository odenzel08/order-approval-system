public with sharing class ErrorLogService {

    public static void log(Sales_Order__c order, String errorMessage, String errorType, DateTime ocurred){

        ErrorLog__c error = new ErrorLog__c(
            Sales_Order__c = order.Id,
            ErrorMessage__c = errorMessage,
            ErrorType__c = errorType,
            OcurredAt__c = ocurred
        );
        insert error;
    }
}