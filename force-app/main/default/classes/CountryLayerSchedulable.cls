/**
 * @description       : 
 * @author            : M.Saqlain Abid
 * @group             : 
 * @last modified on  : 10-07-2023
 * @last modified by  : M.Saqlain Abid
**/
public with sharing class CountryLayerSchedulable implements Schedulable,Database.AllowsCallouts  {
    
    public void execute(SchedulableContext context) {
        CountryLayer_Helper.upsertCountries();
    }
}
