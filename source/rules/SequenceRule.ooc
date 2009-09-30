// ooc imports
import structs/ArrayList

// rock imports
import frontend/[TokenType, ListReader, SourceReader, Token]

// meta imports
import ../[Rule, Node]

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
	
	subApplyImpl: func (reader: ListReader, sReader: SourceReader, firstNode: Node) -> Node {
		
		if(!rules || rules isEmpty()) return firstNode
		
		node : Node = null
		i := 0
		for(rule: Rule in rules) {
			i += 1
			if(i == 1) continue // skip the first one, we're subApplying
			node = rule apply(reader, sReader)
			if(node) {
				//printf("Matched sub-rule #%i '%s', going forward =)\n", i, rule name)
			} else {
				//printf("Broke at sub-rule #%i <'%s', abandoning...\n", i, rule name)
				break
			}
		}

		return null
		
	}
	
	addRule: func (rule: Rule) {
		if(rules == null) rules = ArrayList<Rule> new()
		rules add(rule)
		if(rules size() == 1) {
			printf("// First rule added is %s, adding us as a leaf to it\n", rule name)
			rule addLeaf(this)
		}
	}

}
