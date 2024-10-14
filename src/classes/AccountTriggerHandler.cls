public class AccountTriggerHandler {
  public static final string[] ValidChars = new List<string>{
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  };
  public static final integer IDLENGTH = 11;
  public static final integer ValidCharsLength = ValidChars.size();

  public static String generateRandomAccountNumber() {
    String ID = '';
    for (integer i = 0; i < IDLENGTH; i++) {
      ID = ID + ValidChars[(integer) (math.random() * (ValidCharsLength))];
    }
    return ID;
  }

  public static void updateAccountNumberAsPerAccountType(
    List<Account> accountList
  ) {
    for (Account acc : accountList) {
      if (acc.Type == 'Saving') {
        acc.AccountNumber = 'SB-' + generateRandomAccountNumber();
      } else if (acc.Type == 'FD') {
        acc.AccountNumber = 'FD-' + generateRandomAccountNumber();
      }
    }
  }

  public static void sendEmail(List<Account> accountList) {
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    for (Account acc : accountList) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<String> sendTo = new List<String>();
      sendTo.add('krishna.saha@fexle.com');
      mail.setToAddresses(sendTo);
      mail.setSubject('Account was created...');
      String body = 'Dear ' + acc.Name + ', ';
      body +=
        'Congratulations your ' +
        acc.Type +
        ' account has been created on your request.';
      mail.setHtmlBody(body);
      mails.add(mail);
    }
    Messaging.sendEmail(mails);
  }
}
