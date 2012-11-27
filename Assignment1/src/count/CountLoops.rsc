/* Module to count the loops of a file and the project

*/
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
    if(/for\((int\s[\w]*(\=|\s\=)|;)/ := s) 
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
  
/* Method to count the total while loops in a file. Is using a regular expression
   to find while loops that are build in currently that format while(iterator.hasNext()){
   @return int the total number of for loops 
   @param file the file to read
   @author Philipp
*/  
public int countTotalWhiles(list[str] file){
n = 0;
  for(s <- file)
    if(/\swhile\(([\w]*\.[\w]*\(\)|true|\w*\(\)|\w*[\>,\=,\<]*)(\)\{|)/ := s)   
      n +=1;											 
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

/* Method to count all do while loops of a file
   @param file the file to read
   @return n the amount of do while loops
   @author Philipp
*/
public int countDoWhileLoops(list[str] file){
n = 0;
  for(s <- file)
    if(/do\{/ := s)  
      n +=1;											 
  return n; 
}

/* Method to count all while loops of a project
   @param project a list of location from the classes of the project
   @return n the amount of while loops
   @author Philipp
*/
public int countDoWhileLoopsProject(list[loc] project){
	n = 0;
	for(s <- project){
		file = readProjectFileAsArray(s.top);
		loops = countDoWhileLoops(file);
		n += loops;
	}
	return n;
}

/* Method to count the total loops in a file.
   @return int the total number of loops 
   @param file the file to read
   @author Philipp
*/  
public int countLoops(list[str] file){
	int loops = countTotalWhiles(file) + countTotalFors(file);
	return loops;
}

/* Method to count the total loops in a project.
   @param file the file to read
   @return int the total number of loops 
   @author Philipp
*/ 
public int countTotalLoopsProject(list[loc] project){
	loops = countForLoopsProject(project) + countWhileLoopsProject(project) + countDoWhileLoopsProject(project);
	return loops;
}