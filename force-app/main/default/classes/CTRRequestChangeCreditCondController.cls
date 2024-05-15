public with sharing class CTRRequestChangeCreditCondController {
    public class RequestWrapper
    {
        @auraEnabled public Id mRecordId {get; set;}
        @auraEnabled public Integer mIndex {get; set;}
        @auraEnabled public String mSalesOrg {get; set;}
        @auraEnabled public String mCreditCondition {get;set;}
        @auraEnabled public Decimal mCreditLimit {get;set;}
        @auraEnabled public String mCreditRating {get;set;}
        @auraEnabled public String mCreditControlArea {get;set;}
        @auraEnabled public String mLabelSalesOrg {get; set;}
        @auraEnabled public String mLabelCreditControlArea {get;set;}
        @auraEnabled public Boolean mSelected {get; set;}
        @auraEnabled public String mCurrency {get; set;}
    }

    public class ResponseWrapper {
        @AuraEnabled public Boolean result {get; set;}
        @AuraEnabled public String message {get; set;} 
        @AuraEnabled public Id resRecordId {get; set;}
    }

    @AuraEnabled
    public static List<RequestWrapper> onloadCreatePage(Id mAccountId, String mBusinessUnit, Id mRecordTypeSelectedId)
    {
        try 
        {
            List<RequestWrapper> mRequestWrapperList = new List<RequestWrapper>();
            List<RecordType> mRecordTypeList = [SELECT Id, Name, DeveloperName FROM RecordType WHERE Id = :mRecordTypeSelectedId LIMIT 1];
            Integer mIndex = 1;

            if(mRecordTypeList[0].DeveloperName.contains('Customer'))
            {
                Set<String> setSalesOrg = new Set<String>();
                if(mBusinessUnit == 'TOP') {
                    setSalesOrg = new Set<String>{'1100'};
                } else if(mBusinessUnit == 'TPX') {
                    setSalesOrg = new Set<String>{'1300'};
                } else if(mBusinessUnit == 'TLB') {
                    setSalesOrg = new Set<String>{'1400'};
                } else if(mBusinessUnit == 'LABIX') {
                    setSalesOrg = new Set<String>{'1700'};
                } else if(mBusinessUnit == 'TXTH') {
                    setSalesOrg = new Set<String>{'2000'};
                } else if(mBusinessUnit == 'TSV') {
                    setSalesOrg = new Set<String>{'9100'};
                } else if(mBusinessUnit == 'TSR') {
                    setSalesOrg = new Set<String>{'9200'};
                } else if(mBusinessUnit == 'JSKem') {
                    setSalesOrg = new Set<String>{'9300'};
                } else if(mBusinessUnit == 'TXINDIA') {
                    setSalesOrg = new Set<String>{'9400'};
                }

                List<C360_FinancialInfo__c> mFinancialInfoList = new List<C360_FinancialInfo__c>([SELECT CompanyCode__c, toLabel(CompanyCode__c) companyCodeLabel, Credit_Condition__c, CreditLimit__c, InternalCreditRating__c, CreditControlArea__c, toLabel(CreditControlArea__c) creditControlAreaLabel, Currency__c FROM C360_FinancialInfo__c WHERE CompanyName__c = :mAccountId AND CompanyCode__c IN :setSalesOrg]);
                // mSalesAreaList = Database.query(soqlText);
                for(C360_FinancialInfo__c mFinancialInfo: mFinancialInfoList)
                {
                    RequestWrapper mRequestWrapper = new RequestWrapper();
                    mRequestWrapper.mRecordId = mFinancialInfo.Id;
                    mRequestWrapper.mIndex = mIndex;
                    mRequestWrapper.mSalesOrg = mFinancialInfo.CompanyCode__c;
                    mRequestWrapper.mCreditCondition = mFinancialInfo.Credit_Condition__c;
                    mRequestWrapper.mCreditLimit = mFinancialInfo.CreditLimit__c;
                    mRequestWrapper.mCreditRating = mFinancialInfo.InternalCreditRating__c;
                    mRequestWrapper.mCreditControlArea = mFinancialInfo.CreditControlArea__c;
                    mRequestWrapper.mCurrency = mFinancialInfo.Currency__c;
                    mRequestWrapper.mLabelSalesOrg = String.valueOf(mFinancialInfo.get('companyCodeLabel'));
                    mRequestWrapper.mLabelCreditControlArea = String.valueOf(mFinancialInfo.get('creditControlAreaLabel'));
                    mRequestWrapper.mSelected = false;

                    mRequestWrapperList.add(mRequestWrapper);
                    mIndex++;
                }

            }
            else if(mRecordTypeList[0].DeveloperName.contains('Supplier'))
            {
                // supplier
            }
            
            return mRequestWrapperList;
        } 
        catch (Exception e) 
        {
            System.debug('Error From CTRRequestChangeCreditCondController.onloadCreatePage Line: '+e.getLineNumber()+' || Message:'+e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static ResponseWrapper createRequest(String customerId, String businessUnit, String recordTypeId, RequestWrapper mRequestWrapper)
    {
        System.debug(mRequestWrapper);
        ResponseWrapper responseResult = new ResponseWrapper();
        responseResult.result = false;
        try
        {
            List<RecordType> recordTypeList = [SELECT Id, Name, DeveloperName FROM RecordType WHERE Id = :recordTypeId LIMIT 1];
            if(recordTypeList[0].DeveloperName.contains('Customer')){
                List<CTRRequestFormItem__c> mItemList = [SELECT Id, RecordTypeId, RecordType.DeveloperName, DistributionChannel__c, Division__c, SalesOrganization__c, Customer__c,
                                                            ProductName__c, BusinessUnit__c, SalesOrganizationTX__c, SalesOrganizationTOP__c, InterestedProductTypeAsSupplierTX__c, InterestedProductTypeAsSupplierTOP__c, InterestedProductTypeAsCustomerTOP__c,
                                                            InterestedProductTypeAsCustomerTX__c
                                                            FROM CTRRequestFormItem__c 
                                                            WHERE Customer__c = :customerId  
                                                            AND SalesOrganization__c = :mRequestWrapper.mSalesOrg
                                                            AND CreditControlArea__c = :mRequestWrapper.mCreditControlArea];

                Id itemRecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerChangeCrCond').getRecordTypeId();
                List<CTRRequestFormItem__c> checkInprogressItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordTypeId = :itemRecordTypeId AND Customer__c =: customerId AND Status__c NOT IN('Approved','Rejected') AND SalesOrganization__c = :mRequestWrapper.mSalesOrg];

                if(checkInprogressItem.size() > 0) {
                    responseResult.message = 'Cannot create request, found pending request on the current customer';
                    return responseResult;
                }
                CTRRequestFormHeader__c mRequestFormHeader = new CTRRequestFormHeader__c();
                Id headerRecordTypeId = Schema.SObjectType.CTRRequestFormHeader__c.getRecordTypeInfosByDeveloperName().get('ChangeCrCondition').getRecordTypeId();
                mRequestFormHeader.RecordTypeId = headerRecordTypeId;
                mRequestFormHeader.Customer__c = CustomerId;
                insert mRequestFormHeader;

                // List<CTRRequestFormItem__c> itemToInsert = new List<CTRRequestFormItem__c>();
                CTRRequestFormItem__c itemToInsert = new CTRRequestFormItem__c();
                itemToInsert.CTRRequestFormHeader__c = mRequestFormHeader.Id;
                itemToInsert.Customer__c = CustomerId;
                itemToInsert.RecordTypeId = itemRecordTypeId;
                itemToInsert.SalesOrganization__c = mRequestWrapper.mSalesOrg;
                itemToInsert.CreditControlArea__c = mRequestWrapper.mCreditControlArea;
                itemToInsert.CreditOwner__c = UserInfo.getUserId();
                itemToInsert.Status__c = 'In Review';
                itemToInsert.Approval_Step__c = 'Credit Rating';
                itemToInsert.FinancialInformation__c = mRequestWrapper.mRecordId;

                List<String> topSubBU = new List<String>{'TOP','TLB','TPX'};
                List<String> txSubBU = new List<String>{'TXTH','TSV','TSR','JSKem','TXINDIA'};

                if (txSubBU.contains(businessUnit)) {
                    itemToInsert.SalesOrganizationTX__c = mRequestWrapper.mSalesOrg;
                } else if (topSubBU.contains(businessUnit))
                {
                    itemToInsert.SalesOrganizationTOP__c = mRequestWrapper.mSalesOrg;
                }

                if (mItemList.size() > 0)
                {
                    if (txSubBU.contains(businessUnit)) {
                        itemToInsert.InterestedProductTypeAsCustomerTX__c = mItemList[0].InterestedProductTypeAsCustomerTX__c != null ? mItemList[0].InterestedProductTypeAsCustomerTX__c : '';
                    } else if (topSubBU.contains(businessUnit))
                    {
                        itemToInsert.InterestedProductTypeAsCustomerTOP__c = mItemList[0].InterestedProductTypeAsCustomerTOP__c != null ? mItemList[0].InterestedProductTypeAsCustomerTOP__c : '';
                    }

                }

                insert itemToInsert;

                responseResult.result = true;
                responseResult.message = 'Success';
                responseResult.resRecordId = itemToInsert.Id;
            } else if(recordTypeList[0].DeveloperName.contains('Supplier')) 
            {
                
            }
            return responseResult;
        } 
        catch (Exception e) 
        {
            System.debug('Error From CTRRequestChangeCreditCondController.onSave Line: '+e.getLineNumber()+' || Message:'+e.getMessage());
            responseResult.message = 'error:'+ e.getMessage();
            return responseResult;
        }
    }
}