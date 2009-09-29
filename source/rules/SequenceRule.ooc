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
	
	apply: func (reader: ListReader<Token>, sReader: SourceReader) -> Node {
		
		if(!rules) return null
		
		n : Node = null
		i := 0
		for(rule: Rule in rules) {
			i += 1
			n = rule apply(reader, sReader)
			if(n) {
				printf("Matched sub-rule %i, continuing..\n", i)
			} else {
				printf("Broke at sub-rule %i, abandoning...\n", i)
				break
			}
		}
		
		return n
		
	}
	
	addRule: func (rule: Rule) {
		if(rules == null) rules = ArrayList<Rule> new()
		rules add(rule)
		if(rules size() == 1) {
			printf("First rule added is %s, adding us as a leaf to it\n", rule name)
			rule addLeaf(this)
		}
	}

}
