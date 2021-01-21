public class SalesforceChatterUtil {
    
    public static void createChatterPost(String recordId){
        
        String errorMessage = '';
        String endPoint = '';
        
        String instanceURL = System.Url.getSalesforceBaseUrl().toExternalForm()
            +'/services/data/v50.0/chatter/feed-elements/0D52x00000T3pCfCAJ/capabilities/comments/items';
        
        String json=		'{'+
		'  "body": {'+
		'    "messageSegments": ['+
		'      {'+
		'        "type": "Text",'+
		'        "text": " When should we meet for release planning? "'+
		'      },'+
		'      {'+
		'        "type": "Text",'+
		'        "text": " This sprint has a very tight deadlines. "'+
		'      },'+
		'      {'+
		'        "type": "Mention",'+
		'        "id": "0052x000000ldxE"'+
		'      }'+
		'    ]'+
		'  }'+
		'}';
        
        Http http = new Http();
        HttpRequest httpReq   = new HttpRequest();
        httpReq.setEndpoint(instanceURL);
        httpReq.setMethod('POST');
        httpReq.setBody(json);
        httpReq.setHeader('Authorization', 'Bearer '+UserInfo.getSessionId());
        httpReq.setHeader('Content-Type', 'application/json');
        
        HttpResponse response = new HttpResponse();
        
        try{
            response = http.send(httpReq);
            if( response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                String body = response.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Responsse from Server '+body);
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
        } 
    }
}