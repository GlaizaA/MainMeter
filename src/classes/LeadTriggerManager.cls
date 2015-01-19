public class LeadTriggerManager {

    static Integer THRESHOLD = 30000;
    static String FlowId = '';
    static String UtilId = '';
    
    public static void updateTerritoryName (List<Lead> leadList) {
       
           List<String> ZipCodes = new List<String>();
           List<String> cityList = new List<String>();
           List<String> stateList = new List<String>();
           List<String> stateCodeList = new List<String>();
            
           List<RecordType> rt = [SELECT Name, Id FROM RecordType WHERE SObjectType = 'Lead' AND Name like 'Flow%'];
           If (rt.size() > 0) { FlowId = rt[0].Id; }
            
           List<RecordType> rtUtil = [SELECT Name, Id FROM  RecordType WHERE SObjectType = 'Lead' AND Name like 'Utili%'];
           If (rtUtil.size() > 0) { UtilId = rtUtil[0].Id; }
           
            //  add checker for correctness of zipcode
           for (Lead l : leadList) { //trigger.new
               if (l.PostalCode != null ){ //l.State != null
                   ZipCodes.add(l.PostalCode); 
               } else if(l.City != null && l.StateCode != null){
                   stateCodeList.add(l.StateCode);
               } else { }
           }
        
           List<Geo_Data_Map__c> st_list = new List<Geo_Data_Map__c>();
           if(stateCodeList.size() > 0) {
               st_list = [SELECT Id, ST__c, State__c FROM Geo_Data_Map__c WHERE ST__c in :stateCodeList];
           }
           
           // get list of state
           Map<String,String> stateMap = new Map<String, String>();
           for(Lead l:leadList){
               if (l.PostalCode != null ){ 
                   continue; //this is already added at the previous for loop
               } else if(l.City != null && (l.State != null || l.StateCode != null)){
                   if(l.StateCode != null){
                       for(Geo_Data_Map__c gdm:st_list){
                           if(l.StateCode==gdm.ST__c && gdm.State__c!=null){
                               stateList.add(gdm.State__c);
                               stateMap.put(gdm.ST__c, gdm.State__c);
                               break;
                           } else continue;
                       }
                       cityList.add(l.City);
                   }
                   else { 
                       cityList.add(l.City);
                       stateList.add(l.State);
                   }
               }
           }
           if(ZipCodes.size()>0) {
               populateValuesBasedOnZipCode(ZipCodes, leadList);    // called to populate territoryname and over threshold based on given zipcode
           }
        
           if(cityList.size()>0 && stateList.size()>0){
               populateValuesBasedOnCityState(cityList, stateList,stateMap, leadList); // populate values using city and state pair
           }
    }
    
    public static void populateValuesBasedOnZipCode(List<String> ZipCodes, List<Lead> leadList){
        Boolean isMoreThanOneZip=false;
        
        Map<string, Geo_Data_Map__c> GDM_Map = new map<string, Geo_Data_Map__c>();
        List<Geo_Data_Map__c> gList = [SELECT Id, Zip_Code__c, Flow_Territory__c, Uterritory_2__c, Uterritory_Name__c, Population_for_Zip__c
                                     FROM Geo_Data_Map__c
                                     WHERE Zip_Code__c in :ZipCodes];
        
        for (Geo_Data_Map__c g:gList) {
            if(GDM_Map.containsKey(g.Zip_Code__c)){
                isMoreThanOneZip=true;
            } else {
                GDM_Map.put(g.Zip_Code__c, g);
                isMoreThanOneZip=false;
            }
        }
        
        for(Lead ld : leadList){
            if(gList.size()>0){
                if(isMoreThanOneZip){
                    //ld.addError('More than 2 records on Heat Map has the same zip code.');
                }
                if (ld.PostalCode != null && GDM_Map.containsKey(ld.PostalCode)){     // ld.State != ''
                    if (ld.RecordTypeId == FlowId) {
                        ld.Territory_Name_2__c = GDM_Map.get(ld.PostalCode).Flow_Territory__c;
                    } else if(ld.RecordTypeId == UtilId){
                        ld.Uterritory2__c = GDM_Map.get(ld.PostalCode).Uterritory_2__c;
                        ld.UTerritory_Name__c = GDM_Map.get(ld.PostalCode).Uterritory_Name__c;
                        ld.Territory_Name_2__c = GDM_Map.get(ld.PostalCode).Uterritory_Name__c; 
                        ld.Population_Threshold__c = updatePopulationThresholdByZipCode(GDM_Map.get(ld.PostalCode));
                    } // else don't default anything
                } else if (ld.PostalCode != null && !GDM_Map.containsKey(ld.PostalCode)){ // extra validation for incorrect postalCode
                    //ld.addError('Postal Code Invalid or Deleted.');
                } else { }
            } else {
                //ld.addError('Invalid Postal Codes.');
            }
        }
    }
     
    // This will be called every insert and update of Lead record 
    public static boolean updatePopulationThresholdByZipCode(Geo_Data_Map__c gdm){
        if(gdm.Population_for_Zip__c >= THRESHOLD) {
            return true;
        }
        return false;
    }
    
    public static void populateValuesBasedOnCityState(List<String> cityList, List<String> stateList, Map<String,String> stateMap, List<Lead> leadList){
           Boolean isDifferentTerritoriesFlow = false;
           Boolean isDifferentTerritoriesUtil = false;

           Map<string, Geo_Data_Map__c> GDM_Map_City = new map<string, Geo_Data_Map__c>();
           Map<string, Decimal> GDM_Map_Population = new map<string, Decimal>();
           
           List<Geo_Data_Map__c> gList = [SELECT Id, City__c, State__c, Flow_Territory__c, Uterritory_2__c, Uterritory_Name__c, Population_for_Zip__c 
                                         FROM Geo_Data_Map__c WHERE City__c in :cityList AND State__c in :stateList];
                                         
           if(gList.size()>0){
               // get corresponding geodatamap record and max population
               String city='', state='';
                for (Geo_Data_Map__c g : gList) {
                    // Get corresponding state and population density
                    for(integer i=0; i<cityList.size(); i++){
                        city = cityList.get(i).toLowerCase();
                        state = stateList.get(i);
                        Decimal maxPopulation=0.0;
                        
                        // find the matching city and state
                        if(g.City__c.equalsIgnoreCase(city) && g.State__c.equalsIgnoreCase(state)){
                            if(GDM_Map_City.containsKey(city)){     // if there is already an existing city/state pair
                                //check if all territoryName is the same : FLOW
                                if(!(GDM_Map_City.get(city).Flow_Territory__c.equalsIgnoreCase(g.Flow_Territory__c))){
                                    isDifferentTerritoriesFlow = true;
                                } else {
                                    isDifferentTerritoriesFlow = false;
                                }
                                // population threshold is only for Utility : UTILITY
                                if(GDM_Map_City.get(city).Uterritory_2__c.equalsIgnoreCase(g.Uterritory_2__c)){
                                    isDifferentTerritoriesUtil = false;
                                } else {    // get the highest population
                                    isDifferentTerritoriesUtil = true;
                                    if(GDM_Map_Population.size() > 0){
                                        maxPopulation=determineHighestPopn(GDM_Map_Population.get(g.City__c.toLowerCase()),g.Population_for_Zip__c);
                                        GDM_Map_Population.put(g.City__c.toLowerCase(), maxPopulation);
                                    } else {
                                        GDM_Map_Population.put(g.City__c.toLowerCase(), g.Population_for_Zip__c);//will be passed only if GDM_Map_Population is empty
                                    }
                                }
                            } else {
                                GDM_Map_City.put(g.City__c.toLowerCase(), g);
                                GDM_Map_Population.put(g.City__c.toLowerCase(), g.Population_for_Zip__c);
                            }
                        } else continue;
                    }
                }
                String currentState='';
                for (Lead ld : leadList) {
                    if(ld.PostalCode==null && ld.City != null){
                        if(ld.StateCode != null){
                            ld.State = stateMap.get(ld.StateCode);
                            currentState = stateMap.get(ld.stateCode); 
                        } else if(GDM_Map_City.get(ld.City.toLowerCase()) != null){
                            currentState = GDM_Map_City.get(ld.City.toLowerCase()).State__c;
                        } else {}
                        
                        if (ld.RecordTypeId == FlowId && GDM_Map_City.size() > 0 && isDifferentTerritoriesFlow==false) {
                            if(ld.State == currentState){
                                System.debug('GDM_Map_City.get('+ld.City.toLowerCase()+').Flow_Territory__c: '+GDM_Map_City.get(ld.City.toLowerCase()).Flow_Territory__c);
                                ld.Territory_Name_2__c = GDM_Map_City.get(ld.City.toLowerCase()).Flow_Territory__c;
                            } // else continue with the next iteration
                        } else if (ld.RecordTypeId == UtilId && GDM_Map_City.size() > 0 && isDifferentTerritoriesUtil==false){
                            if(ld.State == currentState /*|| ld.StateCode.equals(currentStateCode)*/){
                                ld.Uterritory2__c = GDM_Map_City.get(ld.City.toLowerCase()).Uterritory_2__c;
                                ld.UTerritory_Name__c = GDM_Map_City.get(ld.City.toLowerCase()).Uterritory_Name__c;
                                ld.Territory_Name_2__c = GDM_Map_City.get(ld.City.toLowerCase()).Uterritory_Name__c;
                                ld.Population_Threshold__c = updatePopulationThresholdByCityState(GDM_Map_City.get(ld.City.toLowerCase()).Population_for_Zip__c);
                            }  // else continue with the next iteration
                        } else if(ld.RecordTypeId == UtilId && GDM_Map_City.size() > 0 && isDifferentTerritoriesUtil==true){ 
                            if(ld.State.equals(currentState) /*|| ld.StateCode.equals(currentStateCode)*/){
                                ld.Population_Threshold__c = updatePopulationThresholdByCityState(GDM_Map_Population.get(ld.City.toLowerCase()));
                            }  // else continue with the next iteration
                        }else if (isDifferentTerritoriesFlow==true){
                            // territoryName left blank and allow user to continue
                        } else {
                            // no change on territoryName or over threshold field
                            // Other unexpected scenarios: territoryName will be left blank
                        }
                    } else {} // do nothing since this is already handled on populateBasedOnZipcodes()
                }
        } else { }
    }
    
    public static boolean updatePopulationThresholdByCityState(Decimal maxPopn){
        if(maxPopn >= THRESHOLD) {
            return true;
        }
        return false;
    }
                                   
    public static Decimal determineHighestPopn(Decimal currentPopn, Decimal populationDensity){
        Decimal maxNumber=0;
        if(populationDensity>currentPopn){
            maxNumber = populationDensity;
        } else {
            maxNumber = currentPopn;
        }
        return maxNumber;
    }
}