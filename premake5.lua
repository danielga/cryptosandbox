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

local ROOT_DIRECTORY = "."
local SOURCE_DIRECTORY = "source"
local CRYPTOPP_DIRECTORY = "cryptopp"
local INCLUDE_DIRECTORY = "include"
local PROJECTS_DIRECTORY = "projects"
local PROJECT_DIRECTORY = PROJECTS_DIRECTORY .. "/" .. os.target() .. "/" .. _ACTION

if _ACTION == "clean" then
	return os.rmdir(PROJECTS_DIRECTORY)
end

workspace("cryptosandbox")
	uuid("8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942")
	language("C++")
	cppdialect("C++17")
	location(PROJECT_DIRECTORY)
	warnings("Extra")
	flags("MultiProcessorCompile")
	exceptionhandling("SEH")
	characterset("Unicode")
	platforms({"x86", "x64"})
	configurations({"Release", "Debug", "StaticRelease", "StaticDebug"})
	startproject("testing")

	filter("platforms:x86")
		architecture("x32")

	filter("platforms:x64")
		architecture("x64")

	filter("options:static-runtime")
		staticruntime("On")

	filter("system:windows")
		defines({
			"WINVER=0x0601",
			"_WIN32_WINNT=0x0601",
			"STRICT",
			"_CRT_NONSTDC_NO_WARNINGS",
			"_CRT_SECURE_NO_WARNINGS"
		})

	filter("configurations:Release")
		defines("NDEBUG")
		optimize("On")
		vectorextensions("SSE2")
		kind("SharedLib")

		filter({"configurations:Release", "platforms:x86"})
			targetdir(PROJECT_DIRECTORY .. "/x86/release")
			debugdir(PROJECT_DIRECTORY .. "/x86/release")
			objdir("!" .. PROJECT_DIRECTORY .. "/x86/release/intermediate/%{prj.name}")

		filter({"configurations:Release", "platforms:x64"})
			targetdir(PROJECT_DIRECTORY .. "/x64/release")
			debugdir(PROJECT_DIRECTORY .. "/x64/release")
			objdir("!" .. PROJECT_DIRECTORY .. "/x64/release/intermediate/%{prj.name}")

	filter("configurations:Debug")
		defines({"DEBUG", "_DEBUG"})
		symbols("On")
		kind("SharedLib")

		filter({"configurations:Debug", "platforms:x86"})
			targetdir(PROJECT_DIRECTORY .. "/x86/debug")
			debugdir(PROJECT_DIRECTORY .. "/x86/debug")
			objdir("!" .. PROJECT_DIRECTORY .. "/x86/debug/intermediate/%{prj.name}")

		filter({"configurations:Debug", "platforms:x64"})
			targetdir(PROJECT_DIRECTORY .. "/x64/debug")
			debugdir(PROJECT_DIRECTORY .. "/x64/debug")
			objdir("!" .. PROJECT_DIRECTORY .. "/x64/debug/intermediate/%{prj.name}")

	filter("configurations:StaticRelease")
		defines("NDEBUG")
		optimize("On")
		vectorextensions("SSE2")
		kind("StaticLib")

		filter({"configurations:StaticRelease", "options:static-runtime"})
			staticruntime("On")

		filter({"configurations:StaticRelease", "platforms:x86"})
			targetdir(PROJECT_DIRECTORY .. "/x86/release-static")
			debugdir(PROJECT_DIRECTORY .. "/x86/release-static")
			objdir("!" .. PROJECT_DIRECTORY .. "/x86/release-static/intermediate/%{prj.name}")

		filter({"configurations:StaticRelease", "platforms:x64"})
			targetdir(PROJECT_DIRECTORY .. "/x64/release-static")
			debugdir(PROJECT_DIRECTORY .. "/x64/release-static")
			objdir("!" .. PROJECT_DIRECTORY .. "/x64/release-static/intermediate/%{prj.name}")

	filter("configurations:StaticDebug")
		defines({"DEBUG", "_DEBUG"})
		symbols("On")
		kind("StaticLib")

		filter({"configurations:StaticDebug", "options:static-runtime"})
			staticruntime("On")

		filter({"configurations:StaticDebug", "platforms:x86"})
			targetdir(PROJECT_DIRECTORY .. "/x86/debug-static")
			debugdir(PROJECT_DIRECTORY .. "/x86/debug-static")
			objdir("!" .. PROJECT_DIRECTORY .. "/x86/debug-static/intermediate/%{prj.name}")

		filter({"configurations:StaticDebug", "platforms:x64"})
			targetdir(PROJECT_DIRECTORY .. "/x64/debug-static")
			debugdir(PROJECT_DIRECTORY .. "/x64/debug-static")
			objdir("!" .. PROJECT_DIRECTORY .. "/x64/debug-static/intermediate/%{prj.name}")

	project("testing")
		uuid("CF356D02-1311-4953-BA28-D6838A5F7792")
		kind("ConsoleApp")
		includedirs({
			INCLUDE_DIRECTORY,
			ROOT_DIRECTORY -- We want to be able to do #include <cryptopp/...>
		})
		vpaths({["Source files"] = SOURCE_DIRECTORY .. "/**.cpp"})
		files(SOURCE_DIRECTORY .. "/main.cpp")
		links({"common", "cryptopp"})

		filter("system:windows")
			defines({
				"UNICODE",
				"_UNICODE",
				"WIN32_LEAN_AND_MEAN"
			})

	project("common")
		uuid("8565F3C3-99EA-4685-BDDE-D8240AA57223")
		includedirs({
			INCLUDE_DIRECTORY,
			SOURCE_DIRECTORY,
			ROOT_DIRECTORY -- We want to be able to do #include <cryptopp/...>
		})
		vpaths({
			["Header files"] = INCLUDE_DIRECTORY .. "/**.hpp",
			["Source files"] = {
				SOURCE_DIRECTORY .. "/**.cpp",
				SOURCE_DIRECTORY .. "/**.hpp"
			}
		})

		filter("system:windows")
			defines({
				"UNICODE",
				"_UNICODE",
				"WIN32_LEAN_AND_MEAN"
			})

		filter("configurations:Debug or Release")
			defines("CRYPTOPP_IMPORTS")
			links("cryptopp")
			disablewarnings({"4251", "4275"})

	project("cryptopp")
		uuid("56A1D28D-90AF-4924-8781-0811439E03C2")
		characterset("MBCS")
		includedirs(CRYPTOPP_DIRECTORY)
		vpaths({
			["Header files"] = CRYPTOPP_DIRECTORY .. "/**.h",
			["Source files"] = {
				CRYPTOPP_DIRECTORY .. "/**.asm",
				CRYPTOPP_DIRECTORY .. "/**.cpp"
			}
		})
		pchheader("pch.h")
		pchsource(CRYPTOPP_DIRECTORY .. "/pch.cpp")

		filter("system:windows")
			disablewarnings({"4251", "4275"})

		filter("configurations:Debug or Release")
			defines("CRYPTOPP_EXPORTS")
			files({
				CRYPTOPP_DIRECTORY .. "/pch.cpp",
				CRYPTOPP_DIRECTORY .. "/dll.cpp",
				CRYPTOPP_DIRECTORY .. "/iterhash.cpp",
				CRYPTOPP_DIRECTORY .. "/algebra.cpp",
				CRYPTOPP_DIRECTORY .. "/algparam.cpp",
				CRYPTOPP_DIRECTORY .. "/asn.cpp",
				CRYPTOPP_DIRECTORY .. "/authenc.cpp",
				CRYPTOPP_DIRECTORY .. "/basecode.cpp",
				CRYPTOPP_DIRECTORY .. "/cbcmac.cpp",
				CRYPTOPP_DIRECTORY .. "/ccm.cpp",
				CRYPTOPP_DIRECTORY .. "/channels.cpp",
				CRYPTOPP_DIRECTORY .. "/cmac.cpp",
				CRYPTOPP_DIRECTORY .. "/cpu.cpp",
				CRYPTOPP_DIRECTORY .. "/cryptlib.cpp",
				CRYPTOPP_DIRECTORY .. "/des.cpp",
				CRYPTOPP_DIRECTORY .. "/dessp.cpp",
				CRYPTOPP_DIRECTORY .. "/dh.cpp",
				CRYPTOPP_DIRECTORY .. "/dsa.cpp",
				CRYPTOPP_DIRECTORY .. "/ec2n.cpp",
				CRYPTOPP_DIRECTORY .. "/eccrypto.cpp",
				CRYPTOPP_DIRECTORY .. "/ecp.cpp",
				CRYPTOPP_DIRECTORY .. "/emsa2.cpp",
				CRYPTOPP_DIRECTORY .. "/eprecomp.cpp",
				CRYPTOPP_DIRECTORY .. "/files.cpp",
				CRYPTOPP_DIRECTORY .. "/filters.cpp",
				CRYPTOPP_DIRECTORY .. "/fips140.cpp",
				CRYPTOPP_DIRECTORY .. "/fipstest.cpp",
				CRYPTOPP_DIRECTORY .. "/gcm.cpp",
				CRYPTOPP_DIRECTORY .. "/gcm_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/gf2n.cpp",
				CRYPTOPP_DIRECTORY .. "/gf2n_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/gfpcrypt.cpp",
				CRYPTOPP_DIRECTORY .. "/hex.cpp",
				CRYPTOPP_DIRECTORY .. "/hmac.cpp",
				CRYPTOPP_DIRECTORY .. "/hrtimer.cpp",
				CRYPTOPP_DIRECTORY .. "/integer.cpp",
				CRYPTOPP_DIRECTORY .. "/misc.cpp",
				CRYPTOPP_DIRECTORY .. "/modes.cpp",
				CRYPTOPP_DIRECTORY .. "/mqueue.cpp",
				CRYPTOPP_DIRECTORY .. "/nbtheory.cpp",
				CRYPTOPP_DIRECTORY .. "/oaep.cpp",
				CRYPTOPP_DIRECTORY .. "/osrng.cpp",
				CRYPTOPP_DIRECTORY .. "/pkcspad.cpp",
				CRYPTOPP_DIRECTORY .. "/pssr.cpp",
				CRYPTOPP_DIRECTORY .. "/pubkey.cpp",
				CRYPTOPP_DIRECTORY .. "/queue.cpp",
				CRYPTOPP_DIRECTORY .. "/randpool.cpp",
				CRYPTOPP_DIRECTORY .. "/rdtables.cpp",
				CRYPTOPP_DIRECTORY .. "/rijndael.cpp",
				CRYPTOPP_DIRECTORY .. "/rijndael_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/rng.cpp",
				CRYPTOPP_DIRECTORY .. "/rsa.cpp",
				CRYPTOPP_DIRECTORY .. "/rw.cpp",
				CRYPTOPP_DIRECTORY .. "/sha.cpp",
				CRYPTOPP_DIRECTORY .. "/sha_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/simple.cpp",
				CRYPTOPP_DIRECTORY .. "/skipjack.cpp",
				CRYPTOPP_DIRECTORY .. "/sse_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/strciphr.cpp",

				CRYPTOPP_DIRECTORY .. "/aes.h",
				CRYPTOPP_DIRECTORY .. "/algebra.h",
				CRYPTOPP_DIRECTORY .. "/algparam.h",
				CRYPTOPP_DIRECTORY .. "/argnames.h",
				CRYPTOPP_DIRECTORY .. "/asn.h",
				CRYPTOPP_DIRECTORY .. "/authenc.h",
				CRYPTOPP_DIRECTORY .. "/basecode.h",
				CRYPTOPP_DIRECTORY .. "/cbcmac.h",
				CRYPTOPP_DIRECTORY .. "/ccm.h",
				CRYPTOPP_DIRECTORY .. "/channels.h",
				CRYPTOPP_DIRECTORY .. "/cmac.h",
				CRYPTOPP_DIRECTORY .. "/config.h",
				CRYPTOPP_DIRECTORY .. "/cpu.h",
				CRYPTOPP_DIRECTORY .. "/cryptlib.h",
				CRYPTOPP_DIRECTORY .. "/des.h",
				CRYPTOPP_DIRECTORY .. "/dh.h",
				CRYPTOPP_DIRECTORY .. "/dll.h",
				CRYPTOPP_DIRECTORY .. "/dsa.h",
				CRYPTOPP_DIRECTORY .. "/ec2n.h",
				CRYPTOPP_DIRECTORY .. "/eccrypto.h",
				CRYPTOPP_DIRECTORY .. "/ecp.h",
				CRYPTOPP_DIRECTORY .. "/ecpoint.h",
				CRYPTOPP_DIRECTORY .. "/emsa2.h",
				CRYPTOPP_DIRECTORY .. "/eprecomp.h",
				CRYPTOPP_DIRECTORY .. "/files.h",
				CRYPTOPP_DIRECTORY .. "/filters.h",
				CRYPTOPP_DIRECTORY .. "/fips140.h",
				CRYPTOPP_DIRECTORY .. "/fltrimpl.h",
				CRYPTOPP_DIRECTORY .. "/gcm.h",
				CRYPTOPP_DIRECTORY .. "/gf2n.h",
				CRYPTOPP_DIRECTORY .. "/gfpcrypt.h",
				CRYPTOPP_DIRECTORY .. "/hex.h",
				CRYPTOPP_DIRECTORY .. "/hmac.h",
				CRYPTOPP_DIRECTORY .. "/integer.h",
				CRYPTOPP_DIRECTORY .. "/iterhash.h",
				CRYPTOPP_DIRECTORY .. "/mdc.h",
				CRYPTOPP_DIRECTORY .. "/misc.h",
				CRYPTOPP_DIRECTORY .. "/modarith.h",
				CRYPTOPP_DIRECTORY .. "/modes.h",
				CRYPTOPP_DIRECTORY .. "/modexppc.h",
				CRYPTOPP_DIRECTORY .. "/mqueue.h",
				CRYPTOPP_DIRECTORY .. "/mqv.h",
				CRYPTOPP_DIRECTORY .. "/nbtheory.h",
				CRYPTOPP_DIRECTORY .. "/oaep.h",
				CRYPTOPP_DIRECTORY .. "/oids.h",
				CRYPTOPP_DIRECTORY .. "/osrng.h",
				CRYPTOPP_DIRECTORY .. "/pch.h",
				CRYPTOPP_DIRECTORY .. "/pkcspad.h",
				CRYPTOPP_DIRECTORY .. "/pssr.h",
				CRYPTOPP_DIRECTORY .. "/pubkey.h",
				CRYPTOPP_DIRECTORY .. "/queue.h",
				CRYPTOPP_DIRECTORY .. "/randpool.h",
				CRYPTOPP_DIRECTORY .. "/rijndael.h",
				CRYPTOPP_DIRECTORY .. "/rng.h",
				CRYPTOPP_DIRECTORY .. "/rsa.h",
				CRYPTOPP_DIRECTORY .. "/rw.h",
				CRYPTOPP_DIRECTORY .. "/secblock.h",
				CRYPTOPP_DIRECTORY .. "/seckey.h",
				CRYPTOPP_DIRECTORY .. "/sha.h",
				CRYPTOPP_DIRECTORY .. "/simple.h",
				CRYPTOPP_DIRECTORY .. "/skipjack.h",
				CRYPTOPP_DIRECTORY .. "/smartptr.h",
				CRYPTOPP_DIRECTORY .. "/stdcpp.h",
				CRYPTOPP_DIRECTORY .. "/strciphr.h",
				CRYPTOPP_DIRECTORY .. "/trap.h",
				CRYPTOPP_DIRECTORY .. "/words.h"
			})

		filter("configurations:StaticDebug or StaticRelease")
			vectorextensions("AVX2")
			files({
				CRYPTOPP_DIRECTORY .. "/cryptlib.cpp",
				CRYPTOPP_DIRECTORY .. "/cpu.cpp",
				CRYPTOPP_DIRECTORY .. "/integer.cpp",
				CRYPTOPP_DIRECTORY .. "/3way.cpp",
				CRYPTOPP_DIRECTORY .. "/adler32.cpp",
				CRYPTOPP_DIRECTORY .. "/algebra.cpp",
				CRYPTOPP_DIRECTORY .. "/algparam.cpp",
				CRYPTOPP_DIRECTORY .. "/arc4.cpp",
				CRYPTOPP_DIRECTORY .. "/aria.cpp",
				CRYPTOPP_DIRECTORY .. "/aria_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/ariatab.cpp",
				CRYPTOPP_DIRECTORY .. "/asn.cpp",
				CRYPTOPP_DIRECTORY .. "/authenc.cpp",
				CRYPTOPP_DIRECTORY .. "/base32.cpp",
				CRYPTOPP_DIRECTORY .. "/base64.cpp",
				CRYPTOPP_DIRECTORY .. "/basecode.cpp",
				CRYPTOPP_DIRECTORY .. "/bfinit.cpp",
				CRYPTOPP_DIRECTORY .. "/blake2.cpp",
				CRYPTOPP_DIRECTORY .. "/blake2s_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/blake2b_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/blowfish.cpp",
				CRYPTOPP_DIRECTORY .. "/blumshub.cpp",
				CRYPTOPP_DIRECTORY .. "/camellia.cpp",
				CRYPTOPP_DIRECTORY .. "/cast.cpp",
				CRYPTOPP_DIRECTORY .. "/casts.cpp",
				CRYPTOPP_DIRECTORY .. "/cbcmac.cpp",
				CRYPTOPP_DIRECTORY .. "/ccm.cpp",
				CRYPTOPP_DIRECTORY .. "/chacha.cpp",
				CRYPTOPP_DIRECTORY .. "/chacha_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/chacha_avx.cpp",
				CRYPTOPP_DIRECTORY .. "/chachapoly.cpp",
				CRYPTOPP_DIRECTORY .. "/cham.cpp",
				CRYPTOPP_DIRECTORY .. "/cham_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/channels.cpp",
				CRYPTOPP_DIRECTORY .. "/cmac.cpp",
				CRYPTOPP_DIRECTORY .. "/crc.cpp",
				CRYPTOPP_DIRECTORY .. "/crc_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/darn.cpp",
				CRYPTOPP_DIRECTORY .. "/default.cpp",
				CRYPTOPP_DIRECTORY .. "/des.cpp",
				CRYPTOPP_DIRECTORY .. "/dessp.cpp",
				CRYPTOPP_DIRECTORY .. "/dh.cpp",
				CRYPTOPP_DIRECTORY .. "/dh2.cpp",
				CRYPTOPP_DIRECTORY .. "/dll.cpp",
				CRYPTOPP_DIRECTORY .. "/donna_32.cpp",
				CRYPTOPP_DIRECTORY .. "/donna_64.cpp",
				CRYPTOPP_DIRECTORY .. "/donna_sse.cpp",
				CRYPTOPP_DIRECTORY .. "/dsa.cpp",
				CRYPTOPP_DIRECTORY .. "/eax.cpp",
				CRYPTOPP_DIRECTORY .. "/ec2n.cpp",
				CRYPTOPP_DIRECTORY .. "/eccrypto.cpp",
				CRYPTOPP_DIRECTORY .. "/ecp.cpp",
				CRYPTOPP_DIRECTORY .. "/elgamal.cpp",
				CRYPTOPP_DIRECTORY .. "/emsa2.cpp",
				CRYPTOPP_DIRECTORY .. "/eprecomp.cpp",
				CRYPTOPP_DIRECTORY .. "/esign.cpp",
				CRYPTOPP_DIRECTORY .. "/files.cpp",
				CRYPTOPP_DIRECTORY .. "/filters.cpp",
				CRYPTOPP_DIRECTORY .. "/fips140.cpp",
				CRYPTOPP_DIRECTORY .. "/fipstest.cpp",
				CRYPTOPP_DIRECTORY .. "/gcm.cpp",
				CRYPTOPP_DIRECTORY .. "/gcm_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/gf256.cpp",
				CRYPTOPP_DIRECTORY .. "/gf2_32.cpp",
				CRYPTOPP_DIRECTORY .. "/gf2n.cpp",
				CRYPTOPP_DIRECTORY .. "/gf2n_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/gfpcrypt.cpp",
				CRYPTOPP_DIRECTORY .. "/gost.cpp",
				CRYPTOPP_DIRECTORY .. "/gzip.cpp",
				CRYPTOPP_DIRECTORY .. "/hc128.cpp",
				CRYPTOPP_DIRECTORY .. "/hc256.cpp",
				CRYPTOPP_DIRECTORY .. "/hex.cpp",
				CRYPTOPP_DIRECTORY .. "/hight.cpp",
				CRYPTOPP_DIRECTORY .. "/hmac.cpp",
				CRYPTOPP_DIRECTORY .. "/hrtimer.cpp",
				CRYPTOPP_DIRECTORY .. "/ida.cpp",
				CRYPTOPP_DIRECTORY .. "/idea.cpp",
				CRYPTOPP_DIRECTORY .. "/iterhash.cpp",
				CRYPTOPP_DIRECTORY .. "/kalyna.cpp",
				CRYPTOPP_DIRECTORY .. "/kalynatab.cpp",
				CRYPTOPP_DIRECTORY .. "/keccak.cpp",
				CRYPTOPP_DIRECTORY .. "/keccak_core.cpp",
				CRYPTOPP_DIRECTORY .. "/keccak_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/lea.cpp",
				CRYPTOPP_DIRECTORY .. "/lea_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/luc.cpp",
				CRYPTOPP_DIRECTORY .. "/mars.cpp",
				CRYPTOPP_DIRECTORY .. "/marss.cpp",
				CRYPTOPP_DIRECTORY .. "/md2.cpp",
				CRYPTOPP_DIRECTORY .. "/md4.cpp",
				CRYPTOPP_DIRECTORY .. "/md5.cpp",
				CRYPTOPP_DIRECTORY .. "/misc.cpp",
				CRYPTOPP_DIRECTORY .. "/modes.cpp",
				CRYPTOPP_DIRECTORY .. "/mqueue.cpp",
				CRYPTOPP_DIRECTORY .. "/mqv.cpp",
				CRYPTOPP_DIRECTORY .. "/nbtheory.cpp",
				CRYPTOPP_DIRECTORY .. "/oaep.cpp",
				CRYPTOPP_DIRECTORY .. "/osrng.cpp",
				CRYPTOPP_DIRECTORY .. "/padlkrng.cpp",
				CRYPTOPP_DIRECTORY .. "/panama.cpp",
				CRYPTOPP_DIRECTORY .. "/pch.cpp",
				CRYPTOPP_DIRECTORY .. "/pkcspad.cpp",
				CRYPTOPP_DIRECTORY .. "/poly1305.cpp",
				CRYPTOPP_DIRECTORY .. "/polynomi.cpp",
				CRYPTOPP_DIRECTORY .. "/pssr.cpp",
				CRYPTOPP_DIRECTORY .. "/pubkey.cpp",
				CRYPTOPP_DIRECTORY .. "/queue.cpp",
				CRYPTOPP_DIRECTORY .. "/rabin.cpp",
				CRYPTOPP_DIRECTORY .. "/randpool.cpp",
				CRYPTOPP_DIRECTORY .. "/rabbit.cpp",
				CRYPTOPP_DIRECTORY .. "/rc2.cpp",
				CRYPTOPP_DIRECTORY .. "/rc5.cpp",
				CRYPTOPP_DIRECTORY .. "/rc6.cpp",
				CRYPTOPP_DIRECTORY .. "/rdrand.cpp",
				CRYPTOPP_DIRECTORY .. "/rdtables.cpp",
				CRYPTOPP_DIRECTORY .. "/rijndael.cpp",
				CRYPTOPP_DIRECTORY .. "/rijndael_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/ripemd.cpp",
				CRYPTOPP_DIRECTORY .. "/rng.cpp",
				CRYPTOPP_DIRECTORY .. "/rsa.cpp",
				CRYPTOPP_DIRECTORY .. "/rw.cpp",
				CRYPTOPP_DIRECTORY .. "/safer.cpp",
				CRYPTOPP_DIRECTORY .. "/salsa.cpp",
				CRYPTOPP_DIRECTORY .. "/scrypt.cpp",
				CRYPTOPP_DIRECTORY .. "/seal.cpp",
				CRYPTOPP_DIRECTORY .. "/seed.cpp",
				CRYPTOPP_DIRECTORY .. "/serpent.cpp",
				CRYPTOPP_DIRECTORY .. "/sha.cpp",
				CRYPTOPP_DIRECTORY .. "/sha_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/sha3.cpp",
				CRYPTOPP_DIRECTORY .. "/shacal2.cpp",
				CRYPTOPP_DIRECTORY .. "/shacal2_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/shake.cpp",
				CRYPTOPP_DIRECTORY .. "/shark.cpp",
				CRYPTOPP_DIRECTORY .. "/sharkbox.cpp",
				CRYPTOPP_DIRECTORY .. "/simeck.cpp",
				CRYPTOPP_DIRECTORY .. "/simeck_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/simon.cpp",
				CRYPTOPP_DIRECTORY .. "/simon64_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/simon128_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/simple.cpp",
				CRYPTOPP_DIRECTORY .. "/skipjack.cpp",
				CRYPTOPP_DIRECTORY .. "/sm3.cpp",
				CRYPTOPP_DIRECTORY .. "/sm4.cpp",
				CRYPTOPP_DIRECTORY .. "/sm4_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/sosemanuk.cpp",
				CRYPTOPP_DIRECTORY .. "/speck.cpp",
				CRYPTOPP_DIRECTORY .. "/speck64_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/speck128_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/square.cpp",
				CRYPTOPP_DIRECTORY .. "/squaretb.cpp",
				CRYPTOPP_DIRECTORY .. "/sse_simd.cpp",
				CRYPTOPP_DIRECTORY .. "/strciphr.cpp",
				CRYPTOPP_DIRECTORY .. "/tea.cpp",
				CRYPTOPP_DIRECTORY .. "/tftables.cpp",
				CRYPTOPP_DIRECTORY .. "/threefish.cpp",
				CRYPTOPP_DIRECTORY .. "/tiger.cpp",
				CRYPTOPP_DIRECTORY .. "/tigertab.cpp",
				CRYPTOPP_DIRECTORY .. "/ttmac.cpp",
				CRYPTOPP_DIRECTORY .. "/tweetnacl.cpp",
				CRYPTOPP_DIRECTORY .. "/twofish.cpp",
				CRYPTOPP_DIRECTORY .. "/vmac.cpp",
				CRYPTOPP_DIRECTORY .. "/wake.cpp",
				CRYPTOPP_DIRECTORY .. "/whrlpool.cpp",
				CRYPTOPP_DIRECTORY .. "/xed25519.cpp",
				CRYPTOPP_DIRECTORY .. "/xtr.cpp",
				CRYPTOPP_DIRECTORY .. "/xtrcrypt.cpp",
				CRYPTOPP_DIRECTORY .. "/zdeflate.cpp",
				CRYPTOPP_DIRECTORY .. "/zinflate.cpp",
				CRYPTOPP_DIRECTORY .. "/zlib.cpp",

				CRYPTOPP_DIRECTORY .. "/3way.h",
				CRYPTOPP_DIRECTORY .. "/adler32.h",
				CRYPTOPP_DIRECTORY .. "/adv_simd.h",
				CRYPTOPP_DIRECTORY .. "/aes.h",
				CRYPTOPP_DIRECTORY .. "/algebra.h",
				CRYPTOPP_DIRECTORY .. "/algparam.h",
				CRYPTOPP_DIRECTORY .. "/arc4.h",
				CRYPTOPP_DIRECTORY .. "/aria.h",
				CRYPTOPP_DIRECTORY .. "/argnames.h",
				CRYPTOPP_DIRECTORY .. "/asn.h",
				CRYPTOPP_DIRECTORY .. "/authenc.h",
				CRYPTOPP_DIRECTORY .. "/base32.h",
				CRYPTOPP_DIRECTORY .. "/base64.h",
				CRYPTOPP_DIRECTORY .. "/basecode.h",
				CRYPTOPP_DIRECTORY .. "/blake2.h",
				CRYPTOPP_DIRECTORY .. "/blowfish.h",
				CRYPTOPP_DIRECTORY .. "/blumshub.h",
				CRYPTOPP_DIRECTORY .. "/camellia.h",
				CRYPTOPP_DIRECTORY .. "/cast.h",
				CRYPTOPP_DIRECTORY .. "/cbcmac.h",
				CRYPTOPP_DIRECTORY .. "/ccm.h",
				CRYPTOPP_DIRECTORY .. "/chacha.h",
				CRYPTOPP_DIRECTORY .. "/chachapoly.h",
				CRYPTOPP_DIRECTORY .. "/cham.h",
				CRYPTOPP_DIRECTORY .. "/channels.h",
				CRYPTOPP_DIRECTORY .. "/cmac.h",
				CRYPTOPP_DIRECTORY .. "/config.h",
				CRYPTOPP_DIRECTORY .. "/cpu.h",
				CRYPTOPP_DIRECTORY .. "/crc.h",
				CRYPTOPP_DIRECTORY .. "/cryptlib.h",
				CRYPTOPP_DIRECTORY .. "/darn.h",
				CRYPTOPP_DIRECTORY .. "/default.h",
				CRYPTOPP_DIRECTORY .. "/des.h",
				CRYPTOPP_DIRECTORY .. "/dh.h",
				CRYPTOPP_DIRECTORY .. "/dh2.h",
				CRYPTOPP_DIRECTORY .. "/dmac.h",
				CRYPTOPP_DIRECTORY .. "/drbg.h",
				CRYPTOPP_DIRECTORY .. "/donna.h",
				CRYPTOPP_DIRECTORY .. "/donna_32.h",
				CRYPTOPP_DIRECTORY .. "/donna_64.h",
				CRYPTOPP_DIRECTORY .. "/donna_sse.h",
				CRYPTOPP_DIRECTORY .. "/dsa.h",
				CRYPTOPP_DIRECTORY .. "/eax.h",
				CRYPTOPP_DIRECTORY .. "/ec2n.h",
				CRYPTOPP_DIRECTORY .. "/eccrypto.h",
				CRYPTOPP_DIRECTORY .. "/ecp.h",
				CRYPTOPP_DIRECTORY .. "/ecpoint.h",
				CRYPTOPP_DIRECTORY .. "/elgamal.h",
				CRYPTOPP_DIRECTORY .. "/emsa2.h",
				CRYPTOPP_DIRECTORY .. "/eprecomp.h",
				CRYPTOPP_DIRECTORY .. "/esign.h",
				CRYPTOPP_DIRECTORY .. "/files.h",
				CRYPTOPP_DIRECTORY .. "/filters.h",
				CRYPTOPP_DIRECTORY .. "/fips140.h",
				CRYPTOPP_DIRECTORY .. "/fhmqv.h",
				CRYPTOPP_DIRECTORY .. "/fltrimpl.h",
				CRYPTOPP_DIRECTORY .. "/gcm.h",
				CRYPTOPP_DIRECTORY .. "/gf256.h",
				CRYPTOPP_DIRECTORY .. "/gf2_32.h",
				CRYPTOPP_DIRECTORY .. "/gf2n.h",
				CRYPTOPP_DIRECTORY .. "/gfpcrypt.h",
				CRYPTOPP_DIRECTORY .. "/gost.h",
				CRYPTOPP_DIRECTORY .. "/gzip.h",
				CRYPTOPP_DIRECTORY .. "/hc128.h",
				CRYPTOPP_DIRECTORY .. "/hc256.h",
				CRYPTOPP_DIRECTORY .. "/hex.h",
				CRYPTOPP_DIRECTORY .. "/hight.h",
				CRYPTOPP_DIRECTORY .. "/hkdf.h",
				CRYPTOPP_DIRECTORY .. "/hmac.h",
				CRYPTOPP_DIRECTORY .. "/hmqv.h",
				CRYPTOPP_DIRECTORY .. "/hrtimer.h",
				CRYPTOPP_DIRECTORY .. "/ida.h",
				CRYPTOPP_DIRECTORY .. "/idea.h",
				CRYPTOPP_DIRECTORY .. "/integer.h",
				CRYPTOPP_DIRECTORY .. "/iterhash.h",
				CRYPTOPP_DIRECTORY .. "/kalyna.h",
				CRYPTOPP_DIRECTORY .. "/keccak.h",
				CRYPTOPP_DIRECTORY .. "/lubyrack.h",
				CRYPTOPP_DIRECTORY .. "/lea.h",
				CRYPTOPP_DIRECTORY .. "/luc.h",
				CRYPTOPP_DIRECTORY .. "/mars.h",
				CRYPTOPP_DIRECTORY .. "/md2.h",
				CRYPTOPP_DIRECTORY .. "/md4.h",
				CRYPTOPP_DIRECTORY .. "/md5.h",
				CRYPTOPP_DIRECTORY .. "/mdc.h",
				CRYPTOPP_DIRECTORY .. "/misc.h",
				CRYPTOPP_DIRECTORY .. "/modarith.h",
				CRYPTOPP_DIRECTORY .. "/modes.h",
				CRYPTOPP_DIRECTORY .. "/modexppc.h",
				CRYPTOPP_DIRECTORY .. "/mqueue.h",
				CRYPTOPP_DIRECTORY .. "/mqv.h",
				CRYPTOPP_DIRECTORY .. "/naclite.h",
				CRYPTOPP_DIRECTORY .. "/nbtheory.h",
				CRYPTOPP_DIRECTORY .. "/nr.h",
				CRYPTOPP_DIRECTORY .. "/oaep.h",
				CRYPTOPP_DIRECTORY .. "/oids.h",
				CRYPTOPP_DIRECTORY .. "/osrng.h",
				CRYPTOPP_DIRECTORY .. "/padlkrng.h",
				CRYPTOPP_DIRECTORY .. "/panama.h",
				CRYPTOPP_DIRECTORY .. "/pch.h",
				CRYPTOPP_DIRECTORY .. "/pkcspad.h",
				CRYPTOPP_DIRECTORY .. "/poly1305.h",
				CRYPTOPP_DIRECTORY .. "/polynomi.h",
				CRYPTOPP_DIRECTORY .. "/pssr.h",
				CRYPTOPP_DIRECTORY .. "/pubkey.h",
				CRYPTOPP_DIRECTORY .. "/pwdbased.h",
				CRYPTOPP_DIRECTORY .. "/queue.h",
				CRYPTOPP_DIRECTORY .. "/rabin.h",
				CRYPTOPP_DIRECTORY .. "/randpool.h",
				CRYPTOPP_DIRECTORY .. "/rabbit.h",
				CRYPTOPP_DIRECTORY .. "/rc2.h",
				CRYPTOPP_DIRECTORY .. "/rc5.h",
				CRYPTOPP_DIRECTORY .. "/rc6.h",
				CRYPTOPP_DIRECTORY .. "/rdrand.h",
				CRYPTOPP_DIRECTORY .. "/rijndael.h",
				CRYPTOPP_DIRECTORY .. "/ripemd.h",
				CRYPTOPP_DIRECTORY .. "/rng.h",
				CRYPTOPP_DIRECTORY .. "/rsa.h",
				CRYPTOPP_DIRECTORY .. "/rw.h",
				CRYPTOPP_DIRECTORY .. "/safer.h",
				CRYPTOPP_DIRECTORY .. "/salsa.h",
				CRYPTOPP_DIRECTORY .. "/scrypt.h",
				CRYPTOPP_DIRECTORY .. "/seal.h",
				CRYPTOPP_DIRECTORY .. "/secblock.h",
				CRYPTOPP_DIRECTORY .. "/seckey.h",
				CRYPTOPP_DIRECTORY .. "/seed.h",
				CRYPTOPP_DIRECTORY .. "/serpent.h",
				CRYPTOPP_DIRECTORY .. "/sha.h",
				CRYPTOPP_DIRECTORY .. "/sha3.h",
				CRYPTOPP_DIRECTORY .. "/shacal2.h",
				CRYPTOPP_DIRECTORY .. "/shake.h",
				CRYPTOPP_DIRECTORY .. "/shark.h",
				CRYPTOPP_DIRECTORY .. "/simple.h",
				CRYPTOPP_DIRECTORY .. "/simeck.h",
				CRYPTOPP_DIRECTORY .. "/simon.h",
				CRYPTOPP_DIRECTORY .. "/siphash.h",
				CRYPTOPP_DIRECTORY .. "/skipjack.h",
				CRYPTOPP_DIRECTORY .. "/sm3.h",
				CRYPTOPP_DIRECTORY .. "/sm4.h",
				CRYPTOPP_DIRECTORY .. "/smartptr.h",
				CRYPTOPP_DIRECTORY .. "/sosemanuk.h",
				CRYPTOPP_DIRECTORY .. "/speck.h",
				CRYPTOPP_DIRECTORY .. "/square.h",
				CRYPTOPP_DIRECTORY .. "/stdcpp.h",
				CRYPTOPP_DIRECTORY .. "/strciphr.h",
				CRYPTOPP_DIRECTORY .. "/tea.h",
				CRYPTOPP_DIRECTORY .. "/threefish.h",
				CRYPTOPP_DIRECTORY .. "/tiger.h",
				CRYPTOPP_DIRECTORY .. "/trap.h",
				CRYPTOPP_DIRECTORY .. "/trunhash.h",
				CRYPTOPP_DIRECTORY .. "/ttmac.h",
				CRYPTOPP_DIRECTORY .. "/tweetnacl.h",
				CRYPTOPP_DIRECTORY .. "/twofish.h",
				CRYPTOPP_DIRECTORY .. "/vmac.h",
				CRYPTOPP_DIRECTORY .. "/wake.h",
				CRYPTOPP_DIRECTORY .. "/whrlpool.h",
				CRYPTOPP_DIRECTORY .. "/words.h",
				CRYPTOPP_DIRECTORY .. "/xed25519.h",
				CRYPTOPP_DIRECTORY .. "/xtr.h",
				CRYPTOPP_DIRECTORY .. "/xtrcrypt.h",
				CRYPTOPP_DIRECTORY .. "/zdeflate.h",
				CRYPTOPP_DIRECTORY .. "/zinflate.h",
				CRYPTOPP_DIRECTORY .. "/zlib.h"
			})

			filter("system:windows")
				files(CRYPTOPP_DIRECTORY .. "/rdrand.asm")

			filter({"system:windows", "platforms:x64"})
				files(CRYPTOPP_DIRECTORY .. "/x64dll.asm")

			filter({"configurations:StaticDebug or StaticRelease", "system:windows", "platforms:x64"})
				files(CRYPTOPP_DIRECTORY .. "/x64masm.asm")

			filter({"files:" .. CRYPTOPP_DIRECTORY .. "/eccrypto.cpp or " .. CRYPTOPP_DIRECTORY .. "/eprecomp.cpp", "configurations:StaticDebug or StaticRelease"})
				flags("ExcludeFromBuild")

		filter("files:" .. CRYPTOPP_DIRECTORY .. "/dll.cpp or " .. CRYPTOPP_DIRECTORY .. "/iterhash.cpp")
			flags("NoPCH")

		filter({"files:" .. CRYPTOPP_DIRECTORY .. "/rdrand.asm", "system:windows"})
			buildmessage("Assembling %{file.relpath}")
			buildoutputs("%{cfg.objdir}/%{file.basename}-%{cfg.platform}.obj")

			filter({"files:" .. CRYPTOPP_DIRECTORY .. "/rdrand.asm", "system:windows", "platforms:x86"})
				buildcommands("ml /c /nologo /D_M_X86 /W3 /Cx /Zi /safeseh /Fo \"%{cfg.objdir}/%{file.basename}-%{cfg.platform}.obj\" \"%{file.relpath}\"")

			filter({"files:" .. CRYPTOPP_DIRECTORY .. "/rdrand.asm", "system:windows", "platforms:x64"})
				buildcommands("ml64 /c /nologo /D_M_X64 /W3 /Cx /Zi /Fo \"%{cfg.objdir}/%{file.basename}-%{cfg.platform}.obj\" \"%{file.relpath}\"")

		filter({"files:" .. CRYPTOPP_DIRECTORY .. "/x64dll.asm", "system:windows", "platforms:x64"})
			buildmessage("Assembling %{file.relpath}")
			buildoutputs("%{cfg.objdir}/%{file.basename}.obj")
			buildcommands("ml64 /c /nologo /D_M_X64 /W3 /Zi /Fo \"%{cfg.objdir}/%{file.basename}.obj\" \"%{file.relpath}\"")

		filter({"files:" .. CRYPTOPP_DIRECTORY .. "/x64masm.asm", "system:windows", "platforms:x64", "configurations:Debug or Release"})
			buildmessage("Assembling %{file.relpath}")
			buildoutputs("%{cfg.objdir}/%{file.basename}.obj")
			buildcommands("ml64 /c /nologo /D_M_X64 /W3 /Zi /Fo \"%{cfg.objdir}/%{file.basename}.obj\" \"%{file.relpath}\"")
