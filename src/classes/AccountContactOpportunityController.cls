public with sharing class AccountContactOpportunityController {
  @AuraEnabled(Cacheable=true)
  public static List<Account> getAccountRecord() {
    try {
      List<Account> accList = new List<Account>();
      Account acc = [
        SELECT Id, Name, Phone
        FROM Account
        ORDER BY CreatedDate DESC
        LIMIT 1
      ];
      accList.add(acc);
      return accList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(Cacheable=true)
  public static List<Contact> getContacts() {
    try {
      List<Account> accList = getAccountRecord();
      return [
        SELECT Id, Name, Email
        FROM Contact
        WHERE AccountId = :accList[0].Id
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(Cacheable=true)
  public static List<Opportunity> getOpportunities() {
    try {
      List<Account> accList = getAccountRecord();
      return [
        SELECT Id, Name, StageName
        FROM Opportunity
        WHERE AccountId = :accList[0].Id
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
