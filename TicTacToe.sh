#!/bin/bash -x

echo "Welcome to tic-tac-toe game"

#CONSTANTS
NO_OF_ROWS=3
NO_OF_COLUMNS=3
O=0
X=1
TOTALCOUNT=9

#VARIABLES
letter=$((RANDOM%2))
toss=$((RANDOM%2))
playCount=0

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
		echo $player
	else
		echo $computer
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

#FUNCTION TO CHECK IF SELECTED BLOCK IS EMPTY
function isEmpty(){
	local row=$1
	local column=$2
	if [[ ${board[$row,$column]} == " " ]]
	then
		echo true
		return
	else
		echo false
		return
	fi
}

#FUNCTION TO SIMULATE PLAYER TURN
function playerTurn(){
	if [ $playCount -eq $TOTALCOUNT ]
	then
		echo "Match Tie"
		exit
	fi

	read -p "Enter block number 0-8 : " block
	row=$(($block/3))
	column=$(($block%3))
	while [[ $(isEmpty $row $column) == false ]]
	do
		echo "Block $block is already occupied."
		read -p "Enter block number 0-8 : " block
		row=$(($block/3))
		column=$(($block%3))
	done
	board[$row,$column]=$player
	((playCount++))
	displayBoard
	if [[ $(checkWin $player) == true ]]
	then
		echo "You won!"
		exit
	fi
	computerTurn
}

#FUNCTION TO SIMULATE COMPUTER TURN
function computerTurn(){
	if [ $playCount -eq $TOTALCOUNT ]
	then
		echo "Match Tie"
		exit
	fi

	local row=$((RANDOM%3))
	local column=$((RANDOM%3))
	while [[ $(isEmpty $row $column) == false ]]
	do
		row=$((RANDOM%3))
		column=$((RANDOM%3))
	done
	board[$row,$column]=$computer
	((playCount++))
	displayBoard
	if [[ $(checkWin $computer) == true ]]
	then
		echo "Computer won!"
		exit
	fi
	playerTurn
}

resetBoard
assignLetter

#CALLING THE TOSS WINNER PLAYER'S TURN FUNCTION
if [[ $(toss) == $player ]]
then
	printf "You won toss\n"
	displayBoard
	playerTurn
else
	printf "Computer won toss\n"
	computerTurn
fi
