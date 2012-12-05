
VALAC = valac
LIBS      := gee-1.0 gudev-1.0
VALAONLYLIBS := posix
VALALIBS  := $(patsubst %, --pkg %, $(LIBS) $(VALAONLYLIBS))
VFLAGS = -g
SOURCES = ueatadick.vala
BINARY = ueatadick

all: $(BINARY)

version.vala: .
	echo "static const string HgVersion = \"$$(hg id -bnit)\";" > version.vala
$(BINARY): $(SOURCES)
	$(VALAC) $(VFLAGS) $(VALALIBS) -o $@ $^

cfiles: $(SOURCES) 
	$(VALAC) $(VFLAGS) $(VALALIBS) -C $^
	mkdir -p cfiles
	mv *.c cfiles/
	cd cfiles
	echo 'LIBS := `pkg-config --libs $(LIBS)`' > cfiles/Makefile
	echo 'CFLAGS := `pkg-config --cflags $(LIBS)`' >> cfiles/Makefile
	echo "$(BINARY): $(subst vala,c,$^)" >> cfiles/Makefile
	echo '	$$(CC) -o $(BINARY) $$(LIBS) $$(CFLAGS) $$^' >> cfiles/Makefile

.PHONY: cfiles
