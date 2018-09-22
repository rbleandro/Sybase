/*
Decimal	Hex		Status
256		0x0100	Stored procedure created with execute as owner clause
512		0x0200	Stored procedure created with execute as caller clause
2048	0x0800	Table contains LOB compressed data
4096	0x1000	Table uses row-level compression
8192	0x2000	Table uses page-level compression
16384	0x4000	Table contains compressed data
32768	0x8000	Table participates in incremental transfer
*/

select name, sysstat3 
from sysobjects 
where sysstat3 & 2048=2048 or sysstat3&4096=4096 or sysstat3&8192=8192 or sysstat3&16384=16384
order by name