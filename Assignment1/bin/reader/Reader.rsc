module reader::Reader

import util::Resources;
import IO;

public void readProject(loc project){
	println(project);
	// example readFile(|file://C:/Users/../workspace/SmallSQL/src/smallsql/database/Column.java|);
	return readFile(project); // http://tutor.rascal-mpl.org/Rascal/Libraries/Prelude/IO/readFile/readFile.html
	// return getProject(project);
	//if(getProject(project) == null){
	//	return true;
	//}else{
	//	return false;
	//}
}