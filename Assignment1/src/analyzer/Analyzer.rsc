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
private CountLines lines;

public void main(loc file){
	// Step 1 : We need to read the project with the reader
	loc program = reader.readProject(file);	
	// Step 2 : Counting the lines of code
	println(lines.countLines(program));
	// Step 3 : Counting the If statements
	// Step 4 : counting the function
	// Step 5 : counting the classes
	// Step 6 : checking code duplication
}


