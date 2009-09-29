// ooc imports
import structs/[List, ArrayList]

// rock imports
import frontend/[SourceReader, Tokenizer, Token, ListReader]

// meta2 imports
import Rule, Node

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
		
		reader := ListReader<Token> new(tokens)
		
		while (reader hasNext()) {
		
			node = null : Node
			mark := reader mark()
		
			for(rule: Rule in rules) {
				printf("\n == Trying rule %s (%s)\n", rule name, rule class name)
				node = rule apply(reader, sReader)
				if(node) break
				reader seek(mark)
			}
			
			if(node) {
				printf("  -> Got node of type %s\n", node type class name)
			} else {
				token := reader peek()
				printf("EE] Choked on token '%s' at %s\n", token toString(), sReader getLocation(token start, token length) toString())
				exit(1)
			}
		
		}
		
	}
	
}
