public with sharing class pocController {
  @AuraEnabled
  public String label { get; set; }

  @AuraEnabled
  public static void setApexClassType(String myApexClass) {
    NewWrapperClass nwc = (NewWrapperClass) JSON.deserialize(
      myApexClass,
      NewWrapperClass.class
    );
  }
}
