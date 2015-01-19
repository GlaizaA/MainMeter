@isTest
public class LeadTriggerManager_Test {
    static Lead l1;

    public static void leadTestData (Id recordTypeId, String postalCode, String country, String city, String state, String stateCode, Id recordToUpdate) {
        if(recordToUpdate != null){
            List<Lead> leadList = [Select id from Lead where id=:recordToUpdate];
            l1 = leadList.get(0);
        } else {
            l1 = new Lead();
        }
        l1.RecordTypeId = recordTypeId;
        l1.FirstName = 'John';
        l1.LastName = 'Doe';
        l1.Company = 'Acme';
        l1.Organization_Type__c = 'Instrumentation Customer (IC)';
        l1.Status = 'Qualified';
        l1.Rating = 'Hot';
        l1.Product__c = 'Concrete Fluid Products';
        
        l1.Country = country;
        l1.City = city;
        l1.State = state;
        l1.StateCode = stateCode;
        l1.PostalCode = postalCode;
    }
    
    public static void geoDataMapTestData (){
        // Flow Record Type - zip without dupes
        Geo_Data_Map__c g1 = new Geo_Data_Map__c();
        g1.Zip_Code__c = '10001';
        g1.City__c = 'Moody';
        g1.State__c = 'Alabama';
        g1.Flow_Territory__c = 'Midwest';
        g1.Uterritory_2__c = 'MN1';
        g1.Uterritory_Name__c = 'Southeast';
        g1.Population_for_Zip__c = 3000;
        g1.County__c = 'Marshall';
        g1.ST__c = 'AL';
        g1.Zip3__c = '567';
        g1.Flow_Regional_Sales_Manager__c = 'Tim Wissing';
        g1.UAccount_Manager__c = 'Mike McNabb';
        insert g1;
        
        // zip and city state with 3 dupes, similar data
        Geo_Data_Map__c g2 = new Geo_Data_Map__c();
        g2.Zip_Code__c = '10002';
        g2.City__c = 'Bessemer';
        g2.State__c = 'Alabama';
        g2.Flow_Territory__c = 'Southeast';
        g2.Uterritory_2__c = 'MN1';
        g2.Uterritory_Name__c = 'East';
        g2.Population_for_Zip__c = 5000;
        g2.County__c = 'Marshall';
        g2.ST__c = 'AL';
        g2.Zip3__c = '567';
        g2.Flow_Regional_Sales_Manager__c = 'Tim Wissing';
        g2.UAccount_Manager__c = 'Mike McNabb';
        insert g2;
        
        Geo_Data_Map__c g3 = new Geo_Data_Map__c();
        g3.Zip_Code__c = '10002';
        g3.City__c = 'Bessemer';
        g3.State__c = 'Alabama';
        g3.Flow_Territory__c = 'Southeast';
        g3.Uterritory_2__c = 'MN1';
        g3.Uterritory_Name__c = 'East';
        g3.Population_for_Zip__c = 5000;
        g3.County__c = 'Marshall';
        g3.ST__c = 'AL';
        g3.Zip3__c = '567';
        g3.Flow_Regional_Sales_Manager__c = 'Tim Wissing';
        g3.UAccount_Manager__c = 'Mike McNabb';
        insert g3;
        
        Geo_Data_Map__c g4 = new Geo_Data_Map__c();
        g4.Zip_Code__c = '10002';
        g4.City__c = 'Bessemer';
        g4.State__c = 'Alabama';
        g4.Flow_Territory__c = 'Southeast';
        g4.Uterritory_2__c = 'MN1';
        g4.Uterritory_Name__c = 'East';
        g4.Population_for_Zip__c = 5000;
        g4.County__c = 'Marshall';
        g4.ST__c = 'AL';
        g4.Zip3__c = '567';
        g4.Flow_Regional_Sales_Manager__c = 'Tim Wissing';
        g4.UAccount_Manager__c = 'Mike McNabb';
        insert g4;
        
        // zip and city state with 3 dupes, different data
        Geo_Data_Map__c g5 = new Geo_Data_Map__c();
        g5.Zip_Code__c = '10003';
        g5.City__c = 'Arvada';
        g5.State__c = 'Colorado';
        g5.Flow_Territory__c = 'Central';
        g5.Uterritory_2__c = 'AL1';
        g5.Uterritory_Name__c = 'East';
        g5.Population_for_Zip__c = 31000;
        g5.County__c = 'Marshall';
        g5.ST__c = 'CO';
        g5.Zip3__c = '567';
        g5.Flow_Regional_Sales_Manager__c = 'Tim Wissing';
        g5.UAccount_Manager__c = 'Mike McNabb';
        insert g5;
        
        Geo_Data_Map__c g6 = new Geo_Data_Map__c();
        g6.Zip_Code__c = '10003';
        g6.City__c = 'Arvada';
        g6.State__c = 'Colorado';
        g6.Flow_Territory__c = 'West';
        g6.Uterritory_2__c = 'NC1';
        g6.Uterritory_Name__c = 'East';
        g6.Population_for_Zip__c = 30000;
        g6.County__c = 'Marshall';
        g6.ST__c = 'CO';
        g6.Zip3__c = '567';
        g6.Flow_Regional_Sales_Manager__c = 'Tim Wissing';
        g6.UAccount_Manager__c = 'Mike McNabb';
        insert g6;
        
        Geo_Data_Map__c g7 = new Geo_Data_Map__c();
        g7.Zip_Code__c = '10003';
        g7.City__c = 'Arvada';
        g7.State__c = 'Colorado';
        g7.Flow_Territory__c = 'Southeast';
        g7.Uterritory_2__c = 'WY2';
        g7.Uterritory_Name__c = 'West';
        g7.Population_for_Zip__c = 10000;
        g7.County__c = 'Marshall';
        g7.ST__c = 'CO';
        g7.Zip3__c = '567';
        g7.Flow_Regional_Sales_Manager__c = 'Tim Wissing';
        g7.UAccount_Manager__c = 'Mike McNabb';
        insert g7;
        
        Geo_Data_Map__c g8 = new Geo_Data_Map__c();
        g8.Zip_Code__c = '10004';
        g8.City__c = 'Phoenix';
        g8.State__c = 'Arizona';
        g8.Flow_Territory__c = 'West';
        g8.Uterritory_2__c = 'AZ1';
        g8.Uterritory_Name__c = 'West';
        g8.Population_for_Zip__c = 30000;
        g8.County__c = 'Marshall';
        g8.ST__c = 'AZ';
        g8.Zip3__c = '567';
        g8.Flow_Regional_Sales_Manager__c = 'Tim Wissing';
        g8.UAccount_Manager__c = 'Mike McNabb';
        insert g8;
        
        Geo_Data_Map__c g9 = new Geo_Data_Map__c();
        g9.Zip_Code__c = '10005';
        g9.City__c = 'Austell';
        g9.State__c = 'Georgia';
        g9.Flow_Territory__c = 'Southeast';
        g9.Uterritory_2__c = 'GA1';
        g9.Uterritory_Name__c = 'East';
        g9.Population_for_Zip__c = 1000;
        g9.County__c = 'Marshall';
        g9.ST__c = 'GA';
        g9.Zip3__c = '567';
        g9.Flow_Regional_Sales_Manager__c = 'Tim Wissing';
        g9.UAccount_Manager__c = 'Mike McNabb';
        insert g9;
    }
    
    public static testmethod void testValuesUpdateFlowRecordZip(){
         // add data to GDM Data Map
         geoDataMapTestData();
         
         Test.startTest();
         List<RecordType> recordTypes = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Flow%'];
         System.assertEquals(1, recordTypes.size());
         
         leadTestData(recordTypes.get(0).Id, '10001',null,null,null,'AL',null);
         Database.SaveResult resultL1 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, '10004',null,null,null, 'AZ',null);
         Database.SaveResult resultL2 = Database.insert(l1, false);
         
         // for Update
         leadTestData(recordTypes.get(0).Id, '10004',null,null,null, 'AZ',null);
         Database.SaveResult resultL0 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, '10005',null,null,null,null,resultL0.getId());
         Database.SaveResult resultL3 = Database.update(l1, false);
         
         // with similar dupes: insert
         leadTestData(recordTypes.get(0).Id, '10002',null,null,null, 'AL',null);
         Database.SaveResult resultL4 = Database.insert(l1, false);
         
         // with similar dupes: update
         leadTestData(recordTypes.get(0).Id, '10004',null,null,null,'AZ' ,null);
         Database.SaveResult resultL5 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, '10002',null,null,null,null, resultL5.getId());
         Database.SaveResult resultL6 = Database.update(l1, false);
         Test.stopTest();
         
         // asserts here
         System.assert(resultL0.isSuccess());
         System.assert(resultL5.isSuccess());
         
         System.assert(resultL1.isSuccess());
         List<Lead> leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL1.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('Midwest', leadList.get(0).Territory_Name_2__c);
         
         System.assert(resultL2.isSuccess());
         leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL2.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('West', leadList.get(0).Territory_Name_2__c);
         
         System.assert(resultL3.isSuccess());
         leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL3.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('Southeast', leadList.get(0).Territory_Name_2__c);
         
         System.assert(resultL4.isSuccess());
         leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL4.getId()];
         System.assertEquals(1, leadList.size());
         
         System.assert(resultL6.isSuccess());
         leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL6.getId()];
         System.assertEquals(1, leadList.size());
     }
     
     public static testmethod void testValuesUpdateUtilityRecordZip(){
         geoDataMapTestData();
         
         Test.startTest();
         List<RecordType> recordTypes = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Utility%'];
         System.assertEquals(1, recordTypes.size());
         
         leadTestData(recordTypes.get(0).Id, '10001',null,null,null,'AL',null);
         Database.SaveResult resultL1 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, '10004',null,null,null,'AZ', null);
         Database.SaveResult resultL2 = Database.insert(l1, false);
         
         // for Update
         leadTestData(recordTypes.get(0).Id, '10004',null,null,null,'AZ', null);
         Database.SaveResult resultL0 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, '10005',null,null,null,null, resultL0.getId());
         Database.SaveResult resultL3 = Database.update(l1, false);
         
         // with similar dupes: insert
         leadTestData(recordTypes.get(0).Id, '10002',null,null,null,'AL', null);
         Database.SaveResult resultL4 = Database.insert(l1, false);
         
         // with similar dupes: update
         leadTestData(recordTypes.get(0).Id, '10004',null,null,null,'AZ', null);
         Database.SaveResult resultL5 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, '10002',null,null,null, null, resultL5.getId());
         Database.SaveResult resultL6 = Database.update(l1, false);
         Test.stopTest();
         
         // asserts here
         System.assert(resultL0.isSuccess());
         System.assert(resultL5.isSuccess());
         
         System.assert(resultL1.isSuccess());
         List<Lead> leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL1.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('MN1', leadList.get(0).Uterritory2__c);
         System.assertEquals('Southeast', leadList.get(0).UTerritory_Name__c);
         System.assertEquals(false, leadList.get(0).Population_Threshold__c);
         
         System.assert(resultL2.isSuccess());
         leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL2.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('AZ1', leadList.get(0).Uterritory2__c);
         System.assertEquals('West', leadList.get(0).UTerritory_Name__c);
         System.assertEquals(true, leadList.get(0).Population_Threshold__c);
         
         System.assert(resultL3.isSuccess());
         leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL3.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('GA1', leadList.get(0).Uterritory2__c);
         System.assertEquals('East', leadList.get(0).UTerritory_Name__c);
         System.assertEquals(false, leadList.get(0).Population_Threshold__c);
         
         System.assert(resultL4.isSuccess());
         leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL4.getId()];
         System.assertEquals(1, leadList.size());
         
         System.assert(resultL6.isSuccess());
         leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL6.getId()];
         System.assertEquals(1, leadList.size());
     }
     
     public static testmethod void testValuesUpdateFlowRecordCityState(){
         // add data to GDM Data Map
         geoDataMapTestData();
         
         Test.startTest();
         List<RecordType> recordTypes = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Flow%'];
         System.assertEquals(1, recordTypes.size());
         
         leadTestData(recordTypes.get(0).Id, null,'United States','Moody','Alabama','AL', null);
         Database.SaveResult resultL1 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, null,'United States','Phoenix','Arizona','AZ', null);
         Database.SaveResult resultL2 = Database.insert(l1, false);
         
         // for Update
         leadTestData(recordTypes.get(0).Id, null,'United States','Phoenix','Arizona','AZ', null);
         Database.SaveResult resultL0 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, null,'United States','Austell','Georgia','GA', resultL0.getId());
         Database.SaveResult resultL3 = Database.update(l1, false);
         
         // with similar dupes: insert
         leadTestData(recordTypes.get(0).Id, null,'United States','Bessemer','Alabama','AL', null);
         Database.SaveResult resultL4 = Database.insert(l1, false);
         
         // with similar dupes: update
         leadTestData(recordTypes.get(0).Id, null,'United States','Phoenix','Arizona','AZ', null);
         Database.SaveResult resultL5 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, null,'United States','Bessemer','Alabama','AL', resultL5.getId());
         Database.SaveResult resultL6 = Database.update(l1, false);
         Test.stopTest();
         
         // asserts here
         System.assert(resultL0.isSuccess());
         System.assert(resultL5.isSuccess());
         
         System.assert(resultL1.isSuccess());
         List<Lead> leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL1.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('Midwest', leadList.get(0).Territory_Name_2__c);
         
         System.assert(resultL2.isSuccess());
         leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL2.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('West', leadList.get(0).Territory_Name_2__c);
         
         System.assert(resultL3.isSuccess());
         leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL3.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('Southeast', leadList.get(0).Territory_Name_2__c);
         
         System.assert(resultL4.isSuccess());
         leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL4.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('Southeast', leadList.get(0).Territory_Name_2__c);
         
         System.assert(resultL6.isSuccess());
         leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL6.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('Southeast', leadList.get(0).Territory_Name_2__c);
     }
     
     public static testmethod void testValuesUpdateUtilityRecordCityState(){
         geoDataMapTestData();
         
         Test.startTest();
         List<RecordType> recordTypes = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Utility%'];
         System.assertEquals(1, recordTypes.size());
         
         leadTestData(recordTypes.get(0).Id, null,'United States','Moody','Alabama','AL', null);
         Database.SaveResult resultL1 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, null,'United States','Phoenix','Arizona','AZ', null);
         Database.SaveResult resultL2 = Database.insert(l1, false);
         
         // for Update
         leadTestData(recordTypes.get(0).Id, null,'United States','Phoenix','Arizona','AZ', null);
         Database.SaveResult resultL0 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, '','United States','Austell','Georgia','GA', resultL0.getId());
         Database.SaveResult resultL3 = Database.update(l1, false);
         
         // with similar dupes: insert
         leadTestData(recordTypes.get(0).Id, null,'United States','Bessemer','Alabama','AL', null);
         Database.SaveResult resultL4 = Database.insert(l1, false);
         
         // with similar dupes: update
         leadTestData(recordTypes.get(0).Id, null,'United States','Phoenix','Arizona','AZ', null);
         Database.SaveResult resultL5 = Database.insert(l1, false);
         leadTestData(recordTypes.get(0).Id, null,'United States','Bessemer','Alabama','AL', resultL5.getId());
         Database.SaveResult resultL6 = Database.update(l1, false);
         Test.stopTest();
         
         // asserts here
         System.assert(resultL0.isSuccess());
         System.assert(resultL5.isSuccess());
         
         System.assert(resultL1.isSuccess());
         List<Lead> leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL1.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('MN1', leadList.get(0).Uterritory2__c);
         System.assertEquals('Southeast', leadList.get(0).UTerritory_Name__c);
         System.assertEquals(false, leadList.get(0).Population_Threshold__c);
         
         System.assert(resultL2.isSuccess());
         leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL2.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('AZ1', leadList.get(0).Uterritory2__c);
         System.assertEquals('West', leadList.get(0).UTerritory_Name__c);
         System.assertEquals(true, leadList.get(0).Population_Threshold__c);
         
         System.assert(resultL3.isSuccess());
         leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL3.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('GA1', leadList.get(0).Uterritory2__c);
         System.assertEquals('East', leadList.get(0).UTerritory_Name__c);
         System.assertEquals(false, leadList.get(0).Population_Threshold__c);
         
         System.assert(resultL4.isSuccess());
         leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL4.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('MN1', leadList.get(0).Uterritory2__c);
         System.assertEquals('East', leadList.get(0).UTerritory_Name__c);
         System.assertEquals(false, leadList.get(0).Population_Threshold__c);
         
         System.assert(resultL6.isSuccess());
         leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL6.getId()];
         System.assertEquals(1, leadList.size());
         System.assertEquals('MN1', leadList.get(0).Uterritory2__c);
         System.assertEquals('East', leadList.get(0).UTerritory_Name__c);
         System.assertEquals(false, leadList.get(0).Population_Threshold__c);
     }
     
     public static testmethod void testNegativeBlankScenarios(){
        geoDataMapTestData();
        
        Test.startTest();
        // Incorrect ZipCode CityState if recordtype is Flow
        List<RecordType> recordTypesFlow = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Flow%'];
        System.assertEquals(1, recordTypesFlow.size());
        leadTestData(recordTypesFlow.get(0).Id, '10009',null,null,null,null, null);
        Database.SaveResult resultL1 = Database.insert(l1, false);
        //leadTestData(recordTypesFlow.get(0).Id, null,'United States','Georgia','Norcross','GA', null);
        //Database.SaveResult resultL2 = Database.insert(l1, false);
        
        // Incorrect ZipCode CityState if recordtype is Utility
        List<RecordType> recordTypesUtil = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Utili%'];
        System.assertEquals(1, recordTypesUtil.size());
        leadTestData(recordTypesUtil.get(0).Id, '10009',null,null,null,null, null);
        Database.SaveResult resultL3 = Database.insert(l1, false);
        //leadTestData(recordTypesUtil.get(0).Id, null,'United States','Georgia','Norcross','GA', null);
        //Database.SaveResult resultL4 = Database.insert(l1, false);
        
        // Test for blank territoryNames
        leadTestData(recordTypesUtil.get(0).Id, null,'United States','Georgia','','GA', null);
        Database.SaveResult resultL5 = Database.insert(l1, false);
        
        Test.stopTest();
        
        //asserts here
        System.assert(resultL1.isSuccess());   //Flow: invalid zip codes
        System.assert(resultL3.isSuccess());   //Utility: invalid zip codes
        
        // will not update anything
        System.assert(resultL5.isSuccess());
        List<Lead> leadList = [Select id, Territory_Name_2__c, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL5.getId()];
        System.assertEquals(1, leadList.size());
        System.assertEquals(null, leadList.get(0).Uterritory2__c);
        System.assertEquals(null, leadList.get(0).UTerritory_Name__c);
        System.assertEquals(false, leadList.get(0).Population_Threshold__c);
    }
    
    public static testmethod void testHeatMapDuplicates(){
        geoDataMapTestData();
        
        Test.startTest();
        List<RecordType> recordTypesFlow = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Flow%'];
        System.assertEquals(1, recordTypesFlow.size());
        leadTestData(recordTypesFlow.get(0).Id, '10003',null,null,null,null, null);
        Database.SaveResult resultL1 = Database.insert(l1, false);
        leadTestData(recordTypesFlow.get(0).Id, null,'United States','Arvada','Colorado','CO', null);
        Database.SaveResult resultL2 = Database.insert(l1, false);
        
        List<RecordType> recordTypesUtil = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Utili%'];
        System.assertEquals(1, recordTypesUtil.size());
        leadTestData(recordTypesUtil.get(0).Id, '10003',null,null,null,null, null);
        Database.SaveResult resultL3 = Database.insert(l1, false);
        leadTestData(recordTypesUtil.get(0).Id, null,'United States','Arvada','Colorado','CO', null);
        Database.SaveResult resultL4 = Database.insert(l1, false);
        Test.stopTest();
        
        //asserts here
        // FLOW
        System.assert(resultL1.isSuccess()); //more than 1 zipcode,different data will return error
        List<Lead> leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL1.getId()];
        System.assertEquals(1, leadList.size());
        
        System.assert(resultL2.isSuccess());
        leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL2.getId()];
        System.assertEquals(1, leadList.size());
        System.assertEquals(null, leadList.get(0).Territory_Name_2__c);   //if more than 1 city/state pair, different data
        
        // UTILITY
        System.assert(resultL3.isSuccess());
        leadList = [Select id, Uterritory2__c,UTerritory_Name__c from Lead where id=:resultL3.getId()];
        System.assertEquals(1, leadList.size());
        
        System.assert(resultL4.isSuccess());
        leadList = [Select id, Uterritory2__c,UTerritory_Name__c,Population_Threshold__c from Lead where id=:resultL4.getId()];
        System.assertEquals(1, leadList.size());
        System.assertEquals(null, leadList.get(0).Uterritory2__c);
        System.assertEquals(null, leadList.get(0).UTerritory_Name__c);
        System.assertEquals(true, leadList.get(0).Population_Threshold__c);
    }
    
    public static testmethod void testMultipleInserts(){
        geoDataMapTestData();
        
        Test.startTest();
        // put all records to insert on a single list
        List<Lead> flowInsertList = new List<Lead>();
        List<RecordType> recordTypesFlow = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Flow%'];
        System.assertEquals(1, recordTypesFlow.size());
        leadTestData(recordTypesFlow.get(0).Id, '10001',null,null,null,'AL', null);
        flowInsertList.add(l1);
        leadTestData(recordTypesFlow.get(0).Id, '10004',null,null,null, 'AZ',null);
        flowInsertList.add(l1);
        leadTestData(recordTypesFlow.get(0).Id, null,'United States','Moody','Alabama','AL', null);
        flowInsertList.add(l1);
        leadTestData(recordTypesFlow.get(0).Id, null,'United States','Phoenix','Arizona','AZ', null);
        flowInsertList.add(l1);
        leadTestData(recordTypesFlow.get(0).Id, null,'United States','Bessemer','Alabama','AL', null);
        flowInsertList.add(l1);
        Database.SaveResult[] resultL1 = Database.insert(flowInsertList, false);
        
        List<Lead> utilInsertList = new List<Lead>();
        List<RecordType> recordTypesUtil = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Utili%'];
        System.assertEquals(1, recordTypesUtil.size());
        leadTestData(recordTypesUtil.get(0).Id, '10001',null,null,null,null, null);
        utilInsertList.add(l1);
        leadTestData(recordTypesUtil.get(0).Id, '10004',null,null,null, null,null);
        utilInsertList.add(l1);
        leadTestData(recordTypesUtil.get(0).Id, null,'United States','Moody','Alabama','AL', null);
        utilInsertList.add(l1);
        leadTestData(recordTypesUtil.get(0).Id, null,'United States','Phoenix','Arizona','AZ', null);
        utilInsertList.add(l1);
        leadTestData(recordTypesUtil.get(0).Id, null,'United States','Bessemer','Alabama','AL', null);
        utilInsertList.add(l1);
        Database.SaveResult[] resultL2 = Database.insert(utilInsertList, false);
        
        Test.stopTest();
        
        //asserts here
        for(Database.SaveResult result:resultL1){
            System.assert(result.isSuccess());
        }
        for(Database.SaveResult result:resultL2){
            System.assert(result.isSuccess());
        }
    }
    
}