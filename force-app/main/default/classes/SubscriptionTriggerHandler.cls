public with sharing class SubscriptionTriggerHandler {

    List<Subscription__c> newSubscriptions;

    public SubscriptionTriggerHandler(List<Subscription__c> newSubscriptions) {
        this.newSubscriptions = newSubscriptions;
    }

    public class SubscriptionException extends Exception {}

    public void beforeInsert() {
        this.validateSubscriptionDates();
    }

    public void beforeUpdate() {
        this.validateSubscriptionDates();
    }

    private void validateSubscriptionDates() {
        Set<Id> customerIds = new Set<Id>();
        for (Subscription__c subscription : this.newSubscriptions) {
            customerIds.add(subscription.Customer__c);
        }
        Map<Id,Customer__c> relatedCustomers = new Map<Id,Customer__c>([SELECT Id, 
                                                (SELECT Id, Customer__c, Shared_Solar_System__c, Start_Date__c, End_Date__c 
                                                FROM Subscriptions__r)
                                            FROM Customer__c
                                            WHERE Id IN :customerIds]);

        for(Subscription__c subscription : this.newSubscriptions) {
            if (relatedCustomers.get(subscription.Customer__c) == null || relatedCustomers.get(subscription.Customer__c).Subscriptions__r == null) {
                continue;
            }
            for (Subscription__c existingSubscription : relatedCustomers.get(subscription.Customer__c).Subscriptions__r) {
                if (subscription.Shared_Solar_System__c == existingSubscription.Shared_Solar_System__c) {
                    checkDatesForOverlap(subscription, existingSubscription);
                }
            }
        }
    }

    private void checkDatesForOverlap(Subscription__c newSubscription, Subscription__c existingSubscription) {
        Boolean startsBeforeEnd = existingSubscription.End_Date__c != null ? newSubscription.Start_Date__c <= existingSubscription.End_Date__c : true;
        Boolean endsAfterStarts = newSubscription.End_Date__c != null ? newSubscription.End_Date__c >= existingSubscription.Start_Date__c : true;
        if (startsBeforeEnd && endsAfterStarts) {
            throw new SubscriptionException('Subscription Dates cannot overlap for the same customer and shared solar system.');
        }
    }
}
