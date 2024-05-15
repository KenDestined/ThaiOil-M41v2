public class CTRDisclaimerPDFController {
        // public static String requestdate {get; set;}
        // public String type {get; set;}
        // public String ver {get; set;}
        // public String name {get; set;}
        // public String via {get; set;}
        // public String grantdate {get; set;}
        // public String consentAccept {get; set;}
        // public String emp {get; set;}
        // //add new
        // public String MCflag {get; set;}
        // public String DAver {get; set;}
        // public String DAvia {get; set;}
        // public String DAgrantdate {get; set;}
        // public String MCver {get; set;}
        // public String MCvia {get; set;}
        // public String PDgrantdate {get; set;}
        // public String PDver {get; set;}
        // public String PDvia {get; set;}
        // public String PDflag {get; set;}
        // public String DAflag {get; set;}
        // public String DAtime {get; set;}
        // public String MCtime {get; set;}
        // public String PDtime {get; set;}
        // public String MCgrantdate {get; set;}
        // public String flag {get; set;}
        // public String MCflagName {get; set;}
        // public String MCflagNameTab {get; set;}
        // public String PDflagName {get; set;}
        // public String PDflagNameTab {get; set;}
        // public String DAflagName {get; set;}
        // public String DAflagNameTab {get; set;}
        // public String Namedataflag {get; set;}
        public String recordId {get; set;}
        public String selectedLanguage {get; set;}
        public String formattedDateTime {get; set;}
        public List<CTRShareholder__c> shareholderList {get; set;}
        public List<CTRShippingCountry__c> spList {get; set;}
        public CTRRequestFormItem__c requestItem {get; set;}
        public Account accountObj {get; set;}
        
        public CTRDisclaimerPDFController() {
                renderPage();
        }
    
        public void renderPage() {
        //    requestdate = string.valueof(Datetime.now().format('dd/MM/YYYY'));
           selectedLanguage = apexpages.currentpage().getparameters().get('selectedLanguage');
           recordId = apexpages.currentpage().getparameters().get('recordId');
           String fileName = 'Disclaimer.pdf';
           Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+fileName);

           Datetime now = Datetime.now();
           formattedDateTime = now.format('dd-MMM-yyyy HH:mm:ss');
           
           if(recordId != null) {
                getInitialData(recordId);
           }
           
        }

        public void getInitialData(String recordId){
                try 
                {
                        System.debug('Record id = '+recordId);
                        requestItem = [SELECT Id, Name, CTRRequestFormHeader__c, Customer__c, InterestedProductTypeAsCustomerTX__c, CustomerProductIdentification__c, InterestedProductTypeAsSupplierTX__c,
                                        SupplierProductIdentification__c
                                        FROM CTRRequestFormItem__c WHERE Id =: recordId];

                        accountObj = [SELECT Id, Name, CompanyNameENF__c, CompanyNameLocal__c, SpecifyLanguagesOfCompanyName__c, FormerNameofCompany__c,
                                        Country__c, fmlCountryCode__c, CustomerType__c, SupplierType__c, TypeOfBusiness__c, TypeOfBusinessOthers__c, LegalEntity__c,
                                        LegalEntityOthers__c, IncoperationDate__c, Yearofexperience__c, TAXNumber__c, CompanyWebsite__c, CEOFirstName__c, CEOLastName__c, ImmidiateParentCompany__c,
                                        BuildingCodeLocal__c, RoomLocal__c, FloorLocal__c, CoName__c, HousenoLocal__c, StreetLocal__c, SubDistrictLocalText__c, DistrictLocalText__c, CityStateLocalText__c,
                                        PostalCodeLocalText__c, LocationInGoogleMapsLinks__c, Location__Latitude__s, Location__Longitude__s, SameRegisteredAddress__c, ContactSalutation__c,
                                        Nickname__c, FirstName__c, LastName__c, Position__c, Email__c, Language__c, MobileCountryCode__c, PhoneCountryCode__c, MobilePhone__c, Phone, FaxCountryCode__c, Fax,
                                        EstimatedMonthlyPurchaseUnit__c, CustomersFacilityTankAndStorage__c, CustomersFacilityTransportation__c, CustomerPurchaseProductFrom__c, SupplierSupplyProductTo__c,
                                        SuppliersFacilityTankAndStorage__c, SuppliersFacilityTransportation__c, MainService__c, OtherMainService__c, MainProduct__c, OtherMainProduct__c, CompanyLatestCreditRating__c,
                                        EnvironmentPolicy__c, SocialResponsibilityPolicy__c, CorporateGovernancePolicy__c, OccupationalHealthAndSafetyPolicy__c, HumanRightsPolicy__c, HasIssuesDuringThePast5Years__c,
                                        PaymentOverTheAmountOfUSD__c, HasFailedSupplyInLast3Years__c, HasSanctionedTarget__c
                                        FROM Account WHERE Id =: requestItem.Customer__c];

                        shareholderList = [SELECT Name,of_Shareholder__c FROM CTRShareholder__c WHERE CTRRequestFormHeader__c =: requestItem.CTRRequestFormHeader__c];
                        System.debug(shareholderList);

                        spList = [SELECT ShippingCountry__c,LocationType__c FROM CTRShippingCountry__c WHERE CTRRequestFormItem__c =: recordId];
                        System.debug(spList);
                }
                catch(Exception e)
                {
                    System.debug('CTRDisclaimerPDFController---'+e.getmessage()+' line:'+e.getLineNumber());
                }
        }
        
        
}