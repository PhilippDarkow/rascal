module count::CountProjects

import Set;
import IO;

public int countProjectsInWorkspace(set[loc] projects){
   return size(projects);
}

public void printNamesOfProjects(set[loc] projects){
    for(s <- projects)
    	println("Project Name : <s>");
}