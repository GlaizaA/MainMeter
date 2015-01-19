<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Customer_Number_Creation_for_Prospect_Account</fullName>
        <ccEmails>lrippey@badgermeter.com.test</ccEmails>
        <ccEmails>jolmstead@badgermeter.com.test</ccEmails>
        <ccEmails>hhall-maison@badgermeter.com.test</ccEmails>
        <ccEmails>jcrumer-pascale@badgermeter.com.test</ccEmails>
        <ccEmails>jason.esterl@cloudsherpas.com</ccEmails>
        <description>Customer Number Creation for Prospect Account</description>
        <protected>false</protected>
        <recipients>
            <recipient>lbrushaber@badgermeter.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mholm@badgermeter.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Badger_Meter_Custom_Email_Templates/Badger_Meter_Customer_Number_Population_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Set_Owner_to_Director_of_Sales</fullName>
        <field>OwnerId</field>
        <lookupValue>kstoll@badgermeter.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account Set Owner to Director of Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_Account_to_Active</fullName>
        <field>Active__c</field>
        <literalValue>1</literalValue>
        <name>Update Customer Account to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Customer Account Active</fullName>
        <actions>
            <name>Update_Customer_Account_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Number Notification</fullName>
        <actions>
            <name>Customer_Number_Creation_for_Prospect_Account</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
