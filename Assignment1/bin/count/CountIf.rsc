module count::CountIf

import List;
import String;

// Counting all ifs ( also when if loop is commented out ) !!! 
// if(idx <  and this one if(log.isLogging()
public int countIfs(list[str] file){
n = 0;
  for(s <- file)
    if(/if\((\w*(\s(\<|\>|\=\=|\&\&|\!\!)\s|\.\w*\((\"\w*\:\"\)|\)))|\w*\)|\w*(\<|\>|\=\=|\&\&|\!\!|\.))/ := s)          // \<|\>|\=\=|\&\&|\!\! == [<>=!.] 
      n +=1;
  return n; 
}