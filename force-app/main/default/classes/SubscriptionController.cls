public with sharing class SubscriptionController {
    
    @AuraEnabled(cacheable=true)
    public static List<Subscription__c> getCurrentSubscriptions(Id sharedSolarSystemId) {
        try {
            return [SELECT Id, Name, Customer__r.Name, Start_Date__c, End_Date__c
                    FROM Subscription__c
                    WHERE Shared_Solar_System__c = :sharedSolarSystemId
                    AND (End_Date__c = null OR End_Date__c >= TODAY)
                    ORDER BY End_Date__c DESC Nulls FIRST];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
