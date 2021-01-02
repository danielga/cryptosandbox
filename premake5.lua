newoption({
	trigger = "static-runtime",
	description = "Force the use of the static C runtime (only works with static builds)"
})

if not _ACTION then
	if os.istarget("windows") then
		_ACTION = "vs2019"
		print("No action defined for the target platform (\"Windows\"), selecting \"" .. _ACTION .. "\" as the default...")
	elseif os.istarget("linux") or os.istarget("macosx") then
		_ACTION = "gmake"
		print("No action defined for the target platform (\"" .. os.target() .. "\"), selecting \"" .. _ACTION .. "\" as the default...")
	else
		error("No action defined and no supported defaults for the target platform (\"" .. os.target() .. "\")")
	end
end

if _ACTION == "clean" then
	return os.rmdir("projects")
end

workspace("cryptosandbox")
	uuid("8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942")
	language("C++")
	cdialect("C11")
	cppdialect("C++17")
	location("projects/%{os.target()}/%{_ACTION}")
	warnings("Extra")
	flags("MultiProcessorCompile")
	exceptionhandling("SEH")
	characterset("Unicode")
	intrinsics("On")
	inlining("Auto")
	rtti("On")
	vectorextensions("AVX2")
	pic("On")
	platforms({"x86", "x86_64"})
	configurations({"release", "debug", "release-static", "debug-static"})
	startproject("testing")
	targetdir("%{prj.location}/%{cfg.platform}/%{cfg.buildcfg}")
	debugdir("%{prj.location}/%{cfg.platform}/%{cfg.buildcfg}")
	objdir("!%{prj.location}/%{cfg.platform}/%{cfg.buildcfg}/intermediate")

	filter("platforms:x86")
		architecture("x86")

	filter("platforms:x86_64")
		architecture("x86_64")

	filter("system:windows")
		defines({
			"WINVER=0x0601",
			"_WIN32_WINNT=0x0601",
			"STRICT",
			"_CRT_NONSTDC_NO_WARNINGS",
			"_CRT_SECURE_NO_WARNINGS"
		})

	filter("configurations:release")
		defines("NDEBUG")
		optimize("On")
		kind("SharedLib")

	filter("configurations:debug")
		defines({"DEBUG", "_DEBUG"})
		symbols("On")
		kind("SharedLib")

	filter("configurations:release-static")
		defines("NDEBUG")
		optimize("On")
		kind("StaticLib")

		filter({"configurations:release-static", "options:static-runtime"})
			staticruntime("On")

	filter("configurations:debug-static")
		defines({"DEBUG", "_DEBUG"})
		symbols("On")
		kind("StaticLib")

		filter({"configurations:debug-static", "options:static-runtime"})
			staticruntime("On")

	project("testing")
		uuid("CF356D02-1311-4953-BA28-D6838A5F7792")
		kind("ConsoleApp")
		includedirs({
			"include",
			"." -- We want to be able to do #include <cryptopp/...>
		})
		vpaths({["Source files"] = "source/**.cpp"})
		files("source/main.cpp")
		links("signature")

		filter("system:windows")
			defines({
				"UNICODE",
				"_UNICODE",
				"WIN32_LEAN_AND_MEAN"
			})

		filter("configurations:debug or release")
			defines("SIGNATURE_IMPORT")

		filter("configurations:debug-static or release-static")
			defines("SIGNATURE_STATIC")
			links("cryptopp")

	project("signature")
		uuid("8565F3C3-99EA-4685-BDDE-D8240AA57223")
		includedirs({
			"include",
			"include/signature",
			"source",
			"." -- We want to be able to do #include <cryptopp/...>
		})
		vpaths({
			["Header files"] = "include/**.hpp",
			["Source files"] = {
				"source/**.cpp",
				"source/**.hpp"
			}
		})
		files({
			"source/signature/memory.cpp",
			"source/signature/verifier.cpp",
			"include/signature/verifier.hpp"
		})

		filter("system:windows")
			defines({
				"UNICODE",
				"_UNICODE",
				"WIN32_LEAN_AND_MEAN"
			})

		filter("configurations:debug or release")
			defines({"CRYPTOPP_IMPORTS", "SIGNATURE_EXPORT"})
			links("cryptopp")
			disablewarnings({"4251", "4275"})

		filter("configurations:debug-static or release-static")
			defines("SIGNATURE_STATIC")

	include("cryptopp.lua")
