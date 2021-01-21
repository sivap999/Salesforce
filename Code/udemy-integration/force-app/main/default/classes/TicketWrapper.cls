public class TicketWrapper {

    public List<String> cc_emails;
    public List<String> fwd_emails;
    public List<String> reply_cc_emails;
    public List<String> ticket_cc_emails;
    public Boolean fr_escalated;
    public Boolean spam;
    public Integer priority;
    public String requester_id;
    public Integer source;
    public Integer status;
    Public String subject;
    Public Integer id;
    Public String due_by;
    Public String fr_due_by;
    Public Boolean is_escalated;
    Public String description_text;
    Public String created_at;
    Public String updated_at;
    public Requester requester;
    
    Public Class Requester {
        public String id;
        public String name;
        public String email;
        public String mobile;
        public String phone;
    }

}