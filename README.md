# cableReboot
Tests connection speed then reboots cable modem if slow

Run it
======
./modemCheck.sh

eg. in crontab:

*/30   *     *    *    *    /Users/user/cableReboot/modemCheck.sh >> /var/log/speedtest.log 2>&1


Output
======

[2016/05/22 22:30:00]:  INFO Starting run: 1
[2016/05/22 22:30:03]:  INFO Run 1 : 9
[2016/05/22 22:30:13]:  INFO Starting run: 2
[2016/05/22 22:30:17]:  INFO Run 2 : 19
[2016/05/22 22:30:27]:  INFO Starting run: 3
[2016/05/22 22:30:36]:  INFO Run 3 : 28
[2016/05/22 22:30:36]:  INFO Average : 18
[2016/05/22 22:30:36]:  INFO Running one last check
[2016/05/22 22:30:38]:  INFO Final : 36

