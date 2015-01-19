trigger LeadTrigger on Lead (before insert, before update) {

   /*
      When the Lead is inserted, the Zip Code will be retrieved.  This will be compared to the 
      Geo_Data_Map__c table, and the matching row retrieved.
      
      If the Lead Record Type is Flow, it will set the value of the Territory_Name_2__c field to the
      value of the Geo_Data_Map__c.Flow_Territory__c field.  Otherwise, the Lead.Uterritory2__c and 
      Lead.UTerritory_Name__c fields will be set to the Geo_Data_Map__c.Uterritory_2__c and 
      Geo_Data_Map__c.Uterritory_Name__c field values.
   */
   
   if(Trigger.isBefore && Trigger.isInsert){
       LeadTriggerManager.updateTerritoryName(trigger.new);
   }
   if(Trigger.isBefore && Trigger.isUpdate){
       LeadTriggerManager.updateTerritoryName(trigger.new);
   }
   
}