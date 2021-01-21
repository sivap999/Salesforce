global class POCChainedCallout implements HttpCalloutMock {
    global FINAL STRING END_POINT = 'https://sampleendpoint.com/v1/users';
    global FINAL STRING END_POINT_2 = 'https://sampleendpoint.com/v1/users/userId/Accounts';
    global FINAL STRING END_POINT_3 = 'https://sampleendpoint.com/v1/users/userId/Accounts/Contacts';
    global String  contentType { get; set; }
    global Integer statusCode  { get; set; }
    
    global POCChainedCallout(){}
    
    global POCChainedCallout(String contentType, Integer statusCode) {
        this.statusCode  = statusCode;
        this.contentType = contentType;
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        
        HTTPResponse httpRes = new HTTPResponse();
        httpRes.setHeader('Content-Type', 'application/json');
        httpRes.setStatus('OK');
        httpRes.setStatusCode(200);
        
        if( END_POINT == req.getEndpoint() ){
            httpRes.setBody( TestCallOutUtility.responseBody );
        } else if( END_POINT_2 == req.getEndpoint() ) {
            httpRes.setBody( TestCallOutUtility.responseBody1 );
        } else if( END_POINT_3 == req.getEndpoint() ) {
            httpRes.setBody( TestCallOutUtility.responseBody2 );
        }
        return httpRes;
    }
}