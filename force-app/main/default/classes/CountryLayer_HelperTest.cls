/**
 * @description       : 
 * @author            : M.Saqlain Abid
 * @group             : 
 * @last modified on  : 10-07-2023
 * @last modified by  : M.Saqlain Abid
**/
@isTest
private class CountryLayer_HelperTest {
    @isTest
    static void test_upsertCountries() {
        // Mock the HTTP callout
        Test.setMock(HttpCalloutMock.class, new CountryLayer_HTTPCalloutMock());
        // Start the test context
        Test.startTest();

        // Call the method to test
        Result_Wrapper result = CountryLayer_Helper.upsertCountries();
        // Stop the test context
        Test.stopTest();

        // Verify result
        System.assert(result.success);

        // Verify that new countries are upserted
        List<Country__c> countries = [SELECT Name, Alpha2Code__c, Alpha3Code__c, CapitalCity__c, Region__c FROM Country__c];
        System.assertEquals(2, countries.size());
        System.assertEquals('AF', countries[0].Alpha2Code__c);
        System.assertEquals('FI', countries[1].Alpha2Code__c);
    }
}