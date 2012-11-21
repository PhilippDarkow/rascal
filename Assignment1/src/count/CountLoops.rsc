module count::CountLoops

import List;
import String;
import reader::Reader;

/* Method to count the total for loops in a file. Is using a regular expression to find for loops that are
   build in that format for(int i=
   @param file the file to read
   @return int the total number of for loops 
   @author Philipp
*/
public int countTotalFors(list[str] file){
	n = 0;
  for(s <- file)
    if(/for\(int\s[a-z]*\=/ := s) 
      n +=1;
  return n;	
}

/* Method to count all for loops of a project
   @param project a list of location from the classes of the project
   @return n the amount of for loops
   @author Philipp
*/
public int countForLoopsProject(list[loc] project){
	n = 0;
	for(s <- project){
		file = readProjectFileAsArray(s.top);
		loops = countTotalFors(file);
		n += loops;
	}
	return n;
}

/* Method to count the total inner for loops in a file.
   @return int the total number of inner for loops 
   @param file the file to read
*/
public int countInnerFors(list[str] file){

}
  
/* Method to count the total while loops in a file. Is using a regular expression to find while loops that are
   build in currently that format while(iterator.hasNext()){
   @return int the total number of for loops 
   @param file the file to read
   @author Philipp
*/  
public int countTotalWhiles(list[str] file){
n = 0;
  for(s <- file)
    if(/while\(([\w]*\.[\w]*\(\)|true|\w*\(\)|\w*[\>,\=,\<]*)(\)\{|)/ := s)  // 1 version: while\([A-Z,a-z]*\.[A-Z,a-z]*\(\)\)\{  2 version : while\(([\w]*\.[\w]*\(\)|true)\)\{  
      n +=1;											  // 3 version while\(([\w]*\.[\w]*\(\)|true|\w*\(\))\)\{  
  return n; 
}

/* Method to count all while loops of a project
   @param project a list of location from the classes of the project
   @return n the amount of while loops
   @author Philipp
*/
public int countWhileLoopsProject(list[loc] project){
	n = 0;
	for(s <- project){
		file = readProjectFileAsArray(s.top);
		loops = countTotalWhiles(file);
		n += loops;
	}
	return n;
}

/* Method to count the total loops in a file.
   @return int the total number of for loops 
   @param file the file to read
   @author Philipp
*/  
public int countLoops(list[str] file){
	int loops = countTotalWhiles(file) + countTotalFors(file);
	return loops;
}

public int countTotalLoopsProject(list[loc] project){
	loops = countForLoopsProject(project) + countWhileLoopsProject(project);
	return loops;
}

