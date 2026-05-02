#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include <desktop_multi_window/desktop_multi_window_plugin.h>

#include "flutter_window.h"
#include "appbar_channel.h"
#include "utils.h"

namespace
{

  void OnDesktopMultiWindowCreated(void *flutter_view_controller)
  {
    if (!flutter_view_controller)
    {
      return;
    }

    auto *controller = reinterpret_cast<flutter::FlutterViewController *>(
        flutter_view_controller);
    if (!controller->engine() || !controller->view())
    {
      return;
    }
    HWND view_hwnd = controller->view()->GetNativeWindow();
    HWND top_level = GetAncestor(view_hwnd, GA_ROOT);
    RegisterAppBarChannel(controller->engine(), top_level);
  }

} // namespace

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command)
{
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent())
  {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  // Ensure plugins can register on engines created by desktop_multi_window.
  DesktopMultiWindowSetWindowCreatedCallback(OnDesktopMultiWindowCreated);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"record_essence", origin, size))
  {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0))
  {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
