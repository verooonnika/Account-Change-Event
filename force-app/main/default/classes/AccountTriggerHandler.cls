public with sharing class AccountTriggerHandler {

    public static void createEvent(Map<Id, Account> oldAccounts, List<Account> newAccounts){
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Account.fields.getMap(); 
        

        for(Account newAccount: newAccounts){
            List<ChangedAccountInfo> changedFields = new List<ChangedAccountInfo>();

            Account oldAccount = oldAccounts.get(newAccount.Id);

            for (String field: mapFields.keyset()){
                if(newAccount.get(field) != oldAccount.get(field)){
                    ChangedAccountInfo changedField = new ChangedAccountInfo(field, oldAccount.get(field), newAccount.get(field));
                    changedFields.add(changedField);
                }
            } 

            AccountEventHandler.publishEvent(changedFields);
        }
        
    }


}
