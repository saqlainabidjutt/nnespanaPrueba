/**
 * @description       : 
 * @author            : M.Saqlain Abid
 * @group             : 
 * @last modified on  : 10-07-2023
 * @last modified by  : M.Saqlain Abid
**/
public with sharing class Result_Wrapper {
    @AuraEnabled public boolean success;
    @AuraEnabled public String msg;
    @AuraEnabled public String jsonResult;

    
    public Result_Wrapper(boolean isSuccess, String msg, String jsonResult) {
        this.success = isSuccess;
        this.msg = msg;
        this.jsonResult = jsonResult;
    }
}