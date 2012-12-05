/* Module to count classes of a java project

*/
module count::CountClasses

import Prelude;
import reader::Reader;
import util::Resources;
import IO;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;

/* Method to count the classes in a project
   @param project the project location
   @return classList a list with the locations of the project
   @author Philipp
*/
public list[loc] countJavaClasses(loc project){
	list[loc] javaClasses = []; 
	check = extProject(project);	
	classes = check@packages;
	classSet = domain(classes);
	classList = toList(classSet);
	for(s <- classList){ 
		if(/(junit|test)/ := "<s.top>") println("testclass : <s.top>");
		else javaClasses += s ;  
	}
	return javaClasses;
}