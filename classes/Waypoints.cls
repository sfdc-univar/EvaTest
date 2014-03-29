global with sharing class Waypoints {


    public String start{
    get{
        if(start == null){
    //get start querystring param
    start = ApexPages.currentPage().getParameters().get('start');
    }
    return start;
    }
    set;
    }
    // Allow the user to check off which accounts to use for routing
    public String nextUrl{
        get{
            if(nextUrl==null) {
                nextUrl='';
            }
            return nextUrl;
        }
        set;
    }
    
    public List<AccountWrapper> results {get;set;}
      
    public void findAccounts() {
        results = new List<AccountWrapper>();

        List<Account>accounts = (List<Account>)[SELECT id,RecordTypeId, ShipToNumber__c ,Name,
        ShippingStreet,ShippingCity,CustomerNumber__c,SalesRepName__c,ShippingState,
        BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity,ShippingPostalCode, 
        ShippingCountry, Owner.Name, ShipToName__c, CustomerStatus__c, Location__Longitude__s, Location__Latitude__s 
        FROM Account WHERE Owner.Name =: Userinfo.getName() AND ShippingCity <> '' ORDER BY DISTANCE(Location__c, GEOLOCATION(37.775,-122.418), 'mi')];
        
        for(Account a : accounts) {
            AccountWrapper accountWrapper = new AccountWrapper(a);
            results.add(accountWrapper);
        }
        System.debug('************* Results: ' + results.size());
    }   
   
    public void next() {
        List<Id> accountIdsForUrl = new List<Id>();

        for(AccountWrapper aw : results) {
            if(aw.isChecked) {
                accountIdsForUrl.add(aw.account.Id);
            }
        }
        
        if(accountIdsForUrl.size()<2) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Select_More_Accounts));
            return; 
        }
        
        nextUrl = Url.getSalesforceBaseUrl().toExternalForm();
        nextUrl += createNextUrl(accountIdsForUrl);
         
  }
   
    public PageReference cancel() {
        return new PageReference('/001/o');  
    } 

    private String createNextUrl(List<Id> accountIds) {
        String url = '/apex/FindDirections?';
        for(Id id : accountIds) {
            url+='&cid='+id; 
        }
        return url;
    }
    
    //wrapper class for shown accounts
    public class AccountWrapper {
        public Boolean isChecked{get;set;}
        public Account account{get; private set;}
        
        public AccountWrapper(Account account) {
            this.account = account;
            isChecked = false;
        }
    }   
}