module unitTesting::AssertStatement

import reader::Reader;
import Prelude;
import util::Resources;
import IO;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;

/* Method to count the assert statements per file
   @param file the location of the file
*/
public int countAssertStatements(loc file){
	n = 0;
  for(s <- file)
    if(/assert(True|Equals|False)/ := s) 
      n +=1;
  return n;	
}

/* Method to count all assert statements of the unit test files
   @param package the location of the test package
   //get files of the package and then call with a for loop for every file the countAssertStatements
*/
public int countTotalAssertStatements(loc package){
    t = extProject(package);
    k = t@classes;
    classSet = domain(k);
    print(classSet);	
	return 0;
}