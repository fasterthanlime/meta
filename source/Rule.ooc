// ooc imports
import frontend/SourceReader

// meta2 imports
import Node

/**
 * Rules define how to join tokens into nodes.
 */
Rule: abstract class {
	
	name: String
	parent: Rule
	
	init: func(=name, =parent) {}
	
	parse: abstract func (sr: SourceReader) -> Node
	
}
