public class PipedriveStage {
    public boolean success;
    public data[] data;
    public class data {
        public Integer id;	
        public Integer order_nr;	
        public String name;	
        public boolean active_flag;
        public Integer deal_probability;	
        public Integer pipeline_id;	
        public boolean rotten_flag;
        public rotten_days rotten_days;
        public String add_time;	
        public update_time update_time;
        public String pipeline_name;	
        public boolean pipeline_deal_probability;
    }
    public class rotten_days {
    }
    public class update_time {
    }
    public static List<PipedriveStage> parse(String json){
        return (List<PipedriveStage>) System.JSON.deserialize(json, List<PipedriveStage>.class);
    }
}