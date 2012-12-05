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
	Figure b1 = box(size(30,fileLength),vsize(fileLength),fillColor("red"),id("javaClass"),resizable(false),
				mouseOver(box(text("<file.uri> Lines : <size(class) - 1>"), size(20,20),resizable(false))));  
	// NOT WORKING
	//b2 = mapMethodToClass(b1, file);
	//b1 = box(b2,size(30,fileLength),vsize(fileLength),fillColor("red"),id("javaClass"),resizable(false),
	//			mouseOver(box(text("<file.uri> Lines : <size(class) - 1>"), size(20,20),resizable(false))));
	
	println("BOX : <b1>");
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
		b1 = box(fillColor("green"),size(30,2),resizable(false),     
			 mouseOver(box(text("Lines : <end-begin>"), size(20,20),resizable(false))));  // NEED TO GIVE A POSITION 
		methodsInBoxes += b1;
	}
	
	return b1;
}


// !!!!! STUFF FROM THE LIBARY   !!!! FOR TESTING
public void lala(){
	b1 = box(size(150,20), fillColor("green"),resizable(false));  // ,align(1,1)
	b0 = box(b1, size(150,50), fillColor("lightGray"),resizable(false));
	render(b0);
	//b1 = box(shrink(1.0),fillColor("green"),align(10,10));
	//class = box(b1, size(150,50), fillColor("lightGray"));	
	//render(class);
}



public Figure stairs(int nr){
	props = (nr == 0) ? [] : [mouseOver(stairs(nr-1))];
	return box(props + 
        [ ( nr %2 == 0 )? left() : right(),
          resizable(false),size(100),fillColor("green"),valign(0.25) ]);
}

public bool intInput(str s){
	return /^[0-9]+$/ := s;
}

public Figure higher(){
	int H = 100;
    return vcat( [ textfield("<H>", void(str s){H = toInt(s);}, intInput),
	               box(width(100), vresizable(false), vsize(num(){return H;}), fillColor("red"))
	             ], shrink(0.5), resizable(false));
}