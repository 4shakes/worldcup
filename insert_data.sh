#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

  echo $($PSQL "TRUNCATE teams, games")
  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL
  do
    if [[ $WINNER != "winner" ]]
    then
     WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
     OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      if [[ -z $WINNER_ID ]]
      then
        INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
        if [[ $INSERT_TEAMS == "INSERT 0 1" ]]
        then
          echo "Insert table TEAMS the value " $WINNER
        fi
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      fi

      if [[ -z $OPPONENT_ID ]]
      then
        INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
        if [[ $INSERT_TEAMS == "INSERT 0 1" ]]
        then
          echo "Insert table TEAMS the value " $OPPONENT
        fi
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      fi

        INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ('$YEAR','$ROUND',$WINNER_ID,$OPPONENT_ID,'$WINNER_GOAL','$OPPONENT_GOAL')")
        if [[ $INSERT_GAMES == "INSERT 0 1" ]]
        then
          echo "Insert table GAMES the value " $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOAL $OPPONENT_GOAL
        fi

    fi
  done
