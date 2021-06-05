public with sharing class OpportunityLineitemTriggerHandler {
  public static void updateTotalSalesQuantityInAccount(
    List<OpportunityLineItem> opptyLineitems
  ) {
    Set<Id> oppsIdSet = new Set<Id>();

    for (OpportunityLineitem oli : opptyLineitems) {
      oppsIdSet.add(oli.OpportunityId);
    }

    //Get OpportunityLineitems for all Accounts involved in transaction Summarized by Account Id
    List<Account> accountsToUpdate = new List<Account>();
    for (AggregateResult objAgr : [
      SELECT Opportunity.AccountId account, SUM(TotalPrice) total
      FROM OpportunityLineitem
      WHERE OpportunityLineitem.OpportunityId IN :oppsIdSet
      GROUP BY Opportunity.AccountId
    ]) {
      //Validate Data

      //Manipulate Data
      system.debug('objAgr: ' + objAgr);
      accountsToUpdate.add(
        new Account(
          Id = (String) objAgr.get('account'),
          AnnualRevenue = (Decimal) objAgr.get('total')
        )
      );
    }
    //Update Data
    system.debug(accountsToUpdate);

    update accountsToUpdate;
  }
}
