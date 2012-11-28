/* Module to check if a file or a project has duplication

*/
module duplication::Checker

import Prelude;
import List;
import reader::Reader;

/* Method to check the project of duplication --- IS NOT COMPLETE
   @param project a list of locations of the files in the project
   @author Philipp
*/
public void checkDuplicationProject(list[loc] project){
	for(s <- project){
		list[str] file = readProjectFileAsArray(s.top);
		println("URI : <s.top>");
		file = removeCommentsAndWhiteLinesFromFile(file);
		duplicationOneFile(file);
	}
}

/* Method to check 2 files for code duplication
   @param orginalFile the orginal file
   @compareFile the file to compare with
   @author Philipp
*/
public void checkCodeDuplicationFiles(list[str] orginalFile, list[str] compareFile){
		
}

/* Method to check duplication in one file 
   @param file the file to check
   @return
   @author Philipp
*/
public bool duplicationOneFile(list[str] file){
	for(i <- [0..size(file)- 6 ]){
		if(checkCodeDuplicationInOneFile(file, i)) {
			println("i is <i>");
			return true;   // stops by the first occur from duplication in a file
		}else{
			println("no duplication in file");
			return false;
		}
	}
}

/* Method to check one file for code duplication  --- NOT COMPLETE NOW
   @param file the file to check for duplication
   @author Philipp
*/
public bool checkCodeDuplicationInOneFile(list[str] file, int lineNumber){
	bool check = true;
	//file = removeCommentsAndWhiteLinesFromFile(file);
	FileList = takeNextLines(file, lineNumber);
	compareList = FileList[0];
	codeClone = FileList[1];
	list[str] lines = [];
	for(i <- [0..size(codeClone)- 1 ]){
		for(u <- [0..5]){
			if(i+u >= size(codeClone)){
				check = false;
			}else{
				println("codeClone[u+i] : <codeClone[u+i]>");
				lines += codeClone[u+i];  // get error |project://rascal/src/duplication/Checker.rsc|(1484,1,<53,25>,<53,26>): EmptyList()
			}
		}
		//println("CodeClone : <codeClone[i]>   Lines : <lines[0]>");
		if(check == false && size(lines) < 6){
			lines = [];
			check = true;
		}else{
			if(checkSixRows(compareList, lines)){
			 	println("found duplication");
			 	//println(codeClone);
			 	codeClone = removeDublicationFromList(codeClone, i);
			 	return true;
			 }
		lines = [];
		}
	}
	return false;
}

/* Method to remove the lines that are duplicates 
   @param file a list of str representing the file
   @param rowNumber the rownumber where to start to remove
   @return file without the duplication
   @author Philipp
*/
public list[str] removeDublicationFromList(list[str] file, int rowNumber){
	//println("FILE START : <file>");
	println("SIZE FILE : <size(file)>");
	for(i <- [0..size(file)]){
		if(i == rowNumber){
			for(k <- [0..5]){
			println("i : <i>    k : <k>");
			//println("remove part : <file[i+k]>");
			//println("i : <i>    k : <k>");
			file = delete(file,i);
			}
		//println("FILE : <file>");
		return file;
		}
	}
}

/* Method to check six rows from two lists
   @param compareList
   @param lines
   @return true when the six lines identical
   @author Philipp
*/
public bool checkSixRows(list[str] compareList,list[str] lines){
	checkCounter = 0;
	for(i <- [0..size(compareList) - 1]){  // lines
		str com = compareList[i];   // I need to replace all white spaces in front of the code to check it better
		com = replaceAll(com, "\t", "");
		com = replaceAll(com, " ", "");
		str lin =  lines[i];
		lin = replaceAll(lin, "\t", "");
		lin = replaceAll(lin, " ", "");
		//println("compare : <com>  lines : <lin>");		
		if(com == lin)	checkCounter += 1;  // When I found true i need to marker that linen and remove them from the file
		else return false;
	}
	//println("-------------------- <checkCounter>");	
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
		//println("File : <file[i]>   i : <i>");
		for(a <- [0..5]){
			if(i + a <= size(file) - 1){
			//println("i+a : <i+a>   size : <size(file)>");
			compareList += file[i + a];
			codeClone = delete(codeClone, i);
			}
		}
		//println(compareList);
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

/* Method to remove the Comment Lines of a file
   @param file the file where the comment lines should get removed
   @return file the file without comment lines
   @author Philipp
*/
public list[str] removeCommentsFromFile(list[str] file){
  list[str] fileWithoutWhiteLines = [];
  for(int i <- [0..(size(file) - 1)]){
      if(/((\s|\/*)(\/\*|\s\*)|[^\w,\;]\s\/*\/)/ := file[i]){
          print("");
       } else {
       	  fileWithoutWhiteLines += file[i] ;       	 
       }       
      } 
      return fileWithoutWhiteLines;
}