@isTest
public class Result_WrapperTest {
    @isTest static void testResultWrapper() {
        // Test data
        boolean success = true;
        String msg = 'Test Message';
        String jsonResult = '{"key": "value"}';

        // Instantiate Result_Wrapper object
        Result_Wrapper rw = new Result_Wrapper(success, msg, jsonResult);

        // Assert instance variable values
        System.assertEquals(success, rw.success, 'Success field not set correctly');
        System.assertEquals(msg, rw.msg, 'Message field not set correctly');
        System.assertEquals(jsonResult, rw.jsonResult, 'JsonResult field not set correctly');
    }
}
