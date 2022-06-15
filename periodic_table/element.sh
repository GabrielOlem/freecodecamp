#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]*$ ]]
then
  CHECK = $($PSQL "select * from elements where atomic_number=$1")
  if [[ -z CHECK ]]
  then
    echo "I could not find that element in the database."
    exit
  fi
  echo $($PSQL "select * from properties inner join elements using(atomic_number) inner join types using(type_id) where atomic_number=$1") | while IFS="|" read TYPE_ID NUMBER MASS MELTING BOILING SYMBOL NAME TYPE
  do
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
elif [[ $1 =~ ^[a-zA-Z]*$ ]]
then
  if [[ ${#1} > 2 ]]
  then
    CHECK=$($PSQL "select * from elements where name='$1'")
    if [[ -z $CHECK ]]
    then
      echo "I could not find that element in the database."
      exit
    fi
    echo $($PSQL "select * from properties inner join elements using(atomic_number) inner join types using(type_id) where name='$1'") | while IFS="|" read TYPE_ID NUMBER MASS MELTING BOILING SYMBOL NAME TYPE
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  else
    CHECK=$($PSQL "select * from elements where symbol='$1'")
    if [[ -z $CHECK ]]
    then
      echo "I could not find that element in the database."
      exit
    fi
    echo $($PSQL "select * from properties inner join elements using(atomic_number) inner join types using(type_id) where symbol='$1'") | while IFS="|" read TYPE_ID NUMBER MASS MELTING BOILING SYMBOL NAME TYPE
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
  
fi
