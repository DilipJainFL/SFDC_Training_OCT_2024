public with sharing class showToastController {
  @AuraEnabled(cacheable=true)
  public static Boolean showErrorMessage() {
    Boolean isError = true;
    // if (isError) {
    //     throw new AuraHandledException('Hi new Error message');
    // }
    return isError;
  }
}
