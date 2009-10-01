// ooc imports
import structs/ArrayList

// rock imports
import frontend/[TokenType, ListReader, SourceReader, Token]

// meta imports
import ../[Rule, Node], TokenRule

GroupRule: class extends Rule {
	
	rules: ArrayList<Rule>
	
	init: func (.name) {
		super(name)
	}
	
	applyImpl: func (reader: ListReader<Token>, sReader: SourceReader) -> Node {
		
		node = null : Node
		
		printf(" [%s] {\n", name)
		
		rule: Rule
		mark := reader mark()
		
		// applying
		for(rule in rules) {
				
			// we only want root rules here
			if(!rule isRoot()) continue
			
			token := reader peek()
			//printf(" [%s] trying rule '%s'\n", name, rule name)
			node = rule apply(reader, sReader)
			if(node) {
				printf(" [%s] \tmatched '%s'!\n", name, rule name)
				break // if we matched, stop there - we're happy
			}
			reader seek(mark) // didn't match? try again at the same pos.
			
		}
		
		printf(" [%s] }\n", name)
		//printf(" [%s] returning '%s'\n", name, node ? node type name : "null")
		return node
		
	}
	
	subApplyImpl: func (reader: ListReader, sReader: SourceReader, firstNode: Node) -> Node {
		return null
	}
	
	addRule: func (rule: Rule) {
		if(rules == null) rules = ArrayList<Rule> new()
		rules add(rule)
	}
	
	addLeaf: func (leaf: Rule) {
		if(!leafs) leafs = ArrayList<Rule> new()
		leafs add(leaf)
		printf("// Trying to add leaf '%s' to grouprule '%s', adding to all children rules\n", leaf name, name)
		leaf root = false
		if(rules) for(rule: Rule in rules) {
			rule addLeaf(leaf)
		}
	}
	
	/*
	isRoot: func -> Bool {
		if(!rules || rules isEmpty()) return false
		
		for(rule: Rule in rules) {
			//if(!rule isRoot()) return false
			if(rule class != TokenRule) return false
		}
		return true		
	}
	*/

}
