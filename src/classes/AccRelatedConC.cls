public class AccRelatedConC {
  @AuraEnabled(cacheable=true)
  public static List<Account> fetchAcc() {
    string query =
      'SELECT Id, Name,(select id,Name,AccountId from contacts)' +
      ' FROM Account';

    return Database.query(query);
  }
}
