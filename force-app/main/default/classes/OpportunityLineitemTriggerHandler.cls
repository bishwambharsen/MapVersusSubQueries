public with sharing class OpportunityLineitemTriggerHandler {
  public static void updateTotalSalesQuantityInAccount(
    List<OpportunityLineItem> opptyLineitems
  ) {
    Map<Id, List<OpportunityLineItem>> mapOpptyOLI = new Map<Id, List<OpportunityLineItem>>();

    for (OpportunityLineItem oli : opptyLineitems) {
      if (mapOpptyOLI.containsKey(oli.OpportunityId)) {
        mapOpptyOLI.get(oli.OpportunityId).add(oli);
      } else {
        mapOpptyOLI.put(
          oli.OpportunityId,
          new List<OpportunityLineItem>{ oli }
        );
      }
    }

    Set<Id> accountIds = new Set<Id>();

    for (Opportunity op : [
      SELECT AccountId
      FROM Opportunity
      WHERE Id IN :mapOpptyOLI.keySet()
    ]) {
      accountIds.add(op.AccountId);
    }

    List<Account> accountsToBeUpdated = new List<Account>();

    for (Account acc : [
      SELECT
        Total_Sales_Quantity__c,
        (SELECT Id FROM Opportunities WHERE Id IN :mapOpptyOLI.keySet())
      FROM Account
      WHERE Id IN :accountIds
    ]) {
      Decimal temp = acc.Total_Sales_Quantity__c;
      for (Opportunity op : acc.Opportunities) {
        for (OpportunityLineItem oli : mapOpptyOLI.get(op.Id)) {
          temp += oli.TotalPrice;
        }
      }
      accountsToBeUpdated.add(
        new Account(Id = acc.Id, Total_Sales_Quantity__c = temp)
      );
    }

    if (
      !accountsToBeUpdated.isEmpty() &&
      Schema.SObjectType.Account.IsUpdateable()
    ) {
      update accountsToBeUpdated;
    }
  }
}
