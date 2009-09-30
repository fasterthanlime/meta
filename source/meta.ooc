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
	parser addRule(access)
	expression addRule(access)
	
	// varAccess
	varAccess := TokenRule new("varAccess", TokenType NAME)
	parser addRule(varAccess)
	access addRule(varAccess)
	
	// assignment
	assignment := SequenceRule new("assignment")
	assignment addRule(access)
	assignment addRule(TokenRule new("=", TokenType ASSIGN))
	assignment addRule(access)
	parser addRule(assignment)
	access addRule(assignment)
	
	// linesep
	linesep := TokenRule new("linesep", TokenType LINESEP)
	parser addRule(linesep)
	
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
