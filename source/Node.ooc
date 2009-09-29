// rock imports
import frontend/Token

// meta2 imports
import Rule, Location

/**
 * 
 */
Node: class {

	type: Rule
	startToken: Token
	
	init: func (=type, =startToken) {}

}
