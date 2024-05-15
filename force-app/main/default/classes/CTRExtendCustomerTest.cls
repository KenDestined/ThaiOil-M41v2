@isTest
public with sharing class CTRExtendCustomerTest {
    
    @isTest
    public static void testSaveRequest(){
        Account customer = new Account(
            Name='test',
            AccountNumber__c='510001'
        );
        insert customer;

        CTRRequestFormHeader__c requestHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            Customer__c = customer.Id
        );
        insert requestHeader;

        CTRRequestFormItem__c requestItem = new CTRRequestFormItem__c(
            CustomerSubject__c = '',
            CustomerMessage__c = '',
            CustomerEmailTo__c = 'testuser@test.com',
            CustomerEmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = requestHeader.Id,
            Customer__c = customer.Id
        );
        insert requestItem;

        CTRExtendCustomer.saveRequest(requestHeader, requestItem, new List<CTRShippingCountry__c>(), 'TOP', false);
        CTRExtendCustomer.saveRequest(requestHeader, requestItem, new List<CTRShippingCountry__c>(), 'TOP', true);
        CTRExtendCustomer.saveRequest(requestHeader, requestItem, new List<CTRShippingCountry__c>(), 'TX', true);
        CTRExtendCustomer.saveRequest(requestHeader, requestItem, new List<CTRShippingCountry__c>(), 'TX', false);
    }

    @isTest
    public static void testSaveRequest2(){
        Account customer = new Account(
            Name='test',
            SupplierNumber__c='510001'
        );
        insert customer;

        CTRRequestFormHeader__c requestHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            Customer__c = customer.Id
        );
        insert requestHeader;

        CTRRequestFormItem__c requestItem = new CTRRequestFormItem__c(
            CustomerSubject__c = '',
            CustomerMessage__c = '',
            CustomerEmailTo__c = 'testuser@test.com',
            CustomerEmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = requestHeader.Id,
            Customer__c = customer.Id
        );
        insert requestItem;

        CTRExtendCustomer.saveRequest(requestHeader, requestItem, new List<CTRShippingCountry__c>(), 'TOP', true);
        CTRExtendCustomer.saveRequest(requestHeader, requestItem, new List<CTRShippingCountry__c>(), 'TOP', false);
        CTRExtendCustomer.saveRequest(requestHeader, requestItem, new List<CTRShippingCountry__c>(), 'TX', true);
        CTRExtendCustomer.saveRequest(requestHeader, requestItem, new List<CTRShippingCountry__c>(), 'TX', false);
    }
    
    @isTest
    public static void testSaveRequest3(){
        Account customer = new Account(
            Name='test',
            SupplierNumber__c = '510001'
        );
        insert customer;

        CTRPurchasingView__c  purchasingView = new CTRPurchasingView__c (
            BlockStatus__c = 'FALSE',
            PurchasingDocDate__c = Date.today().addYears(-2).addDays(-100),
            Account__c = customer.Id,
            PurchasingOrg__c = 'A000',
            Key__c = '5100011100'
        );
        insert purchasingView;

        CTRRequestFormHeader__c requestHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            Customer__c = customer.Id
        );
        insert requestHeader;

        CTRRequestFormHeader__c requestHeader2 = new CTRRequestFormHeader__c(
            Status__c = 'New',
            Customer__c = customer.Id
        );

        RecordType recordType = [SELECT Id FROM RecordType WHERE Name = 'New Supplier'];
        CTRRequestFormItem__c requestItem = new CTRRequestFormItem__c(
            CustomerSubject__c = '',
            CustomerMessage__c = '',
            CustomerEmailTo__c = 'testuser@test.com',
            CustomerEmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = requestHeader.Id,
            Customer__c = customer.Id,
            PurchasingOrganization__c = '1100',
            RecordTypeId = recordType.Id
        );
        insert requestItem;

        String bu = 'TOP';
        CTRExtendCustomer.saveRequest(requestHeader2, requestItem, new List<CTRShippingCountry__c>(), bu, false);
        CTRExtendCustomer.saveRequest(requestHeader2, requestItem, new List<CTRShippingCountry__c>(), bu, true);
    }
    

    @isTest
    public static void testRetrieveSalesOrgMapping(){
        String results = CTRExtendCustomer.retrieveSalesOrgMapping('', 'TX');
    }

    @isTest
    public static void testRetrieveDistributionChannel(){
        List<Map<String, String>> results = CTRExtendCustomer.retrieveDistributionChannel('Petroleum Products', '1100','TX');
    }

    @isTest
    public static void testRetrievePaymentMethodMapping(){
        List<Map<String, String>> results = CTRExtendCustomer.retrievePaymentMethodMapping('9100');
    }
}