#pragma once
#include <QtCore/qglobal.h>

#if defined(QOSC_STATIC)
#  define QOSC_EXPORT
#elif defined(QOSC_LIBRARY)
#  define QOSC_EXPORT Q_DECL_EXPORT
#else
#  define QOSC_EXPORT Q_DECL_IMPORT
#endif
