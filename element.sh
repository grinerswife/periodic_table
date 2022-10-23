#if there is not an argument
if [[ -z "$1" ]]
then
  echo "Please provide an element as an argument."
  exit
fi


PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -Ac"

#if argument is number
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$1'")
else

#if argument is name of element
  if [[ ${#1} > 2 ]]
  then
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  else

#if arguement is symbol
    if [[ $1 =~ [A-Za-z]{1,2} ]]
    then
      ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
     fi
  fi
fi

#if argument is none of the above
if [[ -z $ELEMENT_NAME ]]
then
  echo "I could not find that element in the database."

#assign variables from database to create sentence
else
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$ELEMENT_NAME'")
  PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
  ELEMENT_INFO=$($PSQL  "SELECT properties. atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM properties FULL JOIN elements ON properties.atomic_number=elements.atomic_number FULL JOIN types ON properties.type_id=types.type_id WHERE name='$ELEMENT_NAME'")
  echo "$ELEMENT_INFO" | while read ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELT BAR BOIL BAR TYPE
  do
  echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
fi
