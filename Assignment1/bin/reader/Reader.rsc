/* Module to read a file or project

*/
module reader::Reader

import util::Resources;
import IO;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;
import Prelude;
import Set;
import Map;


/* Method to read the file
   @return the file in an array of string ( each position is one line )
   @author Philipp
*/
public list[str] readProjectFileAsArray(loc file){
	return readFileLines(file);
}

/* Method to read a project
   @return the project with getProject
   @author Philipp
*/
public Resource giveProject(loc project){
	return getProject(project);  
}

/* Method to extract a project 
   @param project the project location
   @return the project as a resource
   @author Philipp
*/
public Resource extProject(loc project){
   return extractProject(project);  
}

/* Method to get all projects which are in the current workspace
   @author Philipp
*/
public set[loc] getAllProjects(){
  return projects();
}