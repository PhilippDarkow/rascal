/* Main module to start the scan of a java project
*/
module analyzer::Analyzer

import IO;

import reader::Reader;
import count::CountClasses;
import count::CountFunctions;
import count::CountIf;
import count::CountLines;
import count::CountLoops;
import count::CountProjects;
import complexcity::ComplexcityAnalyzer;
import duplication::Checker;
import unitSize::UnitSize;
import Set;
import List;

/* Main method 
   @author Philipp
*/
public void main(){
	// Step 1 : We need to read the project with the reader 
	set[loc] workspaceProjects = getAllProjects();          	
	workspaceList = toList(workspaceProjects);               
	// Step 2 : Count Projects
	println("Eclipse workspace contains : <countProjectsInWorkspace(workspaceProjects)> projects");		
	println("Scan project : <workspaceList[1]>");
	println(workspaceList);
	// Step 3 : counting the classes & packages
	list[loc] javaClasses = countJavaClasses(workspaceList[0]);
	println("<size(javaClasses)> classes are in the project");
	println("------ PRINT LINES -------");
	println("Total Blank lines in project : <countBlankLinesProject(javaClasses)>");
	println("Total Comment lines in project: <countCommentLinesProject(javaClasses)>");
	println("Total Code lines in project : <countCodeLinesProject(javaClasses)>");
	println("Total lines in project : <countLinesTotalProject(javaClasses)>");
	// Step 7 : checking code duplication  
	checkDuplicationProject(javaClasses); 
	// Step 8 : checking complexcity -- not complete at the moment
	scanProjectComplexity(javaClasses);
	// Step 9 : show Unit size
	println("------ UNIT SIZE ---------");
	//println("Unit Size measuring with Lines of codes : <countLinesTotalProject(javaClasses)>");
	getCodeLinesToMethod(javaClasses);
}


