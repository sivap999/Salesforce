/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 12-31-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   12-31-2020   Amit Singh   Initial Version
**/
public class EinsteinOCRResponse {
    public String task;	
    public Probabilities[] probabilities;
    public class Probabilities {
        public Double probability;
        public String label;	
        public BoundingBox boundingBox;
    }
    public class BoundingBox {
        public Integer minX;	
        public Integer minY;	
        public Integer maxX;	
        public Integer maxY;	
    }
}