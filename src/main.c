#include <stdlib.h>
#include <stdio.h>
#include <string.h>


extern int find_queens (void (*found_callback)(unsigned int board[8]));


void print_solution (unsigned int board[8]) {
	int i;
	printf("/--------\\\n");
	for (i=0; i<8; ++i) {
		char *row = strdup("|........|");
		row[board[i]] = '*';
		printf("%s\n", row);
		free(row);
	}
	printf("\\--------/\n\n");
}

int main (int argc, char *argv[]) {
	int num_solutions = find_queens(print_solution);
	printf("Found %i solutions.\n", num_solutions);
}
