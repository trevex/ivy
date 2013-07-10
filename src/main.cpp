#include <iostream>
#include <stdlib.h>

#include "app.h"
#include "camera.h"

#ifdef EMSCRIPTEN
#include <emscripten.h>
#endif


void frame() {

}

int main( void )
{
	std::cout << "Cross platform OpenGL/WebGL Test!" << std::endl << std::endl;

	if (!App.initialize("test")) {
		exit(EXIT_FAILURE);
	}
    
	// Main loop
#ifdef EMSCRIPTEN
    emscripten_set_main_loop(frame, 60, true);
#else
	while (App.run()) {
        frame();		
	}
#endif

	exit(EXIT_SUCCESS);
}
