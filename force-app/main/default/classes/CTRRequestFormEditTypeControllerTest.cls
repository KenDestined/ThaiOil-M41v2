@isTest
public with sharing class CTRRequestFormEditTypeControllerTest {
    
    @isTest
    public static void testOnloadCreatePage(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.AccountNumber__c = '12345';
        insert acc;

        Account acc2 = new Account();
        acc2.Name = 'test2';
        acc2.AccountNumber__c = '123456';
        insert acc2;

        C360_SalesArea__c  isa =  new C360_SalesArea__c();
        isa.AccountNumber__c = acc.id;
        isa.SalesOrganization__c = '1100';
        isa.Key__c = 'test11001000';
        insert isa;

        C360_SalesArea__c  isa2 =  new C360_SalesArea__c();
        isa2.AccountNumber__c = acc2.id;
        isa2.SalesOrganization__c = '1100';
        isa2.Key__c = 'test11001000';
        insert isa2;

        
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser1 = new User(
            FirstName = 'Test',
            LastName = 'User 1',
            Email = 'testuser1@example.test',
            Username = 'testuser1@example.test',
            ProfileId = testProfile.Id,
            Alias = 'tuser1',
            CommunityNickname = 'testuser1',
            TimeZoneSidKey = 'Asia/Bangkok',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser1;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name = 'Test Header';
        insert reqHeader;
        
        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerExtend' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        reqItem.Name = 'TestConditionTrue Item';
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.RecordTypeId = rt.Id;
        reqItem.EmailTo__c = 'testemailto@test.com';
        reqItem.EmailCC__c = 'testemailcc@test.com';
        reqItem.CommitteeOwner__c = testUser1.Id;
        reqItem.Customer__c = acc.Id;
        reqItem.SalesOrganization__c = '1100';
        reqItem.SAPNumber__c = 'test';
        reqItem.DistributionChannel__c = '10';
        reqItem.Division__c = '00';
        insert reqItem;
        

        CTRPurchasingView__c purchasingView = new CTRPurchasingView__c (
            BlockStatus__c = 'FALSE',
            PurchasingDocDate__c = Date.today().addYears(-2).addDays(-100),
            Account__c = acc2.Id,
            PurchasingOrg__c = '1100'
        );
        insert purchasingView;
        
        Id customerRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'TxCustomer' LIMIT 1].Id;
        Id editRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'SupplierEditInfo' LIMIT 1].Id;

        List<CTRRequestFormEditTypeController.RequestWrapper> results = CTRRequestFormEditTypeController.onloadCreatePage(acc.Id,customerRecordTypeId,'TOP');
        List<CTRRequestFormEditTypeController.RequestWrapper> results2 = CTRRequestFormEditTypeController.onloadCreatePage(acc2.Id,editRecordTypeId,'TOP');
    }

    @isTest
    public static void testOnloadCreatePage2(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.AccountNumber__c = '12345';
        insert acc;

        C360_SalesArea__c  isa =  new C360_SalesArea__c();
        isa.AccountNumber__c = acc.id;
        isa.SalesOrganization__c = '1100';
        isa.Key__c = 'test1100';
        insert isa;

        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser1 = new User(
            FirstName = 'Test',
            LastName = 'User 1',
            Email = 'testuser1@example.test',
            Username = 'testuser1@example.test',
            ProfileId = testProfile.Id,
            Alias = 'tuser1',
            CommunityNickname = 'testuser1',
            TimeZoneSidKey = 'Asia/Bangkok',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser1;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name = 'Test Header';
        insert reqHeader;
        
        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'SupplierExtend' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        reqItem.Name = 'TestConditionTrue Item';
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.RecordTypeId = rt.Id;
        reqItem.EmailTo__c = 'testemailto@test.com';
        reqItem.EmailCC__c = 'testemailcc@test.com';
        reqItem.CommitteeOwner__c = testUser1.Id;
        reqItem.Customer__c = acc.Id;
        reqItem.SalesOrganization__c = '1100';
        reqItem.SAPNumber__c = 'test';
        reqItem.DistributionChannel__c = '10';
        reqItem.Division__c = '00';
        insert reqItem;
        

        CTRPurchasingView__c purchasingView = new CTRPurchasingView__c (
            BlockStatus__c = 'FALSE',
            PurchasingDocDate__c = Date.today().addYears(-2).addDays(-100),
            Account__c = acc.Id,
            PurchasingOrg__c = '1100'
        );
        insert purchasingView;
        
        Id editRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'SupplierExtend' LIMIT 1].Id;

        List<CTRRequestFormEditTypeController.RequestWrapper> results = CTRRequestFormEditTypeController.onloadCreatePage(acc.Id,editRecordTypeId,'TOP');
    }

}