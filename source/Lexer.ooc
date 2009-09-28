// ooc imports
import structs/[List, ArrayList]

// rock imports
import frontend/[SourceReader, Tokenizer, Token]

// meta2 imports
import Rule

/**
 * Applies rules to a list of tokens in order to build an AST
 * (Abstract Syntax Tree)
 */
Lexer: class {
	
	rules: ArrayList<Rule>
	
	init: func {
		
		rules = ArrayList<Rule> new()
		
	}
	
	parse: func (path: String) {
		
		sReader := SourceReader getReaderFromPath(path)
		tokens := Tokenizer new() parse(sReader)
		
		for(token: Token in tokens) {
			printf("%s ", token toString(sReader))
		}
		println()
		
		for(rule in rules) {
			
		}
		
	}
	
}
