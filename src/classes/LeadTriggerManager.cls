public class LeadTriggerManager {

    public static void updateTerritoryName (List<Lead> leadList) {
       
           String FlowId = '';

           List<String> ZipCodes = new List<String>();
           List<String> cityList = new List<String>();
           List<String> stateList = new List<String>();
           List<RecordType> rt = [SELECT Name, Id FROM RecordType WHERE SObjectType = 'Lead' AND Name like 'Flow%'];
           If (rt.size() > 0) { FlowId = rt[0].Id; }
           
            //  add checker for correctness of zipcode
           for (Lead l : leadList) { //trigger.new
               if (l.PostalCode != null && !l.PostalCode.equals('')){ //l.State != null
                   ZipCodes.add(l.PostalCode); 
               } else if(l.City != null && l.State != null) {
                   cityList.add(l.City);    //will only be populated when no available postal code
                   stateList.add(l.State);
               } else { }
           }
           
           if (ZipCodes.size() > 0){
               Map<string, Geo_Data_Map__c> GDM_Map = new map<string, Geo_Data_Map__c>();
               for (Geo_Data_Map__c g :[SELECT Id, Zip_Code__c, Flow_Territory__c, Uterritory_2__c, Uterritory_Name__c
                                          FROM Geo_Data_Map__c
                                         WHERE Zip_Code__c in :ZipCodes]) {
                  GDM_Map.put(g.Zip_Code__c, g);
               }
               for (Lead ld : leadList) {
                   if (ld.PostalCode != null && GDM_Map.containsKey(ld.PostalCode)){     // ld.State != ''
                      if (ld.RecordTypeId == FlowId) {
                          ld.Territory_Name_2__c = GDM_Map.get(ld.PostalCode).Flow_Territory__c;
                      } else {
                         ld.Uterritory2__c = GDM_Map.get(ld.PostalCode).Uterritory_2__c;
                         ld.UTerritory_Name__c = GDM_Map.get(ld.PostalCode).Uterritory_Name__c;
                      }
                   } else if (!GDM_Map.containsKey(ld.PostalCode)){ // if incorrect postalCode
                       ld.addError('Invalid Postal Code.');
                   } else {
                       // do nothing
                   }
               }
            } 
        
            if(cityList.size() > 0){ 
                Map<string, Geo_Data_Map__c> GDM_Map_City = new map<string, Geo_Data_Map__c>();
                for (Geo_Data_Map__c g :[SELECT Id, City__c, State__c, Flow_Territory__c, Uterritory_2__c, Uterritory_Name__c
                                          FROM Geo_Data_Map__c
                                         WHERE City__c in :cityList]) {
                
                    // Get corresponding state
                    for(integer i=0; i<cityList.size(); i++){
                        String city = cityList.get(i);
                        String state = stateList.get(i);
                        if(g.City__c.equalsIgnoreCase(city) && g.State__c.equalsIgnoreCase(state)){
                            GDM_Map_City.put(g.City__c, g);
                        } else continue;
                    }
                }
                
                String currentState='';
                for (Lead ld : leadList) {
                    System.debug(ld.City+':'+ld.State+'::'+ld.PostalCode);
                    if(ld.PostalCode==null && ld.City != null && ld.State != null){
                        if (ld.RecordTypeId == FlowId && GDM_Map_City.size() > 0) {
                            currentState = GDM_Map_City.get(ld.City).State__c;
                            if(ld.State.equals(currentState)){
                                ld.Territory_Name_2__c = GDM_Map_City.get(ld.City).Flow_Territory__c;
                            } // else as blank
                        } else {
                            if(GDM_Map_City.size() > 0){
                                currentState = GDM_Map_City.get(ld.City).State__c;
                                if(ld.State.equals(currentState)){
                                    ld.Uterritory2__c = GDM_Map_City.get(ld.City).Uterritory_2__c;
                                    ld.UTerritory_Name__c = GDM_Map_City.get(ld.City).Uterritory_Name__c;
                                }  // else as blank
                            }
                            
                        }
                    }
                }
            }
        
    }
    
}