public class PipedriveDeal {
    
    public boolean success;
    public data[] data;
    
    public class data {
        public Integer id;	
        public creator_user_id creator_user_id;
        public user_id user_id;
        public person_id person_id;
        public org_id org_id;
        public Integer stage_id;	
        public String title;	
        public String value;	
        public String currency_x;	
        public String add_time;	
        public String update_time;	
        public String stage_change_time;	
        public boolean active;
        public boolean deleted;
        public String status;	
        public String next_activity_date;	
        public String next_activity_time;	
        public Integer next_activity_id;
        public String visible_to;	
        public Integer pipeline_id;	
        public Integer products_count;	
        public Integer files_count;
        public Integer notes_count;	
        public Integer followers_count;	
        public Integer email_messages_count;	
        public Integer activities_count;	
        public Integer done_activities_count;	
        public Integer undone_activities_count;	
        public Integer participants_count;	
        public String expected_close_date;	
        public Integer stage_order_nr;
        public String person_name;	
        public String org_name;	
        public String next_activity_subject;	
        public String next_activity_type;	
        public String next_activity_duration;	
        public String next_activity_note;	
        public String formatted_value;	
        public String weighted_value;
        public String formatted_weighted_value;	
        public String weighted_value_currency;	
        public String owner_name;	
        public String cc_email;	
        public boolean org_hidden;
        public boolean person_hidden;
    }
    public class creator_user_id {
        public Integer id;	
        public String name;	
        public String email;	
        public Integer has_pic;	
        public boolean active_flag;
        public Integer value;
    }
    public class user_id {
        public Integer id;	
        public String name;	
        public String email;	
        public Integer has_pic;	
        public boolean active_flag;
        public Integer value;	
    }
    public class person_id {
        public boolean active_flag;
        public String name;	
        public email[] email;
        public phone[] phone;
        public Integer value;	
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
    public class org_id {
        public String name;	
        public Integer people_count;	
        public Integer owner_id;	
        public String address;	
        public boolean active_flag;
        public String cc_email;	
        public Integer value;	
    }
    
}