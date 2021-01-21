public class QuickbooksEstimates {
    public Double TotalAmt;	
    public BillEmail BillEmail;
    public CustomerMemo CustomerMemo;
    public ShipAddr ShipAddr;
    public String PrintStatus;	
    public String EmailStatus;	
    public BillAddr BillAddr;
    public Line[] Line;
    public CustomerRef CustomerRef;
    public TxnTaxDetail TxnTaxDetail;
    public boolean ApplyTaxAfterDiscount;
    public class BillEmail {
        public String Address;	
    }
    public class CustomerMemo {
        public String value;	
    }
    public class ShipAddr {
        public String City;	
        public String Line1;	
        public String PostalCode;	
        public String Lat;	
        public String Lng;	
        public String CountrySubDivisionCode;	
        public String Id;	
    }
    public class BillAddr {
        public String City;	
        public String Line1;	
        public String PostalCode;	
        public String Lat;	
        public String Lng;	
        public String CountrySubDivisionCode;	
        public String Id;	
    }
    public class Line {
        public String Description;	
        public String DetailType;	
        public SalesItemLineDetail SalesItemLineDetail;
        public Integer LineNum;	
        public Integer Amount;	
        public String Id;	
    }
    public class SalesItemLineDetail {
        public TaxCodeRef TaxCodeRef;
        public Integer Qty;
        public Integer UnitPrice;	
        public ItemRef ItemRef;
    }
    public class TaxCodeRef {
        public String value;	
    }
    public class ItemRef {
        public String name;	
        public String value;	
    }
    public class CustomerRef {
        public String name;	
        public String value;	
    }
    public class TxnTaxDetail {
        public Integer TotalTax;	
    }
}