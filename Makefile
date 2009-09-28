TESTFILE=source/Lexer.ooc
GDBCOMMANDS_PATH=/tmp/gdbcommands
.PHONY:all clean mrproper

all:
	ooc meta -sourcepath=source/:../rock/source/ -g ${OOC_FLAGS}

test:
	make all && ./meta ${TESTFILE}

debug:
	echo run ${TESTFILE} >> ${GDBCOMMANDS_PATH} && gdb ./meta -command=${GDBCOMMANDS_PATH} && rm ${GDBCOMMANDS_PATH}

clean:
	rm -rf ooc_tmp/

mrproper: clean
	rm -rf ./meta
