// rock imports
import frontend/Locatable

/**
 * 
 */
Location: class extends Locatable {

	/** Absolute path of the file */
	path: String
	
	start, length: SizeT
	
	init: func(=path, =start, =length) {}
	
	getStart: func -> SizeT { start }
	getLength: func -> SizeT { length }

}
