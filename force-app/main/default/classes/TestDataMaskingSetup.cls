/*
 * File: TestDataMaskingSetup.cls
 * Salesforce Sandbox Data Masking Automation
 * Copyright (c) 2025, Anil Mannem
 * https://github.com/amworkspace/am-sandbox-data-masking
 */

@IsTest
public class TestDataMaskingSetup {

  public static Lead setupLead() {
    Lead l = new Lead(
      FirstName = 'John',
      LastName = 'Original',
      Email = 'john.doe@example.com',
      Company = 'Test Company',
      Phone = '9876543210',
      Description = 'Test Description',
      NumberOfEmployees = 100
    );
    insert l;
    return l;
  }

  public static List<Data_Masking_Config__mdt> setupMetadata() {
    return new List<Data_Masking_Config__mdt>{
      new Data_Masking_Config__mdt(
        Object_API__c='Lead',
        Field_API__c='FirstName',
        Masking_Type__c='Name',
        Active__c=true
      ),
      new Data_Masking_Config__mdt(
        Object_API__c='Lead',
        Field_API__c='LastName',
        Masking_Type__c='Name',
        Active__c=true
      ),
      new Data_Masking_Config__mdt(
        Object_API__c='Lead',
        Field_API__c='Email',
        Masking_Type__c='Email',
        Active__c=true
      ),
      new Data_Masking_Config__mdt(
        Object_API__c='Lead',
        Field_API__c='Phone',
        Masking_Type__c='Phone',
        Active__c=true
      ),
      new Data_Masking_Config__mdt(
        Object_API__c='Lead',
        Field_API__c='Description',
        Masking_Type__c='Text',
        Active__c=true
      ),
      new Data_Masking_Config__mdt(
        Object_API__c='Lead',
        Field_API__c='NumberOfEmployees',
        Masking_Type__c='Number',
        Active__c=true
      )
    };
  }
}