UNAME := $(shell uname)

CPP_FILES := $(wildcard src/*.cpp)
OBJ_FILES := $(addprefix obj/,$(notdir $(CPP_FILES:.cpp=.o)))
BC_FILES := $(addprefix obj/,$(notdir $(CPP_FILES:.cpp=.bc)))

EXECUTABLE = ivy
WEB_HTML_TARGET = ivy.html

INCLUDES := -Iinclude/ -Iglm/include/

CC_FLAGS := $(INCLUDES)

#debug
CC_FLAGS += -g

LD_FLAGS := -lglfw -std=c++11

CC := $(EMSCRIPTEN_CLANG)/bin/clang++


#emscripten variables
EMCC := $(EMSCRIPTEN_ROOT)/emcc
EMCC_FLAGS := $(INCLUDES)
EMLD_FLAGS := -std=c++11


ifeq ($(UNAME), Linux)
 
endif
ifeq ($(UNAME), Darwin)
 LD_FLAGS += -framework Cocoa -framework OpenGL -framework IOKit
endif


unix: $(EXECUTABLE)

$(EXECUTABLE): $(OBJ_FILES)
	$(CC) -o $@ $^ $(LD_FLAGS) 

obj/%.o: src/%.cpp
	$(CC) $(CC_FLAGS) -c -o $@ $<


web: $(WEB_HTML_TARGET)

$(WEB_HTML_TARGET): $(BC_FILES)
	$(EMCC) -o $@ $^ $(EMLD_FLAGS)

obj/%.bc: src/%.cpp
	$(EMCC) $(EMCC_FLAGS) -c -o $@ $<




clean:
		-rm $(EXECUTABLE) $(WEB_HTML_TARGET) $(OBJ_FILES) $(BC_FILES)



