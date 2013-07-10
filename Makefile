UNAME := $(shell uname)

CPP_FILES := $(wildcard src/*.cpp)
OBJ_FILES := $(addprefix obj/,$(notdir $(CPP_FILES:.cpp=.o)))
BC_FILES := $(addprefix obj/,$(notdir $(CPP_FILES:.cpp=.bc)))

OS_LIB_TARGET = libivy.so
WEB_LIB_TARGET = libivy.js

INCLUDES := -Iinclude/ -Iglm/include/

CC_FLAGS := $(INCLUDES)

#debug
CC_FLAGS += -fPIC -g

LD_FLAGS := -shared -lglfw -std=c++11

CC := $(EMSCRIPTEN_CLANG)/bin/clang++


#emscripten variables
EMCC := $(EMSCRIPTEN_ROOT)/emcc
EMCC_FLAGS := $(INCLUDES) --bind
EMCC_POST := src/post.js
EMLD_FLAGS := -std=c++11 --bind --post-js $(EMCC_POST)

SONAME := -soname
ifeq ($(UNAME), Linux)
 
endif
ifeq ($(UNAME), Darwin)
 LD_FLAGS += -framework Cocoa -framework OpenGL -framework IOKit
 SONAME := -install_name
endif


unix: $(OS_LIB_TARGET)

$(OS_LIB_TARGET): $(OBJ_FILES)
	$(CC) -o $@.1 $^ $(LD_FLAGS) -Wl,$(SONAME),$@ -lc

obj/%.o: src/%.cpp
	$(CC) $(CC_FLAGS) -c -o $@ $<


web: $(WEB_LIB_TARGET)

$(WEB_LIB_TARGET): $(BC_FILES)
	$(EMCC) -o $@ $^ $(EMLD_FLAGS)

obj/%.bc: src/%.cpp
	$(EMCC) $(EMCC_FLAGS) -c -o $@ $<




clean:
	-rm $(OS_LIB_TARGET)* $(WEB_HTML_TARGET) $(OBJ_FILES) $(BC_FILES)



