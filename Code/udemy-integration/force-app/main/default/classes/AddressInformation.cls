public class AddressInformation {

    public Components components;
    public Integer confidence;	
    public String formatted;	
    public Geometry geometry;

    public class Components {
        public String city;	
        public String city_district;	
        public String continent;	
        public String country;	
        public String country_code;	
        public String county;	
        public String neighbourhood;	
        public String postcode;	
        public String road;	// Street
        public String road_type;	
        public String state;	
        public String state_code;	
        public String state_district;	
        public String suburb;	
    }
    public class Geometry {
        public Double lat;	
        public Double lng;	
    }
}