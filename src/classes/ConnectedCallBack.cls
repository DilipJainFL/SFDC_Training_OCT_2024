public with sharing class ConnectedCallBack {
  @AuraEnabled(Cacheable=true)
  public static string method1() {
    try {
      return 'M1';
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(Cacheable=true)
  public static string method2() {
    try {
      return 'M2';
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(Cacheable=true)
  public static string method3() {
    try {
      return 'M3';
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
