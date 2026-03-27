default:
	 @echo usage make 'reinstall|clobber|clean'
	 @grep ':$$' Makefile

update reinstall: uninstall install

uninstall:
	-sudo raco pkg remove -i racket-hacks

install:
	su -c  "raco pkg install -i --auto"
	sudo chown -R frayser:conman  .
	find . -type d -exec chmod g+s {} +

reinstall: uninstall install

clean: 
	@echo BACKUP
	@find  . | cpio --quiet -W none -dm -p /var/tmp/Attic/racket-hacks 2>&1 |grep -v newer || true 
	@echo DEL
	@find  . -name "*~" -delete -print

clobber:
	clean
