public class FreshdeskTicket {
    public List<String> cc_emails;
    public List<String> fwd_emails;
    public List<String> reply_cc_emails;
    public List<String> ticket_cc_emails;
    public boolean fr_escalated;
    public boolean spam;
    public String email_config_id;
    public String group_id;
    public Integer priority;	
    public String requester_id;	
    public String responder_id;
    public Integer source;	
    public String company_id;
    public Integer status;	
    public String subject;	
    
    public String id;	
    
    public String due_by;	
    public String fr_due_by;	
    public boolean is_escalated;
    public String description;	
    public String description_text;	
    
    public String created_at;	
    public String updated_at;
    public List<String> tags;
    public List<attachments> attachments;
    public boolean nr_escalated;
    
    public class attachments{
        public String id;	
        public String content_type;	
        public Integer size;	
        public String name;	
        public String attachment_url;
        public String created_at;	
        public String updated_at;	
    }
    
    public static FreshdeskTicket parse(String json){
        return (FreshdeskTicket) System.JSON.deserialize(json, FreshdeskTicket.class);
    }
}