module visualMapping::VisualMapping

import vis::Figure;
import vis::Render;
import count::CountClasses;
import Prelude;

/* Method to make the classes visible 
   @param loc the location of the project
   @author Philipp   // take the complete screen as one box and then add boxes to that box
*/
public void makeClassesVisible(loc project){ 
	list[loc] javaClasses = countJavaClasses(project);
	list[Figure] class = [];
	println("<size(javaClasses)> classes are in the project");
	//boxes = [ box(lineColor("red")), 
    //      box(), 
    //      box(lineColor("yellow"))
    //    ];
	//render(box(hcat(boxes,shrink(0.9)),std(lineColor("blue")), std(fillColor("grey")), std(lineWidth(3))));
	for(i <- [0..size(javaClasses) - 1]){
		class += box(fillColor("red"));		
	}
	println(class);
	render(box(hcat(class,shrink(0.9))));
}


// !!!!! STUFF FROM THE LIBARY   !!!! FOR TESTING
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