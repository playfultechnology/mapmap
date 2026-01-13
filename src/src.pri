QT += gui
QT += opengl
QT += xml
QT += core
QT += network
QT += multimedia

greaterThan(QT_MAJOR_VERSION, 4) {
  QT -= gui # using widgets instead gui in Qt5
  QT += widgets webenginewidgets
}

DEFINES += QOSC_STATIC


#Includes common configuration for all subdirectory .pro files.
INCLUDEPATH += $$PWD/core \
    $$PWD/shape \
    $$PWD/gui \
    $$PWD/control \
    $$PWD/app

#Linux-specific:
unix:!macx {
  DEFINES += UNIX
  CONFIG += link_pkgconfig
  INCLUDE_PATH +=
  PKGCONFIG += \
    gstreamer-1.0 gstreamer-base-1.0 gstreamer-app-1.0 gstreamer-pbutils-1.0 \
    gl x11
  QMAKE_CXXFLAGS_WARN_ON += -Wno-unused-result -Wno-unused-parameter \
                            -Wno-unused-variable -Wno-switch -Wno-comment \
                            -Wno-unused-but-set-variable
}

# macOS-specific:
macx {
  TARGET = MapMap
  DEFINES += MACOSX
  QMAKE_CXXFLAGS += -D__MACOSX_CORE__
  QMAKE_CXXFLAGS += -stdlib=libc++
  INCLUDEPATH += /Library/Frameworks/GStreamer.framework/Versions/1.0/Headers
  LIBS += -F /Library/Frameworks/ -framework GStreamer
  LIBS += -framework OpenGL -framework GLUT
  # With Xcode Tools > 1.5, to reduce the size of your binary even more:
  # LIBS += -dead_strip
  # This tells qmake not to put the executable inside a bundle.
  # just for reference. Do not uncomment.
  # CONFIG-=app_bundle
  ICON = resources/app_icons/mapmap.icns
}


# Windows-specific:
win32 {
  DEFINES += WIN32
  TARGET = ../../../MapMap/MapMap # Just for release
  # Hard-set the path here (no env vars)
  GST_HOME = C:/Program Files/gstreamer/1.0/msvc_x86_64
  GST_LIB  = $$GST_HOME/lib

  INCLUDEPATH += \
    $$shell_path($$GST_HOME/include/gstreamer-1.0) \
    $$shell_path($$GST_HOME/include/glib-2.0) \
    $$shell_path($$GST_LIB/glib-2.0/include)

  LIBS += \
    $$system_quote($$GST_LIB/gstapp-1.0.lib) \
    $$system_quote($$GST_LIB/gstbase-1.0.lib) \
    $$system_quote($$GST_LIB/gstpbutils-1.0.lib) \
    $$system_quote($$GST_LIB/gstreamer-1.0.lib) \
    $$system_quote($$GST_LIB/gobject-2.0.lib) \
    $$system_quote($$GST_LIB/glib-2.0.lib) \
    $$system_quote($$GST_LIB/gstaudio-1.0.lib) \
    $$system_quote($$GST_LIB/gstvideo-1.0.lib) \
    -lopengl32

  CONFIG -= debug
  CONFIG += release

  RC_FILE = resources/windows_resource.rc
  QMAKE_CXXFLAGS += -D_USE_MATH_DEFINES
}
