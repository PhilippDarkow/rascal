module analyzer::Analyzer

import reader::Reader;
import count::CountClasses;
import count::CountFunctions;
import count::CountIf;
import count::CountLines;


//Reader reader;
//private CountClasses countClasses;
//private CountFunctions countFunction;
//private CountIf countIf;
//private CountLines lines;

public void main(loc file){
	// Step 1 : We need to read the project with the reader
	loc workFile = Reader.readProject(file);	
	// Step 2 : Counting the lines of code
	println(CountLines.countLines(workFile));
	// Step 3 : Counting the If statements
	// Step 4 : counting the function
	// Step 5 : counting the classes
	// Step 6 : checking code duplication
}


