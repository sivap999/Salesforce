public class QuickbooksVendor {
    public PrimaryEmailAddr PrimaryEmailAddr;
    public WebAddr WebAddr;
    public PrimaryPhone PrimaryPhone;
    public String DisplayName;	
    public String Suffix;	
    public String Title;	
    public Mobile Mobile;
    public String FamilyName;	
    public String TaxIdentifier;	
    public String AcctNum;	
    public String CompanyName;	
    public BillAddr BillAddr;
    public String GivenName;	
    public String PrintOnCheckName;	
    public class PrimaryEmailAddr {
        public String Address;	
    }
    public class WebAddr {
        public String URI;	
    }
    public class PrimaryPhone {
        public String FreeFormNumber;	
    }
    public class Mobile {
        public String FreeFormNumber;	
    }
    public class BillAddr {
        public String City;	
        public String Country;	
        public String Line3;	
        public String Line2;	
        public String Line1;	
        public String PostalCode;	
        public String CountrySubDivisionCode;	
    }
}