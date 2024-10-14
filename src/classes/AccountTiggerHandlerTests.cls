@isTest(SeeAllData=false)
private class AccountTiggerHandlerTests {
  @TestSetup
  static void makeData() {
    List<Account> accounts = new List<Account>();
    accounts.add(
      new Account(
        Name = 'Test1',
        Type = 'Savings' /*, Email = 'test1@test.com'*/
      )
    );
    insert accounts;
  }

  @isTest
  private static void testGenerateRandomAccountNumber() {
  }

  @isTest
  private static void testUpdateAccountNumberAsPerAccountType() {
    List<Account> accounts = new List<Account>();
    accounts.add(
      new Account(
        Name = 'Test2',
        Type = 'Savings' /*, Email = 'test2@test.com'*/
      )
    );

    System.Test.startTest();
    insert accounts;
    System.Test.stopTest();

    Account acc = [
      SELECT Id, AccountNumber
      FROM Account
      WHERE ID = :accounts[0].Id
      LIMIT 1
    ];
    System.debug(acc);
    System.assert(
      acc.AccountNumber.startsWith('SB'),
      'Account Number should starts with SB'
    );
  }

  @isTest
  private static void testSendEmail() {
  }
}
