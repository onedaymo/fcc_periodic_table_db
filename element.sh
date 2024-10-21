#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
    NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  fi

  if [[ $ATOMIC_NUMBER ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) 
    INNER JOIN types USING(type_id) WHERE atomic_number=$1")    
  elif [[ $SYMBOL ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) 
    INNER JOIN types USING(type_id) WHERE symbol='$1'")    
  elif [[ $NAME ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) 
    INNER JOIN types USING(type_id) WHERE name='$1'")
  fi
 
  if [[ $ELEMENT ]]
  then
    echo "$ELEMENT" | while read TYPE_ID BAR ATOMIC BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE
    do
      echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    #The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
    done    
  else
    echo "I could not find that element in the database."
  fi
fi
