public class PipedriveOrganization {
    public boolean success;
    public data[] data;
    public class data {
        public Integer id;	
        public Integer company_id;	
        public String name;
        public Integer open_deals_count;	
        public Integer related_open_deals_count;	
        public Integer closed_deals_count;	
        public Integer related_closed_deals_count;	
        public Integer email_messages_count;	
        public Integer people_count;	
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
        public String first_char;	
        public String update_time;	
        public String add_time;	
        public String visible_to;	
        public String next_activity_date;	
        public String next_activity_time;	
        public Integer next_activity_id;	
        public Integer label;	
        public String address;	
        public String address_subpremise;	
        public String address_street_number;	
        public String address_route;	
        public String address_sublocality;	
        public String address_locality;	
        public String address_admin_area_level_1;	
        public String address_admin_area_level_2;	
        public String address_country;	
        public String address_postal_code;	
        public String address_formatted_address;	
        public String owner_name;	
        public String cc_email;	
        public owner_id owner_id;
    }
    public class owner_id {
        public Integer id;	
        public String name;
        public String email;	
        public Integer has_pic;
        public boolean active_flag;
        public Integer value;	
    }
     public class cls_additional_data {
        public cls_pagination pagination;
    }
     public class cls_pagination {
        public Integer start;	
        public Integer limit_x;	
        public boolean more_items_in_collection;
    }

    public static PipedriveOrganization parse(String json){
        return (PipedriveOrganization) System.JSON.deserialize(json, PipedriveOrganization.class);
    }
}