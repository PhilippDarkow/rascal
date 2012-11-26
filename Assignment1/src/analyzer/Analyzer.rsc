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
import Set;
import List;

public void main(loc file){
	// Step 1 : We need to read the project with the reader 
	set[loc] workspaceProjects = getAllProjects();          	
	workspaceList = toList(workspaceProjects);               
	// Step 2 : Count Projects
	println("Eclipse workspace contains : <countProjectsInWorkspace(workspaceProjects)> projects");		
	println("Scan project : <workspaceList[0]>");
	// Step 3 : counting the classes & packages
	list[loc] javaClasses = countJavaClasses(workspaceList[0]);
	println("<size(javaClasses)> classes are in the project");
	println("Start with class : <javaClasses[0]>");	
	println("------ PRINT LINES -------");
	println("Total Blank lines in project : <countBlankLinesProject(javaClasses)>");
	println("Total Comment lines in project: <countCommentLinesProject(javaClasses)>");
	println("Total Code lines in project : <countCodeLinesProject(javaClasses)>");
	println("Total lines in project : <countLinesTotalProject(javaClasses)>");
	println("------ PRINT FUNCTIONS -------");
	println("Total Int functions in project : <countIntFunctionsProject(javaClasses)>");
	println("Total Boolean functions in project : <countBooleanFunctionsProject(javaClasses)>");
	println("Total String functions in project : <countStringFunctionsProject(javaClasses)>");
	println("Total Void functions in project : <countVoidFunctionsProject(javaClasses)>");
	println("Total Functions in project : <countTotalFunctionsProject(javaClasses)>");
	println("------ PRINT LOOPS -------");
	println("Total For loops in project : <countForLoopsProject(javaClasses)>");
	println("Total While loops in project : <countWhileLoopsProject(javaClasses)>");
	println("Total Do While loops in project : <countDoWhileLoopsProject(javaClasses)>");
	println("Total Loops in project : <countTotalLoopsProject(javaClasses)>");
	println("------ PRINT IFS -------");
	println("Total Ifs in project : <countIfsProject(javaClasses)>");
	// Step 7 : checking code duplication  
	
	// Step 8 : checking complexcity --> not complete at the moment
	scanProjectComplexity(javaClasses);
	// Step 9 : show Unit size
	println("------ UNIT SIZE -------");
	println("Unit Size measuring with Lines of codes : <countLinesTotalProject(javaClasses)>");
}


