.PHONY:all clean mrproper

all:
	ooc meta -sourcepath=source/:../rock/source/ -g ${OOC_FLAGS}

test:
	make all && ./meta

clean:
	rm -rf ooc_tmp/

mrproper: clean
	rm -rf ./meta
