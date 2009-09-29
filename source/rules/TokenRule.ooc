// rock imports
import frontend/[TokenType, ListReader, SourceReader, Token]

// meta imports
import ../[Rule, Node]

TokenRule: class extends Rule {
	
	tokenType: Octet
	
	init: func ~withType (.name, =tokenType) {
		super(name)
	}
	
	apply: func (reader: ListReader<Token>, sReader: SourceReader) -> Node {
		
		token := reader read()
		if(token type == tokenType) {
			printf("Matched token rule for %s\n", TokenType strings[tokenType])
			return Node new(this, token)
		}
		printf("Too bad, the token's a %s not a %s\n", token toString(), TokenType strings[tokenType])
		
		return null
		
	}

}
