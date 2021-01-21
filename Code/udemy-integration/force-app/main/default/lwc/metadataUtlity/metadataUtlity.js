/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 12-29-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   12-28-2020   Amit Singh   Initial Version
**/
import { LightningElement, track, wire } from 'lwc';
import listMetadata from '@salesforce/apexContinuation/MetadataManagerService.listMetadata';
import readMetadata from '@salesforce/apexContinuation/MetadataManagerService.readMetadata';

import mainTemplate from './metadataUtlity.html';
import newObject from    './newobject.html';
import newField from     './newfield.html';

const columns = [
    { label: 'Label', fieldName: 'label' },
    { label: 'API', fieldName: 'fullName' },
    { label: 'Description', fieldName: 'description' },
    { label: 'Help Text', fieldName: 'inlineHelpText' },
    { label: 'isNameField?', fieldName: 'isNameField' },
    { label: 'Required?', fieldName: 'required' },
    { label: 'Unique?', fieldName: 'unique' },
    { label: 'Type', fieldName: 'type_x' },
];

const valcolumns = [
    { label: 'Name', fieldName: 'fullName' },
    { label: 'Description', fieldName: 'description' },
    { label: 'Error Formula', fieldName: 'errorConditionFormula' },
    { label: 'Error Display Field', fieldName: 'errorDisplayField' },
    { label: 'Error Message', fieldName: 'errorMessage' },
    { label: 'Active?', fieldName: 'active' },
];


export default class MetadataUtlity extends LightningElement {

    fieldsData = [];
    columns = columns;
    
    validationRules = [];
    valColumns = valcolumns;

    @track objects;
    @track objectInformation;
    @track errors;
    
    selectedObject;
    isLoading = false;
    newObject = false;
    mainTemplate = true;
    showFormat  = false;
    newfield    = false;

    showLookup  = false;
    showLength  = true;
    showNumbers = false;
    showPickList = false;

    @track relatedToObjects;

    value = [];
    valued = 'Deployed';
    valuet = 'Text'

    get options() {
        return [
            { label: 'Text', value: 'Text' },
            { label: 'Auto Number', value: 'AutoNumber' },
        ];
    }

    get optionsAdd() {
        return [
            { label: 'Do not allow duplicate values', value: 'Unique' },
            { label: 'Set this field as the unique record identifier from an external system', value: 'ExternalId' },
        ];
    }

    get dataTypes(){
        return [
            { label: 'Text', value: 'Text' },
            { label: 'Auto Number', value: 'AutoNumber' },
            { label: 'Lookup', value: 'Lookup' },
            { label: 'Master Detail', value: 'MasterDetail' },
            { label: 'PickList', value: 'Picklist' },
            { label: 'Email', value: 'Email' },
            { label: 'Phone', value: 'Phone' },
            { label: 'Percent', value: 'Percent' },
            /*{ label: 'Text Area', value: 'TextArea' },
            { label: 'Text Area (Long)', value: 'LongTextArea' },
            { label: 'Text Area (Rich)', value: 'Html' },*/
            { label: 'Url', value: 'Url' },
            { label: 'Checkbox', value: 'Checkbox' },
            { label: 'Currency', value: 'Currency' },
            { label: 'Number', value: 'Number' },
            { label: 'Date', value: 'Date' },
            { label: 'DateTime', value: 'DateTime' },
        ];
    }

    handleChangeOF(e) {
        this.value = e.detail.value;
    }

    get optionsOF() {
        return [
            { label: 'Allow Reports', value: 'enableReports' },
            { label: 'Allow Activities', value: 'enableActivities' },
            { label: 'Track Field History', value: 'enableFeeds' },
            { label: 'Allow in Chatter Groups', value: 'allowInChatterGroups' },
        ];
    }

    get optionsD() {
        return [
            { label: 'Deployed', value: 'Deployed' },
            { label: 'In Development', value: 'InDevelopment' },
        ];
    }

    render(){
        if(this.mainTemplate){
            return mainTemplate;
        }else if(this.newObject){
            return newObject;
        }else if(this.newfield){
            return newField;
        }
    }


    @wire(listMetadata)
    wiredData({ error, data }) {
        if (data) {
            let parsedInformation = JSON.parse(data);
            let options = [];
            parsedInformation.forEach(item => {
                if( item.fullName.toLowerCase().includes('__C'.toLowerCase()) && !item.namespacePrefix){
                    options.push({
                        label : item.fullName.replace("__c", " ").replace("_", " "),
                        value : item.fullName
                    })
                }
            });
            this.objects = options;
        } else if (error) {
            console.error({
                method : 'listMetadata',
                Error : error
            });
            this.error = this.error;
        }
    }

    handleChange(event){
        this.selectedObject = event.target.value;
    }

    handleDTChange(event){
        if( event.target.value === 'AutoNumber' ){
            this.showFormat = true;
        }else{
            this.showFormat = false;
        }
    }

    handleObjectInformation(){
        if( !this.selectedObject){
            alert('Select a valid object ');
            return;
        }
        this.isLoading = true;
        readMetadata({ 
            objectApiName : this.selectedObject 
        })
        .then(objectInfo => {
            this.objectInformation = JSON.parse(objectInfo);
            this.fieldsData        = this.objectInformation.fields;
            this.validationRules   = this.objectInformation.validationRules;
        })
        .catch(error => {
            this.error = this.error;
        })
        .finally(()=>{
            this.isLoading = false;
        })
    }

    handleCreateNewObject(){
        this.newObject    = true;
        this.mainTemplate = false;
        this.newfield     = false;
    }
    handleBack(){
        this.newObject    = false;
        this.mainTemplate = true;
        this.newfield     = false;
    }
    handleFieldClick(){
        this.newObject    = false;
        this.mainTemplate = false;
        this.newfield     = true;
        this.relatedToObjects = this.objects.filter( item => {
            return item.value !== this.selectedObject;
        });
    }

    handleDataTypeChange(event){
        let value = event.target.value;
        if( value === 'AutoNumber' ){
            this.showFormat = true;
            this.showLookup = false;
            this.showLength = false;
            this.showNumbers = false;
        }else if(value === 'Text'){
            this.showFormat = false;
            this.showLookup = false;
            this.showLength = true;
            this.showNumbers = false;
            this.showPickList = false;
        }else if( value === 'Lookup' || value === 'MasterDetail'){
            this.showFormat = false;
            this.showLookup = true;
            this.showLength = false;
            this.showNumbers = false;
            this.showPickList = false;
        }else if( value === 'Currency' || value === 'Number' || value === 'Percent' ){
            this.showFormat = false;
            this.showLookup = false;
            this.showLength = false;
            this.showPickList = false;
            this.showNumbers = true;
        }else if( value === 'Picklist'){
            this.showFormat = false;
            this.showLookup = false;
            this.showLength = false;
            this.showNumbers = false;
            this.showPickList = true;
        }else if( value === 'Email' || value === 'Phone' || 
                    value === 'Date' || value === 'DateTime' 
                    || value === 'Checkbox' || value === 'Url'){
            this.showFormat = false;
            this.showLookup = false;
            this.showLength = false;
            this.showNumbers = false;
            this.showPickList = false;
        }
        
    }

    handleCreate(){
        let allValid = this.validateInput();
        if(!allValid){
            return;
        }
        this.isLoading = true;

    }

    validateInput(){
        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        return allValid;
    }
    
}