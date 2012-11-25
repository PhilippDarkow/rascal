module complexcity::ComplexcityAnalyzer

import util::Resources;
import IO;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;
import Prelude;
import Set;


/* Method to scan the complexity of the project
   @param project the project to scan
   @author Philipp
*/
public void scanProjectComplexity(list[loc] project){
	for(s <- project){
		println("visiting loc <s.top>");
		AstNode class = makeAnAstnode(s.top);
		visitMethodsNotesOfFile(class);
		println("--------------------------");
	}
}

/* Method to create an Astnode of a file
   @param loc the location of the file
   @return astNode of the file
   @author Philipp
*/
public AstNode makeAnAstnode(loc file){
	classNode = createAstFromFile(file);
	return createAstFromFile(file);
}

public void visitSetOfNodes(set[AstNode] setOfNodes){
	for(s <- setOfNodes){
		println("----------------------------------------- <s>");
		visitAstNode(s);
	}
}


public void visitAstNode(AstNode classNode){
	visit(classNode) {
     case importDeclaration(name,staticImport,onDemand) : println("importDeclaration");   // AstNode 
     case typeDeclaration(list[Modifier] modifiers,list[AstNode] annotations,str objectType,str name,list[AstNode] genericTypes,Option[AstNode] extends,list[AstNode] implements,list[AstNode] bodyDeclarations) : println("typeDeclaration");
     case methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) : println("methodDeclaration : <name>");
     case fieldDeclaration(modifiers,annotations,\type,fragments) : println("fieldDeclaration"); 
     case constructorInvocation(list[AstNode] genericTypes, list[AstNode] typedArguments) : println("constructorInvocation");
     case packageDeclaration(str name, list[AstNode] annotations) : println("packageDeclaration : <name>"); 
     case variableDeclarationFragment(str name, Option[AstNode] initializer) : println("variableDeclarationFragment : <name>"); 
     case typeParameter(str name, list[AstNode] extendsList) : println("typeParameter : <name>");
   };
}

/* Method to count all statements from the methods in a file
   @param classNode the file as a AstNode
   @author Philipp
*/
public void visitMethodsNotesOfFile(AstNode classNode){
	oldName = "";
	countIfs = 0;
	countForStatement = 0;
	countSwitchStatement = 0;
	countWhileStatement = 0;
	countDoStatement = 0;
	countSwitchCase = 0;
	visit(classNode) {
     case methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	if(name != oldName){
      		println("methodDeclaration : <name>"); 
      		println("method has <countIfs> if statements");
      		println("method has <countForStatement> for statements");
      		println("method has <countWhileStatement> while statements");
      		println("method has <countSwitchStatement> switch statements");
      		println("method has <countDoStatement> do statements");
      		println("method has <countSwitchCase> switch case statements");
      		totalCount = countIfs + countForStatement + countWhileStatement + countSwitchStatement + countDoStatement + countSwitchCase;
      		println("method has in Total : <totalCount>");
      		println("method end");
      		countIfs = 0;
      		countForStatement = 0;
      		countWhileStatement = 0;
      		countDoStatement = 0;
      		countSwitchStatement = 0;
      		countSwitchCase = 0;
      		totalCount = 0;
      	}
      	oldName = name;      	     	
     }
     case forStatement(list[AstNode] initializers, Option[AstNode] optionalBooleanExpression, list[AstNode] updaters, AstNode body) : countForStatement += 1;
     case whileStatement(AstNode expression, AstNode body) : countWhileStatement += 1; 
     case ifStatement(AstNode booleanExpression, AstNode thenStatement, Option[AstNode] elseStatement) : countIfs += 1;
     case switchCase(bool isDefault, Option[AstNode] optionalExpression) : countSwitchCase += 1;
     case doStatement(AstNode body, AstNode whileExpression) : countDoStatement += 1;
     case switchStatement(AstNode expression, list[AstNode] statements) : countSwitchStatement += 1;
   };
}