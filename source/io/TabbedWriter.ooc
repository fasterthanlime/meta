TabbedWriter: class {

	stream: FStream
	tabLevel: int
	String tab = "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"

	TabbedWriter(stream: FStream) {
		this.stream  = stream 
	}
	
	/*
	void close() {
		if(stream  instanceof Writer) {
			((Writer) stream ) close()
		} else {
			// well, do nothing, probably trying
			// to close a StringBuilder, which is
			// nonsense.
		}
	}
	*/
	
	app(c: Char) {
		stream append(c)
		return this
	}
	
	app(s: String) {
		stream write(s)
	}
	
	writeTabs: func {
		stream write(tab, 0, tabLevel)
	}
	
	newUntabbedLine: func {
		stream append('\n')
	}
	
	nl: func {
		newUntabbedLine()
		writeTabs()
	}
	
	tab: func {
		tabLevel++
	}
	
	untab: func {
		tabLevel--
	}
	
}
