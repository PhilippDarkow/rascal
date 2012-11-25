module complexcity::ComplexcityAnalyzer

import util::Resources;
import IO;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;
import Prelude;
import Set;
import Map;

public Resource extClass(loc class){
	return extractClass(class);
}

public BindingRel getMethodName(Resource class){
	return class@methods;
	//visit(class) {
    // case leaf(int N): println("Huhu"); //c = c + N;   
   // };
}

public AstNodeRel getAstNodeRelationFile(loc project){
	//methods = extractProject(project);
	methods = extractClass(project);  
	println(methods@methodBodies);
	return methods@methodBodies;
}

public void scanProjectComplexity(list[loc] file){
	for(s <- file){
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
	//visitAstNode(classNode);
	return createAstFromFile(file);
}

public void visitSetOfNodes(set[AstNode] setOfNodes){
	for(s <- setOfNodes){
		println("----------------------------------------- <s>");
		visitAstNode(s);
	}
}

// methodDeclaration(list[Modifier] , list[AstNode] , list[AstNode] , Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation)
public void visitAstNode(AstNode classNode){
	visit(classNode) {
     case importDeclaration(name,staticImport,onDemand) : println("importDeclaration");   // AstNode 
     case typeDeclaration(list[Modifier] modifiers,list[AstNode] annotations,str objectType,str name,list[AstNode] genericTypes,Option[AstNode] extends,list[AstNode] implements,list[AstNode] bodyDeclarations) : println("typeDeclaration");
     case methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) : println("methodDeclaration : <name>");
     //case methodInvocation(Option[AstNode] optionalExpression, list[AstNode] genericTypes, str name, list[AstNode] typedArguments) : {
     //println("methodInvocation : <name>");
     //}
     case fieldDeclaration(modifiers,annotations,\type,fragments) : println("fieldDeclaration"); 
     case constructorInvocation(list[AstNode] genericTypes, list[AstNode] typedArguments) : println("constructorInvocation");
     case packageDeclaration(str name, list[AstNode] annotations) : println("packageDeclaration : <name>"); 
     //case singleVariableDeclaration(str name, list[Modifier] modifiers, list[AstNode] annotations, AstNode \type, Option[AstNode] initializer, bool isVarargs) : println("singleVariableDeclaration : <name>");
     case variableDeclarationFragment(str name, Option[AstNode] initializer) : println("variableDeclarationFragment : <name>"); 
     case forStatement(list[AstNode] initializers, Option[AstNode] optionalBooleanExpression, list[AstNode] updaters, AstNode body) :{ 
     	println("for loop");
     }
     case whileStatement(AstNode expression, AstNode body) : println("while statement"); 
     case typeParameter(str name, list[AstNode] extendsList) : println("typeParameter : <name>");
     //case qualifiedName(AstNode qualifier, str name) : println("qualifiedName : <name>");
     //case simpleName(str simpleName) : println("Simple name : <simpleName>");
     case ifStatement(AstNode booleanExpression, AstNode thenStatement, Option[AstNode] elseStatement) :{ 
     	println("if statement");
     	//println(booleanExpression);
     	//println(thenStatement);
     	//println(elseStatement);
     }
   };
}

public void visitMethodsNotesOfFile(AstNode classNode){
	oldName = "";
	countIfs = 0;
	countForStatement = 0;
	visit(classNode) {
     case methodDeclaration(list[Modifier] modifiers, list[AstNode] annotations, list[AstNode] genericTypes, Option[AstNode] returnType, str name, list[AstNode] parameters, list[AstNode] possibleExceptions, Option[AstNode] implementation) :{
      	if(name != oldName){
      		println("method has <countIfs> if statements");
      		println("method has <countForStatement> if statements");
      		println("method end");
      		countIfs = 0;
      		countForStatement = 0;
      	}
      	oldName = name;
      	println("methodDeclaration : <name>");      	
     }
     case forStatement(list[AstNode] initializers, Option[AstNode] optionalBooleanExpression, list[AstNode] updaters, AstNode body) :{ 
     	countForStatement += 1;
     	println("for loop");
     }
     case whileStatement(AstNode expression, AstNode body) :{
      	println("while statement"); 
     }
     case ifStatement(AstNode booleanExpression, AstNode thenStatement, Option[AstNode] elseStatement) :{ 
     	countIfs += 1;
     }
     case switchStatement(AstNode expression, list[AstNode] statements) : {
     	println("switch Statement");
     }
   };
}

public void visitStatements(AstNode classNode){
	visit(classNode) {
     case forStatement(list[AstNode] initializers, Option[AstNode] optionalBooleanExpression, list[AstNode] updaters, AstNode body) : println("for loop");
     case ifStatement(AstNode booleanExpression, AstNode thenStatement, Option[AstNode] elseStatement) :  println("ifStatement ");
     case whileStatement(AstNode expression, AstNode body) : println("while statement"); 
   };
}

public set[AstNode] makeProjectTree(loc project){
	return createAstsFromProject(project);
}

