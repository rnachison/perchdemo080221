trigger SubscriptionTrigger on Subscription__c (before insert, before update) {

    SubscriptionTriggerHandler subscriptionTriggerHandler = new SubscriptionTriggerHandler(Trigger.new);

    if (Trigger.isInsert && Trigger.isBefore) {
        subscriptionTriggerHandler.beforeInsert();
    }

    if (Trigger.isUpdate && Trigger.isBefore) {
        subscriptionTriggerHandler.beforeUpdate();
    }

}