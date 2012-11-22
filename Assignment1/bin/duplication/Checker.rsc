module duplication::Checker

import Prelude;
import List;

/* Method to check files for code duplication
*  if 6 blocks identical it is a code duplication
*/
public void checkCodeDuplicationFiles(list[str] file, list[str] file){

}

/* Method to check one file for code duplication
*  if 6 blocks identical it is a code duplication
*/
public void checkCodeDuplicationInOneFile(list[str] file){

}


/* Method to remove the Comment and White Lines of a file
   @param file the file where the white lines should get removed
   @return file the file without comment and white lines
   @author Philipp
*/
public list[str] removeCommentsAndWhiteLinesFromFile(list[str] file){
	list[str] fileWithout = removeWhiteLinesFromFile(file);
	fileWithout = removeCommentsFromFile(fileWithout);
	return fileWithout;
}

/* Method to remove the White Lines of a file
   @param file the file where the white lines should get removed
   @return file the file without white lines
   @author Philipp
*/
public list[str] removeWhiteLinesFromFile(list[str] file){
  list[str] fileWithoutWhiteLines = [];
  for(int i <- [0..(size(file) - 1)]){
      if(/^[ \t\r\n]*$/ := file[i]){
          println("WhiteLine");
      	  // fileWithoutWhiteLines =delete(file, i);
       } else {
       	  fileWithoutWhiteLines += file[i] ;       	 
       }       
      } 
      return fileWithoutWhiteLines;
}

public list[str] removeCommentsFromFile(list[str] file){
  list[str] fileWithoutWhiteLines = [];
  for(int i <- [0..(size(file) - 1)]){
      if(/((\s|\/*)(\/\*|\s\*)|[^\w,\;]\s\/*\/)/ := file[i]){
          println("Comment");
      	  // fileWithoutWhiteLines =delete(file, i);
       } else {
       	  fileWithoutWhiteLines += file[i] ;       	 
       }       
      } 
      return fileWithoutWhiteLines;
}