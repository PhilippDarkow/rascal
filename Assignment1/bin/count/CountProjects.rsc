module count::CountProjects

import Set;
import IO;
import util::Resources;

/* Method to get the size of the projects in the current workspace
   @param projects the projects in the workspace
   @author Philipp
*/
public int countProjectsInWorkspace(set[loc] projects){
   return size(projects);
}

/* Method to print the names in the current workspace
   @param projects the projects in the workspace
   @author Philipp
*/
public void printNamesOfProjects(set[loc] projects){
    for(s <- projects)
    	println("Project Name : <s>");
}

