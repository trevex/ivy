#include <memory>

#include "renderer.h"
#include "camera.h"

CRenderer::CRenderer(void) : m_width(800), m_height(600) {

}

CRenderer::~CRenderer(void) {

}

CRenderer& CRenderer::instance(void) {
	static CRenderer renderer;
    return renderer;
}

bool CRenderer::initialize(void) {
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LESS);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); 

	return true;
}

void CRenderer::setClearColor(GLclampf r, GLclampf g, GLclampf b, GLclampf a) {
    glClearColor(r, g, b, a);
}
     

void CRenderer::resize(float width, float height) {
	m_width = width;
	m_height = height;
	glViewport(0, 0, width, height);
	Camera.setAspect(width / height);
}

void CRenderer::render(void) {
#ifndef EMSCRIPTEN
    // Is not implemented in emscripten library
	glfwSwapBuffers();
#endif
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}


void CRenderer::resetViewport(void) {	
	glViewport(0, 0, m_width, m_height);
}

