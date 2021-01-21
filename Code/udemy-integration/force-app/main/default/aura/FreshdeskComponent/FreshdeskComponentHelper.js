({
	onCreate : function(component, event, helper) {
		component.set('v.isLoading', true);
        var action = component.get('c.createTicket');
        action.setParams({
            name 		: component.get('v.name'),
            email 		: component.get('v.email'),
            phone 		: component.get('v.phone'),
            subject 	: component.get('v.subject'),
            description : component.get('v.description'),
			priorty 	: component.get('v.priority'),
            source 		: component.get('v.source'),
            status 		: component.get('v.status'),
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            component.set('v.isLoading', false);
            if(state==='SUCCESS' || state ==='DRAFT'){
                var responseValue = response.getReturnValue();
                console.log(' responseValue ', responseValue);
                alert('Ticket Created');
            }else{
                let errors = response.getError();
                console.log(' errors ', errors);
            }
        });
        $A.enqueueAction(action);
	}
})