@RestResource(urlMapping='/Account/*')
global with sharing class AccountManager {
  @httpDelete
  global static void doDelete() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String accountId = req.requestURI.substring(
      req.requestURI.lastIndexOf('/') + 1
    );
    Account account = [SELECT Id FROM Account WHERE Id = :accountId];
    delete account;
  }

  @httpGet
  global static Account doGet() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String accountId = req.requestURI.substring(
      req.requestURI.lastIndexOf('/') + 1
    );
    Account account = [
      SELECT Id, Name, Phone, Website
      FROM Account
      WHERE Id = :accountId
    ];
    return account;
  }

  @httpPost
  global static String doPost(String Name, String phone, String Website) {
    Account acc = new Account();
    acc.Name = Name;
    acc.Phone = phone;
    acc.Website = Website;

    insert acc;
    return acc.Id;
  }
}
