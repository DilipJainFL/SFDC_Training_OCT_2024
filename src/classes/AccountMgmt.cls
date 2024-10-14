@RestResource(urlMapping='/v1/Account/')
global with sharing class AccountMgmt {
  @httpGet
  global static List<Account> doGet() {
    List<Account> acc = new List<Account>();
    Map<String, String> paramsMap = RestContext.request.params;
    String name = paramsMap.get('name');
    acc = [SELECT Id, Name, Phone FROM Account WHERE Name = :name];
    return acc;
  }

  @httpDelete
  global static void doDelete() {
    List<Account> acc = new List<Account>();
    Map<String, String> paramsMap = RestContext.request.params;
    String name = paramsMap.get('name');
    String phone = paramsMap.get('phone');
    acc = [
      SELECT Id, Name, Phone
      FROM Account
      WHERE Name = :name AND phone = :phone
    ];
    delete acc;
  }

  @httpPost
  global static Account doPost(String Name, String Phone, String Website) {
    Account acc = new Account();
    acc.Name = Name;
    acc.Phone = Phone;
    acc.Website = Website;
    insert acc;
    return acc;
  }

  @httpPut
  global static Account doPut() {
    Account acc = new Account();
    Map<String, String> paramsMap = RestContext.request.params;
    String id = paramsMap.get('id');
    acc.Name = 'Rajat';
    acc.id = id;
    update acc;
    return acc;
  }
}
