--GET USER AND ITS MAPPINGS INSIDE THE DATABASE
SELECT
	u.name,
	l.name,
	g.name,
	CASE l.status 
		WHEN null 
		THEN 0 
		ELSE l.status 
	END,
	o.name 
FROM
	sysusers u 
		LEFT JOIN master..syslogins l 
		ON u.suid = l.suid 
			LEFT JOIN sysusers g 
			ON u.gid = g.uid 
				LEFT JOIN sysalternates a 
				ON u.suid = a.altsuid 
					LEFT JOIN master..syslogins o 
					ON a.suid = o.suid 
WHERE
	u.suid != -2 AND
	u.uid != u.gid AND
	(u.name = 'webpool_dispatch' or l.name='webpool_dispatch') 
ORDER BY
	u.name
	
go