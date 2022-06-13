#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo "$($PSQL "truncate games, teams")"
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != 'year' ]]
  then
    winner_id="$($PSQL "select team_id from teams where name='$winner'")"
    echo $winner_id
    if [[ -z $winner_id ]]
    then
      echo "$($PSQL "insert into teams(name) values('$winner')")"
    fi
    winner_id="$($PSQL "select team_id from teams where name='$winner'")"
    opponent_id="$($PSQL "select team_id from teams where name='$opponent'")"
    echo $opponent_id
    if [[ -z $opponent_id ]]
    then
      echo "$($PSQL "insert into teams(name) values('$opponent')")"
    fi
    opponent_id="$($PSQL "select team_id from teams where name='$opponent'")"
    echo "$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")"
  fi
done
