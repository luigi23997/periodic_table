# ! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

PRINT(){
  TYPE=$($PSQL "SELECT t.type FROM properties as p INNER JOIN types as t USING (type_id) WHERE p.atomic_number = $1")
  STRING=$($PSQL "SELECT atomic_mass, melting_point_celsius,boiling_point_celsius FROM properties WHERE atomic_number = $1 ")
  IFS='|'
  read -a ARRAY <<< "$STRING"
  echo "The element with atomic number $1 is $2 ($3). It's a $TYPE, with a mass of ${ARRAY[0]} amu. $2 has a melting point of ${ARRAY[1]} celsius and a boiling point of ${ARRAY[2]} celsius."
}

MAIN() {
  if [[ -z $1 ]]
  then
    echo -e "Please provide an element as an argument."
  else
    if [[ ! $1 =~ [0-9]+$ ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol= '$1' OR name = '$1'")
      if [[ -z $ATOMIC_NUMBER ]]
      then
        echo -e "I could not find that element in the database."
      else
        NAME=$($PSQL "SELECT name FROM elements WHERE symbol= '$1' OR name = '$1'")
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol= '$1' OR name = '$1'")
        PRINT $ATOMIC_NUMBER $NAME $SYMBOL
      fi
    else
      ATOMIC_NUMBER=$1
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
      if [[ -z $NAME ]]
      then
        echo -e "I could not find that element in the database."
      else
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
        PRINT $ATOMIC_NUMBER $NAME $SYMBOL
      fi
    fi
  fi
}


MAIN $1


