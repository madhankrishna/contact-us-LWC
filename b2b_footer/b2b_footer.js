import { LightningElement,api } from 'lwc';
import uId from '@salesforce/user/Id';
import isguest from '@salesforce/user/isGuest';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


import CreateLeadOrCase from '@salesforce/apex/B2B_ContacUsController.CreateLeadorCases';


export default class B2b_footer extends LightningElement {
    _effectiveAccountId;
    @api
    get effectiveAccountId() {
        return this._effectiveAccountId;
    }
    showSpinner = false;

    isModalOpen = false;
    isloginUser = isguest;
    fName;
    lName;
    username;
    company;
    email;
    phone;
    comment;
    title = 'Sample Title';
    message = 'Sample Message';
    variant = 'success';

    

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    submitDetails(){
        console.log('init');
        const isInputsCorrectInput = [...this.template.querySelectorAll('lightning-input')]
        .reduce((validSoFar, inputField) => {
            console.log('called');
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);

        if(isInputsCorrectInput){
            console.log('if called');
            if(isguest){
                console.log('a guest user');
               // console.log(this.template.querySelector("[data-field='FirstName']"));
                this.fName = this.template.querySelector("[data-field='FirstName']").value;
                this.lName = this.template.querySelector("[data-field='LastName']").value;
                this.company = this.template.querySelector("[data-field='Company']").value;
                this.email = this.template.querySelector("[data-field='Email']").value;
                //this.phone = this.template.querySelector("[data-field='Phone']").value;
            } 
            this.comment= this.template.querySelector("[data-field='Comment']").value;
            console.log(this.fName,this.lName,this.company,this.email,this.phone,this.comment);
            console.log('completed');

            this.showSpinner = true;
            CreateLeadOrCase({isGuestuser : this.isloginUser,description : this.comment,firstName : this.fName,lastName : this.lName,email : this.email,AccountName : this.company})
            .then((result)=>{
                console.log('method call');
                console.log(result);
                const evt = new ShowToastEvent({
                    title: this._title,
                    message: this.message,
                    variant: this.variant,
                });
                this.dispatchEvent(evt);
                this.closeModal();
                this.showSpinner = false;
            })
            .catch((e)=>{
                this.showSpinner = false;
                console.log(e);
            })
           
        }
    }
    connectedCallback(){
        console.log('userid>>>' + this._effectiveAccountId);
        console.log(JSON.stringify(this._effectiveAccountId))
        console.log('effectiveAccountId--->'+this.effectAccountId);


    }
}