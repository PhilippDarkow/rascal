module complexcity::RiskAnalzer

import duplication::Checker;
import IO;
import List;
import count::CountIf;
import count::CountLoops;
import count::CountClasses;
import reader::Reader;
import util::Resources;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;
import Prelude;

/* Method to get one method of a java file
   @param file the file
   @return 
   @author Philipp
*/
public list[str] getOneMethodFromFile(list[str] file, int rowNumber){
	list[str] method = [];
	file = removeCommentsAndWhiteLinesFromFile(file);
	for(s <- file[rowNumber]){    // need to check this more
    if(/String\s\w*(\(\))\{\s*([\w\s\;\=\(\)\.]*)\}/ := s)  
      //println(s); 
      method += s;
      }
  return method;	
}

// String\s\w*(\(\))\{\s*([\w\s\;\=\(\)\.]*)\} 
// (String|int|boolean)\s\w*(\(\))\{\s*([\w\s\;\=\(\)\.]*)\}

public list[str] getMethodStartLineFile(list[str] file){
	list[str] method = [];
	file = removeCommentsAndWhiteLinesFromFile(file);
	for(s <- file){    // need to check this more
    if(/(String|int|boolean)\s\w*(\(\))\{/ := s)  {  // match begin of method
      startLine = s;
      method += s;
      return method;
      }
      }
      return method;  	
}

public list[str] getMethodEndLineFile(list[str] file){
	list[str] method = [];
	file = removeCommentsAndWhiteLinesFromFile(file);
	for(s <- file){    // need to check this more
    if(/(String|int|boolean)\s\w*(\(\))\{/ := s)  {  // match begin of method
      startLine = s;
      method += s;
      return method;
      }
      }
      return method;
}

/* Function to count the methods of a the project per java class
   @param project the project location
   @return methodMap a map that links a java file to the amount of functions
   @author Philipp
*/
public map[str, int] countMethods(loc project){	
	map[str, int] methodMap = ();
	facts = extProject(project);
	classes = {c | c:entity([_*,class(_)]) <- facts@declaredTopTypes};
	methods = (e : size((facts@declaredMethods)[e]) | e <- classes);
	for(m <- methods){
		//println("<readable(m)> : <methods[m]>");
		methodMap += (readable(m) : methods[m]);
		}
	return methodMap;
}

public int getMethodAmount(list[str] file){
	n = 0;
  for(s <- file)
    if(/(void|boolean|String|int|long|float|double|Strings|Expression|Expression\[\]|Column|SQLToken|Command|IndexDescription|File|SQLException|CommandSelect)\s\w*\((\s|[\w,\s,\[,\]]*)\)(\{|\s\w*\s\w|)/ := s) 
      n +=1;
  return n; 
}

public void getComplexityOfProject(loc project){	
	list[loc] javaClasses = countJavaClasses(project); 
	for(s <- javaClasses){
		println("Hallo <s.top>");
		list[str] file = readProjectFileAsArray(s.top);
		file = removeCommentsAndWhiteLinesFromFile(file);
		getComplexityFromMethod(file);
	}
}


public void getComplexityFromMethod(list[str] file){
	n = 0;
	int methodsInFile = getMethodAmount(file);	
	for(i <- [0..methodsInFile-1]){
	int startRow = getMethodStartLine(file,n);
	println("startrow is : <startRow>");
	list[str] method = findOneMethod(file,startRow);
	println(method);
	println("There is/are <countLoopsMethod(method)> loops in the method");
	//println("There is/are <countIfsMethod(method)> if statements in the method");
	n = (startRow + size(method));
	println("End Row is : <n>"); 
	}
}

//public int getAmountOfMethodsFile(file[str] file){
	
//}

/* Method to get the first method start line
   @param file the file to get the method startline
   @param startRow the row where to start to search
   @return int the start row of a method
   @author Philipp
*/
public int getMethodStartLine(list[str] file, int startRow){
	n = 0;
	fileSize = size(file);
	println(fileSize);
	for(i <- [startRow..fileSize - 1]){		
		if(/(void|boolean|String|int|long|float|double|Strings|Expression|Expression\[\]|Column|SQLToken|Command|IndexDescription|File|SQLException|CommandSelect)\s\w*\((\s|[\w,\s,\[,\]]*)\)(\{|\s\w*\s\w|)/ := file[i]){   // 3 version:(void|boolean|String|int|Expression|Column|SQLToken|Command|IndexDescription)\s\w*\((\s|[\w,\s]*)\)(\{|\s\w*\s\w)  2. version (void|boolean|String|int|long|float|double|Strings|Expression|Column|SQLToken|Command|IndexDescription|File)\s\w*\((\s|[\w,\s]*)\)(\{|\s\w*\s\w|)   
			println("method start");
			println("Line Number : <n>");
			return n + startRow;
			//list[str] method = findOneMethod(file, n);
			//countLoopsMethod(method);
			//countIfsMethod(method);
		} elseif(/(protected|public)\s\w*(\(\))/ := file[i]){
			return n + startRow;
		} elseif(i == fileSize){
			println("end of file");
		}
		n += 1;
	}
	return 0;
}

/* Method to get one method back 
   @param file the file as a list of string
   @param startRow the row where the method starts
   @author Philipp
*/
public list[str] findOneMethod(list[str] file, int startRow){
	list[str] method = [];
	brackets = 0;
	end = size(file);
	for(n <- [startRow..end]){
		//sprintln("in loop startROW: <n> End: <end>");    		
		if(/(\}catch\([\w,\s]*\)\{[\w\.\(\)\;]*\}|\{[\",\w,\s]*\}\,[\s,\w,\[,\]]*\{[\w\.\,\s]*\})/ := file[startRow]){
			brackets -= 1;	
			method += file[startRow];	
		} elseif(/\}\w*\(\w*\s\w*\)\{\w*\s\w*\;\}/ := file[startRow]){
			brackets -= 1;	
			method += file[startRow];	
		} elseif(/\}[\s\w\(\)]*\{[\/\*\s\w]*\}/ := file[startRow]){   // } catch (Exception ex1) {/* ignore it */}
		 	brackets -= 1;	
			method += file[startRow];
		} elseif(/(\{[\s,\w,\(,\)]*\}|\}\s\w*\s\([\w,\s,\)]*\{|\{[\s\w]*\.\w*\;\s\}|\{[\s,\w,\(,\)\.]*\})/ := file[startRow]){  // first version: \{[\s,\w,\(,\)]*\}  2 version: (\{[\s,\w,\(,\)]*\}|\}\s\w*\s\([\w,\s,\)]*\{)    
			println("open bracket and closed bracket found");
			method += file[startRow];		
		} elseif(/\{[\s,\",\w,\+\.]*\([\s,\w]*\)\s\}/ := file[startRow]){
			println("open bracket and closed bracket found");
			method += file[startRow];
		} elseif(/(\}else\{|\}catch\([\w,\s]*\)\{|\}finally\{|\}\selse\s\{|\}case\s[\w\.]*\:\{)/ := file[startRow]){
			method += file[startRow];		
		} elseif(/\{/ := file[startRow]){
			println("open bracket found");
			brackets += 1;
			//println("Brackets : <brackets>");
			method += file[startRow];
		} elseif(/\}/ := file[startRow]) {
			println("closed bracket found");
			brackets -= 1;
			//println("Brackets : <brackets>");
			method += file[startRow];
		} else {
			method += file[startRow];;
		}
		if(brackets == 0){
			//println("Method End !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			return method;
		}
		startRow += 1;
	}
}

/* Function to count the loops of a method
   @param method the method as a list of str
   @return loops amount of loops
*/
public int countLoopsMethod(list[str] method){
	//println(method);
	int i = countLoops(method);
	return i;
}

public int countIfsMethod(list[str] method){
	//println("count the ifs in the method");
	int i = countIfs(method);
	//println("There is/are <i> if statements in the method");
	return i;
}