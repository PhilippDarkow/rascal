module visualMapping::ClassVisible

import vis::Figure;
import vis::Render;
import reader::Reader;

import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;
import complexcity::ComplexcityAnalyzer;
import util::Resources;
import Prelude;
import visualMapping::MethodLocation;

/* Method to make one class visible
   @param file the file to make visible
   @author Philipp
*/
public void makeOneClassVisible(loc file){
	Resource extFile = makeAnAstnode(file);			
}

/* Function to map a while loop to a method declaration
   @
   @author Philipp
*/
public void mapWhileLoopToMethod(loc file){
	AstNode extFile = makeAnAstnode(file);
	list[loc] whileStatements = getWhileStatementsLocationClass(extFile);
	list[rel[loc,str]] methodStatements = getMethodLocation(extFile);
	println("WHILE STATEMENTS : <whileStatements>");
	println("Method STATEMENTS : <methodStatements>");
}

/* Method to show methods in a box
   @para file 
   @author Philipp
*/
public void showMethodsInClass(loc file){
	AstNode extFile = makeAnAstnode(file);
	list[str] whileStatements = getWhileStatementsLocationClass(extFile);
	list[str] forStatements = getForStatementsLocationClass(extFile);
	list[str] switchCaseStatements = getSwitchCaseStatementsLocation(extFile);
	list[str] ifStatements = getIfStatementsLocation(extFile);	
}