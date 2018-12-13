#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <string.h>
#include <time.h>

void forkSum(int left, int right, int pipefd[]) {
	dup2(pipefd[1], STDOUT_FILENO);
	close(pipefd[0]);

    if (left==right) {
    	printf("%d\n", left);
    	exit(EXIT_SUCCESS);
    }
    else
    {
	    int new_pipefd1[2];
	    char buf1[1024];

        if (pipe(new_pipefd1) == -1) {
    	    perror("pipe");
    	    exit(EXIT_FAILURE);
        }
        pid_t cpid = fork();

		if (cpid == -1) {
		    perror("fork");
		    exit(EXIT_FAILURE);
		}
		else if (cpid == 0) {
			forkSum(left, (left+right)/2, new_pipefd1);
		}
		close(new_pipefd1[1]);
		wait(NULL);

		int new_pipefd2[2];
		char buf2[1024];

	    if (pipe(new_pipefd2) == -1) {
		    perror("pipe");
		    exit(EXIT_FAILURE);
	    }
	    pid_t cpid2 = fork();

		if (cpid2 == -1) {
		    perror("fork");
		    exit(EXIT_FAILURE);
		}
		else if (cpid2 == 0) {
			forkSum(((left+right)/2)+1, right, new_pipefd2);
		}
		close(new_pipefd2[1]);
		wait(NULL);

		read(new_pipefd1[0], &buf1, sizeof(buf1));
		read(new_pipefd2[0], &buf2, sizeof(buf2));
		int sum = atoi(buf1)+atoi(buf2);
		printf("%d\n", sum);
    }
    exit(EXIT_SUCCESS);
}

int main(int argc, char **argv) {

	if(argc!=3) {
		exit(EXIT_FAILURE);
	}
	int left = atoi(argv[1]);
	int right = atoi(argv[2]);

	int gauss = ((left+right)*(right-left+1))/2;

	struct timespec start, end;
	clock_gettime(CLOCK_REALTIME, &start);

	int pipefd[2];
	char buf[1024];

    if (pipe(pipefd) == -1) {
	    perror("pipe");
	    exit(EXIT_FAILURE);
    }
    pid_t cpid2 = fork();

	if (cpid2 == -1) {
	    perror("fork");
	    exit(EXIT_FAILURE);
	}
	else if (cpid2 == 0) {
		forkSum(left, right, pipefd);
	}
	close(pipefd[1]);
	read(pipefd[0], &buf, sizeof(buf));

	if (gauss == atoi(buf))
	{
		clock_gettime(CLOCK_REALTIME, &end);
		fprintf(stderr, "%f\n", end.tv_sec-start.tv_sec+(end.tv_nsec-start.tv_nsec)/(double)1000000000);
	}
	return 0;
}