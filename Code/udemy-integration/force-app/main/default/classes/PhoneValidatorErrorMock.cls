@IsTest
global class PhoneValidatorErrorMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req){
        
        
        System.debug(req.getBody());
        System.debug(req.getEndpoint());
        System.debug(req.getMethod());
        
        String json=		'{'+
            '  "valid": false,'+
            '  "number": "14158586273",'+
            '  "local_format": "4158586273",'+
            '  "international_format": "+14158586273",'+
            '  "country_prefix": "+1",'+
            '  "country_code": "US",'+
            '  "country_name": "United States of America",'+
            '  "location": "Novato",'+
            '  "carrier": "AT&T Mobility LLC",'+
            '  "line_type": "mobile"'+
            '}    ';
        
        HttpResponse response = new HttpResponse();
        response.setStatusCode(300);
        response.setBody(json);
        return response;
    }
}