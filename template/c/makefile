#########################
#Main Makefile
#########################
MAIN = main.cpp
BUILD_DIR = build
RELEASE_DIR = bin
SCRIPTS_DIR = scripts
SRC_DIR = src
NAME = aox

CCL = g++
CCW32 = i686-w64-mingw32-g++
CCW64 = x86_64-w64-mingw32-g++
LIBSL = -lGL -lX11 -ldl -lpthread -lrt -lz
LIBSW32 = -L/usr/lib/x86_64-linux-gnu/ -lopengl32 -lX11 -ldl -lpthread -lrt -lbgfx-shared-libRelease
LIBSW64 = -L/usr/lib/x86_64-linux-gnu/ -lopengl32 -lX11 -ldl -lpthread -lrt -lbgfx-shared-libRelease

COMMON_INCLUDE_DIR = bgfx/examples
BGFX_INCLUDE_DIR = bgfx/include
BIMG_INCLUDE_DIR = bimg/include
BX_INCLUDE_DIR = bx/include

CFLAGS = -w -g
CFLAGS_O = -w:-g:-c:-I../../$(BGFX_INCLUDE_DIR):-I../../$(BIMG_INCLUDE_DIR):-I../../$(BX_INCLUDE_DIR):-I../../$(COMMON_INCLUDE_DIR)

VALGRIND_EXEC = valgrind --leak-check=full --show-leak-kinds=all
GDB_EXEC = gdb

#Get OS and configure based on OS
ifeq ($(OS),Windows_NT)
    ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
        CFLAGS += -D AMD64
   		DISTRO = windows64
   	else
	    ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
	        CFLAGS += -D AMD64
			DISTRO = windows64
	    endif
	    ifeq ($(PROCESSOR_ARCHITECTURE),x86)
	        CFLAGS += -D IA32 WIN32
			DISTRO = windows32
	    endif
    endif
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        CFLAGS += -D LINUX
   		DISTRO = linux
    endif
    ifeq ($(UNAME_S),Darwin)
        CFLAGS += -D OSX
   		DISTRO = mac
    endif
    ifeq ($(UNAME),Solaris)
   		DISTRO = solaris
    endif
    UNAME_P := $(shell uname -p)
    ifeq ($(UNAME_P),x86_64)
        CFLAGS += -D AMD64
    endif
    ifneq ($(filter %86,$(UNAME_P)),)
        CFLAGS += -D IA32
    endif
    ifneq ($(filter arm%,$(UNAME_P)),)
        CFLAGS += -D ARM
    endif
endif

CC =
LIBS =
EXT = -$(DISTRO)


#########################
#OS independent building
#########################
.PHONY: run main setup objects executable

#: Runs build made targeting host system
run: main
	@cd ./$(RELEASE_DIR)/$(DISTRO) && ./$(NAME)$(EXT)

#: Builds targeting host system
main: $(DISTRO) objects executable

setup:
	@echo -e making for `tput bold`$(DISTRO)`tput sgr0`... | awk '{sub(/-e /,""); print}'
	$(eval ifeq ($(DISTRO),windows64) $(newline)\
		LIBS = $(LIBSW64) $(newline)\
		CC = $(CCW64) $(newline)\
	endif $(newline)\
	ifeq ($(DISTRO),windows32) $(newline)\
		LIBS = $(LIBSW32) $(newline)\
		CC = $(CCW32) $(newline)\
	endif $(newline)\
	ifeq ($(DISTRO),linux) $(newline)\
		LIBS = $(LIBSL) $(newline)\
		CC = $(CCL) $(newline)\
	endif)

objects: setup
	@echo -e '\t'Compiling object code... | awk '{sub(/-e /,""); print}'
	@mkdir -p $(BUILD_DIR)/$(DISTRO)
	@cd $(BUILD_DIR)/$(DISTRO) && ../../$(SCRIPTS_DIR)/includes.sh ../../$(SRC_DIR)/$(MAIN) $(CC) $(CFLAGS_O)
	@echo -e '\t'Done Compiling | awk '{sub(/-e /,""); print}'
	@mkdir -p $(RELEASE_DIR)/$(DISTRO)

executable: setup
	@rm -f $(BUILD_DIR)/$(DISTRO)/bgfx_utils.o 2>/dev/null || :
	@echo -e $(NAME)$(EXT) "\n" $(BUILD_DIR) "\n" $(RELEASE_DIR)/$(DISTRO) "\n" $(CC) "\n" $(CFLAGS) "\n" $(LIBS) "\n" $(DISTRO) "\n" | awk '{sub(/-e /,""); print}' > assemble.txt
	@$(SCRIPTS_DIR)/assemble.sh < assemble.txt
	@$(MAKE) -f assemble.mk --no-print-directory | grep -vE "(Nothing to be done for|is up to date)" || :
	@rm -f assemble.txt 2>/dev/null || :
	@rm -f assemble.mk 2>/dev/null || :

#########################
#Specific OS building
#########################
.PHONY: all \
	linux linux-var \
	mac mac-var \
	solaris solaris-var \
	windows32 windows32-var \
	windows64 windows64-var \
	ios-ar ios-var \
	wasm wasm-var \
	freebsd64 freebsd64-var

#: Builds for linux
linux: linux-var main
linux-var:
	@$(eval DISTRO = linux)
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

#: Builds for mac
mac: mac-var main
mac-var:
	@$(eval DISTRO = mac)
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

#: Builds for solaris
solaris: solaris-var main
solaris-var:
	@$(eval DISTRO = solaris)
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

#: Builds for windows32
windows32: windows32-var main
windows32-var:
	$(eval DISTRO = windows32)
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

#: Builds for windows64
windows64: windows64-var main
windows64-var:
	$(eval DISTRO = windows64)
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

#: Builds for android-arm
android-arm: android-arm-var main
android-arm-var:
	$(eval DISTRO = android-arm)
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

#: Builds for ios-arm
ios-arm: ios-arm-var main
ios-var:
	$(eval DISTRO = ios-arm)
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

#: Builds for wasm
wasm: wasm-var main
wasm-var:
	$(eval DISTRO = wasm)
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

#: Builds for freebsd64
freebsd64: freebsd64-var main
freebsd64-var:
	$(eval DISTRO = freebsd64)
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

#: Builds for all supported systems
all: linux mac windows32 windows64 wasm freebsd64

#########################
#Utility functions
#########################
.PHONY: help valgrind gdb clean

#: Lists available commands
help:
	@echo "Available Commands for project:"
	@grep -B1 -E "^[a-zA-Z0-9_-]+\:([^\=]|$$)" Makefile \
	 | grep -v -- -- \
	 | sed 'N;s/\n/###/' \
	 | sed -n 's/^#: \(.*\)###\(.*\):.*/\2###\1/p' \
	 | column -t  -s '###'

#: Runs executable with valgrind
valgrind: main
	@cd ./$(RELEASE_DIR)/$(DISTRO) && $(VALGRIND_EXEC) ./$(NAME)$(EXT)

#: Runs executable with gdb
gdb: main
	@cd ./$(RELEASE_DIR)/$(DISTRO) && $(GDB_EXEC) ./$(NAME)$(EXT)

#: Cleans project repo
clean:
	@echo Cleaning... | awk '{sub(/-e /,""); print}'
	@rm -rf $(BUILD_DIR) 2>/dev/null || :
	@rm -rf $(RELEASE_DIR) 2>/dev/null || :
	@echo Done cleaning | awk '{sub(/-e /,""); print}'
