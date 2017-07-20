#include <stdlib.h>
#include <unistd.h>

int main() {
    setuid(0);
    system("/sbin/shutdown -h now"); /* change this to the actual location of shutdown */
    return 0;
}
