// ooc imports
import structs/Array

// rock imports
import frontend/TokenType

// meta imports
import Parser, rules/[TokenRule, SequenceRule, GroupRule]

/**
 * Entry point
 */
main: func(args: Array<String>) {

	if(args size() <= 1) quit("Usage: meta FILE")
	
	Main new(args) run()

}

/**
 * Main class - a-la Java ;)
 */
Main: class {

	args: Array<String>
	parser: Parser

	// FIXME '=args' should work. But it doesn't.
	init: func(args: Array<String>) {
		this args = args
		parser = makeParser()
	}

	run: func {
		
		iter := args iterator()
		if(iter hasNext()) iter next() // skip the first - if any
		
		while(iter hasNext()) {
			arg := iter next()
			printf("Parsing %s\n", arg)
			parser parse(arg)
		}
		
	}

}

/**
 * This is a test parser-building function to help test/evolve the design.
 * It manually adds rules to the parser instead of reading them from a 
 * grammar file.
 */
makeParser: func -> Parser {
	
	parser := Parser new()
	
	// expression
	expression := GroupRule new("expression")
	parser addRule(expression)
	
	// access
	access := GroupRule new("access")
	//access root = true
	parser addRule(access)
	
	// assignment
	assignment := SequenceRule new("assignment")
	assignment addRule(access)
	assignment addRule(TokenRule new("=", TokenType ASSIGN))
	assignment addRule(expression)
	parser addRule(assignment)
	
	// add
	add := SequenceRule new("add")
	add addRule(expression)
	add addRule(TokenRule new("+", TokenType PLUS))
	add addRule(expression)
	//add root = true
	parser addRule(add)
	
	// varAccess
	varAccess := TokenRule new("varAccess", TokenType NAME)
	varAccess root = true
	parser addRule(varAccess)
	
	openParen := TokenRule new("(", TokenType OPEN_PAREN)
	parser addRule(openParen)
	
	closParen := TokenRule new(")", TokenType CLOS_PAREN)
	parser addRule(closParen)
	
	// paren
	paren := SequenceRule new("paren")
	paren addRule(openParen)
	paren addRule(expression)
	paren addRule(closParen)
	paren root = true
	parser addRule(paren)
	
	// linesep
	linesep := TokenRule new("linesep", TokenType LINESEP)
	parser addRule(linesep)
	
	// expression children
	expression addRule(paren)
	expression addRule(access)
	expression addRule(add)
	
	// access children
	access addRule(varAccess)
	access addRule(assignment)
	
	parser build()
	
	return parser
	
}

/**
 * Utility function to print a message to stderr, then exit.
 */
quit: func (message: String) {
	
	fprintf(stderr, "%s\n", message)
	exit(1)
	
}
