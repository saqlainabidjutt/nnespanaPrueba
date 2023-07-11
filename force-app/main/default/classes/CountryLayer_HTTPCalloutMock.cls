@isTest
global class CountryLayer_HTTPCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('[{"name":"Afghanistan","topLevelDomain":[".af"],"alpha2Code":"AF","alpha3Code":"AFG","callingCodes":["93"],"capital":"Kabul","altSpellings":["AF","Afghanistan"],"region":"Asia"},{"name":"Finland","topLevelDomain":[".fi"],"alpha2Code":"FI","alpha3Code":"FIN","callingCodes":["358"],"capital":"Helsinki","altSpellings":["FI","Finland"],"region":"Europe"}]');
        return res;
    }
}
