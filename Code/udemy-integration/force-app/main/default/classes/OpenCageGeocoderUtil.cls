global with sharing class OpenCageGeocoderUtil {
    
    @future(callout=true)
    public static void forwordGeoCoding(Id recordId){
        
        String endPoint = System.Label.OpenCageEndpoint ;
        String apeKey   = System.Label.OpenCageKey;
        String errorMessage = '';
        
        Account accRec = [Select Id, Name, Location__latitude__s , Location__longitude__s ,ShippingStreet, ShippingState, ShippingPostalCode,
                          ShippingCountry, ShippingCity From Account Where Id =:recordId];
        
        String address = accRec.ShippingStreet+','+accRec.ShippingCity+','+accRec.ShippingState+','+accRec.ShippingPostalCode+','+
            +accRec.ShippingCountry;
        String encodedString = EncodingUtil.urlEncode(address, 'UTF-8');
        String finalEndPoint = endPoint+'q='+encodedString+'&key='+apeKey+'&pretty=1&limit=1';
        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(finalEndPoint);
        httpReq.setHeader('Content-Type', 'application/json');
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 200 ){
                String body = response.getBody();
                
                OpenCageGeoCoder openCageData = (OpenCageGeoCoder)System.JSON.deserialize(body, OpenCageGeoCoder.class);
                List<OpenCageGeoCoder.results> results = openCageData.results;
                if(results != null && results.size()>0){
                    OpenCageGeoCoder.results result = results.get(0);
                    accRec.Location__latitude__s = result.geometry.lat;
                    accRec.Location__longitude__s = result.geometry.lng;
                    update accRec;
                }
                
            }else{
                errorMessage = 'Unexpected Error while communicating with OpenCage Data API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with OpenCage Data API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
        } 
    }

    @future(callout=true)
    public static void reverseGeoCoding(Id recordId){
        
        String endPoint = System.Label.OpenCageEndpoint ;
        String apeKey   = System.Label.OpenCageKey;
        String errorMessage = '';
        
        Account accRec = [Select Id, Address__c, Location__latitude__s , Location__longitude__s ,ShippingStreet, ShippingState, ShippingPostalCode,
                          ShippingCountry, ShippingCity From Account Where Id =:recordId];
        
        String address = accRec.Location__latitude__s+','+accRec.Location__longitude__s;
        
        String encodedString = EncodingUtil.urlEncode(address, 'UTF-8');
        String finalEndPoint = endPoint+'q='+encodedString+'&key='+apeKey+'&pretty=1&limit=1';
        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(finalEndPoint);
        httpReq.setHeader('Content-Type', 'application/json');
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 200 ){
                String body = response.getBody();
                
                OpenCageGeoCoder openCageData = (OpenCageGeoCoder)System.JSON.deserialize(body, OpenCageGeoCoder.class);
                List<OpenCageGeoCoder.results> results = openCageData.results;
                if(results != null && results.size()>0){
                    OpenCageGeoCoder.results result = results.get(0);
                    accRec.ShippingStreet 	  = result.components.road;
                    accRec.ShippingCity       = result.components.city;
                    accRec.ShippingState 	  = result.components.state;
                    accRec.ShippingPostalCode = result.components.postcode;
                    accRec.ShippingCountry    = result.components.country;
                    accRec.Address__c		  = result.formatted;
                    update accRec;
                }
                
            }else{
                errorMessage = 'Unexpected Error while communicating with OpenCage Data API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with OpenCage Data API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
        } 
    }
}