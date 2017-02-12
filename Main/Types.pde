/**
* Parent class for block types
*/
class Type {    
  int id;
  int numberOfPeople;
  //TODO allow more than one destination type
  String destinationType;
  String imageSource;
}

//--------------------------------------------------------------------------

/**
* The Type_1 class represents a block of type 1 of building usage. It is a child of class Type.
*
* TEMP = SCHOOL
*
*/

class Type_1 extends Type {    
  
  Type_1 () {
    id = 1;
    numberOfPeople = 1;
    destinationType = "Type_2";
    imageSource = "assets/school_icon.png";
  }
}

//--------------------------------------------------------------------------

/**
* The Type_2 class represents a block of type 2 of building usage
*
* TEMP = FOOD
*
*/

class Type_2 extends Type {    
  
  Type_2 () {
    id = 2;
    numberOfPeople = 2;
    destinationType = "Type_1";
    imageSource = "assets/food_icon.png";
  }  
}

//--------------------------------------------------------------------------

/**
* The Type_3 class represents a block of type 3 of building usage
*
* TEMP = TRANSIT
*
*/

class Type_3 extends Type {    
  
  Type_3 () {
    id = 3;
    numberOfPeople = 3;
    destinationType = "Type_1";
    imageSource = "assets/transit_icon.png";
  }
}

//--------------------------------------------------------------------------

/**
* The Type_4 class represents a block of type 4 of building usage
*
* TEMP = OFFICE
*
*/

class Type_4 extends Type {    
  
  Type_4 () {
    id = 4;
    numberOfPeople = 3;
    destinationType = "Type_2";
    imageSource = "assets/office_icon.png";
  }
  
}