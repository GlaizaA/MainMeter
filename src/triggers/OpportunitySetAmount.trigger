trigger OpportunitySetAmount on Opportunity (before update, after insert) {
    if(Trigger.isBefore && Trigger.isUpdate){
        OpportunityHelper.setTotalAmountBasedOnQuotes(trigger.new);
    }
}