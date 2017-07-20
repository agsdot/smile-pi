echo "Hotfix shutdown_php.c and reboot_php.c files"

sed -i.bak 's/usr\/bin/sbin/' ~/smile-pi/setup_files/reboot_php.c
sed -i.bak 's/usr\/bin/sbin/' ~/smile-pi/setup_files/shutdown_php.c

cd /tmp
\cp ~/smile-pi/setup_files/shutdown_php.c /tmp/shutdown_php.c
\cp ~/smile-pi/setup_files/reboot_php.c /tmp/reboot_php.c

gcc -o shutdown_php shutdown_php.c
sudo mv shutdown_php /usr/local/bin/
sudo chown root:root /usr/local/bin/shutdown_php
sudo chmod 4755 /usr/local/bin/shutdown_php

gcc -o reboot_php reboot_php.c
sudo mv reboot_php /usr/local/bin/
sudo chown root:root /usr/local/bin/reboot_php
sudo chmod 4755 /usr/local/bin/reboot_php
