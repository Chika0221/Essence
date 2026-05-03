#ifndef RUNNER_APPBAR_CHANNEL_H_
#define RUNNER_APPBAR_CHANNEL_H_

#include <windows.h>

namespace flutter
{
    class FlutterEngine;
}

// Registers a per-engine MethodChannel that can turn the given top-level window
// into a Windows AppBar (aka "Application Desktop Toolbar").
void RegisterAppBarChannel(flutter::FlutterEngine *engine, HWND top_level_hwnd);

#endif // RUNNER_APPBAR_CHANNEL_H_
