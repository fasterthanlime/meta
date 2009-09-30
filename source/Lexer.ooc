// ooc imports
import structs/[List, ArrayList]

// rock imports
import frontend/[SourceReader, Tokenizer, Token, ListReader]

// meta imports
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
	
	addRule: func (rule: Rule) {
		
		rules add(rule)
		
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
		
			rule: Rule
			for(rule in rules) {
				
				printf(" trying rule '%s'\n", rule name)
				node = rule apply(reader, sReader)
				
				while(node) {
					
					cont := false
					
					if(rule leafs) for(leaf: Rule in rule leafs) {
						printf("  \\_ trying leaf '%s'\n", leaf name)
						sub := leaf subApply(reader, sReader, node)
						if(sub) {
							printf("\n leaf '%s' matched!\n", leaf name)
							node = sub
							rule = leaf
							cont = true
							break
						}
					}
					if(cont) continue
					
					break
				}
				
				if(node) break
				
				reader seek(mark)
				
			}
			
			if(node) {
				printf("   -> Got node '%s'\n\n", node type name)
			} else {
				token := reader peek()
				printf("!!  Choked on token '%s' at %s\n", token toString(), sReader getLocation(token start, token length) toString())
				exit(1)
			}
		
		}
		printf("\nParsing ended successfully =)\n")
		
	}
	
}
