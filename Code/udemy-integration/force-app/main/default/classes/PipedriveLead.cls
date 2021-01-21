public class PipedriveLead {
    
    public boolean success;
    public data[] data;
    
    public class data {
        public String id;	
        public String title;	
        public Integer owner_id;	
        public Integer creator_id;	
        public value value;
        public String note;	
        public Integer person_id;	
        public Integer organization_id;	
        public boolean is_archived;
        public String source_name;	
        public boolean was_seen;
        public Integer next_activity_id;	
        public String add_time;	
        public String update_time;	
    }
    public class value {
        public Integer amount;	
        public String currency_x;	
    }
    public class pagination {
        public Integer start;	
        public Integer limit_x;	
        public boolean more_items_in_collection;
    }
}