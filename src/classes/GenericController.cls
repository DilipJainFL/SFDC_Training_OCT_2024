public class GenericController {
  @AuraEnabled
  public static String uploadFiles(String recordId, String filedata) {
    try {
      if (String.isNotBlank(FileData)) {
        List<FileDataWP> files = (List<FileDataWP>) JSON.deserialize(
          filedata,
          List<FileDataWP>.class
        );
        System.debug(files);

        List<ContentVersion> cvList = new List<ContentVersion>();
        for (FileDataWP file : files) {
          ContentVersion conVer = new ContentVersion();
          conVer.ContentLocation = 'S'; // S = Salesforce, E = External Files
          conVer.VersionData = EncodingUtil.base64Decode(file.fileContent);
          conVer.Title = file.fileName;
          conVer.PathOnClient = file.fileName;
          cvList.add(conVer);
        }
        insert cvList;

        List<ContentDocumentLink> cdList = new List<ContentDocumentLink>();
        for (ContentVersion cv : [
          SELECT ContentDocumentId
          FROM ContentVersion
          WHERE Id = :cvList
        ]) {
          ContentDocumentLink conDocLink = new ContentDocumentLink();
          conDocLink.LinkedEntityId = '0015g00000lrSJbAAM';
          conDocLink.ContentDocumentId = cv.ContentDocumentId;
          conDocLink.Visibility = 'AllUsers';
          conDocLink.shareType = 'V'; // V = Viewer, C = Collaborator, I = Inferred
          cdList.add(conDocLink);
        }
        insert cdList;
      } else {
        return 'record Id is Blank';
      }
      return 'success';
    } catch (Exception ex) {
      System.debug(ex.getMessage() + ' -> ' + ex.getStackTraceString());
      throw new AuraHandledException(ex.getMessage());
    }
  }

  public class FileDataWP {
    public String fileName;
    public String fileContent;
  }
}
