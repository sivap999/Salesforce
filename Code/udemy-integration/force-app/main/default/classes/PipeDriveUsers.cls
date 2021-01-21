public class PipeDriveUsers {
    public boolean success;
    public data[] data;
    public additional_data additional_data;
    public class data {
        public Integer id;	
        public String name;	
        public String default_currency;	
        public String timezone_name;	
        public String timezone_offset;	
        public String locale;	
        public String email;	
        public String phone;
        public String created;	
        public String modified;
        public Integer lang;	
        public boolean active_flag;
        public Integer is_admin;	
        public String last_login;	
        public String signup_flow_variation;	
        public Integer role_id;	
        public boolean has_created_company;
        public boolean activated;
        public icon_url icon_url;
        public boolean is_you;
    }
    public class phone {
    }
    public class icon_url {
    }
    public class additional_data {
        public Integer company_id;	
    }
    public static List<PipeDriveUsers> parse(String json){
        return (List<PipeDriveUsers>) System.JSON.deserialize(json, List<PipeDriveUsers>.class);
    }
}