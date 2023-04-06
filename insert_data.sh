#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games";)

cat games.csv | while  IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $WINNER != "winner" ]]
  then 
    # get team id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'";)
    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert team 
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')";)
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted Winner into teams, $WINNER
      fi
      # get new team id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'";)
    fi
  fi
  if [[ $OPPONENT != "opponent" ]]
  then
    # get team id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'";)
    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert team 
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')";)
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted Opponent into teams, $OPPONENT
      fi
      # get new team id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'";)
    fi
  fi
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'";)
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'";)
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')";)
  fi
done
