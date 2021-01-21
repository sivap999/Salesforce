public class TicketConversion {
    public String body;	
    public String body_text;	
    public String id;	
    public boolean incoming;
    
    public String user_id;	
    public String support_email;	
    public Integer source;	
    public Integer category;	
    public String[] to_emails;
    public String from_email;	
    public String[] cc_emails;
    public String[] bcc_emails;
    public Integer email_failure_count;
    public Integer outgoing_failures;
    public String created_at;	
    public String updated_at;
    public attachments[] attachments;
    public String ticket_id;	
    
    
    public class attachments {
        public String id;	
        public String name;	
        public String content_type;	
        public Integer size;	
        public String created_at;	
        public String updated_at;	
        public String attachment_url;	
        public String thumb_url;	
    }
    class cls_source_additional_info {
    }
}