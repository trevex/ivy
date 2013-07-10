#ifndef _RENDERER_H_
#define _RENDERER_H_

#include <GL/glfw.h>

#define Renderer CRenderer::instance()

class CRenderer {
public:
	CRenderer(void);
	~CRenderer(void);

	static CRenderer& instance(void);

	bool initialize(void);
	void resize(float width, float height);
	void render(void);
	void resetViewport(void);
    void setClearColor(GLclampf r, GLclampf g, GLclampf b, GLclampf a);
protected:
private:

	GLsizei m_width;
	GLsizei m_height;

    CRenderer(CRenderer const&);
    void operator=(CRenderer const&);

};

#endif
