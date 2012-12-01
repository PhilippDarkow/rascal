module visualMapping::VisualMapping

import vis::Figure;
import vis::Render;
import count::CountClasses;

/* Method to make the classes visible 
   @param loc the location of the project
   @author Philipp   // take the complete screen as one box and then add boxes to that box
*/
public void makeClassesVisible(loc project){ 
	list[loc] javaClasses = countJavaClasses(project);
	println("<size(javaClasses)> classes are in the project");
	for(i <- [0..2]){
		b = box(fillColor("red"), shrink(0.5));
	render(b);
	}
}