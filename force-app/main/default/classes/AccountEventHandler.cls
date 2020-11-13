public with sharing class AccountEventHandler {

    public static Account_Change__e createEvent(List<ChangedAccountInfo> changedFields){
        String message = createMessage(changedFields);
        Account_Change__e accountEvent = new Account_Change__e(
            Message__c = message
        );
        return accountEvent;
    }

    public static String createMessage(List<ChangedAccountInfo> changedFields){
        String message = 'Changed Fields: \n';

        for(ChangedAccountInfo field: changedFields){
            message = message + field.fieldName + ' ' + field.oldValue + ' -> ' + field.newValue + '\n';
        }

        return message;
    }

    public static void publishEvent(List<ChangedAccountInfo> changedFields){
        Account_Change__e accountEvent = createEvent(changedFields);
        Database.SaveResult eventResult = EventBus.publish(accountEvent);

        if(eventResult.isSuccess()){
            System.debug('Successfully published event.' + accountEvent.Message__c);
        } 
        else {
            for(Database.Error error : eventResult.getErrors()) {
                System.debug('Error returned: ' +
                             error.getStatusCode() +
                             ' - ' +
                             error.getMessage());
            }
        }
    }
}
