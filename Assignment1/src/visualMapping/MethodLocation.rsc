module visualMapping::MethodLocation

import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;
import complexcity::ComplexcityAnalyzer;
import util::Resources;
import Prelude;


public list[rel[loc,str]] getMethodLocation(AstNode file){
	list[rel[loc,str]] statement = [];
	visit(file) {
		case m:methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	   println("Method Location : <m@location>");
      	   relation = {<m@location,name>};
      	   statement += relation;	     	
     } 
   };
   return statement;
}

/* Method to get the while loops 
   @param file as an Astnode
   @return statement a list with 
   @author Philipp
*/
public list[loc] getWhileStatementsLocationClass(AstNode file){
	list[loc] statement = [];
	visit(file) {
     case w:whileStatement(AstNode expression, AstNode body) :{
      println("While Loop Location : <w@location>"); 
      statement += w@location;	 
      }
   };
   return statement;
}

/* Method to get the for loops location
   @param file as an Astnode
   @return statement a list with 
   @author Philipp
*/
public list[str] getForStatementsLocationClass(AstNode file){
	list[str] statement = [];
	visit(file) {
     case f:forStatement(list[AstNode] initializers, Option[AstNode] optionalBooleanExpression, list[AstNode] updaters, AstNode body) : println("For Loop Location : <f@location>"); 
   };
   return statement;
}

/* Method to get the switch loops location 
   @param file as an Astnode
   @return statement a list with 
   @author Philipp
*/
public list[str] getSwitchCaseStatementsLocation(AstNode file){
	list[str] statement = [];
	visit(file) {
     case s:switchCase(bool isDefault, Option[AstNode] optionalExpression) : println("Switch Case Location : <s@location>"); 
   };
   return statement;
}

/* Method to get the switch loops location 
   @param file as an Astnode
   @return statement a list with 
   @author Philipp
*/
public list[str] getIfStatementsLocation(AstNode file){
	list[str] statement = [];
	visit(file) {
     case i:ifStatement(AstNode booleanExpression, AstNode thenStatement, Option[AstNode] elseStatement) : println("If Statement Location : <i@location>"); 
   };
   return statement;
}


public list[str] getIfStatementsLocation(AstNode file){
	list[str] statement = [];
	visit(file) {
     case d:doStatement(AstNode body, AstNode whileExpression)  : println("Do Statement Location : <d@location>"); 
   };
   return statement;
}
