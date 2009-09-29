// ooc imports
import structs/ArrayList

// rock imports
import frontend/[ListReader, SourceReader]

// meta imports
import Node

/**
 * Rules define how to join tokens into nodes.
 */
Rule: abstract class {
	
	name: String
	leafs: ArrayList<Rule>
	
	init: func(=name) {}
	
	addLeaf: func (leaf: Rule) {
		if(!leafs) leafs = ArrayList<Rule> new()
		leafs add(leaf)
		printf("Rule %s just got leaf %s\n", name, leaf name)
	}
	
	apply: abstract func (reader: ListReader, sReader: SourceReader) -> Node
	
}
