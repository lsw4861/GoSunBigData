#!/bin/bash
IP=172.18.18.119
PORT=4000
COUNT=2
 mysql -u root -h ${IP} -P ${PORT} << EOF
use people;

#新增
INSERT INTO people.t_people_new (peopleid,month,deviceid,isconfirm,flag)
SELECT peopleid,DATE_FORMAT(capturetime ,'%Y%m') AS time,deviceid,1,flag
FROM people.t_people_recognize
WHERE flag = 2 AND time =DATE_FORMAT(DATE_SUB(NOW(),INTERVAL 1 MONTH,'%Y%m'))
GROUP BY peopleid, deviceid
HAVING COUNT(peopleid) >=2 AND COUNT(deviceid)>=2;
#实名
INSERT INTO people.t_people_new (peopleid,month,deviceid,isconfirm,flag)
SELECT peopleid,DATE_FORMAT(capturetime ,'%Y%m') ,deviceid,1,flag
FROM t_people_recognize AS pr
WHERE pr.flag = 1 AND DATE_FORMAT(capturetime ,'%Y%m')=DATE_FORMAT(DATE_SUB(NOW(),INTERVAL 1 DAY),'%Y%m') AND pr.community = (SELECT community FROM t_people AS p WHERE p.id = pr.peopleid)
GROUP BY peopleid, deviceid
HAVING COUNT(peopleid) >=2 AND COUNT(deviceid)>=2;
EOF
