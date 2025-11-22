/*
 * File: Test_DataMaskingController.cls
 * Salesforce Data Masking Automation
 * Copyright (c) 2025, Anil Mannem
 * https://github.com/amworkspace/am-sandbox-data-masking
 */

@IsTest
private class Test_DataMaskingController {

  @IsTest
  static void testControllerRun() {
    Contact c = TestDataMaskingSetup.setupContact();
    TestDataMaskingSetup.setupMetadata();

    Test.startTest();
    DataMaskingController.maskData();
    Test.stopTest();

    Contact updated = [
      SELECT FirstName, LastName, Email, Phone
      FROM Contact
      WHERE Id = :c.Id
    ];
    System.assertNotEquals('john.doe@example.com', updated.Email);
    System.assert(updated.Email.endsWith('@masked.invalid'));
  }
}