public class PDFGenerateCtrl {
  List<Account> accounts;

  public List<Account> getAccounts() {
    if (accounts == null)
      accounts = [SELECT Name, Rating, Industry FROM Account LIMIT 20];
    return accounts;
  }
}
