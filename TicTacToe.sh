#!/bin/bash -x

echo "Welcome to tic-tac-toe game"

#CONSTANTS
NO_OF_ROWS=3
NO_OF_COLUMNS=3
O=0
X=1

#VARIABLES
letter=$((RANDOM%2))
toss=$((RANDOM%2))

#FUNCTION TO RESET BOARD WITH EMPTY VALUES
function resetBoard(){
	for (( row=0; row<$NO_OF_ROWS; row++ ))
	do
		for (( column=0; column<$NO_OF_COLUMNS; column++ ))
		do
			board[$row,$column]=""
		done
	done
}

#FUNCTION TO ASSIGN LETTERS TO PLAYER AND COMPUTER
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

#FUNCTION TO SIMULATE TOSS TO DETERMINE WHO PLAYS FIRST
function toss(){
	if [ $toss -eq $X ]
	then
		echo "Player Won Toss"
	else
		echo "Computer Won Toss"
	fi
}

resetBoard
assignLetter
toss
