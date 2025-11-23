/*
 * File: DataMaskingController.cls
 * Salesforce Sandbox Data Masking Automation
 * Copyright (c) 2025, Anil Mannem
 * https://github.com/amworkspace/am-sandbox-data-masking
 *
 * Description: Controller class to mask data in the org, for fields specified in Custom Metadata.
 */

global class DataMaskingController {

  private static final String LIMIT_EXCEPTION_MESSAGE =
    'Limited to 5 Objects at once. Please update Metadata config to '+
    'make sure we have only 5 Active Objects';
  private static final String PROD_EXCEPTION_MESSAGE =
    'Data masking is blocked in Production.';
  private static final String PROD_ORG_ID = '00DXXXXXXXXXXX'; // Update with your PRODUCTION Org Id

  private static Boolean isProduction() {
    return UserInfo.getOrganizationId() == PROD_ORG_ID;
  }

  global static void maskData() {
    if (isProduction() && !Test.isRunningTest()) {
      throw new SecurityException(PROD_EXCEPTION_MESSAGE);
    }
    runMasking();
  }

  private static void runMasking() {
    Map<String, Data_Masking_Config__mdt> configMap =
      Data_Masking_Config__mdt.getAll();
    Map<String, List<Data_Masking_Config__mdt>> groupedConfigs =
      new Map<String, List<Data_Masking_Config__mdt>>();
    for (Data_Masking_Config__mdt cfg : configMap.values()) {
      if (!cfg.Active__c) {
        continue;
      }
      if (!groupedConfigs.containsKey(cfg.Object_API__c)) {
        groupedConfigs.put(cfg.Object_API__c,
          new List<Data_Masking_Config__mdt>());
      }
      groupedConfigs.get(cfg.Object_API__c).add(cfg);
    }
    if (groupedConfigs.size() > 5) {
      throw new SecurityException(LIMIT_EXCEPTION_MESSAGE);
    }
    for (String objName : groupedConfigs.keySet()) {
      List<Data_Masking_Config__mdt> objConfigs = groupedConfigs.get(objName);
      Integer batchSize = 200;
      if (!objConfigs.isEmpty() && objConfigs[0].Batch_Size__c != null) {
        batchSize = Integer.valueOf(objConfigs[0].Batch_Size__c);
      }
      Database.executeBatch(new DataMaskingBatch(objName, objConfigs),
        batchSize);
    }
  }
}