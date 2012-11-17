module analyzer::Analyzer

import IO;

import reader::Reader;
import count::CountClasses;
import count::CountFunctions;
import count::CountIf;
import count::CountLines;
import count::CountLoops;

public void main(loc file){
	// Step 1 : We need to read the project with the reader
	str project = readProjectFileOneString(file);
	list[str] projectArray = readProjectFileAsArray(file); 	
	// Step 2 : Counting the lines of code
	println("Lines in file total: <countLinesTotal(projectArray)>");
	println("Comment Lines in file total: <countCommentLines(projectArray)>");
	println("Blank Lines in file total: <countBlankLines(projectArray)>");
	println("Code Lines in file total: <countCodeLines(projectArray)>");
	// Step 3 : Counting the If statements
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
	// Step 6 : counting the classes & packages
	// Step 7 : checking code duplication
}


