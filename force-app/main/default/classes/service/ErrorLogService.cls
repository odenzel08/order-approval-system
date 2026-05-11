public with sharing class ErrorLogService {

    public void log (String numberOrder, String errorMessage, String errorType, DateTime ocurred);

    ErrorLog__c error = new ErrorLog__c(
        OrderNumber__c = numberOrder,
        ErrorMessage__c = errorMessage,
        ErrorType__c = errorType
        OcurredAt__c = ocurred
    );
    insert error;
}