public with sharing class TreeGridDemoController {
  public static ContactWrapper contactWrapperObject;
  public static AccountWithContactWrapper accountWithContactWrapperObject;
  public static List<AccountWithContactWrapper> listWrapperForAccountWithContactWrapper = new List<AccountWithContactWrapper>();

  @AuraEnabled(cacheable=true)
  public static List<AccountWithContactWrapper> fetchAccounts() {
    List<Account> accnt = [
      SELECT
        Id,
        Name,
        Industry,
        (SELECT Id, FirstName, LastName, Phone FROM Contacts)
      FROM Account
      WHERE Name = 'Test'
      LIMIT 20
    ];
    system.debug('accnt =>  ' + accnt);
    for (Account acc : [
      SELECT
        Id,
        Name,
        Industry,
        (SELECT Id, FirstName, LastName, Phone FROM Contacts)
      FROM Account
      WHERE Name = 'Test'
      LIMIT 20
    ]) {
      accountWithContactWrapperObject = new AccountWithContactWrapper();
      accountWithContactWrapperObject.accountId = acc.Id;
      accountWithContactWrapperObject.accountName = acc.Name;
      accountWithContactWrapperObject.accountIndustry = acc.Industry;
      accountWithContactWrapperObject.iconName = 'utility:chevronright';
      accountWithContactWrapperObject.nameStyle = '';
      List<ContactWrapper> listWrapperForContactWrapper = new List<ContactWrapper>();
      for (Contact con : acc.Contacts) {
        contactWrapperObject = new ContactWrapper();
        contactWrapperObject.contacId = con.Id;
        contactWrapperObject.contactFirstName = con.FirstName;
        contactWrapperObject.contactLastName = con.LastName;
        contactWrapperObject.contactPhone = con.Phone;
        contactWrapperObject.iconName = '';
        contactWrapperObject.nameStyle = 'margin-left:10px;';
        listWrapperForContactWrapper.add(contactWrapperObject);
      }
      accountWithContactWrapperObject.accountContacts = listWrapperForContactWrapper;
      listWrapperForAccountWithContactWrapper.add(
        accountWithContactWrapperObject
      );
    }
    if (listWrapperForAccountWithContactWrapper.size() > 0) {
      System.debug(
        'listWrapper =>  ' + listWrapperForAccountWithContactWrapper
      );
      return listWrapperForAccountWithContactWrapper;
    } else {
      return null;
    }

    //return [ SELECT Id, Name, Industry, ( SELECT Id, FirstName, LastName, Phone FROM Contacts ) FROM Account LIMIT 20 ];
  }

  @AuraEnabled
  public static list<Contact> fetchContacts() {
    list<Contact> lstContact = new List<Contact>();
    for (Contact con : [
      SELECT id, name, email, phone, title
      FROM Contact
      LIMIT 5000
    ]) {
      lstContact.add(con);
    }
    return lstContact;
  }

  //wrapper class
  public class AccountWithContactWrapper {
    @AuraEnabled
    public Id accountId { get; set; }
    @AuraEnabled
    public String accountName { get; set; }
    @AuraEnabled
    public String accountIndustry { get; set; }
    @AuraEnabled
    public String iconName { get; set; }
    @AuraEnabled
    public String nameStyle { get; set; }
    @AuraEnabled
    public List<ContactWrapper> accountContacts { get; set; }
  }

  public class ContactWrapper {
    @AuraEnabled
    public Id contacId { get; set; }
    @AuraEnabled
    public String contactFirstName { get; set; }
    @AuraEnabled
    public String contactLastName { get; set; }
    @AuraEnabled
    public String contactPhone { get; set; }
    @AuraEnabled
    public String iconName { get; set; }
    @AuraEnabled
    public String nameStyle { get; set; }
  }
}
