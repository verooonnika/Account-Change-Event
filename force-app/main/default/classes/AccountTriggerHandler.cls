public with sharing class AccountTriggerHandler {
    
    public static void createEvent(Map<Id, Account> oldAccounts, List<Account> newAccounts){
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Account.fields.getMap(); 
        List<Account_Change__e> accountEvents = new List<Account_Change__e>();       
        
        for(Account newAccount: newAccounts){
            List<ChangedAccountInfo> changedFields = new List<ChangedAccountInfo>();
            
            Account oldAccount = oldAccounts.get(newAccount.Id);
            
            for (String field: mapFields.keyset()){
                if(newAccount.get(field) != oldAccount.get(field)){
                    ChangedAccountInfo changedField = new ChangedAccountInfo(field, oldAccount.get(field), newAccount.get(field));
                    changedFields.add(changedField);
                }
            } 

            Account_Change__e accountEvent = AccountEventHandler.createEvent(changedFields);
            accountEvents.add(accountEvent);
        }
        
        AccountEventHandler.publishEvents(accountEvents);
    }
    
}