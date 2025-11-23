/*
 * File: Test_DataMaskingBatch.cls
 * Salesforce Sandbox Data Masking Automation
 * Copyright (c) 2025, Anil Mannem
 * https://github.com/amworkspace/am-sandbox-data-masking
 */

@IsTest
private class Test_DataMaskingBatch {

  @IsTest
  static void testBatchExecution() {
    Lead l = TestDataMaskingSetup.setupLead();
    List<Data_Masking_Config__mdt> configs = TestDataMaskingSetup.setupMetadata();

    Test.startTest();
    Database.executeBatch(new DataMaskingBatch('Lead', configs), 1);
    Test.stopTest();

    Lead updated = [
      SELECT FirstName, LastName, Email, Phone
      FROM Lead
      WHERE Id = :l.Id
    ];

    System.assertEquals('john.doe+sandbox@masked.invalid', updated.Email);
    System.assertEquals('9999999910', updated.Phone);
    System.assertEquals('Test', updated.FirstName);
    System.assertEquals('User', updated.LastName);
  }
}