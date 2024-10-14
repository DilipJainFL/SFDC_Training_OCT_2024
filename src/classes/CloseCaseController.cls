public with sharing class CloseCaseController {
  @AuraEnabled(cacheable=true)
  public static List<CaseWrapper> getClosedCases() {
    List<CaseWrapper> caseList = new List<CaseWrapper>();
    try {
      for (Case caseRecord : [
        SELECT Id, CaseNumber, Subject, Status
        FROM Case
        WHERE Status = 'Closed'
        LIMIT 50
      ]) {
        CaseWrapper wrapper = new CaseWrapper(caseRecord);
        caseList.add(wrapper);
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return caseList;
  }

  public class CaseWrapper {
    @AuraEnabled
    public Case CaseRecord { get; set; }
    @AuraEnabled
    public Boolean isSelected { get; set; }

    public CaseWrapper(case CaseRecord) {
      this.isSelected = false;
      this.CaseRecord = CaseRecord;
    }
  }
}
