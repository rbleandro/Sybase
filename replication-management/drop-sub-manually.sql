Symptom: In SAP Replication Server (SRS), 'drop subscription' command does not work.

Environment: SAP Replication Server (SRS) all versions

Workaround: Steps to remove a subscription manually if drop subscription fails.

Subscription information is stored in three tables in the Replication Server System Database (RSSD) for the primary and replicate SRS: rs_subscriptions, rs_rules, and rs_repdbs. 
The following procedure is used to manually remove subscriptions by deleting rows from these tables. It is a good idea to make a backup of the RSSD before performing the steps below.

Step1: Examine the subscription data:
{
	login to the dataserver that contains the RSSD (or eRSSD) for the primary SRS - login as the RSSD_primary_user
	use the RSSD database
	Examine the subscription data:

	select s.subname, s.subid, s.type, d.dbname, r.objname, s.dbid, s.pdbid
	from rs_subscriptions s, rs_objects r, rs_databases d
	where subname = "Target subscription name"
	and objname = "Replication definition name for target subscription"
	and dbname = "Replicae database name"
	and s.dbid = d.dbid
	and s.objid = r.objid

	If this query will be entered in primary SRS RSSD, replace "rs_databases" with "rs_repdbs".

	Output explanation:

	subname: subscription name
	subid: subscription id
	type: If the subscription has a "where" clause, there will be rows in rs_rules for this subscription, and rs_subscriptions.type will be 1 or 2
	dbid: replicate database id
	pdbid: primary database id
}
Step 2: Clean up rs_rules system table if the subscription has a where clause:
{
	select * from rs_rules where rs_rules.subid = <subid from step 1>
	go

	(if 0 rows returned, then no need to continue!)

	begin tran
	go

	delete from rs_rules
	where rs_rules.subid = <subid from Step 1>
	go

	select * from rs_rules where rs_rules.subid = <subid from step 1>
	go

	(should return 0 rows now. If not, abort tran)

	commit tran
	go
}
Step 3: Determine if this is the last/only subscription for this primary database:
{
	select * from rs_subscriptions where pdbid = <pdbid from Step 1> and dbid = <dbid from Step 1>
	go

	If above query returns two or more row, you can skip Step 4.
}
Step 4: Clean up of rs_repdbs system table (check the query in the appendix to quickly generate the delete commands for all databases)
{
	If the row of the subscription we want to delete is the only row returned, then this means that this is the only/last subscription for this primary database. Therefore, we want to delete the row for this database/subscription from rs_repdbs.

	begin tran
	go

	select * from rs_repdbs where dbid = <dbid from Step 1>
	go

	(should return 1 row now. If not, abort tran)

	delete from rs_repdbs where dbid = <dbid from Step 1>
	go

	select * from rs_repdbs where dbid = <dbid from Step 1>
	go

	(should return 0 rows--if not, abort tran)

	commit tran
	go
}
Step 5: Clean up rs_subscription system table (check the query in the appendix to quickly generate the delete commands for all databases)
{
	begin tran
	go

	delete from rs_subscriptions where subid = <subid from Step 1>
	go

	select * from rs_subscriptions where subid = <subid from Step 1>
	go

	(should return 0 rows now. If not, abort tran)

	commit tran
	go
}
Step 6: If you have multiple SAP Replication Servers that communicate via routes, perform the following steps:
{
	1) login to the dataserver that contains the RSSD for the replicate SRS
	2) use the RSSD database
	3) repeat step 1 above
	4) repeat step 2 above
	5) repeat step 5 above
}
Step 7:
{
	Always restart SRS and SAP Adaptive Server Enterprise (ASE) holding the RSSD after manually updating system tables.
}
Appendix:

select subname,dbid,pdbid
,'select * from rs_repdbs where dbid ='+cast(dbid as varchar(10))+'
select * from rs_subscriptions where pdbid='+cast(pdbid as varchar(10))+' and dbid='+cast(dbid as varchar(10))+'
GO' as 'select',
'delete from rs_repdbs where dbid ='+cast(dbid as varchar(10))+'
delete from rs_subscriptions where pdbid='+cast(pdbid as varchar(10))+' and dbid='+cast(dbid as varchar(10))+'
GO' as 'delete'
from rs_subscriptions where subname like 'CPDB4%'
go 