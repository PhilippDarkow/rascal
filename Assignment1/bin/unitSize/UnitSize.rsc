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

public map[str,int] getCodeLinesToMethod(){
	simpleMethods = getSimpleMethodName(file);
} 

public void printData(loc file){
	simpleMethods = getSimpleMethodName(file);
	//moreComplexMethods = getMoreComplexMethodName(file);
	//complexMethods = getComplexMethodName(file);
	//untestableMethods = getUntestableMethodName(file);
	println("Simple Methods : <simpleMethods>");
	//println("More Complex Methods : <moreComplexMethods>");
	//println("Complex Methods : <complexMethods>");
	//println("Untestable  Methods : <untestableMethods>");
}

/* Method to get the method length of a method --> NOT WORKING
   @param returnType a option with astnode 
   @author Philipp
*/
public void getMethodLength(Option[AstNode] returntype){
	AstNode aa = returntype@simpleType;   // --> this is not working
	println(aa);

	visit(returntype) {
	 case returntype : println(returntype@location);
	}
}

/* Method to get the names of the simple methods
   @param the file as an ast node
   @return a list with the names of the methods
   @author Philipp
*/
public list[str] visitSimpleMethods(AstNode classNode){
	list[str] met = []; 
	oldName = "";
	countComplexity = 0;
	visit(classNode) {
     case methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	println("!!!! Location : <classNode@location>");
      	if(name != oldName){   
      		println(name);  		
      		int complexcity = calculateComplexcity(countComplexity);
      		if(complexcity == 1) met += name; // countSimple += 1;
      		println("method end !!!!!!!!!!!!!!!!!!");
      		println(returnType);
      		//getMethodLength(returnType);
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

/* Method to get the names of the more complex methods
   @param the file as an ast node
   @return a list with the names of the methods
   @author Philipp
*/
public list[str] visitMoreComplexMethods(AstNode classNode){
	list[str] met = []; 
	oldName = "";
	countComplexity = 0;
	visit(classNode) {
     case methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	if(name != oldName){   
      		println(name);  		
      		int complexcity = calculateComplexcity(countComplexity);
      		if(complexcity == 2) met += name;
      		println("method end");
      		countComplexity = 0;
      	}
      	println(classNode@location);
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
public list[str] visitComplexMethods(AstNode classNode){
	list[str] met = []; 
	oldName = "";
	countComplexity = 0;
	visit(classNode) {
     case methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	if(name != oldName){   
      		println(name);  		
      		int complexcity = calculateComplexcity(countComplexity);
      		if(complexcity == 3) met += name;
      		println("method end");
      		countComplexity = 0;
      	}
      	println(classNode@location);
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
public list[str] visitUntestableMethods(AstNode classNode){
	list[str] met = []; 
	oldName = "";
	countComplexity = 0;
	visit(classNode) {
     case methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	if(name != oldName){   
      		println(name);  		
      		int complexcity = calculateComplexcity(countComplexity);
      		if(complexcity == 4) met += name;
      		println("method end");
      		countComplexity = 0;
      	}
      	println(classNode@location);
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
public list[str] getSimpleMethodName(loc file){
	fileNode = makeAnAstnode(file);	
	simpleMethods = visitSimpleMethods(fileNode);
	return simpleMethods;
}

/* Method to get the names of more complex methods
   @return moreComplexMethods a list of str with the names of more complex methods
   @author Philipp
*/
public list[str] getMoreComplexMethodName(loc file){
	fileNode = makeAnAstnode(file);	
	moreComplexMethods = visitMoreComplexMethods(fileNode);
	return moreComplexMethods;
}

/* Method to get the names of complex methods
   @return complexMethods a list of str with the names of complex methods
   @author Philipp
*/
public list[str] getComplexMethodName(loc file){
	fileNode = makeAnAstnode(file);	
	complexMethods = visitComplexMethods(fileNode);
	return complexMethods;
}

/* Method to get the names of untestable methods
   @return untestableMethods a list of str with the names of untestable methods
   @author Philipp
*/
public list[str] getUntestableMethodName(loc file){
	fileNode = makeAnAstnode(file);	
	untestableMethods = visitUntestableMethods(fileNode);
	return untestableMethods;
}