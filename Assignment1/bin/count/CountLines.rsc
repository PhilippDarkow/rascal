/* Module to count the lines of code of the project

*/
module count::CountLines

import IO;
import List;
import reader::Reader;

/* Method to count the total lines of a file 
   @param file the file as a list of string
   @return the lines of the file
   @author Philipp
*/
public int countLinesTotal(list[str] file){    
    return size(file);
}

/* Method to count all lines of a project
   @param project a list of location from the classes of the project
   @return lines the amount of all lines
   @author Philipp
*/
public int countLinesTotalProject(list[loc] project){
	int lines = countCommentLinesProject(project);
	lines += countBlankLinesProject(project);
	lines += countCodeLinesProject(project);
	return lines;
}

/* Method to count the comments of a file 
   @param file the file as a list of string
   @return the comments of a file
   @author Philipp 
*/
public int countComment(list[str] file){	
  n = 0;
  for(s <- file)
    if(/\*(.|[\r\n])*?\*/ := s)  
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
    if(/((\s|\/*)(\/\*|\s\*)|[^\w,\;]\s\/*\/)/ := s)   
      n +=1;
  return n;
}

/* Method to count all comment lines of a project
   @param project a list of location from the classes of the project
   @return n the amount of all comment lines
   @author Philipp
*/
public int countCommentLinesProject(list[loc] project){
	n = 0;
	for(s <- project){
		file = readProjectFileAsArray(s.top);
		lines = countCommentLines(file);
		n += lines;
	}
	return n;	
}

/* Method to count the blank lines  
   @param file the java file
   @return number of blank lines
   @author Philipp
*/
public int countBlankLines(list[str] file){
	n = 0;
  for(s <- file)
    if(/^[ \t\r\n]*$/ := s)  
      n +=1;
  return n;
}

/* Method to count all blank lines of a project
   @param project a list of location from the classes of the project
   @return n the amount of all blank lines
   @author Philipp
*/
public int countBlankLinesProject(list[loc] project){
	n = 0;
	for(s <- project){
		file = readProjectFileAsArray(s.top);
		lines = countBlankLines(file);
		n += lines;
	}
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

/* Method to count all code lines of a project
   @param project a list of location from the classes of the project
   @return n the amount of all code lines
   @author Philipp
*/
public int countCodeLinesProject(list[loc] project){
	n = 0;
	for(s <- project){
		file = readProjectFileAsArray(s.top);
		lines = countCodeLines(file);
		n += lines;
	}
	return n;	
}
