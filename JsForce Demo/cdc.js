const jsforce  = require('jsforce');
const username = 'amitsingh@integration.org';
const password = 'Udemy@2020';

const conn = new jsforce.Connection();

conn.login(username, password, function(err, res) {
    if (err) {
        return console.error(err);
    }
    console.log('Authenticated ', res);
	
    conn.streaming.topic("/data/AccountChangeEvent").subscribe(function(message) {
        console.log('AccountChangeEvent : ', message );
		console.log(' \n ' );
    });
	
	conn.streaming.topic("/data/Employ__ChangeEvent").subscribe(function(message) {
        console.log('Employ__ChangeEvent : ', message );
		console.log(' \n ' );
    });

    
});