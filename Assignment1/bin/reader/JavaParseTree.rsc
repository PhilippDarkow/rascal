module reader::JavaParseTree

data JavaTree = 
            leaf(int N) 
          | folder(JavaTree left, JavaTree right) 
          | file(JavaTree left, JavaTree right);
      
// Count the number of folder nodes
          
public int cntfolder(JavaTree t){
   int c = 0;
   visit(t) {
     case folder(_,_): c = c + 1;      
   };
   return c;
}

// Count the number of file nodes
          
public int cntfiles(JavaTree t){
   int c = 0;
   visit(t) {
     case file(_,_): c = c + 1;      
   };
   return c;
}

// Compute the sum of all integer leaves

public int addLeaves(JavaTree t){
   int c = 0;
   visit(t) {
     case leaf(int N): c = c + N;   
   };
   return c;
}
