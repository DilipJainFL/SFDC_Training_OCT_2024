public with sharing class refreshContactController {
  @AuraEnabled(Cacheable=true)
  public static list<Contact> getContactList() {
    return [SELECT id, FirstName, LastName, Email FROM Contact LIMIT 10];
  }
}
