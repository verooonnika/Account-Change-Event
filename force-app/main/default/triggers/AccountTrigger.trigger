trigger AccountTrigger on Account (after update) {

    AccountTriggerHandler.createEvent(Trigger.oldMap, Trigger.new);

}