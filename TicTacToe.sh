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

#FUNCTION TO CHECK IF THE PLAYER OR COMPUTER HAS WON
function checkWin(){
	local playerLetter=$1
	local row=0
	local column=0

	#CHECKING IF WON VERTICALLY
	while [ $column -lt $NO_OF_COLUMNS ]
	do
		if [[ ${board[$row,$column]}${board[$(($row+1)),$column]}${board[$(($row+2)),$column]} == $playerLetter$playerLetter$playerLetter ]]
		then
			echo true
			return
		fi
	((column++))
	done

	row=0
	column=0

	#CHECKING IF WON HORIZONTALLY
	while [ $row -lt $NO_OF_COLUMNS ]
	do
		if [[ ${board[$row,$column]}${board[$row,$(($column+1))]}${board[$row,$(($column+2))]} == $playerLetter$playerLetter$playerLetter ]]
		then
			echo true
			return
		fi
	((row++))
	done

	row=0
	column=0

	#CHECKING IF WON DIAGONALLY
	if [[ ${board[$row,$column]}${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$(($column+2))]} == $playerLetter$playerLetter$playerLetter ]]
	then
		echo true
		return
	fi

	row=0
	column=$(($column+2))

	#CHECKING IF WON DIAGONALLY
	if [[ ${board[$row,$column]}${board[$(($row+1)),$(($column-1))]}${board[$(($row+2)),$(($column-2))]} == $playerLetter$playerLetter$playerLetter ]]
	then
		echo true
		return
	fi
	echo false
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

	while [[ $block -eq "" || $block -lt 0 || $block -gt 8 ]]
	do
		printf  "Invalid Block Number\n"
		read -p "Enter block number 0-8 : " block
	done

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
	turnPlayed=0
	if [ $playCount -eq $TOTALCOUNT ]
	then
		echo "Match Tie"
		exit
	fi
	#TO CHECK IF WINNING POSSIBLE AND PLAY WINNING MOVE
	checkIfWinPossibleAndBlockCompetitorFromWinning $computer

	#TO CHECK IF OPPONENT CAN WIN AND BLOCK FROM WINNING
	checkIfWinPossibleAndBlockCompetitorFromWinning $player

	if [[ $turnPlayed == 0 ]]
	then
		local row=$((RANDOM%3))
		local column=$((RANDOM%3))
		while [[ $(isEmpty $row $column) == false ]]
		do
			row=$((RANDOM%3))
			column=$((RANDOM%3))
		done
		board[$row,$column]=$computer
	fi
	((playCount++))
	displayBoard
	if [[ $(checkWin $computer) == true ]]
	then
		echo "Computer won!"
		exit
	fi
	playerTurn
}

#FUNCTION TO CHECK IF WIN POSSIBLE FOR COMPUTER AND PLAY WINNING MOVE AND ALSO BLOCK OPPONENT FROM WINNING
function checkIfWinPossibleAndBlockCompetitorFromWinning(){
	winningLetter=$1
	local row=0
	local column=0
	possibleWins=(" "$winningLetter$winningLetter $winningLetter" "$winningLetter $winningLetter$winningLetter" ")

	#CHECKING FOR VERTICAL WIN
	while [ $column -lt $NO_OF_COLUMNS ]
	do
		for (( position=0; position<3; position++ ))
		do
			if [[ ${possibleWins[$position]} == ${board[$row,$column]}${board[$(($row+1)),$column]}${board[$(($row+2)),$column]} ]]
			then
				board[$(($row+$position)),$column]=$computer
				turnPlayed=1
				return
			fi
		done
	((column++))
	done

	row=0
	column=0

	#CHECKING FOR HORIZONTAL WIN
	while [ $row -lt $NO_OF_COLUMNS ]
	do
		for (( position=0; position<3; position++ ))
		do
			if [[ ${possibleWins[$position]} == ${board[$row,$column]}${board[$row,$(($column+1))]}${board[$row,$(($column+2))]} ]]
			then
				echo horizontal true
				board[$row,$(($column+$position))]=$computer
				turnPlayed=1
				return
			fi
		done
	((row++))
	done

	row=0
	column=0

	#CHECKING FOR DIAGONAL 1 WIN
	for (( position=0; position<3; position++ ))
	do
		if [[ ${possibleWins[$position]} == ${board[$row,$column]}${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$(($column+2))]} ]]
		then
			echo diagonal 1true
			board[$(($row+$position)),$(($column+$position))]=$computer
			turnPlayed=1
			return
		fi
	done

	row=0
	column=$(($column+2))

	#CHECKING FOR DIAGONAL 2 WIN
	for (( position=0; position<3; position++ ))
	do
		if [[ ${possibleWins[$position]} == ${board[$row,$column]}${board[$(($row+1)),$(($column-1))]}${board[$(($row+2)),$(($column-2))]} ]]
		then
			echo diagonally true
			board[$(($row+$position)),$(($column-$position))]=$computer
			turnPlayed=1
			return
		fi
	done
}

resetBoard
assignLetter

#THE TOSS WINNING PLAYER PLAYS FIRST MOVE
if [[ $(toss) == $player ]]
then
	printf "You won toss\n"
	displayBoard
	playerTurn
else
	printf "Computer won toss\n"
	computerTurn
fi
