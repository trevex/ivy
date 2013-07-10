#include <iostream>
#include <memory>
#include <GL/glfw.h>

#include "app.h"
#include "renderer.h"

void GLFWCALL resize(int, int);

CApp::CApp(void) : m_bRunning(true) {
	
}

CApp::~CApp(void) {
	// Close window and terminate GLFW
	glfwTerminate();
}

CApp& CApp::instance(void) {
	static CApp app;
    return app;
}

bool CApp::initialize(std::string title, int width, int height, bool fullscreen) {
	// Try to initialize OpenGL
	if (!glfwInit()) {
		std::cout << "Unable to initialize OpenGL!" << std::endl;
		return false;
	}
	// Setup GLFW Profile
	glfwOpenWindowHint(GLFW_OPENGL_VERSION_MAJOR, 2);
	glfwOpenWindowHint(GLFW_OPENGL_VERSION_MINOR, 1);
	// Try to open the window
	int mode = fullscreen ? GLFW_FULLSCREEN : GLFW_WINDOW;
	if (!glfwOpenWindow(width, height, 0, 0, 0, 0, 32, 0, mode))	{
		std::cout << "Unable to open window!" << std::endl;
		glfwTerminate();
		return false;
	}
	glfwSetWindowTitle(title.c_str());
	// Enable sticky keys for capturing
	glfwEnable(GLFW_STICKY_KEYS);
	// Try to initialize the Renderer
	if (!Renderer.initialize()) {
		std::cout << "Unable to initialize Renderer!" << std::endl;
		glfwTerminate();
		return false;
	}


	// Callbacks
	glfwSetWindowSizeCallback(resize);

	return true;
}

bool CApp::isRunning(void) const {
	return m_bRunning;
}

bool CApp::run(void) {
	// Check if ESC key was pressed or window was closed
	m_bRunning = !glfwGetKey(GLFW_KEY_ESC) && glfwGetWindowParam(GLFW_OPENED);
	Renderer.render();
	return m_bRunning;
}

void GLFWCALL resize(int width, int height)
{
	if (height == 0) height=1;
	Renderer.resize((float)width, (float)height);
}
