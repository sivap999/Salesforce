public class QuickbooksPayment {
    public Payment Payment;
    public class Payment {
        public String SyncToken;	
        public String domain;	
        public DepositToAccountRef DepositToAccountRef;
        public Integer UnappliedAmt;	
        public String TxnDate;	
        public Integer TotalAmt;	
        public boolean ProcessPayment;
        public boolean sparse;
        public Line[] Line;
        public CustomerRef CustomerRef;
        public String Id;	
        public MetaData MetaData;
    }
    public class DepositToAccountRef {
        public String value;	
    }
    public class Line {
        public Integer Amount;	
        public LineEx LineEx;
        public LinkedTxn[] LinkedTxn;
    }
    public class LineEx {
        public any_x[] any_x;
    }
    public class any_x {
        public String name;	
        public boolean nil;
        public value value;
        public String declaredType;	
        public String scope;	
        public boolean globalScope;
        public boolean typeSubstituted;
    }
    public class value {
        public String Name;	
        public String Value;	
    }
    public class LinkedTxn {
        public String TxnId;	
        public String TxnType;	
    }
    public class CustomerRef {
        public String name;	
        public String value;
    }
    public class MetaData {
        public String CreateTime;	
        public String LastUpdatedTime;	
    }
    public static QuickbooksPayment parse(String json){
        return (QuickbooksPayment) System.JSON.deserialize(json, QuickbooksPayment.class);
    }
}