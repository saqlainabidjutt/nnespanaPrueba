trigger LeadTrigger on Lead (before insert, before update) {
    Set<String> countryNames = new Set<String>();

    for (Lead lead : Trigger.new) {
        countryNames.add(lead.Country);
    }

    Map<String, Country__c> countryMap = new Map<String, Country__c>();
    for (Country__c country : [SELECT Name, CapitalCity__c, Region__c FROM Country__c WHERE Name IN :countryNames]) {
        countryMap.put(country.Name, country);
    }

    for (Lead lead : Trigger.new) {
        Country__c country = countryMap.get(lead.Country);
        if (country != null) {
            lead.CapitalCity__c= country.CapitalCity__c;
            lead.Region__c= country.Region__c;
        }
    }
}