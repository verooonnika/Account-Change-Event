public with sharing class ChangedAccountInfo {
    
    public String fieldName;
    public Object oldValue;
    public Object newValue;

    public ChangedAccountInfo(String fieldName, Object oldValue, Object newValue ){
        this.fieldName = fieldName;
        this.oldValue = oldValue;
        this.newValue = newValue;
    }
}