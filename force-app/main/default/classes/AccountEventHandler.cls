public with sharing class AccountEventHandler {
    
    public static Account_Change__e createEvent(List<ChangedAccountInfo> changedFields){
        List<Account_Change__e> accountEvents = new List<Account_Change__e>();
        String message = createMessage(changedFields);
        Account_Change__e accountEvent = new Account_Change__e(
            Message__c = message
        );
        accountEvents.add(accountEvent);
        return accountEvent;
    }
    
    public static String createMessage(List<ChangedAccountInfo> changedFields){
        String message = 'Changed Fields: \n';
        
        for(ChangedAccountInfo field: changedFields){
            message = message + field.fieldName + ' ' + field.oldValue + ' -> ' + field.newValue + '\n';
        }
        
        return message;
    }
    
    public static void publishEvents(List<Account_Change__e> changedAccounts){
        Database.SaveResult[] eventResults = EventBus.publish(changedAccounts);
        
        for (Database.SaveResult eventResult : eventResults) {
            if(eventResult.isSuccess()){
                System.debug('Successfully published event: ' + eventResult.getId());
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
}