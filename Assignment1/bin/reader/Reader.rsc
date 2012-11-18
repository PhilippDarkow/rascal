module reader::Reader

import util::Resources;
import IO;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import analysis::graphs::Graph;
import Prelude;
import Set;


/* Method to read a file
   example readProjectFileOneString(|file://C:/Users/../workspace/SmallSQL/src/smallsql/database/Column.java|);
   @return the file as one string
*/
public str readProjectFileOneString(loc file){
	return readFile(file); // http://tutor.rascal-mpl.org/Rascal/Libraries/Prelude/IO/readFile/readFile.html
}

/* Method to read the file
   @return the file in an array of string ( each position is one line )
*/
public list[str] readProjectFileAsArray(loc file){
	return readFileLines(file);
}

/* Method to read a project
   http://tutor.rascal-mpl.org/Rascal/Rascal.html#/Rascal/Libraries/lang/java/jdt/JDT/JDT.html
   http://ask.rascal-mpl.org/question/1105/i-want-to-analyze-a-java-program-how-do-i-start
   @return the project with getProject
*/
public Resource giveProject(loc project){
	return getProject(project);  // getProject(|project://SmallSQL|);
}

public Resource extProject(loc project){
   return extractProject(project);  // |project://SmallSQL/src/smallsql|
}
// extractClass(|project://SmallSQL/src/smallsql/database/Column.java|);

/* Method to return a Java Project as a Tree
   @param project the location of the project ( (|project://SmallSQL/src/smallsql|); )
   @return a set of AstNode with the project structure
*/
public set[AstNode] giveProjectAsTree(loc project){
   return createAstsFromProject(project);
}

public AstNode giveFileAsTree(loc file){
   return createAstFromFile(file);
}

/* Method to get the files of a project
   @param project the location of the project   --> I need to make a node type and to search the tree for that node that contain "file"
*/
public BindingRel getFilesOfProject(loc project){
   check = extProject(project);	
   return check@packages;
}

public set[loc] getAllProjects(){
  return projects();
}

public void showMethodDeclsForFile(Resource file){

    methodDeclarations = file@file;
    methodLocations = domain(methodDeclarations); // I am only interested in the locations

    for(methodLocation <- methodLocations){
        println(" methodLocation: " + methodLocation );
    }
}

public EntityRel getSubTypeInformation(loc project){
    fm = extractProject(project);
    return fm@extends + fm@implements;
}


public void countMethods(loc project){
facts = extractProject(project);
classes = {c | c:entity([_*,class(_)]) <- facts@declaredTopTypes};
methods = (e : size((facts@declaredMethods)[e]) | e <- classes);
for(m <- methods)
println("<readable(m)> : <methods[m]>");
}
//public BindingRel getOtherStuff(loc project){
//     fm = extractProject(project);
//     BindingRel a = [project, fm@implements]; 
//     return a; // fm + fm@methodDecls;
//}