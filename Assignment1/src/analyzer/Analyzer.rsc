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

// main(|file://C:/Users/Philipp/Desktop/uni/SoftwareEvolution/workspace/SmallSQL|);
public void main(loc file){
	// Step 1 : We need to read the project with the reader
	list[str] projectArray = readProjectFileAsArray(file);
	
	set[loc] workspaceProjects = getAllProjects();
	workspaceList = toList(workspaceProjects);
	println(workspaceList[0]);
	// Step 2 : Count Projects
	println("Eclipse workspace contains : <countProjectsInWorkspace(workspaceProjects)> projects");	
	//println(printNamesOfProjects(workspaceProjects));	
	// Step 3 : counting the classes & packages
	println("<countJavaClasses(workspaceList[0])> classes are in the project");
	// Step 4 : Counting the lines of code
	println("Lines in file total: <countLinesTotal(projectArray)>");
	println("Comment Lines in file total: <countCommentLines(projectArray)>");
	println("Blank Lines in file total: <countBlankLines(projectArray)>");
	println("Code Lines in file total: <countCodeLines(projectArray)>");
	// Step 5 : Counting the If statements
	println("If statements in the file: <countIfs(projectArray)>");
	// Step 4 : Counting for and while loops
	println("For loops in the file: <countTotalFors(projectArray)>");
	println("While loops in the file: <countWhiles(projectArray)>");
	println("Total loops in the file: <countLoops(projectArray)>");
	// Step 5 : counting the function
	println("Void functions in the file: <countVoidFunctions(projectArray)>");
	println("Int functions in the file: <countVoidFunctions(projectArray)>");
	println("Boolean functions in the file: <countBooleanFunctions(projectArray)>");
	println("String functions in the file: <countStringFunctions(projectArray)>");
	println("Special functions in the file: <countSpecialFunctions(projectArray)>");
	println("Total functions in the file: <countTotalFunctions(projectArray)>");
	
	// Step 7 : checking code duplication
}


