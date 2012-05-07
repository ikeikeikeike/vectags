#
# vectags Makefile
#

DICT_DEV_FOLDER = ./src

DESTINATION_FOLDER = /usr/local/lib
DESTINATION_BIN_FOLDER = /usr/local/bin

CD = cd
RM = /bin/rm -f
CP = /bin/cp
LN = /bin/ln
LS = /bin/ls
ECHO = /bin/echo
MKDIR = /bin/mkdir -p
INSTALL = install

all:
	$(MKDIR) $(DICT_DEV_FOLDER)
	$(CP) -r lib $(DICT_DEV_FOLDER)
	$(CP) -r bin $(DICT_DEV_FOLDER)

	BASEPATH=`pwd`;\
	for i in `$(CD) $(DICT_DEV_FOLDER)/lib/vetags/lang; \ls`;\
	do\
		cd $$BASEPATH/$(DICT_DEV_FOLDER)/lib/vetags/lang/$$i;\
		FILENAME=`\ls createtags-$$i*`;\
		ln -s $$FILENAME `basename $$FILENAME | cut -d "." -f 1`;\
	done
	$(ECHO)	"Done."

install:
	$(MKDIR) $(DESTINATION_FOLDER)
	$(ECHO) "Installing into $(DESTINATION_BIN_FOLDER)"
	$(INSTALL) -d $(DESTINATION_BIN_FOLDER)
	$(INSTALL) -m 755 $(DICT_DEV_FOLDER)/bin/vetags $(DESTINATION_BIN_FOLDER)
	$(ECHO)	"Installing into $(DESTINATION_FOLDER)"
	$(INSTALL) -d $(DESTINATION_FOLDER)
	$(CP) -r $(DICT_DEV_FOLDER)/lib/vetags $(DESTINATION_FOLDER)
	$(ECHO)	"Done."

uninstall:
	$(RM) -r $(DESTINATION_FOLDER)/vetags
	$(RM) $(DESTINATION_BIN_FOLDER)/vetags
	$(ECHO)	"Done."

clean:
	$(RM) -r $(DICT_DEV_FOLDER)
	$(ECHO)	"Done."


.PHONY:	all	install	uninstall clean
