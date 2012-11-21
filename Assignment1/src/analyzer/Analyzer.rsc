module analyzer::Analyzer

import IO;

import reader::Reader;
import count::CountClasses;
import count::CountFunctions;
import count::CountIf;
import count::CountLines;
import count::CountLoops;
import count::CountProjects;
import Set;
import List;

// main(|file://C:/Users/Philipp/Desktop/uni/SoftwareEvolution/workspace/SmallSQL|);
public void main(loc file){
	// Step 1 : We need to read the project with the reader 
	set[loc] workspaceProjects = getAllProjects();           // get all the Projects in the current workspace
	
	workspaceList = toList(workspaceProjects);               // make the workspace to a list
	// Step 2 : Count Projects
	println("Eclipse workspace contains : <countProjectsInWorkspace(workspaceProjects)> projects");		
	println("Scan project : <workspaceList[0]>");
	// Step 3 : counting the classes & packages
	list[loc] javaClasses = countJavaClasses(workspaceList[0]);
	println("<size(javaClasses)> classes are in the project");
	println("Start with class : <javaClasses[0]>");
	for(int i <- [0..(size(javaClasses) - 1)]){ 
		println("Java class name : <javaClasses[i].top>");   // i need to cut the optional part of the location
		list[str] fileToRead = readProjectFileAsArray(javaClasses[i].top);
		
		
	// Step 4 : Counting the lines of code
	println("Lines in file total: <countLinesTotal(fileToRead)>");   
	println("Comment Lines in file total: <countCommentLines(fileToRead)>");
	println("Blank Lines in file total: <countBlankLines(fileToRead)>");
	println("Code Lines in file total: <countCodeLines(fileToRead)>");
	// Step 5 : Counting the If statements
	println("If statements in the file: <countIfs(fileToRead)>");
	// Step 4 : Counting for and while loops
	println("For loops in the file: <countTotalFors(fileToRead)>");
	println("While loops in the file: <countWhiles(fileToRead)>");
	println("Total loops in the file: <countLoops(fileToRead)>");
	// Step 5 : counting the function
	println("Void functions in the file: <countVoidFunctions(fileToRead)>");
	println("Int functions in the file: <countVoidFunctions(fileToRead)>");
	println("Boolean functions in the file: <countBooleanFunctions(fileToRead)>");
	println("String functions in the file: <countStringFunctions(fileToRead)>");
	println("Special functions in the file: <countSpecialFunctions(fileToRead)>");
	println("Total functions in the file: <countTotalFunctionsClass(fileToRead)>");
	}
	
	println("Total Blank lines in project : <countBlankLinesProject(javaClasses)>");
	println("Total Comment lines in project: <countCommentLinesProject(javaClasses)>");
	println("Total Code lines in project : <countCodeLinesProject(javaClasses)>");
	println("Total lines in project : <countLinesTotalProject(javaClasses)>");
	// Step 7 : checking code duplication
}


