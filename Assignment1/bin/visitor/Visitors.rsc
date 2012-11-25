module visitor::Visitors

import util::Resources;
import IO;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
//import JDTRefactoring;
import Relation;
import Set;
import List;
import String;

public list[str] strParts(str s) { 
	if (/^<s1:\w+>.?<s2:.*>/ := s) 
		return s1 + strParts(s2); 
	else 
		return [ ]; 
}

public Entity makeClassOrInterfaceName(str s, bool ifc, str ps...) { 
	list[str] sp = strParts(s);
	list[Entity] params = [ entity([typeParameter(p)]) | p <- ps ];
	str last = head(tail(sp,1));
	Id lastId = ifc ? ( (size(params) == 0) ? interface(last) : interface(last,params))
	                : ( (size(params) == 0) ? class(last) : class(last,params));	 
	if (size(sp) == 1) 
		return entity([lastId]); 
	else 
		return entity([package(sp[idx]) | idx <- [0..size(sp)-2]] + lastId);
}

public Entity makeClassName(str s, str ps...) {
	return makeClassOrInterfaceName(s, false, ps);
}

public Entity makeInterfaceName(str s, str ps...) {
	return makeClassOrInterfaceName(s, true, ps);
}

alias MethodInfo = rel[str mname, loc mloc, Entity owner, Entity method];
alias MethodInfoWDef = rel[str mname, loc mloc, Entity owner, Entity method, Entity def];

public MethodInfo getVisitorsInClassOrInterface(Resource r, str s, bool ifc, str ps...) {
	im = invert(r@methodDecls);
	cn = makeClassOrInterfaceName(s, ifc, ps);
	return { <mns,l,cn,mn> | tm:<cn,mn> <- r@declaredMethods, entity([_*,method(mns,_,_),_*]) := mn, /visit.*/ := mns, l <- im[mn] };
}

public MethodInfo getVisitorsInClass(Resource r, str s, str ps...) {
	return getVisitorsInClassOrInterface(r, s, false, ps);
}

public MethodInfo getVisitorsInInterface(Resource r, str s, str ps...) {
	return getVisitorsInClassOrInterface(r, s, true, ps);
}

public MethodInfo getVisitorsInClassOrInterface(Resource r, Entity e) {
	im = invert(r@methodDecls);
	return { <mns,l,e,mn> | tm:<e,mn> <- r@declaredMethods, entity([_*,method(mns,_,_),_*]) := mn, /visit.*/ := mns, l <- im[mn] };
}

public MethodInfo getMethodsNamedAccept(Resource r) {
	im = invert(r@methodDecls);
	return { <mns,l,e,mn> | <e,mn> <- r@declaredMethods, entity([_*,method(mns,_,_),_*]) := mn, /accept/ := mns, l <- im[mn] };
}

public map[str mname, str mcode] getVisitorCodeInClassOrInterface(Resource r, str s, bool ifc, str ps...) {
	MethodInfo mi = getVisitorsInClassOrInterface(r, s, ifc, ps);
	return ( mn : readFile(getOneFrom(mi[mn]<0>)) | mn <- mi<0> );
} 

public map[str mname, str mcode] getVisitorCodeInClass(Resource r, str s, str ps...) { 
	return getVisitorCodeInClassOrInterface(r,s,false,ps);
}

public map[str mname, str mcode] getVisitorCodeInInterface(Resource r, str s, str ps...) {
	return getVisitorCodeInClassOrInterface(r,s,true,ps);
}

public Entity makeNameIntoParameterName(Entity e) {
	if (entity(list[Id] idl) := e) { 
		Id lastid = head(tail(idl,1));
		Id newid;
		if (interface(_,pl) := lastid || class(_,pl) := lastid) {
			str pls = ""; for (entity([typeParameter(p)]) <- pl) pls += "\<<p>\>";
			if (interface(ifn,_) := lastid) newid = interface(ifn+pls,pl);
			if (class(cn,_) := lastid) newid = class(cn+pls,pl);
			idl[size(idl)-1] = newid;
			return entity(idl);
		}
	}
	return e;
}

public set[Entity] getMethodSetWithParameter(Resource r, Entity param) {
	Entity paramName = makeNameIntoParameterName(param);
	return { mn | <_,mn> <- r@declaredMethods, entity([_*,method(_,[_*,paramName,_*],_)]) := mn };
}

public rel[Entity method, loc l] getMethodsWithParameter(Resource r, Entity param) {
	set[Entity] methods = getMethodSetWithParameter(r, param);
	im = invert(r@methodDecls);	
	return { <m, l> | m <- methods, l <- im[m] }; 
}

//
// Given an interface of the form ifName<T>, find the classes that implement it.
//
public set[Entity] getInterfaceImplementers(Resource r, Entity ifEntity) {
	list[Id] prefix = (entity(lid) := ifEntity) ? head(lid,size(lid)-1) : [];
	str ifName = ( (entity([prefix,interface(ifn,_)]) := ifEntity || entity([prefix,interface(ifn)]) := ifEntity) && 
		         ( (/^<ifnp:[^\<]+>.*$/ := ifn) || (/^<ifnp:[^\<]+>$/ := ifn))) ? ifnp : "";
	return { f | <f,e> <- r@implements, 
			     entity([prefix,interface(ifn,_)]) := e || entity([prefix,interface(ifn)]) := e, 
			     (/^<ifnp:[^\<]+>.*$/ := ifn || /^<ifnp:[^\<]+>$/ := ifn), ifName == ifnp };
}

//
// Given an interface of the form ifName<T>, find the interfaces and classes that
// extend it.
//
public set[Entity] getInterfaceExtenders(Resource r, Entity ifEntity) {
	list[Id] prefix = (entity(lid) := ifEntity) ? head(lid,size(lid)-1) : [];
	str ifName = ( (entity([prefix,interface(ifn,_)]) := ifEntity || entity([prefix,interface(ifn)]) := ifEntity) && 
		         ( (/^<ifnp:[^\<]+>.*$/ := ifn) || (/^<ifnp:[^\<]+>$/ := ifn))) ? ifnp : "";
	return { f | <f,e> <- r@extends, 
			     entity([prefix,interface(ifn,_)]) := e || entity([prefix,interface(ifn)]) := e, 
			     (/^<ifnp:[^\<]+>.*$/ := ifn || /^<ifnp:[^\<]+>$/ := ifn), ifName == ifnp };
}

//
// Given a  class of the form cName<T>, find the classes that extend it.
//
public set[Entity] getClassExtenders(Resource r, Entity cEntity) {
	list[Id] prefix = (entity(lid) := cEntity) ? head(lid,size(lid)-1) : [];
	str cName = ( (entity([prefix,class(cn,_)]) := cEntity || entity([prefix,class(cn)]) := cEntity) && 
		         ( (/^<cnp:[^\<]+>.*$/ := cn) || (/^<cnp:[^\<]+>$/ := cn))) ? cnp : "";
	return { f | <f,e> <- r@extends, 
			     entity([prefix,class(cn,_)]) := e || entity([prefix,class(cn)]) := e, 
			     (/^<cnp:[^\<]+>.*$/ := cn || /^<cnp:[^\<]+>$/ := cn), cName == cnp };
}

//
// Run the source clean-up on the classes that implement the visitor methods. Note that we need
// a fresh extract here, since this contains our location information, and we may as well keep it
// local since the clean-up will "break" the location offsets we collect here.
//
public bool cleanUpImplementers() {
	println("CLEANUP: Extracting Rascal Project");
	Resource rascal = extractProject(|project://rascal|);
	Entity astVisitor = makeInterfaceName("org.rascalmpl.ast.IASTVisitor", "T");

	// Starting at the base interface, get all reachable interfaces (based on extends relation)
	println("CLEANUP: Finding all visitor interfaces");
	set[Entity] extenders = { astVisitor };
	solve (extenders) { extenders = extenders + { getInterfaceExtenders(rascal, e) | e <- extenders }; }

	// Starting with interfaces, get all reachable implementing classes (based on implements and extends relations)
	println("CLEANUP: Finding all visitor implementing classes");
	set[Entity] implementers = { getInterfaceImplementers(rascal, e) | e <- extenders };
	solve (implementers) { implementers = implementers + { getClassExtenders(rascal, e) | e <- implementers }; }
	//implementers = implementers - { i | i <- implementers, entity([_*,class("SdfImportExtractor"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("BoxEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("StringTemplateConverter"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("TestEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,package("debug"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("IUPTRAstToSymbolConstructor"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("DeclarationCollector"),_*]) := i };
	
	// For each of the implementers, run the code cleanup
	println("CLEANUP: Starting code cleanup");
	bool success = true;
	for (i <- implementers) {
		println("CLEANUP: Starting cleanup of <readable(i)>");
		set[loc] classLocs = invert(rascal@classes)[i];
		if (size(classLocs) != 1) {
			println("CLEANUP: Error, should have 1 declaration location for <readable(i)>, but instead have <size(classLocs)>");
			success = false;
		} else {
			cloc = getOneFrom(classLocs);
			cloc.offset = -1; // throw away offset info
			rel[str,str] res = cleanUpSource(cloc);
			if (size(res) > 0) {
				success = false;
				for (msg <- res<1>) println("CLEANUP: Encountered error: <msg>");
			}
		}
		println("CLEANUP: Cleanup finished");
	}
	
	return success;
}

//
// Encapsulate private fields used by the visit methods so that instead we are accessing
// them using public getters and setters.
//
public bool encapsulateVisitorFields() {
	println("ENCAPSULATE: Extracting Rascal Project");
	Resource rascal = extractProject(|project://rascal|);
	Entity astVisitor = makeInterfaceName("org.rascalmpl.ast.IASTVisitor", "T");

	// Starting at the base interface, get all reachable interfaces (based on extends relation)
	println("ENCAPSULATE: Finding all visitor interfaces");
	set[Entity] extenders = { astVisitor };
	solve (extenders) { extenders = extenders + { getInterfaceExtenders(rascal, e) | e <- extenders }; }

	// Starting with interfaces, get all reachable implementing classes (based on implements and extends relations)
	println("ENCAPSULATE: Finding all visitor implementing classes");
	set[Entity] implementers = { getInterfaceImplementers(rascal, e) | e <- extenders };
	solve (implementers) { implementers = implementers + { getClassExtenders(rascal, e) | e <- implementers }; }
	implementers = implementers - { i | i <- implementers, entity([_*,class("BoxEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("StringTemplateConverter"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("TestEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,package("debug"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("IUPTRAstToSymbolConstructor"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("DeclarationCollector"),_*]) := i };

	// Get the visitors declared in the base interface. This gives us the names of the visitor methods we
	// care about.
	println("ENCAPSULATE: Finding base visitor methods");
	MethodInfo miBase = getVisitorsInClassOrInterface(rascal, astVisitor);
	set[str] miBaseNames = { mn | entity([_*,method(mn,_,_)]) <- miBase.method };
	
	// Get the implementations of these visitors -- to be in this table, this must be included in the
	// IASTVisitor interface (this prevents spurious matches just because we have a method named visit...)
	println("ENCAPSULATE: Finding visitor method implementations");
	MethodInfoWDef miImp = { <mi.mname,mi.mloc,mi.owner,mi.method,def> | e <- implementers, 
	    tuple[str mname, loc mloc, Entity owner, Entity method] mi <- getVisitorsInClassOrInterface(rascal,e), 
		entity([_*,method(mn,_,_)]) := mi.method, mn in miBaseNames, def <- (miBase[mn]<2>) };

	// Get the methods called inside the visit methods. We need this to check to see which are public and which
	// are not (package, private, protected are all problematic...). To do this, first we build information
	// on where the visit methods are in the file. This is done by creating ranges, based on the offset and
	// the length. We can then find the methods used inside each range. 
	println("ENCAPSULATE: Constructing range information");
    rel[str,int,int,loc,Entity,Entity] overlapsAux = { <l.path, l.offset, l.offset+l.length-1, l, i, dm> | 
    	i <- implementers, dm <- (rascal@declaredMethods)[i], dm in miImp.method, l <- invert(rascal@methodDecls)[dm] };
	rel[Entity,loc] classLocs = invert(rascal@types);
	set[str] classPaths = { l.path | i <- implementers, l <- classLocs[i] }; 

    // Now, do the same for fields. First, create a relation with the path, offset, and field entity.	
	println("ENCAPSULATE: Finding non-public fields used in visit methods");
    rel [str, int, Entity] frel = { < l.path, l.offset, e > |  <loc l,e> <- rascal@fields, l.path in classPaths,
    	entity([package("org"),package("rascalmpl"),_*]) := e };
    
    // Second, narrow this down to only those entities which are in the range. The information is: the entity representing
    // the var, the path, the offset, the entity representing the class, the entity representing the method, the location
    // of the method. 
    rel[Entity,str,int,Entity,Entity,loc] frel2 = { <e,fp,o,i,dm,l> | fi:<fp,o,e> <- frel, 
    		<fp,bn,en,l,i,dm> <- overlapsAux, bn <= o, o <= en };

    // Limit it further to those fields that are not public
    rel[Entity,str,int,Entity,Entity,loc] frel3 = { fri | fri <- frel2, \public() notin (rascal@modifiers)[fri[0]] };
    set[Entity] npFields = frel3<0>;

    // Finally -- these are the fields that need to be made public, along with their location in the code
    rel[Entity,loc] npFieldsWLocs = { <f,l> | f <- npFields, l <- invert(rascal@fieldDecls)[f] };
	
	// Now, make these fields public
	println("ENCAPSULATE: Encapsulating non-public fields");
	rel[str,int] npOffsets = { <l.path,l.offset> | l <- npFieldsWLocs<1> };
	set[loc] npLocs = { };
	for (loc l <- npFieldsWLocs<1>) { l.offset = -1; l.length = -1; npLocs += l; }
	bool success = true;
	for (loc l <- npLocs) {
		set[int] offsets = npOffsets[l.path];
		println("ENCAPSULATE: Encapsulating <size(offsets)> non-public fields in compilation unit <l>");
		rel[str,str] res = encapsulateFields(offsets, l);
		if (size(res) > 0) {
			success = false;
			for (msg <- res<1>) println("ENCAPSULATE: Encountered error: <msg>");
		}
		println("ENCAPSULATE: Finished encapsulating fields in compilation unit");
	}
	
	println("ENCAPSULATE: Finished encapsulating fields");
	
	return success;
}
//
// Make the methods used inside the visitors public, so they can still be invoked
// once the code is moved into the interpreter classes.
//
public bool makeVisitorMethodsPublic() {
	println("CHANGE SIGNATURE: Extracting Rascal Project");
	Resource rascal = extractProject(|project://rascal|);
	Entity astVisitor = makeInterfaceName("org.rascalmpl.ast.IASTVisitor", "T");

	// Starting at the base interface, get all reachable interfaces (based on extends relation)
	println("CHANGE SIGNATURE: Finding all visitor interfaces");
	set[Entity] extenders = { astVisitor };
	solve (extenders) { extenders = extenders + { getInterfaceExtenders(rascal, e) | e <- extenders }; }

	// Starting with interfaces, get all reachable implementing classes (based on implements and extends relations)
	println("CHANGE SIGNATURE: Finding all visitor implementing classes");
	set[Entity] implementers = { getInterfaceImplementers(rascal, e) | e <- extenders };
	solve (implementers) { implementers = implementers + { getClassExtenders(rascal, e) | e <- implementers }; }
	implementers = implementers - { i | i <- implementers, entity([_*,class("BoxEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("StringTemplateConverter"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("TestEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,package("debug"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("IUPTRAstToSymbolConstructor"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("DeclarationCollector"),_*]) := i };

	// Get the visitors declared in the base interface. This gives us the names of the visitor methods we
	// care about.
	println("CHANGE SIGNATURE: Finding base visitor methods");
	MethodInfo miBase = getVisitorsInClassOrInterface(rascal, astVisitor);
	set[str] miBaseNames = { mn | entity([_*,method(mn,_,_)]) <- miBase.method };
	
	// Get the implementations of these visitors -- to be in this table, this must be included in the
	// IASTVisitor interface (this prevents spurious matches just because we have a method named visit...)
	println("CHANGE SIGNATURE: Finding visitor method implementations");
	MethodInfoWDef miImp = { <mi.mname,mi.mloc,mi.owner,mi.method,def> | e <- implementers, 
	    tuple[str mname, loc mloc, Entity owner, Entity method] mi <- getVisitorsInClassOrInterface(rascal,e), 
		entity([_*,method(mn,_,_)]) := mi.method, mn in miBaseNames, def <- (miBase[mn]<2>) };

	// Get the methods called inside the visit methods. We need this to check to see which are public and which
	// are not (package, private, protected are all problematic...). To do this, first we build information
	// on where the visit methods are in the file. This is done by creating ranges, based on the offset and
	// the length. We can then find the methods used inside each range. 
	println("CHANGE SIGNATURE: Constructing range information");
    rel[str,int,int,loc,Entity,Entity] overlapsAux = { <l.path, l.offset, l.offset+l.length-1, l, i, dm> | 
    	i <- implementers, dm <- (rascal@declaredMethods)[i], dm in miImp.method, l <- invert(rascal@methodDecls)[dm] };
	rel[Entity,loc] classLocs = invert(rascal@types);
	set[str] classPaths = { l.path | i <- implementers, l <- classLocs[i] }; 

    // Now, do the same for fields. First, create a relation with the path, offset, and field entity.	
	println("CHANGE SIGNATURE: Finding non-public methods used in visit methods");
     rel [str, int, Entity] mrel = { < l.path, l.offset, e > |  <loc l,e> <- rascal@methods, l.path in classPaths,
    	l notin overlapsAux<3>, entity([package("org"),package("rascalmpl"),_*]) := e };
    
    // Now, limit this to just those methods that are called inside the visitor methods.
    rel[Entity,str,int,Entity,Entity,loc] mrel2 = { <e,fp,o,i,dm,l> | fi:<fp,o,e> <- mrel, 
    		<fp,bn,en,l,i,dm> <- overlapsAux, bn <= o, o <= en };
    
    // Limit it further to those methods that are not public
    rel[Entity,str,int,Entity,Entity,loc] mrel3 = { mri | mri <- mrel2, \public() notin (rascal@modifiers)[mri[0]] };
    set[Entity] npMethods = mrel3<0>;
    
    // Finally -- these are the methods that need to be made public, along with their location in the code
    rel[Entity,loc] npMethodsWLocs = { <m,l> | m <- npMethods, l <- invert(rascal@methodDecls)[m] };
	
	// Now, make these fields public
	println("CHANGE SIGNATURE: Making non-public methods public");
	rel[str,int] npOffsets = { <l.path,l.offset> | l <- npMethodsWLocs<1> };
	set[loc] npLocs = { };
	for (loc l <- npMethodsWLocs<1>) { l.offset = -1; l.length = -1; npLocs += l; }
	bool success = true;
	for (loc l <- npLocs) {
		set[int] offsets = npOffsets[l.path];
		println("CHANGE SIGNATURE: Making <size(offsets)> non-public methods public in compilation unit <l>");
		rel[str,str] res = makeMethodsPublic(offsets, l);
		if (size(res) > 0) {
			success = false;
			for (msg <- res<1>) println("CHANGE SIGNATURE: Encountered error: <msg>");
		}
		println("CHANGE SIGNATURE: Finished making non-public methods public in compilation unit");
	}
	
	println("CHANGE SIGNATURE: Finished changing method signatures");
	
	return success;
}

public bool fullyQualifyTypes() {
	// The resource base we are using
	println("QUALIFY: Extracting Rascal Project");
	Resource rascal = extractProject(|project://rascal|);
	
	// This is the interface that defines the visitor; we use this to link to the other
	// information that we need.
	Entity astVisitor = makeInterfaceName("org.rascalmpl.ast.IASTVisitor", "T");
	
	// Get all the interfaces that could lead to implementations -- i.e., the IASTVisitor interface,
	// the interfaces that extend it, the interfaces that extend these interfaces, etc.
	println("QUALIFY: Finding all visitor interfaces");
	set[Entity] extenders = { astVisitor };
	solve (extenders) { extenders = extenders + { getInterfaceExtenders(rascal, e) | e <- extenders }; }

	// Get all the classes that could then have actual implementations -- i.e., all classes that implement
	// the interfaces in extenders, plus all classes that extend these classes, etc.
	println("QUALIFY: Finding all visitor implementing classes");
	set[Entity] implementers = { getInterfaceImplementers(rascal, e) | e <- extenders };
	solve (implementers) { implementers = implementers + { getClassExtenders(rascal, e) | e <- implementers }; }
	implementers = implementers - { i | i <- implementers, entity([_*,class("BoxEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("StringTemplateConverter"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("TestEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,package("debug"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("IUPTRAstToSymbolConstructor"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("DeclarationCollector"),_*]) := i };
	
	// Get all the locations of the implementer classes
	println("QUALIFY: Finding locations for classes to qualify");
	rel[Entity,loc] classLocs = invert(rascal@classes);
	set[loc] locsToQualify = { };
	for (i <- implementers, il <- classLocs[i]) {
		il.offset = -1; il.length = -1;
		locsToQualify += il;
	}
	
	for (l <- locsToQualify) {
		println("QUALIFY: Fully qualifying names in file <l>");
		fullyQualifyTypeNamesInFile(l);
	}
	
	println("QUALIFY: Finished");
	return true;
}

public bool performCleanups() {
	bool res = cleanUpImplementers();
	if (res) res = encapsulateVisitorFields();
	if (res) res = makeVisitorMethodsPublic();
	if (res) res = fullyQualifyTypes();
	return res;
}

public void checkForProblems() {
	println("CHECK: Extracting Rascal Project");
	Resource rascal = extractProject(|project://rascal|);
	Entity astVisitor = makeInterfaceName("org.rascalmpl.ast.IASTVisitor", "T");
	
	// Starting at the base interface, get all reachable interfaces (based on extends relation)
	println("CHECK: Finding all visitor interfaces");
	set[Entity] extenders = { astVisitor };
	solve (extenders) { extenders = extenders + { getInterfaceExtenders(rascal, e) | e <- extenders }; }

	// Starting with interfaces, get all reachable implementing classes (based on implements and extends relations)
	println("CHECK: Finding all visitor implementing classes");
	set[Entity] implementers = { getInterfaceImplementers(rascal, e) | e <- extenders };
	solve (implementers) { implementers = implementers + { getClassExtenders(rascal, e) | e <- implementers }; }
	implementers = implementers - { i | i <- implementers, entity([_*,class("BoxEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("StringTemplateConverter"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("TestEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,package("debug"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("IUPTRAstToSymbolConstructor"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("DeclarationCollector"),_*]) := i };
	
	// Get the visitors declared in the base interface. This gives us the names of the visitor methods we
	// care about.
	println("CHECK: Finding base visitor methods");
	MethodInfo miBase = getVisitorsInClassOrInterface(rascal, astVisitor);
	set[str] miBaseNames = { mn | entity([_*,method(mn,_,_)]) <- miBase.method };
	
	// Get the implementations of these visitors -- to be in this table, this must be included in the
	// IASTVisitor interface (this prevents spurious matches just because we have a method named visit...)
	println("CHECK: Finding visitor method implementations");
	MethodInfoWDef miImp = { <mi.mname,mi.mloc,mi.owner,mi.method,def> | e <- implementers, 
	    tuple[str mname, loc mloc, Entity owner, Entity method] mi <- getVisitorsInClassOrInterface(rascal,e), 
		entity([_*,method(mn,_,_)]) := mi.method, mn in miBaseNames, def <- (miBase[mn]<2>) };

	// Get all the methods that are of the form visit*, we need to manually check to see if there are others
	// that we missed for some reason. Any methods in here are not overrides of the initially defined
	// visitor methods.
	// TODO: Check the difference -- these are methods that are named visit..., but are not actually overrides of
	// the real visitor methods. From my initial look, these are all other methods, which could have been named
	// something else, which happen to be called from within the class with the real visitor methods.
	println("CHECK: Finding all other methods named visit...");
	MethodInfo miImpOther = { mi | e <- (rascal@types)<1>, e notin extenders,
	    tuple[str mname, loc mloc, Entity owner, Entity method] mi <- getVisitorsInClassOrInterface(rascal,e),
	    mi notin miImp<0,1,2,3> };
	
	// Here, look at the functions and see WHY they are not included in miImp -- most likely reason? part of
	// another visitor...
	println("CHECK: Other visit methods:");
	set[Entity] otherVisitMethods = miImpOther<3>;
	for (e <- otherVisitMethods) println("CHECK: <readable(e)>");
	
	// Get methods that take the visitor interface as a parameter. These in general should be the accept
	// methods. 
	println("CHECK: Finding methods that take <readable(astVisitor)> as a parameter");
	rel[Entity method, loc l] uses = getMethodsWithParameter(rascal, astVisitor);
	
	// Get any methods named accept, to make sure we aren't missing things...
	println("CHECK: Finding all accept methods");
	MethodInfo accepters = getMethodsNamedAccept(rascal);
	
	// Look at accept methods that do not take an IASTVisitor parameter, make sure we aren't missing
	// other accept methods (for instance, ones that take a subtype)
	// NOTE: These need to be reviewed to make sure they are not problematic; they appear to all deal with
	// value and type visitors, so this should be fine
	println("CHECK: Finding all accept methods that do not take <readable(astVisitor)> as a parameter");
	MethodInfo oddities = { e | e:<_,_,_,m> <- accepters, m notin uses<0> };
	set[Entity] otherAccepters = oddities<3>;
	println("CHECK: Other accepters:");
	for (e <- otherVisitMethods) println("CHECK: <readable(e)>");
	
	// For each use, get the actual visit method that is called. calledMethodsAux includes the method name,
	// the location of the method, and the name of each visit method called in the method body. calledMethods
	// includes the method name, the location of the method, and the MethodInfo item for each visit method
	// called in the method body.
	println("CHECK: Finding information about visit methods called inside accept methods");
	rel[Entity method, loc l, str mname] calledMethodsAux = { <m,l,mn> | <m,l> <- uses, mc := readFile(l), /<mn:visit\w*>[(]/ <- mc };
	rel[Entity method, loc l, Entity calls] calledMethods = { <m,l,mni> | <m,l,mn> <- calledMethodsAux, <mn,_,_,mni> <- miBase }; 
	
	// Do we have asserts? Sanity checking here...
	println("CHECK: Ensuring that each accept method only calls one visitor...");
	if (size(calledMethods) != size(calledMethods<0,1>)) println("ERROR: Some accept methods call multiple visitors!");
}

public void convertCode() {
	// The resource base we are using
	println("CONVERT: Extracting Rascal Project");
	Resource rascal = extractProject(|project://rascal|);
	
	// This is the interface that defines the visitor; we use this to link to the other
	// information that we need.
	Entity astVisitor = makeInterfaceName("org.rascalmpl.ast.IASTVisitor", "T");
	
	// Get all the interfaces that could lead to implementations -- i.e., the IASTVisitor interface,
	// the interfaces that extend it, the interfaces that extend these interfaces, etc.
	println("CONVERT: Finding all visitor interfaces");
	set[Entity] extenders = { astVisitor };
	solve (extenders) { extenders = extenders + { getInterfaceExtenders(rascal, e) | e <- extenders }; }

	// Get all the classes that could then have actual implementations -- i.e., all classes that implement
	// the interfaces in extenders, plus all classes that extend these classes, etc.
	println("CONVERT: Finding visitor method implementations");
	set[Entity] implementers = { getInterfaceImplementers(rascal, e) | e <- extenders };
	solve (implementers) { implementers = implementers + { getClassExtenders(rascal, e) | e <- implementers }; }
	implementers = implementers - { i | i <- implementers, entity([_*,class("BoxEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("StringTemplateConverter"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("TestEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,package("debug"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("IUPTRAstToSymbolConstructor"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("DeclarationCollector"),_*]) := i };
	
	// Come up with evaluator method names for the various implementers
	//rel[Entity imp, str evalMethod] evalMethods = { <i, makeEvalMethodName(i)> | i <- implementers };
	//rel[Entity imp, str evalMethod] evalMethods = { <i, "evaluate"> | i <- implementers };
	
	// Form the "super" relation, so when we say "super" we know which class is being referred to. This
	// is needed when rewriting the code in the visit methods, which sometimes calls a super method
	println("CONVERT: Building superclass relation");
	rel[Entity,Entity] super = { < e1, e2 > | e1 <- implementers, <e1, e2> <- rascal@extends };

	// Get methods that take the visitor interface as a parameter. These in general should be the accept
	// methods. 
	println("CONVERT: Finding accept methods");
	rel[Entity method, loc l] uses = getMethodsWithParameter(rascal, astVisitor);

	// Narrow this down to only those in the org.rascalmpl.ast hierarchy (should check the ones that aren't
	// as a sanity check in the code above)
	rel[Entity method, loc l] justInAst = { <e,l> | <e,l> <- uses, entity([_*,package("ast"),_*]) := e };
	
	// Associate these with the related sourcecode
	//rel[Entity method, loc l, str code] usesWithCode = { <e,l,readFile(l)> | <e,l> <- justInAst };
	
	// Form the "containment" hierarchy as a relation; this will tell us which classes we need to create (i.e., all
	// those in the second projection) as well as where we need to create them (if the item in the first projection
	// is a package, this is a new sourcefile and class, else it is an inner class) 
	println("CONVERT: Building class hierarchy information");
	set[Entity] tops = {entity([x,package(p1)]) | e <- justInAst<0>, entity([x*,package(p1),i,_*]) := e, (class(_) := i || class(_,_) := i) };
	rel[Entity,Entity] hierarchy = { <et, entity([i,j])> | e <- justInAst<0>, et <- tops, entity([i*]) := et, entity([i,j,_*]) := e, (class(_) := j || class(_,_) := j) };
	solve(hierarchy) {
		hierarchy = hierarchy + { <et, entity([i,j])> | e <- justInAst<0>, et <- hierarchy<1>, entity([i*]) := et, entity([i,j,_*]) := e, (class(_) := j || class(_,_) := j) };
	}

	// Get the visitors declared in the base interface. This gives us the names of the visitor methods we
	// care about.
	println("CONVERT: Finding visit method implementations");
	MethodInfo miBase = getVisitorsInClassOrInterface(rascal, astVisitor);
	set[str] miBaseNames = { mn | entity([_*,method(mn,_,_)]) <- miBase.method };
	
	// Get the implementations of these visitors -- to be in this table, this must be included in the
	// IASTVisitor interface (this prevents spurious matches just because we have a method named visit...)
	rel[str mname, loc mloc, Entity owner, Entity method, Entity defOf, str source] miImp = 
		{ <mi.mname,mi.mloc,mi.owner,mi.method,def,readFile(mi.mloc)> | e <- implementers, 
	    	tuple[str mname, loc mloc, Entity owner, Entity method] mi <- getVisitorsInClassOrInterface(rascal,e), 
			entity([_*,method(mn,_,_)]) := mi.method, mn in miBaseNames, def <- (miBase[mn]<2>) };
			
	rel[Entity inType, str mname, loc mloc, Entity owner, Entity method, Entity defOf, str source] byParam = 
		{ <p,mn,ml,o,m,d,s> | <mn,ml,o,m,d,s> <- miImp, entity([_*,method(_,[p,_*],_)]) := m };
	
	println("CONVERT: Building new methods");
	rel[Entity inType, Entity owner, Entity method, str oldsource, str newsource] withNewSource = 
		{ <p,o,m,os,buildNewMethod(rascal,o,m,os,super)> | <p,_,_,o,m,_,os> <- byParam };
		
	// Generate code for each of the top-level classes, which will then each have their own files
	Entity dest = entity([package("org"),package("rascalmpl"),package("semantics"),package("dynamic")]);
	println("CONVERT: Generating classes");
	rel[Entity topClass, str source] byClass = 
		{ <c, "package <readable(dest)>;\n\n<generateClass(c, withNewSource<0,4>, hierarchy, false, rascal)>"> | 
			t <- tops, c <- hierarchy[t], size((hierarchy+)[c]) > 0 || c in withNewSource<0> };
		
	// Generate the files
	loc base = |file:///Users/mhills/Projects/visitors/before/rascal/src/org/rascalmpl|;
	
	// NOTE: For some reason, this doesn't always return true or false correctly
	if (! (mkDirectory(base+"/semantics") && mkDirectory(base+"/semantics/dynamic"))) println("Warning, may not have created directories correctly, checking...");
	if (! (exists(base+"/semantics") && exists(base+"/semantics/dynamic"))) throw "Error, could not create target directories";
	
	for (t <- byClass<0>) {
		if (entity([_*,ce]) := t) writeFile(base+"/semantics/dynamic/<getClassName(ce)>.java", getOneFrom((byClass[t])));
	}
	println("CONVERT: Classes generated");	
}

public str generateClass(Entity classEntity, rel[Entity inType, str newsource] typeSources, rel[Entity,Entity] hierarchy, bool isStatic, Resource rascal) {
	// First, get the name of the last class entity -- this is most likely an inner class, 
	// such as Addition inside Exception, but not necessarily.
	set[str] methodSources = typeSources[classEntity];
	str cname = "";
	if (entity([_*,i]) := classEntity && (class(cn) := i || class(cn,_) := i)) cname = cn;
	if (cname == "") throw "Error in generateClass, could not find class name!";
	
	str classSource = "";
	if (\static() in (rascal@modifiers)[classEntity]) classSource += "static ";
//	if (isStatic) classSource += "static ";
	classSource += "public ";
	if (\abstract() in (rascal@modifiers)[classEntity]) classSource += "abstract ";
	classSource += "class <cname> extends <readable(classEntity)> {\n\n";
	
	for (ce:entity([_*,constr(cps)]) <- (rascal@declaredMethods)[classEntity]) {
		set[Modifier] cmods = (rascal@modifiers)[ce];
		if (\public() in cmods) {
			classSource = classSource + "\npublic <cname> (";
			int cpsCount = 1;
			for (cpsi <- cps) {
				classSource = classSource + (cpsCount > 1 ? "," : "") + "<readable(cpsi)> __param<cpsCount>";
				cpsCount += 1;
			}
			classSource = classSource + ") {\n\tsuper(";
			cpsCount = 1;
			for (cpsi <- cps) {
				classSource = classSource + (cpsCount > 1 ? "," : "") + "__param<cpsCount>";
				cpsCount += 1;
			}
			classSource = classSource + ");\n}\n";
		} 
	}
	
	for (ms <- methodSources) classSource = classSource + ms + "\n";
	
	for (c <- hierarchy[classEntity]) classSource = classSource + generateClass(c,typeSources,hierarchy,true,rascal) + "\n";
	
	classSource += "}";
	
	return classSource;
}

public str getSharedImports(Resource rascal, set[Entity] implementers) {
	set[str] importLines = { };
	for (i <- implementers) {
		set[loc] classLocs = invert(rascal@classes)[i];
		if (size(classLocs) != 1) throw "Error, multiple locations for the same class";
		loc cloc = getOneFrom(classLocs);
		cloc.offset = -1; cloc.length = -1; // clears out all offset information
		list[str] fileLines = readFileLines(cloc);
		for (line <- fileLines) {
			if (/^\s*import\s{1}/ := line) importLines += line; 
		}
	}	
	return reducer(importLines, str(str x, str y) { return x + "\n" + y; }, "");
}

//public list[&T] filter(list[&T] l, bool(&T) f) { 
//	return [ x | x <- l, f(x)]; 
//}

public str getClassName(Id id) { 
	if (class(cn) := id || class(cn,_) := id) 
		return cn; 
	else 
		return ""; 
}

public str collapseStrList(list[str] strs) {
	return reducer(strs, str(str x, str y) { return x + y; }, "");
}

//public str makeEvalMethodName(Entity e) {
//	s = collapseStrList([ getClassName(x) | entity(l) := e, x <- filter(l,bool(Id i) { return (class(_) := i || class(_,_) := i); }) ]);
//	return toLowerCase(substring(s,0,1))+substring(s,1);
//}

public str replaceLastThatActuallyWorks(str input, str find, str replacement) {
	if(/^<pre:.*><find><post:.*?>$/s := input) {	
		return "<pre><replacement><post>";
	}	
	
	return input;
}

public str getMethodBody(str methodCode) {
	if (/[{]<body:.*>/s := replaceLastThatActuallyWorks(methodCode,"}","")) 
		return body;
	else
		return "";
}

//
// Replace method invocations of the form ClassName.method with the fully qualified version of ClassName.
// This is needed because we are moving the invoking code to where ClassName is not in scope.
//
public str expandStaticClass(str methodCode, Entity instance) {
	str packagePart = (entity([pi*,i]) := instance && (class(_) := i || class(_,_) := i)) ? readable(entity([pi])) : "";
	str classPart = (entity([_*,i]) := instance) ? getClassName(i) : "";
	str fullyQualified = ( (packagePart == "") ? "" : "<packagePart>.") + classPart;
	
	solve(methodCode) {
		if(/<left:.*><leftpre:[^\w.]+><classPart>\.<right:.*>/s := methodCode) methodCode = "<left><leftpre><fullyQualified>.<right>";
		if(/^<classPart>\.<right:.*>/s := methodCode) methodCode = "<fullyQualified>.<right>";
	}
	return methodCode;
}

//
// Replace code of the form this.evaluator.visitMethod(something) with evaluate(this.evaluator). This is a special
// case for one of the current visitors, which just delegates to the same visitor defined on another evaluator.
//
public str replaceEvalVisit(str methodCode) {
	solve(methodCode) {
		if (/<left:.*><leftpre:[^\w]+>this[.]evaluator[.]visit\w*\(\w*\)<right:.*>/s := methodCode) 
			methodCode = "<left><leftpre>__evaluate(this.evaluator)<right>";
	}
	return methodCode; 
}

//
// Replace the keyword this with the thisItem, such as __eval. This is because the current this item
// is becoming the parameter __eval being passed into the function.
//
public str replaceThis(str methodCode, str thisItem) {
	solve(methodCode) {
		if(/<left:.*><leftpre:[^\w]+>this<rightpost:\W+><right:.*>/s := methodCode) methodCode = "<left><leftpre><thisItem><rightpost><right>";
		if(/^this<rightpost:\W+><right:.*>/s := methodCode) methodCode = "<thisItem><rightpost><right>";
		if(/<left:.*><leftpre:[^\w]+>this$/s := methodCode) methodCode = "<left><leftpre><thisItem>";
		if(/^this$/s := methodCode) methodCode = "<thisItem>";
	}
	return methodCode;
}

//
// Replace code of the form accept( with evaluate(.
// 
public str replaceAccepts(str methodCode, str evalMethod) {
	solve(methodCode) {
		if(/<left:.*><leftpre:[^\w]+>accept\(<right:.*>/s := methodCode) methodCode = "<left><leftpre><evalMethod>(<right>";
		if(/^accept\(<right:.*>/s := methodCode) methodCode = "<evalMethod>(<right>";
	}
	return methodCode;
}	

//
// Replace the given local parameter with this, since the generated code will go into the class
// for the current local parameter.
//
public str replaceParamWithThis(str methodCode, str param) {
	solve(methodCode) {
		if(/<left:.*><leftpre:[^\w]+><param><rightpost:\W+><right:.*>/s := methodCode) methodCode = "<left><leftpre>this<rightpost><right>";
		if(/^<param><rightpost:\W+><right:.*>/s := methodCode) methodCode = "this<rightpost><right>";
		if(/<left:.*><leftpre:[^\w]+><param>$/s := methodCode) methodCode = "<left><leftpre>this";
		if(/^<param>$/s := methodCode) methodCode = "this";
	}
	return methodCode;
}

//
// Replace code of the form super.visitMethod(this) with this.evaluate((superClass)__eval)
//
public str replaceSuper(str methodCode, Entity instance, rel[Entity,Entity] super) {
	if (size(super[instance]) != 1) throw "Error in replaceSuper, superclass of <readable(instance)> should just contain 1 element, not <super[instance]>";
	Entity superClass = getOneFrom(super[instance]);
	str superClassCast = "(<readable(superClass)>)";
	solve(methodCode) {
		if(/<left:.*><leftpre:[^\w]+>super\.visit\w*\(this\)<rightpost:\W+><right:.*>/s := methodCode) methodCode = "<left><leftpre>this.__evaluate(<superClassCast>__eval)<rightpost><right>";
		if(/^super\.visit\w*\(this\)<rightpost:\W+><right:.*>/s := methodCode) methodCode = "this.__evaluate(<superClassCast>__eval)<rightpost><right>";
		if(/<left:.*><leftpre:[^\w]+>super\.visit\w*\(this\)$/s := methodCode) methodCode = "<left><leftpre>this.__evaluate(<superClassCast>__eval)";
		if(/^super\.visit\w*\(this\)$/s := methodCode) methodCode = "this.__evaluate(<superClassCast>__eval)";
	}
	return methodCode;
}

//
// Generate the new method code, using the code transformations defined above
//
public str buildNewMethod(Resource rascal, Entity instance, Entity methodEntity, str methodCode, rel[Entity,Entity] super) {
	str methodBody = getMethodBody(methodCode);
	
	if (entity([_*,method(mn,mps,mr)]) := methodEntity) {
		if (size(mps) != 1) throw "Unexpected visit method signature for <readable(methodEntity)>, should have exactly one parameter!";
		set[Entity] varEntities = (rascal@variables)<1>;
		set[str] paramIds = { p | entity([i*]) := methodEntity, entity([i,\parameter(str p)]) <- varEntities };
		if (size(paramIds) != 1) throw "Unexpected visit parameter signature for <readable(methodEntity)>, should have one named parameter, instead have <paramIds>!";
		str paramId = getOneFrom(paramIds);
		
//		methodBody = expandStaticClass(methodBody, instance);
		methodBody = replaceEvalVisit(methodBody);
		methodBody = replaceThis(methodBody, "__eval");
		methodBody = replaceAccepts(methodBody, "__evaluate");
		methodBody = replaceParamWithThis(methodBody, paramId);
		methodBody = replaceSuper(methodBody, instance, super);
		
		str paramsForSig = "";
		if (entity([_*,class(_,tps)]) := instance) {
			for (entity([typeParameter(tpstr)]) <- tps) {
				if (paramsForSig == "") 
					paramsForSig = " \<<tpstr>";
				else
					paramsForSig += ",<tpstr>";
			}
			if (paramsForSig != "") paramsForSig += "\> ";
		}
		
		methodCode = "@Override\npublic<paramsForSig> <readable(mr)> __evaluate(<readable(instance)> __eval) {\n\t<methodBody>\n}\n";
		return methodCode;
	}
	throw "Unexpected visit method entity, expected method, found <readable(methodEntity)>";
}

public void removeOldCode() {
	// The resource base we are using
	println("REMOVE: Extracting Rascal Project");
	Resource rascal = extractProject(|project://rascal|);
	
	// This is the interface that defines the visitor; we use this to link to the other
	// information that we need.
	Entity astVisitor = makeInterfaceName("org.rascalmpl.ast.IASTVisitor", "T");
	
	// Get all the interfaces that could lead to implementations -- i.e., the IASTVisitor interface,
	// the interfaces that extend it, the interfaces that extend these interfaces, etc.
	println("REMOVE: Finding all visitor interfaces");
	set[Entity] extenders = { astVisitor };
	solve (extenders) { extenders = extenders + { getInterfaceExtenders(rascal, e) | e <- extenders }; }

	// Get all the classes that could then have actual implementations -- i.e., all classes that implement
	// the interfaces in extenders, plus all classes that extend these classes, etc.
	println("REMOVE: Finding all visitor implementers");
	set[Entity] implementers = { getInterfaceImplementers(rascal, e) | e <- extenders };
	solve (implementers) { implementers = implementers + { getClassExtenders(rascal, e) | e <- implementers }; }
	implementers = implementers - { i | i <- implementers, entity([_*,class("BoxEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("StringTemplateConverter"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("TestEvaluator"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,package("debug"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("IUPTRAstToSymbolConstructor"),_*]) := i };
	implementers = implementers - { i | i <- implementers, entity([_*,class("DeclarationCollector"),_*]) := i };
	implementers = implementers - { i | i <- implementers, (entity([_*,class(cn)]) := i && /NullASTVisitor/ := cn) || (entity([_*,class(cn,_)]) := i && /NullASTVisitor/ := cn)};
	
	// Get the visitors declared in the base interface. This gives us the names of the visitor methods we
	// care about.
	println("REMOVE: Finding visitor method implementations");
	MethodInfo miBase = getVisitorsInClassOrInterface(rascal, astVisitor);
	set[str] miBaseNames = { mn | entity([_*,method(mn,_,_)]) <- miBase.method };
	
	// Get the implementations of these visitors -- to be in this table, this must be included in the
	// IASTVisitor interface (this prevents spurious matches just because we have a method named visit...)
	rel[Entity owner, loc mloc] miImp = 
		{ <e,mi.mloc> | e <- implementers, 
			tuple[str mname, loc mloc, Entity owner, Entity method] mi <- getVisitorsInClassOrInterface(rascal,e), 
			entity([_*,method(mn,_,_)]) := mi.method, mn in miBaseNames };
			
	// Remove these methods from the file
	println("REMOVE: Removing old visitor method implementations");
	rel[Entity,loc] classLocs = invert(rascal@classes);
	set[loc] entityLocs = { };
	for (el <- miImp<1>) { el.offset = -1; el.length = -1; entityLocs += el; }
	rel[str,int] offsetsWPaths = { <l.path,l.offset> | l <- miImp<1> };
	
	for (l <- entityLocs) {
		println("REMOVE: Removing implementations in file <l.uri>");
		set[int] offsets = offsetsWPaths[l.path];
		removeMethods(offsets,l);
	}
}