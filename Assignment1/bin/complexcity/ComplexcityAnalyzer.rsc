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
	int countProjectSimple = 0;
	int countProjectMoreComplex = 0;
	int countProjectComplex = 0;
	int countProjectUntestable = 0;
	for(s <- project){
		println("visiting loc <s.top>");
		AstNode class = makeAnAstnode(s.top);
		list[int] complexcityInClass = visitMethodsNotesOfFile(class);
		println("Class has <complexcityInClass[0]> simple methods");
		countProjectSimple += complexcityInClass[0];
   		println("Class has <complexcityInClass[1]> more complex methods");
   		countProjectMoreComplex += complexcityInClass[1];
   		println("Class has <complexcityInClass[2]> complex methods");
   		countProjectComplex += complexcityInClass[2];
   		println("Class has <complexcityInClass[3]> untestable methods");
   		countProjectUntestable += complexcityInClass[3];
		println("--------------------------");	
	}
	println("Project has <countProjectSimple> simple methods");
	println("Project has <countProjectMoreComplex> more complex methods");
	println("Project has <countProjectComplex> complex methods");
	println("Project has <countProjectUntestable> untestable methods");
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
public list[int] visitMethodsNotesOfFile(AstNode classNode){
	oldName = "";
	int rowNumbers = 0;
	countSimple = 0;
	countMoreComplex = 0;
	countComplex = 0;
	countUntestable = 0;
	countIfs = 0;
	countForStatement = 0;
	countSwitchStatement = 0;
	countWhileStatement = 0;
	countDoStatement = 0;
	countSwitchCase = 0;
	visit(classNode) {
     case methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	if(name != oldName){
      		printDetails(name, countIfs, countForStatement, countWhileStatement, countSwitchStatement, countDoStatement, countSwitchCase);
      		totalCount = countIfs + countForStatement + countWhileStatement + countSwitchStatement + countDoStatement + countSwitchCase;
      		int complexcity = calculateComplexcity(totalCount);
      		if(complexcity == 1) countSimple += 1;
      		elseif(complexcity == 2) countMoreComplex += 1;
      		elseif(complexcity == 3) countComplex += 1;
      		elseif(complexcity == 3) countUntestable += 1;
      		//println("The method has <rowNumbers> lines");
      		println("method end");
      		countIfs = 0;
      		countForStatement = 0;
      		countWhileStatement = 0;
      		countDoStatement = 0;
      		countSwitchStatement = 0;
      		countSwitchCase = 0;
      		totalCount = 0;
      	}
      	//print(implementation);
      	oldName = name;     	     	
     }
     case forStatement(list[AstNode] initializers, Option[AstNode] optionalBooleanExpression, list[AstNode] updaters, AstNode body) : countForStatement += 1;
     case whileStatement(AstNode expression, AstNode body) : countWhileStatement += 1; 
     case ifStatement(AstNode booleanExpression, AstNode thenStatement, Option[AstNode] elseStatement) : countIfs += 1;
     case switchCase(bool isDefault, Option[AstNode] optionalExpression) : countSwitchCase += 1;
     case doStatement(AstNode body, AstNode whileExpression) : countDoStatement += 1;
     case switchStatement(AstNode expression, list[AstNode] statements) : countSwitchStatement += 1;
   };
   
   return [countSimple,countMoreComplex,countComplex,countUntestable];
}

public void printDetails(str name, int countIfs, int countForStatement, int countWhileStatement, int countSwitchStatement, int countDoStatement, int countSwitchCase){
	println("methodDeclaration : <name>"); 
    //println("method has <countIfs> if statements");
    //println("method has <countForStatement> for statements");
    //println("method has <countWhileStatement> while statements");
    //println("method has <countSwitchStatement> switch statements");
    //println("method has <countDoStatement> do statements");
    //println("method has <countSwitchCase> switch case statements");
}

public int calculateComplexcity(int complexityScore){
	if(complexityScore <= 10){
		println("Complexcity is simple");
		return 1;
	} elseif(complexityScore >= 11 && complexityScore <= 20) {
		println("Complexcity is more complex");
		return 2;
	} elseif(complexityScore >= 21 && complexityScore <= 50){
		println("Complexcity is complex");
		return 3;
	} elseif(complexityScore >= 51){
		println("Complexcity is untestable");
		return 4;
	}

public void returnOption(Option[Astnode] impl){
	println("-----------------------------------------");
	println(impl[0]);
	println(impl[1]);
	println("-----------------------------------------");
	//return impl;
}
}