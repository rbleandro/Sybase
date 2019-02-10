#########################################################
#		RESOURCE TEMPLATE
#
# This file contains a list of configuration attributes
# for SAP Replication Server. This is the template for
# adding a database to the replication system. DO NOT EDIT THIS FILE. 
# Copy the template to another file and edit that.
#
# Syntax of the resource file is:
#
#	product_name.attribute:value
#
# Attributes with a value of USE_DEFAULT will use the Sybase
# defaults for this platform.
#
# NOTES:	
#   Generic attributes are prefaced by "sybinit." The
#   only generic attributes are "release_directory" and "product."
#    
#########################################################


#########################################################
#	RELEASE LOCATION
#
sybinit.release_directory: /opt/sybase

# The product that you wish to configure.  Possible values are:
#	rs
#
sybinit.product: rs


#############################################################
# REPLICATION SERVER ATTRIBUTES
#

# This operation adds a database to the replication system.
rs.rs_operation: rs_setup_db


#############################################################
# REPLICATION SERVER INFORMATION
#

# Replication Server name - this Server should be running.
rs.rs_name: hqvsybrep3

# sa login for this Replication Server - default is sa
rs.rs_rs_sa_user: sa

# sa password for this Replication Server
rs.rs_rs_sa_pass: 

#############################################################
# DATABASE INFORMAITON
#

# name of the Adaptive Server with the database that you are adding to 
# the replicated data system
rs.rs_ds_name: CPDB1

# sa login for this Adaptive Server - default sa
rs.rs_ds_sa_user: USE_DEFAULT

# sa password for this Adaptive Server
rs.rs_ds_sa_password: 

# name of the database that you are adding to the replicated data system
rs.rs_db_name: rev_hist_lm

# will this database hold primary data, or will asynchronous transactions
# originate in this database(assume Repserver is 11.0 or higher)
rs.rs_needs_repagent: yes

# will this database hold primary data, or will asynchronous transactions
# originate in this database(assume Repserver is 11.0 or higher)
rs.rs_requires_ltm: no

# name of the user who will update replicated data 
# default <rs_db_name>_maint
rs.rs_db_maint_user: USE_DEFAULT

# password for this user who will update replicated data 
# This is a required field
rs.rs_db_maint_password: sybase

# The dbo_user and dbo_password attributes are not used by default. They
# should be used only if the database requires an LTM and the log should be 
# scanned by someone other than rs_ds_sa_user. This user should already 
# exist in the database.

# name of the Database Owner for this database
rs.rs_db_dbo_user: USE_DEFAULT

# password for the database owner
rs.rs_db_dbo_password:

#############################################################
# RSSD LOG TRANSFER MANAGER INFORMATION 
#

# RSSD LTM name - default is <rs_ds_name>_<rs_db_name>_ltm
rs.ltm_name: USE_DEFAULT

# The values for the next two attributes should match the values that were 
# used while installing the Replication Server and cannot be changed here.

# Replication Server login name that the log transfer manager
# will use when connecting to the Replication Server
# Default is <rs_name>_ltm
rs.rs_ltm_rs_user: hqvsybrep3_ra

# the password for the login name for the log transfer manager
rs.rs_ltm_rs_pass: 

# the login name for the user who will start and shutdown the log
# transfer manager for this database
# Default is sa
rs.rs_ltm_admin_user: USE_DEFAULT

# the password for the admin user 
rs.rs_ltm_admin_pass: 

# Locations of the errorlog and config file for the LTM.
# The default names of these files are <ltm_name>.log and <ltm_name>.cfg
# respectively.
# The default directory in which these files are located is the current
# working directory on Unix platforms, and in %SYBASE%\install on PC platforms.
rs.rs_ltm_errorlog: USE_DEFAULT
rs.rs_ltm_cfg_file: USE_DEFAULT

# is password encryption enabled for this LTM ? Default is no
rs.rs_ltm_pwd_encryption: no

# the charset used by the LTM
rs.rs_charset: USE_DEFAULT

# the language used by the LTM
rs.rs_language: USE_DEFAULT

# the sort-order used by the LTM
rs.rs_sortorder: USE_DEFAULT

#############################################################
# Logical Connection info for Warm Standby
# only use this section of the template if creating an active/standby
#    for a logical connection
#

# is this a physical for logical connection :yes if physical connection
# is being created. No if old style connection is being created
# Default is no
rs.rs_db_physical_for_logical: no

# is this an active or standby. Only used if rs_db_physical_for_logical is 'yes'
rs.rs_db_active_or_standby: standby

# Logical DS Name. Only used if rs_db_physical_for_logical is 'yes'
rs.rs_db_logical_ds_name: logical_ds_name

# Logical DB Name. Only used if rs_db_physical_for_logical is 'yes'
rs.rs_db_logical_db_name: logical_db_name

# Active DS name. Only used if rs_db_physical_for_logical is 
# 'yes' and rs_db_active_or_standby is 'standby'
rs.rs_db_active_ds_name: active_sqlds

# Active DB name. Only used if rs_db_physical_for_logical is 
# 'yes' and rs_db_active_or_standby is 'standby'
rs.rs_db_active_db_name: active_sqldb

# Active sa name. Only used if rs_db_physical_for_logical is 
# 'yes' and rs_db_active_or_standby is 'standby'
rs.rs_db_active_sa: sa

# Active sa password. Only used if rs_db_physical_for_logical is 
# 'yes' and rs_db_active_or_standby is 'standby'
rs.rs_db_active_sa_pw: sa

# Initialize standby by using dump/load of the active database or dump load
# with subsequent transaction dumps. Only used if
# rs_db_physical_for_logical is 
# 'yes' and rs_db_active_or_standby is 'standby'
rs.rs_init_by_dump: yes

# Use dump marker to start replicating when creating standby. Only used if 
# rs_db_physical_for_logical is 
# 'yes' and rs_db_active_or_standby is 'standby' and rs_init_by_dump is 
# 'yes'
rs.rs_db_use_dmp_marker: yes

#############################################################
# REPLICATION SERVER INTERFACES INFORMATION 
# These attributes are valid only for Unix platforms. On PC platforms,
# adding interface file entries through resource files is not supported.
# rs.do_add_replication_server must be no on these platforms.
#

# add Replication Server to interfaces file?
rs.do_add_replication_server: no

# connect retry count; number of times client tries to connect
# to Replication Server before giving up
rs.rs_rs_connect_retry_count: USE_DEFAULT

# connect retry delay time (in seconds); amount of time client
# waits between each connection attempt
rs.rs_rs_connect_retry_delay_time: USE_DEFAULT

# notes associated with Replication Server interfaces file entry
rs.rs_rs_notes: Default Sybase Configuration

# protocol for Replication Server network listener
rs.rs_rs_network_protocol_list: tcp

# name of host for Replication Server
rs.rs_rs_hostname:  herbie

# port numbers for network listener
rs.rs_rs_port: 5005

#############################################################
# LOG TRANSFER MANAGER INTERFACES INFORMATION 
# These attributes are valid only for Unix platforms. On PC platforms,
# adding interface file entries through resource files is not supported.
# rs.do_add_ltm must be no on these platforms.
#

# Add Log Transfer Manager to interfaces file?
rs.do_add_ltm: no

# Connect retry count; number of times client tries to connect
# to Log Transfer Manager before giving up
rs.rs_ltm_connect_retry_count: USE_DEFAULT

# Connect retry delay time (in seconds); amount of time client
# waits between each connection attempt
rs.rs_ltm_connect_retry_delay_time: USE_DEFAULT

# Notes associated with Log Transfer Manager interfaces file entry
rs.rs_ltm_notes: Default Sybase Configuration

# Protocol for Log Transfer Manager network listener
rs.rs_ltm_network_protocol_list: tcp

# Name of host for Log Transfer Manager
rs.rs_ltm_hostname:  herbie

# Port numbers for network listener
rs.rs_ltm_port: 5000

# end of resource file
