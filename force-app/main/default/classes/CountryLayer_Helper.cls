/**
 * @description       : 
 * @author            : M.Saqlain Abid
 * @group             : 
 * @last modified on  : 10-07-2023
 * @last modified by  : M.Saqlain Abid
**/
public with sharing class CountryLayer_Helper {
    public static Result_Wrapper upsertCountries() {
        Result_Wrapper resultWrapper;
        List<Country__c> countryList = new List<Country__c>();
        try {
            // Get custom metadata type record
            Countries_API__mdt countriesMetadataRecord = [SELECT  access_key__c,EndPoint_Dev__c,EndPoint_Prod__c,HTTP_Method__c
            FROM Countries_API__mdt 
            WHERE DeveloperName = 'countrylayer' LIMIT 1];

            if (countriesMetadataRecord == null && !Test.isRunningTest()) {
                return new Result_Wrapper(false, 'No configuration found for countrylayer integration.', null);
            }
            HttpRequest req = createDefaultHttpRequest(countriesMetadataRecord);
            Http http = new Http();
            System.debug('req: ' + req);
            HttpResponse response = http.send(req);
            System.debug('getStatusCode: ' + response.getStatusCode());
            System.debug('getBody: ' + response.getBody());
            if (response.getStatusCode() == 200) {//response.getStatusCode() == 200
                //response.getBody()
                //String responseBody='[{"name":"Afghanistan","topLevelDomain":[".af"],"alpha2Code":"AF","alpha3Code":"AFG","callingCodes":["93"],"capital":"Kabull","altSpellings":["AF","Af\u0121\u0101nist\u0101n"],"region":"Asia"},{"name":"\u00c5land Islands","topLevelDomain":[".ax"],"alpha2Code":"AX","alpha3Code":"ALA","callingCodes":["358"],"capital":"Mariehamn","altSpellings":["AX","Aaland","Aland","Ahvenanmaa"],"region":"Europe"}]';
                String responseBody=response.getBody();
                List<Object> apiResponse = (List<Object>) JSON.deserializeUntyped(responseBody);
    
                // Gather all alpha2Code and alpha3Code values
                Set<String> alpha2Codes = new Set<String>();
                Set<String> alpha3Codes = new Set<String>();
                for (Object obj : apiResponse) {
                    Map<String, Object> countryMap = (Map<String, Object>) obj;
                    alpha2Codes.add((String) countryMap.get('alpha2Code'));
                    alpha3Codes.add((String) countryMap.get('alpha3Code'));
                }
                // Query all existing countries at once
                List<Country__c> existingCountries = [SELECT Id, Name, Alpha2Code__c, Alpha3Code__c, CapitalCity__c, Region__c
                                                     FROM Country__c
                                                     WHERE Alpha2Code__c IN :alpha2Codes OR Alpha3Code__c IN :alpha3Codes];
            
                // Create a map for easy lookup of existing countries
                Map<String, Country__c> existingCountriesMap = new Map<String, Country__c>();
                for (Country__c country : existingCountries) {
                    existingCountriesMap.put(country.Alpha2Code__c, country);
                    existingCountriesMap.put(country.Alpha3Code__c, country);
                }
            
                // Loop through API response again to upsert records
                for (Object obj : apiResponse) {
                    Map<String, Object> countryMap = (Map<String, Object>) obj;
                    String alpha2Code = (String) countryMap.get('alpha2Code');
                    String alpha3Code = (String) countryMap.get('alpha3Code');
                    String capitalCity = (String) countryMap.get('capital');
                    String name = (String) countryMap.get('name');
                    String region = (String) countryMap.get('region');
            
                    // Check if country exists using the map
                    Country__c existingCountry = existingCountriesMap.get(alpha2Code) != null ? 
                                                 existingCountriesMap.get(alpha2Code) : 
                                                 existingCountriesMap.get(alpha3Code);
            
                    if (existingCountry != null) {
                        // Update existing record
                        existingCountry.Name = name;
                        existingCountry.Alpha2Code__c = alpha2Code;
                        existingCountry.Alpha3Code__c = alpha3Code;
                        existingCountry.CapitalCity__c = capitalCity;
                        existingCountry.Region__c = region;
                        countryList.add(existingCountry);
                    } else {
                        // Create new record
                        Country__c newCountry = new Country__c(
                            Name = name,
                            Alpha2Code__c = alpha2Code,
                            Alpha3Code__c = alpha3Code,
                            CapitalCity__c = capitalCity,
                            Region__c = region
                        );
                        countryList.add(newCountry);
                    }
                }
            
                // Perform DML operation to update or insert records
                if (!countryList.isEmpty()) {
                    upsert countryList;
                }    
                resultWrapper = new Result_Wrapper(true,'', null);        
            } else {
                System.debug('API request failed with status code: ' + response.getStatusCode());
                System.debug('Response body: ' + response.getBody());
                return new Result_Wrapper(false, 'API request failed with', response.getBody());
            }
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            resultWrapper = new Result_Wrapper(false, 'Error:'+ex.getMessage(), null);
        }

        return resultWrapper;
    }

    private static HttpRequest createDefaultHttpRequest(Countries_API__mdt countriesMetadataRecord) {
        HttpRequest req = new HttpRequest();
        String endpoint = (countriesMetadataRecord.EndPoint_Prod__c != null) ? countriesMetadataRecord.EndPoint_Prod__c : countriesMetadataRecord.EndPoint_Dev__c;
        req.setEndpoint(endpoint+'?access_key='+countriesMetadataRecord.access_key__c);
        req.setMethod(countriesMetadataRecord.HTTP_Method__c);
        req.setHeader('Content-Type', 'application/json');
        return req;
    }
}