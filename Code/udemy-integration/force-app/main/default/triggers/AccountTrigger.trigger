trigger AccountTrigger on Account (after insert, after update) {
	/*
    if(Trigger.isAfter && Trigger.isInsert){
        Account acc = Trigger.new.get(0);
        if(acc.Location__latitude__s != null && acc.Location__longitude__s != null){
            OpenCageGeocoderUtil.reverseGeoCoding(acc.Id);
        }else{
            OpenCageGeocoderUtil.forwordGeoCoding(acc.Id);
        }
        
    }else if (Trigger.isAfter && Trigger.isUpdate) {
        // Trigger.OldMap
    }*/
}