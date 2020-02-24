#!/bin/bash -x

echo "Welcome to tic-tac-toe game"

#CONSTANTS
NO_OF_ROWS=3
NO_OF_COLUMNS=3

for (( row=0; row<$NO_OF_ROWS; row++ ))
do
	for (( column=0; column<$NO_OF_COLUMNS; column++ ))
	do
		board[$row,$column]=""
	done
done
