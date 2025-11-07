WITH
    history
    AS
    (
        SELECT
            [caseid] ticketid
        , [newvalue] assigned_to
      , MAX(CAST(createddate AS DATETIME) + CAST(createdtime AS DATETIME)) last_assignment
      , MIN(CAST(createddate AS DATETIME) + CAST(createdtime AS DATETIME)) first_assignment
        FROM [rpt_squaretrade].[dbo].[view_ticket_history] h

        WHERE   h.field LIKE '%wner%' AND
            h.oldvalue LIKE '00%' AND
            h.newvalue LIKE '00%'
        GROUP BY caseid, newvalue
    )

SELECT TOP (1000)
    t.[id] AS "ticket_id"
      , [casenumber] ticket_number
      , t.[type]
      , t.record_Type
      , [reason]
      , t.[status]
      , [subject]
      , [priority]
      , [closed_date]
      , CAST(t.[closed_date] AS DATETIME) + CAST(closed_time AS DATETIME) Closed_Date_Time
      , [owner_id]
      , o.[name] current_owner
      , h.first_assignment
      , h.last_assignment
      , t.[created_date]
      , CAST(t.[created_date] AS DATETIME) + CAST(created_time AS DATETIME) Created_Date_Time
      , t.[lastmodified_date]
      , CAST(t.[lastmodified_date] AS DATETIME) + CAST(t.[lastmodified_time] AS DATETIME) Last_Modified_Date_Time
      , [case_reason_detail]
      , cl.claim_name AS "ClaimID"
      , cl.approvallocation
      , [use_st_funds__c]
      , [payout_cost__c]
      , [resolution_completion_date__c]
      , w.kb_subscriptionid
      , [primary_escalation_role__c]
      , [escalation_source__c]
      , [escalation_status__c]
      , [resolution_outcome_notes__c]
      , [customer_sentiment__c]
      , [primary_escalation_reason_detail__c]
      , [primary_escalation_reason__c]
      , [reason_for_qa_request__c]
      , [escalation_source_confirm__c]
      , [complaint_escalated_to_ombudsman__c]
      , [complaint__c]
      , [date_acknowledgement_letter_sent__c]
      , [not_required]
      , [escalation_type__c]
      , [squaretrade_id__c]
      , [warranty_seller__c]
      , [purchase_date__c]
      , [insurer__c]
      , disposition__c
FROM [rpt_squaretrade].[dbo].[view_ticket] t
    LEFT JOIN view_dim_owner o ON t.owner_id=o.id
    LEFT JOIN history h ON t.id=h.ticketid
        AND t.owner_id=h.assigned_to
    LEFT JOIN view_claims cl ON cl.id=t.claim__c
    LEFT JOIN view_warranties w ON t.squaretrade_id__c=w.name
WHERE t.lastmodified_date >= '2025-01-01'
    AND t.[record_Type] = 'EU Support'