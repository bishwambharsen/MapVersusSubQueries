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

    for (Account acc : newMap.values()) {
      //Check if it is either an insert operation
      //or if the type or industry has changed in case of an update operation
      if (
        isInsert ||
        (acc.Type != oldMap.get(acc.Id).Type ||
        acc.Industry != oldMap.get(acc.Id).Industry)
      ) {
        //Check if a key exists in the aforementioned map with a combination of Account Type and Account Industry.
        //If yes, then use that key to retrieve the Rating
        if (mapAccRating.containsKey(acc.Type + acc.Industry)) {
          acc.Rating = mapAccRating.get(acc.Type + acc.Industry)
            .Account_Rating__c;
        }
      }
    }
  }
}
