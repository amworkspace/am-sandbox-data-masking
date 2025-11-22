/*
 * File: Test_DataMaskingBatch.cls
 * Salesforce Data Masking Automation
 * Copyright (c) 2025, Anil Mannem
 * https://github.com/amworkspace/am-sandbox-data-masking
 */

@IsTest
private class Test_DataMaskingBatch {

  @IsTest
  static void testBatchExecution() {
    Contact c = TestDataMaskingSetup.setupContact();
    List<Data_Masking_Config__mdt> configs = TestDataMaskingSetup.setupMetadata();

    Test.startTest();
    Database.executeBatch(new DataMaskingBatch('Contact', configs), 1);
    Test.stopTest();

    Contact updated = [
      SELECT FirstName, LastName, Email, Phone
      FROM Contact
      WHERE Id = :c.Id
    ];

    System.assertEquals('john.doe+sandbox@masked.invalid', updated.Email);
    System.assertEquals('9999999910', updated.Phone);
    System.assertEquals('Test', updated.FirstName);
    System.assertEquals('User', updated.LastName);
  }
}