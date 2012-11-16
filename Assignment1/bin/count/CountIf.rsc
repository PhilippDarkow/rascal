module count::CountIf

import List;
import String;

// Counting all ifs ( also when if loop is commented out ) !!! 
public int countIfs(list[str] file){
n = 0;
  for(s <- file)
    if(/\sif\([A-Z,a-z]*\)\{/ := s) 
      n +=1;
  return n; 
}