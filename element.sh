#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
         FROM elements 
         JOIN properties USING(atomic_number) 
         JOIN types USING(type_id) 
         WHERE atomic_number=$1"
else
  QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
         FROM elements 
         JOIN properties USING(atomic_number) 
         JOIN types USING(type_id) 
         WHERE symbol='$1' OR name='$1'"
fi

RESULT=$($PSQL "$QUERY")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo "$RESULT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    FORMATTED_MASS=$(printf "%.3f" "$MASS" | sed 's/0*$//;s/\.$//')
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $FORMATTED_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi
