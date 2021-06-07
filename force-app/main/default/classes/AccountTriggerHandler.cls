public with sharing class AccountTriggerHandler {
  public static void updateAccountRating(
    Map<Id, Account> oldMap,
    Map<Id, Account> newMap
  ) {
    //Retrieve Account Rating Config CMD values
    Map<String, Account_Rating_Config__mdt> mapAccRating = new Map<String, Account_Rating_Config__mdt>();

    //Prepare this map so that later we can easily pick the correct Account Rating based on Type and Industry.
    for (
      Account_Rating_Config__mdt accRating : Account_Rating_Config__mdt.getAll()
        .values()
    ) {
      mapAccRating.put(
        accRating.Account_Type__c + accRating.Account_Industry__c,
        accRating
      );
    }
    //Check if this is an insert or update operation
    Boolean isInsert = oldMap == null;

    if (isInsert) {
      //Since this is insert, no need to check if type and industry have changed
      for (Account acc : newMap.values()) {
        //Check if a key exists in the aforementioned map with a combination of Account Type and Account Industry.
        //If yes, then use that key to retrieve the Rating
        if (mapAccRating.containsKey(acc.Type + acc.Industry)) {
          acc.Rating = mapAccRating.get(acc.Type + acc.Industry)
            .Account_Rating__c;
        }
      }
    } else {
      //Since this is update, we need to check if either the Account Type or Industry changed. If yes, only then re-retrieve the rating from config
      for (Id accountId : newMap.keySet()) {
        Account newAcc = newMap.get(accountId);
        Account oldAcc = oldMap.get(accountId);

        if (newAcc.Type != oldAcc.Type || newAcc.Industry != oldAcc.Industry) {
          if (mapAccRating.containsKey(newAcc.Type + newAcc.Industry)) {
            newAcc.Rating = mapAccRating.get(newAcc.Type + newAcc.Industry)
              .Account_Rating__c;
          }
        }
      }
    }
  }
}
