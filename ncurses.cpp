/***********************************************
* Name:                 Brandon Stanley
* Student Number:       0495470
* Date Created:         Feb. 1, 2014
* Last Modified:        Feb. 1, 2014
*
************************************************
* Purpuse:
* 	ncurses functions for use in my Assembly course.
*	I had to simulate the DOS terminal's ability to
*	write in random locations, in random colors to
*	console.
*
*	May not be overly useful unless writing simple
*	console programs in Linux.
************************************************/




#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include "../driver.h"

//compile with -lncurses flag
void set_colors();

void init(){
	srand(time(0));
	initscr();
	start_color();
	set_colors();
}

void set_colors(){
	//define 16 colors
	int c = 100, b = 1, i, j;

	init_color(c++, 0, 0, 0);
	init_color(c++, 1000, 1000, 1000);
	init_color(c++, 500, 0, 0);
	init_color(c++, 1000, 0, 0);
	init_color(c++, 0, 500, 0);
	init_color(c++, 0, 1000, 0);
	init_color(c++, 0, 0, 500);
	init_color(c++, 0, 0, 1000);
	init_color(c++, 500, 500, 0);
	init_color(c++, 1000, 1000, 0);
	init_color(c++, 0, 500, 500);
	init_color(c++, 0, 1000, 1000);
	init_color(c++, 500, 0, 500);
	init_color(c++, 1000, 0, 1000);
	init_color(c++, 333, 333, 333);
	init_color(c++, 666, 666, 666);
	c = 100;
	for(i = 0; i < 16; ++i){
		for(j = 0; j < 16; ++j){
			init_pair(b++, (c+j), (c+i));
		}
	}
}

void print_to_screen(char * in, int x, int y, int pair){
	attron(COLOR_PAIR(pair));
	mvprintw(y, x, in);
	refresh();
	attroff(COLOR_PAIR(pair));
}

int lines(){
	return LINES;
}

int columns(){
	return COLS;
}

void wait_for_input(){
	getch();
}

void close_window(){
	endwin();
}

int get_rand(int base){
	return rand() % base;
}