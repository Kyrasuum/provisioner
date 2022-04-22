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

define newline


endef

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
BGFX_BUILD_DIR =

.PHONY: detect main all help fix run valgrind gdb clean objects executable setup \
linux linux-bgfx linux-var \
mac-var mac-bgfx mac-var \
solaris solaris-bgfx solaris-var \
windows32 windows32-bgfx windows32-var \
windows64 windows64-bgfx windows64-var \
freebsd64 freebsd64-var freebsd64-bgfx \
wasm wasm-var wasm-bgfx main \
ios-arm ios-arm-var ios-arm-bgfx main \
android-arm android-arm-var android-arm-bgfx main

#########################
#OS independent building
#########################
main: $(DISTRO) objects executable

setup:
	@echo -e making for `tput bold`$(DISTRO)`tput sgr0`... | awk '{sub(/-e /,""); print}'
	$(eval ifeq ($(DISTRO),windows64) $(newline)\
		LIBS = $(LIBSW64) $(newline)\
		CC = $(CCW64) $(newline)\
		BGFX_BUILD_DIR = bgfx/.build/win32_mingw-gcc/bin/*.a$(newline)\
	endif $(newline)\
	ifeq ($(DISTRO),windows32) $(newline)\
		LIBS = $(LIBSW32) $(newline)\
		CC = $(CCW32) $(newline)\
		BGFX_BUILD_DIR = bgfx/.build/win64_mingw-gcc/bin/*.a$(newline)\
	endif $(newline)\
	ifeq ($(DISTRO),linux) $(newline)\
		LIBS = $(LIBSL) $(newline)\
		CC = $(CCL) $(newline)\
		BGFX_BUILD_DIR = bgfx/.build/linux64_gcc/bin/*.a$(newline)\
	endif)

objects: setup
	@echo -e '\t'Compiling object code... | awk '{sub(/-e /,""); print}'
	@mkdir -p $(BUILD_DIR)/$(DISTRO)
	@cd $(BUILD_DIR)/$(DISTRO) && ../../$(SCRIPTS_DIR)/includes.sh ../../$(SRC_DIR)/$(MAIN) $(CC) $(CFLAGS_O)
	@echo -e '\t'Done Compiling | awk '{sub(/-e /,""); print}'
	@mkdir -p $(RELEASE_DIR)/$(DISTRO)

executable: setup
	@rm -f $(BUILD_DIR)/$(DISTRO)/bgfx_utils.o 2>/dev/null || :
	@echo -e $(NAME)$(EXT) "\n" $(BUILD_DIR) "\n" $(RELEASE_DIR)/$(DISTRO) "\n" $(CC) "\n" $(CFLAGS) "\n" $(BGFX_BUILD_DIR) "\n" $(LIBS) "\n" $(DISTRO) "\n" | awk '{sub(/-e /,""); print}' > assemble.txt
	@$(SCRIPTS_DIR)/assemble.sh < assemble.txt
	@$(MAKE) -f assemble.mk --no-print-directory | grep -vE "(Nothing to be done for|is up to date)" || :
	@rm -f assemble.txt 2>/dev/null || :
	@rm -f assemble.mk 2>/dev/null || :

#########################
#Specific OS building
#########################
linux: linux-var linux-bgfx main

linux-var:
	$(eval DISTRO = linux)

linux-bgfx:
	@$(MAKE) -C bgfx --no-print-directory linux-release64
	@mkdir -p $(BUILD_DIR)/$(DISTRO)
	@find bgfx/.build/linux64_gcc/obj/x64/Release/example-common -type f -name '*.o' -exec cp -at $(BUILD_DIR)/$(DISTRO)/ {} + 2>/dev/null || :

mac: mac-var mac-bgfx main

mac-var:
	$(eval DISTRO = mac)

mac-bgfx:
	@$(MAKE) -C bgfx --no-print-directory osx-x64-release64
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

solaris: solaris-var solaris-bgfx main

solaris-var:
	$(eval DISTRO = solaris)

solaris-bgfx:
	@$(MAKE) -C bgfx --no-print-directory linux-release64
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

windows32: windows32-var windows32-bgfx main

windows32-var:
	$(eval DISTRO = windows32)

windows32-bgfx:
	@$(MAKE) -C bgfx --no-print-directory mingw-gcc-release32
	@mkdir -p $(BUILD_DIR)/$(DISTRO)
	@find bgfx/.build/win64_mingw-gcc/obj/x64/Release/example-common -type f -name '*.o' -exec cp -at $(BUILD_DIR)/$(DISTRO)/ {} +

windows64: windows64-var windows64-bgfx main

windows64-var:
	$(eval DISTRO = windows64)

windows64-bgfx:
	@$(MAKE) -C bgfx --no-print-directory mingw-gcc-release64
	@mkdir -p $(BUILD_DIR)/$(DISTRO)
	@find bgfx/.build/win64_mingw-gcc/obj/x64/Release/example-common -type f -name '*.o' -exec cp -at $(BUILD_DIR)/$(DISTRO)/ {} +

android-arm: android-arm-var android-arm-bgfx main

android-arm-var:
	$(eval DISTRO = android-arm)

android-arm-bgfx:
	@$(MAKE) -C bgfx --no-print-directory android-arm-release
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

ios-arm: ios-arm-var ios-arm-bgfx main

ios-var:
	$(eval DISTRO = ios-arm)

ios-bgfx:
	@$(MAKE) -C bgfx --no-print-directory ios-arm-release
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

wasm: wasm-var wasm-bgfx main

wasm-var:
	$(eval DISTRO = wasm)

wasm-bgfx:
	@$(MAKE) -C bgfx --no-print-directory wasm-release
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

freebsd64: freebsd64-var freebsd64-bgfx main

freebsd64-var:
	$(eval DISTRO = freebsd64)

freebsd64-bgfx:
	@$(MAKE) -C bgfx --no-print-directory freebsd-release64
	@mkdir -p $(BUILD_DIR)/$(DISTRO)

all:
	@$(MAKE) linux --no-print-directory
	@$(MAKE) windows32 --no-print-directory
	@$(MAKE) windows64 --no-print-directory

#########################
#Utility functions
#########################
help:
	@echo -e "Available build targets:\
\n\t`tput bold`Command;Description`tput sgr0`\
\n\tmain;Build for detected operating system\
\n\tall;Build for all currently supported operating systems\
\n\tobjects;Build only objects for detected operating system\
\n\texecutable;Build only executable for detected operating system\
\n\tlinux;Build for linux\
\n\tmac;Build for mac\
\n\tsolaris;Build for solaris\
\n\twindows32;Build for Windows 32 bit\
\n\twindows64;Build for windows 64 bit\
\n\tandroid-arm;Build for android arm\
\n\tios-arm;Build for ios arm\
\n\twasm;Build for wasm\
\n\tfreebsd64;Build for freebsd 64 bit\
\n\trun;Run for detected operating system\
\n\tvalgrind;Run with valgrind for detecting memory leaks\
\n\tgdb;Run with GDB for debugging purposes\
\n\tclean;Remove build directories and release executable\
\n\tfix;Replaces spaces with tabs in source files\
\n\thelp;Print availabe commands" | awk '{sub(/-e /,""); print}' | column -t -s ';'

run: main
	@cd ./$(RELEASE_DIR)/$(DISTRO) && ./$(NAME)$(EXT)

valgrind: main
	@cd ./$(RELEASE_DIR)/$(DISTRO) && $(VALGRIND_EXEC) ./$(NAME)$(EXT)

gdb: main
	@cd ./$(RELEASE_DIR)/$(DISTRO) && $(GDB_EXEC) ./$(NAME)$(EXT)

clean:
	@echo Cleaning... | awk '{sub(/-e /,""); print}'
	@rm -rf $(BUILD_DIR) 2>/dev/null || :
	@rm -rf $(RELEASE_DIR) 2>/dev/null || :
	@echo Done cleaning | awk '{sub(/-e /,""); print}'

fix:
	@echo Replacing spaces with tabs in source files | awk '{sub(/-e /,""); print}'
	@./scripts/fix.sh src
#EOF
