public class TwitterUtil {
    
    public static Map<String, String> getParameters(String ConsumerKey){
        
        String nounce=String.valueOf(DateTime.now().getTime()/1000);
        String timestamp=String.valueOf(DateTime.now().getTime()/1000);
        
        Map<String,String> parameters = new Map<String,String>();
        parameters.put('oauth_consumer_key',ConsumerKey);
        parameters.put('oauth_nonce',nounce);
        parameters.put('oauth_timestamp',timestamp);
        parameters.put('oauth_signature_method','HMAC-SHA1');
        parameters.put('oauth_version', '1.0');
        
        return parameters;
        
    }

    public static String generateAPISignature(HttpRequest req, String consumerSecret, String tokenSecret, Map<String,String> parameters) {
        String baseString    = createBaseString(req, parameters);        
        String key  = EncodingUtil.urlEncode(consumerSecret, 'UTF-8') + '&' + EncodingUtil.urlEncode(tokenSecret, 'UTF-8');
        Blob sign = Crypto.generateMac(
            'HmacSHA1'
            , Blob.valueOf(baseString)
            , Blob.valueOf(key)
        );
        return EncodingUtil.urlEncode( EncodingUtil.base64encode(sign), 'UTF-8');
    }

    public static String generateAPIHeader(String signature, Map<String,String> parameters) {
        String header = 'OAuth ';
        for (String key : parameters.keySet()) {
            header = header + key + '="'+parameters.get(key)+'", ';
        }
        return header + 'oauth_signature="' + signature + '"';
    }
    
    private static String createBaseString(HttpRequest req, Map<String,String> parameters) {
        Map<String,String> p = parameters.clone();
        String host = req.getEndpoint();
        Integer n = host.indexOf('?');
        if(n>-1) {
            p.putAll(getUrlParams(host.substring(n+1)));
            host = host.substring(0,n);
        }
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();
        String s = keys.get(0)+'='+p.get(keys.get(0));
        for(Integer i=1;i<keys.size();i++) {
            s = s + '&' + keys.get(i)+'='+p.get(keys.get(i));
        }
        
        return req.getMethod().toUpperCase()+ '&' +
            EncodingUtil.urlEncode(host, 'UTF-8') + '&' +
            EncodingUtil.urlEncode(s, 'UTF-8');
    }
    

    private static Map<String,String> getUrlParams(String value) {
        Map<String,String> res = new Map<String,String>();
        if(value==null || value=='') {
            return res;
        }
        for(String s : value.split('&')) {
            System.debug('getUrlParams: '+s);
            List<String> kv = s.split('=');
            if(kv.size()>1) {
                System.debug('getUrlParams: -> '+kv[0]+','+kv[1]);
                res.put(kv[0],kv[1]);
            }
        }
        return res;
    }

     private static Map<String,String> tokenInfoMap(String resParams){  
        Map<String,String> rp = new Map<String,String>();
        for(String s : resParams.split('&')) {
            List<String> kv = s.split('=');
            rp.put(kv[0],kv[1]);
        }
        return rp;
    }
    
    public static PageReference doFetchOuthNonce(String CallBackVF, String ConsumerSecret, String oauthURL,
                                                  String APIName, String APIEndPoint, String authenticationURL,
                                                  String consumerKey){
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(oauthURL);
        
        Map<String , String> Parameters = getParameters(consumerKey);
        Parameters.put('oauth_callback',EncodingUtil.urlEncode(URL.getSalesforceBaseUrl().toExternalForm() + 
        CallBackVF, 'UTF-8'));
        String Signature = generateAPISignature(httpReq, ConsumerSecret, '', Parameters);
        String body = generateAPIHeader(Signature, Parameters);
        httpReq.setHeader('Authorization', body);
        HttpResponse response = new HttpResponse();
        Try{
            response = new HTTP().send(httpReq);
            
            if(response.getStatusCode() == 200){
                String resp = response.getBody();
                Map<String,String> responseMap = tokenInfoMap(resp);
                
                String authURL = authenticationURL+'?oauth_token='+responseMap.get('oauth_token');
                
                Cookie tempSecret = ApexPages.currentPage().getCookies().get('tempSecret');
                tempSecret = new Cookie('tempSecret', responseMap.get('oauth_token_secret'),null,-1,false);

                ApexPages.currentPage().setCookies(new Cookie[]{tempSecret});
                
                PageReference pageRef = new PageReference(authURL);
                pageRef.setRedirect(true);
                
                return pageRef;
            }else{
                String errorMessage = 'Unexpected Error while communicating with ' +APIName+' API. '
                                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                return null;
            }
        }Catch(System.Exception e){
            System.debug('#### Exception Excuted '+e.getStackTraceString()+'  '+e.getMessage());
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                String errorMessage =  'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                                    +' Remote Site Setting and add '+' '+ APIEndPoint +' Endpoint';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                return null;
            }else{
                String errorMessage = 'Unexpected Error while communicating with ' + APIName+' . '
                                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                return null;
            }
        }
    }

    public static Map<String,String> doFetchAccessToken(String ConsumerKey, String tokenURL, String ConsumerSecret){
   
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(tokenURL);
        Map<String, String> urlMap = ApexPages.Currentpage().getParameters();
        Map<String , String> Parameters = getParameters(ConsumerKey);
        Parameters.put('oauth_token', urlMap.get('oauth_token'));
        Parameters.put('oauth_verifier', urlMap.get('oauth_verifier'));
        
        Cookie tempSecret = ApexPages.currentPage().getCookies().get('tempSecret');
        
        String Signature = generateAPISignature(httpReq, ConsumerSecret, tempSecret.getValue(), Parameters);
        String body = generateAPIHeader(Signature, Parameters);
        
        httpReq.setHeader('Authorization',body);
        
        HttpResponse response = new HttpResponse();
        Try{
            response = new Http().send(httpReq);
            Map<String,String> responseMap = tokenInfoMap(response.getBody());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'You Have Successfully authorized!!'));
            return responseMap;
        }Catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getStackTraceString()));
            return null;
        }
    }
    
    public static Map<String,String> doRefreshAccessToken(String ConsumerKey, String ConsumerSecret, 
                                                          String TokenSecret, String oauthToken, String tokenURL){
    
 
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(tokenURL);
        
        Map<String , String> Parameters = getParameters(ConsumerKey);
        Parameters.put('oauth_token', oauthToken);
        
        String Signature = generateAPISignature(httpReq, ConsumerSecret, TokenSecret, Parameters);
        String body = generateAPIHeader(Signature, Parameters);
        
        httpReq.setHeader('Authorization',body);
        HttpResponse response = new HttpResponse();
        Try{
            response = new Http().send(httpReq);
            Map<String,String> responseMap = tokenInfoMap(response.getBody());
            return responseMap;
        }Catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getStackTraceString()));
            return null;
        }
    }
    
    public static HttpRequest prepareRequest(String apiEndPoint, String consumerKey, String ConsumerSecret,
                                             String oauthToken, String tokenSecret,
                                             String urlToTarget, String Method){
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod(Method);
        httpReq.setEndPoint(apiEndPoint+urlToTarget);
        
        Map<String , String> Parameters = getParameters(consumerKey);
        Parameters.put('oauth_token', oauthToken);
        
        String Signature = generateAPISignature(httpReq, ConsumerSecret, 
                            tokenSecret, Parameters);
        String body = generateAPIHeader(Signature, Parameters);
        
        httpReq.setHeader('Authorization',body);
        return httpReq;
    }
}