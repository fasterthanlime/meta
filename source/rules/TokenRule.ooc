import frontend/SourceReader
import ../Lexer

TokenRule: class extends MetaNode {
	
	string : String
	
	parse: abstract func 

}
