#!/bin/bash -x

echo "Welcome to tic-tac-toe game"

#CONSTANTS
NO_OF_ROWS=3
NO_OF_COLUMNS=3
O=0
X=1

#VARIABLES
letter=$((RANDOM%2))

function resetBoard(){
	for (( row=0; row<$NO_OF_ROWS; row++ ))
	do
		for (( column=0; column<$NO_OF_COLUMNS; column++ ))
		do
			board[$row,$column]=""
		done
	done
}

function assignLetter(){
	if [ $letter -eq $X ]
	then
		computer="O"
		player="X"
	else
		computer="X"
		player="O"
	fi
	echo "Player : $player"
	echo "Computer : $computer"
}

resetBoard
assignLetter
