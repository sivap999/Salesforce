public class LinkedInPost {
    public content content;
    public distribution distribution;
    public String owner;	
    public String subject;	
    public text text;
    public class content {
        public contentEntities[] contentEntities;
        public String title;	
    }
    public class contentEntities {
        public String entityLocation;	
        public thumbnails[] thumbnails;
    }
    public class thumbnails {
        public String resolvedUrl;	
    }
    public class distribution {
        public linkedInDistributionTarget linkedInDistributionTarget;
    }
    public class linkedInDistributionTarget {
    }
    public class text {
        public String text;	
    }
}