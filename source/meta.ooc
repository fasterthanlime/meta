// ooc imports
import structs/Array

// rock imports
import frontend/TokenType

// meta imports
import Lexer, rules/[TokenRule, SequenceRule]

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
	lexer: Lexer

	// FIXME '=args' should work. But it doesn't.
	init: func(args: Array<String>) {
		this args = args
		lexer = makeLexer()
	}

	run: func {
		
		iter := args iterator()
		if(iter hasNext()) iter next() // skip the first - if any
		
		while(iter hasNext()) {
			arg := iter next()
			printf("Parsing %s\n", arg)
			lexer parse(arg)
		}
		
	}

}

/**
 * This is a test lexer-building function to help test/evolve the design.
 * It manually adds rules to the lexer instead of reading them from a 
 * grammar file.
 */
makeLexer: func -> Lexer {
	
	lexer := Lexer new()
	
	// access
	access := TokenRule new("access", TokenType NAME)
	lexer addRule(access)
	
	// assignment
	assignment := SequenceRule new("assignment")
	assignment addRule(access)
	assignment addRule(TokenRule new("=", TokenType ASSIGN))
	assignment addRule(access)
	lexer addRule(assignment)
	
	// linesep
	linesep := TokenRule new("linesep", TokenType LINESEP)
	lexer addRule(linesep)
	
	return lexer
	
}

/**
 * Utility function to print a message to stderr, then exit.
 */
quit: func (message: String) {
	
	fprintf(stderr, "%s\n", message)
	exit(1)
	
}
