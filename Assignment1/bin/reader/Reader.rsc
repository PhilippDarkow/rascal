module reader::Reader

import util::Resources;
import IO;

//Constructor
int max;
//data READER = reader(reader::Reader reader);

public void readFile(loc file){
	println(file);
	// example readFile(|file://C:/Users/../workspace/SmallSQL/src/smallsql/database/Column.java|);
	return readFile(project); // http://tutor.rascal-mpl.org/Rascal/Libraries/Prelude/IO/readFile/readFile.html
	// return getProject(project);
}