module count::CountProjects

import Set;
import IO;
import util::Resources;

public int countProjectsInWorkspace(set[loc] projects){
   return size(projects);
}

public void printNamesOfProjects(set[loc] projects){
    for(s <- projects)
    	println("Project Name : <s>");
}

