# cableReboot
Tests connection speed then reboots cable modem if slow

Uses http://testmy.net/ to supply a file of given size using wget and capturing the avg download speed after. Runs $reps iterations, specified at the top of the script.

Tries to grab a 3Mb file, then uses the Mb/s value as a size on the next run. This algo accounts for times when it's slow - ie. large downloads timeout fast, and when speed is good, and you need a larger file to accurately judge the average. A little trial and error show this works somewhat accurately.

If the average of $reps runs is less than 20Mb/s it will run another test with a 5Mb file, and reboot if the result is less than 15Mb/s. These are all hard-coded values based on my personal connection.

The modem URL to reboot works for my cable modem - might take some testing to find the correct URL. Using the Chrome debugger I traced the arguments passed in and worked out what to send.

Configure
=========
reps=3 # Default number of iterations.

Run it
======
./modemCheck.sh

eg. in crontab:

```
*/30   *     *    *    *    /Users/user/cableReboot/modemCheck.sh >> /var/log/speedtest.log 2>&1
```

Output
======

Good:

```
[2016/05/22 22:30:00]:  INFO Starting run: 1
[2016/05/22 22:30:03]:  INFO Run 1 : 9
[2016/05/22 22:30:13]:  INFO Starting run: 2
[2016/05/22 22:30:17]:  INFO Run 2 : 19
[2016/05/22 22:30:27]:  INFO Starting run: 3
[2016/05/22 22:30:36]:  INFO Run 3 : 28
[2016/05/22 22:30:36]:  INFO Average : 18
[2016/05/22 22:30:36]:  INFO Running one last check
[2016/05/22 22:30:38]:  INFO Final : 36
```

Bad:

```
[2016/05/22 16:00:00]:  INFO Starting run: 1
[2016/05/22 16:00:03]:  INFO Run 1 : 9
[2016/05/22 16:00:13]:  INFO Starting run: 2
[2016/05/22 16:00:19]:  INFO Run 2 : 14
[2016/05/22 16:00:29]:  INFO Starting run: 3
[2016/05/22 16:03:06]:  INFO Run 3 : 1
[2016/05/22 16:03:06]:  INFO Average : 8
[2016/05/22 16:03:06]:  INFO Running one last check
[2016/05/22 16:03:29]:  INFO Final : 1
[2016/05/22 16:03:29]:  INFO Restarting modem
[2016/05/22 16:03:29]:  INFO Done
```

Extra
=====

``` bash
# alias speedtestavg
speedtestavg='echo '\''Latest download speed:'\'' $( tail -5 /var/log/speedtest.log | grep Average ) && \
echo '\''Current Daily Avg:'\'' $(grep Average /var/log/speedtest.log | awk '\''{ sum += $6 } END { if (NR > 0) print sum / NR }'\'') && \
echo '\''Samples today:'\'' $(grep -c -v Average /var/log/speedtest.log)'
```

An alias to print out interesting data:

```
# speedtestavg
Latest download speed: [2016/05/22 22:30:36]: INFO Average : 18
Current Daily Avg: 33.3864
Samples today: 279
```
