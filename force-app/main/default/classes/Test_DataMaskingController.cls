/*
 * File: Test_DataMaskingController.cls
 * Salesforce Sandbox Data Masking Automation
 * Copyright (c) 2025, Anil Mannem
 * https://github.com/amworkspace/am-sandbox-data-masking
 */

@IsTest
private class Test_DataMaskingController {

  @IsTest
  static void testControllerRun() {
    Lead l = TestDataMaskingSetup.setupLead();
    TestDataMaskingSetup.setupMetadata();

    Test.startTest();
    DataMaskingController.maskData();
    Test.stopTest();

    Lead updated = [
      SELECT FirstName, LastName, Email, Phone
      FROM Lead
      WHERE Id = :l.Id
    ];
    System.assertNotEquals('john.doe@example.com', updated.Email);
    System.assert(updated.Email.endsWith('@masked.invalid'));
  }
}