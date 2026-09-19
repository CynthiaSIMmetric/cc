-- premake5.lua
-- Usage:
--   premake5 gmake
--   make -C build config=release      (or config=debug)
--   ./build/bin/Release/cc

workspace "CC"
    configurations { "Debug", "Release" }
    architecture "x86_64"
    startproject "app"

    -- Generated project files (Makefiles, etc.) go in build/
    location "build"

    language "C"
    cdialect "C23"
    warnings "Extra"

    -- Executables and intermediate objects go in build/
    targetdir "build/bin/%{cfg.buildcfg}"
    objdir    "build/obj/%{cfg.buildcfg}/%{prj.name}"

    filter "toolset:gcc or toolset:clang"
        buildoptions { "-Wpedantic" }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"
        optimize "Off"

    filter "configurations:Release"
        defines { "NDEBUG" }
        symbols "Off"
        optimize "Speed"
        linktimeoptimization "On"

    filter {}

-- Chess engine: static library, output goes in lib/
project "engine"
    kind "StaticLib"
    location "build"
    targetdir "lib/%{cfg.buildcfg}"

    files {
        "src/engine/**.h",
        "src/engine/**.c"
    }
    includedirs { "src" }

    filter "system:linux"
        links { "m" }

    filter {}

-- Front end application: links against the engine
project "app"
    kind "ConsoleApp"
    location "build"
    targetname "cc"

    files {
        "src/app/**.h",
        "src/app/**.c"
    }
    includedirs { "src" }
    libdirs { "lib/%{cfg.buildcfg}" }
    links { "engine" }

    filter "system:linux"
        links { "m" }

    filter {}
