public class QuickbooksEmployee {
    public Employee Employee;
    public class Employee {
        public String SyncToken;	
        public String domain;	
        public String DisplayName;	
        public PrimaryPhone PrimaryPhone;
        public String PrintOnCheckName;	
        public String FamilyName;	
        public boolean Active;
        public String SSN;	
        public PrimaryAddr PrimaryAddr;
        public boolean sparse;
        public boolean BillableTime;
        public String GivenName;	
        public String Id;	
        public MetaData MetaData;
    }
    public class PrimaryPhone {
        public String FreeFormNumber;	
    }
    public class PrimaryAddr {
        public String CountrySubDivisionCode;	
        public String City;	
        public String PostalCode;	
        public String Id;	
        public String Line1;	
    }
    public class MetaData {
        public String CreateTime;	
        public String LastUpdatedTime;	
    }
    public static QuickbooksEmployee parse(String json){
        return (QuickbooksEmployee) System.JSON.deserialize(json, QuickbooksEmployee.class);
    }
}