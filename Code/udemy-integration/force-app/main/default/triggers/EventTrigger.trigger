trigger EventTrigger on Event (after insert) {
    if(!System.isBatch() && !System.isFuture()){
        EventTriggerHandler.createEventInGoogle(Trigger.new.get(0).Id);
    }
}