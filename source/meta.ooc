// ooc imports
import structs/Array

// meta imports
import Lexer

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
	return lexer
	
}

/**
 * Utility function to print a message to stderr, then exit.
 */
quit: func (message: String) {
	
	fprintf(stderr, "%s\n", message)
	exit(1)
	
}
