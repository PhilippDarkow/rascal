module analyzer::Analyzer

import IO;

import reader::Reader;
import count::CountClasses;
import count::CountFunctions;
import count::CountIf;
import count::CountLines;

public void main(loc file){
	// Step 1 : We need to read the project with the reader
	str project = readProjectFileOneString(file);
	list[str] projectArray = readProjectFileAsArray(file); 	
	// Step 2 : Counting the lines of code
	println("Lines in file total: <countLinesTotal(projectArray)>");
	// Step 3 : Counting the If statements
	// Step 4 : counting the function
	// Step 5 : counting the classes
	// Step 6 : checking code duplication
}


