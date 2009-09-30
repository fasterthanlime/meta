// rock imports
import frontend/[TokenType, ListReader, SourceReader, Token]

// meta imports
import ../[Rule, Node]

TokenRule: class extends Rule {
	
	tokenType: Octet
	
	init: func ~withType (.name, =tokenType) {
		super(name)
	}
	
	applyImpl: func (reader: ListReader<Token>, sReader: SourceReader) -> Node {
		
		token := reader read()
		if(token type == tokenType) {
			return Node new(this, token)
		}
		
		return null
		
	}

}
