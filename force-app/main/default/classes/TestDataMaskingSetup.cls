/*
 * File: TestDataMaskingSetup.cls
 * Salesforce Data Masking Automation
 * Copyright (c) 2025, Anil Mannem
 * https://github.com/amworkspace/am-sandbox-data-masking
 */

@IsTest
public class TestDataMaskingSetup {

  public static Contact setupContact() {
    Contact c = new Contact(
      FirstName = 'John',
      LastName = 'Original',
      Email = 'john.doe@example.com',
      Phone = '9876543210'
    );
    insert c;
    return c;
  }

  public static List<Data_Masking_Config__mdt> setupMetadata() {
    return new List<Data_Masking_Config__mdt>{
      new Data_Masking_Config__mdt(
        Object_API__c='Contact',
        Field_API__c='Email',
        Masking_Type__c='Email',
        Active__c=true
      ),
      new Data_Masking_Config__mdt(
        Object_API__c='Contact',
        Field_API__c='Phone',
        Masking_Type__c='Phone',
        Active__c=true
      ),
      new Data_Masking_Config__mdt(
        Object_API__c='Contact',
        Field_API__c='FirstName',
        Masking_Type__c='Name',
        Active__c=true
      ),
      new Data_Masking_Config__mdt(
        Object_API__c='Contact',
        Field_API__c='LastName',
        Masking_Type__c='Name',
        Active__c=true
      )
    };
  }
}