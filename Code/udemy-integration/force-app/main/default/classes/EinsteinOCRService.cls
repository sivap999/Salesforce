/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-01-2021
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   12-31-2020   Amit Singh   Initial Version
**/
public class EinsteinOCRService {
    
    public static FINAL String  OCR_API         = 'https://api.einstein.ai/v2/vision/ocr';
    public static FINAL String  OCR_MODEL       = 'OCRModel';
    public static FINAL String  OCR_MODEL_TABEL = 'OCRModel';
    
    public static void readTextFromImageByURL(){
        String sample = 'https://www.gluu.org/blog/wp-content/uploads/2016/12/jwt-diagram.png';
        String result = EinsteinAPIService.imageOCR(OCR_API, sample, OCR_MODEL, false, false);
        parseResponse(result);
    }
    
    public static void readTextFromImageByBase64(String recordId){
        List<ContentDocumentLink> contentLink = [SELECT ContentDocumentId, LinkedEntityId  
                                                FROM ContentDocumentLink where LinkedEntityId =:recordId  WITH SECURITY_ENFORCED];
        if(!contentLink.isEmpty()){
            ContentVersion content = [SELECT Title,VersionData FROM 
                                    ContentVersion 
                                    where ContentDocumentId =: contentLink.get(0).ContentDocumentId 
                                    WITH SECURITY_ENFORCED
                                    LIMIT 1];
            String sample = EncodingUtil.base64Encode(content.VersionData);
            String result = EinsteinAPIService.imageOCR(OCR_API, sample, OCR_MODEL, true, false);
            parseResponse(result);
        }
    }
    private static void parseResponse(String ressult){
        EinsteinOCRResponse response = (EinsteinOCRResponse)System.JSON.deserialize(ressult, EinsteinOCRResponse.class);
        for(EinsteinOCRResponse.Probabilities prob : response.probabilities){
            System.debug(System.LoggingLevel.DEBUG, prob.label);
        }
    }
}