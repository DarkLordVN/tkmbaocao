SELECT t1.name, (SELECT ip FROM interface WHERE hostid = t1.hostid) ip,
(SELECT COUNT(*) FROM applications WHERE hostid = t1.hostid) capplication,
(SELECT COUNT(*) FROM items WHERE hostid = t1.hostid) citem,
(SELECT COUNT(triggerid) FROM functions WHERE itemid IN (SELECT itemid FROM items WHERE hostid = t1.hostid)) ctrigger
FROM hosts t1 WHERE t1.hostid IN (SELECT hostid FROM hstgrp WHERE groupid IN (SELECT groupid FROM hstgrp WHERE lower(name) NOT LIKE 'templates/%')) 
AND lower(name) NOT LIKE '%template%' ORDER BY name;


SELECT groupname, groupid, (SELECT COUNT(*) FROM problem)  FROM (
SELECT t3.groupid, t3.name groupname, t1.name hostname FROM hosts t1, hosts_groups t2, hstgrp t3 
WHERE t1.hostid = t2.hostid AND t2.groupid = t3.groupid AND lower(t3.name) NOT LIKE '%template%') tbl1 GROUP BY groupid, groupname;


SELECT t4.groupid, t7.name, COUNT(t1.eventid), COUNT(CASE WHEN t2.priority = 4 THEN 1 ELSE null END) phigh, 
COUNT(CASE WHEN t2.priority = 2 THEN 1 ELSE null END) paverage FROM problem t1, triggers t2, hosts t3, hosts_groups t4, functions t5, items t6, hstgrp t7
WHERE t1.objectid = t2.triggerid AND t3.hostid = t4.hostid AND t2.triggerid = t5.triggerid 
AND t6.itemid = t5.itemid AND t6.hostid = t3.hostid AND t7.groupid = t4.groupid AND t2.status = 0
GROUP BY t4.groupid, t7.name ORDER BY t7.name;

SELECT groupname, COUNT(eventid) tongvande, SUM(CASE WHEN r_eventid IS NULL THEN 1 ELSE 0 END) chuaxuly, SUM(CASE WHEN r_eventid IS NOT NULL THEN 1 ELSE 0 END) daxuly FROM (
SELECT t7.name groupname, t7.groupid grid,t1.r_eventid, t1.eventid FROM problem t1, triggers t2, hosts t3, hosts_groups t4, functions t5, items t6, hstgrp t7, items t8, events t9 WHERE t1.objectid = t2.triggerid AND t3.hostid = t4.hostid AND t2.triggerid = t5.triggerid AND t8.itemid = t5.itemid AND t1.eventid = t9.eventid AND t6.itemid = t5.itemid AND t6.hostid = t3.hostid AND t7.groupid = t4.groupid) tblAll GROUP BY groupname;

SELECT t1.clock, dateadd(s, t1.clock, convert(datetime, '1-1-1970 00:00:00')), CURRENT_TIMESTAMP, CAST(Datediff(s, '1970-01-01', CURRENT_TIMESTAMP) AS BIGINT), CAST(Datediff(s, '1970-01-01', dateadd(s, t1.clock, convert(datetime, '1-1-1970 00:00:00'))) AS BIGINT), t1.clock FROM problem t1, triggers t2, hosts t3, hosts_groups t4, functions t5, items t6, hstgrp t7, items t8, events t9 WHERE t1.objectid = t2.triggerid AND t3.hostid = t4.hostid AND t2.triggerid = t5.triggerid AND t8.itemid = t5.itemid AND t1.eventid = t9.eventid AND t6.itemid = t5.itemid AND t6.hostid = t3.hostid AND t7.groupid = t4.groupid;

SELECT COUNT(*) FROM (SELECT DISTINCT t1.objectid FROM problem t1, triggers t2, hosts t3, hosts_groups t4, functions t5, items t6, hstgrp t7, items t8, events t9 WHERE t1.objectid = t2.triggerid AND t3.hostid = t4.hostid AND t2.triggerid = t5.triggerid AND t8.itemid = t5.itemid AND t1.eventid = t9.eventid AND t6.itemid = t5.itemid AND t6.hostid = t3.hostid AND t7.groupid = t4.groupid AND lower(t7.name) NOT LIKE '%template%') a;

SELECT groupname, COUNT(eventid) tongvande, SUM(CASE WHEN r_eventid IS NULL THEN 1 ELSE 0 END) chuaxuly, SUM(CASE WHEN r_eventid IS NOT NULL THEN 1 ELSE 0 END) daxuly FROM (SELECT ROW_NUMBER() OVER (PARTITION BY t1.objectid ORDER BY t1.clock DESC) rnum,t7.name groupname, t7.groupid grid,t1.r_eventid, t1.eventid, t1.severity, t1.clock FROM problem t1, triggers t2, hosts t3, hosts_groups t4, functions t5, items t6, hstgrp t7, items t8, events t9 WHERE t1.objectid = t2.triggerid AND t3.hostid = t4.hostid AND t2.triggerid = t5.triggerid AND t8.itemid = t5.itemid AND t1.eventid = t9.eventid AND t6.itemid = t5.itemid AND t6.hostid = t3.hostid AND t7.groupid = t4.groupid AND lower(t7.name) NOT LIKE '%template%') tblAll WHERE rnum = 1 AND r_eventid IS NULL AND clock > 10000 GROUP BY groupname;



SELeCT * FROM problem where eventid IN (976781,962042);

SELECT * FROM events where eventid IN (976781,962042);

SELECT * FROM problem WHERE objectid = 16371;
SELECT * FROM events WHERE objectid = 16371;
