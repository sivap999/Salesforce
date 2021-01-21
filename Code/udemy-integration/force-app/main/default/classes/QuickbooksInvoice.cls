public class QuickbooksInvoice {
    public Invoice Invoice;
    public class Invoice {
        public String TxnDate;	
        public String domain;	
        public String PrintStatus;	
        public SalesTermRef SalesTermRef;
        public Double TotalAmt;	
        public Line[] Line;
        public String DueDate;	
        public boolean ApplyTaxAfterDiscount;
        public String DocNumber;	
        public boolean sparse;
        public CustomerMemo CustomerMemo;
        public Integer Deposit;	
        public Double Balance;	
        public CustomerRef CustomerRef;
        public TxnTaxDetail TxnTaxDetail;
        public String SyncToken;	
        public LinkedTxn[] LinkedTxn;
        public BillEmail BillEmail;
        public ShipAddr ShipAddr;
        public String EmailStatus;	
        public BillAddr BillAddr;
        public MetaData MetaData;
        public CustomField[] CustomField;
        public String Id;	
    }
    public class SalesTermRef {
        public String value;	
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
    public class CustomerMemo {
        public String value;	
    }
    public class CustomerRef {
        public String name;	
        public String value;	
    }
    public class TxnTaxDetail {
        public TxnTaxCodeRef TxnTaxCodeRef;
        public Double TotalTax;	
        public TaxLine[] TaxLine;
    }
    public class TxnTaxCodeRef {
        public String value;	
    }
    public class TaxLine {
        public String DetailType;	
        public Double Amount;	
        public TaxLineDetail TaxLineDetail;
    }
    public class TaxLineDetail {
        public Double NetAmountTaxable;
        public Integer TaxPercent;	
        public TaxRateRef TaxRateRef;
        public boolean PercentBased;
    }
    public class TaxRateRef {
        public String value;	
    }
    public class LinkedTxn {
        public String TxnId;	
        public String TxnType;	
    }
    public class BillEmail {
        public String Address;	
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
        public String Line4;	
        public String Line3;	
        public String Line2;	
        public String Line1;	
        public String Lng;	
        public String Lat;	
        public String Id;	
    }
    public class MetaData {
        public String CreateTime;	
        public String LastUpdatedTime;	
    }
    public class CustomField {
        public String DefinitionId;
        public String StringValue;	
        public String Type_x;	
        public String Name;	
    }
    public static QuickbooksInvoice parse(String json){
        return (QuickbooksInvoice) System.JSON.deserialize(json, QuickbooksInvoice.class);
    }
}