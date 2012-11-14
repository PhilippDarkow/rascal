module reader::Reader

import util::Resources;
import IO;

public void readProject(loc project){
	println(project);
	return getProject(project);
	//if(getProject(project) == null){
	//	return true;
	//}else{
	//	return false;
	//}
}