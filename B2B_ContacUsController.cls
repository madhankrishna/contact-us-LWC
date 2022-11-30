public without sharing class B2B_ContacUsController {
    public B2B_ContacUsController() {

    }
    // 

    @AuraEnabled
    public static Map<String,Object> CreateLeadorCases(boolean isGuestuser,String description,String firstName, String lastName,String email,string AccountName){
        Map<String,Object> resp = new Map<String,Object>();

        
        system.debug('contact controller called');
        try {
           
            if(isGuestuser){
                AssignmentRule AR = new AssignmentRule();
                AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.assignmentRuleId= AR.Id;
    
                Lead createLead = new Lead();
                createLead.FirstName = firstName;
                createLead.LastName = lastName;
                createLead.Company = AccountName;
                createLead.Description = description;
                createLead.Email = email; 
                createLead.Type__c = 'B2BStore';
                createLead.setOptions(dmo);
                insert createLead;
                resp.put('Lead', createLead);
                return resp;
            }
            else{
                AssignmentRule AR = new AssignmentRule();
                AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.Id;
                
                String userId = UserInfo.getUserId();
                String contactId = [SELECT ContactId FROM User WHERE Id = :userId].ContactId;
                String AccountId = [SELECT AccountId FROM Contact WHERE Id = :contactId].AccountId; 
                Case createCase = new Case();
                createCase.AccountId = AccountId;
                createCase.ContactId = contactId;
                createCase.Status = 'New';
                createCase.Origin = 'Web';
                createCase.Description = description;
                createCase.setOptions(dmlOpts);
                insert createCase;
                resp.put('caseObj', createCase);
                return resp;
            }     
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }
}