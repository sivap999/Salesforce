({

    onInit : function(component, event, helper) {
        
        component.set('v.columns', [
            {label: 'Exception Type', fieldName: 'ExceptionType', type: 'text'},
            {label: 'Phase', fieldName: 'Phase', type: 'text'},
            {label: 'Message', fieldName: 'Message', type: 'text'},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date'},
            //{label: 'Async Apex JobId', fieldName: 'AsyncApexJobId', type: 'text'},
            {label: 'Stack Trace', fieldName: 'StackTrace', type: 'text', wrapText:true},
        ]);
        
        const empApi = component.find('empApiNew');
        empApi.onError($A.getCallback(error => {
            console.error('EMP API error: ', JSON.stringify(error));
        }));
        const channel = component.find('channel').get('v.value');
        const replayId = -2;
            
        /*empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {
            console.log('Received event ', JSON.stringify(eventReceived));
            let datalist = component.get('v.data');
            if(!datalist){
            	datalist = [];
        	}
            datalist.push(eventReceived.data.payload);
        	component.set('v.data', datalist);
        }))
        .then(subscription => {
            component.set('v.eventMessage', 'Subscription request sent to: '+ subscription.channel);
            console.log(' subscription ', subscription);
            component.set('v.subscription', subscription);
        });*/
    },

    subscribe : function(component, event, helper) {
            
        const empApi = component.find('empApiNew');
        const channel = component.find('channel').get('v.value');
        const replayId = -2;
            
        empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {
            console.log('Received event ', JSON.stringify(eventReceived));
            let datalist = component.get('v.data');
            if(!datalist){
            	datalist = [];
        	}
            datalist.push(eventReceived.data.payload);
        	component.set('v.data', datalist);
        }))
        .then(subscription => {
            component.set('v.eventMessage', 'Subscription request sent to: '+ subscription.channel);
            console.log(' subscription ', subscription);
            component.set('v.subscription', subscription);
        });
    },

    unsubscribe : function(component, event, helper) {
        const empApi = component.find('empApiNew');
        const subscription = component.get('v.subscription');
        console.log(' subscription \n ', subscription);
        empApi.unsubscribe(subscription, $A.getCallback(unsubscribed => {
          console.log('Unsubscribed from channel '+ unsubscribed.subscription);
          component.set('v.subscription', null);
          component.set('v.data', null);
        }));
    }
})