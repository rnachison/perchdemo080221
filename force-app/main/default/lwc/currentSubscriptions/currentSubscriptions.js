import { LightningElement, api, wire } from 'lwc';
import getCurrentSubscriptions from '@salesforce/apex/SubscriptionController.getCurrentSubscriptions';


const COLUMNS = [
    { label: 'Customer', fieldName: 'CustomerName', type: 'text' },
    { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date' },
    { label: 'End Date', fieldName: 'End_Date__c', type: 'date' },
];

export default class CurrentSubscriptions extends LightningElement {
    @api recordId;
    subscriptions;
    error;

    @wire(getCurrentSubscriptions, { sharedSolarSystemId: '$recordId' })
    subscriptionResults(result) {
        if (result.data) {
            this.subscriptions = result.data.map(row=>{
                return{...row, CustomerName: row.Customer__r.Name}
            })
   
        } else if (result.error) {
            this.error = result.error;
        }
   
    }

    columns = COLUMNS;

}