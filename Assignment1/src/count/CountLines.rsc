module count::CountLines

import IO;

public int countLines(loc project){    
    return readFileLines(project);
}