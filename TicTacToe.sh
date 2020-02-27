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
	local blockNumber=$1
	local row=$(($(($blockNumber-1))/3))
	local column=$(($(($blockNumber-1))%3))
	if [[ ${board[$row,$column]} == " " ]]
	then
		echo true
		return
	else
		echo false
		return
	fi
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
			board[$(($row+$position)),$(($column-$position))]=$computer
			turnPlayed=1
			return
		fi
	done
}

#TAKE AVAILABLE CORNER IF WINNING NOT POSSIBLE
function takeAvailableCorner(){
	#STORING ALL POSSIBLE CORNERS IN ARRAY allCorners
	allCorners=(1 $(($NO_OF_ROWS)) $(($NO_OF_ROWS*$NO_OF_COLUMNS-$NO_OF_ROWS+1)) $(($NO_OF_ROWS*$NO_OF_COLUMNS)))
	flag=false
	counter=0
	for (( corner=0; corner<${#allCorners[@]}; corner++ ))
	do
		if [[ $(isEmpty ${allCorners[$corner]}) == true ]]
		then
			flag=true
			#STORING ALL AVAILABLE CORNERS IN ARRAY availableCorners
			availableCorners[((counter++))]=${allCorners[$corner]}
		fi
	done

	#TAKE ANY ONE AVAILABLE CORNER RANDOMLY
	if [[ $flag == true ]]
	then
		cornerNumber=$((RANDOM%${#availableCorners[@]}))
		while [[ $(isEmpty ${availableCorners[$cornerNumber]}) == false ]]
		do
			cornerNumber=$((RANDOM%${#availableCorners[@]}))
		done

		local row=$(($((${availableCorners[$cornerNumber]}-1))/3))
		local column=$(($((${availableCorners[$cornerNumber]}-1))%3))
		board[$row,$column]=$computer
		turnPlayed=1
		return
	fi
}

#TAKE CENTER IF CORNERS NOT AVAILABLE
function takeCenter(){
	local centerBlock=$(($NO_OF_ROWS*$NO_OF_COLUMNS/2+1))
	if [[ $(isEmpty $centerBlock) == true ]]
	then
		local row=$(($(($centerBlock-1))/3))
		local column=$(($(($centerBlock-1))%3))
		board[$row,$column]=$computer
		turnPlayed=1
	fi
}

#FUNCTION TO SIMULATE PLAYER TURN
function playerTurn(){
	if [ $playCount -eq $TOTALCOUNT ]
	then
		echo "Match Tie"
		exit
	fi

	read -p "Enter block number 1-9 : " block

	while [[ $(isEmpty $block) == false ]]
	do
		printf "Block Already Occupied Or Invalid Input\n"
		read -p "Enter block number 1-9 : " block
	done

	row=$(($(($block-1))/3))
	column=$(($(($block-1))%3))

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
	#USING TURNPLAYED VARIABLE TO RESTRICT COMPUTER FROM PLAYING ITS TURN MULTIPLE TIMES
	turnPlayed=0
	if [ $playCount -ge $TOTALCOUNT ]
	then
		echo "Match Tie"
		exit
	fi
	#TO CHECK IF WINNING POSSIBLE AND PLAY WINNING MOVE
	checkIfWinPossibleAndBlockCompetitorFromWinning $computer

	#TO CHECK IF OPPONENT CAN WIN AND BLOCK FROM WINNING
	if [[ $turnPlayed == 0 ]]
	then
		checkIfWinPossibleAndBlockCompetitorFromWinning $player
	fi

	#TAKE CENTER IF CORNER NOT AVAILABLE
	if [[ $turnPlayed == 0 ]]
	then
		takeCenter
	fi

	#TAKE CORNER IF WINNING AND BLOCKING NOT POSSIBLE
	if [[ $turnPlayed == 0 ]]
	then
		takeAvailableCorner
	fi

	#FINALLY TAKE ANY SIDE IF CENTER NOT AVAILABLE
	if [[ $turnPlayed -eq 0 ]]
	then
		local blockNumber=$((RANDOM%9))
		while [[ $(isEmpty $blockNumber) == false ]]
		do
			blockNumber=$((RANDOM%9))
		done
		row=$(($(($blockNumber-1))/3))
		column=$(($(($blockNumber-1))%3))
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
