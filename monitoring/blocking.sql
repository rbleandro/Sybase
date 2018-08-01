--select count(*) as connected_processes from master..sysprocesses
--select count(*) as total_locks from master.dbo.syslocks l, master.dbo.sysprocesses p, master.dbo.spt_values v where l.spid=p.spid and l.type=v.number and v.type='L'

SELECT
	H.spid 'hspid',
	H.fid 'hfid',
	SUSER_NAME(H.suid) 'huser',
	H.status 'hstatus',
	H.hostname 'hhost',
	H.program_name 'hprogram',
	H.cmd 'hcmd',
	H.cpu 'hcpu',
	H.physical_io 'hphys_io',
	H.memusage 'hmemory',
	H.tran_name 'htranname' 
	,query_text(H.spid)
	W.hostname 'whost',
	W.program_name 'wprogram',
	W.cmd 'wcmd',
	W.spid 'wspid',
	W.fid 'wfid',
	SUSER_NAME(W.suid) 'wuser',
	W.time_blocked 'wtimeblocked'
	,query_text(W.spid)
	
FROM
	master.dbo.sysprocesses H,
	master.dbo.sysprocesses W 
WHERE
	H.spid=W.blocked AND
	H.blocked = 0 
ORDER BY
	W.time_blocked DESC,
	H.spid,
	W.spid