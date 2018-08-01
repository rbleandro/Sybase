SELECT
	DISTINCT c.name,
	ut.name,
	c.length,
	o.name,
	o.type,
	c.prec,
	c.scale,
	nulls = convert(bit, (c.status & 8)),
	cd.text,
	u.name,
	ident = convert(bit, (c.status & 0x80)),
	user_name(d.uid),
	d.name,
	o.sysstat2,
	t.name,
	a.char_value objpath,
	v.name externType,
	ct.text,
	@@ncharsize,
	@@unicharsize,
	r.name rulename,
	user_name(r.uid) ruleowner,
	c.inrowlen,
	c.status2,
	c.lobcomp_lvl,
	cd.status,
	cd.id,
	t.usertype 
FROM
	dbo.syscolumns c 
		LEFT JOIN dbo.sysobjects o 
		ON c.id = o.id 
			LEFT JOIN dbo.sysusers u 
			ON o.uid = u.uid 
				LEFT JOIN dbo.sysattributes a 
				ON (a.object_type = 'OD' AND
				o.name = a.object_cinfo) 
					LEFT JOIN master.dbo.spt_values v 
					ON (a.object_info2 = v.number AND
					v.type = 'Y' AND
					v.name != 'view') 
						LEFT JOIN dbo.syscomments ct 
						ON c.computedcol = ct.id 
							LEFT JOIN dbo.systypes t 
							ON c.usertype = t.usertype 
								LEFT JOIN dbo.systypes ut 
								ON (t.type = ut.type AND
								ut.usertype < 100 AND
								((t.usertype > 99 AND
								ut.name not in ('sysname',
								'longsysname',
								'nchar',
								'nvarchar')) or
								t.usertype = ut.usertype)) 
									LEFT JOIN dbo.sysobjects d 
									ON (c.cdefault = d.id AND
									d.type = 'D' AND
									t.tdefault != d.id) 
										LEFT JOIN dbo.syscomments cd 
										ON (d.id = cd.id AND
										cd.texttype = 0) 
											LEFT JOIN dbo.sysobjects r 
											ON (c.domain = r.id AND
											r.type = 'R' AND
											t.domain != r.id AND
											(	SELECT
													sc.constrid 
												from
													dbo.sysconstraints sc 
												WHERE
													sc.constrid = r.id) IS NULL) 
WHERE
	(c.status3 & 1) = 0 AND
	o.type IN (N'U',
	N'S',
	N'V',
	N'RS') AND
	o.name = 'tttl_ie_international_events' AND
	u.name = 'dbo' 
ORDER BY
	c.colid,
	ct.colid