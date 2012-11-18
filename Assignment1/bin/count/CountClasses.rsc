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
	return size(classSet);
}

// size(classList)
public int countJavaClasses(loc project){
	check = extProject(project);	
	classes = check@packages;
	classSet = domain(classes);
	classList = toList(classSet);
	for(int i <- [0..(size(classList) - 1)]) println("Java class name : <classList[i]>");  //; i < size(classList); i++){
	 
	
	return size(classList);
}