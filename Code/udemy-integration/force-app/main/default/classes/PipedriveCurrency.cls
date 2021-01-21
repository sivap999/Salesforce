public class PipedriveCurrency {
    public boolean success;
    public data[] data;
    public class data {
        public Integer id;	
        public String code;
        public String name;	
        public String symbol;	
        public Integer decimal_points;	
        public boolean active_flag;
        public boolean is_custom_flag;
    }
    public static List<PipedriveCurrency> parse(String json){
        return (List<PipedriveCurrency>) System.JSON.deserialize(json, List<PipedriveCurrency>.class);
    }
}