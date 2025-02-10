#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


while IFS=",
"; read -r year round winner opponent winner_goals opponent_goals
do
	if [[ $winner == "winner" ]]
	then
		continue
	fi
	IFS=" 	
" # reset the IFS, changing it screws up the way bash processes arguments, so we need to change it back
	winner_id="$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")"
	opponent_id="$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")"
	if [[ -z $opponent_id ]]
	then
		opponent_insert_result="$($PSQL "INSERT INTO teams(name) VALUES('$opponent');")"
		opponent_id="$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")"
	fi
	if [[ -z $winner_id ]]
	then
		winner_insert_result="$($PSQL "INSERT INTO teams(name) VALUES('$winner');")"
		winner_id="$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")"
	fi
	# echo OPPONENT_ID: $opponent_id
	insert_game_result="$($PSQL "INSERT INTO games(winner_id, opponent_id, year, round, winner_goals, opponent_goals) VALUES($winner_id, $opponent_id, $year, '$round', $winner_goals, $opponent_goals);")"
done < "games.csv"


