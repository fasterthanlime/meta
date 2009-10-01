// ooc imports
import structs/[List, ArrayList]

// rock imports
import frontend/[SourceReader, Lexer, Token, ListReader]

// meta imports
import Rule, Node, rules/GroupRule, io/TabbedWriter

/**
 * Applies rules to a list of tokens in order to build an AST
 * (Abstract Syntax Tree)
 */
Parser: class {
	
	rules: ArrayList<Rule>
	tw := static TabbedWriter new(stdout)
	
	init: func {
		
		rules = ArrayList<Rule> new()
		
	}
	
	addRule: func (rule: Rule) {
		
		rules add(rule)
		
	}
	
	parse: func (path: String) {
		
		sReader := SourceReader getReaderFromPath(path)
		tokens := Lexer new() parse(sReader)
		
		for(token: Token in tokens) {
			printf("%s ", token toString(sReader))
		}
		println()
		
		reader := ListReader<Token> new(tokens)
		
		while (reader hasNext()) {

			node := apply(reader, sReader)
			
			if(node) {
				if(reader hasNext()) {
					reader peek()
					printf("   -> Got node '%s' at %d\n\n", node type name, reader peek() start)
				} else {
					printf("   -> Got node '%s' at the end\n\n", node type name)
				}
			} else {
				token := reader peek()
				printf("!!  Choked on token '%s' at %s\n", token toString(), sReader getLocation(token start, token length) toString())
				exit(1)
			}
		
		}
		printf("\nParsing ended successfully =)\n")
		
	}
	
	apply: func (reader: ListReader<Token>, sReader: SourceReader) -> Node {
		
		node = null : Node
		
		rule: Rule
		mark := reader mark()
		
		// applying
		for(rule in rules) {
				
			// we only want root rules here
			if(!rule isRoot()) continue
			
			//token := reader peek()
			//loc := sReader getLocation(token start, token length) toString()
			//printf(" [%s] trying rule '%s' at %s\n", "root", rule name, loc)
			node = rule apply(reader, sReader)
			if(node) {
				printf(" [%s] '%s' matched!\n", "root", rule name)
				break // if we matched, stop there - we're happy
			}
			reader seek(mark) // didn't match? try again at the same pos.
			
		}
		
		if(!node) return null
		
		// we're gonna descend recursively into rules. As long as
		// node is non-null, we keep going down.
		descend := true
		while(descend) {
			
			descend = false // so that if no leaf matched, we stop trying.
			printf(" [%s] descending from rule '%s'\n", "root", rule name)
			descend = tryLeafs(node&, rule&, reader, sReader)
			
		}
		
		return node
		
	}
	
	tryLeafs: func (node: Node@, rule: Rule@, reader: ListReader<Token>, sReader: SourceReader) -> Bool {
		
		if(rule leafs) for(leaf: Rule in rule leafs) {
			//token := reader peek()
			//loc := sReader getLocation(token start, token length) toString()
			//printf(" [%s] trying leaf '%s' -> '%s' at %s\n", "root", rule name, leaf name, loc)
			mark := reader mark()
			subNode := leaf subApply(reader, sReader, node)
			if(subNode) {
				printf(" [%s] leaf '%s' -> '%s' matched!\n", "root", rule name, leaf name)
				node = subNode
				rule = leaf 
				return true // keep descending - who knows? and stop searching leafs
			}
			//printf(" [%s] No luck for '%s' -> '%s' :/\n", "root", rule name, leaf name)
			reader seek(mark)
		}
		
		// FIXME ugly workaround with references.
		rrule : Rule = rule
		if(rrule class == GroupRule) {
			//printf(" [%s] Now trying leaf of sub-rules of group '%s'\n", "root", rule name)
			rules := rule as GroupRule rules
			for(subRule: Rule in rules) {
				//printf(" [%s] Trying leaf of sub-rule '%s'\n", "root", subRule name)
				if(tryLeafs(node&, subRule&, reader, sReader)) {
					rule = subRule
					return true
				}
			}
		}
		
		return false
		
	}
	
	build: func {
		
		for(rule: Rule in rules) {
			rule build()
		}
		
	}
	
}
