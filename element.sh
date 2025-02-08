#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  BY_NAME="$($PSQL "select e.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements e inner join properties p on e.atomic_number = p.atomic_number inner join types t on p.type_id = t.type_id where name='$1';")"
  if [[ -n $BY_NAME ]]
  then
    echo "$BY_NAME" | while IFS="|" read NUM NAME SYMBOL TYPE MASS MELTING BOILING
    do
      echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  else
    BY_SYM="$($PSQL "select e.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements e inner join properties p on e.atomic_number = p.atomic_number inner join types t on p.type_id = t.type_id where symbol='$1';")"
    if [[ -n $BY_SYM ]]
    then
      echo "$BY_SYM" | while IFS="|" read NUM NAME SYMBOL TYPE MASS MELTING BOILING
      do
        echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    else
      BY_NUM="$($PSQL "select e.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements e inner join properties p on e.atomic_number = p.atomic_number inner join types t on p.type_id = t.type_id where e.atomic_number=$1;")"
      if [[ -n $BY_NUM ]]
      then
        echo "$BY_NUM" | while IFS="|" read NUM NAME SYMBOL TYPE MASS MELTING BOILING
        do
          echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      else
        echo "I could not find that element in the database."
      fi
    fi
  fi
else 
  echo "Please provide an element as an argument."
fi
