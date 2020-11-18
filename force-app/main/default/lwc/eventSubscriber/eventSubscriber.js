import { LightningElement, api} from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class eventSubscriber extends LightningElement {
    channelName = '/event/Account_Change__e';
    subscription = {};
    @api recordId;

    connectedCallback() {    
       
        const messageCallback = (response) => {
            var message = response.data.payload.Message__c;
            var eventRecordId = response.data.payload.Record_Id__c;

            if(eventRecordId == this.recordId){
                this.showToast(message);
            }
        };

        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
        });   
        this.registerErrorListener(); 
    }

    registerErrorListener() {
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
        });
    }

    showToast(eventMessage) {
        const event = new ShowToastEvent({
            title: 'Account Successfully Changed!',
            message: eventMessage,
        });
        this.dispatchEvent(event);
    }

    disconnectedCallback() {
        unsubscribe(this.subscription, response => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
        });
    }
}