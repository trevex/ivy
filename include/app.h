#ifndef _APP_H_
#define _APP_H_

#include <string>

#define App CApp::instance()

class CApp {
public:
	CApp(void);
	~CApp(void);

	static CApp& instance(void);

	bool initialize(std::string title, int width = 800, int height = 600, bool fullscreen = false);
	bool isRunning(void) const;
	bool run(void);
protected:
private:
	bool m_bRunning;

#ifndef EMSCRIPTEN
    // currently not possible with embind
    CApp(CApp const&);
    void operator=(CApp const&);
#endif
};



#ifdef EMSCRIPTEN
#include <emscripten/bind.h>
using namespace emscripten;

EMSCRIPTEN_BINDINGS(AppSingleton) {
    class_<CApp>("_AppSingleton")
        .function("initialize", &CApp::initialize)
        .function("run", &CApp::run)
        .class_function("instance", &CApp::instance, allow_raw_pointers())
        ;
}
#endif


#endif
