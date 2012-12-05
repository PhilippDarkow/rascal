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

/* Method to make the classes visible 
   @param loc the location of the project
   @author Philipp   // take the complete screen as one box and then add boxes to that box
*/
public void makeClassesVisible(loc project){ 
	list[loc] javaClasses = countJavaClasses(project);
	list[Figure] class = [];
	println("<size(javaClasses)> classes are in the project");
	for(i <- [0..size(javaClasses) - 1]){
		class += drawClassWithLength(javaClasses[i].top);		   // box(fillColor("red"));
	}
	println(class);
	class = sort(class);
	render(box(hcat(class)));  // hvcat ,gap(5))
}

/* Method to draw a class with the length and a mouse over event
   @param file the class to draw
   @return b1 the class as a box
   @author Philipp
*/
public Figure drawClassWithLength(loc file){	//render(drawClassWithLength(|project://SmallSQL/src/smallsql/database/SQLParser.java|));
	list[str] class = readProjectFileAsArray(file);
	int fileLength = size(class) - 1;
	println("FILE LENGTH : <fileLength>");
	Figure b1 = outline([info(100,"a"), warning(125, "b")],fileLength,size(30,fileLength),fillColor("red"),resizable(false),
				mouseOver(box(text("<file.uri> Lines : <size(class) - 1>"), size(20,20),resizable(false))));  
	// now we need to to put the right method lines in the array of the outline
	
	return b1;
}

/* Method to map a method location to the class size  --> NOT COMPLETE NOT WORKING
   @author Philipp
*/
public Figure mapMethodToClass(Figure class, loc file){
	AstNode extFile = makeAnAstnode(file);
	list[rel[loc lineLocation,str methodName]] methods = getMethodLocation(extFile);
	set[loc] line = methods[0].lineLocation; 
	list[Figure] methodsInBoxes = [];
	list[loc] lineList = toList(line);
	Figure b1 = box();
	println(lineList);
	for(i <- [0..size(methods) -1]) {
		println("Now create for every method a box");
		set[loc] line = methods[i].lineLocation; 	
		list[loc] lineList = toList(line);
		println(lineList); 
		int begin = lineList[0].begin.line;
		int end = lineList[0].end.line;
		print(<begin>);
		methodsInBoxes += b1;
	}
	
	return b1;
}