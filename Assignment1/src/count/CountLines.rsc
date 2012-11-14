module count::CountLines

import IO;
import List;


// countLines(|file://C:/Users/Philipp/Desktop/uni/SoftwareEvolution/workspace/SmallSQL/src/smallsql/database/Column.java|);
// return the lines of codes in a file
public int countLines(loc file){    
    return size(readFileLines(file));
}