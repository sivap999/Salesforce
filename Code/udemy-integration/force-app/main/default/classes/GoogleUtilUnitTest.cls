@IsTest
public class GoogleUtilUnitTest {

    @isTest
    public static void createEventtest(){
        
        String createEvent = '{'+
		' "kind": "calendar#event",'+
		' "etag": "\"3218825246238000\"",'+
		' "id": "1ce0635rldkkdhf8gmefaknspk",'+
		' "status": "confirmed",'+
		' "htmlLink": "https://www.google.com/calendar/event?eid=MWNlMDYzNXJsZGtrZGhmOGdtZWZha25zcGtfMjAxNTA1MjhUMTYwMDAwWiBhbWl0LmEucGFudGhlckBt",'+
		' "created": "2020-12-31T11:03:43.000Z",'+
		' "updated": "2020-12-31T11:03:43.119Z",'+
		' "summary": "Google I/O 2015",'+
		' "description": "A chance to hear more about Google\"s developer products.",'+
		' "location": "800 Howard St., San Francisco, CA 94103",'+
		' "creator": {'+
		'  "email": "amit.a.panther@gmail.com",'+
		'  "self": true'+
		' },'+
		' "organizer": {'+
		'  "email": "amit.a.panther@gmail.com",'+
		'  "self": true'+
		' },'+
		' "start": {'+
		'  "dateTime": "2015-05-28T12:00:00-04:00",'+
		'  "timeZone": "America/Los_Angeles"'+
		' },'+
		' "end": {'+
		'  "dateTime": "2015-05-28T20:00:00-04:00",'+
		'  "timeZone": "America/Los_Angeles"'+
		' },'+
		' "recurrence": ['+
		'  "RRULE:FREQ=DAILY;COUNT=2"'+
		' ],'+
		' "iCalUID": "1ce0635rldkkdhf8gmefaknspk@google.com",'+
		' "sequence": 0,'+
		' "attendees": ['+
		'  {'+
		'   "email": "sbrin@example.com",'+
		'   "responseStatus": "needsAction"'+
		'  },'+
		'  {'+
		'   "email": "lpage@example.com",'+
		'   "responseStatus": "needsAction"'+
		'  }'+
		' ],'+
		' "reminders": {'+
		'  "useDefault": true'+
		' }'+
		'}';
        
        String token=		'{'+
		'  "access_token": "1/fFAGRNJru1FTz70BzhT3Zg",'+
		'  "expires_in": 3920,'+
		'  "scope": "https://www.googleapis.com/auth/drive.metadata.readonly",'+
		'  "token_type": "Bearer"'+
		'}';
        
        SingleRequstMock refreshTokenMock = new SingleRequstMock(200,'OK',token, null);
        SingleRequstMock createEventMock = new SingleRequstMock(200,'OK',createEvent, null);
        
        Map<String, HttpCalloutMock> requests = new Map<String, HttpCalloutMock>();
        requests.put('https://oauth2.googleapis.com/token',refreshTokenMock);
        requests.put('https://www.googleapis.com/calendar/v3/calendars/cse.amitallenhouse@gmail.com/events',createEventMock);
        
        MultiRequestMock mock = new MultiRequestMock(requests);
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        String body=		'{'+
		'  "summary": "Google I/O 2015",'+
		'  "location": "800 Howard St., San Francisco, CA 94103",'+
		'  "description": "A chance to hear more about Google\"s developer products.",'+
		'  "start": {'+
		'    "dateTime": "2015-05-28T09:00:00-07:00",'+
		'    "timeZone": "America/Los_Angeles"'+
		'  },'+
		'  "end": {'+
		'    "dateTime": "2015-05-28T17:00:00-07:00",'+
		'    "timeZone": "America/Los_Angeles"'+
		'  },'+
		'  "recurrence": ['+
		'    "RRULE:FREQ=DAILY;COUNT=2"'+
		'  ],'+
		'  "attendees": ['+
		'    {'+
		'      "email": "lpage@example.com"'+
		'    },'+
		'    {'+
		'      "email": "sbrin@example.com"'+
		'    }'+
		'  ]'+
		'}';
        
        Test.startTest();
        	GoogleUtil.createGoogleEvent(body);
        Test.stopTest();
    }
}