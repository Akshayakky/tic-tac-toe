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

#DECLARING 2D ARRAY
declare -A board

#FUNCTION TO RESET BOARD WITH EMPTY VALUES
function resetBoard(){
	for (( row=0; row<$NO_OF_ROWS; row++ ))
	do
		for (( column=0; column<$NO_OF_COLUMNS; column++ ))
		do
			board[$row,$column]=" "
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

#FUNCTION TO DISPLAY BOARD
function displayBoard(){
	for (( row=0; row<$NO_OF_ROWS; row++ ))
	do
		printf " --- --- --- \n"
		printf "| "
		for (( column=0; column<$NO_OF_COLUMNS; column++ ))
		do
			printf "${board[$row,$column]} | "
		done
		printf "\n"
	done
	printf " --- --- --- \n"
}

#FUNCTION TO CHECK IF THE PLAYER HAS WON
function checkWin(){
	local playerLetter=$1
	local row=0
	local column=0
	local flag=false

	while [ $column -lt $NO_OF_COLUMNS ]
	do
		if [[ ${board[$row,$column]}${board[$(($row+1)),$column]}${board[$(($row+2)),$column]} == $playerLetter$playerLetter$playerLetter ]]
		then
			flag=true
			echo $flag
			return
		fi
	((column++))
	done

	row=0
	column=0

	while [ $row -lt $NO_OF_COLUMNS ]
	do
		if [[ ${board[$row,$column]}${board[$row,$(($column+1))]}${board[$row,$(($column+2))]} == $playerLetter$playerLetter$playerLetter ]]
		then
			flag=true
			echo $flag
			return
		fi
	((row++))
	done

	row=0
	column=0

	if [[ ${board[$row,$column]}${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$(($column+2))]} == $playerLetter$playerLetter$playerLetter ]]
	then
		flag=true
		echo $flag
		return
	fi

	row=0
	column=$(($column+2))

	if [[ ${board[$row,$column]}${board[$(($row+1)),$(($column-1))]}${board[$(($row+2)),$(($column-2))]} == $playerLetter$playerLetter$playerLetter ]]
	then
		flag=true
		echo $flag
		return
	fi
	echo $flag
}

resetBoard
assignLetter
toss
displayBoard
checkWin $player
