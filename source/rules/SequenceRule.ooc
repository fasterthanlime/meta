// ooc imports
import structs/ArrayList

// rock imports
import frontend/[TokenType, ListReader, SourceReader, Token]

// meta imports
import ../[Rule, Node], TokenRule

SequenceRule: class extends Rule {
	
	rules: ArrayList<Rule>
	
	init: func (.name) {
		super(name)
	}
	
	applyImpl: func (reader: ListReader<Token>, sReader: SourceReader) -> Node {
		
		if(!rules || rules isEmpty()) return null
		node := rules get(0) apply(reader, sReader)
		if(node) return subApply(reader, sReader, node)
		return null
		
	}
	
	subApplyImpl: func (reader: ListReader<Token>, sReader: SourceReader, firstNode: Node) -> Node {
		
		if(!rules || rules isEmpty()) return firstNode
		
		printf(" [%s] being sub-applied.\n", name)
		
		node : Node = null
		i := 0
		for(rule: Rule in rules) {
			i += 1
			if(i == 1) {
				//printf(" [%s] (skipping '%s')\n", name, rule name)
				continue // skip the first one, we're subApplying
			}
			node = rule apply(reader, sReader)
			if(node) {
				printf(" [%s] \tgot element '%s'!\n", name, rule name)
			} else {
				printf(" [%s] \tbroke on '%s' (expected rule '%s')\n", name, reader peek() toString(sReader), rule name)
				break // broke the sequence :/
			}
		}

		return node
		
	}
	
	build: func {
		printf("// Building seqrule '%s'\n", name)
		if(rules && rules size() > 0) {
			parent := rules get(0)
			printf("// Adding as leaf to '%s'\n", parent name)
			parent addLeaf(this)
		}
	}
	
	addRule: func (rule: Rule) {
		if(!rules) rules = ArrayList<Rule> new()
		rules add(rule)
	}
	
	//isRoot: func -> Bool {
		//return (rules && rules size() > 0 && rules get(0) isRoot())
	//}

}
