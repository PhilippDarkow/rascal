module count::CountLoops

import List;
import String;

// Counting all fors ( also when for( is just a comment ) !!! 
public int countFors(str file){
	return size(findAll(file, "for("));
}

// Counting all whiles ( also when while( is just a comment ) !!! 
public int countWhiles(str file){
	return size(findAll(file, "while("));
}

// Counting all while and for loops ( also when while( is just a comment ) !!! 
public int countLoops(str file){
	int loops = countWhiles(file) + countFors(file);
	return loops;
}

