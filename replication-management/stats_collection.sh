#! /bin/sh

if [ $# -eq 0 ]
then
echo Usage
echo $0 bcp_out
exit
fi

if [ $# -eq 1 ] && [ $1 = bcp_out ]
then
#echo rssd_serververname?    ; read ds ; export ds
#echo rssd_databasename?     ; read db ; export db
#echo rssd_username?         ; read u  ; export u
#echo rssd_password?         ; read p  ; export p
export ds=hqvsybrep2_erssd
export db=hqvsybrep2_erssd
export  u=hqvsybrep2_RSSD_prim
export  p=sybase

mkdir out ; chmod 777 out
for a in `$0 bcp_out tbl_list`
do
$0 $1 $a
done
chmod 644 out/*.bcp
echo;echo;echo
exit
fi


if [ $# -eq 2 ] && [ $1 = bcp_out ] && [ $2 = tbl_list ]
then
echo rs_articles
echo rs_asyncfuncs
echo rs_classes
echo rs_clsfunctions
echo rs_columns
echo rs_config
echo rs_databases
echo rs_datatype
echo rs_dbreps
echo rs_dbsubsets
echo rs_diskaffinity
echo rs_diskpartitions
echo rs_erroractions
# echo rs_exceptscmd  -- Usually not necessary
# echo rs_exceptshdr  -- Usually not necessary
echo rs_exceptslast
echo rs_functions
echo rs_funcstrings
echo rs_locater
echo rs_msgs
echo rs_objects
echo rs_objfunctions
echo rs_oqid
echo rs_profdetail
echo rs_profile
echo rs_publications
echo rs_queues
echo rs_recovery
echo rs_repdbs
echo rs_repobjs
echo rs_routes
echo rs_routeversions
echo rs_rules
echo rs_scheduletxt
echo rs_schedule
echo rs_segments
echo rs_sites
echo rs_statcounters
echo rs_statdetail
echo rs_statrun
echo rs_subscriptions
# echo rs_systext   -- Usually not necessary
echo rs_targetobjs
echo rs_tbconfig
echo rs_translation
echo rs_tvalues
echo rs_users
echo rs_version
echo rs_whereclauses
exit
fi


if [ $# -eq 2 ] && [ $1 = bcp_out ]
then
echo bcp $db..$2 out out/$2.bcp -U $u -P $p -S $ds -b1000 -c -t\"\|\"
bcp $db..$2 out out/$2.bcp -U $u -P $p -S $ds -b1000 -c -t\"\|\"
exit
fi

