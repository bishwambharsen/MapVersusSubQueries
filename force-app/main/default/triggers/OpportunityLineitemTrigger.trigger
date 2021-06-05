trigger OpportunityLineitemTrigger on OpportunityLineItem(after insert) {
  switch on Trigger.OperationType {
    when AFTER_INSERT {
      OpportunityLineitemTriggerHandler.updateTotalSalesQuantityInAccount(
        Trigger.new
      );
    }
  }
}
