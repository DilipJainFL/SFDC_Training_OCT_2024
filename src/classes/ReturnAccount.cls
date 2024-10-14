public class ReturnAccount {
  public static list<Account> accounts() {
    return [SELECT Id, Name FROM Account LIMIT 5];
  }
}
