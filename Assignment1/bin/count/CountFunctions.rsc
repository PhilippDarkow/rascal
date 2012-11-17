module count::CountFunctions

import List;
import String;

public int countFunction(list[str] file){

}

/* Method to get the amount of public functions of a file
   @return int the number of void functions
*/
public int countPuplicFunction(list[str] file){
	n = 0;
  for(s <- file)
    if(/public/ := s) 
      n +=1;
  return n;
}

public int countPrivateFunction(list[str] file){

}

public int countProtectedFunctions(list[str] file){

}

/* Method to get the amount of void functions of a file
   @return int the number of void functions
*/
public int countVoidFunctions(list[str] file){
	n = 0;
  for(s <- file)
    if(/void/ := s) 
      n +=1;
  return n;
}

/* Method to get the amount of int functions of a file
   @return int the number of int functions
*/
public int countIntFunctions(list[str] file){
n = 0;
  for(s <- file)
    if(/int\s[a-z,A-Z]*\(\)|int\s[a-z,A-Z]*\([A-Z,a-z]*/ := s) 
      n +=1;
  return n; 
}

/* Method to get the amount of boolean functions of a file
   @return int the number of boolean functions
*/
public int countBooleanFunctions(list[str] file){
n = 0;
  for(s <- file)
    if(/boolean\s[a-z,A-Z]*\(\)|boolean\s[a-z,A-Z]*\([A-Z,a-z]*/ := s) 
      n +=1;
  return n; 
}

/* Method to get the amount of String functions of a file
   @return int the number of String functions
*/
public int countStringFunctions(list[str] file){
n = 0;
  for(s <- file)
    if(/String\s[a-z,A-Z]*\(\)|String\s[a-z,A-Z]*\([A-Z,a-z]*/ := s) 
      n +=1;
  return n; 
}

/* The method counts the methods with are not have an standart java return typ ) is it the moment not complete down )
   @return int the number of functions
*/
public int countSpecialFunctions(list[str] file){
n = 0;
  for(s <- file)
    if(/[A-Z,a-z]*\s[a-z]*\(\)\{|[A-Z,a-z]*\s[a-z]*\([A-Z,a-z]*\s[a-z]*\)\{|[A-Z,a-z]*\s[a-z,A-Z]*\([A-Z,a-z]*\s[a-z]*\)\s[a-z]*/ := s) 
      n +=1;
  return n; 
}
