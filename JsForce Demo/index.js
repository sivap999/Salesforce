const jsforce  = require('jsforce');
const username = 'amitsingh@integration.org';
const password = 'Udemy@2020';
const securityToken = 'YOUR_SECURITY_TOKEN';

const conn = new jsforce.Connection();

conn.login(username, password, function(err, res) {
    if (err) {
        return console.error(err);
    }
    console.log('Authenticated ', res);
    conn.sobject('PushTopic').create({ 
        Name: 'DemoUpdates',
        Query : 'SELECT Id, Name, CloseDate, StageName FROM Opportunity Where AccountId != null',
        ApiVersion : 50.0,
        NotifyForOperationCreate : true,
        NotifyForOperationUpdate : true,
        NotifyForOperationUndelete: true,
        NotifyForOperationDelete : true,
        NotifyForFields  : 'All'
    }).then(function(ret) {
        console.log('Return ', ret);
        conn.streaming.topic("DemoUpdates").subscribe(function(message) {
            console.log('Event Type : ' + message.event.type);
            console.log('Event Created : ' + message.event.createdDate);
            console.log('Object Id : ' + message.sobject.Id);
            console.log('Event : ' + JSON.stringify(message));
        });
    }, 
    function(err) {
        console.error('Error  ', err);
    });

    
});