/**
* @description       : It create Lead or case based in user type  
* @author            : Madhan
* @group             :
* @last modified on  : 9.Dec.2022
* @last modified by  : Madhan
**/
public without sharing class B2B_ContacUsController {

    public static final String LEAD = 'Lead';
    public static final String CASE_OBJ = 'caseObj';

    @AuraEnabled
    public static Map<String,Object> CreateLeadorCases(boolean isGuestUser,String description,
                                                        String firstName, String lastName,String email,string AccountName){
    
        Map<String,Object> respMap = new Map<String,Object>();
        AssignmentRule aR = new AssignmentRule();
        try {
            if(isGuestUser){
                aR = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Lead' and Active = true limit 1];
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.assignmentRuleId= aR.Id;
    
                Lead createLead = new Lead();
                createLead.FirstName = firstName;
                createLead.LastName = lastName;
                createLead.Company = AccountName;
                createLead.Description = description;
                createLead.Email = email; 
                createLead.Type__c = 'B2BStore';
                createLead.setOptions(dmo);
                insert createLead;
                respMap.put(LEAD, createLead);
            }
            else{
                aR = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Case' and Active = true limit 1];

                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.assignmentRuleId= aR.Id;
                
                String userId = UserInfo.getUserId();
                User userObj = [SELECT ContactId, AccountId FROM User WHERE Id = : userId LIMIT 1];

                Case createCase = new Case();
                createCase.AccountId = userObj.AccountId;
                createCase.ContactId = userObj.ContactId;
                createCase.Status = 'New';
                createCase.Origin = 'Web';
                createCase.Description = description;
                createCase.setOptions(dmlOpts);
                insert createCase;
                respMap.put(CASE_OBJ, createCase);
            }  
            return respMap;   
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
