#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUMBER=$(( $RANDOM % 1001 ))
echo $SECRET_NUMBER
echo "Enter your username:"
read USERNAME
USER_INFO=$($PSQL "select * from players where name='$USERNAME'")
if [[ -z $USER_INFO ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  echo $($PSQL "insert into players(name) values('$USERNAME')") >/dev/null
else
  echo $USER_INFO | while IFS="|" read ID N_GAMES BEST_GAME NAME
  do
    echo "Welcome back, $NAME! You have played $N_GAMES games, and your best game took $BEST_GAME guesses."
  done
fi
N_GUESSES=0
echo "Guess the secret number between 1 and 1000:"
while [ True ]
do
  N_GUESSES=$((N_GUESSES+1))
  read GUESSED_NUMBER
  if [[ ! $GUESSED_NUMBER =~ ^[0-9]*$ ]] 
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $GUESSED_NUMBER == $SECRET_NUMBER ]]
    then
      echo "You guessed it in $N_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      echo $($PSQL "update players set n_games=n_games+1 where name='$USERNAME'") >/dev/null
      BEST_GAME=$($PSQL "select best_game from players where name='$USERNAME'")
      if [[ $N_GUESSES -lt $BEST_GAME || -z $BEST_GAME ]]
      then
        echo $($PSQL "update players set best_game=$N_GUESSES where name='$USERNAME'") >/dev/null
      fi
      exit
    elif [[ $GUESSED_NUMBER -lt $SECRET_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
    else
      echo "It's lower than that, guess again:"
    fi
  fi

done
