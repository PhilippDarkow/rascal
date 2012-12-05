/* Module to check if a file or a project has duplication

*/
module duplication::Checker

import IO;
import Type;
import Prelude;
import List;
import reader::Reader;



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
/* Method to remove the Comment Lines of a file
   @param file the file where the comment lines should get removed
   @return file the file without comment lines
   @author Abisha
*/
public void checkCodeDuplicationInOneFile(list[str] file)
{
	list[str]duplicates = removeCommentsAndWhiteLinesFromFile(file);
	list[str] nonDuplicates = [];
	int count =0;
	int numDuplicates = 0;
	
	for(int i<-[0..size(duplicates)-1])
	{
	
				if(size(duplicates) > i && (duplicates[i] in nonDuplicates))
				{
					//println("duplicate! <count>");
					count+=1;
				}
				else 
				{
					if(count > 5) 
					{
						numDuplicates += 1;
					}
					nonDuplicates+=duplicates[i];
					count=0;
					//println("nonduplicate <count>");
					
				}
//		println("number of duplicates is: <numDuplicates> ");
}
println("Number of duplicates: <numDuplicates> ");
}


public void checkDuplicationProject(list[loc] project){
	list[str] file = [];
	for(s <- project){
		file += readProjectFileAsArray(s.top);
	}
	checkCodeDuplicationInOneFile(file);
		
}
