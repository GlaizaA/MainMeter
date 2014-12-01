trigger LeadUpdate on Lead (before update) {    
    // test sandbox
    LeadTriggerManager.updateTerritoryName(trigger.new);    
}