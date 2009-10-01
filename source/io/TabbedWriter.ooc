TabbedWriter: class {

	stream: FStream
	tabLevel: Int
	tab := "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"

	init: func (=stream) {}
	
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
	
	app: func ~chr (c: Char) {
		stream write(c)
	}
	
	app: func ~str (s: String) {
		stream write(s)
	}
	
	writeTabs: func {
		stream write(tab, 0, tabLevel)
	}
	
	newUntabbedLine: func {
		stream write('\n')
	}
	
	nl: func {
		newUntabbedLine()
		writeTabs()
	}
	
	tab: func {
		tabLevel += 1
	}
	
	untab: func {
		tabLevel -= 1
	}
	
}
