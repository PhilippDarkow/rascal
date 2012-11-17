module reader::Reader

import util::Resources;
import IO;

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
   @return the project with getProject
*/
public Resource giveProject(loc project){
	return getProject(project);
}