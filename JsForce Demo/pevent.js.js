const jsforce  = require('jsforce');
const username = 'amitsingh@integration.org';
const password = 'Udemy@2020';

const conn = new jsforce.Connection();

conn.login(username, password, function(err, res) {
    if (err) {
        return console.error(err);
    }
    console.log('Authenticated ', res);
	
    conn.streaming.topic("/event/BatchApexErrorEvent").subscribe(function(message) {
        console.log('Event Batch Apex : ', message );
		console.log(' \n ' );
    });
	
	conn.streaming.topic("/event/Test_Event__e").subscribe(function(message) {
        console.log('Event Test Event : ', message );
		console.log(' \n ' );
    });
	
	conn.streaming.topic("/event/LogoutEventStream").subscribe(function(message) {
        console.log('Event Logout Event : ', message );
		console.log(' \n ' );
    });

    
});