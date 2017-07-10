<?php
   $ip = shell_exec("/sbin/ifconfig | grep -A2 wlan0 | awk '/HWaddr(.*$)/' |  awk '{ print $5}' | tail -1  | sed s/://g | tr '[:lower:]' '[:upper:]' | tail -c 5");
   echo $ip;
?>
