module analyzer::Analyzer

import reader::Reader;
import count::CountClasses;
import count::CountFunction;
import count::CountIf;
import count::CountLines;

private Reader reader;
private CountClasses countClasses;
private CountFunction countFunction;
private CountIf countIf;
private CountLines countLines;

public void main(){
	// Step 1 : We need to read the project with the reader
	// Step 2 : Counting the lines of code
	// Step 3 : Counting the If statements
	// Step 4 : counting the function
	// Step 5 : counting the classes
	// Step 6 : checking code duplication
}


