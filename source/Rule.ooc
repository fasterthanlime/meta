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
	//root := false
	root := true
	
	init: func(=name) {}
	
	addLeaf: func (leaf: Rule) {
		if(!leafs) leafs = ArrayList<Rule> new()
		leafs add(leaf)
		leaf root = false
		printf("// Rule <%s> just got leaf %s\n", name, leaf name)
	}
	
	/**
	 * Most rules have to be 'built'. e.g. SequenceTokens etc. have to add themselves
	 * as Leafs to their first nodes, etc. this is the opportunity to do so,
	 * because at this time, the rule tree is fixed
	 */
	build: func {}
	
	apply: func (reader: ListReader, sReader: SourceReader) -> Node {
		node := applyImpl(reader, sReader)
		if(!node) return null
		
		return node
	}
	
	applyImpl: abstract func (reader: ListReader, sReader: SourceReader) -> Node
	
	subApply: func (reader: ListReader, sReader: SourceReader, node: Node) -> Node {
		return subApplyImpl(reader, sReader, node)
	}
	
	subApplyImpl: func (reader: ListReader, sReader: SourceReader, node: Node) -> Node {
		return null
	}
	
	/**
	 * Root nodes are nodes the Lexer should begin with when parsing
	 * GroupRules or SequenceRules, for example, aren't root nodes
	 */
	isRoot: func -> Bool { root }
	
}
