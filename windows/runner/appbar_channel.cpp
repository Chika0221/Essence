#include "appbar_channel.h"

#include <commctrl.h>
#include <shellapi.h>

#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter/flutter_engine.h>

#include <map>
#include <memory>
#include <optional>
#include <string>

namespace
{

    struct AppBarState
    {
        bool enabled = false;
        UINT callback_message = 0;
        UINT edge = ABE_TOP;
        int thickness_px = 56;
    };

    // Keep channels and state alive for the lifetime of the process.
    struct EngineState
    {
        HWND hwnd = nullptr;
        std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel;
        AppBarState appbar;
    };

    static std::map<flutter::FlutterEngine *, std::unique_ptr<EngineState>> g_engines;
    static const UINT_PTR kAppBarSubclassId = 0xAABBCCDD;

    RECT GetMonitorRectForWindow(HWND hwnd)
    {
        HMONITOR monitor = MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
        MONITORINFO info{};
        info.cbSize = sizeof(info);
        if (GetMonitorInfo(monitor, &info))
        {
            return info.rcMonitor;
        }
        RECT fallback{};
        SystemParametersInfo(SPI_GETWORKAREA, 0, &fallback, 0);
        return fallback;
    }

    void ApplyAppBarPosition(HWND hwnd, AppBarState &state)
    {
        if (!hwnd || !state.enabled)
        {
            return;
        }

        APPBARDATA abd{};
        abd.cbSize = sizeof(abd);
        abd.hWnd = hwnd;
        abd.uCallbackMessage = state.callback_message;
        abd.uEdge = state.edge;

        RECT monitor_rc = GetMonitorRectForWindow(hwnd);
        abd.rc = monitor_rc;

        // Set requested thickness on the chosen edge.
        switch (state.edge)
        {
        case ABE_TOP:
            abd.rc.bottom = abd.rc.top + state.thickness_px;
            break;
        case ABE_BOTTOM:
            abd.rc.top = abd.rc.bottom - state.thickness_px;
            break;
        case ABE_LEFT:
            abd.rc.right = abd.rc.left + state.thickness_px;
            break;
        case ABE_RIGHT:
            abd.rc.left = abd.rc.right - state.thickness_px;
            break;
        default:
            abd.uEdge = ABE_TOP;
            state.edge = ABE_TOP;
            abd.rc.bottom = abd.rc.top + state.thickness_px;
            break;
        }

        SHAppBarMessage(ABM_QUERYPOS, &abd);

        // Re-apply thickness after the shell adjusts the rect.
        switch (state.edge)
        {
        case ABE_TOP:
            abd.rc.bottom = abd.rc.top + state.thickness_px;
            break;
        case ABE_BOTTOM:
            abd.rc.top = abd.rc.bottom - state.thickness_px;
            break;
        case ABE_LEFT:
            abd.rc.right = abd.rc.left + state.thickness_px;
            break;
        case ABE_RIGHT:
            abd.rc.left = abd.rc.right - state.thickness_px;
            break;
        }

        SHAppBarMessage(ABM_SETPOS, &abd);

        // Ensure the window matches the reserved rect.
        SetWindowPos(hwnd, HWND_TOPMOST, abd.rc.left, abd.rc.top,
                     abd.rc.right - abd.rc.left, abd.rc.bottom - abd.rc.top,
                     SWP_SHOWWINDOW);
    }

    void DisableAppBar(HWND hwnd, AppBarState &state)
    {
        if (!hwnd || !state.enabled)
        {
            return;
        }
        APPBARDATA abd{};
        abd.cbSize = sizeof(abd);
        abd.hWnd = hwnd;
        SHAppBarMessage(ABM_REMOVE, &abd);
        state.enabled = false;
    }

    LRESULT CALLBACK AppBarSubclassProc(HWND hwnd, UINT msg, WPARAM wparam,
                                        LPARAM lparam, UINT_PTR /*subclassId*/,
                                        DWORD_PTR ref_data)
    {
        auto *state = reinterpret_cast<AppBarState *>(ref_data);
        if (state && msg == state->callback_message)
        {
            // Shell notifications like ABN_POSCHANGED
            if (wparam == ABN_POSCHANGED)
            {
                ApplyAppBarPosition(hwnd, *state);
                return 0;
            }
        }

        if (state && msg == WM_DESTROY)
        {
            DisableAppBar(hwnd, *state);
            RemoveWindowSubclass(hwnd, AppBarSubclassProc, kAppBarSubclassId);
        }

        return DefSubclassProc(hwnd, msg, wparam, lparam);
    }

    std::optional<UINT> ParseEdge(const flutter::EncodableValue &v)
    {
        const auto *s = std::get_if<std::string>(&v);
        if (!s)
        {
            return std::nullopt;
        }
        if (*s == "top")
            return ABE_TOP;
        if (*s == "bottom")
            return ABE_BOTTOM;
        if (*s == "left")
            return ABE_LEFT;
        if (*s == "right")
            return ABE_RIGHT;
        return std::nullopt;
    }

    int ScaleLogicalToPhysical(HWND hwnd, double logical_px)
    {
        // Fallback to 96 dpi if API not available.
        UINT dpi = 96;
        HMODULE user32 = GetModuleHandle(L"User32.dll");
        if (user32)
        {
            using GetDpiForWindowFn = UINT(WINAPI *)(HWND);
            auto fn = reinterpret_cast<GetDpiForWindowFn>(
                GetProcAddress(user32, "GetDpiForWindow"));
            if (fn)
            {
                dpi = fn(hwnd);
            }
        }

        const double scale = static_cast<double>(dpi) / 96.0;
        return static_cast<int>(logical_px * scale);
    }

    void EnableOrUpdateAppBar(HWND hwnd, AppBarState &state, UINT edge,
                              int thickness_px)
    {
        if (!hwnd)
        {
            return;
        }

        state.edge = edge;
        state.thickness_px = thickness_px;

        if (!state.enabled)
        {
            state.callback_message = RegisterWindowMessage(L"record_essence_appbar");

            APPBARDATA abd{};
            abd.cbSize = sizeof(abd);
            abd.hWnd = hwnd;
            abd.uCallbackMessage = state.callback_message;
            SHAppBarMessage(ABM_NEW, &abd);

            // Subclass to handle shell callbacks without touching window classes.
            SetWindowSubclass(hwnd, AppBarSubclassProc, kAppBarSubclassId,
                              reinterpret_cast<DWORD_PTR>(&state));

            state.enabled = true;
        }

        ApplyAppBarPosition(hwnd, state);
    }

} // namespace

void RegisterAppBarChannel(flutter::FlutterEngine *engine, HWND top_level_hwnd)
{
    if (!engine || !top_level_hwnd)
    {
        return;
    }

    // Avoid double-registration for the same engine.
    if (g_engines.find(engine) != g_engines.end())
    {
        return;
    }

    auto state = std::make_unique<EngineState>();
    state->hwnd = top_level_hwnd;

    state->channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        engine->messenger(), "record_essence/appbar",
        &flutter::StandardMethodCodec::GetInstance());

    state->channel->SetMethodCallHandler(
        [engine](const flutter::MethodCall<flutter::EncodableValue> &call,
                 std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
        {
            auto it = g_engines.find(engine);
            if (it == g_engines.end())
            {
                result->Error("NO_ENGINE", "engine state not found");
                return;
            }

            auto &st = *it->second;
            const auto &method = call.method_name();

            if (method == "setAppBar")
            {
                bool enabled = false;
                UINT edge = ABE_TOP;
                double thickness = 56.0;

                if (call.arguments())
                {
                    if (const auto *map = std::get_if<flutter::EncodableMap>(call.arguments()))
                    {
                        auto enabled_it = map->find(flutter::EncodableValue("enabled"));
                        if (enabled_it != map->end())
                        {
                            if (const auto *b = std::get_if<bool>(&enabled_it->second))
                            {
                                enabled = *b;
                            }
                        }

                        auto edge_it = map->find(flutter::EncodableValue("edge"));
                        if (edge_it != map->end())
                        {
                            if (auto parsed = ParseEdge(edge_it->second))
                            {
                                edge = *parsed;
                            }
                        }

                        auto thickness_it = map->find(flutter::EncodableValue("thickness"));
                        if (thickness_it != map->end())
                        {
                            if (const auto *d = std::get_if<double>(&thickness_it->second))
                            {
                                thickness = *d;
                            }
                            else if (const auto *i = std::get_if<int32_t>(&thickness_it->second))
                            {
                                thickness = static_cast<double>(*i);
                            }
                            else if (const auto *i64 = std::get_if<int64_t>(&thickness_it->second))
                            {
                                thickness = static_cast<double>(*i64);
                            }
                        }
                    }
                }

                if (enabled)
                {
                    const int thickness_px = ScaleLogicalToPhysical(st.hwnd, thickness);
                    EnableOrUpdateAppBar(st.hwnd, st.appbar, edge, thickness_px);
                }
                else
                {
                    DisableAppBar(st.hwnd, st.appbar);
                }

                result->Success(flutter::EncodableValue(true));
                return;
            }

            result->NotImplemented();
        });

    g_engines[engine] = std::move(state);
}
