<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Proposal%5CBid Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Proposal_Bid_Expiration__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Proposal_Bid_Expiration_Reminder__c</field>
            <operation>equals</operation>
            <value>30 Days</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Proposal_Bid_Expiration_in_30_Days</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.Proposal_Bid_Expiration__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Proposal_Bid_Expiration_in_30_Days</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Proposal\Bid Expiration in 30 Days</subject>
    </tasks>
    <tasks>
        <fullName>Send_Reminder</fullName>
        <assignedToType>creator</assignedToType>
        <description>To send 1 year anniversary reminder to calibrate product on the Opportunity being won.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.LastLoginDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Reminder</subject>
    </tasks>
    <tasks>
        <fullName>To_send_Thank_You</fullName>
        <assignedToType>creator</assignedToType>
        <description>To send thank you message as opportunity is won</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>To send Thank You</subject>
    </tasks>
</Workflow>
