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
public list[str] checkCodeDuplicationInOneFile(list[str] file){
	file = removeCommentsAndWhiteLinesFromFile(file);

	FileList = takeNextLines(file, 0);
	compareList = FileList[0];
	codeClone = FileList[1];
	
	list[str] lines = [];
		for(i <- [0..size(codeClone) - 1]){
			println("start loop with i : <i>");
			if(size(lines) == 6){
				println("we have 6 rows");
				if(checkSixRows(compareList, lines)) println("found duplication");
				else println("no duplication");
				lines = [];
			}
			lines += codeClone[i];
		}

	return codeClone;
}

/* Method to check six rows from two lists
   @param compareList
   @param lines
   @return true when the six lines identical
   @author Philipp
*/
public bool checkSixRows(list[str] compareList,list[str] lines){
	checkCounter = 0;
	for(i <- [0..5]){
		if(compareList[i] == lines[i])	checkCounter += 1;
	}	
	if(checkCounter == 6) return true;
	else return false;
}

/* Method to take the next lines from a list
   @param file the file to take the six lines
   @param fileNumber the fileNumber to take lines from 
   @return list with 6 lines
   @author Philipp
*/
public list[list[str]] takeNextLines(list[str] file, int fileNumber){
	codeClone = file;
	compareList = [];
	for(i <- [0..size(file) - 1]){
		if(fileNumber == i){
		for(a <- [0..5]){
			compareList += file[a];
			codeClone = delete(codeClone, 0);
		}
		return [compareList,codeClone];
		}
	}
	return [[]];
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
          print("");
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
          print("");
      	  // fileWithoutWhiteLines =delete(file, i);
       } else {
       	  fileWithoutWhiteLines += file[i] ;       	 
       }       
      } 
      return fileWithoutWhiteLines;
}