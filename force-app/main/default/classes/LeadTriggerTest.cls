@isTest
public class LeadTriggerTest {
    @isTest static void testLeadTrigger() {
        // Create a test country
        Country__c testCountry = new Country__c(Name='Test Country', CapitalCity__c='Test City', Region__c='Test Region');
        insert testCountry;

        // Create a test lead
        Lead testLead = new Lead(LastName='Test Lead', Company='Test Company', Country='Test Country');
        insert testLead;

        // Check that the trigger correctly updated the lead
        testLead = [SELECT Id, CapitalCity__c, Region__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Test City', testLead.CapitalCity__c, 'Lead country city did not update correctly');
        System.assertEquals('Test Region', testLead.Region__c, 'Lead country region did not update correctly');

        // Update lead country and check if the trigger correctly updated the lead
        testLead.Country = 'Updated Country';
        update testLead;
    }
}