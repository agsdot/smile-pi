#include <stdlib.h>
#include <unistd.h>

int main() {
    setuid(0);
    system("/usr/bin/reboot"); /* change this to the actual location of reboot*/
    return 0;
}
