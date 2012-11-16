module count::CountLoops

import List;
import String;

// Counting all fors if for is so :  for(int i= 
public int countTotalFors(list[str] file){
	n = 0;
  for(s <- file)
    if(/for\(int\s[a-z]*\=/ := s) 
      n +=1;
  return n;	
}

public int countInnerFors(list[str] file){

}

// Counting all whiles ( if the while loop is :  while(iterator.hasNext()){  
public int countWhiles(list[str] file){
n = 0;
  for(s <- file)
    if(/while\([A-Z,a-z]*\.[A-Z,a-z]*\(\)\)\{/ := s) 
      n +=1;
  return n; 
}

// Counting all while and for loops ( also when while( is just a comment ) !!! 
public int countLoops(str file){
	int loops = countWhiles(file) + countFors(file);
	return loops;
}

