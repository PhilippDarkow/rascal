/* Module to compute the unit size

*/
module unitSize::UnitSize

import complexcity::ComplexcityAnalyzer;
import duplication::Checker;
import util::Resources;
import IO;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;
import Prelude;
import Set;
import List;
import Map;
import reader::Reader;
import count::CountLines;


public void getCodeLinesToMethod(list[loc] project){
	num simpleAll = 0;
	num moreComplexAll = 0;
	num complexAll = 0;
	num untestableAll = 0;
	for(s <- project){
		simpleMethods = getSimpleMethodName(s.top);
		moreComplexMethods = getMoreComplexMethodName(s.top);
		complexMethods = getComplexMethodName(s.top);
		untestableMethods = getUntestableMethodName(s.top);
		//println("Simple Methods : <simpleMethods> + Code lines : <countMethodLinesFile(simpleMethods)>");
		simpleAll += countMethodLinesFile(simpleMethods);
		//println("More Complex Methods : <moreComplexMethods> + Code lines : <countMethodLinesFile(moreComplexMethods)>");
		moreComplexAll += countMethodLinesFile(moreComplexMethods);
		//println("Complex Methods : <complexMethods> + Code lines : <countMethodLinesFile(complexMethods)>");
		complexAll += countMethodLinesFile(complexMethods);
		//println("Untestable  Methods : <untestableMethods> + Code lines : <countMethodLinesFile(untestableMethods)>");
		untestableAll += countMethodLinesFile(untestableMethods);
		//println("-------------------------------------");
	}
	//println("Simple Methods Code lines : <simpleAll>");
	//println("More Complex Methods Code lines : <moreComplexAll>");
	//println("Complex Methods Code lines : <complexAll>");
	//println("Untestable Methods Code lines : <untestableAll>");
	// calculate complexcity in percentage
	num codeLines = countCodeLinesProject(project);
	num simpleProcent = (simpleAll / ( codeLines / 100 ));
	num moreComplexProcent = (moreComplexAll / ( codeLines / 100 ));
	num complexProcent = (complexAll / ( codeLines / 100 ));
	num untestableProcent = (untestableAll / ( codeLines / 100 ));
	println("<simpleProcent> % are simple");
	println("<moreComplexProcent> % are more complex");
	println("<complexProcent> % are complex");
	println("<untestableProcent> % are untestable");
} 

public num countMethodLinesFile(list[rel[str name,int lines]] methodsLines){
	list[int] total = [];
	if(size(methodsLines) >= 1){
	for(i <- [0..size(methodsLines) - 1]){
		lineCountSet = methodsLines[i].lines;
		lineCountList = toList(lineCountSet);
		total += lineCountList;	
	}
	return sum(total);
	}else return 0;
}

/* Method to get the method length of a method --> NOT WORKING
   @param returnType a option with astnode 
   @author Philipp
*/
public int getMethodLength(loc file){
	methodLength = (file.end.line - file.begin.line) + 1;
	return methodLength;
}

/* Method to get the names of the simple methods
   @param the file as an ast node
   @return a list with the names of the methods
   @author Philipp
*/
public list[rel[str,int]] visitSimpleMethods(AstNode classNode){  // list[str]
	list[rel[str,int]] met = []; 
	rel[str,int] relation;
	oldName = "";
	countComplexity = 0;
	visit(classNode) {
     case m:methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	if(name != oldName){   		
      		int complexcity = calculateComplexcity(countComplexity);
      		int lines = getMethodLength(m@location);
      		if(complexcity == 1) {
      		relation = ({<name,lines>}); 
      		met += relation;
      		}     				
      		countComplexity = 0;
      	}
      	oldName = name;     	     	
     }
     case forStatement(list[AstNode] initializers, Option[AstNode] optionalBooleanExpression, list[AstNode] updaters, AstNode body) : countComplexity += 1;
     case whileStatement(AstNode expression, AstNode body) : countComplexity += 1; 
     case ifStatement(AstNode booleanExpression, AstNode thenStatement, Option[AstNode] elseStatement) : countComplexity += 1;
     case switchCase(false, Option[AstNode] optionalExpression) : countComplexity += 1;
     case doStatement(AstNode body, AstNode whileExpression) : countComplexity += 1;
     //case switchStatement(AstNode expression, list[AstNode] statements) : countComplexity += 1;
   };   
   return met;
}

/* Method to get the names of the more complex methods
   @param the file as an ast node
   @return a list with the names of the methods
   @author Philipp
*/
public list[rel[str,int]] visitMoreComplexMethods(AstNode classNode){
	list[rel[str,int]] met = []; 
	rel[str,int] relation;
	oldName = "";
	countComplexity = 0;
	visit(classNode) {
     case m:methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	if(name != oldName){   		
      		int complexcity = calculateComplexcity(countComplexity);
      		int lines = getMethodLength(m@location);
      		if(complexcity == 2) {
      		relation = ({<name,lines>});
      		met += relation;
      		}
      		countComplexity = 0;
      	}
      	oldName = name;     	     	
     }
     case forStatement(list[AstNode] initializers, Option[AstNode] optionalBooleanExpression, list[AstNode] updaters, AstNode body) : countComplexity += 1;
     case whileStatement(AstNode expression, AstNode body) : countComplexity += 1; 
     case ifStatement(AstNode booleanExpression, AstNode thenStatement, Option[AstNode] elseStatement) : countComplexity += 1;
     case switchCase(bool isDefault, Option[AstNode] optionalExpression) : countComplexity += 1;
     case doStatement(AstNode body, AstNode whileExpression) : countComplexity += 1;
     case switchStatement(AstNode expression, list[AstNode] statements) : countComplexity += 1;
   };   
   return met;
}

/* Method to get the names of the complex methods
   @param the file as an ast node
   @return a list with the names of the methods
   @author Philipp
*/
public list[rel[str,int]] visitComplexMethods(AstNode classNode){
	list[rel[str,int]] met = []; 
	rel[str,int] relation;
	oldName = "";
	countComplexity = 0;
	visit(classNode) {
     case m:methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	if(name != oldName){   		
      		int complexcity = calculateComplexcity(countComplexity);
      		int lines = getMethodLength(m@location);
      		if(complexcity == 3){ 
      			relation = ({<name,lines>});
      			met += relation;
      		}      		
      		countComplexity = 0;
      	}
      	oldName = name;     	     	
     }
     case forStatement(list[AstNode] initializers, Option[AstNode] optionalBooleanExpression, list[AstNode] updaters, AstNode body) : countComplexity += 1;
     case whileStatement(AstNode expression, AstNode body) : countComplexity += 1; 
     case ifStatement(AstNode booleanExpression, AstNode thenStatement, Option[AstNode] elseStatement) : countComplexity += 1;
     case switchCase(bool isDefault, Option[AstNode] optionalExpression) : countComplexity += 1;
     case doStatement(AstNode body, AstNode whileExpression) : countComplexity += 1;
     case switchStatement(AstNode expression, list[AstNode] statements) : countComplexity += 1;
   };   
   return met;
}

/* Method to get the names of the untestable methods
   @param the file as an ast node
   @return a list with the names of the methods
   @author Philipp
*/
public list[rel[str,int]] visitUntestableMethods(AstNode classNode){
	list[rel[str,int]] met = []; 
	rel[str,int] relation;
	oldName = "";
	countComplexity = 0;
	visit(classNode) {
     case m:methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	if(name != oldName){    		
      		int complexcity = calculateComplexcity(countComplexity);
      		int lines = getMethodLength(m@location);
      		if(complexcity == 4){
      		relation = ({<name,lines>});
      		met += relation;
      		}      		
      		countComplexity = 0;
      	}
      	oldName = name;     	     	
     }
     case forStatement(list[AstNode] initializers, Option[AstNode] optionalBooleanExpression, list[AstNode] updaters, AstNode body) : countComplexity += 1;
     case whileStatement(AstNode expression, AstNode body) : countComplexity += 1; 
     case ifStatement(AstNode booleanExpression, AstNode thenStatement, Option[AstNode] elseStatement) : countComplexity += 1;
     case switchCase(bool isDefault, Option[AstNode] optionalExpression) : countComplexity += 1;
     case doStatement(AstNode body, AstNode whileExpression) : countComplexity += 1;
     case switchStatement(AstNode expression, list[AstNode] statements) : countComplexity += 1;
   };   
   return met;
}

/* Method to get the names of simple methods
   @return simpleMethods a list of str with the names of simple methods
   @author Philipp
*/
public list[rel[str,int]] getSimpleMethodName(loc file){
	fileNode = makeAnAstnode(file);	
	simpleMethods = visitSimpleMethods(fileNode);
	return simpleMethods;
}

/* Method to get the names of more complex methods
   @return moreComplexMethods a list of str with the names of more complex methods
   @author Philipp
*/
public list[rel[str,int]] getMoreComplexMethodName(loc file){
	fileNode = makeAnAstnode(file);	
	moreComplexMethods = visitMoreComplexMethods(fileNode);
	return moreComplexMethods;
}

/* Method to get the names of complex methods
   @return complexMethods a list of str with the names of complex methods
   @author Philipp
*/
public list[rel[str,int]] getComplexMethodName(loc file){
	fileNode = makeAnAstnode(file);	
	complexMethods = visitComplexMethods(fileNode);
	return complexMethods;
}

/* Method to get the names of untestable methods
   @return untestableMethods a list of str with the names of untestable methods
   @author Philipp
*/
public list[rel[str,int]] getUntestableMethodName(loc file){
	fileNode = makeAnAstnode(file);	
	untestableMethods = visitUntestableMethods(fileNode);
	return untestableMethods;
}