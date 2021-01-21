public class PipedriveActivities {
    public boolean success;
    public data[] data;
    
    public class data {
        public Integer id;
        public Integer company_id;	
        public Integer user_id;	
        public boolean done;
        public String type_x;	
        public String due_date;	
        public String due_time;	
        public String duration;	
        public String add_time;	
        public String marked_as_done_time;	
        public Integer notification_language_id;	
        public String subject;
        public String public_description;	
        public Integer org_id;	
        public Integer person_id;	
        public Integer deal_id;	
        public String lead_id;
        public String lead_title;	
        public boolean active_flag;
        public String update_time;	
        public String note;
        public Integer created_by_user_id;	
        public String org_name;	
        public String person_name;	
        public String deal_title;	
        public String owner_name;	
        public String person_dropbox_bcc;	
        public String deal_dropbox_bcc;	
        public Integer assigned_to_user_id;	
        public String type_name;	
    }
    
    public class participants {
        public Integer person_id;	
        public boolean primary_flag;
    }
    
    public class email {
        public String label;	
        public String value;	
        public boolean primary;
    }
    public class phone {
        public String label;	
        public String value;	
        public boolean primary;
    }
}