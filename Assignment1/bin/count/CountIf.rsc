module count::CountIf

import List;
import String;

/* Method to count the if statement in a file
   @param file the file to count the if statements
   @return n the amount of if statements
*/
public int countIfs(list[str] file){
n = 0;
  for(s <- file)
    if(/if\((\w*(\s(\<|\>|\=\=|\&\&|\!\!)\s|\.\w*\((\"\w*\:\"\)|\)))|\w*\)|\w*(\<|\>|\=\=|\&\&|\!\!|\.))/ := s)          // \<|\>|\=\=|\&\&|\!\! == [<>=!.] 
      n +=1;
  return n; 
}