trigger AccountTrigger on Account(
  before insert,
  after insert,
  before update,
  after update
) {
  switch on Trigger.OperationType {
    when BEFORE_INSERT {
      AccountTriggerHandler.updateAccountRating(Trigger.oldMap, Trigger.newMap);
    }
    when AFTER_INSERT {
    }
    when BEFORE_UPDATE {
      AccountTriggerHandler.updateAccountRating(Trigger.oldMap, Trigger.newMap);
    }
    when AFTER_UPDATE {
    }
    when else {
    }
  }
}
