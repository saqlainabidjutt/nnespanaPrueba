/**
 * @description       : 
 * @author            : M.Saqlain Abid
 * @group             : 
 * @last modified on  : 11-07-2023
 * @last modified by  : M.Saqlain Abid
**/
@isTest
public class CountryLayerSchedulableTest {
    
    @isTest static void testExecute() {
        // You can add data setup here as per your testing requirement.

        Test.StartTest();
        
        // Instantiate the Schedulable instance
        CountryLayerSchedulable cls = new CountryLayerSchedulable();
        
        // Call the System.schedule method to indirectly test your execute method
        String jobName = 'TestJob' + DateTime.now().getTime();
        String cronExp = '0 0 0 15 3 ? 2122'; // The exact expression doesn't matter as it won't actually run
        System.schedule(jobName, cronExp, cls);
        
        Test.StopTest();

        // After StopTest, all asynchronous methods queued within StartTest and StopTest execute.
        // You can perform assertion(s) to verify that the class behaves as expected.
        // Depends on the exact logic of CountryLayer_Helper.upsertCountries();
    }
}
