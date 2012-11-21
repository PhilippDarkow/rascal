module count::CountLoops

import List;
import String;

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
public int countWhiles(list[str] file){
n = 0;
  for(s <- file)
    if(/while\([A-Z,a-z]*\.[A-Z,a-z]*\(\)\)\{/ := s) 
      n +=1;
  return n; 
}

/* Method to count the total loops in a file.
   @return int the total number of for loops 
   @param file the file to read
   @author Philipp
*/  
public int countLoops(list[str] file){
	int loops = countWhiles(file) + countTotalFors(file);
	return loops;
}

