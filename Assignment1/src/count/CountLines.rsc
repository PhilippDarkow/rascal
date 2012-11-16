module count::CountLines

import IO;
import List;

/* Method to count the total lines of a file 
   @param file the file as a list of string
   @return the lines of the file
*/
public int countLinesTotal(list[str] file){    
    return size(file);
}

/* Method to count the comment of a file 
   @param file the file as a list of string
   @return the comment lines of a file  \/\*[^/*]*(?:(?!\/\*|\*\/)[/*][^/*]*)*\*\/   http://regexpal.com/
*/
public int countComment(list[str] file){	
  n = 0;
  for(s <- file)
    if(/\*(.|[\r\n])*?\*/ := s)  // find comment 
      n +=1;
  return n;
}

// 34 Blanc lines need it to be blank but at the moment i get 35
public int countBlankLines(list[str] file){
	n = 0;
	println(file);
  for(s <- file)
    if(/^[ \t\r\n]*$/ := s)  // http://generally.wordpress.com/2010/09/23/regular-expression-for-a-line-with-only-white-spaces/
      n +=1;
  return n;
}

public int countImports(list[str] file){
	n = 0;
  for(s <- file)
    if(/import/ := s) 
      n +=1;
  return n;
}

public int countCodeLines(list[str] file){
	int codeLines = size(file);
	codeLines = codeLines - (countBlankLines(file) + countComment(file));
	return codeLines;
}
