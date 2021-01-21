@IsTest
public class MetadataUtilMock implements WebServiceMock {
    
		public void doInvoke( Object stub, Object request, Map<String, Object> response,
						String endpoint, String soapAction, String requestName, String responseNS, 
                        String responseName, String responseType) {
            
            System.debug(' requestName \n'+requestName);
            System.debug(' soapAction \n'+soapAction);
            System.debug(' responseNS \n'+responseNS);
            System.debug(' responseName \n'+responseName);
            System.debug(' responseType \n'+responseType);
                            
			if(request instanceof MetadataService.retrieve_element){
                response.put('response_x', new MetadataService.retrieveResponse_element());
                
            }else if(request instanceof MetadataService.checkDeployStatus_element){
                response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
                
            }else if(request instanceof MetadataService.readMetadata_element){
                
               	MetadataService.Profile profile = new MetadataService.Profile();
                profile.fullName = 'Admin';
                
                MetadataService.ReadProfileResult result = new MetadataService.ReadProfileResult();
                result.records = new MetadataService.Profile[] { profile };
                
                MetadataService.readProfileResponse_element responseElement = new MetadataService.readProfileResponse_element();
                responseElement.result = result;
                
                response.put('response_x', responseElement);
                
            }else if(request instanceof MetadataService.listMetadata_element){
                
               MetadataService.FileProperties result = new MetadataService.FileProperties();
               result.fullName = 'Admin';
                
               MetadataService.listMetadataResponse_element responseElement = new MetadataService.listMetadataResponse_element();
               responseElement.result = new MetadataService.FileProperties[] { result };
               response.put('response_x', responseElement ); 
               
            }else if(request instanceof MetadataService.checkRetrieveStatus_element){
                response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
                
            }else if(request instanceof MetadataService.describeMetadata_element){
                response.put('response_x', new MetadataService.describeMetadataResponse_element());
                
            }else if(request instanceof MetadataService.deploy_element){
               response.put('response_x', new MetadataService.deployResponse_element()); 
                
            }else if(request instanceof MetadataService.updateMetadata_element){

                MetadataService.SaveResult result = new MetadataService.SaveResult();
                result.success = true;
                
                MetadataService.updateMetadataResponse_element responseElement = new MetadataService.updateMetadataResponse_element();
                responseElement.result = new MetadataService.SaveResult[] {result};
                    
                response.put('response_x', responseElement);
                
            }else if(request instanceof MetadataService.renameMetadata_element){
                response.put('response_x', new MetadataService.renameMetadataResponse_element());
                
            }else if(request instanceof  MetadataService.cancelDeploy_element){
                response.put('response_x', new MetadataService.cancelDeployResponse_element());
                
            }else if(request instanceof  MetadataService.deleteMetadata_element){
                
                MetadataService.DeleteResult result = new MetadataService.DeleteResult();
                result.success = true;
                
                MetadataService.deleteMetadataResponse_element responseElement = new MetadataService.deleteMetadataResponse_element();
                responseElement.result = new MetadataService.DeleteResult[] {result};
                    
                response.put('response_x', responseElement );
                
            }else if(request instanceof  MetadataService.upsertMetadata_element){
                
                MetadataService.UpsertResult result = new MetadataService.UpsertResult();
                result.success = true;
                
                MetadataService.upsertMetadataResponse_element responseElement = new MetadataService.upsertMetadataResponse_element();
                responseElement.result = new MetadataService.UpsertResult[] {result};
                    
                response.put('response_x', responseElement);
                
            }else if(request instanceof  MetadataService.createMetadata_element){
                
                MetadataService.SaveResult result = new MetadataService.SaveResult();
                result.success = true;
                
                MetadataService.createMetadataResponse_element responseElement = new MetadataService.createMetadataResponse_element();
                responseElement.result = new MetadataService.SaveResult[] {result};
                    
                response.put('response_x', responseElement);
                
            }else if(request instanceof  MetadataService.deployRecentValidation_element){
                response.put('response_x', new MetadataService.deployRecentValidationResponse_element());
                
            }else if(request instanceof MetadataService.describeValueType_element){
                response.put('response_x', new MetadataService.describeValueTypeResponse_element());
                
            }else if(request instanceof MetadataService.checkRetrieveStatus_element){
                response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
                
            }
                
			return;
		}
}