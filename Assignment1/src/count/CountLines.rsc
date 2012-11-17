module count::CountLines

import IO;
import List;

/* Method to count the total lines of a file 
   @param file the file as a list of string
   @return the lines of the file
   @author Philipp
*/
public int countLinesTotal(list[str] file){    
    return size(file);
}

/* Method to count the comments of a file 
   @param file the file as a list of string
   @return the comments of a file
   @author Philipp 
*/
public int countComment(list[str] file){	
  n = 0;
  for(s <- file)
    if(/\*(.|[\r\n])*?\*/ := s)  // find comment 
      n +=1;
  return n;
}

/* Method to count the comment lines. Comment Lines are { /*,*,/*} 
   @param file the java file
   @return number of comment lines
   @author Philipp
*/
public int countCommentLines(list[str] file){
  n = 0;
  for(s <- file)
    if(/(\/\*|\s\*)/ := s)   
      n +=1;
  return n;
}

/* Method to count the blank lines  
   @param file the java file
   @return number of blank lines
   @author Philipp
*/
public int countBlankLines(list[str] file){
	n = 0;
	println(file);
  for(s <- file)
    if(/^[ \t\r\n]*$/ := s)  // http://generally.wordpress.com/2010/09/23/regular-expression-for-a-line-with-only-white-spaces/
      n +=1;
  return n;
}

/* Method to count the imports 
   @param file the java file
   @return number of imports
   @author Philipp
*/
public int countImports(list[str] file){
	n = 0;
  for(s <- file)
    if(/import/ := s) 
      n +=1;
  return n;
}

/* Method to count the code lines  ( is at the moment also counting // that lines ) 
   @param file the java file
   @return number of code lines
   @author Philipp
*/
public int countCodeLines(list[str] file){
	int codeLines = size(file);
	codeLines = codeLines - (countBlankLines(file) + countCommentLines(file));
	return codeLines;
}
