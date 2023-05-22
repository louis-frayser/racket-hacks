default:
	 @echo usage make 'reinstall|clobber|clean'
	 @grep ':$$' Makefile

update reinstall: uninstall install

uninstall:
	raco pkg remove racket-hacks

install:
	raco pkg install

clean: 
	@echo BACKUP
	@find  . | cpio -W none -vdm -p /var/tmp/Attic/racket-hacks
	@echo DEL
	@find  . -name "*~" -delete -print

clobber:
	clean
