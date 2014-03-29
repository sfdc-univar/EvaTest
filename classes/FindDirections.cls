global with sharing class FindDirections {


@RemoteAction
  global static List<Account> getRouteAccounts(String cids) {
   System.debug('***************** cids: ' + cids);
   List<String> parts = cids.split(','); 
   
       // SOQL query to get selected Accounts Locations
       List<Account> getRouteAccounts = [SELECT Id, Name, ShippingCity, ShippingState ,Location__Longitude__s, 
       Location__Latitude__s FROM Account WHERE Id in :parts ];
            
        
        // Run and return the query results
   
        return(getRouteAccounts);
  	
  }
}