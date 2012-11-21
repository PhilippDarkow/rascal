module count::CountIf

import List;
import String;
import reader::Reader;

/* Method to count the if statement in a file
   @param file the file to count the if statements
   @return n the amount of if statements   if\(\w*(\)|\w*)(\s|[\,,\s,\.]*)
*/ 
public int countIfs(list[str] file){
n = 0;
  for(s <- file)
    if(/if\(\w*(\)|\w*)(\s|[\,,\s,\.]*)/ := s)          // if\((\w*(\s(\<|\>|\=\=|\&\&|\!\!)\s|\.\w*\((\"\w*\:\"\)|\)))|\w*\)|\w*(\<|\>|\=\=|\&\&|\!\!|\.))  
      n +=1;
  return n; 
}

/* Method to count all if statements of a project
   @param project a list of location from the classes of the project
   @return n the amount of if statements
   @author Philipp
*/
public int countIfsProject(list[loc] project){
	n = 0;
	for(s <- project){
		file = readProjectFileAsArray(s.top);
		ifs = countIfs(file);
		n += ifs;
	}
	return n;
}