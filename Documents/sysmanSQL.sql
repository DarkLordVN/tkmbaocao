------Insert vào bảng historyCustomReport
INSERT INTO HistoryCustomReport(itemid,value_min,value_avg,value_max,createdDate,maxClock,minClock) 
SELECT itemid, min(value) minval, avg(value) avgval, max(value) maxval, clockConvert, max(clock) maxclock, min(clock) minclock FROM (SELECT *, CAST(dateadd(s, convert(bigint, clock), convert(datetime, '1-1-1970 7:00:00')) AS DATE) clockConvert FROM history WHERE clock > (SELECT CASE WHEN max(maxclock) IS NULL THEN 0 ELSE max(maxclock) END FROM HistoryCustomReport)) tblAll GROUP BY itemid, clockConvert

INSERT INTO HistoryCustomReport(itemid,value_min,value_avg,value_max,createdDate,maxClock,minClock) 
SELECT itemid, min(value_min) minval, avg(value_avg) avgval, max(value_max) maxval, clockConvert, max(clock) maxclock, min(clock) minclock FROM (SELECT *, CAST(dateadd(s, convert(bigint, clock), convert(datetime, '1-1-1970 7:00:00')) AS DATE) clockConvert FROM trends WHERE clock < (SELECT min(clock) FROM history)) tblAll GROUP BY itemid, clockConvert

UPDATE HistoryCustomReport SET value_min = t1.minval, value_avg = t1.avgval, value_max = t1.maxval, createdDate = t1.clockConvert, maxClock = t1.maxclock, minClock = t1.minclock FROM (SELECT itemid, min(value) minval, avg(value) avgval, max(value) maxval, clockConvert, max(clock) maxclock, min(clock) minclock FROM (SELECT *, CAST(dateadd(s, convert(bigint, clock), convert(datetime, '1-1-1970 7:00:00')) AS DATE) clockConvert FROM history WHERE clock >= CAST(Datediff(s, '1970-01-01 7:00:00', CAST(GETDATE() AS DATE) ) AS BIGINT)) tblAll GROUP BY itemid, clockConvert) t1 JOIN HistoryCustomReport t2 ON t1.itemid = t2.itemid AND t1.clockConvert = t2.createdDate


--Delete duplicate
DELETE FROM HistoryCustomReport WHERE %%physloc%% IN (SELECT rowid FROM (SELECT %%physloc%% AS rowid,*, 
        ROW_NUMBER() OVER(PARTITION BY itemid, createdDate
        ORDER BY itemid) rank
 FROM HistoryCustomReport) tAll WHERE rank > 1)

------------------
SELECT *,  dateadd(s, convert(bigint, clock), convert(datetime, '1-1-1970 07:00:00')), CAST(Datediff(s, '1970-01-01', dateadd(s, convert(bigint, clock), convert(datetime, '1-1-1970 07:00:00'))) AS BIGINT) clockConvert
FROM trends t1 
WHERE itemid IN (SELECT itemid FROM items where key_ LIKE '%cpu.%') and itemid = 35071 order by clock desc


----------------------------------------------------------------------


SELECT * FROM (SELECT (SELECT name FROM hosts WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) tenthietbi,
(SELECT ip FROM interface WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) ip,
(SELECT name FROM items WHERE itemid = t1.itemid) item_name, MIN(value_min) minval, AVG(value_avg) avgval, MAX(value_max) maxval
	FROM trends_uint t1 
	WHERE itemid IN (SELECT itemid FROM items
		where lower(key_) like '%net.if%' OR lower(name)  like '%incoming%') GROUP BY itemid) tblAll ORDER BY tblAll.maxval desc;	
-----6.3
SELECT t1.name, (SELECT ip FROM interface WHERE hostid = t1.hostid) ip,
(SELECT COUNT(*) FROM applications WHERE hostid = t1.hostid) capplication,
(SELECT COUNT(*) FROM items WHERE hostid = t1.hostid) citem,
(SELECT COUNT(triggerid) FROM functions WHERE itemid IN (SELECT itemid FROM items WHERE hostid = t1.hostid)) ctrigger
FROM hosts t1 WHERE t1.hostid IN (SELECT hostid FROM hstgrp WHERE groupid IN (SELECT groupid FROM hstgrp WHERE lower(name) NOT LIKE 'templates/%')) 
AND lower(name) NOT LIKE '%template%' ORDER BY name;
SELECT * FROM functions LIMIT 10;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-666-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-----count theo group thiet bi
SELECT (SELECT name FROM hstgrp WHERE groupid = t1.groupid) group_name, COUNT(*) FROM hosts_groups t1 WHERE groupid IN (SELECT groupid FROM hstgrp WHERE name NOT LIKE 'Templates/%') GROUP BY groupid ORDER BY group_name;
-------------------web monitor
SELECT * FROM httpstep t1, httptest t2 WHERE t1.httptestid = t2.httptestid;

SELECT * FROM httptestitem;


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-11111111-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
----------1.1 su dung cpu, ram => search theo application
--cpu, mem[key]: ram, bang thong: net.in net.out
SELECT * FROM (SELECT (SELECT name FROM hosts WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) tenthietbi,
(SELECT ip FROM interface WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) ip,
(SELECT name FROM items WHERE itemid = t1.itemid) item_name, MIN(value_min) minval, AVG(value_avg), MAX(value_max) 
	FROM trends t1 
	WHERE itemid IN (SELECT itemid FROM items_applications 
		where applicationid IN (SELECT applicationid FROM applications 
			WHERE lower(name) like '%cpu%')) GROUP BY itemid) tblAll ORDER BY tblAll.max desc;
----------1.1 su dung cpu, ram => search theo ten items
SELECT * FROM (SELECT (SELECT name FROM hosts WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) tenthietbi,
(SELECT ip FROM interface WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) ip,
(SELECT name FROM items WHERE itemid = t1.itemid) item_name, MIN(value_min) minval, AVG(value_avg), MAX(value_max) 
	FROM trends t1 
	WHERE itemid IN (SELECT itemid FROM items
		where lower(key_) like '%net.inss%' OR lower(name)  like '%incoming%') GROUP BY itemid) tblAll ORDER BY tblAll.max desc;		
---1.3 SELECT theo history
SELECT (SELECT name FROM hosts WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) tenthietbi,
(SELECT ip FROM interface WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) ip,
(SELECT name FROM items WHERE itemid = t1.itemid) item_name, to_timestamp(t1.clock), t1.* FROM history_uint t1 WHERE itemid IN (SELECT itemid FROM items
		where lower(name) like '%disk space%') ORDER BY clock desc;
		--GROUP BY itemid;

----------
SELECT * FROM (SELECT (SELECT name FROM hosts WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) tenthietbi,
(SELECT ip FROM interface WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) ip,
(SELECT name FROM items WHERE itemid = t1.itemid) item_name, AVG(value_min) min, AVG(value_max) max
	FROM trends t1 
	WHERE itemid IN (SELECT itemid FROM items
		where lower(key_) like '%d_free%' OR lower(name)  like '%usage%') GROUP BY itemid) tblAll ORDER BY tblAll.tenthietbi desc;		
-------------------------
SELECT * FROM (SELECT (SELECT name FROM hosts WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) tenthietbi,
(SELECT ip FROM interface WHERE hostid IN (SELECT hostid FROM items WHERE itemid = t1.itemid)) ip,
(SELECT name FROM items WHERE itemid = t1.itemid) item_name, t1.* FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY itemid ORDER BY clock DESC) AS rn
   FROM trends) t1 WHERE t1.rn = 1) tblAll;


SELECT DISTINCT units FROM items;
SELECT * FROM items;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-22222222-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
----Co recovery time tuc la hoan thanh
SELECT * FROM problem where objectid in (SELECT triggerid from triggers);
SELECT t4.groupid, t7.name, COUNT(t1.eventid), COUNT(CASE WHEN t2.priority = 4 THEN 1 ELSE null END) phigh, 
COUNT(CASE WHEN t2.priority = 2 THEN 1 ELSE null END) paverage FROM problem t1, triggers t2, hosts t3, hosts_groups t4, functions t5, items t6, hstgrp t7
WHERE t1.objectid = t2.triggerid AND t3.hostid = t4.hostid AND t2.triggerid = t5.triggerid 
AND t6.itemid = t5.itemid AND t6.hostid = t3.hostid AND t7.groupid = t4.groupid AND t2.status = 0
GROUP BY t4.groupid, t7.name ORDER BY t7.name;

SELECT t3.name tenthietbi, TO_timestamp(t1.clock) FROM problem t1, triggers t2, hosts t3, hosts_groups t4, functions t5, items t6, hstgrp t7
WHERE t1.objectid = t2.triggerid AND t3.hostid = t4.hostid AND t2.triggerid = t5.triggerid 
AND t6.itemid = t5.itemid AND t6.hostid = t3.hostid AND t7.groupid = t4.groupid AND t2.status = 0 ORDER BY t7.name;


SELECT t9.* FROM problem t1, triggers t2, hosts t3, hosts_groups t4, functions t5, items t6, hstgrp t7, items t8, events t9
WHERE t1.objectid = t2.triggerid AND t3.hostid = t4.hostid AND t2.triggerid = t5.triggerid AND t8.itemid = t5.itemid AND t1.eventid = t9.eventid
AND t6.itemid = t5.itemid AND t6.hostid = t3.hostid AND t7.groupid = t4.groupid AND t4.groupid = 39 AND t2.priority = 2 ORDER BY t7.name;
SELECT * FROM hosts_groups; 
SELECT * FROM events LIMIT 10; 
SELECT * FROM problem LIMIT 10; 
SELECT * FROM triggers LIMIT 10; 
SELECT * FROM hosts LIMIT 10; 
SELECT * FROM hstgrp LIMIT 10; 
SELECT * FROM hosts_groups LIMIT 10; 
SELECT * FROM functions;
SELECT COUNT(*) FROM events t1, triggers t2 WHERE t1.objectid = t2.triggerid;

-------------
SELECT * FROM functions;
--trigger function items => hosts
SELECT COUNT(*) FROM functions WHERE itemid IN (SELECT itemid FROM items WHERE hostid = t1.hostid)


SELECT COUNT(*) FROM (SELECT DISTINCT objectid FROM trigger_depends) a;
SELECT COUNT(*) FROM events t1;
SELECT * FROM event_tag;
SELECT * FROM events WHERE objectid NOT IN (SELECT functionid FROM functions);
SELECT * FROM problem_tag;
SELECT * FROM trigger_discovery;
SELECT * FROM trigger_depends;
SELECT * FROM triggers where triggerid = 13503;
SELECT * FROM triggers where triggerid NOT IN (SELECT itemid FROM items);
select * from items where itemid = 13084;
SELECT * FROM graph_discovery;
SELECT * FROM history;
SELECT * FROM trigger_depends;


select * from history LIMIT 10;
select * from history_str LIMIT 10;
select * from history_uint LIMIT 10;
select tu.*, ROUND(value_min / (1024*1024*1024), 2) gb from trends_uint tu  WHERE itemid = 28739 ORDER BY clock desc;
SELECT * FROM items where itemid = 28739;
select * from trends_uint LIMIT 10;

SELECT * FROM trigger_tag;
where itemid = 28739;
--host group
SELECT * FROM hosts_groups WHERE hostid = 10408;
SELECT * FROM hstgrp WHERE groupid IN (SELECT groupid from hosts_groups) AND name NOT LIKE 'Templates/%' ORDER BY name;
SELECT * FROM hosts_groups WHERE groupid IN (SELECT groupid FROM hstgrp WHERE name NOT LIKE 'Templates/%');
SELECT (SELECT name FROM hosts_groups ) groupname,hs.* FROM hosts hs;
--select host info
SELECT (SELECT ip from interface Where hostid = h.hostid LIMIT 1) ip,h.* FROM hosts h WHERE hostid IN (SELECT hostid FROM hosts_groups WHERE groupid IN (SELECT groupid FROM hstgrp WHERE name NOT LIKE 'Templates/%'));
--ip
SELECT * FROM interface;

--thong tin chay theo item
SELECT * FROM history LIMIT 10;
SELECT * FROM items where lower(name) like '%cpu%';
SELECT s.*, to_timestamp(clock) FROM trends s LIMIT 10;
SELECT COUNT(*) FROM trends;
SELECT * FROM applications;
--select item theo tên nhóm
SELECT * FROM items WHERE itemid IN (SELECT itemid FROM items_applications where applicationid IN (SELECT applicationid FROM applications WHERE lower(name) like '%cpu%'));
SELECT itemid FROM items_applications where applicationid IN (SELECT applicationid FROM applications WHERE lower(name) like '%cpu%');

--select theo ten application
SELECT * FROM items_applications WHERE applicationid IN (SELECT applicationid FROM applications WHERE lower(name) like '%cpu%');



SELECT 'SELECT COUNT(*), '''|| table_name ||''' tablename FROM ' || table_name || ' UNION ALL ' 
FROM information_schema.tables WHERE table_schema = 'public' order by table_name;

SELECT * FROM hosts_groups;
SELECT * FROM hosts;
SELECT * FROM host_discovery;
SELECT * FROM interface;
SELECT * FROM profiles;

SELECT * FROM alerts;

SELECT * FROM ;
SELECT * FROM alerts;

--  WHERE itemid = 16129

SELECT * FROM actions where itemid = 10009;
--van de objectid = 16129
SELECT * FROM actions;
SELECT * FROM problem;
SELECT * FROM problem_tag;
SELECT * FROM events where eventid = 936571;

SELECT * FROM hostmacro;
SELECT * FROM hosts where hostid = 16129;


--10679105 records
SELECT COUNT(*) FROM trends;

SELECT * FROM triggers;
SELECT * FROM trigger_tag;
SELECT * FROM trigger_depends;

--phan quyen xem dashboard
SELECT * FROM dashboard;
SELECT * FROM dashboard_usrgrp;
--nguoi dung
SELECT * FROM users;
SELECT * FROM users_groups;
SELECT * FROM usrgrp;
