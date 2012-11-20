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

// size(classList)
public list[loc] countJavaClasses(loc project){
	check = extProject(project);	
	classes = check@packages;
	classSet = domain(classes);
	classList = toList(classSet);
	for(s <- classList){ 
		if(/\|\w*\:\/*[\w,\/]*\.java\|/ := s.uri)
		println("Java class name : <s>");  
	}	
	// regular expression to get just the classes without the extension \|\w*\:\/*[\w,\/]*\.java\|
	// int i <- [0..(size(classList) - 1)]
	// println("Java class name : <classList[i]>"); 
	return classList;
}


public Resource countJavaClassesWithGetProject(loc project){
	javaProject = getProject(project);
	//javaClasses = javaProject@classes;
	return javaProject;
}