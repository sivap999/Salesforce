({
	onClick : function(component, event, helper) {
		component.set('v.isLoading', true);
        var action = component.get('c.getAllTickets');
        action.setCallback(this, function(response){
            let state = response.getState();
            component.set('v.isLoading', false);
            if(state==='SUCCESS' || state ==='DRAFT'){
                var responseValue = response.getReturnValue();
                console.log(' responseValue ', JSON.parse(responseValue));
                component.set('v.ticketsList', JSON.parse(responseValue));
                //alert('Tickets Retrieved ');
            }else{
                let errors = response.getError();
                console.log(' errors ', errors);
            }
        });
        $A.enqueueAction(action);
	}
})