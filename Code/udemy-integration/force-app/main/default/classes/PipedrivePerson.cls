public class PipedrivePerson {
    
    public boolean success;
	public data[] data;
    
    public class data {
        public Integer id;	
        public Integer company_id;	
        public owner_id owner_id;
        public org_id org_id;
        public String name;	
        public String first_name;	
        public String last_name;
        public Integer open_deals_count;	
        public Integer related_open_deals_count;	
        public Integer closed_deals_count;
        public Integer related_closed_deals_count;	
        public Integer participant_open_deals_count;	
        public Integer participant_closed_deals_count;	
        public Integer email_messages_count;	
        public Integer activities_count;	
        public Integer done_activities_count;	
        public Integer undone_activities_count;	
        public Integer files_count;	
        public Integer notes_count;
        public Integer followers_count;	
        public Integer won_deals_count;
        public Integer related_won_deals_count;	
        public Integer lost_deals_count;	
        public Integer related_lost_deals_count;	
        public boolean active_flag;
        public phone[] phone;
        public email[] email;
        public String first_char;	
        public String update_time;	
        public String add_time;	
        public String visible_to;	
        public String next_activity_date;	
        public String next_activity_time;	
        public Integer next_activity_id;	
        public Integer label;	
        public String org_name;
        public String owner_name;	
        public String cc_email;
    }
	public class owner_id {
		public Integer id;	
		public String name;	
		public String email;	
		public Integer has_pic;
		public boolean active_flag;
		public Integer value;	
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
	public class phone {
		public String label;	
		public String value;	
		public boolean primary;
	}
	public class email {
		public String label;	
		public String value;	
		public boolean primary;
	}
    
    public class pagination {
		public Integer start;	
		public Integer limit_x;	
		public boolean more_items_in_collection;
	}
	public static PipedrivePerson parse(String json){
		return (PipedrivePerson) System.JSON.deserialize(json, PipedrivePerson.class);
	}
}