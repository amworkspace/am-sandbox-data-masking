/*
 * File: DataMaskingBatch.cls
 * Salesforce Sandbox Data Masking Automation
 * Copyright (c) 2025, Anil Mannem
 * https://github.com/amworkspace/am-sandbox-data-masking
 *
 * Description: Batch class to mask data in the org
 */

 public class DataMaskingBatch implements Database.Batchable<SObject>,
  Database.Stateful {

  private Integer totalFailed = 0;
  private Integer totalProcessed = 0;
  private Integer totalUpdated = 0;
  private List<Data_Masking_Config__mdt> fieldConfigs;
  private List<String> failedRecordMessages = new List<String>();
  private String objectName;

  public DataMaskingBatch(String objName,
    List<Data_Masking_Config__mdt> configs) {

    this.objectName = objName;
    this.fieldConfigs = configs;
  }

  public Database.QueryLocator start(Database.BatchableContext bc) {
    Set<String> fieldSet = new Set<String>();
    fieldSet.add('Id');
    for (Data_Masking_Config__mdt cfg : fieldConfigs) {
      fieldSet.add(cfg.Field_API__c);
    }
    String queryString = 'select ' +
                          String.join(new List<String>(fieldSet), ',') +
                          ' from ' + objectName;
    return Database.getQueryLocator(queryString);
  }

  public void execute(Database.BatchableContext bc, List<SObject> scope) {
    totalProcessed += scope.size();
    List<SObject> updates = new List<SObject>();
    for (SObject sob : scope) {
      Boolean changed = false;
      for (Data_Masking_Config__mdt cfg : fieldConfigs) {
        String fieldName = cfg.Field_API__c;
        if (!sob.getSObjectType().getDescribe().fields.getMap().containsKey(fieldName)) {
          continue;
        }
        Object original = sob.get(fieldName);
        Boolean isFirstName = fieldName.toLowerCase().contains('firstname');
        Object masked = MaskingUtil.maskField(original, cfg.Masking_Type__c,
          isFirstName);
        if (masked != null && masked != original) {
          sob.put(fieldName, masked);
          changed = true;
        }
      }
      if (changed) {
        updates.add(sob);
      }
    }

    if (!updates.isEmpty()) {
      Database.SaveResult[] results = Database.update(updates, false);
      for (Integer i = 0; i < results.size(); i++) {
        if (results[i].isSuccess()) {
          totalUpdated++;
        } else {
          totalFailed++;
          for (Database.Error err : results[i].getErrors()) {
            failedRecordMessages.add(objectName + ' — Id: ' + updates[i].Id +
              ' — ' + err.getStatusCode() + ': ' + err.getMessage());
          }
        }
      }
    }
  }

  public void finish(Database.BatchableContext bc) {
    System.debug('********* Masking Summary for: ' + objectName + ' *********');
    System.debug('Total Records Queried: ' + totalProcessed);
    System.debug('Total Records Masked Successfully: ' + totalUpdated);
    System.debug('Total Records Failed: ' + totalFailed);
    if (!failedRecordMessages.isEmpty()) {
        System.debug('********* Failed Records Details *********');
        for (String msg : failedRecordMessages) {
          System.debug(msg);
        }
    }
    System.debug('**************************************************');
  }
}