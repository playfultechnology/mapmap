CONFIG += qt
CONFIG += debug
CONFIG += c++11

TEMPLATE = app

# Always use major.minor.micro version number format
VERSION = 0.6.4
TARGET = mapmap

DEFINES += UNICODE QT_THREAD_SUPPORT QT_CORE_LIB QT_GUI_LIB QT_MESSAGELOGCONTEXT

win32:msvc {
    # Make Windows headers less invasive
    DEFINES += WIN32_LEAN_AND_MEAN NOMINMAX

    # Ensure the "right" APIENTRY/WINGDIAPI definitions are used before GL headers
    # This forces windows.h to be included very early in every translation unit.
    QMAKE_CXXFLAGS += /FIwindows.h

    QT += opengl

    GST_ROOT = C:/Program Files/gstreamer/1.0/msvc_x86_64

    GSTREAMER_1_0_ROOT_X86 = $$GST_ROOT
    GSTREAMER_1_0_ROOT_X86_64 = $$GST_ROOT
    export(GSTREAMER_1_0_ROOT_X86)
    export(GSTREAMER_1_0_ROOT_X86_64)

    # Headers (do NOT $$quote() INCLUDEPATH entries for MSVC)
    INCLUDEPATH += \
    $$shell_path($$GST_ROOT/include/gstreamer-1.0) \
    $$shell_path($$GST_ROOT/include/glib-2.0) \
    $$shell_path($$GST_ROOT/lib/glib-2.0/include)


    # Libraries (quote -L path because of the space in "Program Files")
    GST_LIB = $$GST_ROOT/lib
    LIBS += /LIBPATH:$$system_quote($$GST_LIB)
    LIBS += \
        $$system_quote($$GST_LIB/gstreamer-1.0.lib) \
        $$system_quote($$GST_LIB/gstapp-1.0.lib) \
        $$system_quote($$GST_LIB/gobject-2.0.lib) \
        $$system_quote($$GST_LIB/glib-2.0.lib) \
        -lopengl32

    # (Optional but often needed) Ensure plugins can be found when running from Qt Creator
    QMAKE_POST_LINK += set "GST_PLUGIN_PATH=$$GST_ROOT/lib/gstreamer-1.0"$$escape_expand(\\n\\t)
    QMAKE_POST_LINK += set "PATH=$$GST_ROOT/bin;%PATH%"$$escape_expand(\\n\\t)

    message("Using GStreamer from: $$GST_ROOT")
}


include(src/core/core.pri)
include(src/shape/shape.pri)
include(src/gui/gui.pri)
include(src/control/control.pri)
include(src/app/app.pri)

TRANSLATIONS += \
    translations/mapmap_en.ts \
    translations/mapmap_es.ts \
    translations/mapmap_fr.ts \
    translations/mapmap_zh_CN.ts \
    translations/mapmap_zh_TW.ts

RESOURCES = \
    main.qrc \
    translations/translation.qrc \
    docs/documentation.qrc \
    resources/interface.qrc \
    main.qrc # Main resource file

# Manage lrelease (for translations)
isEmpty(QMAKE_LRELEASE) {
    win32: {
        QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\lrelease.exe
    }
    !win32:
        QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
}
updateqm.input = TRANSLATIONS
updateqm.output = ${QMAKE_FILE_PATH}/${QMAKE_FILE_BASE}.qm
updateqm.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_PATH}/${QMAKE_FILE_BASE}.qm
updateqm.CONFIG += no_link
QMAKE_EXTRA_COMPILERS += updateqm
PRE_TARGETDEPS += compiler_updateqm_make_all
system($$QMAKE_LRELEASE mapmap.pro) # Run lrelease

## Add the docs target:
#docs.depends = $(HEADERS) $(SOURCES)
#docs.commands = (cat Doxyfile; echo "INPUT = $?") | doxygen -
#QMAKE_EXTRA_TARGETS += docs

# Linux-specific:
unix:!macx {
    QMAKE_CXXFLAGS += -D_GLIBCXX_USE_CXX11_ABI=0
    QMAKE_CXXFLAGS += -Wno-expansion-to-defined
}

CONFIG -= qtquickcompiler

unix:macx {
    CONFIG += sdk_no_version_check
}

# Adds the tarball target
tarball.target = mapmap-$${VERSION}.tar.gz
tarball.commands = git archive --format=tar.gz -9 --prefix=mapmap-$${VERSION}/ --output=mapmap-$${VERSION}.tar.gz HEAD
tarball.depends = .git
QMAKE_EXTRA_TARGETS += tarball

# Show various messages
message("MapMap version: $${VERSION}")
# message("Qt version: $$[QT_VERSION]")
# message("LIBS: $${LIBS}")
# message("PKGCONFIG: $${PKGCONFIG}")
# message("The project contains the following files: $${SOURCES} $${HEADERS}}")
# message("To create a tarball, run `make tarball`")
# message("To build the documentation, run `make docs`")
