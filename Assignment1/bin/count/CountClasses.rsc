module count::CountClasses

import Prelude;
import reader::Reader;
import util::Resources;
import IO;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;

// countClasses(|project://SmallSQL|);   195   but java classes only 186
public int countClasses(loc project){	
	check = extProject(project);	
	classes = check@classes;
	classSet = domain(classes);
	println(classSet);
	return size(classSet);
}

/* Method to count the classes in a project
   @param project the project location
   @author Philipp
*/
public list[loc] countJavaClasses(loc project){
	check = extProject(project);	
	classes = check@packages;
	classSet = domain(classes);
	classList = toList(classSet);
	for(s <- classList){ 
		println("Java class name : <s.top>");
	}
	return classList;
}