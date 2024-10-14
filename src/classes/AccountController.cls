public with sharing class AccountController {
  @AuraEnabled(cacheable=true)
  public static List<Account> getAccountList() {
    return [SELECT Id, Name, Type, Industry FROM Account LIMIT 5];
  }

  @AuraEnabled(cacheable=true)
  public static List<Account> filterAccountTypeType(String type) {
    return [
      SELECT Id, Name, Type, Industry
      FROM Account
      WHERE Type = :type
      LIMIT 5
    ];
  }

  @AuraEnabled(cacheable=true)
  public static List<Account> findAccounts(String searchKey) {
    String key = '%' + searchKey + '%';
    return [
      SELECT Id, Name, Type, Industry
      FROM Account
      WHERE Name LIKE :key
      LIMIT 5
    ];
  }

  @AuraEnabled
  public static List<Account> insertAccounts(
    List<AccountWrapper> accountWrappers
  ) {
    List<Account> accountsToInsert = new List<Account>();

    for (AccountWrapper wrapper : accountWrappers) {
      System.debug('wrapper -->' + wrapper);
      Account acct = new Account();
      acct.Name = wrapper.accountName;
      acct.Phone = wrapper.accountPhone;
      acct.Website = wrapper.accountWebsite;
      accountsToInsert.add(acct);
    }
    system.debug('entered into the method' + accountsToInsert);
    insert accountsToInsert;
    System.debug('record inserted ' + accountsToInsert);

    return accountsToInsert;
  }

  public class AccountWrapper {
    @AuraEnabled
    public String accountName { get; set; }

    @AuraEnabled
    public String accountPhone { get; set; }
    @AuraEnabled
    public String accountWebsite { get; set; }
    @AuraEnabled
    public String Id { get; set; }
  }
}
