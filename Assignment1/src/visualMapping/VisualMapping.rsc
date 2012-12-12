module visualMapping::VisualMapping

import vis::Figure;
import vis::Render;
import count::CountClasses;
import Prelude;
import visualMapping::MethodLocation;
import reader::Reader;
import complexcity::ComplexcityAnalyzer;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import vis::KeySym;
import util::Editors;

/* Method to make the classes visible 
   @param loc the location of the project
   @author Philipp   // take the complete screen as one box and then add boxes to that box
*/
public void makeClassesVisible(loc project){ 
	list[loc] javaClasses = countJavaClasses(project);   	// get the loc of the java classes
	println(javaClasses);
	list[Figure] classFigures = [];							// create a list for the figures of the classes to save
	//println("<size(javaClasses)> classes are in the project");  
	for(i <- [0..size(javaClasses) - 1]){					// run through the list 
		classFigures += drawClassWithLength(javaClasses[i]);		   // and call the method to draw a class 
	}
	println("---------");
	println(classFigures[1].maxLine);
	classFigures = sort(classFigures,bool(Figure a, Figure b){ return a.maxLine >= b.maxLine; });   //makes sort at the moment on methods in class not right
	render(box(hvcat(classFigures,gap(5))));  // hvcat ,gap(5))  hcat   // render(pack((class),std(gap(10))));
}

/* Method to draw a class with the length and a mouse over event
   @param file the class to draw
   @return b1 the class as a box
   @author Philipp
*/
public Figure drawClassWithLength(loc file){	
	list[str] class = readProjectFileAsArray(file.top);			// read the project 
	int fileLength = size(class) - 1;						// get the size of the class 
	Figure b1 = outline([info(0,"a")],fileLength,size(15,fileLength),fillColor("red"),resizable(false),
				mouseOver(box(text("<file.uri> Lines : <size(class) - 1>"), size(20,20),resizable(false))),
				onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
					println("Go to class");
					edit(file);
					return true;
	}));     // create the Figure with the properties the size of the class is the height parameter for the class.
	 methodStartLine = mapMethodToClass(file.top);   			// call method to get a list int with the startposition of a method in a class
	 list[LineDecoration] infoList = [];					// create a list of line decoration 
	 if(size(methodStartLine) >= 1){						// check if one or more methods in the class					
	 for(i <- [0..size(methodStartLine) - 1]){				// run through the list of start lines
		infoList += info(methodStartLine[i],"a");			// add in the list the position where the line should appear
	}
	
	}
	b1 = visit(b1){
		case fillColor(_) => fillColor("green")
		case [info(_,_)] => infoList
	}
	return b1;
}

/* Method to map a method location to the class size  
   @param file the loc of a java file
   @return methodStartLocation a list of integers shows where a method starts in a class
   @author Philipp
*/
public list[int] mapMethodToClass(loc file){
	AstNode extFile = makeAnAstnode(file);
	list[rel[loc lineLocation,str methodName]] methods = getMethodLocation(extFile);
	set[loc] lineCountSet = {};
	if(size(methods) >= 1){
	for(i <- [0..size(methods) - 1]){
		lineCountSet += methods[i].lineLocation;
	}
	
	lineCountList = toList(lineCountSet);
	list[int] methodStartLocation = getMethodStartLine(lineCountList);
	return methodStartLocation;
	}
	return [];
}

/* Method to get the the startlines of a method
   @param methods a list of method location
   @return startLine the startline positions
   @author Philipp
*/
public list[int] getMethodStartLine(list[loc] methods){
	list[int] startLine = [];
	for(i <- [0..size(methods) - 1]){
		startLine += methods[i].begin.line;
	}
	return sort(startLine);
}
