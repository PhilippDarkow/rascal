module count::CountIf

import List;
import String;

// Counting all ifs ( also when if is just a comment ) !!! 
public int countIfs(str file){
	return size(findAll(file, "if"));
}