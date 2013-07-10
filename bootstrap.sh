#!/bin/sh

ASSIMP_DIR="assimp/"
EMBUILD_DIR="embuild/"
OSBUILD_DIR="osbuild/"

GLFW_DIR="glfw/"
GLM_DIR="glm/"

LIB_INSTALL=0

# Parsing options...
while getopts ":i" opt; do
	case $opt in
		i)
            echo "-i set, libraries will be installed (sudo)!" >&2
			LIB_INSTALL=1
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			;;
	esac
done

# Sorting platform dependent variables
GLFW_MAKE=""
GLFW_INSTALL="install"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    GLFW_INSTALL="x11-dist-install"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    GLFW_MAKE="cocoa"
    GLFW_INSTALL="cocoa-install"
fi

if [ -z "$EMSCRIPTEN_ROOT" ]; then
	echo "Error: EMSCRIPTEN_ROOT not set!"
	exit 1;
fi

# Check assimp dir, if it does not exist, get it...
if [ ! -d "$ASSIMP_DIR" ]; then
	echo "Cloning libassimp into $ASSIMP_DIR ..."
	git clone https://github.com/assimp/assimp assimp
else 
	echo "$ASSIMP_DIR already exists."
fi

# Check emscripten build
if [ ! -d "$ASSIMP_DIR$EMBUILD_DIR" ]; then
	echo "Creating $ASSIMP_DIR$EMBUILD_DIR and compiling libassimp for emscripten."
	mkdir "$ASSIMP_DIR$EMBUILD_DIR"
	cd "$ASSIMP_DIR$EMBUILD_DIR"
	cmake -DEMSCRIPTEN=1 -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN_ROOT/cmake/Platform/Emscripten_unix.cmake -DCMAKE_MODULE_PATH=$EMSCRIPTEN_ROOT/cmake -DASSIMP_ENABLE_BOOST_WORKAROUND=1 -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ..
	make
	mv code/libassimp.so code/libassimp.bc
	cd ../..
else
	echo "$ASSIMP_DIR$EMBUILD_DIR already exists."
fi

# Install libraries
if [ $LIB_INSTALL -eq 1 ]; then
    # Check OS-specific build directory
    if [ ! -d "$ASSIMP_DIR$OSBUILD_DIR" ]; then
    	echo "Creating $ASSIMP_DIR$OSBUILD_DIR and compiling libassimp for OS."
    	mkdir "$ASSIMP_DIR$OSBUILD_DIR"
    	cd "$ASSIMP_DIR$OSBUILD_DIR"
    	cmake -DASSIMP_ENABLE_BOOST_WORKAROUND=1 -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ..
    	make
        # Install libassimp
    	echo "Installing libassimp..."
    	sudo make install
	    cd ../..
    else
	    echo "$ASSIMP_DIR$OSBUILD_DIR already exists."
    fi 
    # Check GLFW
    if [ ! -d "$GLFW_DIR" ]; then
        echo "Downloading, compiling and installing GLFW."
        curl -L http://sourceforge.net/projects/glfw/files/glfw/2.7.9/glfw-2.7.9.tar.bz2/download > glfw-2.7.9.tar.bz2
        tar -jxvf glfw-2.7.9.tar.bz2
        mv glfw-2.7.9/ $GLFW_DIR
        rm glfw-2.7.9.tar.bz2
        cd $GLFW_DIR    
        make $GLFW_MAKE
        sudo make $GLFW_INSTALL
    else
        echo "$GLFW_DIR already exists."
    fi
    # Check GLM
    if [ ! -d "$GLM_DIR" ]; then
        echo "Downloading and preparing GLM."
        curl -L https://sourceforge.net/projects/ogl-math/files/glm-0.9.4.4/glm-0.9.4.4.zip/download > glm-0.9.4.4.zip
        unzip glm-0.9.4.4.zip
        rm glm-0.9.4.4.zipv
        mv glm-0.9.4.4/ $GLM_DIR
        mkdir $GLM_DIR/include
        mv $GLM_DIR/glm/ $GLM_DIR/include/glm/
    else
        echo "$GLM_DIR already exists."
    fi
fi
