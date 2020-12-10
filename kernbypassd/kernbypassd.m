#include <spawn.h>
#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <dlfcn.h>
#import <sys/sysctl.h>
#import <sys/types.h>
#import <sys/wait.h>

#define FLAG_PLATFORMIZE (1 << 1)

static void easy_spawn(const char* args[]) {
    pid_t pid;
    int status;
    posix_spawn(&pid, args[0], NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}

int main(int argc, char **argv, char **envp) {
    @autoreleasepool {
        setuid(0);
        if((chdir("/")) < 0) {
            exit(EXIT_FAILURE);
        }

        printf("/usr/bin/preparerootfs\n");
        easy_spawn((const char *[]){"/usr/bin/preparerootfs", NULL});

        sleep(5);

        printf("/usr/bin/changerootfs &\n");
        easy_spawn((const char *[]){"/usr/bin/changerootfs", "&", NULL});

        sleep(3);

        printf("disown %%1\n");
        easy_spawn((const char *[]){"disown", "%1", NULL});

        printf("RUNNING DAEMON\n");
    }
	return 0;
}