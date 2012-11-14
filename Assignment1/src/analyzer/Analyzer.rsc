module analyzer::Analyzer

import reader::Reader;
import count::CountClasses;
import count::CountFunction;
import count::CountIf;
import count::CountLines;

private Reader reader;
private CountClasses countClasses;
private CountFunction countFunction;
private CountIf countIf;
private CountLines countLines;


